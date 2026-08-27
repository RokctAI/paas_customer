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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:base_sdk/src/services/tr_keys.dart';
import 'package:base_sdk/src/application/home/home_notifier.dart';
import 'package:base_sdk/src/application/home/home_provider.dart';
import 'package:base_sdk/src/services/app_helpers.dart';
import 'package:base_sdk/src/presentation/components/app_bars/common_app_bar.dart';
import 'package:base_sdk/src/presentation/components/buttons/pop_button.dart';
import 'package:base_sdk/src/presentation/theme/app_style.dart';
import 'market_two_item.dart';
import 'package:marketplace_sdk/src/common/presentation/pages/home/home_four/widgets/recommended_two_item.dart';

// // // @RoutePage()
class RecommendedTwoPage extends ConsumerStatefulWidget {
  final bool isNewsOfPage;
  final bool isShop;
  final bool isPopular;

  const RecommendedTwoPage({
    super.key,
    this.isNewsOfPage = false,
    this.isShop = false,
    this.isPopular = false,
  });

  @override
  ConsumerState<RecommendedTwoPage> createState() => _RecommendedPageState();
}

class _RecommendedPageState extends ConsumerState<RecommendedTwoPage> {
  late HomeNotifier event;
  final RefreshController _recommendedController = RefreshController();

  @override
  void didChangeDependencies() {
    event = ref.read(homeProvider.notifier);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeProvider);
    return Scaffold(
      body: Column(
        children: [
          CommonAppBar(
            child: Text(
              AppHelpers.getTranslation(
                widget.isShop
                    ? TrKeys.shops
                    : widget.isPopular
                    ? TrKeys.popular
                    : widget.isNewsOfPage
                    ? TrKeys.newsOfWeek
                    : TrKeys.recommended,
              ),
              style: AppStyle.interNoSemi(size: 18.sp),
            ),
          ),
          widget.isShop
              ? Expanded(
                  child: state.shops.isNotEmpty
                      ? SmartRefresher(
                          controller: _recommendedController,
                          enablePullDown: true,
                          enablePullUp: true,
                          onLoading: () async {
                            await event.fetchShopPage(
                              context,
                              _recommendedController,
                            );
                          },
                          onRefresh: () async {
                            await event.fetchShopPage(
                              context,
                              _recommendedController,
                              isRefresh: true,
                            );
                          },
                          child: AnimationLimiter(
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 8.r,
                                    crossAxisSpacing: 8.r,
                                    mainAxisExtent: 200.r,
                                  ),
                              padding: EdgeInsets.symmetric(horizontal: 16.r),
                              shrinkWrap: true,
                              itemCount: state.shops.length,
                              itemBuilder: (context, index) =>
                                  AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration: const Duration(milliseconds: 375),
                                    child: SlideAnimation(
                                      verticalOffset: 50.0,
                                      child: FadeInAnimation(
                                        child: MarketTwoItem(
                                          isShop: true,
                                          shop: state.shops[index],
                                        ),
                                      ),
                                    ),
                                  ),
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height / 2,
                              child: SvgPicture.asset("assets/svgs/empty.svg"),
                            ),
                            16.verticalSpace,
                            Text(
                              AppHelpers.getTranslation(TrKeys.noRestaurant),
                            ),
                          ],
                        ),
                )
              : widget.isPopular
              ? Expanded(
                  child: state.allShops.isNotEmpty
                      ? SmartRefresher(
                          controller: _recommendedController,
                          enablePullDown: true,
                          enablePullUp: true,
                          onLoading: () async {
                            await event.fetchAllShopsPage(
                              context,
                              _recommendedController,
                            );
                          },
                          onRefresh: () async {
                            await event.fetchAllShopsPage(
                              context,
                              _recommendedController,
                              isRefresh: true,
                            );
                          },
                          child: AnimationLimiter(
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 8.r,
                                    crossAxisSpacing: 8.r,
                                    childAspectRatio: 0.70,
                                  ),
                              padding: REdgeInsets.symmetric(horizontal: 16),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: state.allShops.length,
                              itemBuilder: (context, index) =>
                                  AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration: const Duration(milliseconds: 375),
                                    child: SlideAnimation(
                                      verticalOffset: 50.0,
                                      child: FadeInAnimation(
                                        child: MarketTwoItem(
                                          shop: state.allShops[index],
                                          isSimpleShop: true,
                                        ),
                                      ),
                                    ),
                                  ),
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height / 2,
                              child: SvgPicture.asset("assets/svgs/empty.svg"),
                            ),
                            16.verticalSpace,
                            Text(
                              AppHelpers.getTranslation(TrKeys.noRestaurant),
                            ),
                          ],
                        ),
                )
              : widget.isNewsOfPage
              ? Expanded(
                  child: state.allShops.isNotEmpty
                      ? SmartRefresher(
                          controller: _recommendedController,
                          enablePullDown: true,
                          enablePullUp: true,
                          onLoading: () async {
                            await event.fetchAllShopsPage(
                              context,
                              _recommendedController,
                            );
                          },
                          onRefresh: () async {
                            await event.fetchAllShopsPage(
                              context,
                              _recommendedController,
                              isRefresh: true,
                            );
                          },
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.allShops.length,
                            padding: EdgeInsets.symmetric(
                              vertical: 24.h,
                              horizontal: 16.w,
                            ),
                            itemBuilder: (context, index) => Padding(
                              padding: REdgeInsets.only(bottom: 12),
                              child: MarketTwoItem(
                                shop: state.allShops[index],
                                isSimpleShop: true,
                              ),
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height / 2,
                              child: SvgPicture.asset("assets/svgs/empty.svg"),
                            ),
                            16.verticalSpace,
                            Text(
                              AppHelpers.getTranslation(TrKeys.noRestaurant),
                            ),
                          ],
                        ),
                )
              : Expanded(
                  child: state.shopsRecommend.isNotEmpty
                      ? SmartRefresher(
                          controller: _recommendedController,
                          enablePullDown: true,
                          enablePullUp: false,
                          onLoading: () async {
                            // await event.fetchShopPageRecommend(
                            //     context, _recommendedController);
                          },
                          onRefresh: () async {
                            await event.fetchShopPageRecommend(
                              context,
                              _recommendedController,
                              isRefresh: true,
                            );
                          },
                          child: GridView.builder(
                            shrinkWrap: true,
                            itemCount: state.shopsRecommend.length,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 24.h,
                            ),
                            itemBuilder: (context, index) => RecommendedTwoItem(
                              shop: state.shopsRecommend[index],
                            ),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 0.66.r,
                                  crossAxisCount: 2,
                                  mainAxisExtent: 190.h,
                                  mainAxisSpacing: 10.h,
                                ),
                          ),
                        )
                      : Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height / 2,
                              child: SvgPicture.asset("assets/svgs/empty.svg"),
                            ),
                            16.verticalSpace,
                            Text(
                              AppHelpers.getTranslation(TrKeys.noRestaurant),
                            ),
                          ],
                        ),
                ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(left: 16.w),
        child: const PopButton(),
      ),
    );
  }
}
