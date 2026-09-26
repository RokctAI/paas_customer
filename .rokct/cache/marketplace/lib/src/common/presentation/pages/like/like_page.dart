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

import 'package:auto_route/auto_route.dart';
import 'package:fav_sdk/fav_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:base_sdk/src/services/app_helpers.dart';
import 'package:base_sdk/src/presentation/components/market_item.dart';
import 'package:marketplace_sdk/src/common/presentation/pages/home/home_zero/shimmer/all_shop_shimmer.dart';
import 'package:marketplace_sdk/src/common/presentation/pages/home/home_four/widgets/market_one_item.dart';
import 'package:marketplace_sdk/src/common/presentation/pages/home/home_four/widgets/market_three_item.dart';
import 'package:marketplace_sdk/src/common/presentation/pages/home/home_four/widgets/market_two_item.dart';

/// The marketplace's liked-shops tab and `/like_page` route.
///
/// The page itself (list, refresh, empty state) and the liked-shop IDs are
/// fav_sdk's [FavoriteShopsPage] / favoritesProvider; this wrapper only
/// supplies the shop card that matches the active home layout
/// (`AppHelpers.getType()`) and the marketplace shimmer.
@RoutePage()
class LikePage extends StatelessWidget {
  final bool isBackButton;

  const LikePage({super.key, this.isBackButton = true});

  @override
  Widget build(BuildContext context) {
    final type = AppHelpers.getType();
    return FavoriteShopsPage(
      isBackButton: isBackButton,
      listPadding: type == 2
          ? EdgeInsets.symmetric(horizontal: 16.r)
          : EdgeInsets.only(top: 6.h),
      loadingBuilder: (_) => const AllShopShimmer(isTitle: false),
      shopItemBuilder: (context, shop) => switch (type) {
        0 => MarketItem(shop: shop, isSimpleShop: true),
        1 => MarketOneItem(shop: shop, isSimpleShop: true),
        2 => MarketTwoItem(shop: shop, isSimpleShop: true),
        _ => MarketThreeItem(shop: shop, isSimpleShop: true),
      },
    );
  }
}
