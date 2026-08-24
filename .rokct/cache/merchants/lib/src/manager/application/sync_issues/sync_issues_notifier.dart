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

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:merchants_sdk/src/manager/application/sync_issues/sync_issues_state.dart';
import 'package:merchants_sdk/src/manager/infrastructure/services/sync_issues_service.dart';

/// List/resolve state for the sync-issues screen: parked local-first records
/// with per-record retry (requeue the push as-is) and discard (delete record
/// and op) actions. Every action re-reads the boxes, so the list always
/// shows the current parked set.
class SyncIssuesNotifier extends StateNotifier<SyncIssuesState> {
  SyncIssuesNotifier(this._service) : super(const SyncIssuesState());

  final SyncIssuesService _service;

  Future<void> fetch() async {
    state = state.copyWith(isLoading: true);
    final issues = await _service.listNeedsAttention();
    if (!mounted) return;
    state = state.copyWith(isLoading: false, issues: issues);
  }

  /// Returns whether the push was actually requeued; false leaves the
  /// record parked (no matching outbox op to retry).
  Future<bool> retry(SyncIssue issue) async {
    final retried = await _service.retry(issue);
    await fetch();
    return retried;
  }

  Future<void> discard(SyncIssue issue) async {
    await _service.discard(issue);
    await fetch();
  }
}
