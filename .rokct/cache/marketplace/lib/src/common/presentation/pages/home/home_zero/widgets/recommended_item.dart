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
import 'package:base_sdk/src/presentation/components/shop_avarat.dart';

class RecommendedItem extends StatelessWidget {
  final ShopData shop;

  const RecommendedItem({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.router.pushNamed('/shop?shopId=' + (shop.id ?? ""));
      },
      child: Container(
        margin: EdgeInsets.only(left: 0, right: 9.r),
        width: MediaQuery.sizeOf(context).width / 3,
        height: 190.h,
        decoration: BoxDecoration(
          color: AppStyle.recommendBg,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Stack(
          children: [
            CustomNetworkImage(
              url: shop.backgroundImg ?? "",
              width: MediaQuery.sizeOf(context).width / 2,
              height: 190.h,
              radius: 10.r,
            ),
            Padding(
              padding: EdgeInsets.all(12.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ShopAvatar(
                        shopImage: shop.logoImg ?? "",
                        size: 36,
                        padding: 4,
                      ),
                      8.horizontalSpace,
                      Expanded(
                        child: Text(
                          shop.translation?.title ?? "",
                          style: AppStyle.interNormal(
                            size: 12,
                            color: AppStyle.black,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 4.h,
                      horizontal: 12.w,
                    ),
                    decoration: BoxDecoration(
                      color: AppStyle.black.withOpacity(0.8),
                      borderRadius: BorderRadius.all(Radius.circular(100.r)),
                    ),
                    child: Text(
                      "${shop.productsCount ?? 0}  ${AppHelpers.getTranslation(TrKeys.products)}",
                      style: AppStyle.interNormal(
                        size: 12,
                        color: AppStyle.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
