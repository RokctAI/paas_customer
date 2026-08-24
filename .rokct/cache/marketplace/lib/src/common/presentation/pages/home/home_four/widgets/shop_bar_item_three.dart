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
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:base_sdk/src/models/data/story_data.dart';
import 'package:base_sdk/src/presentation/components/custom_network_image.dart';

class ShopBarItemThree extends StatelessWidget {
  final RefreshController controller;
  final StoryModel? story;
  final int index;

  const ShopBarItemThree({
    super.key,
    required this.story,
    required this.controller,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.router.pushNamed('/storyList?index=$index');
      },
      child: Container(
        margin: EdgeInsets.only(right: 9.r),
        width: 156.r,
        color: AppStyle.transparent,
        child: Stack(
          children: [
            CustomNetworkImage(
              url: story?.url ?? "",
              height: double.infinity,
              width: double.infinity,
              radius: 12.r,
            ),
            Positioned(
              child: Container(
                decoration: ShapeDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppStyle.black.withOpacity(0.2),
                      AppStyle.black.withOpacity(0.2),
                      AppStyle.black.withOpacity(0.2),
                      AppStyle.black.withOpacity(0.5),
                      AppStyle.black.withOpacity(0.7),
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Center(
                child: Text(
                  story?.title ?? "",
                  style: AppStyle.interNoSemi(size: 14, color: AppStyle.white),
                  maxLines: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
