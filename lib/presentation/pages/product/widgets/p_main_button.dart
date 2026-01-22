import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/application/product/product_notifier.dart';
import 'package:foodyman/application/product/product_state.dart';
import 'package:foodyman/application/shop_order/shop_order_notifier.dart';
import 'package:foodyman/application/shop_order/shop_order_state.dart';
import 'package:foodyman/infrastructure/services/services.dart';
import 'package:foodyman/presentation/routes/app_router.dart';
import 'package:foodyman/presentation/theme/app_style.dart';
import 'package:foodyman/presentation/theme/theme_wrapper.dart';

import 'package:foodyman/presentation/components/components.dart';

class ProductMainButton extends StatelessWidget {
  final ShopOrderNotifier eventOrderShop;
  final ShopOrderState stateOrderShop;
  final ProductState state;
  final ProductNotifier event;
  final String? shopId;
  final String? cartId;
  final String? userUuid;

  const ProductMainButton({
    super.key,
    required this.state,
    required this.event,
    required this.stateOrderShop,
    required this.eventOrderShop,
    this.shopId,
    this.cartId,
    this.userUuid,
  });

  @override
  Widget build(BuildContext context) {
    num sumTotalPrice = 0;
    state.selectedStock?.addons?.forEach((element) {
      if (element.active ?? false) {
        sumTotalPrice +=
            ((element.product?.stock?.totalPrice ?? 0) *
            (element.quantity ?? 1));
      }
    });
    sumTotalPrice =
        (sumTotalPrice + (state.selectedStock?.totalPrice ?? 0) * state.count);
    return ThemeWrapper(
      builder: (colors, theme) {
        return Container(
          height: 130.h,
          color: colors.backgroundColor,
          padding: EdgeInsets.only(right: 16.w, left: 16.w),
          child: Column(
            children: [
              16.verticalSpace,
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 50.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: AppStyle.textGrey),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            event.disCount(context);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 8.h,
                              horizontal: 10.w,
                            ),
                            child: Icon(Icons.remove, color: colors.textBlack),
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text:
                                "${state.count * (state.productData?.interval ?? 1)}",
                            style: AppStyle.interSemi(
                              size: 14,
                              color: colors.textBlack,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    " ${state.productData?.unit?.translation?.title ?? ""}",
                                style: AppStyle.interSemi(
                                  size: 14,
                                  color: AppStyle.textGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            event.addCount(context);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 8.h,
                              horizontal: 10.w,
                            ),
                            child: Icon(Icons.add, color: colors.textBlack),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 120.w,
                    child: CustomButton(
                      isLoading: state.isAddLoading || state.isLoading,
                      title: AppHelpers.getTranslation(TrKeys.add),
                      onPressed: () {
                        if (LocalStorage.getToken().isNotEmpty) {
                          event.createCart(
                            context,
                            stateOrderShop.cart?.shopId ??
                                (state.productData!.shopId ?? 0),
                            () {
                              Navigator.pop(context);
                              eventOrderShop.getCart(
                                context,
                                () {},
                                shopId: shopId,
                                userUuid: userUuid,
                                cartId: cartId,
                              );
                            },
                            isGroupOrder: userUuid?.isNotEmpty ?? false,
                            cartId: cartId,
                            userUuid: userUuid,
                          );
                        } else {
                          context.pushRoute(const LoginRoute());
                        }
                      },
                    ),
                  ),
                ],
              ),
              16.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppHelpers.getTranslation(TrKeys.total),
                    style: AppStyle.interNormal(
                      size: 14,
                      color: colors.textBlack,
                    ),
                  ),
                  Text(
                    AppHelpers.numberFormat(sumTotalPrice),
                    style: AppStyle.interNoSemi(
                      size: 20,
                      color: colors.textBlack,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
