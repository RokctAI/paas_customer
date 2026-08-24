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

import 'package:base_sdk/src/presentation/theme/app_style.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:base_sdk/src/models/data/shop_data.dart';
import 'package:base_sdk/src/services/app_helpers.dart';
import 'package:base_sdk/src/services/tr_keys.dart';

import 'package:base_sdk/src/presentation/components/custom_network_image.dart';

import 'package:base_sdk/src/presentation/components/badges/storelogo_badge.dart';

class RecommendedItem extends StatelessWidget {
  final ShopData shop;
  final int itemCount;

  const RecommendedItem({
    super.key,
    required this.shop,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final isNarrow = constraints.maxWidth < screenWidth / 2;
        return GestureDetector(
          onTap: () {
            context.router.pushNamed('/shop?shopId=' + (shop.id ?? 0).toString());
          },
          child: Container(
            margin: EdgeInsets.only(left: 0, right: 9.r),
            width: itemCount == 1
                ? MediaQuery.sizeOf(context).width - 30
                : MediaQuery.sizeOf(context).width / 3,
            height: 190.h,
            decoration: BoxDecoration(
              color: AppStyle.recommendBg,
              borderRadius: BorderRadius.all(Radius.circular(10.r)),
            ),
            child: Stack(
              children: [
                CustomNetworkImage(
                  url: shop.backgroundImg ?? "",
                  width: itemCount == 1
                      ? MediaQuery.sizeOf(context).width - 30
                      : MediaQuery.sizeOf(context).width / 2,
                  height: 190.h,
                  radius: 10.r,
                ),
                ShopBadge(
                  shop: shop,
                  top: 8.h,
                  left: 8.w,
                  iconSize: itemCount == 1 ? 40 : (isNarrow ? 22 : 22),
                  containerHeight: itemCount == 1
                      ? 40.h
                      : (isNarrow ? 30 : 30.h),
                  containerWidth: itemCount == 1
                      ? 170.w
                      : (isNarrow ? 130.w : 100.w),
                  fontSize: itemCount == 1 ? 18 : (isNarrow ? 10 : 8),
                  maxTextLength: 12,
                ),
                Positioned(
                  bottom: 12.h,
                  left: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 4.h,
                      horizontal: 12.w,
                    ),
                    decoration: BoxDecoration(
                      color: AppStyle.black.withOpacity(0.8),
                      borderRadius: BorderRadius.all(Radius.circular(100.r)),
                    ),
                    child: Text(
                      itemCount == 1
                          ? "${shop.productsCount ?? 0} Recommended ${AppHelpers.getTranslation(TrKeys.products)} in this Store"
                          : "${shop.productsCount ?? 0}  ${AppHelpers.getTranslation(TrKeys.products)}",
                      style: AppStyle.interNormal(
                        size: itemCount == 1 ? 16 : 12,
                        color: AppStyle.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
