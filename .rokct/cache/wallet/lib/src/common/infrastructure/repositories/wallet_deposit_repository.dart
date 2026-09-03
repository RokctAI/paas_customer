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

import 'package:flutter/foundation.dart';

import 'package:base_sdk/src/handlers/handlers.dart';
import 'package:base_sdk/src/handlers/platform_gateway.dart';
import 'package:base_sdk/src/services/app_helpers.dart';

import 'package:wallet_sdk/src/common/domain/interface/wallet_deposit.dart';
import 'package:wallet_sdk/src/common/infrastructure/models/data/wallet_deposit_data.dart';

/// The deposit calls, on wallet's `api.wallet.*` defs — design strip frames
/// 49g/49h/49i.
///
/// Same shape as [WalletRepository]: every call is a POST to the one
/// platform gateway path carrying `{cmd, payload}`, where `cmd` is this
/// SDK's frappe manifest whitelisted-method key with the app segment
/// dropped (`{app_name}.api.wallet.*` -> `api.wallet.*`). The slip itself
/// is NOT uploaded here: file bytes cannot ride the JSON envelope, so the
/// caller uploads it through the fleet's multipart gallery seam first and
/// hands the resulting URL to [submitDepositRequest].
class WalletDepositRepository implements WalletDepositRepositoryFacade {
  static const _cmd = 'api.wallet';
  static const _gateway = PlatformGateway();

  @override
  Future<ApiResult<WalletDepositDestination>> getDepositDestination() async {
    try {
      // Manifest key: {app_name}.api.wallet.get_deposit_destination. No
      // arguments; answers the Wallet Deposit Settings Single in full.
      final body = await _gateway.tenant('$_cmd.get_deposit_destination');
      return ApiResult.success(data: WalletDepositDestination.fromJson(body));
    } catch (e) {
      debugPrint('==> get deposit destination failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<WalletDepositSubmitResponse>> submitDepositRequest({
    required double amount,
    required String slipUrl,
    String method = WalletDepositMethod.bankDeposit,
    String? reference,
    String? note,
  }) async {
    try {
      // Manifest key: {app_name}.api.wallet.submit_deposit_request —
      // `submit_deposit_request(amount, method, reference=None, slip=None,
      // note=None)`. Nothing moves in the wallet on this call.
      final trimmedReference = (reference ?? '').trim();
      final trimmedNote = (note ?? '').trim();
      final body = await _gateway.tenant('$_cmd.submit_deposit_request', {
        'amount': amount,
        'method': method,
        'slip': slipUrl,
        if (trimmedReference.isNotEmpty) 'reference': trimmedReference,
        if (trimmedNote.isNotEmpty) 'note': trimmedNote,
      });
      return ApiResult.success(
        data: WalletDepositSubmitResponse.fromJson(body),
      );
    } catch (e) {
      debugPrint('==> submit deposit request failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<List<WalletDepositRecord>>> listDepositRequests() async {
    try {
      // Manifest key: {app_name}.api.wallet.list_deposit_requests. Bare
      // list, newest first, capped at 100 server-side.
      final body = await _gateway.tenant('$_cmd.list_deposit_requests');
      return ApiResult.success(data: WalletDepositRecord.listFrom(body));
    } catch (e) {
      debugPrint('==> list deposit requests failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<List<WalletDepositRecord>>>
      listPendingDepositRequests() async {
    try {
      // Manifest key: {app_name}.api.wallet.list_pending_deposit_requests.
      // Approver roles only; a payer gets a PermissionError.
      final body = await _gateway.tenant('$_cmd.list_pending_deposit_requests');
      return ApiResult.success(data: WalletDepositRecord.listFrom(body));
    } catch (e) {
      debugPrint('==> list pending deposit requests failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<WalletDepositResolution>> approveDepositRequest(
    String requestId,
  ) async {
    try {
      // Manifest key: {app_name}.api.wallet.approve_deposit_request.
      final body = await _gateway.tenant('$_cmd.approve_deposit_request', {
        'request_id': requestId,
      });
      return ApiResult.success(data: WalletDepositResolution.fromJson(body));
    } catch (e) {
      debugPrint('==> approve deposit request failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<WalletDepositResolution>> rejectDepositRequest(
    String requestId, {
    required String reason,
  }) async {
    try {
      // Manifest key: {app_name}.api.wallet.reject_deposit_request. The
      // server refuses a blank reason; it is trimmed but never invented.
      final body = await _gateway.tenant('$_cmd.reject_deposit_request', {
        'request_id': requestId,
        'reason': reason.trim(),
      });
      return ApiResult.success(data: WalletDepositResolution.fromJson(body));
    } catch (e) {
      debugPrint('==> reject deposit request failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }
}
