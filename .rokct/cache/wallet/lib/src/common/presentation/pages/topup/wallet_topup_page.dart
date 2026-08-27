// Copyright (c) 2026 ROKCT INTELLIGENCE (PTY) LTD
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

// compliance-ignore-file: flutter-http-timeout (all HTTP rides base_sdk's
// PlatformGateway Dio, whose BaseOptions set connect/receive timeouts
// centrally; no HTTP client is created in this file)

// Wallet top-up screen, ported from commerce/marketplace's finished
// WalletTopUpScreen (#33): amount presets, a saved-card picker, token
// top-up, and the redirect-URL branch for a new card.
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
//     donor's call would throw. `payFastWebView` (the redirect branch) IS
//     still reached through EmbeddedWidgets, guarded, because a WebView
//     stack is host plumbing this SDK should not own; a shell without it
//     degrades to a friendly message.
//   * Student-facing errors are one friendly line; the detail goes to
//     [TelemetryClient] (#56 standing rule). The donor put raw `$error`
//     text on screen.

import 'dart:async';

import 'package:base_sdk/src/di/injection.dart';
import 'package:base_sdk/src/handlers/api_result.dart';
import 'package:base_sdk/src/handlers/platform_gateway.dart';
import 'package:base_sdk/src/models/data/saved_card.dart';
import 'package:base_sdk/src/navigation/embedded_widgets.dart';
import 'package:base_sdk/src/presentation/components/keyboard_dismisser.dart';
import 'package:base_sdk/src/presentation/components/title_icon.dart';
import 'package:base_sdk/src/presentation/theme/theme.dart';
import 'package:base_sdk/src/services/app_helpers.dart';
import 'package:base_sdk/src/services/local_storage.dart';
import 'package:base_sdk/src/services/telemetry.dart';
import 'package:base_sdk/src/services/tr_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WalletTopUpPage extends StatefulWidget {
  const WalletTopUpPage({super.key});

  @override
  State<WalletTopUpPage> createState() => _WalletTopUpPageState();
}

class _WalletTopUpPageState extends State<WalletTopUpPage> {
  static const _gateway = PlatformGateway();

  final _amountController = TextEditingController();
  final _walletRepository = walletRepository;
  bool _isLoading = false;
  bool _loadingCards = true;
  List<SavedCardModel> _savedCards = [];
  SavedCardModel? _selectedCard;

  // Predefined amount options for quick selection (donor's presets).
  final List<double> _amountOptions = [50, 100, 200, 500, 1500, 2000];

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
      // returns a bare list of card rows (name/gateway/token/last_four/
      // card_type/expiry_date/card_holder_name).
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
                    token: e['token']?.toString() ?? '',
                    lastFour: e['last_four']?.toString() ?? '',
                    cardType: e['card_type']?.toString() ?? 'Card',
                    expiryDate: e['expiry_date']?.toString() ?? '',
                    cardHolderName: e['card_holder_name']?.toString() ?? '',
                  ),
                )
                .toList()
          : <SavedCardModel>[];
      if (!mounted) return;
      setState(() {
        _savedCards = cards;
        _loadingCards = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingCards = false;
      });
      // Cards failing to load is not fatal — the new-card path still
      // works — so no snackbar, telemetry only.
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

  // Process top-up with saved card token.
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
      final result = await _walletRepository.walletTopUp(
        amount: amount,
        token: card.token,
      );

      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });

      result.when(
        success: (data) {
          if (!mounted) return;
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

  // Process top-up with a new card (redirect-URL branch).
  Future<void> _topUpWithNewCard() async {
    final amount = _validAmount();
    if (amount == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _walletRepository.walletTopUp(amount: amount);

      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });

      result.when(
        success: (data) {
          if (!mounted) return;
          if (data is String && data.isNotEmpty) {
            _openRedirect(data);
          } else {
            // Direct success (unlikely for a new card, but possible if the
            // gateway completes without a redirect).
            _loadSavedCards();
            AppHelpers.showCheckTopSnackBarDone(
              context,
              AppHelpers.getTranslation(TrKeys.topUpSuccessful),
            );
            _navigateBack();
          }
        },
        failure: (error, statusCode) => _failFriendly(
          TrKeys.somethingWentWrongWithTheServer,
          'wallet_topup_new_card_failed',
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
        'wallet_topup_new_card_failed',
        e,
      );
    }
  }

  /// The gateway answered with a hosted card-capture URL. The WebView is
  /// host plumbing reached through [EmbeddedWidgets]; a shell composed
  /// without one lands in the catch and shows a friendly line.
  void _openRedirect(String url) {
    try {
      final webView = EmbeddedWidgets.I.payFastWebView(
        url: url,
        onComplete: (success) {
          if (!mounted) return;
          if (success) {
            _loadSavedCards();
            AppHelpers.showCheckTopSnackBarDone(
              context,
              AppHelpers.getTranslation(TrKeys.topUpSuccessful),
            );
            _navigateBack();
          }
        },
      );
      Navigator.push(context, MaterialPageRoute(builder: (_) => webView));
    } catch (e) {
      _failFriendly(
        TrKeys.somethingWentWrongWithTheServer,
        'wallet_topup_webview_unavailable',
        e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLtr = LocalStorage.getLangLtr();
    return Directionality(
      textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
      child: KeyboardDismisser(
        child: Scaffold(
          backgroundColor: AppStyle.bgGrey,
          appBar: AppBar(
            backgroundColor: AppStyle.bgGrey,
            elevation: 0,
            iconTheme: IconThemeData(color: AppStyle.black),
            title: Text(
              AppHelpers.getTranslation(TrKeys.topUpWallet),
              style: AppStyle.interSemi(size: 18.sp, color: AppStyle.black),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
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
                            'R',
                            style: AppStyle.interBold(size: 18.sp),
                          ),
                        ),
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 0,
                          minHeight: 0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: const BorderSide(
                            color: AppStyle.borderColor,
                          ),
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
                              color: AppStyle.white,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(color: AppStyle.borderColor),
                              boxShadow: [
                                BoxShadow(
                                  color: AppStyle.black.withValues(alpha: 0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              'R ${amount.toStringAsFixed(2)}',
                              style: AppStyle.interNormal(size: 14.sp),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    24.verticalSpace,

                    // Saved Cards Section
                    if (_loadingCards)
                      Center(
                        child: CircularProgressIndicator(
                          color: AppStyle.primary,
                        ),
                      )
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
                                  AppHelpers.getTranslation(
                                    TrKeys.payWithSavedCard,
                                  ),
                                  style: AppStyle.interSemi(
                                    size: 16.sp,
                                    color: AppStyle.white,
                                  ),
                                ),
                        ),
                      4.verticalSpace,
                      const Row(
                        children: [
                          Expanded(child: Divider(color: AppStyle.black)),
                        ],
                      ),
                      4.verticalSpace,
                    ],

                    // Pay with new card button
                    ElevatedButton(
                      onPressed: _isLoading ? null : _topUpWithNewCard,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _savedCards.isNotEmpty
                            ? AppStyle.transparent
                            : AppStyle.primary,
                        foregroundColor: _savedCards.isNotEmpty
                            ? AppStyle.primary
                            : AppStyle.white,
                        minimumSize: Size(double.infinity, 50.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          side: _savedCards.isNotEmpty
                              ? BorderSide(color: AppStyle.primary)
                              : BorderSide.none,
                        ),
                        elevation: _savedCards.isNotEmpty ? 0 : 2,
                      ),
                      child: _isLoading
                          ? SizedBox(
                              height: 20.h,
                              width: 20.w,
                              child: CircularProgressIndicator(
                                color: _savedCards.isNotEmpty
                                    ? AppStyle.primary
                                    : AppStyle.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              _savedCards.isNotEmpty
                                  ? AppHelpers.getTranslation(
                                      TrKeys.payWithNewCard,
                                    )
                                  : AppHelpers.getTranslation(TrKeys.topUpNow),
                              style: AppStyle.interSemi(
                                size: 16.sp,
                                color: _savedCards.isNotEmpty
                                    ? AppStyle.primary
                                    : AppStyle.white,
                              ),
                            ),
                    ),

                    24.verticalSpace,
                    Center(
                      child: Text(
                        AppHelpers.getTranslation(TrKeys.cardWillBeSaved),
                        style: AppStyle.interNormal(
                          size: 12.sp,
                          color: AppStyle.textGrey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    24.verticalSpace,
                  ],
                ),
              ),
            ),
          ),
        ),
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
            color: AppStyle.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: selected ? AppStyle.primary : AppStyle.borderColor,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.credit_card,
                color: selected ? AppStyle.primary : AppStyle.textGrey,
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
                          color: AppStyle.textGrey,
                        ),
                      ),
                  ],
                ),
              ),
              if (selected)
                Icon(Icons.check_circle, color: AppStyle.primary, size: 20.r),
            ],
          ),
        ),
      ),
    );
  }
}
