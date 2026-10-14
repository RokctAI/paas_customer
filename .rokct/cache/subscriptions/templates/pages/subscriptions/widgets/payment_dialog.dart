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


import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subscriptions_sdk/src/common/application/subscriptions/subscriptions_provider.dart';
import 'package:base_sdk/base_sdk.dart';
import 'package:subscriptions_sdk/subscriptions_sdk.dart';
import 'package:base_sdk/src/presentation/components/buttons/animation_button_effect2.dart';
import 'package:${package}/presentation/theme/theme.dart';

/// The shared "Select payment" surface (approved section 40, chip 765).
///
/// The 12:02Z sheet/dialog fork applied to the subscription purchase: ONE
/// body, two dresses — at plane widths the page embeds it as the
/// last-plane PAYMENT PANE (frame 40b); on phones [PaymentDialog] wraps it
/// in the shipped alert dialog, unchanged behaviour.
///
/// Contents: "Select payment" + the chosen plan's summary line (title,
/// trial when the row carries one, price + cycle — all from the catalog
/// row, nothing hardcoded), the PAYMENT-METHOD rows (chip 766 — the
/// shipped notifier's list, cash already filtered out), then Total and the
/// fixed-amount PAY + CANCEL action pair (chip 767). Deliberately NO
/// keypad: the plan price is fixed, nothing is typed (MoneyKeypad is for
/// typed amounts). The pane form shows NO corner back pill either — the
/// payment exception (Ray 15:06Z): the escape is its own Cancel.
///
/// COMPOSER SEAM — the `// @subscription-payments-list` and
/// `// @subscription-payments-action` markers below belong to the SDK
/// composer's layout-integration machinery (`update_layout_integrations`
/// in sdk_installer_base.py): another installed SDK may declare
/// `integrations: [{target, placeholder, replacement}]` in its manifest and
/// the composer injects its widgets DIRECTLY AFTER the marker line in the
/// installed copy of this file. Both markers therefore sit inside widget
/// `children:` lists (extra method rows land after the built-in rows;
/// extra actions land after the built-in pair) and must stay verbatim.
class SubscriptionPaymentBody extends ConsumerWidget {
  /// Closes the surface without paying (the Cancel escape).
  final VoidCallback onCancel;

  /// Called after a successful payment; the owner closes the surface and
  /// refreshes the catalog/held-plan state.
  final VoidCallback onPaid;

  const SubscriptionPaymentBody({
    super.key,
    required this.onCancel,
    required this.onPaid,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(subscriptionProvider);
    final notifier = ref.read(subscriptionProvider.notifier);
    final walletPrice = ref.watch(walletPriceProvider);
    final SubscriptionData? plan =
        state.selectSubscribe >= 0 && state.selectSubscribe < state.list.length
            ? state.list[state.selectSubscribe]
            : null;
    final payments = state.payments ?? [];
    final brightness = Theme.of(context).brightness;

    final title = plan == null
        ? ''
        : PlanCardLogic.displayTitle(plan,
            translate: AppHelpers.getTranslation);
    final cycle = plan == null
        ? null
        : PlanCardLogic.cycleLabel(plan, translate: AppHelpers.getTranslation);
    final trial = plan == null
        ? null
        : PlanCardLogic.trialLabel(plan, translate: AppHelpers.getTranslation);
    final priceText = AppHelpers.numberFormat(number: plan?.price);
    final summary = [
      if (title.isNotEmpty) title,
      if (trial != null)
        '$trial, ${AppHelpers.getTranslation('then').toLowerCase()} '
            '$priceText${cycle == null ? '' : ' $cycle'}'
      else
        '$priceText${cycle == null ? '' : ' $cycle'}',
    ].join(' · ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppHelpers.getTranslation(TrKeys.selectPayment),
          style: AppStyle.interSemi(
            size: 22,
            color: AppStyle.inkFor(brightness),
          ),
        ),
        6.verticalSpace,
        Text(
          summary,
          style: AppStyle.interRegular(
            size: 14,
            color: AppStyle.secondaryInkFor(brightness),
          ),
        ),
        18.verticalSpace,
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              for (int i = 0; i < payments.length; i++)
                // subscriptions_sdk's shared row (also used by loyalty_sdk's
                // customer plans): wallet balance as the wallet's hint,
                // "opens secure checkout" for the web-view gateways.
                SubscriptionPaymentMethodRow(
                  method: payments[i],
                  selected: state.selectPayment == i,
                  icon: payments[i].tag == 'wallet'
                      ? Remix.wallet_3_line
                      : Remix.bank_card_line,
                  hint: payments[i].tag == 'wallet'
                      ? '${AppHelpers.getTranslation(TrKeys.balance)} '
                          '${AppHelpers.numberFormat(number: walletPrice())}'
                      : AppHelpers.getTranslation('opens.secure.checkout'),
                  onTap: () => notifier.selectPayment(index: i),
                ),
              // @subscription-payments-list
            ],
          ),
        ),
        Container(height: 1, color: AppStyle.subtleStrokeFor(brightness)),
        14.verticalSpace,
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppHelpers.getTranslation(TrKeys.total),
                  style: AppStyle.interNoSemi(
                    size: 16,
                    color: AppStyle.inkFor(brightness),
                  ),
                ),
                Text(
                  priceText,
                  style: AppStyle.interBold(
                    size: 20,
                    color: AppStyle.inkFor(brightness),
                  ),
                ),
              ],
            ),
            16.verticalSpace,
            // Chip 767 — the fixed-amount PAY: the one place the charge
            // can start, and only from this explicit, amount-labelled tap.
            ButtonEffectAnimation(
              onTap: () {
                if (state.isPaymentLoading || payments.isEmpty) return;
                notifier.payment(context, onSuccess: onPaid);
              },
              child: Container(
                padding: REdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.r),
                  color: payments.isEmpty
                      ? AppStyle.primary.withOpacity(0.4)
                      : AppStyle.primary,
                ),
                child: state.isPaymentLoading
                    ? Center(
                        child: SizedBox(
                          width: 20.r,
                          height: 20.r,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: AppStyle.white,
                          ),
                        ),
                      )
                    : Text(
                        '${AppHelpers.getTranslation(TrKeys.pay)} $priceText',
                        textAlign: TextAlign.center,
                        style: AppStyle.interNoSemi(
                          size: 16,
                          color: AppStyle.white,
                        ),
                      ),
              ),
            ),
            6.verticalSpace,
            TextButton(
              onPressed: onCancel,
              child: Text(
                AppHelpers.getTranslation(TrKeys.cancel),
                style: AppStyle.interNoSemi(
                  size: 15,
                  color: AppStyle.secondaryInkFor(brightness),
                ),
              ),
            ),
            // @subscription-payments-action
          ],
        ),
      ],
    );
  }
}

/// The phone dress of the purchase moment: the shipped alert-dialog
/// behaviour, unchanged (the sheet fork's phone half — frames 40c). Pops
/// itself on Cancel and on success; the page passes [onPaid] to refresh
/// after a successful purchase.
class PaymentDialog extends ConsumerWidget {
  final VoidCallback? onPaid;

  const PaymentDialog({super.key, this.onPaid});

  @override
  Widget build(BuildContext context, ref) {
    final state = ref.watch(subscriptionProvider);
    final isLrt = LocalStorage.getLangLtr();
    return Directionality(
      textDirection: isLrt ? TextDirection.ltr : TextDirection.rtl,
      child: SizedBox(
        height: (state.payments?.length ?? 0) > 8
            ? MediaQuery.sizeOf(context).height / 1.6
            : MediaQuery.sizeOf(context).height / 2,
        width: double.maxFinite,
        child: SubscriptionPaymentBody(
          onCancel: () => Navigator.of(context).maybePop(),
          onPaid: () {
            Navigator.of(context).maybePop();
            onPaid?.call();
          },
        ),
      ),
    );
  }
}
