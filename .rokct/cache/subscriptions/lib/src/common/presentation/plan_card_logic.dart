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

import 'package:base_sdk/base_sdk.dart' show TrKeys;

import '../infrastructure/models/data/subscriptions_data.dart';

/// One line of a plan card's INCLUDES list (approved section 40, chip 763):
/// the check-line text plus an optional mini-badge parsed out of the feature
/// string's embedded markup (e.g. the fixture-style
/// `<span class="...">White Label</span>` suffix).
class PlanIncludeLine {
  final String text;
  final String? badge;

  const PlanIncludeLine(this.text, {this.badge});

  @override
  bool operator ==(Object other) =>
      other is PlanIncludeLine && other.text == text && other.badge == badge;

  @override
  int get hashCode => Object.hash(text, badge);

  @override
  String toString() => 'PlanIncludeLine($text, badge: $badge)';
}

/// Pure decisions behind the approved manager subscriptions screens
/// (section 40, frames 40a/40b/40c) — kept out of the template widgets so
/// they stay testable (templates are excluded from analysis/compilation).
abstract final class PlanCardLogic {
  /// The CURRENT-PLAN GUARD (chip 768, Ray-approved 2026-08-30): whether
  /// [plan] is the plan the shop already holds, in which case its card
  /// renders a disabled "Current plan" state INSTEAD of a Purchase CTA — the
  /// shipped after-tap `youHaveSubscription` error snackbar re-dressed as a
  /// before-tap guard, so no accidental tap can start a charge for a plan
  /// the shop already pays for.
  ///
  /// [held] is the shop's stored subscription row
  /// (`ShopSubscriptionStore.shopSubscription()`): legacy rows nest the plan
  /// object, composed-backend rows carry the plan docname as a link string
  /// ([SubscriptionData.subscriptionRef]); both forms are matched, plus the
  /// legacy numeric `subscription_id`.
  static bool isCurrentPlan(SubscriptionData plan, SubscriptionData? held) {
    if (held == null) return false;
    final heldPlan = held.subscription;
    if (heldPlan != null) {
      if (plan.ref != null && heldPlan.ref == plan.ref) return true;
      if (plan.id != null && heldPlan.id == plan.id) return true;
      if (plan.title != null && heldPlan.title == plan.title) return true;
    }
    if (plan.ref != null && held.subscriptionRef == plan.ref) return true;
    if (plan.id != null && held.subscriptionId == plan.id) return true;
    return false;
  }

  /// The INCLUDES list ON the card face (chip 763 — retires the shipped
  /// "?" info dialog by re-homing its content): the row's `features` lines
  /// when the catalog serves them, else the legacy limit fields the shipped
  /// dialog used to show. Only fields the row actually carries produce
  /// lines — a bare tenant catalog row (price + month only) yields an empty
  /// list and the card simply shows no includes section. Nothing here is
  /// ever invented client-side.
  static List<PlanIncludeLine> includesFor(
    SubscriptionData plan, {
    required String Function(String key) translate,
  }) {
    final features = plan.features;
    if (features != null && features.isNotEmpty) {
      return features
          .map(parseFeatureLine)
          .where((line) => line.text.isNotEmpty || line.badge != null)
          .toList();
    }
    final lines = <PlanIncludeLine>[];
    if (plan.productLimit != null) {
      lines.add(
        PlanIncludeLine('${translate(TrKeys.product)}: ${plan.productLimit}'),
      );
    }
    if (plan.orderLimit != null) {
      lines.add(
        PlanIncludeLine('${translate(TrKeys.order)}: ${plan.orderLimit}'),
      );
    }
    if (plan.withReport ?? false) {
      lines.add(PlanIncludeLine(translate(TrKeys.withReport)));
    }
    return lines;
  }

  /// Parses one feature string into text + optional badge. The first
  /// `<span ...>badge</span>` becomes the mini-badge; every other markup tag
  /// is stripped so backend-authored lines can never inject layout.
  static PlanIncludeLine parseFeatureLine(String raw) {
    String? badge;
    final span =
        RegExp(r'<span[^>]*>(.*?)</span>', dotAll: true).firstMatch(raw);
    if (span != null) {
      final badgeText = _stripTags(span.group(1) ?? '').trim();
      if (badgeText.isNotEmpty) badge = badgeText;
    }
    var text = raw;
    if (span != null) text = text.replaceFirst(span.group(0)!, '');
    text = _stripTags(text).replaceAll(RegExp(r'\s+'), ' ').trim();
    return PlanIncludeLine(text, badge: badge);
  }

  static String _stripTags(String value) =>
      value.replaceAll(RegExp(r'<[^>]*>'), '');

  /// Client-side category slice of the tenant catalog (Ray 2026-08-30
  /// 13:26Z: "each home sdk might need to ask for category it needs"). The
  /// tenant `Subscription` doctype's `type` select (orders / products) is
  /// the category field `list_subscriptions` already returns, so a host
  /// surface can narrow to its own category without any backend change.
  ///
  /// Semantics mirror the Next.js frontend's existing plan filtering (Ray
  /// 13:33Z; `getSubscriptionPlans(category?)` → the backend's exact
  /// `filters["plan_category"] = category` equality): an optional string
  /// `category`, matched by EXACT equality against the row's category
  /// field. Null or empty keeps the full catalog. `list_subscriptions`
  /// takes no category kwarg today, so the slice happens client-side; a
  /// server-side parameter would need backend work and is deliberately NOT
  /// part of this wave.
  static List<SubscriptionData> filterByCategory(
    List<SubscriptionData> list,
    String? category,
  ) {
    if (category == null || category.isEmpty) return list;
    return list.where((plan) => plan.type == category).toList();
  }

  /// The plan's display name. The tenant `Subscription` doctype has no
  /// title field (only type / price / month), so a composed-backend row
  /// usually carries none: the card then reads "<Type> plan" (e.g. "Orders
  /// Plan") rather than the bare type name, which read like a category,
  /// not a plan. A row that does carry a title or content keeps it; a row
  /// with nothing at all reads just "Plan". Nothing is invented beyond
  /// what the row says.
  static String displayTitle(
    SubscriptionData plan, {
    required String Function(String key) translate,
  }) {
    final title = plan.title?.trim();
    if (title != null && title.isNotEmpty) return title;
    final content = plan.content?.trim();
    if (content != null && content.isNotEmpty) return content;
    final planWord = translate(TrKeys.plan);
    final type = plan.type?.trim();
    if (type == null || type.isEmpty) return planWord;
    return '${translate(type)} $planWord';
  }

  /// The billing-cycle wording next to a price ("per month" / "per year" /
  /// "per N months"), derived from the tenant catalog's real `month` field.
  /// Null when the row does not say — the card then shows the price alone
  /// rather than inventing a cycle.
  static String? cycleLabel(
    SubscriptionData plan, {
    required String Function(String key) translate,
  }) {
    final months = plan.month;
    if (months == null || months <= 0) return null;
    final per = translate('per').toLowerCase();
    if (months == 1) return '$per ${translate(TrKeys.month).toLowerCase()}';
    if (months == 12) return '$per ${translate('year').toLowerCase()}';
    return '$per $months ${translate('months').toLowerCase()}';
  }

  /// The trial-badge copy (chip 762), only when the row itself carries a
  /// positive `trial_period_days`. Null hides the badge.
  static String? trialLabel(
    SubscriptionData plan, {
    required String Function(String key) translate,
  }) {
    final days = plan.trialPeriodDays;
    if (days == null || days <= 0) return null;
    return '$days-${translate('day.free.trial').toLowerCase()}';
  }
}
