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

import 'dart:convert';
import 'dart:typed_data';

import 'package:base_sdk/base_sdk.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:subscriptions_sdk/subscriptions_sdk.dart';

/// A seller's shop purchase is cached in its OWN 'shop_subscriptions' KV
/// row, never in the shared 'user_subscriptions' row a student's access
/// state lives in: a shop purchase must never flip the student's `active`
/// flag (supacharge verification item 7).
void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues(const {});
    await LocalStorage.init();
    await LocalStorage.setUser(ProfileData(id: '42'));
  });

  test('shop purchase lands in shop_subscriptions, student row untouched',
      () async {
    final db = _MemoryDatabase()
      ..boxes['user_subscriptions'] = {
        '42': {
          'active': false,
          'expiryDate': null,
          'title': 'Full Access',
          'allowedSubjects': '["Maths"]',
        },
      };
    final dio = Dio()..httpClientAdapter = _PurchaseAdapter();
    final repo = SubscriptionsRepository(dio, db);

    final result = await repo.purchaseSubscription(
        id: 0, ref: 'Gold', paymentId: 1);
    expect(result, isA<Success>());

    // The student's row is exactly as it was.
    expect(db.boxes['user_subscriptions']!['42'], {
      'active': false,
      'expiryDate': null,
      'title': 'Full Access',
      'allowedSubjects': '["Maths"]',
    });
    // The shop purchase has its own row.
    final shop =
        db.boxes[SubscriptionsRepository.shopSubscriptionBox]!['42']!;
    expect(shop['active'], isTrue);
    expect(shop['userId'], '42');
    expect(SubscriptionsRepository.shopSubscriptionBox,
        isNot('user_subscriptions'));
  });
}

/// Answers subscribe_my_shop with an active Shop Subscription document.
class _PurchaseAdapter implements HttpClientAdapter {
  @override
  Future<ResponseBody> fetch(RequestOptions options,
      Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    return ResponseBody.fromString(
      jsonEncode({
        'message': {
          'name': 'SS-0001',
          'shop': 'shop-1',
          'subscription': 'Gold',
          'type': 'shop',
          'active': 1,
          'price': 150,
          'expired_at': '2026-11-16',
        }
      }),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

/// In-memory KV stand-in for AppDatabase's generic box API.
class _MemoryDatabase implements AppDatabase {
  final boxes = <String, Map<String, Map<String, dynamic>>>{};

  @override
  Future<Map<String, dynamic>?> getItem(String boxName, String key) async {
    final row = boxes[boxName]?[key];
    return row == null ? null : Map<String, dynamic>.from(row);
  }

  @override
  Future<void> putItem(
      String boxName, String key, Map<String, dynamic> json) async {
    boxes.putIfAbsent(boxName, () => {})[key] = Map.of(json);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} not faked');
}
