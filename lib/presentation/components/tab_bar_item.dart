import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/presentation/theme/theme.dart';
import 'package:foodyman/presentation/theme/theme_wrapper.dart';

class TabBarItem extends StatelessWidget {
  final bool isShopTabBar;
  final String title;
  final int index;
  final int? currentIndex;
  final VoidCallback onTap;

  const TabBarItem({
    super.key,
    required this.title,
    required this.index,
    this.isShopTabBar = false,
    this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ThemeWrapper(
      builder: (colors, theme) {
        return GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              color: isShopTabBar
                  ? (currentIndex == index ? colors.primary : colors.icon)
                  : colors.icon,
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: [
                BoxShadow(
                  color: AppStyle.white.withValues(alpha: 0.07),
                  spreadRadius: 0,
                  blurRadius: 2,
                  offset: const Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            margin: EdgeInsets.only(right: 9.w),
            child: Center(
              child: Text(
                title,
                style: AppStyle.interNormal(size: 13, color: colors.textBlack),
              ),
            ),
          ),
        );
      },
    );
  }
}
