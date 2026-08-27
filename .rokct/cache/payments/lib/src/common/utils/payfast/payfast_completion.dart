// Copyright (c) 2026 ROKCT INTELLIGENCE (PTY) LTD
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

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

/// Pure URL evaluation shared by the mobile (webview_flutter) and Windows
/// (flutter_inappwebview) PayFast WebView variants.
///
/// Detects success/cancel redirects and extracts the tokenization token and
/// card details from the query parameters. Has no side effects.
PayFastCompletionResult evaluatePayFastUrl(String url) {
  debugPrint('PayFast URL check: $url');

  // Parse URL to check for token and other parameters
  final uri = Uri.parse(url);
  final params = uri.queryParameters;

  // Log all parameters to help with debugging
  debugPrint('PayFast URL parameters: $params');

  // Specifically log all custom_str fields
  debugPrint('PayFast custom_str1: ${params['custom_str1']}');
  debugPrint('PayFast custom_str2: ${params['custom_str2']}');
  debugPrint('PayFast custom_str3: ${params['custom_str3']}');
  debugPrint('PayFast custom_str4: ${params['custom_str4']}');
  debugPrint('PayFast custom_str5: ${params['custom_str5']}');

  // Log token parameter
  debugPrint('PayFast token value: ${params['token']}');

  // Match patterns for success
  bool isSuccess =
      url.contains('order-stripe-success') ||
      url.contains('payment-success') ||
      url.contains('redirect-success') ||
      url.contains(AppConstants.baseUrl);

  // Match patterns for cancellation or failure
  bool isFailure =
      url.contains('payment-cancel') ||
      url.contains('payment-failed') ||
      url.contains('redirect-cancel');

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

    debugPrint('PayFast card details found: $cardData');

    return PayFastCompletionResult(
      status: PayFastCompletionStatus.success,
      token: token,
      cardData: cardData,
    );
  } else if (isFailure) {
    return const PayFastCompletionResult(
      status: PayFastCompletionStatus.failure,
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
      debugPrint('PayFast token found: ${result.token}');

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
