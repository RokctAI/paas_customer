import 'package:auto_route/auto_route.dart';
import 'package:base_sdk/src/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:base_sdk/src/services/app_helpers.dart';
import 'package:base_sdk/src/services/local_storage.dart';
import 'package:base_sdk/src/services/tr_keys.dart';
import 'package:base_sdk/src/presentation/components/buttons/custom_button.dart';
// [refork] removed host router import
import 'package:base_sdk/src/presentation/theme/theme.dart';

class DoorToDoor extends StatelessWidget {
  const DoorToDoor({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.r),
      padding: EdgeInsets.all(30.r),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppStyle.doorColor,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppHelpers.getTranslation(TrKeys.doorToDoor),
            style: AppStyle.interSemi(size: 42),
          ),
          10.verticalSpace,
          Text(
            AppHelpers.getTranslation(TrKeys.yourPersonalDoor),
            style: AppStyle.interRegular(size: 16),
          ),
          20.verticalSpace,
          Image.asset("assets/images/door.png"),
          10.verticalSpace,
          CustomButton(
            title: AppHelpers.getTranslation(TrKeys.learnMore),
            onPressed: () {
              if (LocalStorage.getToken().isEmpty) {
                AppRoutes.I.pushLoginRoute(context);
                return;
              }
              AppRoutes.I.pushParcelRoute(context);
              return;
            },
            background: AppStyle.transparent,
            borderColor: AppStyle.black,
          ),
        ],
      ),
    );
  }
}
