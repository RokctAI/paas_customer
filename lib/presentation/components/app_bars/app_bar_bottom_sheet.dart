import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/presentation/theme/theme.dart';

import '../../theme/theme_wrapper.dart';

class AppBarBottomSheet extends StatelessWidget {
  final String title;

  const AppBarBottomSheet({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ThemeWrapper(
      builder: (colors, theme) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              padding: const EdgeInsets.only(
                top: 16,
                right: 32,
                bottom: 16,
                left: 0,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back, color: colors.textBlack),
            ),
            Text(
              title,
              style: AppStyle.interNoSemi(
                size: 20,
                color: colors.textBlack,
                letterSpacing: -0.01,
              ),
            ),
            Container(
              width: 24.w,
              height: 24.h,
              margin: const EdgeInsets.all(8),
            ),
          ],
        );
      },
    );
  }
}
