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

// compliance-ignore-file: flutter-http-timeout (test double: Dio uses a scripted in-memory adapter, no real network)

// The top-up page starts on the user's default saved card, and offers
// "Pay with a new card" (the gateway's own card page) with or without
// saved cards.

import 'dart:convert';
import 'dart:typed_data';

import 'package:base_sdk/src/di/injection.dart';
import 'package:base_sdk/src/domain/interface/wallet.dart';
import 'package:base_sdk/src/handlers/http_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wallet_sdk/src/common/infrastructure/repositories/wallet_repository.dart';
import 'package:wallet_sdk/src/common/presentation/pages/topup/wallet_topup_page.dart';

class _FakeHttpService implements HttpService {
  _FakeHttpService(this.cards);

  final List<Map<String, Object?>> cards;

  @override
  Dio client({bool requireAuth = false, bool routing = false}) =>
      Dio(BaseOptions(baseUrl: 'https://unit.test'))
        ..httpClientAdapter = _CardsAdapter(cards);
}

class _CardsAdapter implements HttpClientAdapter {
  _CardsAdapter(this.cards);

  final List<Map<String, Object?>> cards;

  @override
  Future<ResponseBody> fetch(RequestOptions options,
          Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async =>
      ResponseBody.fromString(jsonEncode(cards), 200, headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      });

  @override
  void close({bool force = false}) {}
}

// Any ElevatedButton, including the `.icon` subclass "receive" uses.
final _buttons = find.byWidgetPredicate((w) => w is ElevatedButton);

void main() {
  void install(List<Map<String, Object?>> cards) {
    if (getIt.isRegistered<HttpService>()) getIt.unregister<HttpService>();
    getIt.registerSingleton<HttpService>(_FakeHttpService(cards));
    addTearDown(() => getIt.unregister<HttpService>());
    if (!getIt.isRegistered<WalletRepositoryFacade>()) {
      getIt.registerSingleton<WalletRepositoryFacade>(WalletRepository());
      addTearDown(() => getIt.unregister<WalletRepositoryFacade>());
    }
  }

  Future<void> pumpPage(WidgetTester tester) async {
    tester.view.physicalSize = const Size(375, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(ProviderScope(
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (_, __) => const MaterialApp(home: WalletTopUpPage()),
      ),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('no saved card: the notice, the new-card button and receive',
      (tester) async {
    install(const []);
    await pumpPage(tester);

    // "Pay with a new card" (the gateway's page) + "receive from a friend".
    expect(_buttons, findsNWidgets(2));
    expect(find.byKey(const ValueKey('pay-with-new-card')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('starts on the default card, ready to top up', (tester) async {
    install(const [
      {'name': 'CARD-0002', 'last_four': '1111', 'is_default': 1},
      {'name': 'CARD-0001', 'last_four': '4242', 'is_default': 0},
    ]);
    await pumpPage(tester);

    // Pay-with-saved-card (shown because a card is preselected), the
    // new-card button and receive.
    expect(_buttons, findsNWidgets(3));
    expect(find.textContaining('1111'), findsOneWidget);
  });
}
