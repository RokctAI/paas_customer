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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:base_sdk/src/models/data/profile_data.dart';
import 'package:base_sdk/src/presentation/components/buttons/second_button.dart';
import 'package:base_sdk/src/presentation/pages/profile/profile_section_registry.dart';
import 'package:base_sdk/src/presentation/pages/profile/widgets/base_wallet_card.dart';
import 'package:wallet_sdk/wallet_sdk.dart';

Widget _host(Widget child) {
  return ProviderScope(
    child: ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, __) => MaterialApp(
        home: Scaffold(body: SingleChildScrollView(child: child)),
      ),
    ),
  );
}

void main() {
  test('register() puts wallet.card at order 120 in the registry', () {
    WalletCardSection.register();

    final registry = ProfileSectionRegistry.I;
    expect(registry.contains(WalletCardSection.sectionId), isTrue);
    expect(WalletCardSection.sectionId, 'wallet.card');

    final section = registry.sections
        .firstWhere((s) => s.id == WalletCardSection.sectionId);
    expect(section.order, 120);
    expect(section.visible, isNotNull);
  });

  test('default visibility gate hides the card while signed out', () async {
    // Idempotent re-register (the registry drops the duplicate id).
    WalletCardSection.register();
    // No LocalStorage.init() ran, so getToken() serves the signed-out ''.
    final section = ProfileSectionRegistry.I.sections
        .firstWhere((s) => s.id == WalletCardSection.sectionId);
    expect(await section.visible!(), isFalse);
  });

  testWidgets('card composes BaseWalletCard with Top-up and Send actions',
      (tester) async {
    await tester.pumpWidget(
      _host(WalletProfileCard(wallet: Wallet(price: 250))),
    );

    expect(find.byType(BaseWalletCard), findsOneWidget);
    // The built-in action pair (Top-up, Send).
    expect(find.byType(SecondButton), findsNWidgets(2));
  });

  testWidgets('extraActions are appended after the built-in pair',
      (tester) async {
    WalletCardSection.extraActions =
        (context) => [const SizedBox(key: Key('extra-action'))];
    addTearDown(() => WalletCardSection.extraActions = null);

    await tester.pumpWidget(
      _host(WalletProfileCard(wallet: Wallet(price: 250))),
    );

    expect(find.byType(SecondButton), findsNWidgets(2));
    expect(find.byKey(const Key('extra-action')), findsOneWidget);
  });

  testWidgets('showActions=false renders a display-only card',
      (tester) async {
    WalletCardSection.showActions = false;
    addTearDown(() => WalletCardSection.showActions = true);

    await tester.pumpWidget(
      _host(WalletProfileCard(wallet: Wallet(price: 250))),
    );

    expect(find.byType(BaseWalletCard), findsOneWidget);
    expect(find.byType(SecondButton), findsNothing);
  });
}
