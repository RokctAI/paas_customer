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

// compliance-ignore-file: flutter-http-timeout (test double: no network)

// Card auto-billing in the top-up page (Ray, 2026-10-17): the consent
// shows only once the payer ticks "save this card", the server is asked to
// save the card only then (with the consent version), and the wallet is
// reported topped up only when the server says the checkout is Paid.

import 'dart:convert';
import 'dart:io';

import 'package:base_sdk/src/di/injection.dart';
import 'package:base_sdk/src/domain/interface/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wallet_sdk/src/common/infrastructure/repositories/card_billing_api.dart';
import 'package:wallet_sdk/src/common/infrastructure/repositories/wallet_repository.dart';
import 'package:wallet_sdk/src/common/presentation/pages/cards/card_checkout_page.dart';
import 'package:wallet_sdk/src/common/presentation/pages/topup/wallet_topup_page.dart';
import 'package:wallet_sdk/src/common/translations/wallet_translations.dart';

class _FakeApi extends CardBillingApi {
  _FakeApi(this.statuses);

  final List<String> statuses;
  final starts = <Map<String, Object?>>[];
  int polls = 0;

  @override
  Future<List<WalletSavedCard>> savedCards() async => const [];

  @override
  Future<CardCheckout> startCheckout({
    required double amount,
    required bool saveCard,
  }) async {
    starts.add({'amount': amount, 'save': saveCard});
    return const CardCheckout(
      transaction: 'TRA-1',
      gateway: 'PayFast',
      returnUrl: 'https://site/?card_checkout=done&tx=TRA-1',
      cancelUrl: 'https://site/?card_checkout=cancelled&tx=TRA-1',
      formAction: 'https://sandbox.payfast.co.za/eng/process',
    );
  }

  @override
  Future<CardCheckoutStatus> checkoutStatus(String transaction) async {
    final status = statuses[polls < statuses.length ? polls : statuses.length - 1];
    polls++;
    return CardCheckoutStatus(status: status, cardSaved: status == 'Paid');
  }
}

void main() {
  setUp(() {
    if (!getIt.isRegistered<WalletRepositoryFacade>()) {
      getIt.registerSingleton<WalletRepositoryFacade>(WalletRepository());
    }
  });

  Future<void> pump(WidgetTester tester, _FakeApi api, {String? outcome = 'done'}) async {
    tester.view.physicalSize = const Size(375, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(ProviderScope(
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (_, __) => MaterialApp(
          home: WalletTopUpPage(
            cardBilling: api,
            openCheckout: (_, __) async => outcome,
            pollEvery: Duration.zero,
            pollTries: 3,
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('consent text shows only once save-card is ticked', (tester) async {
    await pump(tester, _FakeApi(['Paid']));
    expect(find.byKey(const ValueKey('card-consent-text')), findsNothing);
    await tester.tap(find.byKey(const ValueKey('save-card-consent')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('card-consent-text')), findsOneWidget);
  });

  testWidgets('a plain new-card top-up does not ask to save the card', (tester) async {
    final api = _FakeApi(['Pending', 'Paid']);
    await pump(tester, api);
    await tester.enterText(find.byType(TextField), '150');
    await tester.tap(find.byKey(const ValueKey('pay-with-new-card')));
    await tester.pumpAndSettle();
    expect(api.starts, [
      {'amount': 150.0, 'save': false}
    ]);
    // Polled until the server said Paid.
    expect(api.polls, 2);
  });

  testWidgets('ticking the consent saves the card', (tester) async {
    final api = _FakeApi(['Paid']);
    await pump(tester, api);
    await tester.enterText(find.byType(TextField), '200');
    await tester.tap(find.byKey(const ValueKey('save-card-consent')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('pay-with-new-card')));
    await tester.pumpAndSettle();
    expect(api.starts.single['save'], true);
  });

  testWidgets('a cancelled checkout does not poll', (tester) async {
    final api = _FakeApi(['Paid']);
    await pump(tester, api, outcome: 'cancelled');
    await tester.enterText(find.byType(TextField), '50');
    await tester.tap(find.byKey(const ValueKey('pay-with-new-card')));
    await tester.pumpAndSettle();
    expect(api.polls, 0);
  });

  test('PayFast form is escaped and posts the signed fields as given', () {
    final html = payFastAutoSubmitHtml(
      'https://sandbox.payfast.co.za/eng/process',
      {'item_name': 'Top-up "R50" <b>', 'signature': 'abc'},
    );
    expect(html, contains('method="POST"'));
    expect(html, contains('name="signature" value="abc"'));
    expect(html, isNot(contains('<b>')));
    expect(html, contains('&quot;R50&quot;'));
  });

  test('return, cancel and the Paystack callback end the checkout', () {
    const checkout = CardCheckout(
      transaction: 'T',
      gateway: 'PayStack',
      returnUrl: 'https://site/?card_checkout=done&tx=T',
      cancelUrl: 'https://site/?card_checkout=cancelled&tx=T',
    );
    expect(checkoutOutcomeFor('https://site/?card_checkout=done&tx=T', checkout), 'done');
    expect(checkoutOutcomeFor('https://site/?card_checkout=cancelled&tx=T', checkout),
        'cancelled');
    expect(
        checkoutOutcomeFor(
            'https://site/api/v1/method/x.api.payment.handle_paystack_callback?reference=r',
            checkout),
        'done');
    expect(checkoutOutcomeFor('https://checkout.paystack.com/abc', checkout), isNull);
  });

  test('the consent copy says automatic, no reminder, and how to remove', () {
    final text = kWalletEnTranslations[WalletTrKeys.cardRenewalConsent]!.toLowerCase();
    expect(text, contains('automatically'));
    expect(text, contains('not get a reminder'));
    expect(text, contains('remove this card'));
    expect(kCardConsentVersion, '2026-10-17');
  });

  test('every wallet key is declared in the manifest and has English', () {
    final manifest =
        jsonDecode(File('manifest.json').readAsStringSync()) as Map<String, dynamic>;
    final declared = (manifest['tr_keys'] as Map).values.toSet();
    for (final key in const [
      WalletTrKeys.payWithANewCard,
      WalletTrKeys.saveCardForRenewals,
      WalletTrKeys.cardRenewalConsent,
      WalletTrKeys.cardCheckoutTitle,
      WalletTrKeys.cardCheckoutWaiting,
      WalletTrKeys.cardCheckoutCancelled,
      WalletTrKeys.cardCheckoutFailed,
      WalletTrKeys.cardSavedForRenewals,
      WalletTrKeys.savedCards,
      WalletTrKeys.removeCard,
      WalletTrKeys.removeCardConfirm,
      WalletTrKeys.cardRemoved,
      WalletTrKeys.renewsAutomatically,
      WalletTrKeys.transactionDetails,
      WalletTrKeys.reference,
      WalletTrKeys.transactionType,
      WalletTrKeys.status,
    ]) {
      expect(declared, contains(key));
      expect(kWalletEnTranslations[key], isNotNull, reason: key);
    }
    final hooks = (manifest['boot_hooks'] as List).cast<Map>();
    expect(hooks.any((h) => '${h['body']}'.contains('kWalletEnTranslations')), isTrue);
  });
}
