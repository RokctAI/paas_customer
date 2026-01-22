import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/app_constants.dart';
import 'package:foodyman/application/main/main_provider.dart';
import 'package:foodyman/infrastructure/services/services.dart';
import 'package:foodyman/presentation/routes/app_router.dart';
import 'package:foodyman/presentation/theme/app_style.dart';
import 'package:foodyman/presentation/theme/theme_wrapper.dart';

import 'package:foodyman/presentation/components/components.dart';

@RoutePage()
class UiTypePage extends ConsumerStatefulWidget {
  final bool isBack;

  const UiTypePage({super.key, this.isBack = false});

  @override
  ConsumerState<UiTypePage> createState() => _UiTypePageState();
}

class _UiTypePageState extends ConsumerState<UiTypePage>
    with SingleTickerProviderStateMixin {
  int index = 0;
  late AnimationController _animationController;

  @override
  void initState() {
    index = AppHelpers.getType();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeWrapper(
      builder: (colors, theme) {
        return Scaffold(
          backgroundColor: colors.backgroundColor,
          appBar: AppBar(
            backgroundColor: colors.icon,
            elevation: 0,
            centerTitle: true,
            leading: widget.isBack ? BackButton(color: colors.textBlack) : null,
            title: Text(
              AppHelpers.getTranslation(TrKeys.uiType),
              style: AppStyle.interNoSemi(
                size: 18,
                color: colors.textBlack,
                letterSpacing: -0.3,
              ),
            ),
          ),
          body: Column(
            children: [
              16.verticalSpace,
              Padding(
                padding: REdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  AppHelpers.getTranslation(TrKeys.chooseYourPreferredStyle),
                  style: AppStyle.interNormal(
                    size: 14,
                    color: AppStyle.textGrey,
                  ),
                ),
              ),
              8.verticalSpace,
              Expanded(
                child: GridView.builder(
                  itemCount: 4,
                  padding: REdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 260.h,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemBuilder: (context, i) {
                    final isSelected = index == i;
                    return AnimatedScale(
                      scale: isSelected ? 0.98 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: GestureDetector(
                        onTap: () {
                          setState(() => index = i);
                          _animationController.forward(from: 0);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutCubic,
                          decoration: BoxDecoration(
                            color: AppStyle.white,
                            borderRadius: BorderRadius.circular(
                              AppConstants.radius.r,
                            ),
                            border: Border.all(
                              color: isSelected
                                  ? colors.primary
                                  : AppStyle.borderColor,
                              width: isSelected ? 3.r : 1.r,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isSelected
                                    ? colors.primary.withValues(alpha: 0.2)
                                    : AppStyle.shadow,
                                blurRadius: isSelected ? 20 : 12,
                                offset: Offset(0, isSelected ? 8 : 4),
                                spreadRadius: isSelected ? 2 : 0,
                              ),
                            ],
                          ),
                          padding: REdgeInsets.all(8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              (AppConstants.radius * 0.8).r,
                            ),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Image.asset(
                                    "assets/images/ui$i.png",
                                    fit: BoxFit.cover,
                                    alignment: Alignment.topCenter,
                                  ),
                                ),
                                // Gradient overlay
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          AppStyle.transparent,
                                          AppStyle.black.withValues(
                                            alpha: 0.15,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                // Selection overlay
                                if (isSelected)
                                  Positioned.fill(
                                    child: AnimatedOpacity(
                                      opacity: isSelected ? 1.0 : 0.0,
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              colors.primary.withValues(
                                                alpha: 0.15,
                                              ),
                                              colors.primary.withValues(
                                                alpha: 0.05,
                                              ),
                                            ],
                                          ),
                                        ),
                                        child: Center(
                                          child: ScaleTransition(
                                            scale: CurvedAnimation(
                                              parent: _animationController,
                                              curve: Curves.elasticOut,
                                            ),
                                            child: Container(
                                              padding: REdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: colors.primary,
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: colors.primary
                                                        .withValues(alpha: 0.4),
                                                    blurRadius: 12,
                                                    spreadRadius: 2,
                                                  ),
                                                ],
                                              ),
                                              child: Icon(
                                                Icons.check_rounded,
                                                color: colors.buttonFontColor,
                                                size: 26.r,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: colors.icon,
                  boxShadow: [
                    BoxShadow(
                      color: AppStyle.shadowBottom,
                      blurRadius: 12,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                padding: REdgeInsets.fromLTRB(20, 20, 20, 32),
                child: Column(
                  children: [
                    CustomButton(
                      title: AppHelpers.getTranslation(TrKeys.save),
                      radius: 12,
                      onPressed: () async {
                        await LocalStorage.setUiType(index);
                        if (context.mounted) {
                          ref.read(mainProvider.notifier).selectIndex(0);
                          if (LocalStorage.getAddressSelected() == null) {
                            context.replaceRoute(PermissionLocationRoute());
                          } else {
                            context.replaceRoute(MainRoute());
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
