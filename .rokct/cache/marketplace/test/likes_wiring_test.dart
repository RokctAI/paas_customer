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

// Guards the liked-shops move to fav_sdk: the page's state must come from
// fav_sdk's favoritesProvider (on-device likes + the one-time LocalStorage
// migration), not base_sdk's likeProvider, and fav_sdk must resolve as a
// composed sibling SDK (path ../fav) like base_sdk does.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  const likePage = 'lib/src/common/presentation/pages/like/like_page.dart';
  const profile =
      'lib/src/common/presentation/pages/profile/marketplace_profile_sections.dart';

  test('pubspec depends on fav_sdk as a composed sibling', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    expect(pubspec, contains('  fav_sdk:\n    path: ../fav\n'));
  });

  test('LikePage wraps fav_sdk FavoriteShopsPage', () {
    final src = File(likePage).readAsStringSync();
    expect(src, contains("package:fav_sdk/fav_sdk.dart"));
    expect(src, contains('FavoriteShopsPage('));
    expect(src, isNot(contains('likeProvider')));
  });

  test('profile likes badge reads favoritesProvider', () {
    final src = File(profile).readAsStringSync();
    expect(src, contains('favoritesProvider'));
    expect(src, isNot(contains('likeProvider')));
  });
}
