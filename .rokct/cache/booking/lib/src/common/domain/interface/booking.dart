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

import 'package:base_sdk/src/handlers/handlers.dart';
import 'package:booking_sdk/src/common/infrastructure/models/booking_models.dart';

/// The customer-facing booking seam. Registered in GetIt by
/// `BookingSdkDependencies.register` (demo-gated to
/// `DemoBookingRepository` under IS_DEMO).
abstract class BookingRepositoryFacade {
  /// `api.booking.get_booking_settings` (guest-readable).
  Future<ApiResult<BookingSettings>> getBookingSettings();

  /// `api.booking.get_shop_sections_for_booking`.
  Future<ApiResult<List<BookingSection>>> getShopSections(String shopId);

  /// `api.booking.get_tables_for_section` (active tables only).
  Future<ApiResult<List<BookingTable>>> getSectionTables(String sectionId);

  /// `api.booking.get_booking_slots` - the shop's booking hours. A shop
  /// with none is not taking reservations yet.
  Future<ApiResult<List<BookingSlot>>> getBookingSlots(String shopId);

  /// `api.booking.get_shop_booking_schedule` (guest-readable).
  Future<ApiResult<BookingSchedule>> getShopSchedule(String shopId);

  /// `api.booking.create_reservation`. The server re-checks availability
  /// and rejects overlaps on the same table.
  Future<ApiResult<ReservationData>> createReservation({
    required String slotId,
    required String tableId,
    required DateTime start,
    required DateTime end,
    int guestCount = 1,
    String? note,
  });

  /// `api.booking.get_my_reservations` (the session user's, newest first).
  Future<ApiResult<List<ReservationData>>> getMyReservations();

  /// `api.booking.cancel_my_booking`.
  Future<ApiResult<ReservationData>> cancelReservation(String reservationId);
}
