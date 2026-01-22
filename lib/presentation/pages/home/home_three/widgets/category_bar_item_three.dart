import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/presentation/theme/color_set.dart';
import 'package:foodyman/presentation/theme/theme.dart';
import 'package:foodyman/presentation/components/components.dart';

class CategoryBarItemThree extends StatelessWidget {
  final String image;
  final String title;
  final VoidCallback onTap;
  final bool isActive;
  final CustomColorSet colors;

  const CategoryBarItemThree({
    super.key,
    required this.image,
    required this.title,
    this.isActive = false,
    required this.onTap,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 8.r),
      height: 40.h,
      padding: REdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: isActive ? colors.primary : colors.icon,
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomNetworkImage(
              url: image,
              height: 32.r,
              width: 32.r,
              radius: 0,
              fit: BoxFit.cover,
            ),
            6.horizontalSpace,
            Text(
              title,
              style: AppStyle.interNormal(size: 12, color: colors.textBlack),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
