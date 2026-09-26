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

import 'package:base_sdk/base_sdk.dart' show DemoFixtures;
import 'package:booking_sdk/src/common/domain/interface/booking.dart';
import 'package:booking_sdk/src/common/infrastructure/repositories/booking_repository.dart';

/// Host asset directory holding booking_sdk's demo platform fixtures
/// (`<cmd>.json`), installed from `templates/assets/demo/booking`.
const String bookingDemoFixtureDirectory = 'assets/demo/booking';

/// Installer-convention DI hook: the composed app's generated `main.dart`
/// calls `BookingSdkDependencies.register(GetIt.instance)` for every
/// installed SDK. Registers the customer booking seam (idempotently, so
/// hand-wired hosts can call it too). The manager / POS seam is
/// `ManagerBookingDependencies` (lib/src/manager/di), registered by the
/// manager block's di_hook (POS shells compose the manager persona) - it
/// cannot be reached from here because customer caches have
/// lib/src/manager/ stripped.
///
/// Demo runs the REAL repositories: base_sdk's DemoGatewayInterceptor
/// answers every api.booking.* cmd from the `<cmd>.json` fixtures in
/// [bookingDemoFixtureDirectory] while DemoSession.demoActive (customer and
/// manager seams alike), and an unknown cmd fails loudly with
/// DemoFixtureMissing.
class BookingSdkDependencies {
  static void register(GetIt getIt) {
    DemoFixtures.registerAssetDirectory(bookingDemoFixtureDirectory);
    if (!getIt.isRegistered<BookingRepositoryFacade>()) {
      getIt.registerSingleton<BookingRepositoryFacade>(BookingRepository());
    }
  }
}
