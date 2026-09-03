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

// The profile wallet card, re-homed: wallet_sdk (the SDK that owns the
// wallet ledger, top-up flow and CashSend transfer flows) now registers
// the shared wallet balance card with base_sdk's profile host, instead of
// each home SDK composing its own copy. The card itself is base_sdk's
// [BaseWalletCard] (>= 1.32.0; the data-override param is `wallet` since
// 1.33.0) — this SDK contributes the section registration, the navigation
// (history / top-up), the Send sheet, and a small static config seam so a
// home SDK can adapt the card without importing wallet_sdk symbols at
// build time (ADR-005: feature SDKs must not import each other — home
// SDKs configure this seam from their own di_hooks, which run in the
// composed host where every installed SDK is importable).

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:base_sdk/src/models/data/profile_data.dart';
import 'package:base_sdk/src/presentation/components/buttons/second_button.dart';
import 'package:base_sdk/src/presentation/pages/profile/profile_section.dart';
import 'package:base_sdk/src/presentation/pages/profile/profile_section_registry.dart';
import 'package:base_sdk/src/presentation/pages/profile/widgets/base_wallet_card.dart';
import 'package:base_sdk/src/presentation/theme/app_style.dart';
import 'package:base_sdk/src/services/app_helpers.dart';
import 'package:base_sdk/src/services/local_storage.dart';
import 'package:base_sdk/src/services/tr_keys.dart';

import 'package:wallet_sdk/src/common/presentation/pages/send/wallet_send_screen.dart';

/// Static configuration seam for the 'wallet.card' profile section.
///
/// Set fields BEFORE [register] runs (di_hooks run in manifest `order`, so
/// a home SDK that wants to reconfigure the card uses a lower order than
/// wallet_sdk's hook), or simply before the profile page next mounts — the
/// section builder and gate read the current values on every build.
class WalletCardSection {
  WalletCardSection._();

  /// Section identity in base_sdk's [ProfileSectionRegistry].
  static const String sectionId = 'wallet.card';

  /// Render position among profile sections (marketplace's wallet card sat
  /// at order 120 — base 100 + 20 — so composed pages keep their layout).
  static const int sectionOrder = 120;

  /// Visibility gate for the whole section, resolved once per page mount
  /// ([ProfileSection.visible] contract: `false` or a throw hides it).
  /// Default: a signed-in user (stored auth token present) — a guest has
  /// no wallet to show. Assign a sync-completing or async closure to
  /// override.
  static Future<bool> Function() visible = _defaultVisible;

  static Future<bool> _defaultVisible() async =>
      LocalStorage.getToken().isNotEmpty;

  /// Currency symbol passed through to [BaseWalletCard.symbol] for hosts
  /// with no stored currency (e.g. lms). Null (default) keeps the
  /// stored-currency formatting.
  static String? symbol;

  /// Extra action buttons appended after the built-in Top-up / Send pair
  /// (each rides the card's action [Row] — wrap wide buttons in
  /// [Expanded], matching the built-ins). This is the injection seam for
  /// home-SDK-specific actions: e.g. marketplace's Loan button (behind
  /// `AppHelpers.getLendingEnabled()`, opening
  /// `EmbeddedWidgets.I.loanScreen()`) belongs to the lending surface, so
  /// marketplace injects it here rather than wallet_sdk hardcoding it.
  static List<Widget> Function(BuildContext context)? extraActions;

  /// `false` renders a display-only card: no Top-up / Send strip and no
  /// [extraActions] (the balance line and history arrow stay). Meant for
  /// profiles that only surface the balance — e.g. the restaurant/seller
  /// profile.
  static bool showActions = true;

  /// Registers the 'wallet.card' section with base_sdk's
  /// [ProfileSectionRegistry] (first-wins per id; idempotent by the
  /// registry's own duplicate-drop). Called at boot by this SDK's
  /// `di_hooks` manifest entry via `registerWalletProfileSection()` in the
  /// installed wallet_route_pages.dart.
  static void register() {
    ProfileSectionRegistry.I.register(ProfileSection(
      id: sectionId,
      order: sectionOrder,
      visible: () => visible(),
      builder: (context) => const WalletProfileCard(),
    ));
  }
}

/// The wallet section's widget: base_sdk's [BaseWalletCard] (self-sourcing
/// profileProvider → LocalStorage; hides the amount at zero balance, green
/// positive / red negative) composed with wallet_sdk's own surfaces —
/// history arrow → the /wallet-history route, Top-up → the /wallet-topup
/// route (both this SDK's manifest routes, pushed by path with the same
/// guarded idiom as lms_sdk's top-up door: a shell composed without the
/// route lands in onFailure/catch and stays put), Send → the ported
/// CashSend send sheet.
class WalletProfileCard extends StatelessWidget {
  /// Optional wallet snapshot passed through to [BaseWalletCard.wallet]
  /// (base_sdk >= 1.33.0's rename of the old `override` param): non-null
  /// renders as-is and never watches the live provider — the same
  /// testability seam as the base card's own.
  final Wallet? wallet;

  const WalletProfileCard({super.key, this.wallet});

  void _pushGuarded(BuildContext context, String path) {
    try {
      context.router.pushNamed(
        path,
        onFailure: (failure) =>
            debugPrint('==> wallet route $path unavailable: $failure'),
      );
    } catch (e) {
      debugPrint('==> wallet route $path unavailable: $e');
    }
  }

  void _openSendSheet(BuildContext context) {
    AppHelpers.showCustomModalBottomSheet(
      context: context,
      modal: ProviderScope(
        child: Consumer(
          builder: (context, ref, _) => const WalletSendScreen(),
        ),
      ),
      isDarkMode: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BaseWalletCard(
          wallet: wallet,
          symbol: WalletCardSection.symbol,
          onHistory: () => _pushGuarded(context, '/wallet-history'),
          actions: WalletCardSection.showActions
              ? [
                  Expanded(
                    child: SecondButton(
                      title: AppHelpers.getTranslation(TrKeys.topup),
                      bgColor: AppStyle.primary,
                      titleColor: AppStyle.white,
                      onTap: () => _pushGuarded(context, '/wallet-topup'),
                    ),
                  ),
                  12.horizontalSpace,
                  Expanded(
                    child: SecondButton(
                      title: AppHelpers.getTranslation(TrKeys.send),
                      bgColor: AppStyle.primary,
                      titleColor: AppStyle.white,
                      onTap: () => _openSendSheet(context),
                    ),
                  ),
                  ...?WalletCardSection.extraActions?.call(context),
                ]
              : const [],
        ),
        15.verticalSpace,
      ],
    );
  }
}
