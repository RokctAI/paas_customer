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
import 'package:base_sdk/src/models/data/saved_card.dart';

class PaymentsRepository implements PaymentsRepositoryFacade {
  @override
  Future<ApiResult<PaymentsResponse>> getPayments() async {
    try {
      final client = dioHttp.client(requireAuth: true);
      debugPrint('==> Getting payments');
      final response = await client.get(
        '/api/method/paas.api.payment.get_payment_gateways',
      );
      debugPrint('==> Payments response: ${response.data}');
      return ApiResult.success(data: PaymentsResponse.fromJson(response.data));
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
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/method/paas.api.payment.create_transaction',
        data: {'order_id': orderId, 'payment_id': paymentId},
      );
      return ApiResult.success(
        data: TransactionsResponse.fromJson(response.data),
      );
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
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/method/paas.api.payment.get_saved_cards',
      );

      return ApiResult.success(
        data: (response.data['data'] as List)
            .map((e) => SavedCardModel.fromJson(e))
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

  // Implementing Card specific methods first
  @override
  Future<ApiResult<String>> tokenizeCard({
    required String cardNumber,
    required String cardName,
    required String expiryDate,
    required String cvc,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/method/paas.api.payment.tokenize_card',
        data: {
          'card_number': cardNumber,
          'card_holder': cardName,
          'expiry_date': expiryDate,
          'cvc': cvc,
        },
      );
      // The gateway reuse credential stays on the server. What comes
      // back is the Saved Card docname, which is what the charge
      // endpoints take.
      return ApiResult.success(data: response.data['data']['name']);
    } catch (e) {
      debugPrint('==> tokenize card failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
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
    // Backend actually handles saving if save_card=True.
    // But we have a specific endpoint save_payfast_card (or generic)
    // Let's use the tokenize_card endpoint, which saves the card and
    // returns its Saved Card docname. The gateway reuse credential stays
    // on the server and never reaches this client.
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
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/method/paas.api.payment.delete_card',
        data: {'card_name': cardId},
      );
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
    // Logic typically involves local storage or backend flag?
    // Assuming backend for now or simple return if not needed.
    return const ApiResult.success(data: true);
  }

  @override
  Future<ApiResult<String>> processTokenPayment(
    OrderBodyData orderData,
    String savedCardId,
  ) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      // `saved_card`, not `token`: the gateway reuse credential is
      // server-side only, so the card is named by its docname (the `name`
      // that get_saved_cards / tokenize_card return).
      await client.post(
        '/api/method/paas.api.payment.process_token_payment',
        data: {'order_id': orderData.cartId, 'saved_card': savedCardId},
      );
      return const ApiResult.success(data: "Success");
    } catch (e) {
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
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/method/paas.api.payment.process_direct_card_payment',
        data: {
          'order_id': orderBody.cartId,
          'card_number': cardNumber,
          'card_holder': cardName,
          'expiry_date': expiryDate,
          'cvc': cvc,
        },
      );
      return ApiResult.success(data: response.data['message']);
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }
}
