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
import 'package:base_sdk/src/presentation/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:subscriptions_sdk/subscriptions_sdk.dart';

import 'customer_subscription_models.dart';
import 'customer_subscriptions_repository.dart';
import 'package:remixicon/remixicon.dart';

String _t(String key) => AppHelpers.getTranslation(key);

String _day(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

String _money(num? n) => AppHelpers.numberFormat(number: n ?? 0);

String _per(String period) => switch (period) {
      'Yearly' => _t(TrKeys.year),
      'Quarterly' => _t(TrKeys.quarter),
      _ => _t(TrKeys.month),
    };

String _benefitLine(CustomerPlanBenefit b) {
  switch (b.type) {
    case 'Free Delivery':
      final min = b.value ?? 0;
      return min > 0
          ? '${_t(TrKeys.freeDelivery)} ${_t(TrKeys.onOrdersOver)} ${_money(min)}'
          : _t(TrKeys.freeDelivery);
    case 'Delivery Discount':
      return '${(b.value ?? 0).toStringAsFixed(0)}% ${_t(TrKeys.offDelivery)}';
    case 'Service Fee Waiver':
      return _t(TrKeys.noServiceFee);
    default:
      final d = b.description ?? '';
      return d.isNotEmpty ? d : b.type;
  }
}

/// The pick between the wallet and each saved card, rendered with
/// subscriptions_sdk's shared [SubscriptionPaymentMethodRow].
class _MethodChoice {
  final CustomerSubscriptionPayment payment;
  final SavedCardModel? card;
  const _MethodChoice(this.payment, [this.card]);
}

/// Customer plans (Uber One style): the current subscription with manage
/// actions (cancel keeps benefits to the end date, resume, pay a past-due
/// renewal now, change the renewal method) and every plan with Subscribe,
/// paid by wallet or saved card.
class CustomerPlansPage extends StatefulWidget {
  final CustomerSubscriptions repository;

  const CustomerPlansPage({
    super.key,
    this.repository = const HttpCustomerSubscriptions(),
  });

  @override
  State<CustomerPlansPage> createState() => _CustomerPlansPageState();
}

class _CustomerPlansPageState extends State<CustomerPlansPage> {
  List<CustomerPlan> _plans = const [];
  CustomerSubscription? _mine;
  List<SavedCardModel> _cards = const [];
  double? _balance;
  bool _loading = true;
  bool _failed = false;
  bool _busy = false;
  String? _error;

  CustomerSubscriptions get _repo => widget.repository;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _failed = false;
    });
    try {
      final results = await Future.wait([
        _repo.plans(),
        _repo.mine(),
        _repo.savedCards(),
        _repo.walletBalance(),
      ]);
      if (!mounted) return;
      setState(() {
        _plans = results[0] as List<CustomerPlan>;
        _mine = results[1] as CustomerSubscription?;
        _cards = results[2] as List<SavedCardModel>;
        _balance = results[3] as double?;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _failed = true;
      });
    }
  }

  Future<void> _run(Future<CustomerSubscription> Function() action) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final result = await action();
      if (result.paymentError != null && !result.isActive) {
        _error = '${_t(TrKeys.subscriptionPaymentFailed)} ${result.paymentError}';
      }
    } catch (e) {
      _error = e.toString();
    }
    await _load();
    if (mounted) setState(() => _busy = false);
  }

  List<_MethodChoice> get _choices => [
        const _MethodChoice(CustomerSubscriptionPayment.wallet),
        for (final c in _cards) _MethodChoice(CustomerSubscriptionPayment.card, c),
      ];

  /// Asks how to pay; null when dismissed.
  Future<_MethodChoice?> _pickMethod({required String action, num? amount}) {
    return showModalBottomSheet<_MethodChoice>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppStyle.surfaceFor(Theme.of(context).brightness),
      builder: (context) => _MethodSheet(
        choices: _choices,
        balance: _balance,
        action: action,
        amount: amount,
      ),
    );
  }

  Future<void> _subscribe(CustomerPlan plan) async {
    final choice = await _pickMethod(action: _t(TrKeys.pay), amount: plan.price);
    if (choice == null) return;
    await _run(() => _repo.subscribe(plan.id,
        payment: choice.payment, savedCardId: choice.card?.id));
  }

  Future<void> _changeMethod() async {
    final choice = await _pickMethod(action: _t(TrKeys.changePaymentMethod));
    if (choice == null) return;
    await _run(() =>
        _repo.changePayment(choice.payment, savedCardId: choice.card?.id));
  }

  Future<void> _cancel() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(_t(TrKeys.cancelSubscriptionQuestion)),
        actions: [
          TextButton(
            key: const ValueKey('custsub.keep'),
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(_t(TrKeys.keepSubscription)),
          ),
          TextButton(
            key: const ValueKey('custsub.confirm_cancel'),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(_t(TrKeys.cancelSubscription)),
          ),
        ],
      ),
    );
    if (ok == true) await _run(_repo.cancel);
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final ink = AppStyle.inkFor(brightness);
    final muted = AppStyle.secondaryInkFor(brightness);
    final List<Widget> body;
    if (_loading && _plans.isEmpty && _mine == null) {
      body = [
        const Padding(
          padding: EdgeInsets.all(32),
          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
      ];
    } else if (_failed) {
      body = [
        Text(_t(TrKeys.somethingWentWrongWithTheServer),
            style: TextStyle(color: muted)),
        TextButton(onPressed: _load, child: Text(_t(TrKeys.tryAgain))),
      ];
    } else {
      final mine = _mine;
      final holds = mine != null && (mine.isActive || mine.isPastDue);
      body = [
        if (mine != null)
          _ManageCard(
            sub: mine,
            busy: _busy,
            onCancel: _cancel,
            onResume: () => _run(_repo.resume),
            onPayNow: () => _run(_repo.payNow),
            onChangeMethod: _changeMethod,
          ),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(_error!,
                key: const ValueKey('custsub.error'),
                style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        if (_plans.isEmpty)
          Text(_t(TrKeys.noData), style: TextStyle(color: muted)),
        for (final plan in _plans)
          _PlanCard(
            plan: plan,
            current: mine?.planId == plan.id && holds,
            onSubscribe: holds || _busy ? null : () => _subscribe(plan),
          ),
      ];
    }
    return Scaffold(
      backgroundColor: AppStyle.surfaceFor(brightness),
      appBar: AppBar(
        backgroundColor: AppStyle.surfaceFor(brightness),
        foregroundColor: ink,
        elevation: 0,
        title: Text(_t(TrKeys.subscriptionPlans),
            style: TextStyle(color: ink, fontWeight: FontWeight.w600)),
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: body,
        ),
      ),
    );
  }
}

class _Frame extends StatelessWidget {
  final Widget child;
  final bool highlight;

  const _Frame({required this.child, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppStyle.cardFor(brightness),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: highlight ? AppStyle.primary : AppStyle.strokeFor(brightness),
          width: highlight ? 1.5 : 0.5,
        ),
      ),
      child: child,
    );
  }
}

class _ManageCard extends StatelessWidget {
  final CustomerSubscription sub;
  final bool busy;
  final VoidCallback onCancel;
  final VoidCallback onResume;
  final VoidCallback onPayNow;
  final VoidCallback onChangeMethod;

  const _ManageCard({
    required this.sub,
    required this.busy,
    required this.onCancel,
    required this.onResume,
    required this.onPayNow,
    required this.onChangeMethod,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final ink = TextStyle(fontSize: 15, color: AppStyle.inkFor(brightness));
    final muted =
        TextStyle(fontSize: 13, color: AppStyle.secondaryInkFor(brightness));
    final error = TextStyle(
        fontSize: 13, color: Theme.of(context).colorScheme.error);
    final String status;
    if (sub.isPastDue) {
      status = _t(TrKeys.subscriptionPastDue);
    } else if (sub.isPending) {
      status = _t(TrKeys.subscriptionPending);
    } else if (sub.cancelled && sub.endDate != null) {
      status = '${_t(TrKeys.cancelledAccessEndsOn)} ${_day(sub.endDate!)}';
    } else if (sub.renewalDate != null) {
      status =
          '${_t(TrKeys.renewsAutomaticallyOn)} ${_day(sub.renewalDate!)}';
    } else {
      status = '';
    }
    final method = sub.payment == CustomerSubscriptionPayment.card
        ? _t(TrKeys.payWithSavedCard)
        : _t(TrKeys.wallet);
    return _Frame(
      highlight: sub.isActive,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(sub.planName ?? sub.planId,
              style: ink.copyWith(fontSize: 17, fontWeight: FontWeight.w600)),
          if (status.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(status,
                key: const ValueKey('custsub.status'),
                style: sub.isPastDue ? error : muted),
          ],
          if (!sub.isActive && (sub.paymentError ?? '').isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(sub.paymentError!, style: muted),
          ],
          const SizedBox(height: 4),
          Text('${_t(TrKeys.renewsWith)} $method', style: muted),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              if (sub.isPastDue || sub.isPending)
                FilledButton(
                  key: const ValueKey('custsub.pay_now'),
                  style: FilledButton.styleFrom(
                      backgroundColor: AppStyle.primary,
                      foregroundColor: AppStyle.inkFor(Brightness.light)),
                  onPressed: busy ? null : onPayNow,
                  child: Text('${_t(TrKeys.payNow)} ${_money(sub.price)}'),
                ),
              if (!sub.cancelled)
                TextButton(
                  key: const ValueKey('custsub.change_method'),
                  onPressed: busy ? null : onChangeMethod,
                  child: Text(_t(TrKeys.changePaymentMethod)),
                ),
              TextButton(
                key: ValueKey(sub.cancelled ? 'custsub.resume' : 'custsub.cancel'),
                onPressed: busy ? null : (sub.cancelled ? onResume : onCancel),
                child: Text(_t(
                    sub.cancelled ? TrKeys.resume : TrKeys.cancelSubscription)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final CustomerPlan plan;
  final bool current;
  final VoidCallback? onSubscribe;

  const _PlanCard({required this.plan, required this.current, this.onSubscribe});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final ink = AppStyle.inkFor(brightness);
    final muted = AppStyle.secondaryInkFor(brightness);
    return _Frame(
      highlight: current,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(plan.name,
                    style: TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w600, color: ink)),
              ),
              Text('${_money(plan.price)} / ${_per(plan.period)}',
                  style: TextStyle(fontSize: 15, color: ink)),
            ],
          ),
          if ((plan.description ?? '').isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(plan.description!, style: TextStyle(fontSize: 13, color: muted)),
          ],
          const SizedBox(height: 8),
          for (final b in plan.benefits)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Icon(Remix.checkbox_circle_line,
                      size: 16, color: AppStyle.primary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(_benefitLine(b),
                        style: TextStyle(fontSize: 13, color: ink)),
                  ),
                ],
              ),
            ),
          if (!current) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                key: ValueKey('custsub.subscribe.${plan.id}'),
                style: FilledButton.styleFrom(
                    backgroundColor: AppStyle.primary,
                    foregroundColor: AppStyle.inkFor(Brightness.light)),
                onPressed: onSubscribe,
                child: Text(_t(TrKeys.subscribe)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MethodSheet extends StatefulWidget {
  final List<_MethodChoice> choices;
  final double? balance;
  final String action;
  final num? amount;

  const _MethodSheet({
    required this.choices,
    required this.balance,
    required this.action,
    this.amount,
  });

  @override
  State<_MethodSheet> createState() => _MethodSheetState();
}

class _MethodSheetState extends State<_MethodSheet> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final ink = AppStyle.inkFor(brightness);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(_t(TrKeys.selectPayment),
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w600, color: ink)),
            const SizedBox(height: 14),
            for (var i = 0; i < widget.choices.length; i++)
              SubscriptionPaymentMethodRow(
                key: ValueKey('custsub.method.$i'),
                method: SubscriptionPaymentMethod(
                    tag: widget.choices[i].card == null ? 'wallet' : 'card'),
                selected: _selected == i,
                title: widget.choices[i].card == null
                    ? _t(TrKeys.wallet)
                    : widget.choices[i].card!.cardType,
                hint: widget.choices[i].card == null
                    ? '${_t(TrKeys.balance)} ${_money(widget.balance)}'
                    : '•••• ${widget.choices[i].card!.lastFour}',
                onTap: () => setState(() => _selected = i),
              ),
            if (widget.choices.length == 1)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(_t(TrKeys.noSavedCard),
                    style: TextStyle(
                        fontSize: 12,
                        color: AppStyle.secondaryInkFor(brightness))),
              ),
            FilledButton(
              key: const ValueKey('custsub.method.confirm'),
              style: FilledButton.styleFrom(
                  backgroundColor: AppStyle.primary,
                  foregroundColor: AppStyle.inkFor(Brightness.light)),
              onPressed: () =>
                  Navigator.of(context).pop(widget.choices[_selected]),
              child: Text(widget.amount == null
                  ? widget.action
                  : '${widget.action} ${_money(widget.amount)}'),
            ),
          ],
        ),
      ),
    );
  }
}

/// The customer subscription's line inside the profile header card's plan
/// row (marketplace_sdk's 'marketplace.plan' slot — the single plan entry
/// on the customer profile): the plan name and its state, or an
/// invitation to see the plans. Tapping opens [CustomerPlansPage] and
/// reloads the state on return. Registered through base_sdk's
/// ProfileSectionRegistry action group [customerPlanActionGroup].
class CustomerSubscriptionPlanLine extends StatefulWidget {
  final CustomerSubscriptions repository;

  const CustomerSubscriptionPlanLine({
    super.key,
    this.repository = const HttpCustomerSubscriptions(),
  });

  @override
  State<CustomerSubscriptionPlanLine> createState() =>
      _CustomerSubscriptionPlanLineState();
}

class _CustomerSubscriptionPlanLineState
    extends State<CustomerSubscriptionPlanLine> {
  CustomerSubscription? _mine;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final m = await widget.repository.mine();
      if (mounted) setState(() => _mine = m);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final mine = _mine;
    final String line;
    if (mine == null) {
      line = _t(TrKeys.seePlans);
    } else if (mine.isPastDue) {
      line = _t(TrKeys.subscriptionPastDue);
    } else if (mine.cancelled && mine.endDate != null) {
      line = '${_t(TrKeys.cancelledAccessEndsOn)} ${_day(mine.endDate!)}';
    } else if (mine.isActive && mine.renewalDate != null) {
      line = '${_t(TrKeys.renewsAutomaticallyOn)} ${_day(mine.renewalDate!)}';
    } else {
      line = _t(TrKeys.subscriptionPending);
    }
    return GestureDetector(
      key: const ValueKey('custsub.plan_line'),
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => CustomerPlansPage(repository: widget.repository)));
        _load();
      },
      child: Wrap(
        spacing: 6,
        runSpacing: 2,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(mine?.planName ?? _t(TrKeys.subscriptionPlans),
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppStyle.inkFor(brightness))),
          Text(line,
              style: TextStyle(
                  fontSize: 11,
                  color: mine?.isPastDue ?? false
                      ? Theme.of(context).colorScheme.error
                      : AppStyle.secondaryInkFor(brightness))),
          Icon(Remix.arrow_right_s_line,
              size: 16, color: AppStyle.inkFor(brightness)),
        ],
      ),
    );
  }
}
