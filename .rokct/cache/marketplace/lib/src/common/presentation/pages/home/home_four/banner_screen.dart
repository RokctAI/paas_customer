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
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:base_sdk/src/models/data/shop_data.dart';
import 'package:base_sdk/src/services/tr_keys.dart';
import 'package:base_sdk/src/presentation/components/buttons/custom_button.dart';
import 'package:base_sdk/src/presentation/components/custom_network_image.dart';
import 'package:base_sdk/src/services/app_helpers.dart';
import 'package:base_sdk/src/navigation/app_routes.dart';

class BannerScreen extends StatelessWidget {
  final String image;
  final int bannerId;
  final String desc;
  final bool isAds;
  final List<ShopData> list;
  final String? buttonText;

  const BannerScreen({
    super.key,
    required this.image,
    required this.desc,
    required this.list,
    required this.bannerId,
    this.isAds = false,
    this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    // print("Button text being used in BannerScreen: ${buttonText}");
    return Container(
      decoration: BoxDecoration(
        color: AppStyle.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.r),
          topRight: Radius.circular(8.r),
        ),
      ),
      padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 192.h,
            width: MediaQuery.sizeOf(context).width,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.r),
                topRight: Radius.circular(8.r),
              ),
              child: CustomNetworkImage(
                url: image,
                height: double.infinity,
                width: double.infinity,
                radius: 0,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Text(
              desc,
              style: AppStyle.interRegular(
                size: 14.sp,
                color: AppStyle.textGrey,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    background: AppStyle.transparent,
                    borderColor: AppStyle.tabBarBorderColor,
                    title: AppHelpers.getTranslation(TrKeys.cancel),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                10.horizontalSpace,
                Expanded(
                  child: CustomButton(
                    title: buttonText ?? "View",
                    onPressed: () {
                      AppRoutes.I.pushShopsBannerRoute(
                        context,
                        bannerId: bannerId,
                        title: desc,
                        isAds: isAds,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          16.verticalSpace,
        ],
      ),
    );
  }
}
