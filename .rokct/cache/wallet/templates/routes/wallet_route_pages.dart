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

// Host-side route shells + profile-host wiring for wallet_sdk (#33). The
// `/wallet-topup` path this registers is the exact string lms_sdk's
// subscribe surface pushes beside its insufficient-funds refusal
// (agent PR #150: `context.router.pushNamed('/wallet-topup', ...)`), so
// changing it there means changing it here in the same breath.
// `/wallet-history` is the wallet card's history arrow target (pushed by
// path from wallet_sdk's WalletProfileCard, same guarded idiom).

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:wallet_sdk/wallet_sdk.dart';

/// Registers the 'wallet.card' profile section with base_sdk's
/// ProfileSectionRegistry — called once at boot from this SDK's `di_hooks`
/// manifest entry (the same pattern as marketplace_sdk's
/// registerMarketplaceProfileSections). Configuration rides
/// [WalletCardSection]'s static seam; a home SDK that wants to reconfigure
/// the card (symbol, visibility, extra actions, display-only) sets those
/// fields from its own di_hook.
void registerWalletProfileSection() {
  WalletCardSection.register();
}

/// Host route shell for [WalletTopUpPage] (wallet_sdk-resident page).
@RoutePage(name: 'WalletTopUpRoute')
class WalletTopUpRouteView extends StatelessWidget {
  const WalletTopUpRouteView({super.key});

  @override
  Widget build(BuildContext context) => const WalletTopUpPage();
}

/// Host route shell for [WalletHistoryPage] (wallet_sdk-resident page).
/// Constructor keeps the donor page's `isBackButton` param so navigation
/// call-sites that pushed marketplace's page keep working after recompose.
@RoutePage(name: 'WalletHistoryRoute')
class WalletHistoryRouteView extends StatelessWidget {
  final bool isBackButton;

  const WalletHistoryRouteView({super.key, this.isBackButton = true});

  @override
  Widget build(BuildContext context) =>
      WalletHistoryPage(isBackButton: isBackButton);
}
