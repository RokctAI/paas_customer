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

// Saved cards in the wallet (Ray, 2026-10-17): one row per card, with a
// remove button. Removing the card is how a payer stops automatic card
// renewals (the consent text says so); renewals then come from the
// wallet balance. Hidden when there are no cards.

import 'dart:async';

import 'package:base_sdk/src/presentation/theme/app_style.dart';
import 'package:base_sdk/src/services/app_helpers.dart';
import 'package:base_sdk/src/services/telemetry.dart';
import 'package:base_sdk/src/services/tr_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remixicon/remixicon.dart';

import 'package:wallet_sdk/src/common/infrastructure/repositories/card_billing_api.dart';
import 'package:wallet_sdk/src/common/translations/wallet_translations.dart';

class SavedCardsSection extends StatefulWidget {
  const SavedCardsSection({super.key, this.api = const CardBillingApi()});

  final CardBillingApi api;

  @override
  State<SavedCardsSection> createState() => SavedCardsSectionState();
}

class SavedCardsSectionState extends State<SavedCardsSection> {
  List<WalletSavedCard> _cards = const [];
  String? _removing;

  @override
  void initState() {
    super.initState();
    reload();
  }

  Future<void> reload() async {
    try {
      final cards = await widget.api.savedCards();
      if (mounted) setState(() => _cards = cards);
    } catch (e) {
      unawaited(TelemetryClient.I.logError(
        type: 'wallet_saved_cards_failed',
        context: {'detail': '$e'},
      ));
    }
  }

  Future<void> _remove(WalletSavedCard card) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppHelpers.getTranslation(WalletTrKeys.removeCard)),
        content: Text(AppHelpers.getTranslation(WalletTrKeys.removeCardConfirm)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppHelpers.getTranslation(TrKeys.cancel)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              AppHelpers.getTranslation(WalletTrKeys.removeCard),
              style: TextStyle(color: AppStyle.red),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _removing = card.id);
    try {
      await widget.api.removeCard(card.id);
      if (!mounted) return;
      setState(() {
        _cards = _cards.where((c) => c.id != card.id).toList();
        _removing = null;
      });
      AppHelpers.showCheckTopSnackBarDone(
        context,
        AppHelpers.getTranslation(WalletTrKeys.cardRemoved),
      );
    } catch (e) {
      if (mounted) setState(() => _removing = null);
      unawaited(TelemetryClient.I.logError(
        type: 'wallet_remove_card_failed',
        context: {'detail': '$e'},
      ));
      if (mounted) {
        AppHelpers.showCheckTopSnackBarInfo(
          context,
          AppHelpers.getTranslation(WalletTrKeys.cardCheckoutFailed),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cards.isEmpty) return const SizedBox.shrink();
    final brightness = Theme.of(context).brightness;
    return Padding(
      padding: EdgeInsets.fromLTRB(16.r, 16.r, 16.r, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppHelpers.getTranslation(WalletTrKeys.savedCards),
            style: AppStyle.interSemi(size: 16.sp, color: AppStyle.inkFor(brightness)),
          ),
          8.verticalSpace,
          for (final card in _cards)
            Container(
              key: ValueKey('saved-card-${card.id}'),
              margin: EdgeInsets.only(bottom: 8.h),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppStyle.cardFor(brightness),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppStyle.strokeFor(brightness)),
              ),
              child: Row(
                children: [
                  Icon(Remix.bank_card_line, color: AppStyle.secondaryInkFor(brightness)),
                  12.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          card.label,
                          style: AppStyle.interSemi(
                              size: 14.sp, color: AppStyle.inkFor(brightness)),
                        ),
                        if (card.renewsAutomatically)
                          Text(
                            AppHelpers.getTranslation(WalletTrKeys.renewsAutomatically),
                            style: AppStyle.interNormal(
                                size: 12.sp, color: AppStyle.secondaryInkFor(brightness)),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: AppHelpers.getTranslation(WalletTrKeys.removeCard),
                    onPressed: _removing == null ? () => _remove(card) : null,
                    icon: _removing == card.id
                        ? SizedBox(
                            width: 18.r,
                            height: 18.r,
                            child: const CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(Remix.delete_bin_line, color: AppStyle.red),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
