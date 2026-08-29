## 1.3.0

* Floating-nav back conversion (approved design strip section 12, "no
  double back buttons" — base_sdk 1.39.0 / core#125): `WalletHistoryPage`
  replaces its standalone `PopButton` with the shared `FloatingBottomNav`
  carrying only the leading back segment — one back per screen. Back-only
  (empty tab list) because the host app's root tabs are not reachable
  from this SDK's pushed route; embedded hosts that pass
  `isBackButton: false` still render no back at all.

## 0.0.1

* TODO: Describe initial release.
