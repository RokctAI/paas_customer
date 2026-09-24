## 1.2.2

* fix(payfast): cancelling on PayFast no longer reports the payment as
  successful. Failure is decided first, markers are matched on the URL path
  only, PayFast's own pages are never a completion, and the own-site fallback
  compares hosts.
* fix(payfast): the PayFast passphrase, merchant key, signature, customer
  details, card token and card details are no longer written to device logs.
  Logged URLs are cut to scheme, host and path.

## 1.2.0

* Saved-card payment no longer handles the gateway reuse credential.
  `get_saved_cards` and `tokenize_card` stopped returning it, so
  `processTokenPayment` names the card by its docname and sends it on
  `saved_card`, and `tokenizeCard` returns the new card's docname. The
  credential is resolved server-side. Requires the matching wallet
  backend: an older backend reads `token` and will reject the charge
  rather than charge the wrong thing.

## 1.1.1

* Baseline: first CHANGELOG entry for this SDK. Earlier versions
  predate the file.
