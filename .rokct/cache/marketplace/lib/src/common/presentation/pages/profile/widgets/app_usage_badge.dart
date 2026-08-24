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

// lib/presentation/pages/profile/widgets/app_usage_badge.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remixicon/remixicon.dart';
import 'package:base_sdk/src/services/app_helpers.dart';
import 'package:base_sdk/src/services/tr_keys.dart';
import 'package:base_sdk/src/presentation/theme/theme.dart';

import 'package:base_sdk/src/utils/app_usage_service.dart';

class AppUsageBadge extends StatefulWidget {
  const AppUsageBadge({super.key});

  @override
  State<AppUsageBadge> createState() => _AppUsageBadgeState();
}

class _AppUsageBadgeState extends State<AppUsageBadge> {
  int daysInAppThisYear = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAppUsage();
  }

  Future<void> _loadAppUsage() async {
    // Only get stats, don't record usage here
    final stats = await AppUsageService.getAppUsageStats();

    if (mounted) {
      setState(() {
        daysInAppThisYear = stats['days_in_app_this_year'] ?? 0;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: AppStyle.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: isLoading
          ? SizedBox(
              width: 16.r,
              height: 16.r,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppStyle.primary),
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Remix.calendar_2_line,
                  color: AppStyle.primary,
                  size: 16.r,
                ),
                SizedBox(width: 4.w),
                Text(
                  '$daysInAppThisYear ${AppHelpers.getTranslation(TrKeys.daysInAppThisYear)}',
                  style: AppStyle.interNormal(
                    size: 12.sp,
                    color: AppStyle.primary,
                  ),
                ),
              ],
            ),
    );
  }
}
