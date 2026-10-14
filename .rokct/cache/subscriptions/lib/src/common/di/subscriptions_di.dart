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


import 'package:base_sdk/base_sdk.dart' show DemoFixtures;
import 'package:get_it/get_it.dart';

/// Host asset directory holding subscriptions_sdk's demo platform fixtures
/// (`<cmd>.json`), installed from `templates/assets/demo/subscriptions`.
const String subscriptionsDemoFixtureDirectory = 'assets/demo/subscriptions';

class SubscriptionsSdkDependencies {
  static void register(GetIt getIt) {
    // Demo runs the REAL SubscriptionsRepository (subscriptionRepositoryProvider):
    // base_sdk's DemoGatewayInterceptor answers its api.subscription.* cmds
    // from these fixtures while DemoSession.demoActive.
    DemoFixtures.registerAssetDirectory(subscriptionsDemoFixtureDirectory);
  }
}

// ---------------------------------------------------------------------------
// HOST-APP ADAPTER EXAMPLE (documentation only — not compiled wiring)
//
// subscriptions_sdk owns SubscriptionPaymentsProvider and never imports
// payments_sdk or wallet_sdk. The HOST APP — the only place where these SDKs
// are installed together — implements the adapter and overrides the riverpod
// provider. There is no composed host app in this workspace yet
// (supacharge/ is an empty shell), so this adapter is documented here rather
// than wired anywhere real.
//
//   import 'package:subscriptions_sdk/subscriptions_sdk.dart';
//   import 'package:payments_sdk/payments_sdk.dart';
//
//   class PaymentsAdapter implements SubscriptionPaymentsProvider {
//     final PaymentsFacade _payments;
//     PaymentsAdapter(this._payments);
//
//     @override
//     Future<ApiResult<List<SubscriptionPaymentMethod>>>
//         getPaymentMethods() async {
//       final res = await _payments.getPayments();
//       return res.when(
//         success: (data) => ApiResult.success(
//           data: (data.data ?? [])
//               .map((p) => SubscriptionPaymentMethod(id: p.id, tag: p.tag))
//               .toList(),
//         ),
//         failure: (error, statusCode) =>
//             ApiResult.failure(error: error, statusCode: statusCode),
//       );
//     }
//
//     @override
//     Future<ApiResult<String>> paymentSubscriptionWebView({
//       required String name,
//       required String subscriptionId,
//     }) =>
//         _payments.paymentSubscriptionWebView(
//           name: name,
//           subscriptionId: subscriptionId,
//         );
//   }
//
//   // in the host's ProviderScope overrides:
//   // paymentsRepositoryProvider.overrideWithValue(
//   //   PaymentsAdapter(getIt.get<PaymentsFacade>())),
//   //
//   // wallet_sdk is already decoupled the same way: the wallet balance is
//   // injected as a plain callback, e.g.
//   // walletPriceProvider.overrideWithValue(
//   //   () => LocalStorage.getUser()?.wallet?.price ?? 0),
// ---------------------------------------------------------------------------
