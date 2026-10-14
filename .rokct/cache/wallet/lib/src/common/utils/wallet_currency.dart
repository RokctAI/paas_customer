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

import 'package:base_sdk/src/services/local_storage.dart';

/// The currency the wallet's amount fields and preset chips show.
///
/// The backend sets the real currency: the app stores the backend's
/// selected currency (`CurrencyNotifier.fetchCurrency` →
/// [LocalStorage.getSelectedCurrency]), the same store every money string
/// reads. South African rand ("R", symbol first) is only the fallback for
/// an app that has not loaded one yet.
abstract class WalletCurrency {
  WalletCurrency._();

  static const String fallbackSymbol = 'R';

  /// The backend currency's symbol, else [fallbackSymbol].
  static String get symbol {
    final String? stored = LocalStorage.getSelectedCurrency()?.symbol;
    return (stored == null || stored.trim().isEmpty) ? fallbackSymbol : stored;
  }

  /// [amount] with two decimals and the symbol on the side the backend
  /// currency puts it ("before" unless it says "after").
  static String format(num amount) {
    final String text = amount.toStringAsFixed(2);
    return LocalStorage.getSelectedCurrency()?.position == 'after'
        ? '$text $symbol'
        : '$symbol $text';
  }
}
