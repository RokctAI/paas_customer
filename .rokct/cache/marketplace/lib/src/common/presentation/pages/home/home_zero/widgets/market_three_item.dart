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

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:base_sdk/src/models/data/shop_data.dart';
import 'package:base_sdk/src/services/app_helpers.dart';
import 'package:base_sdk/src/services/tr_keys.dart';
import 'package:base_sdk/src/presentation/components/badge_item.dart';
import 'package:base_sdk/src/presentation/components/bonus_discount_popular.dart';
import 'package:base_sdk/src/presentation/components/custom_network_image.dart';

import 'package:base_sdk/src/presentation/theme/app_style.dart';

class MarketThreeItem extends StatelessWidget {
  final ShopData shop;
  final bool isSimpleShop;
  final bool isShop;

  const MarketThreeItem({
    super.key,
    this.isSimpleShop = false,
    required this.shop,
    this.isShop = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.router.pushNamed('/shop?shopId=${(shop.id ?? 0).toString()}');
      },
      child: isShop
          ? _shopItem()
          : Container(
              margin: isSimpleShop
                  ? EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h)
                  : EdgeInsets.only(right: 8.r),
              width: 268.w,
              height: 280.h,
              // foregroundDecoration: BoxDecoration(
              //   color: !(shop.open ?? true) ? AppStyle.white.withOpacity(0.5) : AppStyle.transparent
              // ),
              decoration: BoxDecoration(
                color: AppStyle.bgGrey,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 180.h,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.r),
                            topRight: Radius.circular(10.r),
                          ),
                          child: CustomNetworkImage(
                            url: shop.backgroundImg ?? '',
                            height: 180.h,
                            width: double.infinity,
                            radius: 16,
                          ),
                        ),
                      ),
                      Padding(
                        padding: REdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      (shop.translation?.title?.length ?? 0) >
                                              28
                                          ? "${shop.translation?.title?.substring(0, 28) ?? " "}.."
                                          : shop.translation?.title ?? "",
                                      style: AppStyle.interSemi(
                                        size: 16,
                                        color: AppStyle.black,
                                      ),
                                    ),
                                    if (shop.verify ?? false)
                                      Padding(
                                        padding: EdgeInsets.only(left: 4.r),
                                        child: const BadgeItem(),
                                      ),
                                  ],
                                ),
                                Container(
                                  padding: REdgeInsets.all(8),
                                  decoration: const ShapeDecoration(
                                    color: AppStyle.borderColor,
                                    shape: CircleBorder(),
                                  ),
                                  child: Text(
                                    (shop.avgRate ?? ""),
                                    style: AppStyle.interNormal(
                                      size: 12,
                                      color: AppStyle.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            4.verticalSpace,
                            Row(
                              children: [
                                Expanded(
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
                                6.horizontalSpace,
                                Container(
                                  width: 5.w,
                                  height: 5.h,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppStyle.separatorDot,
                                  ),
                                ),
                                8.horizontalSpace,
                                Text(
                                  "${shop.deliveryTime?.from ?? 0}-${shop.deliveryTime?.to ?? 0} ${shop.deliveryTime?.type ?? "min"}",
                                  style: AppStyle.interNormal(
                                    size: 12,
                                    color: AppStyle.black,
                                  ),
                                ),
                              ],
                            ),
                            16.verticalSpace,
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 150.r,
                    right: 0,
                    left: 0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18.w),
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: isSimpleShop ? 6.h : 0,
                        ),
                        child: BonusDiscountPopular(
                          isPopular: shop.isRecommend ?? false,
                          bonus: shop.bonus,
                          isDiscount: shop.isDiscount ?? false,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _shopItem() {
    return Container(
      padding: REdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: AppStyle.borderColor, width: 1.2),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          24.verticalSpace,
          CustomNetworkImage(
            url: shop.logoImg ?? "",
            height: 66.r,
            width: 66.r,
            radius: 33.r,
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  shop.translation?.title ?? "",
                  style: AppStyle.interSemi(size: 14, color: AppStyle.black),
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (shop.verify ?? false)
                Padding(
                  padding: EdgeInsets.only(left: 4.r),
                  child: const BadgeItem(),
                ),
            ],
          ),
          6.verticalSpace,
          Text(
            "${shop.deliveryTime?.from ?? 0} - ${shop.deliveryTime?.to ?? 0} ${shop.deliveryTime?.type ?? "min"}",
            style: AppStyle.interSemi(size: 12, color: AppStyle.textGrey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          28.verticalSpace,
        ],
      ),
    );
  }
}
