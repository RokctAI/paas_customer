import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/infrastructure/services/services.dart';
import 'package:foodyman/presentation/components/components.dart';
import 'package:foodyman/presentation/theme/theme_wrapper.dart';
import 'package:foodyman/infrastructure/models/data/user.dart';
import 'package:foodyman/app_constants.dart';
import 'package:foodyman/presentation/pages/auth/confirmation/register_confirmation_page.dart';
import 'package:foodyman/presentation/theme/theme.dart';
import 'package:foodyman/application/auth/auth.dart';

@RoutePage()
class ResetPasswordPage extends ConsumerStatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage>
    with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  late TabController _tabController;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(resetPasswordProvider.notifier);
    final state = ref.watch(resetPasswordProvider);
    final bool isDarkMode = LocalStorage.getAppThemeMode();
    final bool isLtr = LocalStorage.getLangLtr();
    ref.listen(resetPasswordProvider, (previous, next) {
      if (previous!.isSuccess != next.isSuccess && next.isSuccess) {
        Navigator.pop(context);
        AppHelpers.showCustomModalBottomSheet(
          context: context,
          modal: RegisterConfirmationPage(
            verificationId: next.verifyId,
            userModel: UserModel(email: state.email),
            isResetPassword: true,
          ),
          isDarkMode: isDarkMode,
        );
      }
    });
    return Directionality(
      textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
      child: AbsorbPointer(
        absorbing: state.isLoading,
        child: ThemeWrapper(
          builder: (colors, theme) {
            return KeyboardDismisser(
              child: Container(
                padding: MediaQuery.of(context).viewInsets,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              AppBarBottomSheet(
                                title: AppHelpers.getTranslation(
                                  TrKeys.resetPassword,
                                ),
                              ),
                              Text(
                                AppHelpers.getTranslation(
                                  TrKeys.resetPasswordText,
                                ),
                                style: AppStyle.interRegular(
                                  size: 14,
                                  color: colors.textBlack,
                                ),
                              ),
                              24.verticalSpace,
                              if (AppHelpers.getAuthOption() == SignUpType.both)
                                AuthTabBar(
                                  tabController: _tabController,
                                  colors: colors,
                                ),
                              SizedBox(
                                height: 76.r,
                                child:
                                    AppHelpers.getAuthOption() ==
                                        SignUpType.both
                                    ? TabBarView(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        controller: _tabController,
                                        children: [
                                          // Phone tab
                                          Directionality(
                                            textDirection: isLtr
                                                ? TextDirection.ltr
                                                : TextDirection.rtl,
                                            child: PhoneTextField(
                                              onChanged: (phoneNum) {
                                                notifier.setEmail(phoneNum);
                                              },
                                            ),
                                          ),
                                          // Email tab
                                          OutlinedBorderTextField(
                                            textCapitalization:
                                                TextCapitalization.none,
                                            label: AppHelpers.getTranslation(
                                              TrKeys.email,
                                            ).toUpperCase(),
                                            onChanged: notifier.setEmail,
                                            isError: state.isEmailError,
                                            validation: (s) {
                                              if (s?.isEmpty ?? true) {
                                                return AppHelpers.getTranslation(
                                                  TrKeys.emailIsNotValid,
                                                );
                                              }
                                              return null;
                                            },
                                            descriptionText: state.isEmailError
                                                ? AppHelpers.getTranslation(
                                                    TrKeys.emailIsNotValid,
                                                  )
                                                : null,
                                          ),
                                        ],
                                      )
                                    : AppHelpers.getAuthOption() ==
                                          SignUpType.phone
                                    ? Directionality(
                                        textDirection: isLtr
                                            ? TextDirection.ltr
                                            : TextDirection.rtl,
                                        child: PhoneTextField(
                                          onChanged: (phoneNum) {
                                            notifier.setEmail(phoneNum);
                                          },
                                        ),
                                      )
                                    : OutlinedBorderTextField(
                                        textCapitalization:
                                            TextCapitalization.none,
                                        label: AppHelpers.getTranslation(
                                          TrKeys.email,
                                        ).toUpperCase(),
                                        onChanged: notifier.setEmail,
                                        isError: state.isEmailError,
                                        validation: (s) {
                                          if (s?.isEmpty ?? true) {
                                            return AppHelpers.getTranslation(
                                              TrKeys.emailIsNotValid,
                                            );
                                          }
                                          return null;
                                        },
                                        descriptionText: state.isEmailError
                                            ? AppHelpers.getTranslation(
                                                TrKeys.emailIsNotValid,
                                              )
                                            : null,
                                      ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.paddingOf(context).bottom,
                            top: 120.h,
                          ),
                          child: CustomButton(
                            isLoading: state.isLoading,
                            title: AppHelpers.getTranslation(TrKeys.send),
                            onPressed: () {
                              if (!(formKey.currentState?.validate() ??
                                  false)) {
                                return;
                              }
                              if (AppConstants.isPhoneFirebase) {
                                notifier.checkEmail()
                                    ? notifier.sendCode(context)
                                    : notifier.sendCodeToNumber(context);
                              } else {
                                notifier.sendCode(context);
                              }
                            },
                            background: colors.primary,
                            textColor: AppStyle.black,
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
    );
  }
}
