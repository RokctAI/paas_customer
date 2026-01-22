import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/presentation/theme/color_set.dart';
import 'package:foodyman/presentation/theme/theme.dart';

class OrderContainer extends StatelessWidget {
  final Widget icon;
  final String title;
  final String description;
  final VoidCallback onTap;
  final CustomColorSet colors;

  const OrderContainer({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colors.icon,
          borderRadius: BorderRadius.circular(10.r),
        ),
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        child: Row(
          spacing: 14.r,
          children: [
            icon,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppStyle.interNormal(
                      size: 12,
                      color: colors.textBlack,
                    ),
                  ),
                  Text(
                    description,
                    style: AppStyle.interSemi(
                      size: 13,
                      color: colors.textBlack,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.keyboard_arrow_right,
              size: 21.r,
              color: colors.textBlack,
            ),
          ],
        ),
      ),
    );
  }
}
