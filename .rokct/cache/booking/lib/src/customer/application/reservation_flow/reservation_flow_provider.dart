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

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import 'package:base_sdk/src/domain/interface/shops.dart';
import 'package:base_sdk/src/handlers/handlers.dart';
import 'package:base_sdk/src/models/data/shop_data.dart';
import 'package:booking_sdk/src/common/domain/interface/booking.dart';
import 'package:booking_sdk/src/common/infrastructure/models/booking_models.dart';
import 'package:booking_sdk/src/common/utils/booking_schedule_rules.dart';

/// The customer reservation flow: shop -> section -> table -> day / time /
/// duration -> confirm. Recovered from paas_customer's web-only hand-off
/// (reservation_shops.dart opened `{webUrl}/reservations`) and paas_pos's
/// TablesNotifier date/time validation, now against the SDK seam.
class ReservationFlowState {
  final bool loadingShops;
  final List<ShopData> shops;

  /// `get_shops` pages 10 at a time; true while the last page was full.
  final bool hasMoreShops;
  final int shopPage;
  final ShopData? shop;

  final bool loadingShop;
  final List<BookingSlot> slots;
  final BookingSchedule? schedule;
  final List<BookingSection> sections;
  final BookingSection? section;

  final bool loadingTables;
  final List<BookingTable> tables;
  final BookingTable? table;

  final DateTime day;
  final DateTime? start;
  final int durationMinutes;
  final int guests;
  final String note;

  final BookingSettings? settings;
  final bool isSubmitting;
  final ReservationData? created;
  final String? error;

  const ReservationFlowState({
    this.loadingShops = false,
    this.shops = const [],
    this.hasMoreShops = false,
    this.shopPage = 0,
    this.shop,
    this.loadingShop = false,
    this.slots = const [],
    this.schedule,
    this.sections = const [],
    this.section,
    this.loadingTables = false,
    this.tables = const [],
    this.table,
    required this.day,
    this.start,
    this.durationMinutes = 60,
    this.guests = 2,
    this.note = '',
    this.settings,
    this.isSubmitting = false,
    this.created,
    this.error,
  });

  /// The booking-hours slot reservations are booked against: the first
  /// active one (paas_pos booked every reservation against one slot too).
  BookingSlot? get slot {
    for (final s in slots) {
      if (s.active) return s;
    }
    return null;
  }

  /// A shop was chosen and it has no booking hours: it is not taking
  /// reservations yet.
  bool get shopNotTakingReservations =>
      shop != null && !loadingShop && slot == null;

  List<DateTime> startOptions(DateTime now) => startTimes(
        day: day,
        slot: slot,
        schedule: schedule,
        now: now,
        leadMinutes: settings?.leadMinutes ?? 0,
      );

  List<int> get durationChoices => durationOptions(
        slot: slot,
        configured: settings?.durationOptions ?? const [],
      );

  bool get canSubmit =>
      shop != null &&
      slot != null &&
      table != null &&
      start != null &&
      !isSubmitting;

  ReservationFlowState copyWith({
    bool? loadingShops,
    List<ShopData>? shops,
    bool? hasMoreShops,
    int? shopPage,
    ShopData? shop,
    bool clearShop = false,
    bool? loadingShop,
    List<BookingSlot>? slots,
    BookingSchedule? schedule,
    bool clearSchedule = false,
    List<BookingSection>? sections,
    BookingSection? section,
    bool clearSection = false,
    bool? loadingTables,
    List<BookingTable>? tables,
    BookingTable? table,
    bool clearTable = false,
    DateTime? day,
    DateTime? start,
    bool clearStart = false,
    int? durationMinutes,
    int? guests,
    String? note,
    BookingSettings? settings,
    bool? isSubmitting,
    ReservationData? created,
    String? error,
    bool clearError = false,
  }) =>
      ReservationFlowState(
        loadingShops: loadingShops ?? this.loadingShops,
        shops: shops ?? this.shops,
        hasMoreShops: hasMoreShops ?? this.hasMoreShops,
        shopPage: shopPage ?? this.shopPage,
        shop: clearShop ? null : (shop ?? this.shop),
        loadingShop: loadingShop ?? this.loadingShop,
        slots: slots ?? this.slots,
        schedule: clearSchedule ? null : (schedule ?? this.schedule),
        sections: sections ?? this.sections,
        section: clearSection ? null : (section ?? this.section),
        loadingTables: loadingTables ?? this.loadingTables,
        tables: tables ?? this.tables,
        table: clearTable ? null : (table ?? this.table),
        day: day ?? this.day,
        start: clearStart ? null : (start ?? this.start),
        durationMinutes: durationMinutes ?? this.durationMinutes,
        guests: guests ?? this.guests,
        note: note ?? this.note,
        settings: settings ?? this.settings,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        created: created ?? this.created,
        error: clearError ? null : (error ?? this.error),
      );
}

class ReservationFlowNotifier extends StateNotifier<ReservationFlowState> {
  final BookingRepositoryFacade _repo;
  final ShopsRepositoryFacade? _shops;

  ReservationFlowNotifier(this._repo, this._shops)
      : super(ReservationFlowState(day: _today()));

  static DateTime _today() {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  /// Loads the shop list (or just [shopId] when the caller pre-selected
  /// one) and the reservation settings.
  Future<void> init({String? shopId}) async {
    // ignore: discarded_futures
    _loadSettings();
    final shops = _shops;
    if (shops == null) {
      state = state.copyWith(error: 'Shops are not available in this app');
      return;
    }
    if (shopId != null && shopId.isNotEmpty) {
      state = state.copyWith(loadingShops: true, clearError: true);
      final result = await shops.getShopsByIds([shopId]);
      if (!mounted) return;
      switch (result) {
        case Success(:final data):
          final list = data.data ?? const <ShopData>[];
          state = state.copyWith(loadingShops: false, shops: list);
          if (list.isNotEmpty) await selectShop(list.first);
        case Failure(:final error):
          state = state.copyWith(loadingShops: false, error: error);
      }
      return;
    }
    await loadMoreShops();
  }

  /// Next page of shops (`get_shops` is 10 a page, no open-now filter:
  /// a reservation is for later).
  Future<void> loadMoreShops() async {
    final shops = _shops;
    if (shops == null || state.loadingShops) return;
    final page = state.shopPage + 1;
    state = state.copyWith(loadingShops: true, clearError: true);
    final result = await shops.getAllShops(page, isOpen: false);
    if (!mounted) return;
    switch (result) {
      case Success(:final data):
        final list = data.data ?? const <ShopData>[];
        state = state.copyWith(
          loadingShops: false,
          shopPage: page,
          hasMoreShops: list.length >= 10,
          shops: [...state.shops, ...list],
        );
      case Failure(:final error):
        state = state.copyWith(loadingShops: false, error: error);
    }
  }

  /// Back to the shop list (keeps the loaded pages).
  void clearShop() {
    state = state.copyWith(
      clearShop: true,
      slots: const [],
      sections: const [],
      tables: const [],
      clearSchedule: true,
      clearSection: true,
      clearTable: true,
      clearStart: true,
      clearError: true,
    );
  }

  Future<void> _loadSettings() async {
    final result = await _repo.getBookingSettings();
    if (!mounted) return;
    if (result case Success(:final data)) {
      state = state.copyWith(settings: data);
    }
  }

  Future<void> selectShop(ShopData shop) async {
    state = state.copyWith(
      shop: shop,
      loadingShop: true,
      slots: const [],
      sections: const [],
      tables: const [],
      clearSchedule: true,
      clearSection: true,
      clearTable: true,
      clearStart: true,
      clearError: true,
    );
    final id = shop.id ?? '';
    final results = await Future.wait([
      _repo.getBookingSlots(id),
      _repo.getShopSchedule(id),
      _repo.getShopSections(id),
    ]);
    if (!mounted || state.shop?.id != shop.id) return;

    var next = state.copyWith(loadingShop: false);
    String? error;
    if (results[0] case Success(:final data)) {
      next = next.copyWith(slots: List<BookingSlot>.from(data as List));
    } else if (results[0] case Failure(error: final e)) {
      error = e;
    }
    if (results[1] case Success(:final data)) {
      next = next.copyWith(schedule: data as BookingSchedule);
    }
    if (results[2] case Success(:final data)) {
      next = next.copyWith(
          sections: List<BookingSection>.from(data as List));
    } else if (results[2] case Failure(error: final e)) {
      error ??= e;
    }
    state = error == null ? next : next.copyWith(error: error);
  }

  Future<void> selectSection(BookingSection section) async {
    state = state.copyWith(
      section: section,
      loadingTables: true,
      tables: const [],
      clearTable: true,
      clearError: true,
    );
    final result = await _repo.getSectionTables(section.id);
    if (!mounted || state.section?.id != section.id) return;
    switch (result) {
      case Success(:final data):
        state = state.copyWith(loadingTables: false, tables: data);
      case Failure(:final error):
        state = state.copyWith(loadingTables: false, error: error);
    }
  }

  void selectTable(BookingTable table) {
    state = state.copyWith(
      table: table,
      guests: table.chairCount > 0 && state.guests > table.chairCount
          ? table.chairCount
          : state.guests,
    );
  }

  void selectDay(DateTime day) {
    state = state.copyWith(
      day: DateTime(day.year, day.month, day.day),
      clearStart: true,
    );
  }

  void selectStart(DateTime start) => state = state.copyWith(start: start);

  void selectDuration(int minutes) =>
      state = state.copyWith(durationMinutes: minutes);

  void setGuests(int guests) {
    final max = state.table?.chairCount ?? 0;
    var g = guests < 1 ? 1 : guests;
    if (max > 0 && g > max) g = max;
    state = state.copyWith(guests: g);
  }

  void setNote(String note) => state = state.copyWith(note: note);

  /// Posts the reservation. Returns the failure message, or null when the
  /// reservation was created (then [ReservationFlowState.created] is set).
  Future<String?> submit() async {
    final s = state;
    final slot = s.slot;
    final table = s.table;
    final start = s.start;
    if (slot == null || table == null || start == null) return null;

    state = s.copyWith(isSubmitting: true, clearError: true);
    final result = await _repo.createReservation(
      slotId: slot.id,
      tableId: table.id,
      start: start,
      end: endTimeFor(
        start: start,
        durationMinutes: s.durationMinutes,
        slot: slot,
        schedule: s.schedule,
      ),
      guestCount: s.guests,
      note: s.note,
    );
    if (!mounted) return null;
    switch (result) {
      case Success(:final data):
        state = state.copyWith(isSubmitting: false, created: data);
        return null;
      case Failure(:final error):
        state = state.copyWith(isSubmitting: false, error: error);
        return error;
    }
  }
}

final reservationFlowProvider = StateNotifierProvider.autoDispose<
    ReservationFlowNotifier, ReservationFlowState>(
  (ref) => ReservationFlowNotifier(
    GetIt.instance<BookingRepositoryFacade>(),
    GetIt.instance.isRegistered<ShopsRepositoryFacade>()
        ? GetIt.instance<ShopsRepositoryFacade>()
        : null,
  ),
);
