import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodyman/application/edit_profile/edit_profile_provider.dart';
import 'package:foodyman/application/order/order_provider.dart';
import 'package:foodyman/infrastructure/services/services.dart';
import 'package:foodyman/presentation/app_assets.dart';

import 'package:foodyman/presentation/pages/profile/phone_verify.dart';
import 'package:foodyman/presentation/routes/app_router.dart';
import 'package:foodyman/presentation/theme/color_set.dart';
import '../../order_check/widgets/time_delivery.dart';
import 'order_container.dart';

import 'package:foodyman/presentation/components/components.dart';

class OrderDelivery extends StatefulWidget {
  final ValueChanged<bool> onChange;
  final VoidCallback getLocation;
  final int shopId;
  final CustomColorSet colors;

  const OrderDelivery({
    super.key,
    required this.onChange,
    required this.getLocation,
    required this.shopId,
    required this.colors,
  });

  @override
  State<OrderDelivery> createState() => _OrderDeliveryState();
}

class _OrderDeliveryState extends State<OrderDelivery> {
  late TextEditingController houseController;
  late TextEditingController floorController;
  late TextEditingController commentController;
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController userPhoneNumber;

  @override
  void initState() {
    houseController = TextEditingController(
      text: LocalStorage.getAddressInformation()?.house,
    );
    floorController = TextEditingController(
      text: LocalStorage.getAddressInformation()?.floor,
    );
    commentController = TextEditingController();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    userPhoneNumber = TextEditingController(
      text: LocalStorage.getUser()?.phone,
    );
    super.initState();
  }

  @override
  void dispose() {
    houseController.dispose();
    floorController.dispose();
    commentController.dispose();
    nameController.dispose();
    phoneController.dispose();
    userPhoneNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 24.h),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Consumer(
          builder: (context, ref, child) {
            ref.listen(editProfileProvider, (previous, next) {
              if (next.isSuccess &&
                  (next.isSuccess != (previous?.isSuccess ?? false))) {
                userPhoneNumber.text = next.userData?.phone ?? "";
              }
            });
            return Column(
              children: [
                OrderContainer(
                  colors: widget.colors,
                  onTap: () async {
                    AppHelpers.showCustomModalBottomSheet(
                      context: context,
                      modal: SelectAddressScreen(
                        addAddress: () async {
                          await context.pushRoute(
                            ViewMapRoute(shopId: widget.shopId),
                          );
                          widget.getLocation();
                        },
                      ),
                      isDarkMode: false,
                    );
                  },
                  icon: Padding(
                    padding: EdgeInsets.only(left: 4.w),
                    child: SvgPicture.asset(
                      Assets.svgsAdress,
                      colorFilter: ColorFilter.mode(
                        widget.colors.textBlack,
                        BlendMode.srcIn,
                      ),
                      width: 20.r,
                      height: 20.r,
                    ),
                  ),
                  title: AppHelpers.getTranslation(TrKeys.deliveryAddress),
                  description:
                      (LocalStorage.getAddressSelected()?.title?.isEmpty ??
                          true)
                      ? LocalStorage.getAddressSelected()?.address ?? ''
                      : LocalStorage.getAddressSelected()?.title ?? "",
                ),
                10.verticalSpace,
                OrderContainer(
                  colors: widget.colors,
                  onTap: () {
                    AppHelpers.showCustomModalBottomSheet(
                      backgroundColor: widget.colors.backgroundColor,
                      paddingTop: MediaQuery.paddingOf(context).top + 150.h,
                      context: context,
                      modal: TimeDelivery(colors: widget.colors),
                      isDarkMode: false,
                      isDrag: true,
                      radius: 12,
                    );
                  },
                  icon: Icon(
                    FlutterRemix.calendar_check_line,
                    size: 24.r,
                    color: widget.colors.textBlack,
                  ),
                  title: AppHelpers.getTranslation(TrKeys.timeDelivery),
                  description: ref.watch(orderProvider).selectDate == null
                      ? AppHelpers.getTranslation(
                          TrKeys.notWorkTodayAndTomorrow,
                        )
                      : "${TimeService.dateFormatMD(ref.watch(orderProvider).selectDate!)}  ${TimeService.timeFormatTime(ref.watch(orderProvider).selectTime.format(context))}",
                ),
                16.verticalSpace,
                OutlinedBorderTextField(
                  label: AppHelpers.getTranslation(TrKeys.house).toUpperCase(),
                  textController: houseController,
                  onChanged: (s) {
                    ref.read(orderProvider.notifier).setAddressInfo(house: s);
                  },
                ),
                12.verticalSpace,
                OutlinedBorderTextField(
                  label: AppHelpers.getTranslation(TrKeys.floor).toUpperCase(),
                  textController: floorController,
                  onChanged: (s) {
                    ref.read(orderProvider.notifier).setAddressInfo(floor: s);
                  },
                ),
                12.verticalSpace,
                OutlinedBorderTextField(
                  label: AppHelpers.getTranslation(
                    TrKeys.comment,
                  ).toUpperCase(),
                  textController: commentController,
                  onChanged: (s) {
                    ref.read(orderProvider.notifier).setAddressInfo(note: s);
                  },
                ),
                12.verticalSpace,
                OutlinedBorderTextField(
                  label: AppHelpers.getTranslation(
                    TrKeys.phoneNumber,
                  ).toUpperCase(),
                  textController: userPhoneNumber,
                  readOnly: true,
                  onTap: () {
                    AppHelpers.showCustomModalBottomSheet(
                      context: context,
                      modal: PhoneVerify(),
                      isDarkMode: false,
                      paddingTop: MediaQuery.paddingOf(context).top,
                    );
                  },
                ),
                12.verticalSpace,
                Row(
                  children: [
                    CustomCheckbox(
                      colors: widget.colors,
                      isActive: ref.watch(orderProvider).sendOtherUser,
                      onTap: () {
                        ref
                            .read(orderProvider.notifier)
                            .checkBox(!ref.watch(orderProvider).sendOtherUser);
                      },
                    ),
                    12.horizontalSpace,
                    Text(
                      AppHelpers.getTranslation(TrKeys.iWantToOrderForSomeone),
                      style: TextStyle(color: widget.colors.textBlack),
                    ),
                  ],
                ),
                if (ref.watch(orderProvider).sendOtherUser)
                  Column(
                    children: [
                      16.verticalSpace,
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedBorderTextField(
                              label: AppHelpers.getTranslation(
                                TrKeys.firstname,
                              ).toUpperCase(),
                              textController: nameController,
                              validation: AppValidators.isNotEmptyValidator,
                              onChanged: (s) {
                                ref
                                    .read(orderProvider.notifier)
                                    .setUser(username: s);
                              },
                            ),
                          ),
                          16.horizontalSpace,
                          Expanded(
                            child: OutlinedBorderTextField(
                              label: AppHelpers.getTranslation(
                                TrKeys.phoneNumber,
                              ).toUpperCase(),
                              textController: phoneController,
                              inputType: TextInputType.phone,
                              validation: AppValidators.isNotEmptyValidator,
                              onChanged: (s) {
                                ref
                                    .read(orderProvider.notifier)
                                    .setUser(phone: s);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
