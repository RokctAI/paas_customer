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
import 'package:base_sdk/src/handlers/handlers.dart';
import 'package:base_sdk/src/handlers/platform_gateway.dart';
import 'package:base_sdk/src/domain/interface/wallet.dart';
import 'package:base_sdk/src/services/app_helpers.dart';

import 'package:base_sdk/src/models/data/wallet_data.dart';
import 'package:base_sdk/src/models/data/wallet_transfer_data.dart';
import 'package:base_sdk/src/models/models.dart';

class WalletRepository implements WalletRepositoryFacade {
  /// Universal platform gateway (project ruling: every client-facing call
  /// POSTs `{"cmd", "payload"}` to the one gateway path). `cmd` is the
  /// wallet frappe manifest's whitelisted-method key with the app prefix
  /// stripped: `{app_name}.api.payment.*` -> `api.payment.*`,
  /// `{app_name}.api.transfer.*` -> `api.transfer.*`.
  static const _gateway = PlatformGateway();

  /// FrappeResponseInterceptor already unwraps the top-level `message`
  /// envelope on 2xx; tolerate both shapes for overridden clients (same
  /// convention as [walletTopUp]).
  static Map<String, dynamic> _asMap(dynamic body) {
    final data =
        body is Map && body.containsKey('message') ? body['message'] : body;
    return data is Map ? Map<String, dynamic>.from(data) : <String, dynamic>{};
  }

  @override
  Future<ApiResult<WalletRecipientData>> confirmRecipient({
    required String phone,
  }) async {
    try {
      // Manifest key: {app_name}.api.transfer.confirm_recipient. Exact
      // full-phone match; the backend answers with ONLY that one user's
      // name fields (anti-enumeration contract — no list, no email).
      final body = await _gateway.tenant('api.transfer.confirm_recipient', {
        'phone': phone,
      });
      return ApiResult.success(
        data: WalletRecipientData.fromJson(_asMap(body)),
      );
    } catch (e) {
      debugPrint('==> confirm recipient failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<WalletReceiveClaimData>> generateReceiveClaim({
    required double amount,
  }) async {
    try {
      // Manifest key: {app_name}.api.transfer.generate_receive_claim.
      // Mints a 6-digit code linked to the logged-in receiver + amount;
      // the receiver hands it to the sender out-of-band.
      final body =
          await _gateway.tenant('api.transfer.generate_receive_claim', {
        'amount': amount,
      });
      return ApiResult.success(
        data: WalletReceiveClaimData.fromJson(_asMap(body)),
      );
    } catch (e) {
      debugPrint('==> generate receive claim failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<bool>> cancelReceiveClaim({required String code}) async {
    try {
      // Manifest key: {app_name}.api.transfer.cancel_receive_claim. Only
      // the claim's own receiver may cancel.
      final body =
          await _gateway.tenant('api.transfer.cancel_receive_claim', {
        'code': code,
      });
      return ApiResult.success(data: _asMap(body)['cancelled'] == true);
    } catch (e) {
      debugPrint('==> cancel receive claim failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<WalletTransferData>> sendWalletToPhone({
    required String phone,
    required double amount,
  }) async {
    try {
      // Manifest key: {app_name}.api.transfer.send_wallet_balance (phone
      // mode). The sender is always the session user server-side; the
      // backend enforces a strictly positive amount and an atomic
      // debit+credit.
      final body = await _gateway.tenant('api.transfer.send_wallet_balance', {
        'phone': phone,
        'amount': amount,
      });
      return ApiResult.success(
        data: WalletTransferData.fromJson(_asMap(body)),
      );
    } catch (e) {
      debugPrint('==> send wallet to phone failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<WalletTransferData>> sendWalletByCode({
    required String code,
  }) async {
    try {
      // Manifest key: {app_name}.api.transfer.send_wallet_balance (code
      // mode). The claim fixes both receiver and exact amount; the code is
      // consumed single-use in the same transaction as the transfer.
      final body = await _gateway.tenant('api.transfer.send_wallet_balance', {
        'code': code,
      });
      return ApiResult.success(
        data: WalletTransferData.fromJson(_asMap(body)),
      );
    } catch (e) {
      debugPrint('==> send wallet by code failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  /// Pages the logged-in user's `Wallet History` rows, newest first.
  ///
  /// [start] / [limit] are the server's own kwargs (`start=0, limit=20`
  /// defaults); the base_sdk facade signature has neither, so they are
  /// optional here and facade callers get the first page.
  @override
  Future<ApiResult<List<WalletHistoryData>>> getWalletHistory({
    int start = 0,
    int limit = 20,
  }) async {
    try {
      // Manifest key: {app_name}.api.user.get_wallet_history (whitelisted
      // by the users frappe half, users.tenant.api.user.get_wallet_history).
      // Replaces the legacy per-method GET
      // `/api/method/paas.api.user.get_wallet_history`, which no composed
      // backend serves (fix-wave 2026-09-02, P1).
      final body = await _gateway.tenant('api.user.get_wallet_history', {
        'start': start,
        'limit': limit,
      });
      // The server answers api_response(data=rows) -> {data: [...],
      // status_code: 200} inside Frappe's `message` envelope; the
      // interceptor strips the envelope and _asMap tolerates a client
      // that did not. A bare list is accepted too.
      final data = body is List ? body : _asMap(body)['data'];
      final rows = data is List ? data : const [];
      return ApiResult.success(
        data: rows
            .map((e) => WalletHistoryData.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
      );
    } catch (e) {
      debugPrint('==> get wallet history failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<dynamic>> walletTopUp({
    required double amount,
    String? token,
  }) async {
    try {
      // Manifest key: {app_name}.api.payment.process_wallet_top_up.
      // The `token` parameter name is fixed by the base_sdk interface this
      // overrides; what travels is the Saved Card docname on `saved_card`.
      // The gateway reuse credential is server-side only and this client
      // never sees it.
      final body = await _gateway.tenant('api.payment.process_wallet_top_up', {
        'amount': amount,
        if (token != null) 'saved_card': token,
      });
      // FrappeResponseInterceptor already unwraps the top-level `message`
      // envelope on 2xx; tolerate both shapes for overridden clients. A
      // String answer is a redirect URL (gateway-hosted card capture); a
      // map is the completed transaction.
      final data = body is Map && body.containsKey('message')
          ? body['message']
          : body;
      if (data is String) {
        return ApiResult.success(data: data);
      }
      if (data is Map) {
        return ApiResult.success(
          data: TransactionsResponse.fromJson(Map<String, dynamic>.from(data)),
        );
      }
      return ApiResult.success(data: data);
    } catch (e) {
      debugPrint('==> wallet top up failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }
}
