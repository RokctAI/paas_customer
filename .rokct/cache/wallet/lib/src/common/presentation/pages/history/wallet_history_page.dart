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

// Ported from commerce marketplace_sdk's WalletHistoryPage as part of
// re-homing the wallet card into wallet_sdk (the transaction list behind
// the card's history arrow, now this SDK's /wallet-history route). The
// donor already read only base_sdk symbols (profileProvider's
// getWallet/getWalletPage drive the list). Port deltas, on purpose:
//   * The app bar's Top-up button pushes this SDK's /wallet-topup route
//     (guarded, lms_sdk's idiom) instead of the marketplace top-up sheet —
//     wallet_sdk's WalletTopUpPage is the finished port of that sheet.
//   * The Send button opens this SDK's ported WalletSendScreen.
//   * The Loan button stays behind AppHelpers.getLendingEnabled(), but
//     resolves EmbeddedWidgets.I.loanScreen() inside a guard: a shell that
//     enables lending without registering the embedded loan screen logs
//     and stays put instead of throwing mid-build.
//   * No @RoutePage annotation here — the host-side shell in the installed
//     wallet_route_pages.dart carries it (this SDK's convention, same as
//     WalletTopUpPage).

import 'package:auto_route/auto_route.dart';
import 'package:base_sdk/src/navigation/embedded_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:base_sdk/src/application/profile/profile_notifier.dart';
import 'package:base_sdk/src/application/profile/profile_provider.dart';
import 'package:base_sdk/src/application/profile/profile_state.dart';
import 'package:base_sdk/src/models/response/wallet_histories_response.dart';
import 'package:base_sdk/src/services/app_helpers.dart';
import 'package:base_sdk/src/services/demo_session.dart';
import 'package:base_sdk/src/services/local_storage.dart';
import 'package:base_sdk/src/services/tr_keys.dart';
import 'package:base_sdk/src/presentation/components/app_bars/common_app_bar.dart';
import 'package:base_sdk/src/presentation/components/badges.dart';
import 'package:intl/intl.dart' as intl;
import 'package:base_sdk/src/presentation/components/floating_nav/floating_bottom_nav.dart';
import 'package:remixicon/remixicon.dart';
import 'package:base_sdk/src/presentation/components/buttons/second_button.dart';
import 'package:base_sdk/src/presentation/components/loading.dart';
import 'package:base_sdk/src/presentation/theme/app_style.dart';

import 'package:wallet_sdk/src/common/infrastructure/repositories/demo_wallet_history.dart';
import 'package:wallet_sdk/src/common/presentation/pages/send/wallet_send_screen.dart';

// Capitalize helper carried over from the donor.
extension StringExtension on String {
  String capitalize() {
    return isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';
  }
}

class WalletHistoryPage extends ConsumerStatefulWidget {
  final bool isBackButton;
  const WalletHistoryPage({super.key, this.isBackButton = true});

  @override
  ConsumerState<WalletHistoryPage> createState() => _WalletHistoryState();
}

class _WalletHistoryState extends ConsumerState<WalletHistoryPage> {
  late RefreshController controller;
  late ProfileState state;
  late ProfileNotifier event;
  final bool isLtr = LocalStorage.getLangLtr();

  @override
  void initState() {
    controller = RefreshController();
    // A demo session talks to no backend: the seeded rows render instead
    // of asking the repository (see DemoWalletHistory), so no fetch here.
    // Read at the moment the decision is taken, never stored on the state:
    // DemoSession.demoActive is the tour build OR a live demo session, and
    // the session half can be activated by a sign-in at any point.
    if (!DemoSession.demoActive) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(profileProvider.notifier).getWallet(context);
      });
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    event = ref.read(profileProvider.notifier);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _openTopUp() {
    try {
      context.router.pushNamed(
        '/wallet-topup',
        onFailure: (failure) =>
            debugPrint('==> wallet top-up route unavailable: $failure'),
      );
    } catch (e) {
      debugPrint('==> wallet top-up route unavailable: $e');
    }
  }

  void _openSendSheet() {
    AppHelpers.showCustomModalBottomSheet(
      context: context,
      modal: ProviderScope(
        child: Consumer(
          builder: (context, ref, _) => const WalletSendScreen(),
        ),
      ),
      isDarkMode: AppStyle.isDark,
    );
  }

  void _openLoanSheet() {
    // Guarded: the loan screen is host plumbing reached through
    // EmbeddedWidgets; a shell composed without it logs and stays put.
    final Widget loan;
    try {
      loan = EmbeddedWidgets.I.loanScreen();
    } catch (e) {
      debugPrint('==> loan screen unavailable: $e');
      return;
    }
    AppHelpers.showCustomModalBottomSheet(
      context: context,
      modal: ProviderScope(child: loan),
      isDarkMode: AppStyle.isDark,
    );
  }

  @override
  Widget build(BuildContext context) {
    state = ref.watch(profileProvider);
    // Re-read every build, never cached on the state: a sign-in that
    // activates the demo session after this page mounted has to be seen by
    // the next frame. Bound to one local per build so the rows and the
    // spinner below cannot disagree within a frame.
    final bool demoActive = DemoSession.demoActive;
    // The rows on screen: the demo seed in a demo session, else whatever
    // the notifier fetched. Bound once so the list and its empty state
    // agree.
    final List<WalletData> history = demoActive
        ? DemoWalletHistory.entries()
        : (state.walletHistory ?? const <WalletData>[]);
    // `isLoadingHistory` defaults to true and is only cleared by the fetch
    // a demo session skips above, so a demo session must ignore it or the
    // page spins forever over rows it already has.
    final bool showLoading = state.isLoadingHistory && !demoActive;
    return Directionality(
      textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppStyle.surfaceDark,
        body: Stack(
          children: [
            Column(
              children: [
                CommonAppBar(
                  child: Column(
                    children: [
                      // Flexible, not a fixed spacer: CommonAppBar's box is
                      // 76.h plus the status-bar inset less 20.h of bottom
                      // padding, so a rigid 55.h here leaves the row only
                      // (1.h + inset) of room. Wherever ScreenUtil scales
                      // 1:1 (any window >= 600 dp wide - the tour's tablet
                      // leg) that is 25 dp for a 35 dp row: the 10 px
                      // BOTTOM OVERFLOWED stripe. Flexible keeps the full
                      // 55.h wherever it fits (phones are pixel-identical)
                      // and yields only the shortfall elsewhere.
                      Flexible(child: 55.verticalSpace),
                      Row(
                        children: [
                          10.horizontalSpace,
                          Text(
                            AppHelpers.getTranslation(TrKeys.transactions),
                            style: AppStyle.interNoSemi(
                              size: 18,
                              color: AppStyle.textPrimary,
                            ),
                          ),
                          5.horizontalSpace,
                          SecondButton(
                            title: AppHelpers.getTranslation(TrKeys.topup),
                            bgColor: AppStyle.primary,
                            titleColor: AppStyle.white,
                            titleSize: 12.sp,
                            onTap: _openTopUp,
                          ),
                          5.horizontalSpace,
                          SecondButton(
                            title: AppHelpers.getTranslation(TrKeys.send),
                            bgColor: AppStyle.primary,
                            titleColor: AppStyle.white,
                            titleSize: 12.sp,
                            onTap: _openSendSheet,
                          ),
                          if (AppHelpers.getLendingEnabled()) ...[
                            5.horizontalSpace,
                            SecondButton(
                              title: AppHelpers.getTranslation(TrKeys.loan),
                              bgColor: AppStyle.primary,
                              titleColor: AppStyle.white,
                              titleSize: 12.sp,
                              onTap: _openLoanSheet,
                            ),
                          ],
                          5.horizontalSpace,
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: showLoading
                      ? const Center(child: Loading())
                      : state.isEmptyWallet || history.isEmpty
                          ? _resultEmpty()
                          : SmartRefresher(
                              enablePullDown: true,
                              enablePullUp: true,
                              physics: const BouncingScrollPhysics(),
                              controller: controller,
                              onLoading: () {
                                // Read per gesture, not captured when the
                                // closure was built.
                                if (DemoSession.demoActive) {
                                  controller.loadNoData();
                                  return;
                                }
                                event.getWalletPage(context, controller);
                              },
                              onRefresh: () {
                                // Read per gesture, not captured when the
                                // closure was built.
                                if (DemoSession.demoActive) {
                                  controller.refreshCompleted();
                                  return;
                                }
                                event.getWallet(context,
                                    refreshController: controller);
                              },
                              child: ListView.builder(
                                padding: EdgeInsets.all(16.r),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemCount: history.length,
                                itemBuilder: (context, index) => Container(
                                  margin: EdgeInsets.only(bottom: 16.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.r),
                                    color:
                                        history[index].type == "topup"
                                            ? Colors.green.withValues(alpha: 0.5)
                                            : history[index].type ==
                                                    "withdraw"
                                                ? AppStyle.red.withValues(alpha: 0.5)
                                                : AppStyle.cardDark,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: 16.r,
                                          right: 16.r,
                                          left: 16.r,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${AppHelpers.getTranslation(TrKeys.paymentDate)}: ${intl.DateFormat("MMM dd,yyyy h:mm a").format(DateTime.tryParse(history[index].createdAt ?? "")?.toLocal() ?? DateTime.now())}",
                                              style: AppStyle.interRegular(
                                                size: 12.sp,
                                                color: AppStyle.textPrimary,
                                              ),
                                            ),
                                            4.verticalSpace,
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: "Ref: ",
                                                    style: AppStyle.interBold(
                                                      size: 16.sp,
                                                      color: AppStyle.textPrimary,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: history[index]
                                                            .note ??
                                                        "",
                                                    style: AppStyle.interRegular(
                                                      size: 16.sp,
                                                      color: AppStyle.textPrimary,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(color: AppStyle.strokeDark),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          bottom: 16.r,
                                          right: 16.r,
                                          left: 16.r,
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  "Transaction type: ",
                                                  style: AppStyle.interRegular(
                                                    size: 12.sp,
                                                    color: AppStyle.textPrimary,
                                                  ),
                                                ),
                                                Text(
                                                  AppHelpers.numberFormat(
                                                    number: history[index]
                                                        .price,
                                                  ),
                                                  style: AppStyle.interBold(
                                                    size: 16.sp,
                                                    color: AppStyle.textPrimary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  (history[index]
                                                              .type ??
                                                          "")
                                                      .capitalize(),
                                                  style: AppStyle.interBold(
                                                    size: 12.sp,
                                                    color: AppStyle.textPrimary,
                                                  ),
                                                ),
                                                Text(
                                                  'Status: ${(history[index].status ?? "").capitalize()}',
                                                  style: AppStyle.interRegular(
                                                    size: 12.sp,
                                                    color: AppStyle.textPrimary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                ),
              ],
            ),
            // The floating nav's back-only pill (FloatingNavBack, core#125 — design
            // strip section 12's one-back rule): the shared pill housing carrying
            // only the leading back segment, this screen's ONE back affordance,
            // replacing the standalone PopButton. Back-only (empty tab list)
            // because the host app's root tabs are not reachable from this SDK
            // package's pushed route. Embedded hosts that pass isBackButton: false
            // still render no back at all.
            if (widget.isBackButton)
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FloatingBottomNav(
                    mode: FloatingNavTabsMode(
                      tabs: const [],
                      currentIndex: 0,
                      onSelect: (_) {},
                      back: FloatingNavBack(
                        icon: Remix.arrow_left_wide_fill,
                        label: AppHelpers.getTranslation(TrKeys.back),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _resultEmpty() {
    return EmptyBadge(
      subtitleText: "Your Transaction History will appear here",
      titleText: "No Transactions",
    );
  }
}
