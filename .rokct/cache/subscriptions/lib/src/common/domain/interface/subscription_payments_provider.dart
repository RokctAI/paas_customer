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

/// The slice of a payment method that the subscriptions purchase flow
/// actually uses: an id to attach transactions to and a tag to branch on
/// (e.g. "wallet", "cash", gateway names for the web-view flow).
class SubscriptionPaymentMethod {
  final int? id;
  final String? tag;

  const SubscriptionPaymentMethod({this.id, this.tag});

  /// Tolerant mapper for adapter implementations: missing/malformed fields
  /// resolve to null instead of throwing.
  factory SubscriptionPaymentMethod.fromJson(Map<String, dynamic> json) =>
      SubscriptionPaymentMethod(
        id: int.tryParse(json['id']?.toString() ?? ''),
        tag: json['tag']?.toString(),
      );
}

/// Consumer-owned slice of the payments surface that subscriptions_sdk
/// needs. subscriptions_sdk deliberately does NOT import payments_sdk (or
/// wallet_sdk): the host app that composes the SDKs implements this with a
/// small adapter wrapping its real payments facade and registers it by
/// overriding `paymentsRepositoryProvider`. See the commented example in
/// `src/di/subscriptions_di.dart`.
abstract class SubscriptionPaymentsProvider {
  /// Available payment methods for purchasing a subscription.
  Future<ApiResult<List<SubscriptionPaymentMethod>>> getPaymentMethods();

  /// Starts a gateway web-view payment for [subscriptionId] and returns the
  /// URL the app should open.
  ///
  /// [subscriptionId] is a String because plan rows on the composed backend
  /// are hash-named Frappe docnames (`SubscriptionData.ref`); legacy numeric
  /// ids are passed as their decimal string form.
  Future<ApiResult<String>> paymentSubscriptionWebView({
    required String name,
    required String subscriptionId,
  });
}
