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

class SubscriptionPayment {
  String amount;
  String itemName;
  late String subscriptionsType;
  String billingDate;
  String recurringAmount;
  String frequency;
  String cycles;

  SubscriptionPayment({
    required this.amount,
    required this.itemName,
    required this.billingDate,
    required this.recurringAmount,
    required this.frequency,
    required this.cycles,
  }) {
    subscriptionsType = '1';
  }

  void setupSubscriptionPayment(String test) {}
}
