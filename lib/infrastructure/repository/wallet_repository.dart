// Copyright (c) 2024 RokctAI
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
import 'package:foodyman/domain/handlers/handlers.dart';
import 'package:foodyman/domain/interface/wallet.dart';
import 'package:foodyman/domain/di/dependency_manager.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/local_storage.dart';

import '../models/data/user.dart';
import '../models/data/user.dart';
import '../models/data/wallet_data.dart';
import '../models/models.dart';

class WalletRepository implements WalletRepositoryFacade {
  @override
  Future<ApiResult<List<UserModel>>> searchSending(Map<String, dynamic> params) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/method/paas.api.user.user.search_users',
        queryParameters: {
          ...params,
          'lang': LocalStorage.getLanguage()?.locale,
        },
      );

      return ApiResult.success(
        data: (response.data['data'] as List)
            .map((e) => UserModel.fromJson(e))
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
        '/api/method/paas.api.user.user.send_wallet_balance',
        data: {
          'receiver': userUuid,
          'amount': amount,
        },
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
      final response = await client.get('/api/method/paas.api.user.user.get_wallet_history');

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
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/method/paas.api.payment.payment.process_wallet_top_up',
        data: {
             'amount': amount,
             'token': token
        },
      );
      // Return message (URL) or data (Transaction) depending on backend response.
      // Assuming backend returns 'message' string for URL and 'data' obj for transaction.
      if (response.data['message'] is String) {
          return ApiResult.success(data: response.data['message']);
      } else {
          return ApiResult.success(
            data: TransactionsResponse.fromJson(response.data),
          );
      }
    } catch (e) {
      debugPrint('==> wallet top up failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }
}
