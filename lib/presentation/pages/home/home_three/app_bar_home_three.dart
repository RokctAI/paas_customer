import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodyman/application/home/home_notifier.dart';
import 'package:foodyman/application/home/home_state.dart';
import 'package:foodyman/infrastructure/services/services.dart';
import 'package:foodyman/presentation/app_assets.dart';
import 'package:foodyman/presentation/routes/app_router.dart';
import 'package:foodyman/presentation/theme/app_style.dart';
import 'package:foodyman/presentation/theme/color_set.dart';

import 'package:foodyman/presentation/components/components.dart';

class AppBarThree extends StatelessWidget {
  final HomeState state;
  final HomeNotifier event;
  final CustomColorSet colors;

  const AppBarThree({
    super.key,
    required this.state,
    required this.event,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return CommonAppBar(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              if (LocalStorage.getToken().isEmpty) {
                context.pushRoute(ViewMapRoute());
                return;
              }
              AppHelpers.showCustomModalBottomSheet(
                context: context,
                modal: SelectAddressScreen(
                  addAddress: () async {
                    await context.pushRoute(ViewMapRoute());
                  },
                ),
                isDarkMode: false,
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppStyle.white,
                  ),
                  padding: EdgeInsets.all(12.r),
                  child: SvgPicture.asset(Assets.svgsAdress),
                ),
                10.horizontalSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      AppHelpers.getTranslation(TrKeys.deliveryAddress),
                      style: AppStyle.interNormal(
                        size: 12,
                        color: AppStyle.textGrey,
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width - 160.w,
                          child: Text(
                            (LocalStorage.getAddressSelected()
                                        ?.title
                                        ?.isEmpty ??
                                    true)
                                ? LocalStorage.getAddressSelected()?.address ??
                                      ''
                                : LocalStorage.getAddressSelected()?.title ??
                                      "",
                            style: AppStyle.interBold(
                              size: 14,
                              color: colors.textBlack,
                            ),
                            maxLines: 1,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down_sharp,
                          color: colors.textBlack,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              context.pushRoute(ProfileRoute());
            },
            child: Container(
              width: 40.r,
              height: 40.r,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: CustomNetworkImage(
                profile: true,
                url: LocalStorage.getUser()?.img,
                height: 40.r,
                width: 40.r,
                radius: 20.r,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
