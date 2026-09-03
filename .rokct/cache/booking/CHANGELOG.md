## 1.1.0

* Recovers the table-reservation flow that was lost in the shell -> SDK
  extraction. Provenance: paas_pos@78ccee4520666ca15788cccf5b9638ee1e6140ab
  (`lib/src/presentation/pages/tables/*`, `tables_notifier.dart`,
  `repository/table_repository*.dart`, the booking models) and
  paas_customer@326092266d7483bf5a35c08bdff32b9909a9e9bd
  (`reservation_shops.dart`, the profile / notification reservation gates,
  `AppHelpers.getReservationEnable`).
  * WHAT WAS LOST: 1.0.x installed one customer template
    (`reservation_shops.dart`, a `{webUrl}/reservations` web hand-off) with
    no route, no repository, no `lib/`, and marketplace_sdk kept its own
    copy behind the profile's Reservation button. The seller side
    (paas_pos's TablesPage: bookings list, status changes, working / closed
    days) was not carried at all, and the flag that shows the button
    (`reservation_enable_for_user`) is not served by core's
    `get_global_settings`, so the button never appeared.
* Customer block (`app_type.customer`): `/reservations` (my reservations,
  cancel) and `/new-reservation` (shop -> section -> table -> day / time /
  duration / guests / note -> confirm; `?shopId=` pre-selects the shop).
  Signed-out users get the login gate. Days honour the shop's working days
  and closed dates; times honour the booking-hours slot, the working day,
  and Reservation Settings' lead time; durations honour the slot's
  `max_time`.
* Seller block (`app_type.manager`; POS shells compose the same manager
  persona - no sibling SDK declares a pos persona, and declaring one would
  make the composer strip `lib/src/manager/` from a pos compose):
  `/shop-reservations` (status tabs; mark
  Accepted / New / Cancelled), `/reservation-tables` (section + table
  CRUD), `/reservation-schedule` (booking hours, weekly working days,
  closed dates). A RESERVATIONS group is registered on base_sdk's
  ProfileSectionRegistry (order 135) from the role di_hook, so the manager
  profile host reaches the screens without merchants_sdk changing.
* Visibility flag: `BookingSettingsBridge` (top-level di_hook, order 30)
  wraps the registered `SettingsRepositoryFacade` so `getGlobalSettings()`
  carries `reservation_enable_for_user` from the booking-owned
  `api.booking.get_booking_settings` (Permission Settings
  `enable_reservations`). `AppHelpers.getReservationEnable()` and
  marketplace's gate work unchanged; core is untouched.
* Server (booking/frappe, same change): `check_shop_permission` no longer
  calls the non-existent `frappe.has_role` (every seller call raised
  before this) and accepts the shop owner (`Shop.user`); reads use
  `get_all` (the booking doctypes grant read to System Manager only, so
  `get_list` returned nothing to customers and sellers); writes are
  authorised by the API's shop scoping and applied with
  `ignore_permissions`; NEW `get_shop_booking_schedule` (the read half of
  `manage_shop_booking_working_days` / `_closed_dates`) and NEW
  `get_booking_settings`.
* Demo (`--dart-define=IS_DEMO=true`): `DemoBookingRepository` and
  `DemoSellerBookingRepository` serve seeded sections, tables, a slot, a
  weekly schedule and an evening of reservations from memory.
* Not recovered (no server counterpart): paas_pos's `getStatistic`
  (booking statistics), `getTableInfo` (`get_booking?id`) and the
  `disableDates` stub.
* Validation: no Dart / Flutter toolchain was available where this was
  written; every import and referenced symbol was checked by hand against
  base_sdk 1.50.x and the sibling SDKs. `flutter analyze` on the composed
  shells is the gate.

## 1.0.2

* Pre-recovery state: one customer template install, no routes.
