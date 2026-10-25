// Copyright (c) 2026 ROKCT INTELLIGENCE (PTY) LTD
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published
// by the Free Software Foundation, version 3.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License

import 'package:base_sdk/src/presentation/theme/app_style.dart';
import 'package:base_sdk/src/services/app_helpers.dart';
import 'package:base_sdk/src/services/tr_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remixicon/remixicon.dart';

/// The "Back" pill of base_sdk's PopButton without its BackdropFilter.
///
/// PopButton wraps itself in a gaussian blur (sigma 13) that re-samples
/// whatever scrolls beneath it every frame. That is a large cost on low-end
/// GPUs and crashes software renderers (SwiftShader) when it is composited
/// over a freshly pushed, still-animating route. PopButton's fill is only
/// 30% opaque and relies on the blur behind it for legibility; without the
/// blur this pill uses a 72% fill instead, so it reads darker than before.
class FlatBackButton extends StatelessWidget {
  const FlatBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.maybePop(context),
      child: Container(
        constraints: BoxConstraints(minWidth: 100.w),
        height: 48.r,
        padding: EdgeInsets.symmetric(horizontal: 16.r),
        decoration: BoxDecoration(
          color: AppStyle.bottomNavigationBarColor.withValues(alpha: 0.72),
          borderRadius: BorderRadius.all(Radius.circular(100.r)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Remix.arrow_left_wide_fill, size: 20.r, color: AppStyle.white),
            4.horizontalSpace,
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppHelpers.getTranslation(TrKeys.back),
                  style: TextStyle(color: AppStyle.white, fontSize: 12.sp),
                ),
                3.verticalSpace,
                Container(
                  height: 4.h,
                  width: 24.w,
                  decoration: BoxDecoration(
                    color: AppStyle.primary,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(100.r),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
