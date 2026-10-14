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

/// Customer subscriptions (Uber One style, commerce loyalty): models for
/// the `api.customer_subscription.*` cmds.
library;

double? _num(Object? v) => v == null ? null : double.tryParse(v.toString());

DateTime? _date(Object? v) =>
    v == null ? null : DateTime.tryParse(v.toString());

/// How a subscription is paid and renewed.
enum CustomerSubscriptionPayment {
  wallet('Wallet'),
  card('Card');

  final String wire;
  const CustomerSubscriptionPayment(this.wire);

  static CustomerSubscriptionPayment fromWire(Object? v) =>
      v == 'Card' ? card : wallet;
}

enum CustomerSubscriptionStatus {
  pending('Pending'),
  active('Active'),
  pastDue('Past Due'),
  cancelled('Cancelled'),
  expired('Expired');

  final String wire;
  const CustomerSubscriptionStatus(this.wire);

  static CustomerSubscriptionStatus fromWire(Object? v) =>
      values.firstWhere((s) => s.wire == v, orElse: () => pending);
}

class CustomerPlanBenefit {
  /// "Free Delivery", "Delivery Discount", "Service Fee Waiver" or "Other".
  final String type;
  final double? value;
  final String? description;

  const CustomerPlanBenefit({required this.type, this.value, this.description});

  factory CustomerPlanBenefit.fromJson(Map<String, dynamic> json) =>
      CustomerPlanBenefit(
        type: (json['benefit_type'] ?? '').toString(),
        value: _num(json['value']),
        description: json['description']?.toString(),
      );
}

class CustomerPlan {
  final String id;
  final String name;
  final String? description;
  final double price;

  /// "Monthly", "Quarterly" or "Yearly".
  final String period;
  final List<CustomerPlanBenefit> benefits;

  const CustomerPlan({
    required this.id,
    required this.name,
    this.description,
    this.price = 0,
    this.period = 'Monthly',
    this.benefits = const [],
  });

  factory CustomerPlan.fromJson(Map<String, dynamic> json) => CustomerPlan(
        id: (json['name'] ?? '').toString(),
        name: (json['plan_name'] ?? json['name'] ?? '').toString(),
        description: json['description']?.toString(),
        price: _num(json['price']) ?? 0,
        period: (json['period'] ?? 'Monthly').toString(),
        benefits: [
          for (final b in (json['benefits'] as List? ?? const []))
            if (b is Map) CustomerPlanBenefit.fromJson(Map<String, dynamic>.from(b)),
        ],
      );
}

class CustomerSubscription {
  final String id;
  final String planId;
  final String? planName;
  final String? period;
  final CustomerSubscriptionStatus status;
  final DateTime? startDate;
  final DateTime? endDate;
  final double? price;
  final CustomerSubscriptionPayment payment;
  final bool autoRenew;

  /// Why the last charge failed (a Pending first payment or a Past Due
  /// renewal).
  final String? paymentError;

  const CustomerSubscription({
    required this.id,
    required this.planId,
    this.planName,
    this.period,
    this.status = CustomerSubscriptionStatus.pending,
    this.startDate,
    this.endDate,
    this.price,
    this.payment = CustomerSubscriptionPayment.wallet,
    this.autoRenew = true,
    this.paymentError,
  });

  bool get isActive => status == CustomerSubscriptionStatus.active;
  bool get isPastDue => status == CustomerSubscriptionStatus.pastDue;
  bool get isPending => status == CustomerSubscriptionStatus.pending;

  /// Cancelled by the customer: benefits run to [endDate], no renewal.
  bool get cancelled => isActive && !autoRenew;

  /// The day it renews (the day after the inclusive [endDate]).
  DateTime? get renewalDate => endDate?.add(const Duration(days: 1));

  factory CustomerSubscription.fromJson(Map<String, dynamic> json) {
    final plan = json['plan_details'] is Map
        ? Map<String, dynamic>.from(json['plan_details'] as Map)
        : const <String, dynamic>{};
    final autoRenew = json['auto_renew'];
    return CustomerSubscription(
      id: (json['name'] ?? '').toString(),
      planId: (json['plan'] ?? '').toString(),
      planName: plan['plan_name']?.toString(),
      period: plan['period']?.toString(),
      status: CustomerSubscriptionStatus.fromWire(json['status']),
      startDate: _date(json['start_date']),
      endDate: _date(json['end_date']),
      price: _num(json['price']),
      payment: CustomerSubscriptionPayment.fromWire(json['payment_method']),
      autoRenew: autoRenew == null || autoRenew == true || autoRenew == 1,
      paymentError: (json['payment_error'] ?? json['last_payment_error'])
          ?.toString(),
    );
  }
}
