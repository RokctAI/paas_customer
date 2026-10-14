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
import 'package:subscriptions_sdk/subscriptions_sdk.dart';

/// list_subscriptions is paged server-side (start/limit); page 1 of the
/// facade walks every server page so a catalog bigger than one page is
/// never cut off.
void main() {
  test('page 1 pages through the whole catalog', () async {
    const total = 230;
    final adapter = _CatalogAdapter(total);
    final dio = Dio()..httpClientAdapter = adapter;
    final repo = SubscriptionsRepository(dio, AppDatabase());

    final res = await repo.getSubscriptions(page: 1);
    final rows = res.when(
      success: (data) => data.data ?? const <SubscriptionData>[],
      failure: (_, __) => const <SubscriptionData>[],
    );
    expect(rows, hasLength(total));
    expect(rows.first.ref, 'plan-0');
    expect(rows.last.ref, 'plan-${total - 1}');
    expect(adapter.starts, [0, 100, 200]);
    expect(adapter.limits.toSet(), {SubscriptionsRepository.catalogPageSize});
  });

  test('later pages are empty so load-more stops', () async {
    final adapter = _CatalogAdapter(5);
    final dio = Dio()..httpClientAdapter = adapter;
    final repo = SubscriptionsRepository(dio, AppDatabase());
    final res = await repo.getSubscriptions(page: 2);
    final rows = res.when(
      success: (data) => data.data ?? const <SubscriptionData>[],
      failure: (_, __) => const <SubscriptionData>[],
    );
    expect(rows, isEmpty);
    expect(adapter.starts, isEmpty);
  });

  test('plan cards name a title-less plan "<Type> Plan"', () {
    String t(String key) => key == TrKeys.plan
        ? 'Plan'
        : key == 'orders'
            ? 'Orders'
            : key;
    expect(
      PlanCardLogic.displayTitle(SubscriptionData(type: 'orders'),
          translate: t),
      'Orders Plan',
    );
    expect(
      PlanCardLogic.displayTitle(SubscriptionData(title: 'Gold'),
          translate: t),
      'Gold',
    );
    expect(PlanCardLogic.displayTitle(SubscriptionData(), translate: t),
        'Plan');
  });
}

/// Serves [total] catalog rows in start/limit pages, recording each ask.
class _CatalogAdapter implements HttpClientAdapter {
  final int total;
  final List<int> starts = [];
  final List<int> limits = [];

  _CatalogAdapter(this.total);

  @override
  Future<ResponseBody> fetch(RequestOptions options,
      Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    final payload = (options.data as Map)['payload'] as Map;
    final start = payload['start'] as int;
    final limit = payload['limit'] as int;
    starts.add(start);
    limits.add(limit);
    final end = (start + limit).clamp(0, total);
    final rows = [
      for (var i = start; i < end; i++)
        {'name': 'plan-$i', 'type': 'orders', 'price': 10, 'month': 1}
    ];
    return ResponseBody.fromString(
      jsonEncode({'message': rows}),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
