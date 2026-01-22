import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/application/parcel/parcel_notifier.dart';
import 'package:foodyman/application/parcel/parcel_state.dart';
import 'package:foodyman/infrastructure/services/services.dart';
import 'package:foodyman/presentation/theme/app_style.dart';

import 'package:foodyman/presentation/theme/color_set.dart';

import 'package:foodyman/presentation/components/components.dart';

class TypeAndTime extends StatelessWidget {
  final ParcelState state;
  final ParcelNotifier event;
  final CustomColorSet colors;

  const TypeAndTime({
    super.key,
    required this.state,
    required this.event,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (state.expand)
          Container(
            margin: EdgeInsets.only(top: 16.r),
            color: AppStyle.transparent,
            padding: EdgeInsets.all(16.r),
            child: InkWell(
              child: Container(
                decoration: BoxDecoration(
                  color: colors.icon,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 16.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppHelpers.getTranslation(TrKeys.remainAnonymous),
                          style: AppStyle.interSemi(size: 16),
                        ),
                        Text(
                          AppHelpers.getTranslation(TrKeys.dontNotifyRecipient),
                          style: AppStyle.interRegular(size: 14),
                        ),
                      ],
                    ),
                    Expanded(
                      child: CustomToggle(
                        controller: ValueNotifier<bool>(false),
                        title: "",
                        isChecked: state.anonymous,
                        onChange: () => event.changeAnonymous(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        Container(
          margin: EdgeInsets.only(top: 16.r, bottom: 24.r),
          color: colors.icon,
          padding: EdgeInsets.all(16.r),
          child: InkWell(
            onTap: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
                initialEntryMode: TimePickerEntryMode.dialOnly,
              );

              if (time != null) {
                if (time.hour < TimeOfDay.now().hour) {
                  if (context.mounted) {
                    AppHelpers.showCheckTopSnackBarInfo(
                      context,
                      AppHelpers.getTranslation(TrKeys.thisTimeIsNotAvailable),
                    );
                  }

                  return;
                }
                if (time.hour == TimeOfDay.now().hour &&
                    time.minute < TimeOfDay.now().hour) {
                  if (context.mounted) {
                    AppHelpers.showCheckTopSnackBarInfo(
                      context,
                      AppHelpers.getTranslation(TrKeys.thisTimeIsNotAvailable),
                    );
                  }
                  return;
                }
                event.setTime(time: time);
              }
            },
            child: AnimationButtonEffect(
              child: Container(
                decoration: BoxDecoration(
                  color: colors.icon,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 16.r),
                child: Row(
                  children: [
                    Icon(FlutterRemix.time_line, color: colors.textBlack),
                    12.horizontalSpace,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppHelpers.getTranslation(TrKeys.deliveryTime),
                          style: AppStyle.interRegular(
                            size: 12,
                            color: colors.textBlack,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width / 2,
                          child: Text(
                            "${AppHelpers.getTranslation(TrKeys.pickupAt)} ${state.time?.format(context) ?? TimeOfDay.now().format(context)}",
                            style: AppStyle.interSemi(
                              size: 16,
                              color: colors.textBlack,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Icon(
                      FlutterRemix.arrow_right_s_line,
                      color: colors.textBlack,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10.r, bottom: 24.r),
          color: colors.backgroundColor,
          padding: EdgeInsets.all(16.r),
          child: GridView.builder(
            padding: EdgeInsets.zero,
            itemCount: state.types.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1,
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  if (index == state.selectType) {
                    AppHelpers.showCustomModalBottomSheet(
                      context: context,
                      modal: Container(
                        decoration: BoxDecoration(
                          color: colors.backgroundColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12.r),
                            topRight: Radius.circular(12.r),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            8.verticalSpace,
                            Center(
                              child: Container(
                                height: 4.h,
                                width: 48.w,
                                decoration: BoxDecoration(
                                  color: AppStyle.dragElement,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(40.r),
                                  ),
                                ),
                              ),
                            ),
                            18.verticalSpace,
                            TitleAndIcon(title: state.types[index]?.type ?? ""),
                            14.verticalSpace,
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.r),
                              child: Text(
                                "${AppHelpers.getTranslation(TrKeys.upTo)} ${(state.types[index]?.maxG ?? 1) / 1000} ${AppHelpers.getTranslation(TrKeys.kg)}, ${(state.types[index]?.maxHeight ?? 1)}X${(state.types[index]?.maxWidth ?? 1)} ${AppHelpers.getTranslation(TrKeys.sm)}",
                                style: AppStyle.interRegular(
                                  size: 14,
                                  color: colors.textBlack,
                                ),
                              ),
                            ),
                            20.verticalSpace,
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.r),
                              child: CustomNetworkImage(
                                url: state.types[index]?.img ?? "",
                                height: 210,
                                width: double.infinity,
                                radius: 10,
                              ),
                            ),
                            20.verticalSpace,
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.r),
                              child: CustomButton(
                                title: AppHelpers.getTranslation(TrKeys.gotIt),
                                onPressed: () {
                                  context.maybePop();
                                },
                              ),
                            ),
                            32.verticalSpace,
                          ],
                        ),
                      ),
                      isDarkMode: false,
                    );
                    return;
                  }
                  event.selectType(index: index, context: context);
                },
                child: AnimationButtonEffect(
                  child: Container(
                    foregroundDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: state.selectType == index
                          ? AppStyle.transparent
                          : colors.icon.withValues(alpha: 0.6),
                    ),
                    margin: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: colors.icon,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomNetworkImage(
                          url: state.types[index]?.img ?? "",
                          height: 70,
                          width: 70,
                          fit: BoxFit.contain,
                          radius: 8,
                        ),
                        8.verticalSpace,
                        Text(
                          state.types[index]?.type ?? "",
                          style: AppStyle.interSemi(
                            size: 16,
                            color: colors.textBlack,
                          ),
                        ),
                        8.verticalSpace,
                        Text(
                          "${AppHelpers.getTranslation(TrKeys.upTo)} ${(state.types[index]?.maxG ?? 1) / 1000} ${AppHelpers.getTranslation(TrKeys.kg)}",
                          style: AppStyle.interSemi(
                            size: 13,
                            color: colors.textBlack,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
