// Copyright (c) 2026 ROKCT INTELLIGENCE (PTY) LTD
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

import 'package:flutter/material.dart';
import 'package:base_sdk/src/handlers/api_result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:base_sdk/src/models/data/shop_data.dart';
import 'package:merchants_sdk/src/manager/application/restaurant/working_days/working_days_state.dart';
import 'package:merchants_sdk/src/manager/domain/interface/seller_shop.dart';

/// Port of paas_manager `application/restaurant/working_days/
/// working_days_notifier.dart`; the repository is this SDK's
/// [SellerShopRepositoryFacade] instead of the legacy `UsersInterface`, and
/// the day model is base_sdk's [ShopWorkingDay].
class WorkingDaysNotifier extends StateNotifier<WorkingDaysState> {
  final SellerShopRepositoryFacade _shopRepository;

  WorkingDaysNotifier(this._shopRepository) : super(const WorkingDaysState());

  Future<void> updateWorkingDays({
    required List<ShopWorkingDay> days,
    String? shopUuid,
    VoidCallback? updateSuccess,
  }) async {
    state = state.copyWith(isLoading: true, workingDays: days);
    final response = await _shopRepository.updateShopWorkingDays(
      workingDays: days,
      uuid: shopUuid,
    );
    response.when(
      success: (data) {
        state = state.copyWith(isLoading: false);
        updateSuccess?.call();
      },
      failure: (failure, status) {
        state = state.copyWith(isLoading: false);
        debugPrint('==> error update working days $failure');
      },
    );
  }

  void setShopWorkingDays(List<ShopWorkingDay> workingDays) {
    state = state.copyWith(workingDays: workingDays);
  }

  void changeIndex(ShopWorkingDay? day) {
    int index = 0;
    if (day != null) {
      for (int i = 0; i < state.workingDays.length; i++) {
        if (state.workingDays[i].id == day.id) {
          index = i;
        }
      }
    }
    state = state.copyWith(currentIndex: index);
  }
}
