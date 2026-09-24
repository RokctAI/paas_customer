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

import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_card_state.freezed.dart';

@freezed
abstract class AddCardState with _$AddCardState {
  const factory AddCardState({
    @Default(false) bool isActiveCard,
    @Default("0000 0000 0000 0000") String cardNumber,
    @Default("") String cardName,
    @Default("") String date,
    @Default("") String cvc,
  }) = _AddCardState;

  const AddCardState._();
}
