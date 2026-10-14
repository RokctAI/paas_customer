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
import 'package:base_sdk/src/presentation/theme/app_style.dart';
import 'package:flutter/material.dart';

import '../../domain/interface/subscription_payments_provider.dart';
import 'package:remixicon/remixicon.dart';

/// One PAYMENT-METHOD radio row of the subscription purchase surface:
/// icon, method name, a hint line (the wallet balance, a card's last four
/// digits, "opens secure checkout") and the radio mark.
///
/// Lifted out of the manager purchase dialog template
/// (templates/pages/subscriptions/widgets/payment_dialog.dart) so every
/// subscription purchase - shop plans and customer plans (loyalty_sdk) -
/// renders the same row. Colours come from the theme seams
/// (Theme.of(context).brightness with AppStyle.inkFor / secondaryInkFor /
/// strokeFor) and the brand primary.
class SubscriptionPaymentMethodRow extends StatelessWidget {
  final SubscriptionPaymentMethod method;
  final bool selected;
  final String hint;
  final VoidCallback onTap;

  /// Shown instead of the translated [SubscriptionPaymentMethod.tag].
  final String? title;

  /// Overrides the default wallet / card icon.
  final IconData? icon;

  const SubscriptionPaymentMethodRow({
    super.key,
    required this.method,
    required this.selected,
    required this.hint,
    required this.onTap,
    this.title,
    this.icon,
  });

  bool get isWallet => method.tag == 'wallet';

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final muted = AppStyle.secondaryInkFor(brightness);
    final accent = AppStyle.primary;
    return Semantics(
      selected: selected,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: selected ? accent.withOpacity(0.08) : Colors.transparent,
            border: Border.all(
              color: selected ? accent : AppStyle.strokeFor(brightness),
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon ??
                    (isWallet
                        ? Remix.wallet_3_line
                        : Remix.bank_card_line),
                size: 22,
                color: selected ? accent : muted,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title ?? AppHelpers.getTranslation(method.tag ?? ''),
                      style: AppStyle.interNoSemi(
                        size: 15,
                        color: AppStyle.inkFor(brightness),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      hint,
                      style: AppStyle.interRegular(size: 12.5, color: muted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? accent : muted,
                    width: 2,
                  ),
                ),
                child: selected
                    ? Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: accent,
                          ),
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
