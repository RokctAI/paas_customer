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

// PaymentScreen in an app with no orders SDK (supacharge): it used to
// resolve OrdersRepositoryFacade in a field initializer, so opening it
// threw a StateError before anything rendered.

import 'package:base_sdk/src/di/injection.dart';
import 'package:base_sdk/src/domain/interface/orders.dart';
import 'package:base_sdk/src/domain/interface/payments.dart';
import 'package:base_sdk/src/handlers/api_result.dart';
import 'package:base_sdk/src/models/data/saved_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:payments_sdk/src/common/presentation/pages/cards/payment_screen.dart';

class _NoCardsPayments implements PaymentsRepositoryFacade {
  @override
  Future<ApiResult<List<SavedCardModel>>> getSavedCards() async =>
      const ApiResult.success(data: <SavedCardModel>[]);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  setUp(() {
    if (getIt.isRegistered<PaymentsRepositoryFacade>()) {
      getIt.unregister<PaymentsRepositoryFacade>();
    }
    getIt.registerSingleton<PaymentsRepositoryFacade>(_NoCardsPayments());
  });

  tearDown(() => getIt.unregister<PaymentsRepositoryFacade>());

  Widget host(PaymentScreen screen) => ProviderScope(
        child: ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (_, __) => MaterialApp(home: Scaffold(body: screen)),
        ),
      );

  testWidgets('tokenize-only mode opens with no orders SDK', (tester) async {
    // A tall phone, so the sheet's 30%-height cap fits its empty state.
    tester.view.physicalSize = const Size(375, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    expect(getIt.isRegistered<OrdersRepositoryFacade>(), isFalse);

    await tester.pumpWidget(
      host(PaymentScreen(tokenizeOnly: true, onPaymentComplete: (_) {})),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.byType(PaymentScreen), findsOneWidget);
  });

  testWidgets('payment mode hides "pay with new card" with no orders SDK',
      (tester) async {
    tester.view.physicalSize = const Size(375, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      host(PaymentScreen(onPaymentComplete: (_) {})),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.textContaining('your.card.will.be.saved'), findsNothing);
    expect(find.textContaining('Your card will be saved'), findsNothing);
  });
}
