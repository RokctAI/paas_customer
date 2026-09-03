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

import 'package:base_sdk/src/constants/app_constants.dart';
import 'package:booking_sdk/src/common/domain/interface/booking.dart';
import 'package:booking_sdk/src/common/infrastructure/repositories/booking_repository.dart';
import 'package:booking_sdk/src/common/infrastructure/repositories/demo_booking_repository.dart';

/// Installer-convention DI hook: the composed app's generated `main.dart`
/// calls `BookingSdkDependencies.register(GetIt.instance)` for every
/// installed SDK. Registers the customer booking seam (idempotently, so
/// hand-wired hosts can call it too). The manager / POS seam is
/// `ManagerBookingDependencies` (lib/src/manager/di), registered by the
/// manager block's di_hook (POS shells compose the manager persona) - it
/// cannot be reached from here because customer caches have
/// lib/src/manager/ stripped.
class BookingSdkDependencies {
  static void register(GetIt getIt) {
    if (!getIt.isRegistered<BookingRepositoryFacade>()) {
      getIt.registerSingleton<BookingRepositoryFacade>(
        AppConstants.isDemo ? DemoBookingRepository() : BookingRepository(),
      );
    }
  }
}
