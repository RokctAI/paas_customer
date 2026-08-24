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
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:base_sdk/src/models/data/take_data.dart';
import 'package:base_sdk/src/services/app_helpers.dart';
// ignore_for_file: unrelated_type_equality_checks

// ignore: must_be_immutable
class FilterItem extends StatelessWidget {
  final String title;
  final List list;
  final bool isRating;
  final bool isPrice;
  final bool isOffer;
  final bool isSort;
  final dynamic currentItem;
  final String? currentItemTwo;
  ValueChanged onTap;

  FilterItem({
    super.key,
    required this.title,
    required this.list,
    this.isRating = false,
    this.isOffer = false,
    this.isSort = false,
    this.currentItem,
    this.currentItemTwo = "",
    required this.onTap,
    this.isPrice = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 18.w,
        right: 18.w,
        top: 18.h,
        bottom: 10.h,
      ),
      decoration: BoxDecoration(
        color: AppStyle.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppStyle.interNoSemi(size: 16.sp, color: AppStyle.black),
          ),
          18.verticalSpace,
          Wrap(
            children: list
                .map(
                  (e) => GestureDetector(
                    onTap: () => onTap(e),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      margin: EdgeInsets.only(right: 8.w, bottom: 8.h),
                      padding: EdgeInsets.symmetric(
                        vertical: 10.h,
                        horizontal: 16.w,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color:
                            ((e.runtimeType == TakeModel)
                                ? (currentItem == (e as TakeModel).id ||
                                      currentItemTwo == e.id)
                                : (currentItem == e || currentItemTwo == e))
                            ? AppStyle.primary
                            : AppStyle.bgGrey,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          isRating
                              ? Row(
                                  children: [
                                    Icon(
                                      FlutterRemix.star_smile_fill,
                                      size: 16.r,
                                    ),
                                    6.horizontalSpace,
                                  ],
                                )
                              : isOffer
                              ? Row(
                                  children: [
                                    Icon(FlutterRemix.leaf_fill, size: 16.r),
                                    6.horizontalSpace,
                                  ],
                                )
                              : isSort
                              ? Row(
                                  children: [
                                    Container(
                                      width: 14.w,
                                      height: 14.h,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: currentItem == e ? 4.r : 2.r,
                                          color: AppStyle.black,
                                        ),
                                        color: AppStyle.transparent,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    6.horizontalSpace,
                                  ],
                                )
                              : const SizedBox.shrink(),
                          isPrice
                              ? Text(
                                  AppHelpers.numberFormat(
                                    number: double.tryParse(e),
                                  ),
                                  style: AppStyle.interNormal(
                                    size: 14,
                                    color: AppStyle.black,
                                  ),
                                )
                              : isOffer
                              ? Text(
                                  (e as TakeModel).translation?.title ?? "",
                                  style: AppStyle.interNormal(
                                    size: 14,
                                    color: AppStyle.black,
                                  ),
                                )
                              : Text(
                                  e,
                                  style: AppStyle.interNormal(
                                    size: 14,
                                    color: AppStyle.black,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
