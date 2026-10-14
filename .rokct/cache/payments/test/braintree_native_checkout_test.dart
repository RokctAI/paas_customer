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
import 'package:flutter/services.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:payments_sdk/src/common/di/payments_di.dart';
import 'package:payments_sdk/src/common/utils/braintree/braintree_native_checkout.dart';

class _FakeGateway extends PlatformGateway {
  _FakeGateway(this.answers);

  final Map<String, Object? Function(Map<String, dynamic>?)> answers;
  final List<MapEntry<String, Map<String, dynamic>?>> calls = [];

  @override
  Future<dynamic> tenant(String cmd, [Map<String, dynamic>? payload]) async {
    calls.add(MapEntry(cmd, payload));
    final answer = answers[cmd];
    if (answer == null) throw Exception('unexpected $cmd');
    return answer(payload);
  }
}

BraintreeDropInResult _picked(String nonce) => BraintreeDropInResult.fromJson({
  'paymentMethodNonce': {
    'nonce': nonce,
    'typeLabel': 'Visa',
    'description': 'ending in 11',
    'isDefault': false,
  },
  'deviceData': '{"correlation_id":"x"}',
});

void main() {
  final tokenAnswer = {
    'api.payment.braintree_client_token': (Map<String, dynamic>? _) => {
      'client_token': 'ct',
      'amount': '150.00',
      'currency': 'USD',
    },
  };

  test('unsupported platform is unavailable and calls nothing', () async {
    final gw = _FakeGateway({});
    final r = await BraintreeNativeCheckout(
      gateway: gw,
      nativeSupported: false,
    ).pay('order', 'ORD-1');
    expect(r.status, BraintreeNativeStatus.unavailable);
    expect(gw.calls, isEmpty);
  });

  test('success sends the nonce and device data for the document', () async {
    BraintreeDropInRequest? seen;
    final gw = _FakeGateway({
      ...tokenAnswer,
      'api.payment.braintree_checkout': (_) => {
        'status': 'success',
        'transaction_id': 'T-1',
      },
    });
    final r = await BraintreeNativeCheckout(
      gateway: gw,
      nativeSupported: true,
      dropIn: (req) async {
        seen = req;
        return _picked('nonce-1');
      },
    ).pay('order', 'ORD-1');
    expect(r.status, BraintreeNativeStatus.success);
    expect(r.transactionId, 'T-1');
    expect(seen!.clientToken, 'ct');
    expect(seen!.collectDeviceData, isTrue);
    expect(seen!.googlePaymentRequest!.totalPrice, '150.00');
    expect(seen!.paypalRequest!.currencyCode, 'USD');
    expect(gw.calls.first.value, {
      'target_type': 'order',
      'target_id': 'ORD-1',
    });
    final checkout = gw.calls.last;
    expect(checkout.key, 'api.payment.braintree_checkout');
    expect(checkout.value!['nonce'], 'nonce-1');
    expect(checkout.value!['device_data'], '{"correlation_id":"x"}');
    expect(checkout.value!.containsKey('amount'), isFalse);
  });

  test('closing the drop-in is cancelled, nothing charged', () async {
    final gw = _FakeGateway(tokenAnswer);
    final r = await BraintreeNativeCheckout(
      gateway: gw,
      nativeSupported: true,
      dropIn: (_) async => null,
    ).pay('parcel', 'P-1');
    expect(r.status, BraintreeNativeStatus.cancelled);
    expect(gw.calls.length, 1);
  });

  test(
    'missing plugin or token failure is unavailable (WebView fallback)',
    () async {
      final r1 = await BraintreeNativeCheckout(
        gateway: _FakeGateway(tokenAnswer),
        nativeSupported: true,
        dropIn: (_) async => throw MissingPluginException(),
      ).pay('order', 'ORD-1');
      expect(r1.status, BraintreeNativeStatus.unavailable);
      final r2 = await BraintreeNativeCheckout(
        gateway: _FakeGateway({}),
        nativeSupported: true,
        dropIn: (_) async => _picked('n'),
      ).pay('order', 'ORD-1');
      expect(r2.status, BraintreeNativeStatus.unavailable);
    },
  );

  test('a refused or failed charge is failed, never a fallback', () async {
    final declined = await BraintreeNativeCheckout(
      gateway: _FakeGateway({
        ...tokenAnswer,
        'api.payment.braintree_checkout': (_) => {
          'status': 'failed',
          'message': 'Do Not Honor',
        },
      }),
      nativeSupported: true,
      dropIn: (_) async => _picked('n'),
    ).pay('order', 'ORD-1');
    expect(declined.status, BraintreeNativeStatus.failed);
    expect(declined.message, 'Do Not Honor');
    final thrown = await BraintreeNativeCheckout(
      gateway: _FakeGateway(tokenAnswer),
      nativeSupported: true,
      dropIn: (_) async => _picked('n'),
    ).pay('order', 'ORD-1');
    expect(thrown.status, BraintreeNativeStatus.failed);
  });

  test('Apple Pay only with a merchant id', () {
    expect(
      BraintreeNativeCheckout.buildRequest(
        clientToken: 'ct',
        amount: '1.00',
        currency: 'USD',
      ).applePayRequest,
      isNull,
    );
    final req = BraintreeNativeCheckout.buildRequest(
      clientToken: 'ct',
      amount: '1.00',
      currency: 'USD',
      appleMerchantId: 'merchant.example',
    );
    expect(req.applePayRequest!.merchantIdentifier, 'merchant.example');
  });

  test('seam result map', () {
    expect(
      const BraintreeNativeResult(
        BraintreeNativeStatus.success,
        transactionId: 'T',
      ).toMap(),
      {'status': 'success', 'transaction_id': 'T'},
    );
  });

  test('DI registers the seam where orders_sdk looks it up', () {
    final getIt = GetIt.asNewInstance();
    PaymentsSdkDependencies.register(getIt);
    PaymentsSdkDependencies.register(getIt);
    // orders_sdk declares the same function type itself.
    expect(
      getIt.isRegistered<Future<Map<String, Object?>> Function(String, String)>(
        instanceName: 'payments.braintree_native_checkout',
      ),
      isTrue,
    );
  });
}
