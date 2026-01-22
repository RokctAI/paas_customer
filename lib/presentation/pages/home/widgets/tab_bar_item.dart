import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/presentation/theme/theme.dart';
import 'package:foodyman/presentation/theme/theme_wrapper.dart';
import 'package:foodyman/presentation/components/components.dart';

class CategoryBarItem extends StatelessWidget {
  final String image;
  final String title;
  final int index;
  final VoidCallback onTap;
  final bool isActive;

  const CategoryBarItem({
    super.key,
    required this.image,
    required this.title,
    required this.index,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ThemeWrapper(
      builder: (colors, theme) {
        return Container(
          width: 100.r,
          height: 100.r,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? colors.primary
                : colors.textHint.withValues(alpha: 0.1),
          ),
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomNetworkImage(
                  fit: BoxFit.contain,
                  url: image,
                  height: 48.r,
                  width: 48.r,
                  radius: 0,
                ),
                4.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.r),
                  child: Text(
                    title,
                    style: AppStyle.interNormal(
                      size: 12,
                      color: colors.textBlack,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
