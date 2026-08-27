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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:base_sdk/src/application/home/home_notifier.dart';
import 'package:base_sdk/src/application/home/home_state.dart';
import 'package:marketplace_sdk/src/common/presentation/pages/home/home_zero/shimmer/category_shimmer.dart';
import 'tab_bar_item.dart';

class CategoryScreen extends StatelessWidget {
  final HomeState state;
  final HomeNotifier event;
  final RefreshController categoryController;
  final RefreshController shopController;

  const CategoryScreen({
    super.key,
    required this.state,
    required this.event,
    required this.categoryController,
    required this.shopController,
  });

  @override
  Widget build(BuildContext context) {
    return state.isCategoryLoading
        ? const CategoryShimmer()
        : Container(
            height: state.categories.isNotEmpty ? 90.h : 0,
            margin: EdgeInsets.only(
              bottom: state.categories.isNotEmpty ? 26.h : 0,
            ),
            child: SmartRefresher(
              scrollDirection: Axis.horizontal,
              enablePullDown: false,
              enablePullUp: true,
              controller: categoryController,
              onLoading: () async {
                await event.fetchCategoriesPage(context, categoryController);
              },
              child: AnimationLimiter(
                child: ListView.builder(
                  padding: EdgeInsets.only(left: 16.r),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: state.isCategoryLoading
                      ? 5
                      : state.categories.length,
                  itemBuilder: (context, index) {
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: CategoryBarItem(
                            index: index,
                            image: state.categories[index].img ?? "",
                            title:
                                state.categories[index].translation?.title ??
                                "",
                            isActive: state.selectIndexCategory == index,
                            onTap: () {
                              event.setSelectCategory(index, context);
                              shopController.resetNoData();
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
  }
}
