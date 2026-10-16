# Changelog

## 1.7.1

* fix(subscriptions): a shop purchase is cached in its own `shop_subscriptions` KV row (`SubscriptionsRepository.shopSubscriptionBox`), never in the student's shared `user_subscriptions` row, so buying a shop plan can no longer flip a student's `active` flag.
* fix(subscriptions): `subscribe_my_shop` locks the seller's Wallet row (`frappe.get_doc(..., for_update=True)`, SELECT ... FOR UPDATE) and checks the balance under the lock, so two concurrent purchases cannot overspend the wallet.

## 1.7.0

* fix(subscriptions): the plan catalog is no longer cached as the user's subscription (`active` there means "published"). The user's own row is cached, merged, from the purchase result.
* fix(subscriptions): a wallet purchase is one call: the server now charges the wallet before activating the plan, and the dead legacy `/api/v1/payments/subscription/{id}/transactions` follow-up is gone (`createTransaction` is deprecated).
* fix(subscriptions): page 1 of `getSubscriptions` pages through the whole catalog (`list_subscriptions` start/limit).
* fix(subscriptions): plan cards name a plan with no title "<Type> Plan" (`PlanCardLogic.displayTitle`) instead of the bare type name.

## 1.6.2

* fix(theme): widgets read their surface, card, stroke and ink colours from Theme.of(context) at build time (AppStyle.surfaceFor/cardFor/cardAltFor/strokeFor/subtleStrokeFor/inkFor/secondaryInkFor/faintFor) instead of the AppStyle.isDark-resolved statics, so a live dark/light switch restyles open pages instead of leaving the old mode's colours (Ray, 2026-10-04).

## 1.6.1

- Icons move to Remixicon (`.rokct/decision_log.md`, "Icon package
  standard"): every Material `Icons.*` is now the matching `Remix.*`
  glyph, and the pubspec pins `remixicon: ^1.4.1`. Icons only.

## 1.6.0

- The purchase dialog's payment-method row is now the public
  `SubscriptionPaymentMethodRow`, coloured through the theme seams so it
  reads in light mode too. The installed dialog template uses it unchanged in
  behaviour; loyalty_sdk's customer plans reuse it for the wallet / saved card
  choice.
- Backend (subscriptions/frappe): new shared recurring-billing engine,
  `src/tenant/recurring/rules.py` (due, retry window, late start, resume,
  card top-up amount; moved from lms `rlms.renewal_rules`) and
  `recurring/billing.py` (saved-card top-up for the shortfall, then wallet
  debit through pay's `debit_wallet_for_payment`; moved from lms
  `rlms.renewal_card`). LMS learner renewals and commerce customer
  subscriptions both use it.

## 1.5.0

- Demo runs the real `SubscriptionsRepository`: `subscriptionRepositoryProvider`
  answers it over base_sdk's `HttpService` Dio unless the host overrides it,
  and base_sdk 1.73.0's `DemoGatewayInterceptor` answers its
  `api.subscription.*` cmds from `templates/assets/demo/subscriptions/<cmd>.json`
  (installed to `assets/demo/subscriptions`) during a demo session.
- Deleted `DemoSubscriptionsRepository`. `DemoSubscriptionPaymentsProvider`
  (no platform cmd here) moved to `demo_subscription_payments_provider.dart`.
  Needs base_sdk 1.73.0.

## 1.3.0

Approved section-40 redesign of the manager /subscriptions screens
(frames 40a/40b/40c, approved 2026-08-30), in the settled dark plane
language. The screens are shops subscribing to THEIR TENANT's plan
catalog (`api.subscription.list_subscriptions` over the tenant
`Subscription` doctype); platform/control-tier plans never appear here.

- `ManagerSubscriptionsPage` rebuilt on base_sdk's `PlaneHost`: the page
  declares two planes (the payment-class money cap — the leftover plane
  trails bare at the END on tablets), header + count pill (chip 700),
  full-width current-plan card (chip 760), and one plan card per plane
  column (chip 761). Pushed page ⇒ bottom-END corner back pill (chip
  347) — deliberately absent while the payment pane is up (the 11u
  payment exception; the escape is the pane's own Cancel).
- Plan cards render the catalog row's real field fork: price + cycle
  (derived from the row's `month`), trial badge (chip 762) only when the
  row carries `trial_period_days`, and the INCLUDES list on the card
  face (chip 763 — `features` lines with badge-markup parsing, falling
  back to the legacy product/order-limit fields); the old "?" info
  dialog is retired. No plan fact is hardcoded; an empty tenant catalog
  gets an honest empty state.
- CURRENT-PLAN GUARD (chip 768): the held plan's card shows a disabled
  "Current plan" CTA instead of erroring after the tap — no accidental
  tap can start a charge; the charge only ever fires from the pane's
  explicit amount-labelled Pay (chip 767).
- `PaymentDialog` skeleton grown into the real purchase surface: shared
  `SubscriptionPaymentBody` (chip 765) used as the last-plane payment
  pane at plane widths and as the shipped phone dialog, with
  payment-method radio rows (chip 766: wallet balance / webview-gateway
  hints, cash filtered by the notifier), Total, fixed-amount Pay +
  Cancel. No keypad by design — the plan price is fixed. The composer's
  `// @subscription-payments-list` / `// @subscription-payments-action`
  layout-integration markers are preserved inside the new pane's widget
  lists.
- `SubscriptionData` gains tolerant `trial_period_days`, `features`, and
  link-string `subscription` (`subscriptionRef`) parsing; new
  `PlanCardLogic` (exported) carries the current-plan guard, includes
  parsing, cycle/trial labels, and an optional client-side `category`
  filter over the tenant catalog's `type` field with the same
  exact-equality semantics as the Next.js frontend's existing plan
  category filtering (a server-side category kwarg would need backend
  work and is out of this wave).

## 1.2.0 and earlier

- Pre-changelog history; see git log.
