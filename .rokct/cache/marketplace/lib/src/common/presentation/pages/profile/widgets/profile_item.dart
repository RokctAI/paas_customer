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

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:base_sdk/src/presentation/components/buttons/animation_button_effect.dart';
import 'package:base_sdk/src/presentation/theme/theme.dart';

class ProfileItem extends StatelessWidget {
  final String title;
  final String? count;
  final IconData icon;
  final bool isCount;
  final bool isLtr;
  final VoidCallback onTap;

  const ProfileItem({
    super.key,
    required this.title,
    required this.icon,
    this.isCount = false,
    this.count,
    required this.onTap,
    required this.isLtr,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationButtonEffect(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(bottom: 8.h),
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppStyle.white,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon),
                    14.horizontalSpace,
                    Text(
                      title,
                      style: AppStyle.interNormal(
                        size: 14,
                        color: AppStyle.black,
                      ),
                    ),
                    12.horizontalSpace,
                    isCount
                        ? Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 5.h,
                              horizontal: 14.w,
                            ),
                            decoration: BoxDecoration(
                              color: AppStyle.primary,
                              borderRadius: BorderRadius.all(
                                Radius.circular(100.r),
                              ),
                            ),
                            child: Text(
                              count ?? '',
                              style: AppStyle.interNormal(
                                size: 14,
                                color: AppStyle.black,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
                Icon(
                  isLtr
                      ? Icons.keyboard_arrow_right
                      : Icons.keyboard_arrow_left,
                  color: AppStyle.arrowRightProfileButton,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
