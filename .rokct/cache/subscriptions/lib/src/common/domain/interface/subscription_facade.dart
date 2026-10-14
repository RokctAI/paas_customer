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


import 'package:base_sdk/base_sdk.dart';
import '../../infrastructure/models/response/subscriptions_response.dart';
import '../../infrastructure/models/response/transactions_response.dart';

abstract class SubscriptionsFacade {
  Future<ApiResult<SubscriptionResponse>> getSubscriptions({
    required int page,
    String? locale,
  });

  /// [ref] is the plan's Frappe document name on the composed backend
  /// (plan rows are hash-named, so the legacy numeric [id] is null for
  /// them); when present it identifies the plan on the wire, with [id] as
  /// the fallback for stored rows that still carry one.
  ///
  /// [beneficiaryUserId] enables delegated billing: purchase this
  /// subscription FOR another account (e.g. an accountability partner
  /// paying for a linked student — the subscription stays the student's,
  /// only who gets charged changes). Null (the default, and every
  /// pre-existing call) means the caller purchases for themselves. The
  /// backend authorizes the delegation — the client only carries the fact.
  Future<ApiResult> purchaseSubscription({
    required int id,
    required int paymentId,
    String? ref,
    String? beneficiaryUserId,
  });

  /// Legacy marketplace payment record. Not used by the purchase flow any
  /// more: the composed backend's purchase charges the wallet and
  /// activates in one call.
  ///
  /// [id] is whatever identifier [purchaseSubscription] returned — the
  /// legacy backend used an int, the composed backend a Frappe document
  /// name (String) — so it is deliberately untyped.
  @Deprecated('The purchase charges and activates in one call.')
  Future<ApiResult<SubscriptionTransactionsResponse>> createTransaction({
    required Object id,
    required int paymentId,
    String? beneficiaryUserId,
  });
}
