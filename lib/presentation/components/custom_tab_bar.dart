import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:foodyman/presentation/theme/theme.dart';
import 'package:foodyman/presentation/theme/theme_wrapper.dart';

class CustomTabBar extends StatelessWidget {
  final bool isScrollable;
  final TabController tabController;
  final List<Tab> tabs;

  const CustomTabBar({
    super.key,
    required this.tabController,
    required this.tabs,
    this.isScrollable = false,
  });

  @override
  Widget build(BuildContext context) {
    return ThemeWrapper(
      builder: (colors, theme) {
        return Container(
          padding: EdgeInsets.all(6.r),
          height: 50.h,
          decoration: BoxDecoration(
            color: AppStyle.transparent,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: AppStyle.tabBarBorderColor),
          ),
          child: TabBar(
            isScrollable: isScrollable,
            controller: tabController,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: colors.icon,
            ),
            labelColor: colors.textBlack,
            unselectedLabelColor: colors.textHint,
            unselectedLabelStyle: AppStyle.interRegular(size: 14),
            labelStyle: AppStyle.interSemi(size: 14),
            tabs: tabs,
          ),
        );
      },
    );
  }
}
