import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/infrastructure/services/services.dart';

import 'package:foodyman/presentation/theme/theme.dart';
import 'package:foodyman/presentation/theme/theme_wrapper.dart';

// ignore: must_be_immutable
class TitleAndIcon extends StatelessWidget {
  final String title;
  final double titleSize;
  final String? rightTitle;
  final bool isIcon;
  final Color rightTitleColor;
  final double paddingHorizontalSize;
  VoidCallback? onRightTap;

  TitleAndIcon({
    super.key,
    this.isIcon = false,
    required this.title,
    this.rightTitle,
    this.rightTitleColor = AppStyle.black,
    this.onRightTap,
    this.titleSize = 18,
    this.paddingHorizontalSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLtr = LocalStorage.getLangLtr();
    return ThemeWrapper(
      builder: (colors, theme) {
        return Directionality(
          textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingHorizontalSize.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppStyle.interNoSemi(
                      size: titleSize,
                      color: colors.textBlack,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onRightTap ?? () {},
                  child: Row(
                    children: [
                      Text(
                        rightTitle ?? "",
                        style: AppStyle.interRegular(
                          size: 14,
                          color: colors.textBlack,
                        ),
                      ),
                      isIcon
                          ? Icon(
                              isLtr
                                  ? Icons.keyboard_arrow_right
                                  : Icons.keyboard_arrow_left,
                              color: colors.textBlack,
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
