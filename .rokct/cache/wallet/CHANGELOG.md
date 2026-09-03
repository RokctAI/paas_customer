## 1.6.0

* **Design strip frames 49g/49h/49i — the bank-deposit route (client
  half).** A driver whose wallet went negative (cash docked at Delivered)
  pays into the tenant's bank account, photographs the slip, and a person
  approves it; nothing moves in the wallet until then. New, exported from
  the barrel: `WalletDepositRepositoryFacade` (this SDK's own seam —
  base_sdk carries no deposit facade), `WalletDepositRepository` over the
  platform gateway (`cmd: api.wallet.get_deposit_destination /
  submit_deposit_request / list_deposit_requests /
  list_pending_deposit_requests / approve_deposit_request /
  reject_deposit_request`), and the typed records
  `WalletDepositDestination`, `WalletDepositRecord`, `WalletDepositStatus`,
  `WalletDepositSubmitResponse`, `WalletDepositResolution`.
  `WalletSdkDependencies.register` registers the facade (guarded). The slip
  is uploaded through the fleet's multipart gallery seam by the caller;
  only its URL rides the envelope. Guarded by
  `test/wallet_deposit_repository_gateway_test.dart`. Requires the
  matching wallet backend (frappe manifest keys `{app_name}.api.wallet.*`,
  doctypes `Wallet Deposit Request` + `Wallet Deposit Settings`, Wallet
  History type `Deposit`).

## 1.5.0

* Implements base_sdk's `AppRoutes.pushWalletHistoryRoute` seam: the
  manifest now declares an `app_routes` entry whose body pushes the
  `WalletHistoryRoute` this SDK already declares at `/wallet-history`.
  Hosts that compose wallet_sdk get the method injected into
  `_HostAppRoutes` (the seam previously threw `noSuchMethod`'s
  StateError from marketplace_sdk's profile page). Guarded by
  `test/manifest_wiring_test.dart`.

## 1.4.2

* `WalletRepository.getWalletHistory` goes through the platform gateway
  (`POST /api/v1/method/rokct.platform.api`, `cmd:
  api.user.get_wallet_history`, payload `{start, limit}`) instead of the
  legacy per-method `/api/method/paas.api.user.get_wallet_history` GET,
  which no composed backend serves. The response is unwrapped per the
  gateway envelope (`api_response(data=rows)`). Optional `start`/`limit`
  kwargs mirror the server signature; facade callers get the first page
  as before. Cross-SDK edge: the `api.user.get_wallet_history` alias is
  whitelisted by the users frappe half, not this SDK's.

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
