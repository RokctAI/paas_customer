import 'package:flutter/material.dart';
import 'package:foodyman/domain/di/dependency_manager.dart';
import 'package:foodyman/domain/interface/payments.dart';
import 'package:foodyman/infrastructure/models/models.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/local_storage.dart';
import 'package:foodyman/domain/handlers/handlers.dart';
import '../models/data/saved_card.dart';


class PaymentsRepository implements PaymentsRepositoryFacade {

  @override
  Future<ApiResult<PaymentsResponse>> getPayments() async {
    try {
      final client = dioHttp.client(requireAuth: true);
      debugPrint('==> Getting payments');
      final response = await client.get(
        '/api/v1/method/paas.api.get_payment_gateways',
      );
      debugPrint('==> Payments response: ${response.data}');
      return ApiResult.success(
        data: PaymentsResponse.fromJson(response.data),
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
    required int orderId,
    required int paymentId,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/method/paas.api.create_transaction',
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
      final response = await client.get('/api/v1/method/paas.api.get_saved_cards');
      
      return ApiResult.success(
        data: (response.data['data'] as List)
            .map((e) => SavedCardModel.fromJson(e))
            .toList(),
      );
    } catch (e) {
      debugPrint('==> get saved cards failure: $e');
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
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
        '/api/v1/method/paas.api.tokenize_card',
        data: {
          'card_number': cardNumber,
          'card_holder': cardName,
          'expiry_date': expiryDate,
          'cvc': cvc,
        },
      );
      return ApiResult.success(data: response.data['data']['token']);
    } catch (e) {
      debugPrint('==> tokenize card failure: $e');
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<String>> tokenizeAfterPayment(
      String cardNumber,
      String cardName,
      String expiryDate,
      String cvc,
      [String? token, String? lastFour, String? cardType]
  ) async {
       // Backend actually handles saving if save_card=True.
       // But we have a specific endpoint save_payfast_card (or generic)
       // Let's use the tokenize_card endpoint which returns a token and saves it.
       return tokenizeCard(cardNumber: cardNumber, cardName: cardName, expiryDate: expiryDate, cvc: cvc);
  }

  @override
  Future<ApiResult<bool>> deleteCard(String cardId) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/v1/method/paas.api.delete_card',
        data: {'card_name': cardId},
      );
      return const ApiResult.success(data: true);
    } catch (e) {
        debugPrint('==> delete card failure: $e');
        return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<bool>> setDefaultCard(String cardId) async {
      // Logic typically involves local storage or backend flag?
      // Assuming backend for now or simple return if not needed.
      return const ApiResult.success(data: true);
  }
  
  @override
  Future<ApiResult<String>> processTokenPayment(OrderBodyData orderData, String token) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/v1/method/paas.api.process_token_payment',
        data: {'order_id': orderData.cartId, 'token': token},
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
        '/api/v1/method/paas.api.process_direct_card_payment',
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
