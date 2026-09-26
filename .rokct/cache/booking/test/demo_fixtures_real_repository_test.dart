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

// Demo runs the REAL BookingRepository and SellerBookingRepository:
// base_sdk's DemoGatewayInterceptor answers every api.booking.* cmd from
// templates/assets/demo/booking.

import 'package:booking_sdk/src/common/infrastructure/models/booking_models.dart';
import 'package:booking_sdk/src/common/infrastructure/repositories/booking_repository.dart';
import 'package:booking_sdk/src/manager/infrastructure/repositories/seller_booking_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/demo_fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(startDemoFixtures);
  tearDown(stopDemoFixtures);

  test(
    'customer: settings, sections, tables, slots, schedule, bookings',
    () async {
      final repo = BookingRepository();
      final settings = ok(await repo.getBookingSettings());
      expect(settings.reservationsEnabled, isTrue);
      expect(settings.durationOptions, [60, 90, 120]);
      final sections = ok(await repo.getShopSections('demo-shop'));
      expect(sections.map((s) => s.title), ['Main hall', 'Terrace']);
      expect(ok(await repo.getSectionTables('demo-main-hall')), hasLength(3));
      expect(
        ok(await repo.getSectionTables('demo-terrace')).single.id,
        'Terrace 1',
      );
      expect(ok(await repo.getBookingSlots('demo-shop')).single.maxTime, 180);
      final schedule = ok(await repo.getShopSchedule('demo-shop'));
      expect(schedule.workingDays, hasLength(7));
      expect(schedule.workingDays.first.disabled, isTrue);
      final mine = ok(await repo.getMyReservations());
      expect(mine.single.note, 'Anniversary');
      expect(mine.single.status, ReservationStatus.accepted);
      final now = DateTime.now();
      final created = ok(
        await repo.createReservation(
          slotId: 'demo-slot',
          tableId: 'Window 2',
          start: now,
          end: now.add(const Duration(hours: 2)),
        ),
      );
      expect(created.status, ReservationStatus.newStatus);
      expect(
        ok(await repo.cancelReservation('demo-reservation-1')).status,
        ReservationStatus.cancelled,
      );
    },
  );

  test(
    'manager: an evening of reservations, filterable, and every write',
    () async {
      final repo = SellerBookingRepository();
      expect(ok(await repo.getShopReservations('demo-shop')), hasLength(4));
      expect(
        ok(
          await repo.getShopReservations(
            'demo-shop',
            status: ReservationStatus.accepted,
          ),
        ).map((r) => r.user),
        ['Sipho K.', 'Lerato D.'],
      );
      expect(
        ok(
          await repo.updateReservationStatus(
            'demo-reservation-1',
            ReservationStatus.accepted,
          ),
        ).status,
        ReservationStatus.accepted,
      );
      ok(await repo.createSection('demo-shop', 'Bar'));
      ok(await repo.deleteSection('demo-terrace'));
      ok(
        await repo.createTable(
          sectionId: 'demo-main-hall',
          name: 'Bar 1',
          chairCount: 2,
        ),
      );
      ok(await repo.deleteTable('Window 1'));
      ok(
        await repo.createBookingSlot(
          shopId: 'demo-shop',
          startTime: '10:00:00',
          endTime: '14:00:00',
          maxTime: 90,
        ),
      );
      ok(await repo.deleteBookingSlot('demo-slot'));
      final schedule = ok(await repo.saveWorkingDays('demo-shop', const []));
      expect(schedule.workingDays, hasLength(7));
      ok(await repo.saveClosedDates('demo-shop', const []));
    },
  );
}
