import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/infrastructure/services/services.dart';
import 'package:foodyman/presentation/routes/app_router.dart';
import 'package:foodyman/presentation/theme/app_style.dart';
import 'package:foodyman/presentation/theme/color_set.dart';

class KeepLoggedCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final CustomColorSet colors;

  const KeepLoggedCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 24.r,
          width: 24.r,
          child: Transform.scale(
            scale: 1.2,
            child: Checkbox(
              side: BorderSide(color: colors.textBlack, width: 1.5.r),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.r),
              ),
              checkColor: colors.backgroundColor,
              activeColor: colors.textBlack,
              value: value,
              onChanged: (value) => onChanged(value!),
            ),
          ),
        ),
        8.horizontalSpace,
        Expanded(
          child: RichText(
            text: TextSpan(
              style: AppStyle.interNormal(size: 13, color: colors.textBlack),
              children: [
                TextSpan(
                  text: '${AppHelpers.getTranslation(TrKeys.iAcceptThe)} ',
                ),
                TextSpan(
                  text: AppHelpers.getTranslation(TrKeys.privacyPolicy),
                  style: AppStyle.interNormal(
                    size: 13,
                    color: colors.primary,
                    textDecoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      context.pushRoute(PolicyRoute());
                    },
                ),
                TextSpan(text: ' ${AppHelpers.getTranslation(TrKeys.and)} '),
                TextSpan(
                  text: AppHelpers.getTranslation(TrKeys.termsAndConditions),
                  style: AppStyle.interNormal(
                    size: 13,
                    color: colors.primary,
                    textDecoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      context.pushRoute(TermRoute());
                    },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
