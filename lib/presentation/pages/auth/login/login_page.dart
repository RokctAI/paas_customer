// ignore_for_file: use_build_context_synchronously
import 'package:auto_route/auto_route.dart';
import 'package:foodyman/infrastructure/app_links/app_links_service.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/application/language/language_provider.dart';
import 'package:foodyman/application/main/main_provider.dart';
import 'package:foodyman/infrastructure/services/services.dart';
import 'package:foodyman/presentation/app_assets.dart';
import 'package:foodyman/presentation/components/components.dart';
import 'package:foodyman/presentation/pages/auth/register/register_page.dart';
import 'package:foodyman/presentation/routes/app_router.dart';
import 'package:foodyman/presentation/theme/color_set.dart';
import 'package:foodyman/presentation/theme/theme.dart';
import 'package:foodyman/application/auth/auth.dart';
import 'package:foodyman/presentation/theme/theme_preference.dart';
import '../../../theme/theme_wrapper.dart';
import '../../profile/language_page.dart';
import 'login_screen.dart';

@RoutePage()
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(loginProvider.notifier).checkLanguage(context);
    });
    AppLinksService.init(context, isMain: false);
    super.initState();
  }

  void selectLanguage() {
    AppHelpers.showCustomModalBottomSheet(
      isDismissible: false,
      isDrag: false,
      context: context,
      modal: LanguageScreen(
        colors: CustomColorSet.createOrUpdate(CustomThemeMode.light),
        onSave: () {
          Navigator.pop(context);
        },
      ),
      isDarkMode: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(languageProvider);
    ref.listen(loginProvider, (previous, next) {
      if (!next.isSelectLanguage &&
          !((previous?.isSelectLanguage ?? false) == next.isSelectLanguage)) {
        selectLanguage();
      }
    });

    final bool isDarkMode = LocalStorage.getAppThemeMode();
    final bool isLtr = LocalStorage.getLangLtr();
    return Directionality(
      textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
      child: ThemeWrapper(
        builder: (colors, theme) {
          return CustomScaffold(
            body: (colors) => Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Assets.imagesSplash),
                  fit: BoxFit.fill,
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: REdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              AppHelpers.getAppName() ?? "",
                              style: AppStyle.interSemi(color: AppStyle.white),
                            ),
                          ),
                          8.horizontalSpace,
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              ref.read(mainProvider.notifier).selectIndex(0);
                              context.replaceRoute(MainRoute());
                            },
                            child: Text(
                              AppHelpers.getTranslation(TrKeys.skip),
                              style: AppStyle.interSemi(
                                size: 16,
                                color: AppStyle.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          CustomButton(
                            title: AppHelpers.getTranslation(TrKeys.login),
                            onPressed: () {
                              AppHelpers.showCustomModalBottomSheet(
                                context: context,
                                modal: LoginScreen(colors: colors),
                                isDarkMode: isDarkMode,
                              );
                            },
                          ),
                          10.verticalSpace,
                          CustomButton(
                            title: AppHelpers.getTranslation(TrKeys.register),
                            onPressed: () {
                              AppHelpers.showCustomModalBottomSheet(
                                context: context,
                                modal: RegisterPage(isOnlyEmail: true),
                                isDarkMode: isDarkMode,
                                paddingTop: MediaQuery.paddingOf(context).top,
                              );
                            },
                            background: AppStyle.transparent,
                            textColor: AppStyle.white,
                            borderColor: AppStyle.white,
                          ),
                          22.verticalSpace,
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
