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
