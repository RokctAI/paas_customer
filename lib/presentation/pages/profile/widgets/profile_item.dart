import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/infrastructure/services/services.dart';
import 'package:foodyman/presentation/theme/color_set.dart';
import 'package:foodyman/presentation/theme/theme.dart';
import 'package:foodyman/presentation/theme/theme_wrapper.dart';

import 'package:foodyman/presentation/components/components.dart';

class ProfileItem extends StatelessWidget {
  final String title;
  final String? count;
  final IconData icon;
  final bool isCount;
  final VoidCallback onTap;
  final CustomColorSet colors;

  const ProfileItem({
    super.key,
    required this.title,
    required this.icon,
    this.isCount = false,
    this.count,
    required this.onTap,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationButtonEffect(
      child: ThemeWrapper(
        builder: (colors, theme) => GestureDetector(
          onTap: onTap,
          child: Container(
            margin: EdgeInsets.only(bottom: 8.h),
            width: double.infinity,
            decoration: BoxDecoration(
              color: colors.icon,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(icon, color: colors.textBlack),
                        14.horizontalSpace,
                        Expanded(
                          child: Text(
                            AppHelpers.getTranslation(title),
                            style: AppStyle.interNormal(
                              size: 14,
                              color: colors.textBlack,
                            ),
                          ),
                        ),
                        12.horizontalSpace,
                        isCount
                            ? Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 5.r,
                                  horizontal: 14.r,
                                ),
                                decoration: BoxDecoration(
                                  color: colors.primary,
                                  borderRadius: BorderRadius.circular(100.r),
                                ),
                                child: Text(
                                  count ?? '',
                                  style: AppStyle.interNormal(
                                    size: 14,
                                    color: colors.buttonFontColor,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                  Icon(
                    LocalStorage.getLangLtr()
                        ? Icons.keyboard_arrow_right
                        : Icons.keyboard_arrow_left,
                    color: AppStyle.arrowRightProfileButton,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
