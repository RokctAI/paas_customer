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

import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';

import 'package:base_sdk/src/services/app_helpers.dart';
import 'package:booking_sdk/src/common/booking_tr_keys.dart';

/// The route PATHS booking_sdk declares in manifest.json.
///
/// SDK code navigates by path (`context.router.pushNamed`) because the
/// generated `*Route` classes live in the host's app_router.gr.dart, which
/// an SDK cannot import (ADR-005). A compose that did not install the
/// route (a customer compose reaching a manager path, or a host whose
/// installer skipped it) fails through `onFailure` with a top snack bar
/// instead of throwing.
class BookingRoutes {
  BookingRoutes._();

  /// Customer: my reservations (app_type.customer).
  static const String reservations = '/reservations';

  /// Customer: the shop -> section -> table -> time flow
  /// (app_type.customer). Optional `?shopId=` pre-selects the shop.
  static const String newReservation = '/new-reservation';

  /// Manager / POS: the shop's reservation list with status changes.
  static const String shopReservations = '/shop-reservations';

  /// Manager / POS: section + table CRUD.
  static const String reservationTables = '/reservation-tables';

  /// Manager / POS: booking hours (slots), working days, closed dates.
  static const String reservationSchedule = '/reservation-schedule';

  static Future<void> push(BuildContext context, String path) async {
    await context.router.pushNamed(
      path,
      onFailure: (_) => AppHelpers.showCheckTopSnackBar(
        context,
        AppHelpers.getTranslation(BookingTrKeys.reservationsAreNotAvailable),
      ),
    );
  }
}
