import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/infrastructure/services/services.dart';
import 'package:foodyman/presentation/app_assets.dart';
import 'package:foodyman/presentation/routes/app_router.dart';
import 'package:foodyman/presentation/theme/app_style.dart';

import 'package:foodyman/presentation/components/components.dart';
import 'package:foodyman/presentation/theme/color_set.dart';

class DeliveryBanner extends StatelessWidget {
  final CustomColorSet colors;

  const DeliveryBanner({super.key, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: REdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Stack(
        children: [
          Padding(
            padding: REdgeInsets.only(left: 0, right: 0, bottom: 160),
            child: Image.asset(Assets.imagesDeliveryBanner),
          ),
          Positioned(
            top: 16.r,
            right: 32.r,
            child: Row(
              children: [
                CustomNetworkImage(
                  url: AppHelpers.getAppLogo(),
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
              height: 256,
              padding: REdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: ShapeDecoration(
                color: colors.primary,
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
                    style: AppStyle.interRegular(
                      size: 32,
                      color: colors.buttonFontColor,
                    ),
                  ),
                  Text(
                    AppHelpers.getTranslation(TrKeys.yourPersonalDoor),
                    style: AppStyle.interNormal(
                      size: 14,
                      color: colors.buttonFontColor,
                    ),
                  ),
                  Spacer(),
                  AnimationButtonEffect(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        if (LocalStorage.getToken().isEmpty) {
                          context.pushRoute(const LoginRoute());
                          return;
                        }
                        context.pushRoute(const ParcelRoute());
                        return;
                      },
                      child: Container(
                        width: 150.r,
                        height: 50.r,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: colors.buttonFontColor),
                        ),
                        child: Center(
                          child: Text(
                            AppHelpers.getTranslation(TrKeys.learnMore),
                            style: AppStyle.interNormal(
                              color: colors.buttonFontColor,
                            ),
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
