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

/// Plain immutable state rather than a `freezed` union.
///
/// Sibling SDKs are split on this — `orders_sdk`/`auth_sdk` commit their
/// generated `*.freezed.dart`, `products_sdk` does not — so a hand-written
/// `copyWith` keeps `merchants_sdk` analyzable without a `build_runner` pass
/// (same call revenue_sdk made for its StatisticsState).
///
/// The legacy state (paas_manager `lib/application/main/main_state.dart`)
/// also carried a `List<Widget> listOfWidget` with no reader anywhere in the
/// app, so it is not carried over.
class MainState {
  const MainState({
    this.selectedIndex = 0,
    this.isScrolling = false,
  });

  /// Which bottom-nav tab is showing: 0 orders, 1 foods, 2 restaurant.
  final int selectedIndex;

  /// Collapses the nav pill while a tab's scroll view is moving.
  final bool isScrolling;

  MainState copyWith({
    int? selectedIndex,
    bool? isScrolling,
  }) =>
      MainState(
        selectedIndex: selectedIndex ?? this.selectedIndex,
        isScrolling: isScrolling ?? this.isScrolling,
      );
}
