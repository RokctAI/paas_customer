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
import 'package:base_sdk/src/services/local_storage.dart';

import 'package:base_sdk/src/models/data/wallet_data.dart';
import 'package:base_sdk/src/models/models.dart';

class WalletRepository implements WalletRepositoryFacade {
  /// Universal platform gateway (project ruling: every client-facing call
  /// POSTs `{"cmd", "payload"}` to the one gateway path). `cmd` is the
  /// wallet frappe manifest's whitelisted-method key with the app prefix
  /// stripped: `{app_name}.api.payment.*` -> `api.payment.*`.
  static const _gateway = PlatformGateway();

  @override
  Future<ApiResult<List<UserModel>>> searchSending(
    Map<String, dynamic> params,
  ) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/method/paas.api.user.search_user',
        data: {
          'name': params['search'] ?? params['name'] ?? '',
          'page': params['page'] ?? 1,
          'lang': LocalStorage.getLanguage()?.locale,
        },
      );

      // search_user returns api_response(data=[{name, full_name, user_image}])
      // wrapped in Frappe's top-level `message` key, which
      // FrappeResponseInterceptor already unwraps — so response.data here is
      // {data: [...], status_code: 200}. The backend only returns name,
      // full_name and user_image; `name` (the Frappe User id) is the
      // identifier the send-wallet-balance flow needs, so it fills both id
      // and uuid, and full_name is surfaced as the display name.
      return ApiResult.success(
        data: (response.data['data'] as List)
            .map(
              (e) => UserModel(
                id: e['name']?.toString(),
                uuid: e['name']?.toString(),
                firstname: e['full_name']?.toString(),
                img: e['user_image']?.toString(),
              ),
            )
            .toList(),
      );
    } catch (e) {
      debugPrint('==> search sending failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<WalletHistoryData>> sendWalletBalance(
    String userUuid,
    double amount,
  ) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/method/paas.api.user.send_wallet_balance',
        data: {'receiver': userUuid, 'amount': amount},
      );

      return ApiResult.success(
        data: WalletHistoryData.fromJson(response.data['data']),
      );
    } catch (e) {
      debugPrint('==> send wallet balance failure: $e');
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
