// Copyright (c) 2026 ROKCT INTELLIGENCE (PTY) LTD
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

// Copyright (c) 2024 ROKCT INTELLIGENCE (PTY) LTD
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

import 'package:flutter/material.dart';
import 'package:base_sdk/src/handlers/handlers.dart';
import 'package:base_sdk/src/handlers/platform_gateway.dart';
import 'package:base_sdk/src/domain/interface/wallet.dart';
import 'package:base_sdk/src/di/injection.dart';
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

  @override
  Future<ApiResult<List<WalletHistoryData>>> getWalletHistory() async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/method/paas.api.user.get_wallet_history',
      );

      return ApiResult.success(
        data: (response.data['data'] as List)
            .map((e) => WalletHistoryData.fromJson(e))
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
      final body = await _gateway.tenant('api.payment.process_wallet_top_up', {
        'amount': amount,
        if (token != null) 'token': token,
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
