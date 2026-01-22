import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/infrastructure/services/services.dart';
import 'package:foodyman/presentation/components/components.dart';
import 'package:foodyman/presentation/pages/auth/reset/reset_password_page.dart';
import 'package:foodyman/app_constants.dart';
import 'package:foodyman/presentation/theme/app_style.dart';
import 'package:foodyman/application/auth/auth.dart';
import 'package:foodyman/presentation/theme/color_set.dart';

class LoginScreen extends ConsumerStatefulWidget {
  final CustomColorSet colors;

  const LoginScreen({super.key, required this.colors});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  late TabController _tabController;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: AppHelpers.getAuthOption() == SignUpType.email ? 1 : 0,
      length: 2,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final event = ref.read(loginProvider.notifier);
    final state = ref.watch(loginProvider);
    final bool isDarkMode = LocalStorage.getAppThemeMode();
    final bool isLtr = LocalStorage.getLangLtr();
    final colors = widget.colors;
    return Directionality(
      textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
      child: KeyboardDismisser(
        child: Container(
          margin: MediaQuery.viewInsetsOf(context),
          decoration: BoxDecoration(
            color: colors.backgroundColor.withValues(alpha: 0.96),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
          ),
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                    key: key,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppBarBottomSheet(
                          title: AppHelpers.getTranslation(TrKeys.login),
                        ),
                        16.verticalSpace,
                        if (AppHelpers.getAuthOption() == SignUpType.both)
                          AuthTabBar(
                            tabController: _tabController,
                            colors: colors,
                          ),
                        SizedBox(
                          height: 76.r,
                          child: TabBarView(
                            physics: NeverScrollableScrollPhysics(),
                            controller: _tabController,
                            children: [
                              Directionality(
                                textDirection: isLtr
                                    ? TextDirection.ltr
                                    : TextDirection.rtl,
                                child: PhoneTextField(
                                  onChanged: (phoneNum) {
                                    event.setPhone(phoneNum);
                                  },
                                ),
                              ),
                              // Email tab
                              OutlinedBorderTextField(
                                textCapitalization: TextCapitalization.none,
                                label: AppHelpers.getTranslation(
                                  TrKeys.email,
                                ).toUpperCase(),
                                textController: emailController,
                                onChanged: event.setEmail,
                                isError: state.isEmailNotValid,
                                validation: (s) {
                                  if (s?.isEmpty ?? true) {
                                    return AppHelpers.getTranslation(
                                      TrKeys.emailIsNotValid,
                                    );
                                  }
                                  return null;
                                },
                                descriptionText: state.isEmailNotValid
                                    ? AppHelpers.getTranslation(
                                        TrKeys.emailIsNotValid,
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ),
                        OutlinedBorderTextField(
                          label: AppHelpers.getTranslation(
                            TrKeys.password,
                          ).toUpperCase(),
                          textController: passwordController,
                          obscure: state.showPassword,
                          suffixIcon: IconButton(
                            splashRadius: 25,
                            icon: Icon(
                              state.showPassword
                                  ? FlutterRemix.eye_line
                                  : FlutterRemix.eye_close_line,
                              color: isDarkMode
                                  ? colors.textBlack
                                  : colors.textHint,
                              size: 20.r,
                            ),
                            onPressed: () =>
                                event.setShowPassword(!state.showPassword),
                          ),
                          onChanged: event.setPassword,
                          isError: state.isPasswordNotValid,
                          descriptionText: state.isPasswordNotValid
                              ? AppHelpers.getTranslation(
                                  TrKeys
                                      .passwordShouldContainMinimum8Characters,
                                )
                              : null,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ForgotTextButton(
                              title: AppHelpers.getTranslation(
                                TrKeys.forgotPassword,
                              ),
                              fontColor: colors.textBlack,
                              onPressed: () {
                                Navigator.pop(context);
                                AppHelpers.showCustomModalBottomSheet(
                                  context: context,
                                  modal: const ResetPasswordPage(),
                                  isDarkMode: isDarkMode,
                                );
                              },
                            ),
                          ],
                        ),
                        8.verticalSpace,
                        KeepLoggedCheckbox(
                          value: state.isAgreedToTerms,
                          onChanged: (value) {
                            event.setAgreedToTerms(value);
                          },
                          colors: colors,
                        ),
                      ],
                    ),
                  ),
                  16.verticalSpace,
                  Column(
                    children: [
                      CustomButton(
                        isLoading: state.isLoading,
                        background: state.isAgreedToTerms
                            ? colors.primary
                            : colors.newBoxColor,
                        textColor: state.isAgreedToTerms
                            ? colors.buttonFontColor
                            : colors.textHint,
                        title: AppHelpers.getTranslation(TrKeys.login),
                        onPressed: () {
                          if (key.currentState?.validate() ?? false) {
                            event.login(context);
                          }
                        },
                      ),
                      24.verticalSpace,
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Divider(
                              color: colors.textBlack.withValues(alpha: 0.5),
                            ),
                          ),
                          Padding(
                            padding: REdgeInsets.only(right: 12, left: 12),
                            child: Text(
                              AppHelpers.getTranslation(TrKeys.orAccessQuickly),
                              style: AppStyle.interNormal(
                                size: 12,
                                color: colors.textHint,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: colors.textBlack.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                      22.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ...AppHelpers.getSocialAuth().map(
                            (e) => SocialButton(
                              colors: colors,
                              iconData: e,
                              onPressed: () {
                                event.loginWithSocial(context, e);
                              },
                            ),
                          ),
                        ],
                      ),
                      22.verticalSpace,
                      if (AppConstants.isDemo)
                        Column(
                          children: [
                            InkWell(
                              onTap: () {
                                emailController.text =
                                    AppConstants.demoUserLogin;
                                passwordController.text =
                                    AppConstants.demoUserPassword;
                                event.setEmail(AppConstants.demoUserLogin);
                                event.setPassword(
                                  AppConstants.demoUserPassword,
                                );
                                _tabController.animateTo(1);
                              },
                              child: Row(
                                children: [
                                  const Spacer(),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text:
                                              '${AppHelpers.getTranslation(TrKeys.login)}:',
                                          style: AppStyle.interNormal(
                                            letterSpacing: -0.3,
                                            color: colors.textBlack,
                                          ),
                                          children: [
                                            TextSpan(
                                              text:
                                                  ' ${AppConstants.demoUserLogin}',
                                              style: AppStyle.interRegular(
                                                letterSpacing: -0.3,
                                                color: colors.textBlack,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      6.verticalSpace,
                                      RichText(
                                        text: TextSpan(
                                          text:
                                              '${AppHelpers.getTranslation(TrKeys.password)}:',
                                          style: AppStyle.interNormal(
                                            letterSpacing: -0.3,
                                            color: colors.textBlack,
                                          ),
                                          children: [
                                            TextSpan(
                                              text:
                                                  ' ${AppConstants.demoUserPassword}',
                                              style: AppStyle.interRegular(
                                                letterSpacing: -0.3,
                                                color: colors.textBlack,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      22.verticalSpace,
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
