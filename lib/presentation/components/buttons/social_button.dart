import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/presentation/theme/color_set.dart';

import 'package:foodyman/presentation/theme/theme.dart';
import 'animation_button_effect.dart';

class SocialButton extends StatelessWidget {
  final IconData iconData;
  final Function() onPressed;
  final CustomColorSet colors;
  const SocialButton({
    super.key,
    required this.iconData,
    required this.onPressed,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationButtonEffect(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: colors.icon,
          minimumSize: Size(96.r, 36.r),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            Icon(iconData, color: AppStyle.textGrey, size: 16.r),
            8.horizontalSpace,
            Text(
              iconData == FlutterRemix.apple_fill
                  ? "Apple"
                  : iconData == FlutterRemix.facebook_fill
                  ? "Facebook"
                  : "Google",
              style: AppStyle.interNormal(size: 12, color: AppStyle.textGrey),
            ),
          ],
        ),
      ),
    );
  }
}
