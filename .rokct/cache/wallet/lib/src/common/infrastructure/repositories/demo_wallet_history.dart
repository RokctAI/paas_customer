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

import 'package:base_sdk/src/models/response/wallet_histories_response.dart';

/// The demo wallet-history seed.
///
/// A demo session talks to no backend, and the wallet history behind
/// `/wallet-history` is served by users_sdk's `UserRepositoryFacade`
/// (`api.user.get_wallet_history`), which has no demo variant: its gateway
/// call fails offline, the notifier settles with no rows, and the guided
/// tour captured an empty list. This SDK owns the page, so it owns the
/// demo rows: [WalletHistoryPage] renders these instead of asking the
/// repository whenever `DemoSession.demoActive` answers true (the guided
/// tour build, or a server-marked demo account signed in). Zero behaviour
/// change in a real session.
///
/// Values are Rand and the ledger is self-consistent (net +R 793.00 after
/// a top-up, two purchases, a partial refund and a cash-out), so the
/// screen reads as a lived-in wallet. The demo profile carries no wallet
/// snapshot (base_sdk's wallet card hides a zero balance), so nothing
/// else in the demo contradicts these rows. Timestamps are relative to
/// [now] so the newest row always looks recent in a fresh capture.
/// Types mirror the wire values the page already colours by (`topup`
/// green, `withdraw` red, everything else white).
abstract class DemoWalletHistory {
  DemoWalletHistory._();

  /// Newest first, the order the live endpoint returns.
  static List<WalletData> entries({DateTime? now}) {
    final DateTime base = (now ?? DateTime.now()).toUtc();
    String at(Duration ago) => base.subtract(ago).toIso8601String();
    return [
      WalletData(
        id: 105,
        uuid: 'wh-105',
        walletUuid: 'wallet-1',
        transactionId: 9105,
        type: 'refund',
        price: 42.50,
        note: "Nonna's Pizzeria - garlic bread not delivered",
        status: 'paid',
        createdAt: at(const Duration(hours: 2)),
        updatedAt: at(const Duration(hours: 2)),
      ),
      WalletData(
        id: 104,
        uuid: 'wh-104',
        walletUuid: 'wallet-1',
        transactionId: 9104,
        type: 'payment',
        price: 264.00,
        note: "Nonna's Pizzeria - order 1042",
        status: 'paid',
        createdAt: at(const Duration(days: 1, hours: 3)),
        updatedAt: at(const Duration(days: 1, hours: 3)),
      ),
      WalletData(
        id: 103,
        uuid: 'wh-103',
        walletUuid: 'wallet-1',
        transactionId: 9103,
        type: 'withdraw',
        price: 300.00,
        note: 'Cash-out to FNB •••• 4821',
        status: 'processed',
        createdAt: at(const Duration(days: 3, hours: 5)),
        updatedAt: at(const Duration(days: 3, hours: 5)),
      ),
      WalletData(
        id: 102,
        uuid: 'wh-102',
        walletUuid: 'wallet-1',
        transactionId: 9102,
        type: 'payment',
        price: 185.50,
        note: 'Corner Kitchen - order 1037',
        status: 'paid',
        createdAt: at(const Duration(days: 5, hours: 1)),
        updatedAt: at(const Duration(days: 5, hours: 1)),
      ),
      WalletData(
        id: 101,
        uuid: 'wh-101',
        walletUuid: 'wallet-1',
        transactionId: 9101,
        type: 'topup',
        price: 1500.00,
        note: 'Card top-up •••• 4821',
        status: 'paid',
        createdAt: at(const Duration(days: 8, hours: 2)),
        updatedAt: at(const Duration(days: 8, hours: 2)),
      ),
    ];
  }
}
