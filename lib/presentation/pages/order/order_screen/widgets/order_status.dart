import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodyman/infrastructure/services/services.dart';
import 'package:foodyman/presentation/app_assets.dart';
import 'package:foodyman/presentation/theme/theme.dart';

import 'package:foodyman/presentation/theme/color_set.dart';
import 'package:foodyman/presentation/theme/theme_wrapper.dart';
import 'order_status_item.dart';

class OrderStatusScreen extends StatelessWidget {
  final OrderStatus status;
  final bool parcel;
  final CustomColorSet colors;

  const OrderStatusScreen({
    super.key,
    required this.status,
    this.parcel = false,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return ThemeWrapper(
      builder: (colors, theme) {
        return Container(
          margin: EdgeInsets.only(top: 16.h),
          decoration: BoxDecoration(
            color: colors.backgroundColor,
            borderRadius: BorderRadius.circular(10.r),
          ),
          padding: EdgeInsets.all(14.r),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppHelpers.getTranslation(
                  AppHelpers.getOrderStatusText(status),
                ),
                style: AppStyle.interNormal(size: 13, color: colors.textBlack),
              ),
              _buildStatusRow(colors),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusRow(CustomColorSet colors) {
    if (status == OrderStatus.canceled) {
      return _buildCompletedStatusRow(AppStyle.red);
    } else if (status == OrderStatus.delivered) {
      return _buildCompletedStatusRow(colors.primary);
    } else {
      return _buildInProgressStatusRow();
    }
  }

  Widget _buildCompletedStatusRow(Color color) {
    return Row(
      children: [
        _buildStatusItem(
          icon: parcel ? FlutterRemix.survey_fill : Icons.done_all,
          bgColor: color,
          iconColor: colors.buttonFontColor,
          colors: colors,
        ),
        _buildConnector(color),
        _buildStatusItem(
          icon: parcel ? Icons.done_all : Icons.restaurant_rounded,
          bgColor: color,
          iconColor: colors.primary,
          colors: colors,
        ),
        _buildConnector(color),
        _buildStatusItem(
          icon: parcel
              ? Icon(FlutterRemix.truck_fill, color: colors.primary)
              : SvgPicture.asset(
                  Assets.svgsDelivery2,
                  width: 20.r,
                  colorFilter: ColorFilter.mode(
                    colors.buttonFontColor,
                    BlendMode.srcIn,
                  ),
                ),
          bgColor: color,
          colors: colors,
        ),
        _buildConnector(color),
        _buildStatusItem(
          icon: Icons.flag,
          bgColor: color,
          iconColor: colors.buttonFontColor,
          colors: colors,
        ),
      ],
    );
  }

  Widget _buildInProgressStatusRow() {
    final isOpen = status == OrderStatus.open;
    final isReadyOrOnWay =
        status == OrderStatus.ready || status == OrderStatus.onWay;
    final isAccepted = status == OrderStatus.accepted;
    final isOnWay = status == OrderStatus.onWay;
    final isReadyOrDelivered =
        status == OrderStatus.ready || status == OrderStatus.delivered;

    return Row(
      children: [
        _buildStatusItem(
          icon: parcel ? FlutterRemix.survey_fill : Icons.done_all,
          iconColor: colors.textBlack,
          isActive: !isOpen,
          isProgress: isOpen,
          colors: colors,
        ),
        _buildConnector(!isOpen ? colors.primary : colors.icon),
        _buildStatusItem(
          icon: parcel ? Icons.done_all : Icons.restaurant_rounded,
          iconColor: colors.textBlack,
          isActive: isReadyOrOnWay,
          isProgress: isAccepted,
          colors: colors,
        ),
        _buildConnector(
          isReadyOrOnWay ? colors.primary : colors.icon,
        ),
        _buildStatusItem(
          icon: parcel
              ? Icon(FlutterRemix.truck_fill, color: colors.textBlack)
              : SvgPicture.asset(
                  isOnWay ? Assets.svgsDelivery2 : Assets.svgsDelivery,
                  width: 20.w,
                  colorFilter: ColorFilter.mode(
                    colors.textBlack,
                    BlendMode.srcIn,
                  ),
                ),
          isActive: isOnWay,
          isProgress: isReadyOrDelivered,
          colors: colors,
        ),
        _buildConnector(colors.icon),
        _buildStatusItem(
          icon: Icon(Icons.flag, size: 16.r, color: colors.textBlack),
          isActive: false,
          isProgress: false,
          colors: colors,
        ),
      ],
    );
  }

  Widget _buildStatusItem({
    required dynamic icon,
    Color? bgColor,
    Color? iconColor,
    bool? isActive,
    bool? isProgress,
    required CustomColorSet colors,
  }) {
    Widget iconWidget;
    if (icon is IconData) {
      iconWidget = Icon(
        icon,
        size: 16.r,
        color: (isActive ?? false) ? colors.buttonFontColor : iconColor,
      );
    } else {
      iconWidget = icon as Widget;
    }

    return OrderStatusItem(
      icon: iconWidget,
      bgColor: bgColor,
      isActive: isActive ?? true,
      isProgress: isProgress ?? false,
      colors: colors,
    );
  }

  Widget _buildConnector(Color color) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: 6.h,
      width: 12.w,
      decoration: BoxDecoration(color: color),
    );
  }
}
