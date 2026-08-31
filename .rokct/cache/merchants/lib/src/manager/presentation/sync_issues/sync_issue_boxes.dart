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

// SYNC ISSUES IN THE STANDARD LIST LANGUAGE — approved design strip frame
// 38c, Ray 2026-08-30 12:23Z ("33 list language = STANDARD for all lists
// ... the box tabs are IN").
//
// The park-and-surface screen is the only list whose cards carry ACTIONS,
// which is why the frame puts it at the two-plane fold: if the treatment
// holds here it holds anywhere. This half is the pure data-in/data-out
// filter behind the new box tabs (chip 710) — All / Shop / Product /
// Order, colour-coded per the 33a set.

import 'dart:ui';

import 'package:base_sdk/src/presentation/theme/app_style.dart';
import 'package:merchants_sdk/src/manager/infrastructure/services/sync_issues_service.dart';

/// One tab of the sync-issue box filter (chip 710).
///
/// The boxes are [SyncIssuesService.boxes] — the three manager local-first
/// stores — plus the leading All. Colours are the 33a status set: Shop =
/// base blue, Product = rate yellow, Order = primary.
enum SyncIssueBox {
  all,
  shop,
  product,
  order;

  /// The KV box this tab filters on; null for [all].
  String? get box => switch (this) {
    SyncIssueBox.all => null,
    SyncIssueBox.shop => 'manager_shops',
    SyncIssueBox.product => 'manager_products',
    SyncIssueBox.order => 'manager_orders',
  };

  /// Translation wire key for the tab label — the same keys the card's
  /// box label already uses.
  String get wire => switch (this) {
    SyncIssueBox.all => 'all',
    SyncIssueBox.shop => 'shop',
    SyncIssueBox.product => 'product',
    SyncIssueBox.order => 'orders',
  };

  /// Tab colour, the 33a set (All takes the neutral base blue).
  Color get color => switch (this) {
    SyncIssueBox.all => AppStyle.blue,
    SyncIssueBox.shop => AppStyle.blue,
    SyncIssueBox.product => AppStyle.rate,
    SyncIssueBox.order => AppStyle.primary,
  };

  /// The rate yellow is a light fill — its count text flips dark, the
  /// 33a `darkPillText` rule.
  bool get darkPillText => this == SyncIssueBox.product;

  /// The issues this tab shows.
  List<SyncIssue> apply(List<SyncIssue> issues) {
    final String? wanted = box;
    if (wanted == null) return issues;
    return issues.where((issue) => issue.box == wanted).toList();
  }

  int countIn(List<SyncIssue> issues) => apply(issues).length;

  /// An unknown box name (a store added later) must never vanish from the
  /// list: it has no tab of its own, so only All shows it — which is what
  /// [apply] already does, and this is the assertion that says so.
  static bool isTabbed(String box) =>
      values.any((tab) => tab.box == box);
}
