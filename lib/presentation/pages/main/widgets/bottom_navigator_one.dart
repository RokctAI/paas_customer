import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodyman/infrastructure/services/services.dart';
import 'package:foodyman/presentation/theme/app_style.dart';
import 'package:foodyman/presentation/theme/color_set.dart';

class BottomNavigatorOne extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final CustomColorSet colors;

  const BottomNavigatorOne({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      backgroundColor: colors.textWhite,
      type: BottomNavigationBarType.fixed,
      unselectedItemColor: AppStyle.textGrey,
      selectedItemColor: colors.textBlack,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(FlutterRemix.home_smile_fill),
          label: AppHelpers.getTranslation(TrKeys.home),
        ),
        BottomNavigationBarItem(
          icon: const Icon(FlutterRemix.apps_2_line),
          label: AppHelpers.getTranslation(TrKeys.allServices),
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            "assets/svgs/box.svg",
            color: AppStyle.textGrey,
          ),
          label: AppHelpers.getTranslation(TrKeys.fosend),
        ),
        BottomNavigationBarItem(
          icon: const Icon(FlutterRemix.shopping_bag_3_line),
          label: AppHelpers.getTranslation(TrKeys.cart),
        ),
      ],
    );
  }
}
