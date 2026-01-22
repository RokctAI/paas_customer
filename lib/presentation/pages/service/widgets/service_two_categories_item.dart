import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/infrastructure/models/models.dart';
import 'package:foodyman/presentation/theme/app_style.dart';
import 'package:foodyman/presentation/theme/color_set.dart';

import 'package:foodyman/presentation/components/components.dart';

class ServiceTwoCategoriesItem extends StatelessWidget {
  final CategoryData category;
  final VoidCallback onTap;
  final CustomColorSet colors;

  const ServiceTwoCategoriesItem({
    super.key,
    required this.category,
    required this.onTap,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationButtonEffect(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: REdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: colors.icon,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomNetworkImage(
                    url: category.img ?? "",
                    height: 80.h,
                    width: 80.w,
                    radius: 12.r,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
              Text(
                category.translation?.title ?? "",
                style: AppStyle.interNormal(size: 14, color: colors.textBlack),
                maxLines: 1,
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
