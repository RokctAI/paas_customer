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
import 'package:base_sdk/src/handlers/platform_gateway.dart';
import 'package:booking_sdk/src/common/domain/interface/booking.dart';
import 'package:booking_sdk/src/common/infrastructure/models/booking_models.dart';
import 'package:booking_sdk/src/common/infrastructure/repositories/booking_wire.dart';

/// `api.booking.*` over base_sdk's [PlatformGateway] (POST
/// `rokct.platform.api` with `cmd` + `payload`), the same transport the
/// orders / merchants repositories use. Every method is whitelisted in
/// booking/frappe/manifest.json.
class BookingRepository implements BookingRepositoryFacade {
  static const _gateway = PlatformGateway();

  @override
  Future<ApiResult<BookingSettings>> getBookingSettings() async {
    try {
      // allow_guest on the server: a signed-out customer still needs the
      // visibility flag before the profile's Reservation button decides
      // whether to show.
      final body = await _gateway.call(
        'api.booking.get_booking_settings',
        requireAuth: false,
      );
      return ApiResult.success(data: BookingSettings.fromJson(asRow(body)));
    } catch (e) {
      return bookingFailure(e);
    }
  }

  @override
  Future<ApiResult<List<BookingSection>>> getShopSections(
      String shopId) async {
    try {
      final body = await _gateway.tenant(
        'api.booking.get_shop_sections_for_booking',
        {'shop_id': shopId},
      );
      return ApiResult.success(
        data: asRows(body).map(BookingSection.fromJson).toList(),
      );
    } catch (e) {
      return bookingFailure(e);
    }
  }

  @override
  Future<ApiResult<List<BookingTable>>> getSectionTables(
      String sectionId) async {
    try {
      final body = await _gateway.tenant(
        'api.booking.get_tables_for_section',
        {'shop_section_id': sectionId},
      );
      return ApiResult.success(
        data: asRows(body).map(BookingTable.fromJson).toList(),
      );
    } catch (e) {
      return bookingFailure(e);
    }
  }

  @override
  Future<ApiResult<List<BookingSlot>>> getBookingSlots(String shopId) async {
    try {
      final body = await _gateway.tenant(
        'api.booking.get_booking_slots',
        {'shop_id': shopId},
      );
      return ApiResult.success(
        data: asRows(body).map(BookingSlot.fromJson).toList(),
      );
    } catch (e) {
      return bookingFailure(e);
    }
  }

  @override
  Future<ApiResult<BookingSchedule>> getShopSchedule(String shopId) async {
    try {
      final body = await _gateway.call(
        'api.booking.get_shop_booking_schedule',
        payload: {'shop_id': shopId},
        requireAuth: false,
      );
      return ApiResult.success(data: BookingSchedule.fromJson(asRow(body)));
    } catch (e) {
      return bookingFailure(e);
    }
  }

  @override
  Future<ApiResult<ReservationData>> createReservation({
    required String slotId,
    required String tableId,
    required DateTime start,
    required DateTime end,
    int guestCount = 1,
    String? note,
  }) async {
    try {
      final body = await _gateway.tenant(
        'api.booking.create_reservation',
        {
          'data': {
            'booking': slotId,
            'table': tableId,
            'start_date': formatWireDateTime(start),
            'end_date': formatWireDateTime(end),
            'guest_count': guestCount,
            if (note != null && note.trim().isNotEmpty) 'note': note.trim(),
          },
        },
      );
      return ApiResult.success(data: ReservationData.fromJson(asRow(body)));
    } catch (e) {
      return bookingFailure(e);
    }
  }

  @override
  Future<ApiResult<List<ReservationData>>> getMyReservations() async {
    try {
      final body = await _gateway.tenant('api.booking.get_my_reservations');
      return ApiResult.success(
        data: asRows(body).map(ReservationData.fromJson).toList(),
      );
    } catch (e) {
      return bookingFailure(e);
    }
  }

  @override
  Future<ApiResult<ReservationData>> cancelReservation(
      String reservationId) async {
    try {
      final body = await _gateway.tenant(
        'api.booking.cancel_my_booking',
        {'name': reservationId},
      );
      return ApiResult.success(data: ReservationData.fromJson(asRow(body)));
    } catch (e) {
      return bookingFailure(e);
    }
  }
}
