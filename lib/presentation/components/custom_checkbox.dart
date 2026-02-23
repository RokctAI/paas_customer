import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/presentation/theme/app_style.dart';
import 'package:foodyman/presentation/theme/color_set.dart';

class CustomCheckbox extends StatelessWidget {
  final bool? isActive;
  final VoidCallback onTap;
  final CustomColorSet colors;

  const CustomCheckbox({
    super.key,
    required this.isActive,
    required this.onTap,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        width: 24.r,
        height: 24.r,
        decoration: BoxDecoration(
          color: (isActive ?? false)
              ? colors.primary
              : AppStyle.outlineButtonBorder,
          borderRadius: BorderRadius.circular(8.r),
        ),
        duration: const Duration(milliseconds: 500),
        child: (isActive ?? false)
            ? Icon(FlutterRemix.check_fill, color: AppStyle.black, size: 18.r)
            : const SizedBox.shrink(),
      ),
    );
  }
}
