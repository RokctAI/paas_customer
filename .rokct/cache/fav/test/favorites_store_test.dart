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

import 'package:fav_sdk/src/common/infrastructure/store/favorites_store.dart';
import 'package:flutter_test/flutter_test.dart';

/// In-memory stand-ins for AppDatabase's key/value box and LocalStorage's
/// legacy saved-shops list.
class _Fakes {
  final Map<String, Map<String, dynamic>> docs = {};
  List<String> legacy;
  int writes = 0;
  _Fakes(this.legacy);

  FavoritesStore store() => FavoritesStore(
        read: (b, k) async => docs['$b/$k'],
        write: (b, k, d) async {
          writes++;
          docs['$b/$k'] = Map.of(d);
        },
        readLegacy: () => List.of(legacy),
        writeLegacy: (ids) async => legacy = List.of(ids),
      );
}

void main() {
  test('first load migrates the legacy saved shops so no like is lost',
      () async {
    final f = _Fakes(['s1', 's2']);
    expect(await f.store().load(), ['s1', 's2']);
    expect(f.docs['${FavoritesStore.box}/${FavoritesStore.docKey}']!['ids'],
        ['s1', 's2']);
  });

  test('migration runs once: later loads do not rewrite storage', () async {
    final f = _Fakes(['s1']);
    final store = f.store();
    await store.load();
    final writes = f.writes;
    expect(await store.load(), ['s1']);
    expect(f.writes, writes);
  });

  test('a new install with no legacy likes starts empty', () async {
    final f = _Fakes([]);
    expect(await f.store().load(), isEmpty);
  });

  test('likes and unlikes made through the legacy toggle are replayed',
      () async {
    final f = _Fakes(['s1', 's2']);
    final store = f.store();
    await store.load();
    f.legacy = ['s2', 's3']; // heart: unlike s1, like s3
    expect(await store.load(), ['s2', 's3']);
  });

  test('toggle writes the device store and mirrors the legacy list',
      () async {
    final f = _Fakes(['s1']);
    final store = f.store();
    expect(await store.toggle('s2'), isTrue);
    expect(await store.load(), ['s1', 's2']);
    expect(f.legacy, ['s1', 's2']);
    expect(await store.toggle('s1'), isFalse);
    expect(await store.load(), ['s2']);
    expect(f.legacy, ['s2']);
    expect(await store.isLiked('s1'), isFalse);
  });

  test('a store-only like survives a later legacy reload', () async {
    final f = _Fakes([]);
    final store = f.store();
    await store.toggle('s9');
    expect(await store.load(), ['s9']);
  });
}
