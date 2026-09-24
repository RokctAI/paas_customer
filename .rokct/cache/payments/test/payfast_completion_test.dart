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

// A cancelled PayFast payment must never read as paid. The backend sends
// PayFast return_url `<site>/payment-success` (or a caller's redirect_to on
// the same site) and cancel_url `<site>/payment-cancel`, both on the tenant's
// own domain, so the cancel redirect is the case that used to be misread.
//
// Run with --dart-define=BASE_URL=https://shop.example.com to also cover the
// own-host fallback; without it BASE_URL is '' and those cases are skipped.

import 'package:flutter_test/flutter_test.dart';

import 'package:base_sdk/src/constants/app_constants.dart';
import 'package:payments_sdk/src/common/utils/payfast/payfast_completion.dart';

void main() {
  final bool haveBase = AppConstants.baseUrl.isNotEmpty;
  final String site =
      haveBase ? AppConstants.baseUrl : 'https://shop.example.com';

  PayFastCompletionStatus statusOf(String url) =>
      evaluatePayFastUrl(url).status;

  test('cancelling on PayFast is a failure, not a payment', () {
    expect(statusOf('$site/payment-cancel'), PayFastCompletionStatus.failure);
    expect(statusOf('$site/payment-failed'), PayFastCompletionStatus.failure);
    expect(statusOf('$site/redirect-cancel?x=1'),
        PayFastCompletionStatus.failure);
  });

  test('the success redirect is a success', () {
    expect(statusOf('$site/payment-success'), PayFastCompletionStatus.success);
    expect(statusOf('$site/order-stripe-success?id=9'),
        PayFastCompletionStatus.success);
  });

  test('the PayFast checkout page itself is never a completion', () {
    // Its query string carries our own return_url and cancel_url.
    const String encodedReturn = 'https%3A%2F%2Fshop.example.com%2Fpayment-success';
    expect(
      statusOf('https://sandbox.payfast.co.za/eng/process?merchant_id=1'
          '&return_url=$encodedReturn&cancel_url=payment-cancel'),
      PayFastCompletionStatus.none,
    );
    expect(statusOf('https://www.payfast.co.za/eng/process?return_url=x'),
        PayFastCompletionStatus.none);
  });

  test('a marker in the query string does not count, only the path', () {
    expect(statusOf('https://elsewhere.example.org/page?next=payment-success'),
        PayFastCompletionStatus.none);
  });

  test('an unrelated page is not a completion', () {
    expect(statusOf('https://elsewhere.example.org/help'),
        PayFastCompletionStatus.none);
    expect(statusOf('not a url'), PayFastCompletionStatus.none);
  });

  test('a token on the success redirect is captured', () {
    final r = evaluatePayFastUrl('$site/payment-success?token=abc&last_four=4242');
    expect(r.isSuccess, isTrue);
    expect(r.token, 'abc');
    expect(r.cardData['last_four'], '4242');
  });

  test('any other page on our own site is a success (redirect_to)', () {
    expect(statusOf('$site/orders/42'), PayFastCompletionStatus.success);
  }, skip: haveBase ? false : 'needs --dart-define=BASE_URL');

  test('logs never carry the query string', () {
    expect(
      payFastLogUrl('https://sandbox.payfast.co.za/eng/process'
          '?merchant_key=SECRET&signature=abc&email=a%40b.c'),
      'https://sandbox.payfast.co.za/eng/process',
    );
  });
}
