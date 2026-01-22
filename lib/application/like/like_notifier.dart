import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodyman/domain/di/dependency_manager.dart';
import 'package:foodyman/infrastructure/services/services.dart';

import 'like_state.dart';

class LikeNotifier extends Notifier<LikeState> {
  @override
  LikeState build() => const LikeState();

  Future<void> fetchLikeShop(BuildContext context) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isShopLoading: true);
      final list = LocalStorage.getSavedShopsList();
      if (list.isNotEmpty) {
        final response = await shopsRepository.getShopsByIds(list);
        response.when(
          success: (data) async {
            state = state.copyWith(
              isShopLoading: false,
              shops: data.data ?? [],
            );
          },
          failure: (failure, status) {
            state = state.copyWith(isShopLoading: false);
            AppHelpers.showCheckTopSnackBar(context, failure);
          },
        );
      } else {
        state = state.copyWith(isShopLoading: false, shops: []);
      }
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }
}
