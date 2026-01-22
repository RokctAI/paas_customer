import 'dart:ui';
import 'package:foodyman/presentation/theme/theme_preference.dart';

import 'app_style.dart';

class CustomColorSet {
  final Color primary;

  final Color buttonFontColor;

  final Color white;

  final Color black;

  final Color textHint;

  final Color textBlack;

  final Color textWhite;

  final Color icon;

  final Color success;

  final Color error;

  final Color transparent;

  final Color backgroundColor;

  final Color socialButtonColor;

  final Color newBoxColor;

  final Color bottomBarColor;

  final Color categoryColor;

  final Color categoryTitleColor;

  final Color red;

  final Color greyColor;

  CustomColorSet._({
    required this.primary,
    required this.buttonFontColor,
    required this.textBlack,
    required this.textWhite,
    required this.textHint,
    required this.white,
    required this.black,
    required this.icon,
    required this.success,
    required this.error,
    required this.transparent,
    required this.backgroundColor,
    required this.socialButtonColor,
    required this.bottomBarColor,
    required this.categoryColor,
    required this.categoryTitleColor,
    required this.newBoxColor,
    required this.red,
    required this.greyColor,
  });

  factory CustomColorSet._create(CustomThemeMode mode) {
    final isLight = mode.isLight;

    final textHint = isLight ? AppStyle.textHint : AppStyle.white;

    final textBlack = isLight ? AppStyle.black : AppStyle.white;

    final textWhite = isLight ? AppStyle.white : AppStyle.black;

    final categoryColor = isLight ? AppStyle.black : AppStyle.categoryDark;

    final categoryTitleColor = isLight
        ? AppStyle.black
        : AppStyle.whiteWithOpacity;

    final primary = AppStyle.primary;

    final buttonFontColor = AppStyle.buttonFontColor;

    const white = AppStyle.white;
    const black = AppStyle.black;

    const icon = AppStyle.icon;

    final backgroundColor = isLight ? AppStyle.white : AppStyle.bgDark;

    final newBoxColor = isLight ? AppStyle.subCategory : AppStyle.categoryDark;

    const success = AppStyle.success;

    const error = AppStyle.red;

    const transparent = AppStyle.transparent;

    const red = AppStyle.red;

    final socialButtonColor = isLight
        ? AppStyle.socialButtonLight
        : AppStyle.socialButtonDark;

    final bottomBarColor = isLight
        ? AppStyle.bottomBarColorLight.withValues(alpha: 0.8)
        : AppStyle.bottomBarColorDark;

    const greyColor = AppStyle.bgGrey;

    return CustomColorSet._(
      categoryColor: categoryColor,
      textHint: textHint,
      textBlack: textBlack,
      textWhite: textWhite,
      primary: primary,
      buttonFontColor: buttonFontColor,
      white: white,
      black: black,
      icon: icon,
      backgroundColor: backgroundColor,
      success: success,
      error: error,
      transparent: transparent,
      socialButtonColor: socialButtonColor,
      bottomBarColor: bottomBarColor,
      categoryTitleColor: categoryTitleColor,
      newBoxColor: newBoxColor,
      red: red,
      greyColor: greyColor,
    );
  }

  static CustomColorSet createOrUpdate(CustomThemeMode mode) {
    return CustomColorSet._create(mode);
  }
}
