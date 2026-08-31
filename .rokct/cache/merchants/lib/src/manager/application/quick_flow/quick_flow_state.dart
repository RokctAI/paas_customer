// Copyright (c) 2026 ROKCT INTELLIGENCE (PTY) LTD
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

import 'package:merchants_sdk/src/manager/domain/interface/quick_flow.dart';

/// Plain immutable state, hand-written `copyWith` — the
/// `MainState`/`SyncIssuesState` call in this SDK (no `build_runner` pass).
///
/// [settings] is the only truth about the surface; [saving] drives nothing
/// but the row's own busy affordance, and [loaded] is what tells the till
/// apart from "autodial is off" and "we have not asked yet" — the
/// difference matters, because an unarmed pad and an unread pad look the
/// same and only one of them should replace the ticket.
class QuickFlowState {
  const QuickFlowState({
    this.settings = const QuickFlowSettings(),
    this.isLoading = false,
    this.loaded = false,
    this.saving = false,
    this.error,
  });

  final QuickFlowSettings settings;
  final bool isLoading;

  /// A read has completed at least once (successfully or not).
  final bool loaded;

  /// A write is in flight.
  final bool saving;

  /// Last failure, surfaced by the page and cleared by the next attempt.
  final String? error;

  QuickFlowState copyWith({
    QuickFlowSettings? settings,
    bool? isLoading,
    bool? loaded,
    bool? saving,
    String? error,
    bool clearError = false,
  }) =>
      QuickFlowState(
        settings: settings ?? this.settings,
        isLoading: isLoading ?? this.isLoading,
        loaded: loaded ?? this.loaded,
        saving: saving ?? this.saving,
        error: clearError ? null : (error ?? this.error),
      );
}
