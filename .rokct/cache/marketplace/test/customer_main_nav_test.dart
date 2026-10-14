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

// The customer main page's floating nav (marketplace_sdk 1.17.0, Ray,
// 2026-10-12: "then let marketplace use floating nav"). The page's tabs
// fetch from repositories a test cannot boot, and the page imports freezed
// state that is only generated in a composed app, so the page is guarded the
// way manifest_wiring_test guards the manifest: the source says it draws
// base_sdk's floating pill with the picture and the basket, and no docked
// Material bar.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final String source = File(
    'lib/src/common/presentation/pages/main/customer_main_page.dart',
  ).readAsStringSync();

  test('draws the floating pill, not a docked Material bar', () {
    expect(source, contains('FloatingBottomNav('));
    expect(source, isNot(contains('BottomNavigationBar(')));
  });

  test('carries the picture and the basket', () {
    expect(source, contains('profile: FloatingNavProfile('));
    expect(source, contains('companion: showCart'));
    expect(source, contains('AppRoutes.I.pushOrderRoute(context)'));
  });

  test('the basket badge counts the first user cart\'s lines', () {
    expect(
      source,
      contains('return carts.first.cartDetails?.length ?? 0;'),
    );
  });
}
