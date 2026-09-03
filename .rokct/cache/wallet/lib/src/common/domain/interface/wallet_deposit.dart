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

import 'package:base_sdk/src/handlers/handlers.dart';

import 'package:wallet_sdk/src/common/infrastructure/models/data/wallet_deposit_data.dart';

/// Wallet deposits over the platform gateway (`api.wallet.*` cmds) —
/// design strip frames 49g/49h/49i, the bank-deposit route that tops a
/// negative driver wallet back up.
///
/// The money model, which every caller must honour on screen:
///
///  * [submitDepositRequest] moves NOTHING. The balance stays exactly where
///    it was until a person has matched the slip against the bank
///    statement; a client that optimistically subtracts the pending deposit
///    is lying to the payer.
///  * [listDepositRequests] is the control that prevents a double deposit:
///    under review, approved, rejected with the reason in words.
///  * The approver's calls are role-gated server-side
///    (`DEPOSIT_APPROVER_ROLES`) and refuse a payer's own request.
///
/// Card top-ups never come here — they credit instantly through
/// `WalletRepositoryFacade.walletTopUp`.
abstract class WalletDepositRepositoryFacade {
  /// The tenant's pay-in account (chip 975) and whether bank deposits are
  /// being accepted at all.
  Future<ApiResult<WalletDepositDestination>> getDepositDestination();

  /// Send a paid-in deposit for approval: how much, which [reference] (the
  /// server generates one when null), the already-uploaded [slipUrl].
  Future<ApiResult<WalletDepositSubmitResponse>> submitDepositRequest({
    required double amount,
    required String slipUrl,
    String method = WalletDepositMethod.bankDeposit,
    String? reference,
    String? note,
  });

  /// The signed-in user's own deposit requests, newest first.
  Future<ApiResult<List<WalletDepositRecord>>> listDepositRequests();

  /// Every Pending request across users, oldest first, with the payer's
  /// name. Approver roles only.
  Future<ApiResult<List<WalletDepositRecord>>> listPendingDepositRequests();

  /// Approve one Pending request: the wallet is credited once, server-side.
  Future<ApiResult<WalletDepositResolution>> approveDepositRequest(
    String requestId,
  );

  /// Reject one Pending request WITH a reason — refused without one.
  Future<ApiResult<WalletDepositResolution>> rejectDepositRequest(
    String requestId, {
    required String reason,
  });
}
