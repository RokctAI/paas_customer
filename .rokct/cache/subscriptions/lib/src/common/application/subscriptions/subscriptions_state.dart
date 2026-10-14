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
import '../../domain/interface/subscription_payments_provider.dart';
import '../../infrastructure/models/data/subscriptions_data.dart';

part 'subscriptions_state.freezed.dart';

@freezed
sealed class SubscriptionState with _$SubscriptionState {
  const factory SubscriptionState({
    @Default(false) bool isLoading,
    @Default(false) bool isPaymentLoading,
    @Default(1) int selectPayment,
    @Default(0) int selectSubscribe,
    @Default([]) List<SubscriptionData> list,
    @Default([]) List<SubscriptionPaymentMethod>? payments,
  }) = _SubscriptionState;

  const SubscriptionState._();
}
