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

/// Wire models for the booking API (`api.booking.*`).
///
/// Plain immutable classes rather than freezed: booking_sdk carries no
/// codegen, and these rows are small. Field names mirror the Frappe
/// doctypes (Booking = a shop's booking-hours slot, User Booking = a
/// reservation, Shop Section, Table).

/// `api.booking.get_booking_settings`.
class BookingSettings {
  /// Permission Settings `enable_reservations`, served as the
  /// `reservation_enable_for_user` key `AppHelpers.getReservationEnable`
  /// reads.
  final bool reservationsEnabled;

  /// Reservation Settings `reservation_time_durations`, parsed into
  /// minute options (empty when unset).
  final List<int> durationOptions;

  /// Reservation Settings `reservation_before_time` (minutes of lead time
  /// a reservation needs), null when unset.
  final int? leadMinutes;

  const BookingSettings({
    required this.reservationsEnabled,
    this.durationOptions = const [],
    this.leadMinutes,
  });

  factory BookingSettings.fromJson(Map<String, dynamic> json) {
    final enable = json['reservation_enable_for_user'];
    return BookingSettings(
      reservationsEnabled: enable == null ||
          enable == 1 ||
          enable == true ||
          enable.toString() == '1',
      durationOptions: parseDurationOptions(json['reservation_time_durations']),
      leadMinutes: _toInt(json['reservation_before_time']),
    );
  }

  /// "30\n60\n90", "30,60,90" or a bare number -> [30, 60, 90].
  static List<int> parseDurationOptions(dynamic raw) {
    if (raw == null) return const [];
    final out = <int>[];
    for (final m in RegExp(r'\d+').allMatches(raw.toString())) {
      final v = int.tryParse(m.group(0)!);
      if (v != null && v > 0 && !out.contains(v)) out.add(v);
    }
    out.sort();
    return out;
  }
}

/// A Shop Section row (`get_shop_sections_for_booking`).
class BookingSection {
  /// Docname; what Table.shop_section links to.
  final String id;

  /// Shop Section `area` - the human label.
  final String title;
  final String shopId;

  const BookingSection({
    required this.id,
    required this.title,
    required this.shopId,
  });

  factory BookingSection.fromJson(Map<String, dynamic> json) {
    final id = (json['name'] ?? '').toString();
    return BookingSection(
      id: id,
      title: (json['area'] ?? id).toString(),
      shopId: (json['shop'] ?? '').toString(),
    );
  }
}

/// A Table row (`get_tables_for_section`). Table's Data field is literally
/// called `name`, so the docname IS the readable table name.
class BookingTable {
  final String id;
  final String sectionId;
  final int chairCount;
  final bool active;

  const BookingTable({
    required this.id,
    required this.sectionId,
    this.chairCount = 0,
    this.active = true,
  });

  factory BookingTable.fromJson(Map<String, dynamic> json) => BookingTable(
        id: (json['name'] ?? '').toString(),
        sectionId: (json['shop_section'] ?? '').toString(),
        chairCount: _toInt(json['chair_count']) ?? 0,
        active: json['active'] == null || _toInt(json['active']) == 1,
      );
}

/// A Booking row: the shop's booking hours (`get_booking_slots`).
class BookingSlot {
  final String id;
  final String shopId;

  /// "HH:mm:ss" (Frappe Time).
  final String startTime;
  final String endTime;

  /// Longest reservation; 0 / null = no limit. paas_pos stored this in
  /// hours for small values, so values <= 24 are read as hours (see
  /// `maxDurationMinutes` in booking_schedule_rules.dart).
  final int maxTime;
  final bool active;

  const BookingSlot({
    required this.id,
    required this.shopId,
    required this.startTime,
    required this.endTime,
    this.maxTime = 0,
    this.active = true,
  });

  factory BookingSlot.fromJson(Map<String, dynamic> json) => BookingSlot(
        id: (json['name'] ?? '').toString(),
        shopId: (json['shop'] ?? '').toString(),
        startTime: (json['start_time'] ?? '').toString(),
        endTime: (json['end_time'] ?? '').toString(),
        maxTime: _toInt(json['max_time']) ?? 0,
        active: json['active'] == null || _toInt(json['active']) == 1,
      );
}

/// A Shop Booking Working Day child row; the exact shape
/// `manage_shop_booking_working_days` accepts and
/// `get_shop_booking_schedule` returns.
class BookingWorkingDay {
  /// 'Monday' .. 'Sunday'.
  final String day;
  final String fromTime;
  final String toTime;
  final bool disabled;

  const BookingWorkingDay({
    required this.day,
    required this.fromTime,
    required this.toTime,
    this.disabled = false,
  });

  factory BookingWorkingDay.fromJson(Map<String, dynamic> json) =>
      BookingWorkingDay(
        day: (json['day'] ?? '').toString(),
        fromTime: (json['from_time'] ?? '').toString(),
        toTime: (json['to_time'] ?? '').toString(),
        disabled: _toInt(json['disabled']) == 1 || json['disabled'] == true,
      );

  Map<String, dynamic> toJson() => {
        'day': day,
        'from_time': fromTime,
        'to_time': toTime,
        'disabled': disabled ? 1 : 0,
      };

  BookingWorkingDay copyWith({
    String? fromTime,
    String? toTime,
    bool? disabled,
  }) =>
      BookingWorkingDay(
        day: day,
        fromTime: fromTime ?? this.fromTime,
        toTime: toTime ?? this.toTime,
        disabled: disabled ?? this.disabled,
      );
}

/// A Shop Booking Closed Date child row (`date` = "yyyy-MM-dd").
class BookingClosedDate {
  final String date;

  const BookingClosedDate(this.date);

  factory BookingClosedDate.fromJson(Map<String, dynamic> json) =>
      BookingClosedDate((json['date'] ?? '').toString());

  Map<String, dynamic> toJson() => {'date': date};
}

/// `get_shop_booking_schedule`.
class BookingSchedule {
  final String shopId;
  final List<BookingWorkingDay> workingDays;
  final List<BookingClosedDate> closedDates;

  const BookingSchedule({
    required this.shopId,
    this.workingDays = const [],
    this.closedDates = const [],
  });

  factory BookingSchedule.fromJson(Map<String, dynamic> json) =>
      BookingSchedule(
        shopId: (json['shop'] ?? '').toString(),
        workingDays: _rows(json['working_days'])
            .map(BookingWorkingDay.fromJson)
            .toList(),
        closedDates: _rows(json['closed_dates'])
            .map(BookingClosedDate.fromJson)
            .where((d) => d.date.isNotEmpty)
            .toList(),
      );
}

/// User Booking `status`.
enum ReservationStatus {
  newStatus('New'),
  accepted('Accepted'),
  cancelled('Cancelled');

  final String wire;
  const ReservationStatus(this.wire);

  static ReservationStatus fromWire(dynamic raw) {
    final s = (raw ?? '').toString().toLowerCase();
    if (s == 'accepted') return ReservationStatus.accepted;
    if (s == 'cancelled' || s == 'canceled') return ReservationStatus.cancelled;
    return ReservationStatus.newStatus;
  }
}

/// A User Booking row (a reservation).
class ReservationData {
  final String id;
  final String slotId;
  final String tableId;
  final String? user;
  final DateTime? start;
  final DateTime? end;
  final int guestCount;
  final String? note;
  final ReservationStatus status;

  const ReservationData({
    required this.id,
    required this.slotId,
    required this.tableId,
    this.user,
    this.start,
    this.end,
    this.guestCount = 0,
    this.note,
    this.status = ReservationStatus.newStatus,
  });

  factory ReservationData.fromJson(Map<String, dynamic> json) =>
      ReservationData(
        id: (json['name'] ?? '').toString(),
        slotId: (json['booking'] ?? '').toString(),
        tableId: (json['table'] ?? '').toString(),
        user: json['user']?.toString(),
        start: _toDateTime(json['start_date']),
        end: _toDateTime(json['end_date']),
        guestCount: _toInt(json['guest_count']) ?? 0,
        note: json['note']?.toString(),
        status: ReservationStatus.fromWire(json['status']),
      );

  ReservationData copyWith({ReservationStatus? status}) => ReservationData(
        id: id,
        slotId: slotId,
        tableId: tableId,
        user: user,
        start: start,
        end: end,
        guestCount: guestCount,
        note: note,
        status: status ?? this.status,
      );
}

int? _toInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is bool) return v ? 1 : 0;
  return int.tryParse(v.toString());
}

DateTime? _toDateTime(dynamic v) {
  if (v == null) return null;
  if (v is DateTime) return v;
  // Frappe Datetime: "2026-09-02 19:30:00" - local wall time, no zone.
  return DateTime.tryParse(v.toString().replaceFirst(' ', 'T'));
}

List<Map<String, dynamic>> _rows(dynamic v) {
  if (v is! List) return const [];
  return v
      .whereType<Map>()
      .map((m) => Map<String, dynamic>.from(m))
      .toList();
}
