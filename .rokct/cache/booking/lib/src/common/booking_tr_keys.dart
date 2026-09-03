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

/// Wire keys for the strings booking_sdk introduces.
///
/// `lib/` analyzes against raw base_sdk, where the composer-injected
/// `TrKeys` constants from manifest.json `tr_keys` do not exist, so SDK code
/// references the wire keys through this class (orders_sdk / products_sdk
/// precedent). The SAME keys are declared in manifest.json so installed
/// templates can use `TrKeys.<field>`; `AppHelpers.getTranslation`
/// humanizes any key the translation store does not carry yet.
class BookingTrKeys {
  BookingTrKeys._();

  static const String reservation = 'reservation';
  static const String reservations = 'reservations';
  static const String myReservations = 'my_reservations';
  static const String newReservation = 'new_reservation';
  static const String reserveATable = 'reserve_a_table';
  static const String chooseAShop = 'choose_a_shop';
  static const String chooseASection = 'choose_a_section';
  static const String chooseATable = 'choose_a_table';
  static const String chooseDateAndTime = 'choose_date_and_time';
  static const String reservationDate = 'reservation_date';
  static const String reservationTime = 'reservation_time';
  static const String reservationGuests = 'reservation_guests';
  static const String reservationSeats = 'reservation_seats';
  static const String reservationNote = 'reservation_note';
  static const String confirmReservation = 'confirm_reservation';
  static const String reservationCreated = 'reservation_created';
  static const String reservationCancelled = 'reservation_cancelled';
  static const String cancelReservation = 'cancel_reservation';
  static const String cancelThisReservation = 'cancel_this_reservation';
  static const String noReservationsYet = 'no_reservations_yet';
  static const String noSectionsYet = 'no_sections_yet';
  static const String noTablesYet = 'no_tables_yet';
  static const String shopNotTakingReservationsYet =
      'shop_not_taking_reservations_yet';
  static const String noTimesLeftOnThisDay = 'no_times_left_on_this_day';
  static const String logInToReserveATable = 'log_in_to_reserve_a_table';
  static const String reservationStatusNew = 'reservation_status_new';
  static const String reservationStatusAccepted =
      'reservation_status_accepted';
  static const String reservationStatusCancelled =
      'reservation_status_cancelled';
  static const String tables = 'tables';
  static const String tablesAndSections = 'tables_and_sections';
  static const String reservationSchedule = 'reservation_schedule';
  static const String bookingHours = 'booking_hours';
  static const String bookingWorkingDays = 'booking_working_days';
  static const String bookingClosedDates = 'booking_closed_dates';
  static const String addSection = 'add_section';
  static const String addTable = 'add_table';
  static const String sectionName = 'section_name';
  static const String tableName = 'table_name';
  static const String chairCount = 'chair_count';
  static const String markAccepted = 'mark_accepted';
  static const String markNew = 'mark_new';
  static const String markCancelled = 'mark_cancelled';
  static const String addBookingHours = 'add_booking_hours';
  static const String opensAt = 'opens_at';
  static const String closesAt = 'closes_at';
  static const String maxMinutesPerReservation =
      'max_minutes_per_reservation';
  static const String saveSchedule = 'save_schedule';
  static const String scheduleSaved = 'schedule_saved';
  static const String addClosedDate = 'add_closed_date';
  static const String deleteThisSectionAndItsTables =
      'delete_this_section_and_its_tables';
  static const String deleteThisTable = 'delete_this_table';
  static const String noShopOnThisAccount = 'no_shop_on_this_account';
  static const String reservedFor = 'reserved_for';
  static const String reservationsAreNotAvailable =
      'reservations_are_not_available';
}
