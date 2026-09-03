## 1.14.1

* Guided-tour fragment (`templates/tour/marketplace.tour.yaml`): the address
  the first step seeds is "Home" / "14 Jacaranda Road, Melville" instead of
  "Demo address" / "1 Demo Street". The home header renders the seeded
  address verbatim, and these stills are published to the app stores, so
  "Demo address" was on the marketplace_home screenshot. Comments that named
  the mock shop were updated to its new name (Corner Kitchen).

## 1.14.0

* Fix-wave 2026-09-02 (Dart SDK audit, G6 M28/M29): the rest of the
  pre-fork customer route table this SDK owns is declared in the manifest -
  `/searchPage`, `/recommended`, `/recommended_one`, `/recommended_two`,
  `/recommended_three`, `/help`, `/result_filter`, `/create_shop`,
  `/shops_banner`, `/share_referral`, `/share_referral_faq`,
  `/notification_list_page`, `/like_page`, `/address_list_page` - with one
  @RoutePage shell each in `templates/routes/marketplace_route_pages.dart`,
  and the matching base_sdk AppRoutes seams are filled (`pushProfileRoute`,
  `pushSearchRoute`, `pushRecommended*Route`, `pushHelpRoute`,
  `pushResultFilterRoute`, `pushCreateShopRoute`, `pushShopsBannerRoute`,
  `pushShareReferral*Route`, `pushNotificationListRoute`, `pushLikeRoute`,
  `pushAddressListRoute`). Until now every one of those seam calls threw the
  host's `noSuchMethod` StateError. `WalletHistoryPage` is deliberately NOT
  declared (wallet_sdk's `/wallet-history` is canonical); the
  `NotificationListRoute` name is shared with comms_sdk's manager/driver
  shell and only collides if comms ever gains a customer block.
* The 16 raw `context.router.pushNamed('/shop?shopId=' | '/map' |
  '/map?isPop=true' | '/parcel_page' | '/storyList?index=' | '/recommended')`
  sites under `pages/home/**` now go through the seam (`pushShopRoute`,
  `pushViewMapRoute`, `pushParcelRoute`, `pushStoryListRoute`,
  `pushRecommendedRoute`), so they work under any host that composes the
  owning SDK rather than silently failing on an undeclared path. The
  `/login` push in door_to_door is untouched (auth_sdk declares that path).
* Tests: `test/manifest_wiring_test.dart` (routes <-> shells <-> seams).

## 1.13.0

* The profile's Reservation button (both the section-registry host and the
  legacy `ProfilePage`) and the reservation notification tap now push
  booking_sdk's in-app `/reservations` route by path instead of opening
  `ReservationShops` (a `{webUrl}/reservations` web view hand-off) - the
  reservation flow was recovered into booking_sdk 1.1.0 and this SDK's
  copy of `reservation_shops.dart` is removed (nothing else imported it).
  The gate is unchanged: `AppHelpers.getReservationEnable()`, whose
  `reservation_enable_for_user` key booking_sdk's settings bridge now
  serves. A compose without booking_sdk fails through `onFailure` with a
  top snack bar rather than throwing.

## 1.12.0

* `WalletTopUpScreen` tops up by naming the saved CARD, not by handing
  back a credential. `Saved Card.token` is the gateway reuse credential —
  presenting it to the gateway charges that card again — and pay confined
  it to a Frappe `Password` field (pay#46), so it stopped travelling to
  clients. The screen passes `_selectedCard!.id`, the Saved Card docname,
  where it passed `_selectedCard!.token`; that field is gone from
  base_sdk 1.50.0, so this is a build break rather than a silent one.
  `walletTopUp`'s parameter keeps the name `token` because it overrides a
  base_sdk interface — what travels on it is the docname.
* REQUIRES base_sdk >= 1.50.0 and a backend carrying pay#46. Against an
  older backend the top-up is REFUSED without being charged.
* VERSIONING NOTE: the `wallet_topup_screen.dart` change described above
  actually SHIPPED in commerce#92, which carried no marketplace_sdk
  version bump — that PR was deliberately held to two files, so the
  behaviour change went out under 1.11.0. This entry is that bump,
  landed after the fact: a compose resolving marketplace_sdk >= 1.12.0
  is the first one guaranteed to carry it.

## 1.11.0

* The customer edit-own-details sheet (`EditProfileScreen`,
  edit_profile_page.dart) is PROMOTED verbatim to base_sdk 1.45.0
  (approved frame 4d 2026-08-30) as the fleet's shared
  `edit_profile_sheet.dart`, so every GenericProfilePage host — the
  manager hub first — can wire the user-card pencil (chip 109) to the
  one shipped flow. This package's copy becomes a thin re-export at the
  same path, so the "Edit account" row (my_account.dart) and every other
  import keep working; customer behavior is unchanged (same class name,
  same drag-sheet contract, same base_sdk `editProfileProvider` save
  path). Only shipped visual delta: the sheet chrome, previously
  light-only bgGrey@96%, now resolves the dark surface in dark mode
  (the promoted sheet's mode-resolving chrome).

## 1.10.0

* Dark mode for the customer profile hub ("all sdks should have darkmode",
  render-verified 2026-08-28). The hub's sections
  (`marketplace_profile_sections.dart`) drop their last fixed light-theme
  colors for base_sdk's mode-resolving `AppStyle` getters: the square tiles
  fall back to `AppStyle.cardDark` / `AppStyle.textPrimary` instead of
  fixed `AppStyle.white` / `AppStyle.black`; the ghost spacer tiles use a
  transparent border instead of a fixed white one (which glared on dark);
  the delete-account tile swaps `Colors.pink[50]` / `Colors.red` /
  `Colors.pink[700]` for a translucent `AppStyle.red` tint with
  `AppStyle.red` icon/label, legible in both modes; and the member footer
  links + separator dots render `AppStyle.textPrimary` /
  `AppStyle.textDarkSecondary` instead of fixed `AppStyle.black`.
  Adjacent: the wallet history page's Topup / Send / Loan bottom sheets
  (`wallet_history.dart`) open with the real current theme mode
  (`LocalStorage.getAppThemeMode()`) instead of hardcoded
  `isDarkMode: false`.
