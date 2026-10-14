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
import 'package:base_sdk/src/models/data/saved_card.dart';
import 'package:flutter/foundation.dart';

import 'customer_subscription_models.dart';

/// The customer side of commerce customer subscriptions. Payment and
/// auto-renewal run on the server through subscriptions_sdk's shared
/// recurring engine (the one LMS learner renewals use); this client only
/// picks the plan and how to pay.
abstract class CustomerSubscriptions {
  Future<List<CustomerPlan>> plans();

  /// The caller's current subscription (Active, Past Due or Pending), or
  /// null. Throws when the server can't be reached.
  Future<CustomerSubscription?> mine();

  /// Subscribes and takes the first payment. The answer carries
  /// `paymentError` when the payment did not go through (it stays Pending).
  Future<CustomerSubscription> subscribe(
    String planId, {
    required CustomerSubscriptionPayment payment,
    String? savedCardId,
  });

  Future<CustomerSubscription> cancel();
  Future<CustomerSubscription> resume();
  Future<CustomerSubscription> changePayment(
    CustomerSubscriptionPayment payment, {
    String? savedCardId,
  });
  Future<CustomerSubscription> payNow();

  Future<List<SavedCardModel>> savedCards();
  Future<double?> walletBalance();
}

class HttpCustomerSubscriptions implements CustomerSubscriptions {
  static const _gateway = PlatformGateway();
  static const _api = 'api.customer_subscription';

  const HttpCustomerSubscriptions();

  Future<dynamic> _call(String cmd, [Map<String, dynamic>? data]) async {
    final body = await _gateway.tenant(cmd, data ?? const {});
    return body is Map && body.containsKey('message') ? body['message'] : body;
  }

  CustomerSubscription _sub(dynamic m) =>
      CustomerSubscription.fromJson(Map<String, dynamic>.from(m as Map));

  Map<String, dynamic> _method(
          CustomerSubscriptionPayment payment, String? savedCardId) =>
      {
        'payment_method': payment.wire,
        if (payment == CustomerSubscriptionPayment.card && savedCardId != null)
          'saved_card': savedCardId,
      };

  @override
  Future<List<CustomerPlan>> plans() async {
    final m = await _call('$_api.get_customer_subscription_plans_public');
    return [
      for (final p in (m is List ? m : const []))
        if (p is Map) CustomerPlan.fromJson(Map<String, dynamic>.from(p)),
    ];
  }

  @override
  Future<CustomerSubscription?> mine() async {
    final m = await _call('$_api.get_my_customer_subscription');
    return m is Map ? _sub(m) : null;
  }

  @override
  Future<CustomerSubscription> subscribe(
    String planId, {
    required CustomerSubscriptionPayment payment,
    String? savedCardId,
  }) async =>
      _sub(await _call('$_api.subscribe_customer_subscription',
          {'plan': planId, ..._method(payment, savedCardId)}));

  @override
  Future<CustomerSubscription> cancel() async =>
      _sub(await _call('$_api.cancel_customer_subscription'));

  @override
  Future<CustomerSubscription> resume() async =>
      _sub(await _call('$_api.resume_customer_subscription'));

  @override
  Future<CustomerSubscription> changePayment(
    CustomerSubscriptionPayment payment, {
    String? savedCardId,
  }) async =>
      _sub(await _call('$_api.update_customer_subscription_payment',
          _method(payment, savedCardId)));

  @override
  Future<CustomerSubscription> payNow() async =>
      _sub(await _call('$_api.pay_customer_subscription_now'));

  @override
  Future<List<SavedCardModel>> savedCards() async {
    try {
      final m = await _call('api.payment.get_saved_cards');
      return [
        for (final c in (m is List ? m : const []))
          if (c is Map) SavedCardModel.fromJson(Map<String, dynamic>.from(c)),
      ];
    } catch (e) {
      debugPrint('==> saved cards failed: $e');
      return const [];
    }
  }

  @override
  Future<double?> walletBalance() async {
    try {
      final m = await _call('api.payment.get_wallet_balance');
      return m is Map ? double.tryParse('${m['balance']}') : null;
    } catch (e) {
      debugPrint('==> wallet balance failed: $e');
      return null;
    }
  }
}
