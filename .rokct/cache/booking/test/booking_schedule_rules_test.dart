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

// Pure-Dart rules behind the reservation flow (no Flutter binding needed).

import 'package:flutter_test/flutter_test.dart';

import 'package:booking_sdk/src/common/infrastructure/models/booking_models.dart';
import 'package:booking_sdk/src/common/utils/booking_schedule_rules.dart';

void main() {
  const slot = BookingSlot(
    id: 'slot',
    shopId: 'shop',
    startTime: '10:00:00',
    endTime: '14:00:00',
    maxTime: 2,
  );

  group('clocks', () {
    test('parseClockMinutes reads Frappe Time and short forms', () {
      expect(parseClockMinutes('10:30:00'), 630);
      expect(parseClockMinutes('9:05'), 545);
      expect(parseClockMinutes(''), isNull);
      expect(parseClockMinutes('25:00'), isNull);
    });

    test('formatClock round-trips', () {
      expect(formatClock(630), '10:30');
      expect(formatClock(630, withSeconds: true), '10:30:00');
    });
  });

  group('max_time', () {
    test('small values are hours, large values minutes, 0 falls back', () {
      expect(maxDurationMinutes(slot), 120);
      expect(
        maxDurationMinutes(const BookingSlot(
          id: 'a',
          shopId: 's',
          startTime: '',
          endTime: '',
          maxTime: 90,
        )),
        90,
      );
      expect(maxDurationMinutes(null), 180);
    });

    test('durationOptions steps up to the max, or uses the configured list',
        () {
      expect(durationOptions(slot: slot), [30, 60, 90, 120]);
      expect(durationOptions(slot: slot, configured: [60, 90, 240]), [60, 90]);
    });
  });

  group('start times', () {
    final monday = DateTime(2026, 9, 7); // a Monday
    final schedule = BookingSchedule(
      shopId: 'shop',
      workingDays: const [
        BookingWorkingDay(day: 'Monday', fromTime: '11:00:00', toTime: '13:00:00'),
        BookingWorkingDay(
            day: 'Tuesday', fromTime: '10:00:00', toTime: '22:00:00', disabled: true),
      ],
      closedDates: const [BookingClosedDate('2026-09-14')],
    );

    test('intersects the slot with the working day', () {
      final starts = startTimes(
        day: monday,
        slot: slot,
        schedule: schedule,
        now: DateTime(2026, 9, 1),
      );
      expect(starts.map((t) => t.hour * 60 + t.minute).toList(),
          [660, 690, 720, 750]);
    });

    test('disabled weekday, closed date and missing weekday are not bookable',
        () {
      expect(isDayBookable(day: monday.add(const Duration(days: 1)), schedule: schedule), isFalse);
      expect(isDayBookable(day: DateTime(2026, 9, 14), schedule: schedule), isFalse);
      expect(isDayBookable(day: monday.add(const Duration(days: 2)), schedule: schedule), isFalse);
      expect(isDayBookable(day: monday, schedule: schedule), isTrue);
      expect(isDayBookable(day: monday, schedule: null), isTrue);
    });

    test('today drops starts before now + lead time', () {
      final starts = startTimes(
        day: monday,
        slot: slot,
        schedule: schedule,
        now: DateTime(2026, 9, 7, 11, 20),
        leadMinutes: 30,
      );
      expect(starts.first.hour * 60 + starts.first.minute, 720);
    });

    test('endTimeFor caps at closing', () {
      final end = endTimeFor(
        start: DateTime(2026, 9, 7, 12, 30),
        durationMinutes: 120,
        slot: slot,
        schedule: schedule,
      );
      expect(end, DateTime(2026, 9, 7, 13, 0));
    });
  });

  test('BookingSettings parses the flag and duration list', () {
    final s = BookingSettings.fromJson({
      'reservation_enable_for_user': '0',
      'reservation_time_durations': '30\n60\n90',
      'reservation_before_time': 15,
    });
    expect(s.reservationsEnabled, isFalse);
    expect(s.durationOptions, [30, 60, 90]);
    expect(s.leadMinutes, 15);
    expect(BookingSettings.fromJson(const {}).reservationsEnabled, isTrue);
  });
}
