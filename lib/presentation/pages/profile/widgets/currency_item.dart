import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/presentation/theme/color_set.dart';
import 'package:foodyman/presentation/theme/theme.dart';

class CurrencyItem extends StatelessWidget {
  final VoidCallback onTap;
  final bool isActive;
  final String title;
  final CustomColorSet colors;

  const CurrencyItem({
    super.key,
    required this.onTap,
    required this.isActive,
    required this.title,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: colors.icon,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(18.r),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: 18.r,
                  height: 18.r,
                  decoration: BoxDecoration(
                    color: isActive
                        ? colors.buttonFontColor
                        : AppStyle.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isActive ? colors.primary : AppStyle.textGrey,
                      width: isActive ? 5.r : 2.r,
                    ),
                  ),
                ),
                16.horizontalSpace,
                Expanded(
                  child: Text(
                    title,
                    style: AppStyle.interNormal(
                      size: 16,
                      color: colors.textBlack,
                    ),
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
