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

// The wallet's amount fields follow the backend's currency; rand is only
// the fallback.

import 'package:base_sdk/src/models/data/currency_data.dart';
import 'package:base_sdk/src/services/local_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet_sdk/src/common/utils/wallet_currency.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalStorage.init();
  });

  test('falls back to rand when no currency is loaded', () {
    expect(WalletCurrency.symbol, 'R');
    expect(WalletCurrency.format(50), 'R 50.00');
  });

  test("uses the backend's currency symbol and position", () async {
    await LocalStorage.setSelectedCurrency(
      CurrencyData(id: 'USD', symbol: r'$', position: 'before'),
    );
    expect(WalletCurrency.symbol, r'$');
    expect(WalletCurrency.format(50), r'$ 50.00');

    await LocalStorage.setSelectedCurrency(
      CurrencyData(id: 'EUR', symbol: '€', position: 'after'),
    );
    expect(WalletCurrency.format(1500), '1500.00 €');
  });
}
