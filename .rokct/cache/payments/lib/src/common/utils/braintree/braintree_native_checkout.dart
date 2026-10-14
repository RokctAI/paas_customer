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

import 'package:base_sdk/src/handlers/platform_gateway.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_braintree/flutter_braintree.dart';

/// GetIt instance name under which [BraintreeNativeCheckout.seam] is
/// registered as a [BraintreeNativeSeam], so feature SDKs that must not
/// import payments_sdk (orders, parcels) can reach it by declaring the same
/// function type:
///
/// ```dart
/// final seam = GetIt.I<Future<Map<String, Object?>> Function(String, String)>(
///     instanceName: 'payments.braintree_native_checkout');
/// ```
/// `(targetType, targetId)` -> [BraintreeNativeResult.toMap].
typedef BraintreeNativeSeam =
    Future<Map<String, Object?>> Function(String targetType, String targetId);

const String kBraintreeNativeCheckoutSeam =
    'payments.braintree_native_checkout';

/// Outcome of a native Braintree checkout.
enum BraintreeNativeStatus {
  /// The document was charged and marked Paid server-side.
  success,

  /// Braintree or the server refused the payment.
  failed,

  /// The payer closed the drop-in.
  cancelled,

  /// The native drop-in cannot run here (web, desktop, plugin missing, no
  /// client token): the caller falls back to its WebView path.
  unavailable,
}

class BraintreeNativeResult {
  const BraintreeNativeResult(this.status, {this.message, this.transactionId});

  final BraintreeNativeStatus status;
  final String? message;
  final String? transactionId;

  Map<String, Object?> toMap() => {
    'status': status.name,
    if (message != null) 'message': message,
    if (transactionId != null) 'transaction_id': transactionId,
  };
}

/// Pays an Order / Parcel Order with Braintree's native drop-in:
/// `api.payment.braintree_client_token` -> drop-in (cards, PayPal,
/// Google Pay, and Apple Pay when a merchant id is configured) ->
/// `api.payment.braintree_checkout` with the nonce. The server charges the
/// amount on the document; the amount here only labels the wallet sheets.
///
/// Build-time configuration (all optional, `--dart-define`):
/// `APPLE_PAY_MERCHANT_ID` (Apple Pay is offered only when set),
/// `GOOGLE_PAY_MERCHANT_ID` (required by Google Pay in production),
/// `BRAINTREE_DISPLAY_NAME`, `BRAINTREE_COUNTRY_CODE` (ISO-2, Apple Pay).
class BraintreeNativeCheckout {
  BraintreeNativeCheckout({
    PlatformGateway gateway = const PlatformGateway(),
    Future<BraintreeDropInResult?> Function(BraintreeDropInRequest)? dropIn,
    bool? nativeSupported,
  }) : _gateway = gateway,
       _dropIn = dropIn ?? BraintreeDropIn.start,
       _nativeSupported = nativeSupported;

  final PlatformGateway _gateway;
  final Future<BraintreeDropInResult?> Function(BraintreeDropInRequest) _dropIn;
  final bool? _nativeSupported;

  static const String _appleMerchantId = String.fromEnvironment(
    'APPLE_PAY_MERCHANT_ID',
  );
  static const String _googleMerchantId = String.fromEnvironment(
    'GOOGLE_PAY_MERCHANT_ID',
  );
  static const String _displayName = String.fromEnvironment(
    'BRAINTREE_DISPLAY_NAME',
    defaultValue: 'Checkout',
  );
  static const String _countryCode = String.fromEnvironment(
    'BRAINTREE_COUNTRY_CODE',
    defaultValue: 'US',
  );

  /// True on Android and iOS, the only platforms flutter_braintree supports.
  static bool get isSupportedPlatform =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  bool get _supported => _nativeSupported ?? isSupportedPlatform;

  /// The function registered under [kBraintreeNativeCheckoutSeam]:
  /// `(targetType, targetId) -> {status, message?, transaction_id?}`.
  static Future<Map<String, Object?>> seam(
    String targetType,
    String targetId,
  ) async =>
      (await BraintreeNativeCheckout().pay(targetType, targetId)).toMap();

  static Map<String, dynamic> _map(Object? response) {
    Object? body = response;
    if (body is Map &&
        body['message'] is Map &&
        !body.containsKey('client_token') &&
        !body.containsKey('status')) {
      body = body['message'];
    }
    return body is Map ? body.cast<String, dynamic>() : <String, dynamic>{};
  }

  /// Builds the drop-in request for [clientToken], [amount] and [currency].
  static BraintreeDropInRequest buildRequest({
    required String clientToken,
    String? amount,
    String? currency,
    String appleMerchantId = _appleMerchantId,
    String googleMerchantId = _googleMerchantId,
    String displayName = _displayName,
    String countryCode = _countryCode,
  }) {
    final bool priced =
        amount != null &&
        amount.isNotEmpty &&
        currency != null &&
        currency.isNotEmpty;
    return BraintreeDropInRequest(
      clientToken: clientToken,
      amount: amount,
      collectDeviceData: true,
      cardEnabled: true,
      paypalEnabled: true,
      paypalRequest: priced
          ? BraintreePayPalRequest(
              amount: amount,
              currencyCode: currency,
              displayName: displayName,
              payPalPaymentIntent: PayPalPaymentIntent.sale,
              payPalPaymentUserAction: PayPalPaymentUserAction.commit,
            )
          : null,
      googlePaymentRequest: priced
          ? BraintreeGooglePaymentRequest(
              totalPrice: amount,
              currencyCode: currency,
              billingAddressRequired: false,
              googleMerchantID: googleMerchantId.isEmpty
                  ? null
                  : googleMerchantId,
            )
          : null,
      applePayRequest: (priced && appleMerchantId.isNotEmpty)
          ? BraintreeApplePayRequest(
              paymentSummaryItems: [
                ApplePaySummaryItem(
                  label: displayName,
                  amount: double.tryParse(amount) ?? 0,
                  type: ApplePaySummaryItemType.final_,
                ),
              ],
              displayName: displayName,
              currencyCode: currency,
              countryCode: countryCode,
              merchantIdentifier: appleMerchantId,
              supportedNetworks: const [
                ApplePaySupportedNetworks.visa,
                ApplePaySupportedNetworks.masterCard,
                ApplePaySupportedNetworks.amex,
                ApplePaySupportedNetworks.discover,
              ],
            )
          : null,
    );
  }

  /// Runs the whole flow for `order` / `parcel` [targetType] and the
  /// document's [targetId]. Never throws: problems before the payer sees
  /// the drop-in answer [BraintreeNativeStatus.unavailable] so the caller
  /// can fall back to its WebView path.
  Future<BraintreeNativeResult> pay(String targetType, String targetId) async {
    if (!_supported) {
      return const BraintreeNativeResult(BraintreeNativeStatus.unavailable);
    }
    final Map<String, dynamic> token;
    try {
      token = _map(
        await _gateway.tenant('api.payment.braintree_client_token', {
          'target_type': targetType,
          'target_id': targetId,
        }),
      );
    } catch (e) {
      debugPrint('==> braintree client token failure: $e');
      return BraintreeNativeResult(
        BraintreeNativeStatus.unavailable,
        message: e.toString(),
      );
    }
    final String? clientToken = token['client_token']?.toString();
    if (clientToken == null || clientToken.isEmpty) {
      return const BraintreeNativeResult(BraintreeNativeStatus.unavailable);
    }
    final BraintreeDropInResult? picked;
    try {
      picked = await _dropIn(
        buildRequest(
          clientToken: clientToken,
          amount: token['amount']?.toString(),
          currency: token['currency']?.toString(),
        ),
      );
    } on MissingPluginException {
      return const BraintreeNativeResult(BraintreeNativeStatus.unavailable);
    } catch (e) {
      debugPrint('==> braintree drop-in failure: $e');
      return BraintreeNativeResult(
        BraintreeNativeStatus.unavailable,
        message: e.toString(),
      );
    }
    if (picked == null) {
      return const BraintreeNativeResult(BraintreeNativeStatus.cancelled);
    }
    try {
      final Map<String, dynamic> result = _map(
        await _gateway.tenant('api.payment.braintree_checkout', {
          'target_type': targetType,
          'target_id': targetId,
          'nonce': picked.paymentMethodNonce.nonce,
          if (picked.deviceData != null) 'device_data': picked.deviceData,
        }),
      );
      if (result['status'] == 'success') {
        return BraintreeNativeResult(
          BraintreeNativeStatus.success,
          transactionId: result['transaction_id']?.toString(),
        );
      }
      return BraintreeNativeResult(
        BraintreeNativeStatus.failed,
        message: result['message']?.toString(),
      );
    } catch (e) {
      // The nonce was sent: never fall back to a second payment path here.
      debugPrint('==> braintree checkout failure: $e');
      return BraintreeNativeResult(
        BraintreeNativeStatus.failed,
        message: e.toString(),
      );
    }
  }
}
