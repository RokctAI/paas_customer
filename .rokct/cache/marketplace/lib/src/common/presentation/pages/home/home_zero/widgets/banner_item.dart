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

import 'package:base_sdk/src/presentation/theme/app_style.dart';
import 'package:base_sdk/src/models/response/banners_paginate_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:base_sdk/src/services/app_helpers.dart';
import 'package:base_sdk/src/presentation/components/custom_network_image.dart';
import 'banner_screen.dart';

class BannerItem extends StatelessWidget {
  final BannerData banner;
  final bool isAds;

  const BannerItem({super.key, required this.banner, this.isAds = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Banner ids are Frappe docnames (hash strings); a banner without
        // one cannot be opened — skip instead of sending a sentinel.
        final String? bannerId = banner.id;
        if (bannerId == null) {
          debugPrint('==> banner tap skipped: banner has no id');
          return;
        }
        AppHelpers.showCustomModalBottomSheet(
          context: context,
          modal: BannerScreen(
            isAds: isAds,
            bannerId: bannerId,
            image: banner.img ?? "",
            desc: banner.translation?.description ?? "",
            list: banner.shops ?? [],
          ),
          isDarkMode: false,
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: 6.r),
        width: MediaQuery.sizeOf(context).width - 46,
        decoration: BoxDecoration(
          color: AppStyle.white,
          borderRadius: BorderRadius.all(Radius.circular(8.r)),
        ),
        child: CustomNetworkImage(
          bgColor: AppStyle.white,
          url: banner.img ?? "",
          height: double.infinity,
          width: double.infinity,
          radius: 8.r,
        ),
      ),
    );
  }
}
