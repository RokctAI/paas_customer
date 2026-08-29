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

import 'package:flutter/foundation.dart';

import 'package:base_sdk/src/services/app_connectivity.dart';

/// The POS checkout's connectivity probe, with a debug seam.
///
/// The checkout flips into its offline inversion (frames 11e/11f: offline
/// banner, straight-to-code entry) on this probe's answer. Tests and
/// headless tours can't reach the connectivity_plus platform channel, so
/// [debugConnectivityOverride] pins the answer — the same widget code then
/// renders both flows honestly.
class PosConnectivity {
  PosConnectivity._();

  /// Debug/test seam: non-null pins the probe's answer. Never set in
  /// production code.
  @visibleForTesting
  static bool? debugConnectivityOverride;

  /// True when the till can reach a network. Radio-level probe
  /// (base_sdk's [AppConnectivity.connectivity]) — the offline inversion
  /// is a counter-flow decision, not a backend-health one.
  static Future<bool> check() async {
    final override = debugConnectivityOverride;
    if (override != null) return override;
    try {
      return await AppConnectivity.connectivity();
    } catch (_) {
      // No platform channel (headless harness) — treat as offline: the
      // code path still lets the sale complete.
      return false;
    }
  }
}
