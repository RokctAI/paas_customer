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

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:payments_sdk/src/common/application/add_card/add_card_state.dart';

class AddCardNotifier extends StateNotifier<AddCardState> {
  AddCardNotifier() : super(const AddCardState());

  void setCardNumber(String number) {
    state = state.copyWith(cardNumber: number);
    _check();
  }

  void setCardName(String name) {
    state = state.copyWith(cardName: name);
    _check();
  }

  void setDate(String date) {
    state = state.copyWith(date: date);
    _check();
  }

  void setCvc(String cvc) {
    state = state.copyWith(cvc: cvc);
    _check();
  }

  void changeActive(bool isChange) {
    state = state.copyWith(isActiveCard: isChange);
  }

  _check() {
    if (state.cardNumber.isNotEmpty &&
        state.cardName.isNotEmpty &&
        state.date.isNotEmpty &&
        state.cvc.isNotEmpty) {
      state = state.copyWith(isActiveCard: true);
    } else {
      state = state.copyWith(isActiveCard: false);
    }
  }
}
