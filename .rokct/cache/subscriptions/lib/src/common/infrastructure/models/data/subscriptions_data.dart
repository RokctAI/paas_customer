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


import 'dart:convert';

class SubscriptionData {
  int? id;

  /// Frappe document name identifying this row on the composed backend
  /// (`paas.api.subscription.*`). Plan rows there are hash-named, so the
  /// legacy numeric [id] is null for them and this is the purchase key.
  String? ref;
  String? type;
  num? price;
  int? month;
  bool? active;
  String? title;
  String? content;
  int? productLimit;
  int? orderLimit;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? withReport;
  int? shopId;
  int? subscriptionId;
  DateTime? expiredAt;
  SubscriptionData? subscription;

  /// On a Shop Subscription row served by the composed backend the
  /// `subscription` field is a LINK STRING — the held plan's Frappe docname
  /// — rather than a nestable object. It is kept here so the plan cards can
  /// tell which catalog row the shop already holds (the current-plan guard)
  /// without inventing a nested object the API never sent.
  String? subscriptionRef;

  /// Free-trial length in days, when the catalog row carries one
  /// (`trial_period_days`). Null means the API did not send the field — the
  /// tenant `Subscription` doctype has no trial column today, so this stays
  /// null there and the trial badge simply never renders.
  int? trialPeriodDays;

  /// The plan's advertised feature lines, when the catalog row carries them
  /// (`features`). Null means the field was not sent; the plan card then
  /// falls back to the legacy limit fields (product/order limits, report)
  /// for its includes list.
  List<String>? features;

  /// Subject slugs unlocked by this plan (e.g. maths, science).
  /// Null means the API did not send the field; an empty list means the
  /// plan explicitly has no subjects.
  List<String>? allowedSubjects;

  /// Delegated billing: the account charged for this subscription when it
  /// is NOT the subscriber themselves (e.g. an accountability partner
  /// paying for a linked student). Null means the subscriber pays — the
  /// default, and what every pre-existing subscription means.
  String? payer;

  // ---- Holiday Programme plan flags (business doc §2, holiday brief) ----
  // The three-way access model is deliberately PER-PLAN FLAGS, not a tier
  // hierarchy: no tier structure exists anywhere (the business doc defines
  // one plan), so plans carry their own entitlements and future tiers are
  // just plan rows that set these. Null on all three means the API did not
  // send them — which is what every pre-existing plan row means.

  /// This plan includes Holiday Programme access at no extra charge
  /// (the "highest tier bundles it" case).
  bool? bundlesHoliday;

  /// Non-null: subscribers on this plan may buy Holiday Programme access
  /// as a paid add-on at this price. Null: no add-on offered.
  num? holidayAddOnPrice;

  /// This plan row IS the standalone Holiday Programme product —
  /// purchasable with no regular subscription at all (the top-of-funnel
  /// acquisition case).
  bool? holidayStandalone;

  /// This plan includes personalized weak-topic catch-up content during
  /// mid-year holiday programmes (vs. generic term revision).
  bool? personalizedCatchUp;

  SubscriptionData({
    this.id,
    this.ref,
    this.type,
    this.price,
    this.month,
    this.active,
    this.title,
    this.content,
    this.productLimit,
    this.orderLimit,
    this.createdAt,
    this.updatedAt,
    this.withReport,
    this.shopId,
    this.subscriptionId,
    this.expiredAt,
    this.subscription,
    this.subscriptionRef,
    this.trialPeriodDays,
    this.features,
    this.allowedSubjects,
    this.payer,
    this.bundlesHoliday,
    this.holidayAddOnPrice,
    this.holidayStandalone,
    this.personalizedCatchUp,
  });

  /// Accepts a JSON list, a JSON-encoded string, or null — anything else
  /// (malformed payloads included) resolves to null rather than throwing.
  static List<String>? parseAllowedSubjects(dynamic raw) {
    if (raw == null) return null;
    dynamic value = raw;
    if (value is String) {
      if (value.trim().isEmpty) return null;
      try {
        value = jsonDecode(value);
      } catch (_) {
        return null;
      }
    }
    if (value is List) {
      return value
          .where((e) => e != null)
          .map((e) => e.toString())
          .toList();
    }
    return null;
  }

  /// Lenient boolean parse matching how `active`/`with_report` arrive
  /// (1 / true / "1" / "true"). Null stays null — "field not sent".
  static bool? parseFlag(dynamic raw) {
    if (raw == null) return null;
    return raw == 1 ||
        raw == true ||
        raw == "1" ||
        raw.toString().toLowerCase() == "true";
  }

  SubscriptionData copyWith({
    int? id,
    String? ref,
    String? type,
    num? price,
    int? month,
    bool? active,
    String? title,
    String? content,
    int? productLimit,
    int? orderLimit,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? withReport,
    int? shopId,
    int? subscriptionId,
    DateTime? expiredAt,
    SubscriptionData? subscription,
    String? subscriptionRef,
    int? trialPeriodDays,
    List<String>? features,
    List<String>? allowedSubjects,
    String? payer,
    bool? bundlesHoliday,
    num? holidayAddOnPrice,
    bool? holidayStandalone,
    bool? personalizedCatchUp,
  }) => SubscriptionData(
    id: id ?? this.id,
    ref: ref ?? this.ref,
    type: type ?? this.type,
    price: price ?? this.price,
    month: month ?? this.month,
    active: active ?? this.active,
    title: title ?? this.title,
    content: content ?? this.content,
    productLimit: productLimit ?? this.productLimit,
    orderLimit: orderLimit ?? this.orderLimit,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    withReport: withReport ?? this.withReport,
    shopId: shopId ?? this.shopId,
    expiredAt: expiredAt ?? this.expiredAt,
    subscription: subscription ?? this.subscription,
    subscriptionId: subscriptionId ?? this.subscriptionId,
    subscriptionRef: subscriptionRef ?? this.subscriptionRef,
    trialPeriodDays: trialPeriodDays ?? this.trialPeriodDays,
    features: features ?? this.features,
    allowedSubjects: allowedSubjects ?? this.allowedSubjects,
    payer: payer ?? this.payer,
    bundlesHoliday: bundlesHoliday ?? this.bundlesHoliday,
    holidayAddOnPrice: holidayAddOnPrice ?? this.holidayAddOnPrice,
    holidayStandalone: holidayStandalone ?? this.holidayStandalone,
    personalizedCatchUp: personalizedCatchUp ?? this.personalizedCatchUp,
  );

  factory SubscriptionData.fromJson(Map<String, dynamic> json) =>
      SubscriptionData(
        id: json["id"],
        // Round-trips as "ref"; live Frappe rows carry it as "name".
        ref: (json["ref"] ?? json["name"])?.toString(),
        type: json["type"],
        price: json["price"],
        month: json["month"],
        active:
            json["active"] == 1 ||
            json["active"] == true ||
            json["active"] == "1" ||
            json["active"]?.toString().toLowerCase() == "true",
        title: json["title"],
        content: json["content"],
        productLimit: json["product_limit"],
        orderLimit: json["order_limit"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.tryParse(json["created_at"])?.toLocal(),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.tryParse(json["updated_at"])?.toLocal(),
        expiredAt: json["expired_at"] == null
            ? null
            : DateTime.tryParse(json["expired_at"]),
        withReport:
            json["with_report"] == 1 ||
            json["with_report"] == true ||
            json["with_report"] == "1" ||
            json["with_report"]?.toString().toLowerCase() == "true",
        shopId: json["shop_id"],
        // Nested plan object in the legacy shape; on Frappe Shop
        // Subscription rows the field is a link STRING (the plan's name),
        // which is not a nestable object — guard rather than throw.
        subscription: json["subscription"] is Map<String, dynamic>
            ? SubscriptionData.fromJson(json["subscription"])
            : null,
        // The Frappe link-string form of the same field (see
        // [subscriptionRef]); a nested object keeps this null.
        subscriptionRef:
            json["subscription"] is String ? json["subscription"] : null,
        subscriptionId: json["subscription_id"],
        trialPeriodDays: json["trial_period_days"] is int
            ? json["trial_period_days"]
            : int.tryParse(json["trial_period_days"]?.toString() ?? ''),
        features: parseAllowedSubjects(json["features"]),
        allowedSubjects: parseAllowedSubjects(json["allowed_subjects"]),
        payer: json["payer"]?.toString(),
        bundlesHoliday: parseFlag(json["bundles_holiday"]),
        holidayAddOnPrice: json["holiday_add_on_price"] is num
            ? json["holiday_add_on_price"]
            : num.tryParse(json["holiday_add_on_price"]?.toString() ?? ''),
        holidayStandalone: parseFlag(json["holiday_standalone"]),
        personalizedCatchUp: parseFlag(json["personalized_catch_up"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ref": ref,
    "type": type,
    "price": price,
    "month": month,
    "active": active,
    "title": title,
    "content": content,
    "product_limit": productLimit,
    "order_limit": orderLimit,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "with_report": withReport,
    "subscription_id": subscriptionId,
    "expired_at": expiredAt?.toIso8601String(),
    "shop_id": shopId,
    // Object and link-string forms are mutually exclusive on the wire;
    // round-trip whichever one this row carried.
    "subscription": subscription?.toJson() ?? subscriptionRef,
    "trial_period_days": trialPeriodDays,
    "features": features,
    "allowed_subjects": allowedSubjects,
    "payer": payer,
    "bundles_holiday": bundlesHoliday,
    "holiday_add_on_price": holidayAddOnPrice,
    "holiday_standalone": holidayStandalone,
    "personalized_catch_up": personalizedCatchUp,
  };
}
