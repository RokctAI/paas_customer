Wallet screens and data access for the RokctAI apps: the wallet balance,
transaction history, top-up, and sending money to another user.

- Wallet card: the profile page's `wallet.card` section shows the balance with
  Top-up and Send buttons and a history arrow to `/wallet-history`.
- Top-up (`/wallet-topup`, or a bottom sheet from the card): pick an amount and
  one of the user's saved cards (the default card is preselected).
- Send: to a friend's full phone number, or with a 6-digit code the friend made
  under Receive. There is no user search.
- History (`/wallet-history`): the wallet ledger.

Money moves on the backend (the pay `wallet` Frappe module) through base_sdk's
platform gateway. Amounts show the backend's currency symbol; rand is only the
fallback.

## Features

- History: `getWalletHistory({int start = 0, int limit = 20})` pages the
  user's wallet history rows, newest first.
- Top-up: `walletTopUp({required double amount, String? token, String? idempotencyKey})`
  calls `api.payment.process_wallet_top_up`; `token` is sent as the Saved Card
  docname (`saved_card`). A String result is a gateway redirect URL, a map is
  the completed transaction.
- Send money by phone: `confirmRecipient({required String phone})` looks up one
  recipient by exact full phone number, then
  `sendWalletToPhone({required String phone, required double amount, String? idempotencyKey})`
  moves the balance.
- Send money by code: the receiver calls `generateReceiveClaim({required double amount})`
  to mint a code (and `cancelReceiveClaim({required String code})` to cancel
  it); the sender redeems it with `sendWalletByCode({required String code})`.
- New card: this SDK has no card entry form. "Pay with a new card" opens the
  gateway's own card page (`CardCheckoutPage`, PayFast or Paystack) via the
  wallet backend's `start_card_checkout`. Saving the card is opt-in: the
  "Save this card for automatic renewals" checkbox on `wallet_topup_page.dart`
  is off until ticked, and ticking it shows the consent text.
- Idempotency: top-ups and phone sends carry an `X-Idempotency-Key` header, so
  a retry cannot charge or pay twice.

## Getting started

The package depends on `base_sdk` (a path dependency on `../base`). Register it
once at start-up, after base_sdk is set up:

```dart
import 'package:get_it/get_it.dart';
import 'package:wallet_sdk/wallet_sdk.dart';

WalletSdkDependencies.register(GetIt.instance);
```

`register` binds `WalletRepositoryFacade` to `WalletRepository` and also binds
`WalletDepositRepositoryFacade` to `WalletDepositRepository` (the bank-deposit
route; the facade belongs to this SDK). Each binding is skipped if already
registered.

## Usage

```dart
final wallet = GetIt.instance<WalletRepositoryFacade>();
final history = await wallet.getWalletHistory();
```

Every method returns an `ApiResult`; handle both the success and failure
branches.

## Additional information

Source: `lib/src/common/` (DI in `di/wallet_di.dart`, data access in
`infrastructure/repositories/wallet_repository.dart`). Hosts use the SDK through the `wallet.card` section and the `/wallet-topup` and `/wallet-history` routes (lms imports `WalletCardSection`). Forex and marketplace must not import wallet_sdk; forex reads the balance through its own `ForexWalletBalanceSource` interface.

Feature SDKs must not import each other: this SDK uses only base_sdk.
