import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/infrastructure/models/data/product_data.dart';
import 'package:foodyman/infrastructure/services/services.dart';
import 'package:foodyman/presentation/theme/color_set.dart';
import 'package:foodyman/presentation/theme/theme.dart';

import '../../product/product_page.dart';

import 'package:foodyman/presentation/components/components.dart';

class ProductItem extends StatelessWidget {
  final ProductData product;
  final CustomColorSet colors;

  const ProductItem({super.key, required this.product, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: InkWell(
        onTap: () {
          AppHelpers.showCustomModalBottomDragSheet(
            context: context,
            modal: (c) => ProductScreen(controller: c, data: product),
            isDarkMode: false,
            isDrag: true,
            radius: 16,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: colors.icon,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: AppStyle.white.withValues(alpha: 0.04),
                spreadRadius: 0,
                blurRadius: 2,
                offset: const Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(12.r),
            child: Row(
              children: [
                CustomNetworkImage(
                  url: product.img ?? "",
                  height: 84.r,
                  width: 84.r,
                  radius: 10.r,
                ),
                14.horizontalSpace,
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 200.h,
                            child: Text(
                              product.translation?.title ?? "",
                              style: AppStyle.interSemi(
                                size: 15,
                                color: colors.textBlack,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            product.translation?.description ?? "",
                            style: AppStyle.interNormal(
                              size: 12,
                              color: colors.textBlack,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppHelpers.numberFormat(
                              product.stocks?.first.totalPrice,
                            ),
                            style: AppStyle.interSemi(
                              size: 13,
                              color: colors.textBlack,
                            ),
                          ),
                          product.stocks?.first.bonus != null
                              ? Container(
                                  width: 22.w,
                                  height: 22.h,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppStyle.blueBonus,
                                  ),
                                  child: Icon(
                                    FlutterRemix.gift_2_fill,
                                    size: 16.r,
                                    color: colors.textWhite,
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
