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

// Demo runs the REAL BannersRepository: base_sdk's DemoGatewayInterceptor
// answers every api.banner.* cmd from templates/assets/demo/promotions.

import 'package:flutter_test/flutter_test.dart';
import 'package:promotions_sdk/src/common/infrastructure/repositories/banners_repository.dart';

import 'support/demo_fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final repo = BannersRepository();

  setUp(startDemoFixtures);
  tearDown(stopDemoFixtures);

  test('banners and ads parse from the fixtures', () async {
    final banners = ok(await repo.getBannersPaginate(page: 1));
    expect(banners.data!.map((b) => b.translation?.title), [
      'Weeknight deals',
      'New Arrivals',
    ]);
    expect(banners.data!.first.img, startsWith('data:image/svg+xml'));
    expect(
      banners.data!.first.shops!.single.translation?.title,
      "Nonna's Pizzeria",
    );
    expect(ok(await repo.getBannerById('1')).id, '1');
    expect(ok(await repo.getAdsPaginate(page: 1)).data, hasLength(1));
    expect(ok(await repo.getAdsById('1')).active, isTrue);
    ok(await repo.likeBanner('1'));
  });
}
