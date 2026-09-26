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

// The wallet history page runs the real api.user.get_wallet_history call in
// a demo session: base_sdk's DemoGatewayInterceptor answers it from
// templates/assets/demo/wallet through the real HttpService Dio stack.

import 'dart:io';

import 'package:base_sdk/base_sdk.dart'
    show DemoFixtures, DemoSession, HttpService, LocalStorage, getIt;
import 'package:base_sdk/src/handlers/platform_gateway.dart';
import 'package:base_sdk/src/models/response/wallet_histories_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wallet_sdk/src/common/di/wallet_di.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await LocalStorage.init();
    await DemoSession.instance.activate();
    if (!getIt.isRegistered<HttpService>()) {
      getIt.registerSingleton<HttpService>(HttpService());
    }
    DemoFixtures.reset();
    DemoFixtures.loader = (key) async {
      final f = File(key.replaceFirst(
          '$walletDemoFixtureDirectory/', 'templates/assets/demo/wallet/'));
      return f.existsSync() ? f.readAsString() : null;
    };
    WalletSdkDependencies.register(GetIt.asNewInstance());
  });

  tearDown(() async {
    DemoFixtures.reset();
    await DemoSession.instance.clear();
  });

  Future<WalletHistoriesResponse> page(int n) async =>
      WalletHistoriesResponse.fromJson(await const PlatformGateway().tenant(
        'api.user.get_wallet_history',
        {'limit_start': (n - 1) * 10, 'limit_page_length': 10},
      ));

  test('the demo ledger is five self-consistent rows on page one', () async {
    final rows = (await page(1)).data!;
    expect(rows, hasLength(5));
    expect(rows.map((r) => r.id).toSet(), hasLength(5));
    expect(rows.map((r) => r.type).toSet(),
        containsAll(['topup', 'payment', 'refund', 'withdraw']));
    num net = 0;
    for (final r in rows) {
      expect(r.createdAt, isNotEmpty);
      expect('${r.uuid} ${r.note}'.toLowerCase(), isNot(contains('demo')));
      final credit = r.type == 'topup' || r.type == 'refund';
      net += credit ? r.price! : -r.price!;
    }
    expect(net, 793.0);
  });

  test('page two is empty, so pull-to-load ends cleanly', () async {
    expect((await page(2)).data, isEmpty);
  });

  test('no demo branch remains on the history page', () {
    final src = File(
            'lib/src/common/presentation/pages/history/wallet_history_page.dart')
        .readAsStringSync();
    expect(src, isNot(contains('DemoSession')));
    expect(src, isNot(contains('DemoWalletHistory')));
  });
}
