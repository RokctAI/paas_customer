import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/infrastructure/models/data/addons_data.dart';
import 'package:foodyman/infrastructure/services/services.dart';
import 'package:foodyman/presentation/theme/theme.dart';

import 'package:foodyman/presentation/theme/theme_wrapper.dart';

import 'package:foodyman/presentation/components/components.dart';

class IngredientItem extends ConsumerWidget {
  final VoidCallback onTap;
  final VoidCallback add;
  final VoidCallback remove;
  final Addons addon;

  const IngredientItem({
    required this.add,
    required this.remove,
    super.key,
    required this.onTap,
    required this.addon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ThemeWrapper(
      builder: (colors, theme) {
        return GestureDetector(
          onTap: () {
            onTap();
            Vibrate.feedback(FeedbackType.selection);
          },
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 10.r),
            decoration: BoxDecoration(
              color: colors.textWhite,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomCheckbox(
                      colors: colors,
                      isActive: addon.active,
                      onTap: onTap,
                    ),
                    10.horizontalSpace,
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              addon.product?.translation?.title ?? "",
                              style: AppStyle.interNormal(
                                size: 16,
                                color: colors.textBlack,
                              ),
                            ),
                          ),
                          4.horizontalSpace,
                          Text(
                            "+${AppHelpers.numberFormat(addon.product?.stock?.totalPrice)}",
                            style: AppStyle.interNoSemi(
                              size: 14,
                              color: AppStyle.textGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    (addon.active ?? false)
                        ? Row(
                            children: [
                              IconButton(
                                onPressed: remove,
                                icon: Icon(
                                  Icons.remove,
                                  color: (addon.quantity ?? 1) == 1
                                      ? AppStyle.outlineButtonBorder
                                      : colors.textBlack,
                                ),
                              ),
                              Text(
                                "${addon.quantity ?? 1}",
                                style: AppStyle.interNormal(
                                  size: 16.sp,
                                  color: colors.textBlack,
                                ),
                              ),
                              IconButton(
                                onPressed: add,
                                icon: Icon(Icons.add, color: colors.textBlack),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
                Divider(color: AppStyle.textGrey.withValues(alpha: 0.2)),
              ],
            ),
          ),
        );
      },
    );
  }
}
