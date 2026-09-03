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
import 'package:booking_sdk/src/common/domain/interface/booking.dart';
import 'package:booking_sdk/src/common/infrastructure/models/booking_models.dart';

/// Demo data behind the customer reservation screens
/// (`--dart-define=IS_DEMO=true`; orders_sdk `DemoSellerOrdersRepository`
/// convention). Served from memory, no HTTP client is constructed; writes
/// stick for the session and reset on the next launch.
class DemoBookingRepository implements BookingRepositoryFacade {
  static const String demoShopId = 'demo-shop';

  final List<ReservationData> _mine = [];
  int _seq = 0;

  DemoBookingRepository() {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1, 19, 0);
    _mine.add(ReservationData(
      id: _nextId(),
      slotId: 'demo-slot',
      tableId: 'Window 2',
      start: tomorrow,
      end: tomorrow.add(const Duration(hours: 2)),
      guestCount: 2,
      note: 'Anniversary',
      status: ReservationStatus.accepted,
    ));
  }

  String _nextId() => 'demo-reservation-${++_seq}';

  @override
  Future<ApiResult<BookingSettings>> getBookingSettings() async =>
      const ApiResult.success(
        data: BookingSettings(
          reservationsEnabled: true,
          durationOptions: [60, 90, 120],
          leadMinutes: 30,
        ),
      );

  @override
  Future<ApiResult<List<BookingSection>>> getShopSections(
          String shopId) async =>
      ApiResult.success(data: [
        BookingSection(id: 'demo-main-hall', title: 'Main hall', shopId: shopId),
        BookingSection(id: 'demo-terrace', title: 'Terrace', shopId: shopId),
      ]);

  @override
  Future<ApiResult<List<BookingTable>>> getSectionTables(
          String sectionId) async =>
      ApiResult.success(data: [
        BookingTable(id: 'Window 1', sectionId: sectionId, chairCount: 2),
        BookingTable(id: 'Window 2', sectionId: sectionId, chairCount: 4),
        BookingTable(id: 'Corner 5', sectionId: sectionId, chairCount: 6),
      ]);

  @override
  Future<ApiResult<List<BookingSlot>>> getBookingSlots(String shopId) async =>
      ApiResult.success(data: [
        BookingSlot(
          id: 'demo-slot',
          shopId: shopId,
          startTime: '10:00:00',
          endTime: '22:00:00',
          maxTime: 180,
        ),
      ]);

  @override
  Future<ApiResult<BookingSchedule>> getShopSchedule(String shopId) async =>
      ApiResult.success(
        data: BookingSchedule(
          shopId: shopId,
          workingDays: [
            for (final day in const [
              'Monday',
              'Tuesday',
              'Wednesday',
              'Thursday',
              'Friday',
              'Saturday',
              'Sunday',
            ])
              BookingWorkingDay(
                day: day,
                fromTime: '10:00:00',
                toTime: '22:00:00',
                disabled: day == 'Monday',
              ),
          ],
        ),
      );

  @override
  Future<ApiResult<ReservationData>> createReservation({
    required String slotId,
    required String tableId,
    required DateTime start,
    required DateTime end,
    int guestCount = 1,
    String? note,
  }) async {
    final created = ReservationData(
      id: _nextId(),
      slotId: slotId,
      tableId: tableId,
      start: start,
      end: end,
      guestCount: guestCount,
      note: note,
    );
    _mine.insert(0, created);
    return ApiResult.success(data: created);
  }

  @override
  Future<ApiResult<List<ReservationData>>> getMyReservations() async =>
      ApiResult.success(data: List.unmodifiable(_mine));

  @override
  Future<ApiResult<ReservationData>> cancelReservation(
      String reservationId) async {
    final i = _mine.indexWhere((r) => r.id == reservationId);
    if (i < 0) {
      return const ApiResult.failure(error: 'Not found', statusCode: 404);
    }
    _mine[i] = _mine[i].copyWith(status: ReservationStatus.cancelled);
    return ApiResult.success(data: _mine[i]);
  }
}
