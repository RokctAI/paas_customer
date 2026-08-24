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

import 'package:base_sdk/src/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:base_sdk/src/models/data/shop_data.dart';
import 'package:base_sdk/src/services/app_helpers.dart';
import 'package:base_sdk/src/services/tr_keys.dart';
import 'package:base_sdk/src/presentation/components/shop_avarat.dart';
// [refork] removed host router import
import 'package:base_sdk/src/presentation/theme/theme.dart';

class RestaurantItem extends StatelessWidget {
  final ShopData shop;

  const RestaurantItem({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: GestureDetector(
        onTap: () {
          AppRoutes.I.pushShopRoute(context, shopId: (shop.id ?? 0).toString());
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppStyle.white,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: AppStyle.white.withOpacity(0.04),
                spreadRadius: 0,
                blurRadius: 2,
                offset: const Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(12.r),
            child: Row(
              children: [
                ShopAvatar(
                  shopImage: shop.logoImg ?? "",
                  size: 50,
                  padding: 6,
                  bgColor: AppStyle.blackWithOpacity,
                ),
                10.horizontalSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      shop.translation?.title ?? "",
                      style: AppStyle.interSemi(
                        size: 15,
                        color: AppStyle.black,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width - 200.h,
                      child: Text(
                        shop.bonus != null
                            ? ((shop.bonus?.type ?? "sum") == "sum")
                                ? "${AppHelpers.getTranslation(TrKeys.under)} ${AppHelpers.numberFormat(number: shop.bonus?.value)} + ${shop.bonus?.bonusStock?.product?.translation?.title ?? ""}"
                                : "${AppHelpers.getTranslation(TrKeys.under)} ${shop.bonus?.value ?? 0} + ${shop.bonus?.bonusStock?.product?.translation?.title ?? ""}"
                            : shop.translation?.description ?? "",
                        style: AppStyle.interNormal(
                          size: 12,
                          color: AppStyle.black,
                        ),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
