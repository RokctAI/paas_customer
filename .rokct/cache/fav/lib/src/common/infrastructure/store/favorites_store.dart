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

import 'package:base_sdk/base_sdk.dart';

/// Reads one JSON document from on-device storage, or null when absent.
typedef FavDocReader = Future<Map<String, dynamic>?> Function(
  String box,
  String key,
);

/// Writes one JSON document to on-device storage.
typedef FavDocWriter = Future<void> Function(
  String box,
  String key,
  Map<String, dynamic> doc,
);

/// On-device store for the shops the user has liked.
///
/// The IDs live in base_sdk's owner-scoped key/value store (`AppDatabase`,
/// box [box]), so likes stay on the device and each signed-in account keeps
/// its own list.
///
/// Legacy list: before fav_sdk owned the likes, they lived in
/// `LocalStorage.getSavedShopsList()` and base_sdk's shop heart toggle still
/// writes there. The first [load] for an account copies that list in (the
/// one-time migration, so nobody loses their likes). After that, [load]
/// replays only what changed in the legacy list since the last snapshot, so a
/// like or unlike made through the legacy toggle still shows up here, and
/// every write made through this store is mirrored back to the legacy list so
/// the heart icon stays in step.
class FavoritesStore {
  FavoritesStore({
    FavDocReader? read,
    FavDocWriter? write,
    List<String> Function()? readLegacy,
    Future<void> Function(List<String>)? writeLegacy,
  })  : _read = read ?? ((b, k) => AppDatabase().getItem(b, k)),
        _write = write ?? ((b, k, d) => AppDatabase().putItem(b, k, d)),
        _readLegacy = readLegacy ?? LocalStorage.getSavedShopsList,
        _writeLegacy = writeLegacy ?? LocalStorage.setSavedShopsList;

  static const String box = 'fav_shops';
  static const String docKey = 'liked';

  final FavDocReader _read;
  final FavDocWriter _write;
  final List<String> Function() _readLegacy;
  final Future<void> Function(List<String>) _writeLegacy;

  /// The liked shop IDs, most recently liked last. Runs the one-time
  /// migration from the legacy list on first use.
  Future<List<String>> load() async {
    final doc = await _read(box, docKey);
    final ids = _list(doc?['ids']);
    final snapshot = doc == null ? null : _list(doc['legacy_snapshot']);
    final legacy = _readLegacy();

    // null snapshot = never migrated: take the whole legacy list.
    final before = snapshot ?? const <String>[];
    final added = legacy.where((id) => !before.contains(id));
    final removed = before.where((id) => !legacy.contains(id)).toSet();

    final next = [
      ...ids.where((id) => !removed.contains(id)),
      ...added.where((id) => !ids.contains(id)),
    ];
    if (doc == null || !_same(next, ids) || !_same(legacy, before)) {
      await _save(next, legacy);
    }
    return next;
  }

  Future<bool> isLiked(String shopId) async =>
      (await load()).contains(shopId);

  /// Likes or unlikes [shopId]; returns true when it is now liked.
  Future<bool> toggle(String shopId) async {
    final ids = await load();
    final liked = !ids.contains(shopId);
    final next = liked
        ? [...ids, shopId]
        : ids.where((id) => id != shopId).toList();
    await _writeLegacy(next);
    await _save(next, next);
    return liked;
  }

  Future<void> _save(List<String> ids, List<String> legacy) => _write(
        box,
        docKey,
        {'ids': ids, 'legacy_snapshot': legacy},
      );

  static List<String> _list(Object? raw) => raw is List
      ? raw.map((e) => e.toString()).toList()
      : <String>[];

  static bool _same(List<String> a, List<String> b) =>
      a.length == b.length && a.toSet().containsAll(b);
}
