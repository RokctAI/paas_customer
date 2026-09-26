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

import 'package:flutter/material.dart';
import 'package:base_sdk/base_sdk.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../infrastructure/store/favorites_store.dart';
import 'favorites_provider.dart';
import 'favorites_state.dart';

class FavoritesNotifier extends Notifier<FavoritesState> {
  @override
  FavoritesState build() => const FavoritesState();

  FavoritesStore get _store => ref.read(favoritesStoreProvider);

  /// Loads the liked shop IDs from the device, then the shops themselves.
  Future<void> fetchFavoritesShop(BuildContext context) async {
    final ids = await _store.load();
    state = state.copyWith(shopIds: ids);
    final connected = await AppConnectivity.connectivity();
    if (!connected) {
      state = state.copyWith(isShopLoading: false);
      if (context.mounted) AppHelpers.showNoConnectionSnackBar(context);
      return;
    }
    if (ids.isEmpty) {
      state = state.copyWith(isShopLoading: false, shops: []);
      return;
    }
    state = state.copyWith(isShopLoading: true);
    final response = await shopsRepository.getShopsByIds(ids);
    response.when(
      success: (data) {
        state = state.copyWith(isShopLoading: false, shops: data.data ?? []);
      },
      failure: (failure, status) {
        state = state.copyWith(isShopLoading: false);
        if (context.mounted) AppHelpers.showCheckTopSnackBar(context, failure);
      },
    );
  }

  /// Likes or unlikes a shop on the device; returns true when now liked.
  Future<bool> toggleShop(String shopId) async {
    final liked = await _store.toggle(shopId);
    final ids = await _store.load();
    state = state.copyWith(
      shopIds: ids,
      shops: liked
          ? state.shops
          : state.shops.where((s) => s.id != shopId).toList(),
    );
    return liked;
  }
}
