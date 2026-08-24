import 'package:auto_route/auto_route.dart';
import 'package:base_sdk/src/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:base_sdk/src/services/app_helpers.dart';
import 'package:base_sdk/src/services/local_storage.dart';
import 'package:base_sdk/src/services/tr_keys.dart';
import 'package:base_sdk/src/presentation/components/buttons/animation_button_effect.dart';
import 'package:base_sdk/src/presentation/components/custom_network_image.dart';
// [refork] removed host router import
import 'package:base_sdk/src/presentation/theme/app_style.dart';

class DeliveryBanner extends StatelessWidget {
  const DeliveryBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: REdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Stack(
        children: [
          Padding(
            padding: REdgeInsets.only(left: 0, right: 0, bottom: 190),
            child: Image.asset("assets/images/delivery_banner.png"),
          ),
          Positioned(
            top: 16.r,
            right: 32.r,
            child: Row(
              children: [
                CustomNetworkImage(
                  url: AppHelpers.getAppLogo() ?? "",
                  height: 28.r,
                  width: 28.r,
                  radius: 0,
                ),
                6.horizontalSpace,
                Text(
                  AppHelpers.getAppName() ?? "",
                  style: AppStyle.interSemi(color: AppStyle.white),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16.r,
            left: 0,
            right: 32.r,
            child: Container(
              width: double.infinity,
              height: 286,
              padding: REdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: ShapeDecoration(
                color: AppStyle.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
                shadows: const [
                  BoxShadow(
                    color: AppStyle.shadow,
                    blurRadius: 30,
                    offset: Offset(0, 10),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppHelpers.getTranslation(TrKeys.doorToDoor),
                    style: AppStyle.interRegular(size: 38),
                  ),
                  Text(
                    AppHelpers.getTranslation(TrKeys.delivery),
                    style: AppStyle.interNormal(size: 38),
                  ),
                  12.verticalSpace,
                  Text(
                    "Your personal door-to-door delivery service",
                    style: AppStyle.interNormal(size: 12),
                  ),
                  const Spacer(),
                  AnimationButtonEffect(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        if (LocalStorage.getToken().isEmpty) {
                          AppRoutes.I.pushLoginRoute(context);
                          return;
                        }
                        AppRoutes.I.pushParcelRoute(context);
                        return;
                      },
                      child: Container(
                        width: 150.r,
                        height: 50.r,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppStyle.black),
                        ),
                        child: Center(
                          child: Text(
                            AppHelpers.getTranslation(TrKeys.learnMore),
                            style: AppStyle.interNormal(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
