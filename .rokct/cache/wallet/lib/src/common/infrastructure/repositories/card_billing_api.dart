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

// compliance-ignore-file: flutter-http-timeout (all HTTP rides base_sdk's
// PlatformGateway Dio, whose BaseOptions set connect/receive timeouts
// centrally; no HTTP client is created in this file)

// Card auto-billing calls (Ray, 2026-10-17): the new-card checkout that
// tops the wallet up and can save the card for automatic renewals, its
// status, and the saved-card list / remove. Every cmd is a wallet frappe
// manifest whitelisted-method key with the app prefix stripped.

import 'package:base_sdk/src/handlers/platform_gateway.dart';

/// The consent version the app shows (the server's CARD_CONSENT_VERSION).
/// The server refuses to save a card for renewals under any other
/// version, so a new wording ships as a new key and a new version here.
const String kCardConsentVersion = '2026-10-17';

/// A saved card as the wallet shows it. The gateway credential never
/// leaves the server; [id] is the handle.
class WalletSavedCard {
  const WalletSavedCard({
    required this.id,
    required this.lastFour,
    required this.cardType,
    required this.expiryDate,
    required this.isDefault,
    required this.renewsAutomatically,
  });

  final String id;
  final String lastFour;
  final String cardType;
  final String expiryDate;
  final bool isDefault;

  /// Saved with the automatic-renewal consent: renewals may charge it.
  final bool renewsAutomatically;

  static bool _flag(Object? v) => v == true || v == 1 || v == '1';

  factory WalletSavedCard.fromJson(Map json) => WalletSavedCard(
        id: (json['id'] ?? json['name'])?.toString() ?? '',
        lastFour: json['last_four']?.toString() ?? '',
        cardType: json['card_type']?.toString() ?? 'Card',
        expiryDate: json['expiry_date']?.toString() ?? '',
        isDefault: _flag(json['is_default']),
        renewsAutomatically: _flag(json['recurring_consent']),
      );

  /// "Visa •••• 4242", or just the type when the gateway sent no digits
  /// (a PayFast tokenised card).
  String get label =>
      lastFour.isEmpty ? cardType : '$cardType •••• $lastFour';
}

/// What start_card_checkout answers: either a signed PayFast form to post
/// or a Paystack page to open, plus the URLs that mean "done"/"cancelled".
class CardCheckout {
  const CardCheckout({
    required this.transaction,
    required this.gateway,
    required this.returnUrl,
    required this.cancelUrl,
    this.redirectUrl,
    this.formAction,
    this.formFields = const {},
  });

  final String transaction;
  final String gateway;
  final String returnUrl;
  final String cancelUrl;
  final String? redirectUrl;
  final String? formAction;
  final Map<String, String> formFields;

  factory CardCheckout.fromJson(Map json) {
    final form = json['form'] is Map ? json['form'] as Map : const {};
    final fields = form['fields'] is Map ? form['fields'] as Map : const {};
    return CardCheckout(
      transaction: json['transaction']?.toString() ?? '',
      gateway: json['gateway']?.toString() ?? '',
      returnUrl: json['return_url']?.toString() ?? '',
      cancelUrl: json['cancel_url']?.toString() ?? '',
      redirectUrl: json['redirect_url']?.toString(),
      formAction: form['action']?.toString(),
      formFields: fields.map((k, v) => MapEntry('$k', '$v')),
    );
  }
}

class CardCheckoutStatus {
  const CardCheckoutStatus({required this.status, required this.cardSaved});

  final String status;
  final bool cardSaved;

  bool get isPaid => status == 'Paid';
  bool get isPending => status == 'Pending';
}

class CardBillingApi {
  const CardBillingApi({PlatformGateway gateway = const PlatformGateway()})
      : _gateway = gateway;

  final PlatformGateway _gateway;

  static dynamic _unwrap(dynamic body) =>
      body is Map && body.containsKey('message') ? body['message'] : body;

  Future<List<WalletSavedCard>> savedCards() async {
    final data = _unwrap(await _gateway.tenant('api.payment.get_saved_cards'));
    return data is List
        ? data.whereType<Map>().map(WalletSavedCard.fromJson).toList()
        : const [];
  }

  Future<void> removeCard(String id) async {
    await _gateway.tenant('api.payment.delete_card', {'card_name': id});
  }

  Future<CardCheckout> startCheckout({
    required double amount,
    required bool saveCard,
  }) async {
    final data = _unwrap(await _gateway.tenant('api.payment.start_card_checkout', {
      'amount': amount,
      'save_card': saveCard ? 1 : 0,
      if (saveCard) 'consent_version': kCardConsentVersion,
    }));
    if (data is! Map) throw StateError('start_card_checkout: $data');
    return CardCheckout.fromJson(data);
  }

  Future<CardCheckoutStatus> checkoutStatus(String transaction) async {
    final data = _unwrap(await _gateway.tenant(
      'api.payment.get_card_checkout_status',
      {'transaction': transaction},
    ));
    final map = data is Map ? data : const {};
    return CardCheckoutStatus(
      status: map['status']?.toString() ?? 'Pending',
      cardSaved: map['card_saved'] == true,
    );
  }
}
