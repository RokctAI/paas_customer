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

/// Pure scheduling rules shared by the customer flow (which start times a
/// shop offers on a day) and the manager schedule screen. No Flutter
/// imports so `test/booking_schedule_rules_test.dart` runs them plain.
///
/// Ported from paas_pos `tables_notifier.dart` (setDateTime / setTimeOfDay
/// / createOrder), which validated a reservation against the shop's
/// working day and the slot's max_time before posting it.

import 'package:booking_sdk/src/common/infrastructure/models/booking_models.dart';

const List<String> kWeekdayNames = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

/// "10:00:00" / "10:00" / "9:5" -> minutes since midnight; null when the
/// string carries no parsable clock.
int? parseClockMinutes(String? raw) {
  if (raw == null) return null;
  final m = RegExp(r'^\s*(\d{1,2}):(\d{2})').firstMatch(raw);
  if (m == null) return null;
  final h = int.parse(m.group(1)!);
  final min = int.parse(m.group(2)!);
  if (h > 24 || min > 59) return null;
  return h * 60 + min;
}

/// 600 -> "10:00" (what the pickers show); [withSeconds] gives the Frappe
/// Time form "10:00:00" the API stores.
String formatClock(int minutes, {bool withSeconds = false}) {
  final h = (minutes ~/ 60).clamp(0, 24).toString().padLeft(2, '0');
  final m = (minutes % 60).toString().padLeft(2, '0');
  return withSeconds ? '$h:$m:00' : '$h:$m';
}

bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// DateTime.weekday is 1 = Monday .. 7 = Sunday.
String weekdayName(DateTime day) => kWeekdayNames[day.weekday - 1];

/// "yyyy-MM-dd" without pulling intl into the rules.
String formatDateKey(DateTime day) =>
    '${day.year.toString().padLeft(4, '0')}-'
    '${day.month.toString().padLeft(2, '0')}-'
    '${day.day.toString().padLeft(2, '0')}';

BookingWorkingDay? workingDayFor(BookingSchedule? schedule, DateTime day) {
  if (schedule == null) return null;
  final name = weekdayName(day).toLowerCase();
  for (final wd in schedule.workingDays) {
    if (wd.day.trim().toLowerCase() == name) return wd;
  }
  return null;
}

bool isClosedDate(BookingSchedule? schedule, DateTime day) {
  if (schedule == null) return false;
  final key = formatDateKey(day);
  return schedule.closedDates.any((d) => d.date.trim().startsWith(key));
}

/// A day takes reservations unless the shop closed it (closed date), or
/// the shop configured working days and this weekday is missing or
/// disabled. A shop with NO working days configured is open every day the
/// slot covers (the pre-fork behaviour: working days were optional).
bool isDayBookable({required DateTime day, BookingSchedule? schedule}) {
  if (isClosedDate(schedule, day)) return false;
  if (schedule == null || schedule.workingDays.isEmpty) return true;
  final wd = workingDayFor(schedule, day);
  return wd != null && !wd.disabled;
}

/// Longest reservation the slot allows, in minutes. `max_time` was written
/// in hours by paas_pos for small values and in minutes by the web
/// reservation form, so values up to 24 are read as hours. 0 / unset
/// falls back to [defaultMinutes].
int maxDurationMinutes(BookingSlot? slot, {int defaultMinutes = 180}) {
  final raw = slot?.maxTime ?? 0;
  if (raw <= 0) return defaultMinutes;
  if (raw <= 24) return raw * 60;
  return raw;
}

/// The duration choices offered for a reservation: multiples of
/// [stepMinutes] up to the slot's maximum, or the server's configured
/// [configured] list when it has one (filtered to the slot's maximum).
List<int> durationOptions({
  BookingSlot? slot,
  List<int> configured = const [],
  int stepMinutes = 30,
}) {
  final max = maxDurationMinutes(slot);
  if (configured.isNotEmpty) {
    final allowed = configured.where((d) => d > 0 && d <= max).toList();
    if (allowed.isNotEmpty) return allowed;
  }
  final out = <int>[];
  for (var d = stepMinutes; d <= max; d += stepMinutes) {
    out.add(d);
  }
  return out.isEmpty ? [max] : out;
}

/// The start times a customer may pick on [day]: every [stepMinutes] from
/// the later of the slot's start_time and the working day's from_time,
/// while a [minimumMinutes] reservation still fits before the earlier of
/// the slot's end_time and the working day's to_time. On today, starts
/// earlier than [now] + [leadMinutes] are dropped.
List<DateTime> startTimes({
  required DateTime day,
  required BookingSlot? slot,
  required DateTime now,
  BookingSchedule? schedule,
  int stepMinutes = 30,
  int leadMinutes = 0,
  int minimumMinutes = 30,
}) {
  if (!isDayBookable(day: day, schedule: schedule)) return const [];

  var open = parseClockMinutes(slot?.startTime) ?? 0;
  var close = parseClockMinutes(slot?.endTime) ?? 24 * 60;
  final wd = workingDayFor(schedule, day);
  if (wd != null) {
    final from = parseClockMinutes(wd.fromTime);
    final to = parseClockMinutes(wd.toTime);
    if (from != null && from > open) open = from;
    if (to != null && to < close) close = to;
  }
  if (close <= open) return const [];

  final earliest = isSameDay(day, now)
      ? now.hour * 60 + now.minute + leadMinutes
      : -1;

  final out = <DateTime>[];
  for (var t = open; t + minimumMinutes <= close; t += stepMinutes) {
    if (t < earliest) continue;
    out.add(DateTime(day.year, day.month, day.day, t ~/ 60, t % 60));
  }
  return out;
}

/// The end of a reservation started at [start] lasting [durationMinutes],
/// capped at the slot / working-day close so a late start never runs past
/// closing.
DateTime endTimeFor({
  required DateTime start,
  required int durationMinutes,
  required BookingSlot? slot,
  BookingSchedule? schedule,
}) {
  var close = parseClockMinutes(slot?.endTime) ?? 24 * 60;
  final wd = workingDayFor(schedule, start);
  final to = parseClockMinutes(wd?.toTime);
  if (to != null && to < close) close = to;
  final end = start.add(Duration(minutes: durationMinutes));
  final closeAt =
      DateTime(start.year, start.month, start.day).add(Duration(minutes: close));
  return end.isAfter(closeAt) ? closeAt : end;
}
