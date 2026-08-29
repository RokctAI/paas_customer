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
