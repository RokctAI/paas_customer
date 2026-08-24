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

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:base_sdk/src/presentation/components/custom_network_image.dart';
import 'package:base_sdk/src/presentation/theme/app_style.dart';

class CategoryTwoItem extends StatelessWidget {
  final String image;
  final String title;
  final int index;
  final VoidCallback onTap;
  final bool isActive;

  const CategoryTwoItem({
    super.key,
    required this.image,
    required this.title,
    required this.index,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: index == 1 ? 4.r : 0, right: 8.r),
          width: 64.r,
          height: 100.r,
          padding: REdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(70.r)),
            color: isActive ? AppStyle.primary : AppStyle.white,
            boxShadow: const [
              BoxShadow(
                color: AppStyle.shadow,
                blurRadius: 15,
                offset: Offset(0, 4),
                spreadRadius: 0,
              ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(24.r),
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppStyle.bgGrey,
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: CustomNetworkImage(
                    fit: BoxFit.contain,
                    url: image,
                    height: 48.r,
                    width: 48.r,
                    radius: 24.r,
                  ),
                ),
                8.verticalSpace,
                SizedBox(
                  width: 62.w,
                  child: Text(
                    title,
                    style: AppStyle.interNormal(
                      size: 12,
                      color: AppStyle.black,
                    ),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
