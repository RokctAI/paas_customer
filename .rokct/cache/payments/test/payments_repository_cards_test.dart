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

// compliance-ignore-file: flutter-http-timeout (test double: Dio uses a scripted in-memory adapter, no real network)

// Wire-level checks for PaymentsRepository's saved-card calls: the default
// card is set through api.payment.set_default_card, get_saved_cards'
// is_default reaches the model, and a typed-in card is refused without
// sending the card number anywhere.

import 'dart:convert';
import 'dart:typed_data';

import 'package:base_sdk/src/di/injection.dart';
import 'package:base_sdk/src/handlers/api_result.dart';
import 'package:base_sdk/src/handlers/http_service.dart';
import 'package:base_sdk/src/handlers/platform_gateway.dart';
import 'package:base_sdk/src/models/data/saved_card.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:payments_sdk/src/common/infrastructure/repositories/payments_repository.dart';

class _FakeHttpService implements HttpService {
  _FakeHttpService(this.handle);

  final ResponseBody Function(RequestOptions options) handle;

  @override
  Dio client({bool requireAuth = false, bool routing = false}) =>
      Dio(BaseOptions(baseUrl: 'https://unit.test'))
        ..httpClientAdapter = _ScriptedAdapter(handle);
}

class _ScriptedAdapter implements HttpClientAdapter {
  _ScriptedAdapter(this.handle);

  final ResponseBody Function(RequestOptions options) handle;

  @override
  Future<ResponseBody> fetch(RequestOptions options,
          Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async =>
      handle(options);

  @override
  void close({bool force = false}) {}
}

ResponseBody _json(Object? body, [int status = 200]) => ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );

void main() {
  late List<RequestOptions> requests;

  void install(ResponseBody Function(RequestOptions options) handle) {
    if (getIt.isRegistered<HttpService>()) {
      getIt.unregister<HttpService>();
    }
    getIt.registerSingleton<HttpService>(_FakeHttpService((options) {
      requests.add(options);
      return handle(options);
    }));
    addTearDown(() => getIt.unregister<HttpService>());
  }

  setUp(() => requests = []);

  test('setDefaultCard POSTs api.payment.set_default_card with the card name',
      () async {
    install((_) => _json({
          'message': {'status': 'success', 'card_name': 'CARD-0002'},
        }));

    final result = await PaymentsRepository().setDefaultCard('CARD-0002');

    final request = requests.single;
    expect(request.path, kPlatformGatewayPath);
    final body = request.data as Map;
    expect(body['cmd'], 'api.payment.set_default_card');
    expect(body['payload'], {'card_name': 'CARD-0002'});
    expect(result, isA<Success<bool>>());
    expect((result as Success<bool>).data, isTrue);
  });

  test('setDefaultCard reports a server refusal as a failure', () async {
    install((_) => _json({'exc_type': 'PermissionError'}, 403));

    final result = await PaymentsRepository().setDefaultCard('CARD-0009');

    expect(result, isA<Failure<bool>>());
  });

  test('getSavedCards carries is_default into the model', () async {
    install((_) => _json({
          'message': [
            {'name': 'CARD-0002', 'last_four': '1111', 'is_default': 1},
            {'name': 'CARD-0001', 'last_four': '4242', 'is_default': 0},
          ],
        }));

    final result = await PaymentsRepository().getSavedCards();

    final cards = (result as Success<List<SavedCardModel>>).data;
    expect(cards.map((c) => c.isDefault), [true, false]);
  });

  test('tokenizeCard refuses without sending the card details', () async {
    install((_) => _json({'message': {'name': 'CARD-0001'}}));

    final result = await PaymentsRepository().tokenizeCard(
      cardNumber: '4242424242424242',
      cardName: 'Test User',
      expiryDate: '12/30',
      cvc: '123',
    );

    expect(requests, isEmpty);
    expect(result, isA<Failure<String>>());
  });
}
