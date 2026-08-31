## 1.4.0

* Saved-card top-up no longer handles the gateway reuse credential.
  `get_saved_cards` stopped returning it, so `WalletTopUpScreen` picks a
  card by its docname and `walletTopUp` sends that on `saved_card`. The
  credential is resolved server-side. Requires the matching wallet
  backend: an older backend reads `token` and will reject the top-up
  rather than charge the wrong thing.

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
