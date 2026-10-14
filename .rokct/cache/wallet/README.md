# wallet_sdk

The wallet for Rokct apps: the profile wallet card and the screens behind it.

- **Wallet card** on the profile page (`wallet.card` section): balance, plus
  Top-up and Send.
- **Top-up** (`/wallet-topup`, or a bottom sheet): pick an amount and one
  of the user's saved cards (the default card is preselected). A card is
  saved by paying with it at a gateway checkout; this SDK has no card form.
- **Send**: to a friend's full phone number, or with a 6-digit code the
  friend made under **Receive**. There is no user search.
- **History** (`/wallet-history`): the wallet ledger.

Money moves on the backend (the pay `wallet` Frappe module) through
base_sdk's platform gateway. Top-ups and phone sends carry an
`X-Idempotency-Key` so a retry cannot charge or pay twice. Amounts show the
backend's currency; rand is only the fallback.

Feature SDKs must not import each other: this SDK uses only base_sdk.
