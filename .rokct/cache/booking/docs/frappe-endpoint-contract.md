# booking_sdk - Frappe endpoint contract

Every call goes through base_sdk's `PlatformGateway` (POST
`/api/v1/method/rokct.platform.api`, `{cmd, payload}`) and is whitelisted
in `booking/frappe/manifest.json` as `{app_name}.api.booking.<method>`.
The response is the interceptor-unwrapped `message`.

## Customer (`BookingRepositoryFacade`)

| Dart | cmd | payload | auth |
| --- | --- | --- | --- |
| `getBookingSettings` | `api.booking.get_booking_settings` | - | guest |
| `getShopSections` | `api.booking.get_shop_sections_for_booking` | `shop_id` | user |
| `getSectionTables` | `api.booking.get_tables_for_section` | `shop_section_id` | user |
| `getBookingSlots` | `api.booking.get_booking_slots` | `shop_id` | user |
| `getShopSchedule` | `api.booking.get_shop_booking_schedule` | `shop_id` | guest |
| `createReservation` | `api.booking.create_reservation` | `data: {booking, table, start_date, end_date, guest_count, note}` | user |
| `getMyReservations` | `api.booking.get_my_reservations` | - | user |
| `cancelReservation` | `api.booking.cancel_my_booking` | `name` | user |

## Seller (`SellerBookingRepositoryFacade`, manager / pos)

| Dart | cmd | payload |
| --- | --- | --- |
| `getShopReservations` | `api.booking.get_shop_reservations` | `shop_id`, optional `status` |
| `updateReservationStatus` | `api.booking.update_reservation_status` | `name`, `status` (New / Accepted / Cancelled) |
| `getShopSections` | `api.booking.get_shop_sections_for_booking` | `shop_id` |
| `createSection` | `api.booking.create_shop_section` | `data: {shop, area}` |
| `deleteSection` | `api.booking.delete_shop_section` | `name` |
| `getSectionTables` | `api.booking.get_tables_for_section` | `shop_section_id` |
| `createTable` | `api.booking.create_table` | `data: {name, shop_section, chair_count, active}` |
| `deleteTable` | `api.booking.delete_table` | `name` |
| `getBookingSlots` | `api.booking.get_booking_slots` | `shop_id` |
| `createBookingSlot` | `api.booking.create_booking_slot` | `data: {shop, start_time, end_time, max_time, active}` |
| `deleteBookingSlot` | `api.booking.delete_booking_slot` | `name` |
| `getShopSchedule` | `api.booking.get_shop_booking_schedule` | `shop_id` |
| `saveWorkingDays` | `api.booking.manage_shop_booking_working_days` | `shop_id`, `working_days: [{day, from_time, to_time, disabled}]` |
| `saveClosedDates` | `api.booking.manage_shop_booking_closed_dates` | `shop_id`, `closed_dates: [{date}]` |

Whitelisted methods with no Dart caller (kept for other clients):
`create_booking`, `get_booking`, `update_booking`, `delete_booking`,
`create_user_booking`, `get_user_bookings`, `update_user_booking_status`,
`get_shop_bookings`, `get_shop_user_bookings`,
`update_shop_user_booking_status`, `get_my_bookings` (aliases),
`update_booking_slot`, `get_shop_section`, `update_shop_section`,
`get_table`, `update_table`.

## Shapes

* Booking (slot): `name, shop, start_time "HH:mm:ss", end_time, max_time,
  active`. `max_time` <= 24 is read as hours (paas_pos wrote hours), larger
  values as minutes, 0 as unlimited (180 min cap in the picker).
* User Booking (reservation): `name, booking, user, table, start_date,
  end_date ("yyyy-MM-dd HH:mm:ss"), status, guest_count, note`.
* Shop Section: `name, shop, area`. Table: `name` (docname = readable
  name), `shop_section, chair_count, active`.
* `get_booking_settings`: `reservation_enable_for_user "1"/"0"`,
  `reservation_time_durations`, `reservation_before_time`,
  `notification_time_before`, `min_reservation_time`.
