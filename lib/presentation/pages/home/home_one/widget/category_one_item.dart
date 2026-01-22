import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/presentation/theme/app_style.dart';
import 'package:foodyman/presentation/theme/color_set.dart';
import 'package:foodyman/presentation/components/components.dart';

class CategoryOneItem extends StatelessWidget {
  final String image;
  final String title;
  final int index;
  final VoidCallback onTap;
  final bool isActive;
  final CustomColorSet colors;

  const CategoryOneItem({
    super.key,
    required this.image,
    required this.title,
    required this.index,
    this.isActive = false,
    required this.onTap,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: index == 1 ? 4.r : 0, right: 8.r),
          width: 72.r,
          height: 72.r,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: isActive ? colors.primary : colors.icon,
          ),
          child: InkWell(
            onTap: onTap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomNetworkImage(
                  fit: BoxFit.contain,
                  url: image,
                  height: 48.r,
                  width: 48.r,
                  radius: 0,
                ),
              ],
            ),
          ),
        ),
        6.verticalSpace,
        SizedBox(
          width: 64.w,
          child: Text(
            title,
            style: AppStyle.interNormal(size: 12, color: colors.textBlack),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
