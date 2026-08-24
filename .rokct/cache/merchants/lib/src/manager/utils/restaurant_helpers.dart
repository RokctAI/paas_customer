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

import 'package:base_sdk/src/models/data/shop_data.dart';
import 'package:merchants_sdk/src/manager/utils/week_days.dart';

/// Small display helpers ported from paas_manager's `AppHelpers` members
/// that base_sdk does not carry (`truncate`,
/// `getShopWorkingTimeForToday`).
abstract class RestaurantHelpers {
  RestaurantHelpers._();

  static String truncate(String value, int length) =>
      value.length > length ? value.substring(0, length) : value;

  /// Today's opening hours as `'HH:mm - HH:mm'`, or null when the shop is
  /// closed today / has no schedule — the caller renders its own
  /// "closed today" translation (the legacy helper returned the translated
  /// string itself; returning null keeps raw tr-key strings out of SDK lib
  /// code, where injected TrKeys members don't exist yet).
  ///
  /// Works from the passed [shop] instead of the legacy typed
  /// `LocalStorage.getShop()`, which base_sdk does not have. Time strings
  /// tolerate both legacy `'HH-mm'` and `'HH:mm(:ss)'` storage — only the
  /// digit positions are read.
  static String? workingTimeForToday(ShopData? shop) {
    final days = shop?.shopWorkingDays;
    if (days == null || days.isEmpty) return null;
    final today = WeekDays.values[DateTime.now().weekday - 1].name;
    for (final day in days) {
      if (day.day?.toLowerCase() == today) {
        if (day.disabled ?? false) return null;
        final from = day.from;
        final to = day.to;
        if (from == null || to == null || from.length < 5 || to.length < 5) {
          return null;
        }
        return '${from.substring(0, 2)}:${from.substring(3, 5)}'
            ' - ${to.substring(0, 2)}:${to.substring(3, 5)}';
      }
    }
    return null;
  }
}
