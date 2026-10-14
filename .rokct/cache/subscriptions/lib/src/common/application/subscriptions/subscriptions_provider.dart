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


import 'package:base_sdk/base_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/interface/subscription_facade.dart';
import '../../domain/interface/subscription_payments_provider.dart';
import '../../infrastructure/repository/demo_subscription_payments_provider.dart';
import '../../infrastructure/repository/subscription_repository.dart';
import 'subscriptions_state.dart';
import 'subscriptions_notifier.dart';

// Demo note: the repository provider answers the REAL repository (demo
// data comes from base_sdk's DemoGatewayInterceptor fixtures). The other
// providers keep their host-must-override contract; unoverridden, they
// fall back to local demo callbacks (one wallet payment method, a zero
// wallet, no-op navigation/errors, identity translation) whenever
// base_sdk's DemoSession.demoActive is on, so a demo composition without
// the host adapters renders /subscriptions instead of throwing. None of
// those has a platform cmd behind it in this SDK.
//
// DemoSession.demoActive is read through demoActiveProvider rather than
// inline, because a riverpod Provider body runs ONCE and its result is
// cached for the container's life.

/// Riverpod's view of `DemoSession.demoActive`, and the reason the six
/// providers below re-decide instead of answering once.
///
/// [DemoSession.instance] is a [ChangeNotifier] that fires when a
/// server-marked demo account signs in ([DemoSession.activate]) and when
/// its session ends ([DemoSession.clear], which every sign-out path
/// calls). This body subscribes to it and calls `ref.invalidateSelf()` on
/// each notification, so riverpod drops this provider's cached value — and
/// with it the cached value (or cached error) of everything that
/// `ref.watch`es it — and the next read re-evaluates against the session
/// as it is now. The subscription is torn down with the provider, so an
/// invalidation swaps one listener for one listener and a disposed
/// container leaves none behind.
///
/// Deliberately a plain [Provider] rather than a `ChangeNotifierProvider`:
/// [DemoSession.instance] is an app-wide singleton this package does not
/// own, and a `ChangeNotifierProvider` would dispose it with the first
/// container that goes away.
final demoActiveProvider = Provider<bool>((ref) {
  void onDemoSessionChanged() => ref.invalidateSelf();
  DemoSession.instance.addListener(onDemoSessionChanged);
  ref.onDispose(
    () => DemoSession.instance.removeListener(onDemoSessionChanged),
  );
  return DemoSession.demoActive;
});

/// The REAL [SubscriptionsRepository] over base_sdk's shared HttpService
/// Dio, unless the host overrides it. Demo runs this same repository:
/// base_sdk's DemoGatewayInterceptor answers its `api.subscription.*` cmds
/// from `assets/demo/subscriptions/<cmd>.json` while a demo session is on
/// (registered by SubscriptionsSdkDependencies), so there is no demo twin.
final subscriptionRepositoryProvider = Provider<SubscriptionsFacade>((ref) {
  if (!getIt.isRegistered<AppDatabase>()) {
    getIt.registerLazySingleton<AppDatabase>(() => AppDatabase());
  }
  return SubscriptionsRepository(
    dioHttp.client(requireAuth: true),
    getIt.get<AppDatabase>(),
    localeCallback: () => LocalStorage.getLanguage()?.locale,
  );
});

/// The host app overrides this with an adapter implementing
/// [SubscriptionPaymentsProvider] around its real payments facade (see the
/// commented example in `src/di/subscriptions_di.dart`).
final paymentsRepositoryProvider = Provider<SubscriptionPaymentsProvider>(
  (ref) => ref.watch(demoActiveProvider)
      ? DemoSubscriptionPaymentsProvider()
      : throw UnimplementedError(
          'paymentsRepositoryProvider is not overridden',
        ),
);

final walletPriceProvider = Provider<num Function()>(
  (ref) => ref.watch(demoActiveProvider)
      ? () => 0
      : throw UnimplementedError('walletPriceProvider is not overridden'),
);

final navigateToWebViewProvider =
    Provider<Future<void> Function(BuildContext, String)>(
      (ref) => ref.watch(demoActiveProvider)
          ? (BuildContext context, String url) async {}
          : throw UnimplementedError(
              'navigateToWebViewProvider is not overridden',
            ),
    );

final errorNotificationProvider = Provider<void Function(BuildContext, String)>(
  (ref) => ref.watch(demoActiveProvider)
      ? (BuildContext context, String message) {}
      : throw UnimplementedError(
          'errorNotificationProvider is not overridden',
        ),
);

final translationProvider = Provider<String Function(String)>(
  (ref) => ref.watch(demoActiveProvider)
      ? (String key) => key
      : throw UnimplementedError('translationProvider is not overridden'),
);

final subscriptionProvider =
    StateNotifierProvider<SubscriptionNotifier, SubscriptionState>(
      (ref) => SubscriptionNotifier(
        ref.watch(subscriptionRepositoryProvider),
        ref.watch(paymentsRepositoryProvider),
        getWalletPrice: ref.watch(walletPriceProvider),
        onNavigateToWebView: ref.watch(navigateToWebViewProvider),
        onError: ref.watch(errorNotificationProvider),
        getTranslation: ref.watch(translationProvider),
      ),
    );
