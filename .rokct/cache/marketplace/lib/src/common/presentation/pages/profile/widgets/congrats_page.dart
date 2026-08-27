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
import 'package:base_sdk/src/presentation/components/buttons/custom_button.dart';
import 'package:base_sdk/src/presentation/theme/app_style.dart';

import 'package:base_sdk/src/services/app_helpers.dart';
import 'package:base_sdk/src/services/tr_keys.dart';

class CongratsPage extends StatelessWidget {
  final bool isOrder;
  final VoidCallback? onTap;

  const CongratsPage({super.key, this.isOrder = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.verticalSpace,
              Text(
                AppHelpers.getTranslation(TrKeys.checkout),
                style: AppStyle.interSemi(color: AppStyle.textGrey, size: 22),
              ),
              42.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.r),
                child: Image.asset("assets/images/order_success.png"),
              ),
              6.verticalSpace,
              if (isOrder)
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        AppHelpers.getTranslation(TrKeys.congrats),
                        style: AppStyle.interBold(
                          color: AppStyle.textGrey,
                          size: 20,
                        ),
                      ),
                      6.verticalSpace,
                      Text(
                        AppHelpers.getTranslation(TrKeys.thankYouPurchase),
                        style: AppStyle.interNormal(
                          color: AppStyle.textGrey,
                          size: 14,
                        ),
                      ),
                      Text(
                        AppHelpers.getTranslation(TrKeys.yourOrderShipping),
                        style: AppStyle.interNormal(
                          color: AppStyle.textGrey,
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              if (!isOrder)
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        AppHelpers.getTranslation(TrKeys.congrats),
                        style: AppStyle.interBold(
                          color: AppStyle.textGrey,
                          size: 20,
                        ),
                      ),
                      6.verticalSpace,
                      Text(
                        AppHelpers.getTranslation(TrKeys.paymentSuccessful),
                        style: AppStyle.interNormal(
                          color: AppStyle.textGrey,
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.r),
        child: SizedBox(
          height: 60.r,
          width: double.infinity,
          child: CustomButton(
            title: AppHelpers.getTranslation(
              isOrder ? TrKeys.returnHome : TrKeys.ok,
            ),
            background: AppStyle.primary,
            textColor: AppStyle.white,
            onPressed: () {
              if (onTap != null) {
                onTap!();
              } else {
                Navigator.pop(context);
              }
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
