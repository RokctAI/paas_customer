import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodyman/presentation/app_assets.dart';
import 'package:foodyman/presentation/theme/color_set.dart';

class OrderStatusItem extends StatelessWidget {
  final Widget icon;
  final bool isActive;
  final bool isProgress;
  final Color? bgColor;
  final CustomColorSet colors;

  const OrderStatusItem({
    super.key,
    required this.icon,
    required this.isActive,
    required this.isProgress,
    this.bgColor,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: isActive ? bgColor ?? colors.primary : colors.icon,
        shape: BoxShape.circle,
      ),
      child: Stack(
        children: [
          Positioned(top: 8.r, left: 10.r, child: icon),
          isProgress
              ? SvgPicture.asset(
                  Assets.svgsOrderTime,
                  colorFilter: ColorFilter.mode(
                    colors.primary,
                    BlendMode.srcIn,
                  ),
                  width: 36.r,
                  height: 36.r,
                )
              : SizedBox(width: 36.r, height: 36.r),
        ],
      ),
    );
  }
}
