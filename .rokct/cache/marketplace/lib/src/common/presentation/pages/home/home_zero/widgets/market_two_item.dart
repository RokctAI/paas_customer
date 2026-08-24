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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:base_sdk/src/models/data/shop_data.dart';
import 'package:base_sdk/src/services/app_helpers.dart';
import 'package:base_sdk/src/services/tr_keys.dart';
import 'package:base_sdk/src/presentation/components/badge_item.dart';
import 'package:base_sdk/src/presentation/components/bonus_discount_popular.dart';
import 'package:base_sdk/src/presentation/components/custom_network_image.dart';

import 'package:base_sdk/src/presentation/theme/app_style.dart';
// import 'two_bonus_discount.dart'; // NOT FOUND IN PROJECT

class MarketTwoItem extends StatelessWidget {
  final ShopData shop;
  final bool isSimpleShop;
  final bool isShop;
  final bool isFilter;

  const MarketTwoItem({
    super.key,
    this.isSimpleShop = false,
    required this.shop,
    this.isShop = false,
    this.isFilter = false,
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
              margin: isFilter
                  ? REdgeInsets.symmetric(horizontal: 16)
                  : isSimpleShop
                  ? EdgeInsets.all(8.r)
                  : EdgeInsets.only(right: 8.r),
              width: 268.r,
              decoration: BoxDecoration(
                color: AppStyle.white,
                borderRadius: BorderRadius.all(Radius.circular(24.r)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppStyle.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24.r),
                            topRight: Radius.circular(24.r),
                          ),
                        ),
                        width: double.infinity,
                        height: 140.h,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24.r),
                            topRight: Radius.circular(24.r),
                          ),
                          child: CustomNetworkImage(
                            url: shop.backgroundImg ?? '',
                            height: isSimpleShop ? 136.h : 150.h,
                            width: double.infinity,
                            radius: 0,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10.h,
                        right: 0,
                        left: 0,
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
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: REdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: ShapeDecoration(
                            color: AppStyle.white.withOpacity(0.6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(100.r),
                                bottomLeft: Radius.circular(100.r),
                                topRight: Radius.circular(100.r),
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                "assets/svgs/delivery_time.svg",
                                height: 24.r,
                              ),
                              4.horizontalSpace,
                              Text(
                                "${shop.deliveryTime?.from ?? 0} - ${shop.deliveryTime?.to ?? 0} ${shop.deliveryTime?.type ?? "min"}",
                                style: AppStyle.interNormal(
                                  size: 12,
                                  color: AppStyle.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: REdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 50.r,
                                    child: Text(
                                      shop.translation?.title ?? "",
                                      style: AppStyle.interSemi(
                                        size: 16,
                                        color: AppStyle.black,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ),
                                  if (shop.verify ?? false)
                                    Padding(
                                      padding: EdgeInsets.only(left: 4.r),
                                      child: const BadgeItem(),
                                    ),
                                ],
                              ),
                            ),
                            10.horizontalSpace,
                            SvgPicture.asset("assets/svgs/star.svg"),
                            4.horizontalSpace,
                            Text(
                              (shop.avgRate ?? ""),
                              style: AppStyle.interNormal(
                                size: 12.sp,
                                color: AppStyle.black,
                              ),
                            ),
                          ],
                        ),
                        6.verticalSpace,
                        Text(
                          shop.bonus != null
                              ? ((shop.bonus?.type ?? "sum") == "sum")
                                    ? "${AppHelpers.getTranslation(TrKeys.under)} ${AppHelpers.numberFormat(number: shop.bonus?.value)} + ${shop.bonus?.bonusStock?.product?.translation?.title ?? ""}"
                                    : "${AppHelpers.getTranslation(TrKeys.under)} ${shop.bonus?.value ?? 0} + ${shop.bonus?.bonusStock?.product?.translation?.title ?? ""}"
                              : shop.translation?.description ?? "",
                          style: AppStyle.interNormal(
                            size: 12,
                            color: AppStyle.black,
                          ),
                          maxLines: isSimpleShop ? 2 : 1,
                        ),
                        6.verticalSpace,
                      ],
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
        color: AppStyle.bgGrey,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          24.verticalSpace,
          CustomNetworkImage(
            url: shop.logoImg ?? "",
            height: 80.r,
            width: 80.r,
            radius: 40.r,
          ),
          const Spacer(),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  (shop.translation?.title?.length ?? 0) > 12
                      ? "${shop.translation?.title?.substring(0, 12) ?? " "}.."
                      : shop.translation?.title ?? "",
                  style: AppStyle.interSemi(size: 14, color: AppStyle.black),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
                if (shop.verify ?? false)
                  Padding(
                    padding: EdgeInsets.only(left: 4.r),
                    child: const BadgeItem(),
                  ),
              ],
            ),
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
