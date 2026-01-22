import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/application/order/order_provider.dart';
import 'package:foodyman/application/promo_code/promo_code_state.dart';
import 'package:foodyman/infrastructure/services/services.dart';
import 'package:foodyman/presentation/theme/theme.dart';

import 'package:foodyman/application/promo_code/promo_code_notifier.dart';
import 'package:foodyman/application/promo_code/promo_code_provider.dart';
import 'package:foodyman/application/shop_order/shop_order_provider.dart';
import '../../../../../app_constants.dart';

import 'package:foodyman/presentation/theme/color_set.dart';

import 'package:foodyman/presentation/components/components.dart';

class PromoCodeScreen extends ConsumerStatefulWidget {
  final CustomColorSet colors;

  const PromoCodeScreen({super.key, required this.colors});

  @override
  ConsumerState<PromoCodeScreen> createState() => _PromoCodeState();
}

class _PromoCodeState extends ConsumerState<PromoCodeScreen> {
  late PromoCodeNotifier event;
  late PromoCodeState state;
  late TextEditingController promoCodeController = TextEditingController();
  final _delayed = Delayed(milliseconds: 700);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(promoCodeProvider.notifier).change(false);
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    event = ref.read(promoCodeProvider.notifier);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    promoCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    state = ref.watch(promoCodeProvider);
    final colors = widget.colors;
    return Container(
      margin: MediaQuery.of(context).viewInsets,
      decoration: BoxDecoration(
        color: colors.backgroundColor.withValues(alpha: 0.96),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r),
          topRight: Radius.circular(12.r),
        ),
      ),
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                        borderRadius: BorderRadius.all(Radius.circular(40.r)),
                      ),
                    ),
                  ),
                  14.verticalSpace,
                  TitleAndIcon(
                    title: AppHelpers.getTranslation(TrKeys.addPromoCode),
                    paddingHorizontalSize: 0,
                    rightTitle: AppHelpers.getTranslation(TrKeys.clear),
                    rightTitleColor: AppStyle.red,
                    onRightTap: () {
                      promoCodeController.clear();
                    },
                  ),
                  24.verticalSpace,
                  OutlinedBorderTextField(
                    textController: promoCodeController,
                    label: AppHelpers.getTranslation(
                      TrKeys.promoCode,
                    ).toUpperCase(),
                    onChanged: (s) {
                      _delayed.run(() {
                        event.checkPromoCode(
                          context,
                          s,
                          ref.read(orderProvider).shopData?.id ?? 0,
                        );
                      });
                    },
                    suffixIcon: state.isActive
                        ? Container(
                            width: 30.r,
                            height: 30.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colors.primary,
                            ),
                            child: Icon(
                              Icons.done_all,
                              color: colors.textBlack,
                              size: 16.r,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  146.verticalSpace,
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.paddingOf(context).bottom + 24.h,
                    ),
                    child: CustomButton(
                      isLoading: state.isLoading,
                      background: state.isActive
                          ? colors.primary
                          : AppStyle.borderColor,
                      textColor: state.isActive
                          ? colors.buttonFontColor
                          : AppStyle.textGrey,
                      title: AppHelpers.getTranslation(TrKeys.save),
                      onPressed: () {
                        if (state.isActive) {
                          ref
                              .read(orderProvider.notifier)
                              .setPromoCode(promoCodeController.text);
                          ref
                              .read(orderProvider.notifier)
                              .getCalculate(
                                context: context,
                                isLoading: false,
                                cartId:
                                    ref.read(shopOrderProvider).cart?.id ?? 0,
                                long:
                                    LocalStorage.getAddressSelected()
                                        ?.location
                                        ?.longitude ??
                                    AppConstants.demoLongitude,
                                lat:
                                    LocalStorage.getAddressSelected()
                                        ?.location
                                        ?.latitude ??
                                    AppConstants.demoLatitude,
                                type: ref.read(orderProvider).tabIndex == 1
                                    ? DeliveryTypeEnum.pickup
                                    : DeliveryTypeEnum.delivery,
                              );
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
