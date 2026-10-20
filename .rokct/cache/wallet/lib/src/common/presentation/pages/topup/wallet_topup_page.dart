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

// compliance-ignore-file: flutter-http-timeout (all HTTP rides base_sdk's
// PlatformGateway Dio, whose BaseOptions set connect/receive timeouts
// centrally; no HTTP client is created in this file)

// Wallet top-up screen, ported from commerce/marketplace's finished
// WalletTopUpScreen (#33): amount presets and a saved-card picker that
// tops up with the chosen card.
//
// Port deltas, on purpose:
//   * Every backend call goes through base_sdk's [PlatformGateway]
//     (`{"cmd", "payload"}` POSTs to the one gateway path) instead of the
//     donor's per-method URLs. Both cmds are the wallet frappe manifest's
//     whitelisted-method keys with the app prefix stripped.
//   * The saved-card picker is rendered by this SDK rather than through
//     `EmbeddedWidgets.I.savedCardsWidget`: feature SDKs must not import
//     each other (ADR-005), and a shell that composes wallet_sdk without
//     the marketplace surfaces never registers that embedded widget — the
//     donor's call would throw.
//   * "Pay with a new card" opens the gateway's own card page (PayFast or
//     Paystack, CardCheckoutPage) through the wallet backend's
//     start_card_checkout, which needs no Order (Ray, 2026-10-17, C1). It
//     never pushes the orders SDK's paymentScreen, which crashed in apps
//     without that SDK. "Save this card for automatic renewals" is off
//     until the payer ticks it; ticking shows the consent text, which says
//     plainly that renewals are charged to the card automatically, with no
//     reminder, and how to remove the card (C2, C4). The wallet is credited
//     only when the gateway confirms the payment to the server.
//   * Each top-up sends an X-Idempotency-Key (one per card + amount, reused
//     on a retry) so a retried top-up cannot charge twice, and a success
//     refreshes the profile so the wallet card shows the new balance.
//   * Amounts show the backend's currency symbol (rand only as fallback).
//   * Student-facing errors are one friendly line; the detail goes to
//     [TelemetryClient] (#56 standing rule). The donor put raw `$error`
//     text on screen.
//   * The donor's "receive from a friend" entry (below the new-card
//     button) is restored with the profile-card re-home: it opens this
//     SDK's ported WalletReceiveScreen claim-code sheet.

import 'dart:async';

import 'package:base_sdk/src/application/profile/profile_provider.dart';
import 'package:base_sdk/src/di/injection.dart';
import 'package:base_sdk/src/handlers/api_result.dart';
import 'package:base_sdk/src/handlers/platform_gateway.dart';
import 'package:base_sdk/src/models/data/saved_card.dart';
import 'package:base_sdk/src/presentation/components/keyboard_dismisser.dart';
import 'package:base_sdk/src/presentation/components/title_icon.dart';
import 'package:base_sdk/src/presentation/theme/theme.dart';
import 'package:base_sdk/src/services/app_helpers.dart';
import 'package:base_sdk/src/services/local_storage.dart';
import 'package:base_sdk/src/services/telemetry.dart';
import 'package:base_sdk/src/services/tr_keys.dart';
import 'package:base_sdk/src/sync/sync_engine.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:wallet_sdk/src/common/infrastructure/repositories/card_billing_api.dart';
import 'package:wallet_sdk/src/common/infrastructure/repositories/wallet_repository.dart';
import 'package:wallet_sdk/src/common/presentation/pages/cards/card_checkout_page.dart';
import 'package:wallet_sdk/src/common/presentation/pages/receive/wallet_receive_screen.dart';
import 'package:wallet_sdk/src/common/translations/wallet_translations.dart';
import 'package:wallet_sdk/src/common/utils/wallet_currency.dart';

class WalletTopUpPage extends ConsumerStatefulWidget {
  /// Render as a bottom sheet (drag handle + title in the sheet chrome,
  /// no Scaffold/AppBar) instead of a pushed page. The profile wallet
  /// card's Top-up opens it this way, the same modal shape as its Send
  /// sheet (Ray, 2026-09-23: "topup wallet needs to be a modal like send
  /// money screen"); the /wallet-topup route keeps the page form for its
  /// other callers.
  final bool asSheet;

  /// The card checkout calls; a test passes a fake.
  final CardBillingApi cardBilling;

  /// Opens the gateway page and answers 'done' / 'cancelled' / null; a
  /// test replaces it. Defaults to pushing [CardCheckoutPage].
  final Future<String?> Function(BuildContext, CardCheckout)? openCheckout;

  /// How long to wait for the gateway's confirmation after the payer
  /// comes back, polling every [pollEvery].
  final Duration pollEvery;
  final int pollTries;

  const WalletTopUpPage({
    super.key,
    this.asSheet = false,
    this.cardBilling = const CardBillingApi(),
    this.openCheckout,
    this.pollEvery = const Duration(seconds: 2),
    this.pollTries = 15,
  });

  /// Opens the top-up flow as a modal bottom sheet over [context].
  static void showAsSheet(BuildContext context) {
    AppHelpers.showCustomModalBottomSheet(
      context: context,
      modal: const WalletTopUpPage(asSheet: true),
      isDarkMode: Theme.of(context).brightness == Brightness.dark,
      paddingTop: 100,
    );
  }

  @override
  ConsumerState<WalletTopUpPage> createState() => _WalletTopUpPageState();
}

class _WalletTopUpPageState extends ConsumerState<WalletTopUpPage> {
  static const _gateway = PlatformGateway();

  final _amountController = TextEditingController();
  final _walletRepository = walletRepository;
  bool _isLoading = false;
  bool _loadingCards = true;
  List<SavedCardModel> _savedCards = [];
  SavedCardModel? _selectedCard;

  /// "Save this card for automatic renewals" - off until the payer ticks
  /// it, which is their consent (the text shows under the box).
  bool _saveNewCard = false;

  // Predefined amount options for quick selection (donor's presets).
  final List<double> _amountOptions = [50, 100, 200, 500, 1500, 2000];

  /// One idempotency key per top-up attempt (card + amount), reused when
  /// the same top-up is retried after a failure or timeout so the server
  /// never charges it twice; another card or amount gets a new key, and a
  /// completed top-up clears it.
  String? _topUpKey;
  String? _topUpKeyFor;

  String _topUpKeyForAttempt(String cardId, double amount) {
    final attempt = '$cardId|$amount';
    if (_topUpKey == null || _topUpKeyFor != attempt) {
      _topUpKey = SyncEngine.newOpId();
      _topUpKeyFor = attempt;
    }
    return _topUpKey!;
  }

  @override
  void initState() {
    super.initState();
    _loadSavedCards();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  /// One friendly line for the student; the detail rides to telemetry.
  void _failFriendly(String friendlyTrKey, String type, Object detail) {
    unawaited(
      TelemetryClient.I.logError(type: type, context: {'detail': '$detail'}),
    );
    if (!mounted) return;
    AppHelpers.showCheckTopSnackBarInfo(
      context,
      AppHelpers.getTranslation(friendlyTrKey),
    );
  }

  Future<void> _loadSavedCards() async {
    setState(() {
      _loadingCards = true;
    });

    try {
      // Manifest key: {app_name}.api.payment.get_saved_cards. The method
      // returns a bare list of card rows (name/gateway/last_four/card_type/
      // expiry_date/card_holder_name/is_default), the default first. No
      // reuse credential: `name` is the handle the top-up charge takes.
      final body = await _gateway.tenant('api.payment.get_saved_cards');
      final data = body is Map && body.containsKey('message')
          ? body['message']
          : body;
      final cards = (data is List)
          ? data
                .whereType<Map>()
                .map(
                  (e) => SavedCardModel(
                    id: (e['id'] ?? e['name'])?.toString() ?? '',
                    lastFour: e['last_four']?.toString() ?? '',
                    cardType: e['card_type']?.toString() ?? 'Card',
                    expiryDate: e['expiry_date']?.toString() ?? '',
                    cardHolderName: e['card_holder_name']?.toString() ?? '',
                    isDefault: e['is_default'] == true || e['is_default'] == 1,
                  ),
                )
                .toList()
          : <SavedCardModel>[];
      if (!mounted) return;
      setState(() {
        _savedCards = cards;
        _loadingCards = false;
        // Start on the user's default card, when they have chosen one.
        _selectedCard ??= cards.where((c) => c.isDefault).firstOrNull;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingCards = false;
      });
      // Cards failing to load shows the no-saved-card state; telemetry
      // only, no snackbar.
      unawaited(
        TelemetryClient.I.logError(
          type: 'wallet_topup_saved_cards_failed',
          context: {'detail': '$e'},
        ),
      );
    }
  }

  void _navigateBack() {
    Navigator.of(context).maybePop();
  }

  // Opens the receive-from-a-friend claim-code sheet on top of this page
  // (the donor's modal pattern).
  void _openReceiveFromFriend() {
    AppHelpers.showCustomModalBottomSheet(
      context: context,
      modal: ProviderScope(
        child: Consumer(
          builder: (context, ref, _) => const WalletReceiveScreen(),
        ),
      ),
      isDarkMode: AppStyle.isDark,
    );
  }

  double? _validAmount() {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      AppHelpers.showCheckTopSnackBarInfo(
        context,
        AppHelpers.getTranslation(TrKeys.pleaseEnterValidAmount),
      );
      return null;
    }
    return amount;
  }

  // Process top-up with a saved card, named by its id. The gateway
  // reuse credential stays on the server.
  Future<void> _processTokenTopUp() async {
    final card = _selectedCard;
    if (card == null) {
      AppHelpers.showCheckTopSnackBarInfo(
        context,
        AppHelpers.getTranslation(TrKeys.selectCard),
      );
      return;
    }

    final amount = _validAmount();
    if (amount == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final key = _topUpKeyForAttempt(card.id, amount);
      final repository = _walletRepository;
      final result = repository is WalletRepository
          ? await repository.walletTopUp(
              amount: amount,
              token: card.id,
              idempotencyKey: key,
            )
          : await repository.walletTopUp(amount: amount, token: card.id);

      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });

      result.when(
        success: (data) {
          _topUpKey = null;
          if (!mounted) return;
          // The profile wallet card reads the profile; refetch it so the
          // new balance shows instead of the pre-top-up one.
          ref.read(profileProvider.notifier).fetchUser(context);
          AppHelpers.showCheckTopSnackBarDone(
            context,
            AppHelpers.getTranslation(TrKeys.topUpSuccessful),
          );
          _navigateBack();
        },
        failure: (error, statusCode) => _failFriendly(
          TrKeys.somethingWentWrongWithTheServer,
          'wallet_topup_token_failed',
          '$error (status $statusCode)',
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      _failFriendly(
        TrKeys.somethingWentWrongWithTheServer,
        'wallet_topup_token_failed',
        e,
      );
    }
  }

  Future<String?> _defaultOpenCheckout(
    BuildContext context,
    CardCheckout checkout,
  ) =>
      Navigator.of(context).push<String>(
        MaterialPageRoute(builder: (_) => CardCheckoutPage(checkout: checkout)),
      );

  /// Top up with a new card at the gateway's page, saving the card for
  /// automatic renewals when the payer ticked the consent box.
  Future<void> _payWithNewCard() async {
    final amount = _validAmount();
    if (amount == null) return;
    setState(() {
      _isLoading = true;
    });
    try {
      final checkout = await widget.cardBilling.startCheckout(
        amount: amount,
        saveCard: _saveNewCard,
      );
      if (!mounted) return;
      final outcome = await (widget.openCheckout ?? _defaultOpenCheckout)(
        context,
        checkout,
      );
      if (!mounted) return;
      if (outcome == 'cancelled') {
        setState(() {
          _isLoading = false;
        });
        AppHelpers.showCheckTopSnackBarInfo(
          context,
          AppHelpers.getTranslation(WalletTrKeys.cardCheckoutCancelled),
        );
        return;
      }
      // The gateway confirms to the server (PayFast ITN, Paystack
      // verify); wait for it rather than trusting the redirect.
      var status = await widget.cardBilling.checkoutStatus(checkout.transaction);
      for (var i = 1; status.isPending && i < widget.pollTries; i++) {
        await Future<void>.delayed(widget.pollEvery);
        if (!mounted) return;
        status = await widget.cardBilling.checkoutStatus(checkout.transaction);
      }
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      if (status.isPaid) {
        ref.read(profileProvider.notifier).fetchUser(context);
        AppHelpers.showCheckTopSnackBarDone(
          context,
          AppHelpers.getTranslation(
            status.cardSaved
                ? WalletTrKeys.cardSavedForRenewals
                : TrKeys.topUpSuccessful,
          ),
        );
        _navigateBack();
      } else if (status.isPending) {
        AppHelpers.showCheckTopSnackBarInfo(
          context,
          AppHelpers.getTranslation(WalletTrKeys.cardCheckoutWaiting),
        );
      } else {
        AppHelpers.showCheckTopSnackBarInfo(
          context,
          AppHelpers.getTranslation(WalletTrKeys.cardCheckoutFailed),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      _failFriendly(
        WalletTrKeys.cardCheckoutFailed,
        'wallet_topup_new_card_failed',
        e,
      );
    }
  }

  Widget _newCardSection() {
    final brightness = Theme.of(context).brightness;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          key: const ValueKey('save-card-consent'),
          onTap: _isLoading
              ? null
              : () => setState(() => _saveNewCard = !_saveNewCard),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                _saveNewCard
                    ? Remix.checkbox_fill
                    : Remix.checkbox_blank_line,
                color: _saveNewCard
                    ? AppStyle.primary
                    : AppStyle.secondaryInkFor(brightness),
              ),
              8.horizontalSpace,
              Expanded(
                child: Text(
                  AppHelpers.getTranslation(WalletTrKeys.saveCardForRenewals),
                  style: AppStyle.interSemi(size: 14.sp),
                ),
              ),
            ],
          ),
        ),
        if (_saveNewCard) ...[
          6.verticalSpace,
          Padding(
            padding: EdgeInsets.only(left: 32.w),
            child: Text(
              AppHelpers.getTranslation(WalletTrKeys.cardRenewalConsent),
              key: const ValueKey('card-consent-text'),
              style: AppStyle.interNormal(
                size: 12.sp,
                color: AppStyle.secondaryInkFor(brightness),
              ),
            ),
          ),
        ],
        12.verticalSpace,
        ElevatedButton.icon(
          key: const ValueKey('pay-with-new-card'),
          onPressed: _isLoading ? null : _payWithNewCard,
          icon: const Icon(Remix.bank_card_2_line),
          style: ElevatedButton.styleFrom(
            backgroundColor: _selectedCard == null
                ? AppStyle.primary
                : AppStyle.transparent,
            foregroundColor:
                _selectedCard == null ? AppStyle.white : AppStyle.primary,
            minimumSize: Size(double.infinity, 50.h),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
              side: BorderSide(color: AppStyle.primary),
            ),
          ),
          label: Text(
            AppHelpers.getTranslation(WalletTrKeys.payWithANewCard),
            style: AppStyle.interSemi(
              size: 16.sp,
              color: _selectedCard == null ? AppStyle.white : AppStyle.primary,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isLtr = LocalStorage.getLangLtr();
    final content = SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.verticalSpace,
            TitleAndIcon(
              title: AppHelpers.getTranslation(TrKeys.enterAmount),
              paddingHorizontalSize: 0,
              titleSize: 16,
              titleColor: AppStyle.textPrimary,
            ),
            16.verticalSpace,
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                hintText: '0.00',
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Text(
                    WalletCurrency.symbol,
                    style: AppStyle.interBold(size: 18.sp),
                  ),
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 0,
                  minHeight: 0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: AppStyle.strokeDark),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: AppStyle.primary),
                ),
              ),
            ),
            24.verticalSpace,
            Text(
              AppHelpers.getTranslation(TrKeys.quickAmount),
              style: AppStyle.interSemi(size: 16.sp),
            ),
            16.verticalSpace,
            Wrap(
              spacing: 10.w,
              runSpacing: 10.h,
              children: _amountOptions.map((amount) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      _amountController.text = amount.toString();
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppStyle.cardDark,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: AppStyle.strokeDark),
                      boxShadow: [
                        BoxShadow(
                          color: AppStyle.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      WalletCurrency.format(amount),
                      style: AppStyle.interNormal(size: 14.sp),
                    ),
                  ),
                );
              }).toList(),
            ),
            24.verticalSpace,

            // Saved Cards Section
            if (_loadingCards)
              Center(child: CircularProgressIndicator(color: AppStyle.primary))
            else if (_savedCards.isNotEmpty) ...[
              Text(
                AppHelpers.getTranslation(TrKeys.selectCard),
                style: AppStyle.interSemi(size: 16.sp),
              ),
              16.verticalSpace,
              ..._savedCards.map(
                (card) => _SavedCardTile(
                  card: card,
                  selected: _selectedCard?.id == card.id,
                  onTap: () {
                    setState(() {
                      _selectedCard = _selectedCard?.id == card.id
                          ? null
                          : card;
                    });
                  },
                ),
              ),
              16.verticalSpace,

              // Pay with selected card button
              if (_selectedCard != null)
                ElevatedButton(
                  onPressed: _isLoading ? null : _processTokenTopUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyle.primary,
                    minimumSize: Size(double.infinity, 50.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 20.h,
                          width: 20.w,
                          child: CircularProgressIndicator(
                            color: AppStyle.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          AppHelpers.getTranslation(TrKeys.payWithSavedCard),
                          style: AppStyle.interSemi(
                            size: 16.sp,
                            color: AppStyle.white,
                          ),
                        ),
                ),
            ] else
              // No saved card yet: say so; the new-card button below is
              // the way in.
              Center(
                child: Column(
                  children: [
                    Icon(
                      Remix.bank_card_line,
                      size: 40.r,
                      color: AppStyle.textDarkSecondary,
                    ),
                    8.verticalSpace,
                    Text(
                      AppHelpers.getTranslation(TrKeys.noSavedCard),
                      style: AppStyle.interSemi(size: 16.sp),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

            16.verticalSpace,
            if (!_loadingCards) _newCardSection(),
            16.verticalSpace,
            Row(
              children: [Expanded(child: Divider(color: AppStyle.strokeDark))],
            ),
            16.verticalSpace,

            // Receive from a friend: mint a 6-digit claim code the
            // receiver hands to the sender out-of-band
            // (CashSend-style).
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _openReceiveFromFriend,
              icon: const Icon(Remix.arrow_left_down_line),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyle.transparent,
                foregroundColor: AppStyle.primary,
                minimumSize: Size(double.infinity, 50.h),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  side: BorderSide(color: AppStyle.primary),
                ),
              ),
              label: Text(
                AppHelpers.getTranslation('receive_from_a_friend'),
                style: AppStyle.interSemi(size: 16.sp, color: AppStyle.primary),
              ),
            ),

            24.verticalSpace,
          ],
        ),
      ),
    );
    return Directionality(
      textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
      child: KeyboardDismisser(
        child: widget.asSheet ? _sheet(content) : _page(content),
      ),
    );
  }

  Widget _page(Widget content) {
    return Scaffold(
      backgroundColor: AppStyle.surfaceDark,
      appBar: AppBar(
        backgroundColor: AppStyle.surfaceDark,
        elevation: 0,
        iconTheme: IconThemeData(color: AppStyle.textPrimary),
        title: Text(
          AppHelpers.getTranslation(TrKeys.topUpWallet),
          style: AppStyle.interSemi(size: 18.sp, color: AppStyle.textPrimary),
        ),
      ),
      body: SafeArea(child: content),
    );
  }

  /// The sheet chrome, matching the Send sheet: rounded top, drag handle,
  /// the title in the sheet, and the keyboard inset so the amount field
  /// stays above the keyboard.
  Widget _sheet(Widget content) {
    return Container(
      decoration: BoxDecoration(
        color: AppStyle.surfaceDark,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
      ),
      width: double.infinity,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          8.verticalSpace,
          Container(
            height: 4.h,
            width: 48.w,
            decoration: BoxDecoration(
              color: AppStyle.dragElement,
              borderRadius: BorderRadius.all(Radius.circular(40.r)),
            ),
          ),
          16.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: TitleAndIcon(
              title: AppHelpers.getTranslation(TrKeys.topUpWallet),
              paddingHorizontalSize: 0,
              titleSize: 18,
              titleColor: AppStyle.textPrimary,
            ),
          ),
          Flexible(child: SafeArea(top: false, child: content)),
        ],
      ),
    );
  }
}

/// SDK-owned saved-card row (see the port-deltas header for why this is
/// not `EmbeddedWidgets.I.savedCardsWidget`). Tap selects; tapping the
/// selected card deselects it.
class _SavedCardTile extends StatelessWidget {
  const _SavedCardTile({
    required this.card,
    required this.selected,
    required this.onTap,
  });

  final SavedCardModel card;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: AppStyle.cardDark,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: selected ? AppStyle.primary : AppStyle.strokeDark,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Remix.bank_card_line,
                color: selected ? AppStyle.primary : AppStyle.textDarkSecondary,
              ),
              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${card.cardType} •••• ${card.lastFour}',
                      style: AppStyle.interSemi(size: 14.sp),
                    ),
                    if (card.expiryDate.isNotEmpty)
                      Text(
                        card.expiryDate,
                        style: AppStyle.interNormal(
                          size: 12.sp,
                          color: AppStyle.textDarkSecondary,
                        ),
                      ),
                  ],
                ),
              ),
              if (selected)
                Icon(Remix.checkbox_circle_fill, color: AppStyle.primary, size: 20.r),
            ],
          ),
        ),
      ),
    );
  }
}
