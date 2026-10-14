// Copyright (c) 2026 ROKCT INTELLIGENCE (PTY) LTD
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published
// by the Free Software Foundation, version 3.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.

import 'package:flutter/material.dart';
import 'package:base_sdk/src/di/injection.dart';
import 'package:base_sdk/src/domain/interface/payments.dart';
import 'package:base_sdk/src/models/models.dart';
import 'package:base_sdk/src/services/app_helpers.dart';
import 'package:base_sdk/src/handlers/handlers.dart';
import 'package:base_sdk/src/handlers/platform_gateway.dart';
import 'package:base_sdk/src/models/data/saved_card.dart';

class PaymentsRepository implements PaymentsRepositoryFacade {
  /// Universal platform gateway: every call POSTs `{"cmd", "payload"}` to
  /// the one gateway path. `cmd` is the wallet frappe manifest's
  /// whitelisted-method key with the app prefix stripped
  /// (`{app_name}.api.payment.*` -> `api.payment.*`).
  static const _gateway = PlatformGateway();

  /// FrappeResponseInterceptor already unwraps the top-level `message`
  /// envelope on 2xx; tolerate both shapes for overridden clients.
  static dynamic _unwrap(dynamic body) =>
      body is Map && body.containsKey('message') && body.length == 1
      ? body['message']
      : body;

  @override
  Future<ApiResult<PaymentsResponse>> getPayments() async {
    try {
      // get_payment_gateways returns a bare list of gateway rows.
      final data = _unwrap(
        await _gateway.tenant('api.payment.get_payment_gateways'),
      );
      return ApiResult.success(
        data: PaymentsResponse.fromJson(data is List ? {'data': data} : data),
      );
    } catch (e) {
      debugPrint('==> get payments failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<TransactionsResponse>> createTransaction({
    required String orderId,
    required String paymentId,
  }) async {
    try {
      // create_transaction returns {timestamp, status, message, data}.
      final data = await _gateway.tenant('api.payment.create_transaction', {
        'order_id': orderId,
        'payment_id': paymentId,
      });
      return ApiResult.success(data: TransactionsResponse.fromJson(data));
    } catch (e) {
      debugPrint('==> create transaction failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<List<SavedCardModel>>> getSavedCards() async {
    try {
      // get_saved_cards returns a bare list of Saved Card rows
      // (name/gateway/last_four/card_type/expiry_date/card_holder_name/
      // is_default), the default card first.
      final data = _unwrap(await _gateway.tenant('api.payment.get_saved_cards'));
      final rows = data is List ? data : const [];
      return ApiResult.success(
        data: rows
            .whereType<Map>()
            .map(
              (e) => SavedCardModel(
                id: (e['id'] ?? e['name'])?.toString() ?? '',
                lastFour: e['last_four']?.toString() ?? '',
                cardType: e['card_type']?.toString() ?? 'Card',
                expiryDate: e['expiry_date']?.toString() ?? '',
                cardHolderName: e['card_holder_name']?.toString() ?? '',
                isDefault: e['is_default'] == true || e['is_default'] == 1,
              ),
            )
            .toList(),
      );
    } catch (e) {
      debugPrint('==> get saved cards failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  // Saving a card from typed-in details is refused without a request: no
  // gateway tokenizes raw card details on the backend (its tokenize_card
  // refuses too), so sending the card number and CVC would only put them
  // on the wire for nothing. A card is saved by paying through a gateway
  // checkout.
  @override
  Future<ApiResult<String>> tokenizeCard({
    required String cardNumber,
    required String cardName,
    required String expiryDate,
    required String cvc,
  }) async {
    return const ApiResult.failure(
      error: 'Saving a card from typed-in details is not available. '
          'Pay with a gateway checkout to save a card.',
      // 501 Not Implemented: nothing was sent, nothing was stored.
      statusCode: 501,
    );
  }

  @override
  Future<ApiResult<String>> tokenizeAfterPayment(
    String cardNumber,
    String cardName,
    String expiryDate,
    String cvc, [
    String? token,
    String? lastFour,
    String? cardType,
  ]) async {
    // A gateway's reusable credential is saved server-side from the
    // gateway's own confirmation (save_gateway_card), never from what a
    // client reports. This path used to hand the details to tokenize_card,
    // which dropped [token] and saved a random stand-in; it now gets the
    // same honest refusal as [tokenizeCard].
    return tokenizeCard(
      cardNumber: cardNumber,
      cardName: cardName,
      expiryDate: expiryDate,
      cvc: cvc,
    );
  }

  @override
  Future<ApiResult<bool>> deleteCard(String cardId) async {
    try {
      await _gateway.tenant('api.payment.delete_card', {'card_name': cardId});
      return const ApiResult.success(data: true);
    } catch (e) {
      debugPrint('==> delete card failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<bool>> setDefaultCard(String cardId) async {
    try {
      // set_default_card marks this card the user's one default and clears
      // the flag on their other cards.
      final data = _unwrap(
        await _gateway.tenant('api.payment.set_default_card', {
          'card_name': cardId,
        }),
      );
      return ApiResult.success(
        data: data is Map && data['status'] == 'success',
      );
    } catch (e) {
      debugPrint('==> set default card failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  /// The card endpoints charge an existing Order (they check ownership and
  /// read its total), but checkout hands this SDK the cart body. Create the
  /// order first and return its id.
  Future<String> _createOrderId(OrderBodyData orderData) async {
    final result = await ordersRepository.createOrder(orderData);
    String? orderId;
    String? error;
    result.when(
      success: (order) => orderId = order.id,
      failure: (e, _) => error = e,
    );
    if (orderId == null || orderId!.isEmpty) {
      throw StateError(error ?? 'Order could not be created');
    }
    return orderId!;
  }

  static String _transactionId(dynamic body, String fallback) {
    final data = _unwrap(body);
    if (data is Map && data['transaction_id'] != null) {
      return data['transaction_id'].toString();
    }
    return fallback;
  }

  @override
  Future<ApiResult<String>> processTokenPayment(
    OrderBodyData orderData,
    String savedCardId,
  ) async {
    try {
      final orderId = await _createOrderId(orderData);
      // `saved_card`, not `token`: the gateway reuse credential is
      // server-side only, so the card is named by its docname.
      final body = await _gateway.tenant('api.payment.process_token_payment', {
        'order_id': orderId,
        'saved_card': savedCardId,
      });
      return ApiResult.success(data: _transactionId(body, orderId));
    } catch (e) {
      debugPrint('==> token payment failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<String>> processDirectCardPayment(
    OrderBodyData orderBody,
    String cardNumber,
    String cardName,
    String expiryDate,
    String cvc,
  ) async {
    try {
      final orderId = await _createOrderId(orderBody);
      final body = await _gateway
          .tenant('api.payment.process_direct_card_payment', {
            'order_id': orderId,
            'card_number': cardNumber,
            'card_holder': cardName,
            'expiry_date': expiryDate,
            'cvc': cvc,
          });
      return ApiResult.success(data: _transactionId(body, orderId));
    } catch (e) {
      debugPrint('==> direct card payment failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }
}
