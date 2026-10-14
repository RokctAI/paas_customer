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


import 'dart:io';

import 'package:base_sdk/base_sdk.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:subscriptions_sdk/src/common/application/subscriptions/subscriptions_provider.dart';
import 'package:subscriptions_sdk/src/common/infrastructure/repository/demo_subscription_payments_provider.dart';
import 'package:subscriptions_sdk/subscriptions_sdk.dart';

/// Demo runs the REAL SubscriptionsRepository: base_sdk's
/// DemoGatewayInterceptor answers its api.subscription.* cmds from
/// templates/assets/demo/subscriptions. The UI-callback providers keep
/// their demo fallbacks (no platform cmd behind them) and still follow the
/// runtime DemoSession.
void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues(const {});
    await LocalStorage.init();
    if (!getIt.isRegistered<HttpService>()) {
      getIt.registerSingleton<HttpService>(HttpService());
    }
    // A stand-in so the provider never opens a drift database in tests.
    if (!getIt.isRegistered<AppDatabase>()) {
      getIt.registerSingleton<AppDatabase>(_NoDatabase());
    }
  });

  setUp(() async {
    await DemoSession.instance.clear();
    DemoFixtures.reset();
    DemoFixtures.loader = (key) async {
      final f = File(key.replaceFirst('$subscriptionsDemoFixtureDirectory/',
          'templates/assets/demo/subscriptions/'));
      return f.existsSync() ? f.readAsString() : null;
    };
    SubscriptionsSdkDependencies.register(getIt);
  });

  tearDown(() async {
    DemoFixtures.reset();
    await DemoSession.instance.clear();
  });

  test('the repository provider is the real repository either way', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    expect(container.read(subscriptionRepositoryProvider),
        isA<SubscriptionsRepository>());
    await DemoSession.instance.activate();
    expect(container.read(subscriptionRepositoryProvider),
        isA<SubscriptionsRepository>());
  });

  test('no demo session: the host-override callbacks still throw', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    expect(DemoSession.demoActive, isFalse);
    expect(() => container.read(paymentsRepositoryProvider),
        throwsA(isA<UnimplementedError>()));
    expect(() => container.read(walletPriceProvider),
        throwsA(isA<UnimplementedError>()));
    expect(() => container.read(translationProvider),
        throwsA(isA<UnimplementedError>()));
  });

  test('a session that starts after the first read is picked up', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    expect(() => container.read(paymentsRepositoryProvider),
        throwsA(isA<UnimplementedError>()));
    await DemoSession.instance.activate();
    expect(container.read(paymentsRepositoryProvider),
        isA<DemoSubscriptionPaymentsProvider>());
    expect(container.read(walletPriceProvider)(), 0);
    expect(container.read(translationProvider)('x'), 'x');
    await DemoSession.instance.clear();
    expect(() => container.read(paymentsRepositoryProvider),
        throwsA(isA<UnimplementedError>()));
  });

  test('demo plans and purchase come from fixtures through the real repo',
      () async {
    await DemoSession.instance.activate();
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final repo = container.read(subscriptionRepositoryProvider);
    final plans = switch (await repo.getSubscriptions(page: 1)) {
      Success(:final data) => data.data!,
      Failure(:final error) => throw StateError(error),
    };
    expect(plans.map((p) => p.ref), ['PLAN-STARTER', 'PLAN-GROWTH']);
    expect(plans.last.withReport, isTrue);
    final bought = await repo.purchaseSubscription(
        id: 1, paymentId: 1, ref: 'PLAN-STARTER');
    expect(bought, isA<Success>());
  });

  test('a host override is untouched by the session either way', () async {
    final host = _HostFacade();
    final container = ProviderContainer(
      overrides: [subscriptionRepositoryProvider.overrideWithValue(host)],
    );
    addTearDown(container.dispose);
    expect(container.read(subscriptionRepositoryProvider), same(host));
    await DemoSession.instance.activate();
    expect(container.read(subscriptionRepositoryProvider), same(host));
  });
}

class _NoDatabase implements AppDatabase {
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('no database in this test');
}

/// Stands in for the adapter a host app installs in its ProviderScope.
class _HostFacade implements SubscriptionsFacade {
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('$_HostFacade is a stand-in');
}
