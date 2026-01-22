import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/application/home/home_provider.dart';
import 'package:foodyman/infrastructure/models/data/address_old_data.dart';
import 'package:foodyman/infrastructure/models/data/location.dart';
import 'package:foodyman/app_constants.dart';
import 'package:foodyman/infrastructure/services/services.dart';
import 'package:foodyman/presentation/routes/app_router.dart';
import 'package:foodyman/presentation/theme/app_style.dart';

import '../../../theme/color_set.dart';

import 'package:foodyman/presentation/components/components.dart';

class AddAddress extends StatelessWidget {
  final CustomColorSet colors;
  const AddAddress({super.key, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppHelpers.getTranslation(TrKeys.agreeLocation),
          style: AppStyle.interSemi(size: 16.sp, color: colors.textBlack),
          textAlign: TextAlign.center,
        ),
        24.verticalSpace,
        Row(
          children: [
            Expanded(
              child: CustomButton(
                title: AppHelpers.getTranslation(TrKeys.cancel),
                borderColor: AppStyle.black,
                textColor: colors.textBlack,
                background: AppStyle.transparent,
                onPressed: () {
                  Navigator.pop(context);
                  context.pushRoute(ViewMapRoute(isPop: true));
                },
              ),
            ),
            24.horizontalSpace,
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  return CustomButton(
                    textColor: colors.textBlack,
                    title: AppHelpers.getTranslation(TrKeys.yes),
                    onPressed: () {
                      Navigator.pop(context);
                      LocalStorage.setAddressSelected(
                        AddressData(
                          title: AppHelpers.getAppAddressName(),
                          location: LocationModel(
                            longitude:
                                (AppHelpers.getInitialLongitude() ??
                                AppConstants.demoLongitude),
                            latitude:
                                (AppHelpers.getInitialLatitude() ??
                                AppConstants.demoLatitude),
                          ),
                        ),
                      );
                      ref.read(homeProvider.notifier).setAddress();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
