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

// The gateway's own card page for a new-card top-up (Ray, 2026-10-17,
// C1): PayFast's hosted checkout (a signed form the server built, posted
// from here; the passphrase never reaches the app) or Paystack's checkout
// page. Pops 'done' when the gateway sends the payer back, 'cancelled'
// when they cancel, null when they close it. The caller then asks the
// server for the outcome (CardBillingApi.checkoutStatus): the wallet is
// credited only when the gateway confirms the payment to the server.

import 'dart:convert';

import 'package:base_sdk/src/presentation/theme/app_style.dart';
import 'package:base_sdk/src/services/app_helpers.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:wallet_sdk/src/common/infrastructure/repositories/card_billing_api.dart';
import 'package:wallet_sdk/src/common/translations/wallet_translations.dart';

/// The auto-submitting HTML form for a PayFast checkout. Values are
/// HTML-escaped; the fields are posted exactly as the server signed them.
String payFastAutoSubmitHtml(String action, Map<String, String> fields) {
  const escape = HtmlEscape(HtmlEscapeMode.attribute);
  final inputs = fields.entries
      .map((e) =>
          '<input type="hidden" name="${escape.convert(e.key)}" value="${escape.convert(e.value)}">')
      .join();
  return '<!doctype html><html><head><meta name="viewport" '
      'content="width=device-width, initial-scale=1"></head>'
      '<body onload="document.forms[0].submit()">'
      '<form method="POST" action="${escape.convert(action)}">$inputs</form>'
      '</body></html>';
}

/// 'done', 'cancelled' or null for a navigation to [url].
String? checkoutOutcomeFor(String url, CardCheckout checkout) {
  if (checkout.returnUrl.isNotEmpty && url.startsWith(checkout.returnUrl)) {
    return 'done';
  }
  if (checkout.cancelUrl.isNotEmpty && url.startsWith(checkout.cancelUrl)) {
    return 'cancelled';
  }
  // Paystack sends the browser to the server's verify callback.
  if (url.contains('handle_paystack_callback')) return 'done';
  return null;
}

class CardCheckoutPage extends StatefulWidget {
  const CardCheckoutPage({super.key, required this.checkout});

  final CardCheckout checkout;

  @override
  State<CardCheckoutPage> createState() => _CardCheckoutPageState();
}

class _CardCheckoutPageState extends State<CardCheckoutPage> {
  late final WebViewController _controller;
  bool _loading = true;
  bool _closed = false;

  void _finish(String outcome) {
    if (_closed || !mounted) return;
    _closed = true;
    Navigator.of(context).pop(outcome);
  }

  @override
  void initState() {
    super.initState();
    final checkout = widget.checkout;
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            final outcome = checkoutOutcomeFor(request.url, checkout);
            // Paystack's callback must load: the server verifies there.
            if (outcome != null && !request.url.contains('handle_paystack_callback')) {
              _finish(outcome);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onPageFinished: (url) {
            if (mounted) setState(() => _loading = false);
            if (url.contains('handle_paystack_callback')) _finish('done');
          },
        ),
      );
    if (checkout.formAction != null) {
      _controller.loadHtmlString(
        payFastAutoSubmitHtml(checkout.formAction!, checkout.formFields),
      );
    } else if (checkout.redirectUrl != null) {
      _controller.loadRequest(Uri.parse(checkout.redirectUrl!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Scaffold(
      backgroundColor: AppStyle.surfaceFor(brightness),
      appBar: AppBar(
        backgroundColor: AppStyle.surfaceFor(brightness),
        foregroundColor: AppStyle.inkFor(brightness),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Remix.close_line),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(AppHelpers.getTranslation(WalletTrKeys.cardCheckoutTitle)),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_loading)
            Center(child: CircularProgressIndicator(color: AppStyle.primary)),
        ],
      ),
    );
  }
}
