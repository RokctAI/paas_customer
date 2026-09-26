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

import 'package:get_it/get_it.dart';
import 'package:base_sdk/src/handlers/demo_gateway_interceptor.dart';
import 'package:base_sdk/src/domain/interface/wallet.dart';
import 'package:wallet_sdk/src/common/domain/interface/wallet_deposit.dart';
import 'package:wallet_sdk/src/common/infrastructure/repositories/wallet_deposit_repository.dart';
import 'package:wallet_sdk/src/common/infrastructure/repositories/wallet_repository.dart';

/// Host asset directory holding wallet_sdk's demo platform fixtures
/// (`<cmd>.json`), installed from `templates/assets/demo/wallet`.
const String walletDemoFixtureDirectory = 'assets/demo/wallet';

/// Installer-convention DI hook: the composed app's generated `main.dart`
/// calls `WalletSdkDependencies.register(GetIt.instance)` for every
/// installed SDK. Registers this SDK's repositories against their base_sdk
/// facades (idempotently, so hand-wired hosts can call it too).
class WalletSdkDependencies {
  static void register(GetIt getIt) {
    // Demo runs the REAL repositories: base_sdk's DemoGatewayInterceptor
    // answers the wallet history page's api.user.get_wallet_history from
    // this directory while DemoSession.demoActive.
    DemoFixtures.registerAssetDirectory(walletDemoFixtureDirectory);
    if (!getIt.isRegistered<WalletRepositoryFacade>()) {
      getIt.registerSingleton<WalletRepositoryFacade>(WalletRepository());
    }
    // Design strip frames 49g/49h/49i: the bank-deposit route. Its facade is
    // this SDK's own (base_sdk carries no deposit seam), so a host resolves
    // it as `getIt<WalletDepositRepositoryFacade>()`.
    if (!getIt.isRegistered<WalletDepositRepositoryFacade>()) {
      getIt.registerSingleton<WalletDepositRepositoryFacade>(
        WalletDepositRepository(),
      );
    }
  }
}
