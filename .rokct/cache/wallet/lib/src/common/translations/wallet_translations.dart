// Copyright (c) 2026 ROKCT INTELLIGENCE (PTY) LTD
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published
// by the Free Software Foundation, version 3.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.

// wallet_sdk's own UI strings for card auto-billing (Ray, 2026-10-17).
//
// The keys are BACKEND translation keys and are also declared in this
// SDK's manifest `tr_keys`, so the compose step adds them to the host's
// TrKeys block. The SDK reads them from [WalletTrKeys] rather than from
// base_sdk's TrKeys so a standalone checkout compiles without a base_sdk
// release (no core change is needed). [kWalletEnTranslations] is the
// English fallback, registered into base_sdk's BundledTranslations by the
// manifest's boot hook: backend-served rows always win, and these keys
// name their strings rather than spell them, so the humanized-key
// fallback would not read well.

class WalletTrKeys {
  WalletTrKeys._();

  static const String payWithANewCard = 'pay_with_a_new_card';
  static const String saveCardForRenewals = 'save_card_for_automatic_renewals';
  static const String cardRenewalConsent = 'card_automatic_renewal_consent';
  static const String acceptCardConsentFirst = 'accept_card_consent_first';
  static const String cardCheckoutTitle = 'card_checkout_title';
  static const String cardCheckoutWaiting = 'card_checkout_waiting';
  static const String cardCheckoutCancelled = 'card_checkout_cancelled';
  static const String cardCheckoutFailed = 'card_checkout_failed';
  static const String cardSavedForRenewals = 'card_saved_for_automatic_renewals';
  static const String savedCards = 'wallet_saved_cards';
  static const String removeCard = 'remove_card';
  static const String removeCardConfirm = 'remove_card_confirm';
  static const String cardRemoved = 'card_removed';
  static const String renewsAutomatically = 'renews_automatically';
  static const String transactionDetails = 'wallet_transaction_details';
  static const String reference = 'wallet_reference';
  static const String transactionType = 'wallet_transaction_type';
  static const String status = 'wallet_status';
}

/// Bundled English for [WalletTrKeys] (the offline/unseeded fallback).
const Map<String, String> kWalletEnTranslations = {
  'pay_with_a_new_card': 'Pay with a new card',
  'save_card_for_automatic_renewals': 'Save this card for automatic renewals',
  // Same words as the server's CARD_CONSENT_TEXT (pay wallet payment.py,
  // version 2026-10-17), which is what the server records as consented.
  'card_automatic_renewal_consent':
      'When a subscription renews, the amount due is charged to this card '
      'automatically. You will not get a reminder before each charge. You '
      'can remove this card at any time in your wallet under Saved cards; '
      'renewals are then paid from your wallet balance.',
  'accept_card_consent_first':
      'Tick the box to agree to automatic renewals, or untick saving the card.',
  'card_checkout_title': 'Pay by card',
  'card_checkout_waiting': 'Confirming your payment…',
  'card_checkout_cancelled': 'Payment cancelled. Nothing was charged.',
  'card_checkout_failed':
      'The payment did not go through. Nothing was added to your wallet.',
  'card_saved_for_automatic_renewals':
      'Card saved. Renewals will be charged to it automatically.',
  'wallet_saved_cards': 'Saved cards',
  'remove_card': 'Remove card',
  'remove_card_confirm':
      'Remove this card? Renewals will then be paid from your wallet balance.',
  'card_removed': 'Card removed',
  'renews_automatically': 'Pays renewals automatically',
  'wallet_transaction_details': 'Transaction details',
  'wallet_reference': 'Reference',
  'wallet_transaction_type': 'Type',
  'wallet_status': 'Status',
};
