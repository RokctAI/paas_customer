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

import 'package:subscriptions_sdk/src/common/infrastructure/models/data/subscriptions_data.dart';

/// Typed view over the merchant shop's active subscription, read from the
/// kernel's untyped shop JSON ([LocalStorage.getShopJson]).
///
/// Replaces the retired core_sdk manager `LocalStorage.getShop()` surface
/// that the subscriptions template pages used to consume.
class ShopSubscriptionStore {
  ShopSubscriptionStore._();

  /// The shop's subscription wrapper (`shop.subscription`), or null when no
  /// shop is stored or it has no subscription.
  static SubscriptionData? shopSubscription() {
    final sub = LocalStorage.getShopJson()?['subscription'];
    if (sub is! Map<String, dynamic>) return null;
    return SubscriptionData.fromJson(sub);
  }
}
