import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/infrastructure/services/services.dart';
import 'package:foodyman/presentation/theme/color_set.dart';
import 'package:foodyman/presentation/theme/theme.dart';

class AuthTabBar extends StatefulWidget {
  final bool isScrollable;
  final TabController tabController;
  final CustomColorSet colors;

  const AuthTabBar({
    super.key,
    required this.tabController,
    this.isScrollable = false,
    required this.colors,
  });

  @override
  State<AuthTabBar> createState() => _AuthTabBarState();
}

class _AuthTabBarState extends State<AuthTabBar> {
  final tabs = [
    AuthTab(text: TrKeys.phone, icon: FlutterRemix.phone_fill),
    AuthTab(text: TrKeys.email, icon: FlutterRemix.mail_fill),
  ];

  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.colors;
    return Container(
      margin: EdgeInsets.only(bottom: 24.r),
      padding: EdgeInsets.all(6.r),
      height: 50.h,
      decoration: BoxDecoration(
        color: colors.newBoxColor,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: colors.textBlack.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TabBar(
        isScrollable: widget.isScrollable,
        controller: widget.tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: colors.textWhite,
        ),
        labelColor: colors.textBlack,
        unselectedLabelColor: colors.textBlack.withValues(alpha: 0.5),
        unselectedLabelStyle: AppStyle.interNormal(size: 12),
        labelStyle: AppStyle.interSemi(size: 12),
        tabs: tabs
            .map(
              (tab) => Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      tab.icon,
                      size: 18.r,
                      color: widget.tabController.index == tabs.indexOf(tab)
                          ? colors.textBlack
                          : colors.textBlack.withValues(alpha: 0.5),
                    ),
                    8.horizontalSpace,
                    Text(AppHelpers.getTranslation(tab.text)),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class AuthTab {
  final String text;
  final IconData icon;

  const AuthTab({required this.text, required this.icon});
}
