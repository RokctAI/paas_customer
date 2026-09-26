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
import 'package:base_sdk/src/domain/interface/banners.dart';
import 'package:promotions_sdk/src/common/infrastructure/repositories/banners_repository.dart';

/// Host asset directory holding promotions_sdk's demo platform fixtures
/// (`<cmd>.json`), installed from `templates/assets/demo/promotions`.
const String promotionsDemoFixtureDirectory = 'assets/demo/promotions';

/// Installer-convention DI hook: the composed app's generated `main.dart`
/// calls `PromotionsSdkDependencies.register(GetIt.instance)` for every
/// installed SDK. Registers this SDK's repositories against their base_sdk
/// facades (idempotently, so hand-wired hosts can call it too).
///
/// Demo runs the REAL repository: base_sdk's DemoGatewayInterceptor answers
/// every api.banner.* cmd from the `<cmd>.json` fixtures in
/// [promotionsDemoFixtureDirectory] while DemoSession.demoActive, and an
/// unknown cmd fails loudly with DemoFixtureMissing.
class PromotionsSdkDependencies {
  static void register(GetIt getIt) {
    DemoFixtures.registerAssetDirectory(promotionsDemoFixtureDirectory);
    if (!getIt.isRegistered<BannersRepositoryFacade>()) {
      getIt.registerSingleton<BannersRepositoryFacade>(BannersRepository());
    }
  }
}
