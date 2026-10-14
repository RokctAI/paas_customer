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


import 'package:base_sdk/base_sdk.dart' show AppHelpers, TrKeys;
import 'package:base_sdk/src/presentation/pages/profile/profile_action_item.dart';
import 'package:base_sdk/src/presentation/pages/profile/profile_section_registry.dart';
import 'package:flutter/material.dart';

import 'customer_plans_page.dart';
import 'package:remixicon/remixicon.dart';

/// The ProfileSectionRegistry action group the customer profile's plan row
/// (marketplace_sdk's header plan slot) reads its extra plan lines from.
/// The group key is the contract between the two SDKs; neither imports
/// the other.
const String customerPlanActionGroup = 'marketplace.plan';

/// Contributes the customer (marketplace) subscription to the profile's
/// existing plan row instead of a separate profile tile: one entry in the
/// [customerPlanActionGroup] group, whose [ProfileActionItem.badgeBuilder]
/// renders [CustomerSubscriptionPlanLine] (plan state + tap to
/// [CustomerPlansPage]). Called from this SDK's di_hook; the duplicate-id
/// rule (first wins) makes a second call harmless.
void registerLoyaltyProfileSections() {
  ProfileSectionRegistry.I.registerAction(
    group: customerPlanActionGroup,
    item: ProfileActionItem(
      id: 'loyalty.customer_subscription',
      icon: Remix.award_line,
      label: () => AppHelpers.getTranslation(TrKeys.subscriptionPlans),
      onTap: (context) => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => const CustomerPlansPage())),
      badgeBuilder: (context) => const CustomerSubscriptionPlanLine(),
    ),
  );
}
