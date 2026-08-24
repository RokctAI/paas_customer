// Copyright (c) 2026 RokctAI
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import 'package:base_sdk/src/database/app_database.dart';

/// Local-first records for manager-created shops, kept in base_sdk's shared
/// KV store (box `manager_shops`).
///
/// A record is written on every `createShop` call (write-through). When the
/// direct backend call succeeds the record is deleted again — the backend is
/// authoritative and reachable. When the backend is unreachable the record
/// stays with `pending_sync: true`, backing the pending-merge UI, until
/// `ShopCreateSyncHandler` drains the queued op and marks it synced (or
/// `needs_attention` on a terminal 4xx, per the park-and-surface policy).
class ManagerShopsLocalStore {
  ManagerShopsLocalStore._();

  static const String box = 'manager_shops';

  static AppDatabase get _db => AppDatabase();

  static Future<void> putPending(
    String localId,
    Map<String, dynamic> record,
  ) =>
      _db.putItem(box, localId, {
        ...record,
        'local_id': localId,
        'pending_sync': true,
        'synced': false,
        'needs_attention': false,
        'created_at': DateTime.now().toIso8601String(),
      });

  static Future<Map<String, dynamic>?> get(String localId) =>
      _db.getItem(box, localId);

  static Future<void> delete(String localId) => _db.deleteItem(box, localId);

  static Future<void> markSynced(
    String localId, {
    String? backendId,
  }) async {
    final record = await _db.getItem(box, localId);
    if (record == null) return;
    record['pending_sync'] = false;
    record['synced'] = true;
    record['needs_attention'] = false;
    record.remove('sync_error');
    if (backendId != null) record['backend_id'] = backendId;
    await _db.putItem(box, localId, record);
  }

  static Future<void> markNeedsAttention(String localId, String error) async {
    final record = await _db.getItem(box, localId);
    if (record == null) return;
    record['pending_sync'] = false;
    record['needs_attention'] = true;
    record['sync_error'] = error;
    await _db.putItem(box, localId, record);
  }

  /// Records not yet reconciled with the backend (pending or parked).
  static Future<List<Map<String, dynamic>>> unsynced() async =>
      (await _db.getAll(box)).where((r) => r['synced'] != true).toList();
}
