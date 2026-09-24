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

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:base_sdk/src/constants/app_constants.dart';
import 'package:base_sdk/src/di/injection.dart';
import 'package:base_sdk/src/services/app_helpers.dart';
import 'package:base_sdk/src/services/tr_keys.dart';

/// Outcome of inspecting a PayFast redirect URL.
enum PayFastCompletionStatus { success, failure, none }

/// Result of evaluating a redirect URL for PayFast payment completion.
class PayFastCompletionResult {
  final PayFastCompletionStatus status;
  final String? token;
  final Map<String, String> cardData;

  const PayFastCompletionResult({
    required this.status,
    this.token,
    this.cardData = const {},
  });

  bool get isCompletion => status != PayFastCompletionStatus.none;

  bool get isSuccess => status == PayFastCompletionStatus.success;

  bool get hasToken => token != null && token!.isNotEmpty;
}

/// A PayFast-related URL with its query string removed, for logs.
///
/// PayFast checkout URLs carry merchant_id, merchant_key, the signature and
/// the customer's name, email and phone in the query string, and return URLs
/// carry the tokenisation token and card details. debugPrint is NOT compiled
/// out of release builds, so logging a full URL put those in logcat on
/// production handsets. Scheme, host and path say where the WebView is,
/// which is all a log needs.
String payFastLogUrl(String url) {
  final Uri? uri = Uri.tryParse(url);
  if (uri == null || uri.host.isEmpty) return '<unparseable url>';
  return '${uri.scheme}://${uri.host}${uri.path}';
}

/// PayFast's own hosts. A URL on one of these is the checkout itself, never
/// a completion - and the checkout URL carries our return_url and cancel_url
/// in its query string, so matching markers against the whole URL made the
/// checkout page read as a finished payment.
bool _isPayFastHost(String host) =>
    host == 'payfast.co.za' || host.endsWith('.payfast.co.za');

/// Pure URL evaluation shared by the mobile (webview_flutter) and Windows
/// (flutter_inappwebview) PayFast WebView variants.
///
/// Detects success/cancel redirects and extracts the tokenization token and
/// card details from the query parameters. Has no side effects.
///
/// FAILURE IS DECIDED FIRST, and only on the URL's path. The backend sends
/// PayFast a cancel_url of `<site>/payment-cancel` on the tenant's own
/// domain, and a success check that included "the URL contains our base
/// URL" matched that cancel redirect too and ran first - so tapping Cancel
/// on PayFast showed "Payment successful" and treated an unpaid order as
/// paid. With BASE_URL unset, `contains('')` matched every URL.
PayFastCompletionResult evaluatePayFastUrl(String url) {
  final Uri? uri = Uri.tryParse(url);
  if (uri == null || uri.host.isEmpty || _isPayFastHost(uri.host)) {
    return const PayFastCompletionResult(status: PayFastCompletionStatus.none);
  }
  final String path = uri.path.toLowerCase();
  final params = uri.queryParameters;

  final bool isFailure = path.contains('payment-cancel') ||
      path.contains('payment-failed') ||
      path.contains('redirect-cancel');

  // The explicit success markers the backend uses, or - because a caller's
  // `redirect_to` return_url can be any page on the tenant's site - any
  // non-failure page on the app's OWN host. Compared host to host, never as
  // a substring, and never with an empty base URL.
  final String ownHost = Uri.tryParse(AppConstants.baseUrl)?.host ?? '';
  final bool isSuccess = !isFailure &&
      (path.contains('order-stripe-success') ||
          path.contains('payment-success') ||
          path.contains('redirect-success') ||
          (ownHost.isNotEmpty && uri.host == ownHost));

  if (isFailure) {
    return const PayFastCompletionResult(
      status: PayFastCompletionStatus.failure,
    );
  }

  if (isSuccess) {
    // Check for token in various potential places
    final token =
        params['token'] ?? params['pf_token'] ?? params['payfast_token'];

    // Extract card details
    final cardData = {
      'last_four':
          params['card_last_digits'] ??
          params['last_four'] ??
          params['cardlastfour'] ??
          '••••',
      'card_type': params['card_brand'] ?? params['card_type'] ?? 'Card',
      'expiry_date': params['card_expiry'] ?? params['expiry'] ?? '',
      'card_holder_name': params['card_holder'] ?? '',
    };

    return PayFastCompletionResult(
      status: PayFastCompletionStatus.success,
      token: token,
      cardData: cardData,
    );
  }

  // Not a completion URL
  return const PayFastCompletionResult(status: PayFastCompletionStatus.none);
}

/// Applies the completion side effects (token capture, snackbars, callbacks,
/// navigation) for an [evaluatePayFastUrl] result. Shared by both WebView
/// variants.
///
/// Returns `true` when [result] represents a completion (so the caller should
/// cancel the navigation), `false` otherwise.
bool handlePayFastCompletion({
  required BuildContext context,
  required bool Function() isMounted,
  required PayFastCompletionResult result,
  Function(bool)? onComplete,
  Function(String, Map<String, String>)? onTokenCaptured,
}) {
  if (!result.isCompletion) return false;

  if (result.isSuccess) {
    // If token exists, capture it along with card details
    if (result.hasToken) {
      debugPrint('PayFast token captured');

      // Notify about token capture using callback
      if (onTokenCaptured != null) {
        // Pass both token and card details to the callback
        onTokenCaptured(result.token!, result.cardData);
      } else {
        // If no callback is provided, save directly
        savePayFastToken(result.token!, result.cardData);
      }
    } else {
      debugPrint('No token found in return URL');
    }

    // Show success message
    if (!isMounted()) return true;
    AppHelpers.showCheckTopSnackBarDone(
      context,
      AppHelpers.getTranslation(TrKeys.paymentSuccessful),
    );

    // Perform success actions
    if (onComplete != null) {
      onComplete(true);
    }

    // Navigate back to main route
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!isMounted()) return;
      AppHelpers.goHome(context);
    });

    return true;
  } else {
    // Show error message
    if (!isMounted()) return true;
    AppHelpers.showCheckTopSnackBarInfo(
      context,
      AppHelpers.getTranslation(TrKeys.paymentRejected),
    );

    // Inform parent about failure
    if (onComplete != null) {
      onComplete(false);
    }

    // Navigate back
    if (!isMounted()) return true;
    Navigator.pop(context);

    return true;
  }
}

/// Saves a captured PayFast token (with card details) via the payments
/// repository. Used when no [onTokenCaptured] callback is provided.
Future<void> savePayFastToken(
  String token,
  Map<String, String> cardData,
) async {
  try {
    // Use PaymentRepository to save the token with card details
    await paymentsRepository.tokenizeAfterPayment(
      '', // Empty card number since we're using token
      cardData['card_holder_name'] ?? '',
      cardData['expiry_date'] ?? '',
      '', // Empty CVC since we're using token
      token, // Pass the token
      cardData['last_four'] ?? '••••',
      cardData['card_type'] ?? 'Card',
    );

    debugPrint('PayFast token and card details saved successfully');
  } catch (e) {
    debugPrint('Failed to save PayFast token and card details: $e');
  }
}
