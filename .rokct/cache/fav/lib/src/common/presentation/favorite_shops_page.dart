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
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:base_sdk/base_sdk.dart' show ShopData;
import 'package:base_sdk/src/application/main/main_provider.dart';
import 'package:base_sdk/src/services/app_helpers.dart';
import 'package:base_sdk/src/services/tr_keys.dart';
import 'package:base_sdk/src/presentation/components/app_bars/common_app_bar.dart';
import 'package:base_sdk/src/presentation/components/buttons/pop_button.dart';
import 'package:base_sdk/src/presentation/components/market_item.dart';
import 'package:base_sdk/src/presentation/components/badges/empty_badge.dart';
import 'package:base_sdk/src/presentation/theme/theme.dart';

import '../application/favorites/favorites_provider.dart';

/// The liked-shops list, backed by [favoritesProvider].
///
/// Host SDKs pass [shopItemBuilder] to draw each shop in their own card style
/// (the marketplace does, per home layout) and [loadingBuilder] for their own
/// shimmer; the defaults are base_sdk's MarketItem and a spinner.
class FavoriteShopsPage extends ConsumerStatefulWidget {
  final bool isBackButton;
  final Widget Function(BuildContext context, ShopData shop)? shopItemBuilder;
  final WidgetBuilder? loadingBuilder;
  final EdgeInsetsGeometry? listPadding;

  const FavoriteShopsPage({
    super.key,
    this.isBackButton = true,
    this.shopItemBuilder,
    this.loadingBuilder,
    this.listPadding,
  });

  @override
  ConsumerState<FavoriteShopsPage> createState() => _FavoriteShopsPageState();
}

class _FavoriteShopsPageState extends ConsumerState<FavoriteShopsPage> {
  final RefreshController _refreshController = RefreshController();
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _fetch();
    });
    _controller.addListener(_listen);
  }

  Future<void> _fetch() async {
    await ref.read(favoritesProvider.notifier).fetchFavoritesShop(context);
    _refreshController.refreshCompleted();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _controller.removeListener(_listen);
    _controller.dispose();
    super.dispose();
  }

  void _listen() {
    final direction = _controller.position.userScrollDirection;
    if (direction == ScrollDirection.reverse) {
      ref.read(mainProvider.notifier).changeScrolling(true);
    } else if (direction == ScrollDirection.forward) {
      ref.read(mainProvider.notifier).changeScrolling(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(favoritesProvider);
    final brightness = Theme.of(context).brightness;
    return Scaffold(
      backgroundColor: AppStyle.surfaceFor(brightness),
      body: Column(
        children: [
          CommonAppBar(
            child: Text(
              AppHelpers.getTranslation(TrKeys.likeRestaurants),
              style: AppStyle.interNoSemi(
                size: 18,
                color: AppStyle.inkFor(brightness),
              ),
            ),
          ),
          Expanded(
            child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: false,
              physics: const BouncingScrollPhysics(),
              controller: _refreshController,
              scrollController: _controller,
              onRefresh: _fetch,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  top: 24.h,
                  bottom: MediaQuery.paddingOf(context).bottom,
                ),
                child: state.isShopLoading
                    ? (widget.loadingBuilder?.call(context) ??
                        const Center(child: CircularProgressIndicator()))
                    : state.shops.isEmpty
                        ? EmptyBadge()
                        : ListView.builder(
                            padding: widget.listPadding ??
                                EdgeInsets.only(top: 6.h),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.shops.length,
                            itemBuilder: (context, index) {
                              final shop = state.shops[index];
                              return widget.shopItemBuilder
                                      ?.call(context, shop) ??
                                  MarketItem(shop: shop, isSimpleShop: true);
                            },
                          ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: widget.isBackButton
          ? Padding(
              padding: EdgeInsets.only(left: 16.w),
              child: const PopButton(),
            )
          : const SizedBox.shrink(),
    );
  }
}
