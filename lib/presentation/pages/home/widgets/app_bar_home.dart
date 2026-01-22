import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodyman/application/home/home_notifier.dart';
import 'package:foodyman/application/home/home_state.dart';
import 'package:foodyman/infrastructure/services/services.dart';
import 'package:foodyman/presentation/components/components.dart';
import 'package:foodyman/presentation/routes/app_router.dart';
import 'package:foodyman/presentation/theme/app_style.dart';
import 'package:foodyman/presentation/theme/color_set.dart';

class AppBarHome extends StatelessWidget {
  final HomeState state;
  final HomeNotifier event;
  final CustomColorSet colors;

  const AppBarHome({
    super.key,
    required this.state,
    required this.event,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return CommonAppBar(
      child: InkWell(
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
                color: AppStyle.bgGrey,
              ),
              padding: EdgeInsets.all(12.r),
              child: SvgPicture.asset("assets/svgs/adress.svg"),
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
                      width: MediaQuery.sizeOf(context).width - 120.w,
                      child: Text(
                        (LocalStorage.getAddressSelected()?.title?.isEmpty ??
                                true)
                            ? LocalStorage.getAddressSelected()?.address ?? ''
                            : LocalStorage.getAddressSelected()?.title ?? "",
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
    );
  }
}
