import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/application/order/order_state.dart';
import 'package:foodyman/infrastructure/services/services.dart';
import 'package:foodyman/presentation/theme/app_style.dart';
import 'package:foodyman/presentation/theme/color_set.dart';
import 'widgets/title_price.dart';

class PriceInformation extends StatelessWidget {
  final bool isOrder;

  final OrderState state;

  final CustomColorSet colors;

  const PriceInformation({
    super.key,
    required this.isOrder,
    required this.state,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        30.verticalSpace,
        TitleAndPrice(
          title: AppHelpers.getTranslation(TrKeys.subtotal),
          rightTitle: AppHelpers.numberFormat(
            isOrder ? state.orderData?.originPrice : state.calculateData?.price,
            isOrder: isOrder,
            symbol: (state.orderData?.currencyModel?.symbol),
          ),
          textStyle: AppStyle.interRegular(size: 16, color: colors.textBlack),
        ),
        16.verticalSpace,
        TitleAndPrice(
          title: AppHelpers.getTranslation(TrKeys.deliveryPrice),
          rightTitle: AppHelpers.numberFormat(
            isOrder
                ? state.orderData?.deliveryFee
                : state.calculateData?.deliveryFee,
            symbol: state.orderData?.currencyModel?.symbol,
            isOrder: isOrder,
          ),
          textStyle: AppStyle.interRegular(size: 16, color: colors.textBlack),
        ),
        16.verticalSpace,
        TitleAndPrice(
          title: AppHelpers.getTranslation(TrKeys.tax),
          rightTitle: AppHelpers.numberFormat(
            isOrder ? state.orderData?.tax : state.calculateData?.totalTax,
            isOrder: isOrder,
            symbol: state.orderData?.currencyModel?.symbol,
          ),
          textStyle: AppStyle.interRegular(size: 16, color: colors.textBlack),
        ),
        16.verticalSpace,
        TitleAndPrice(
          title: AppHelpers.getTranslation(TrKeys.serviceFee),
          rightTitle: AppHelpers.numberFormat(
            isOrder
                ? ((state.orderData?.serviceFee ?? 0))
                : (state.calculateData?.serviceFee ?? 0),
            isOrder: isOrder,
            symbol: state.orderData?.currencyModel?.symbol,
          ),
          textStyle: AppStyle.interRegular(size: 16, color: colors.textBlack),
        ),
        if (isOrder) ...[
          16.verticalSpace,
          TitleAndPrice(
            title: AppHelpers.getTranslation(TrKeys.deliveryTip),
            rightTitle: AppHelpers.numberFormat(
              state.orderData?.tips,
              isOrder: isOrder,
              symbol: state.orderData?.currencyModel?.symbol,
            ),
            textStyle: AppStyle.interRegular(size: 16, color: colors.textBlack),
          ),
        ],
        16.verticalSpace,
        if (isOrder
            ? state.orderData?.totalDiscount != null
            : state.calculateData?.totalDiscount != null)
          TitleAndPrice(
            title: AppHelpers.getTranslation(TrKeys.discount),
            rightTitle:
                "-${AppHelpers.numberFormat(isOrder ? state.orderData?.totalDiscount : state.calculateData?.totalDiscount, isOrder: isOrder, symbol: state.orderData?.currencyModel?.symbol)}",
            textStyle: AppStyle.interRegular(size: 16, color: AppStyle.red),
          ),
        16.verticalSpace,
        if (isOrder
            ? state.orderData?.coupon != null
            : state.calculateData?.couponPrice != null)
          TitleAndPrice(
            title: AppHelpers.getTranslation(TrKeys.promoCode),
            rightTitle:
                "-${AppHelpers.numberFormat(isOrder ? state.orderData?.coupon : state.calculateData?.couponPrice, isOrder: isOrder, symbol: state.orderData?.currencyModel?.symbol)}",
            textStyle: AppStyle.interRegular(size: 16, color: AppStyle.red),
          ),
        16.verticalSpace,
        const Divider(color: AppStyle.textGrey),
        16.verticalSpace,
        TitleAndPrice(
          title: AppHelpers.getTranslation(TrKeys.total),
          rightTitle: AppHelpers.numberFormat(
            isOrder
                ? (state.orderData?.totalPrice?.isNegative ?? true)
                      ? 0
                      : state.orderData?.totalPrice
                : state.calculateData?.totalPrice,
            isOrder: isOrder,
            symbol: state.orderData?.currencyModel?.symbol,
          ),
          textStyle: AppStyle.interSemi(size: 20, color: colors.textBlack),
        ),
      ],
    );
  }
}
