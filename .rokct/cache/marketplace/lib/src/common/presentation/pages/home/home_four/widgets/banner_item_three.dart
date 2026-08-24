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
import 'package:base_sdk/src/models/response/banners_paginate_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:base_sdk/src/services/app_helpers.dart';
import 'package:base_sdk/src/presentation/components/custom_network_image.dart';
import 'package:marketplace_sdk/src/common/presentation/pages/home/home_four/widgets/banner_screen.dart';

class BannerItemThree extends StatelessWidget {
  final BannerData banner;

  const BannerItemThree({super.key, required this.banner});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppHelpers.showCustomModalBottomSheet(
          context: context,
          modal: BannerScreen(
            bannerId: banner.id ?? 0,
            image: banner.img ?? "",
            desc: banner.translation?.description ?? "",
            list: banner.shops ?? [],
          ),
          isDarkMode: false,
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12.r),
        width: MediaQuery.sizeOf(context).width - 46,
        decoration: BoxDecoration(
          color: AppStyle.white,
          borderRadius: BorderRadius.all(Radius.circular(15.r)),
        ),
        child: CustomNetworkImage(
          bgColor: AppStyle.white,
          url: banner.img ?? "",
          width: double.infinity,
          radius: 15.r,
          height: double.infinity,
        ),
      ),
    );
  }
}
