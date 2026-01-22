import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/infrastructure/services/services.dart';
import 'package:foodyman/presentation/components/components.dart';
import 'package:foodyman/presentation/theme/theme_wrapper.dart';
import 'package:foodyman/infrastructure/models/data/user.dart';
import 'package:foodyman/app_constants.dart';
import 'package:foodyman/presentation/theme/theme.dart';
import 'package:foodyman/application/auth/auth.dart';
import '../confirmation/register_confirmation_page.dart';

@RoutePage()
class RegisterPage extends ConsumerStatefulWidget {
  final bool isOnlyEmail;

  const RegisterPage({super.key, required this.isOnlyEmail});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage>
    with SingleTickerProviderStateMixin {
  final phoneNumKey = GlobalKey<FormState>();
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
    final event = ref.read(registerProvider.notifier);
    final state = ref.watch(registerProvider);
    final bool isDarkMode = LocalStorage.getAppThemeMode();
    final bool isLtr = LocalStorage.getLangLtr();
    return Directionality(
      textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
      child: KeyboardDismisser(
        child: ThemeWrapper(
          builder: (colors, theme) {
            return Container(
              margin: MediaQuery.of(context).viewInsets,
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
                              title: AppHelpers.getTranslation(TrKeys.register),
                            ),
                            16.verticalSpace,
                            if (widget.isOnlyEmail &&
                                AppHelpers.getAuthOption() == SignUpType.both)
                              AuthTabBar(
                                tabController: _tabController,
                                colors: colors,
                              ),
                            if (widget.isOnlyEmail)
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
                                          Directionality(
                                            textDirection: isLtr
                                                ? TextDirection.ltr
                                                : TextDirection.rtl,
                                            child: PhoneTextField(
                                              onChanged: (phoneNum) {
                                                event.setEmail(phoneNum);
                                              },
                                            ),
                                          ),
                                          OutlinedBorderTextField(
                                            textCapitalization:
                                                TextCapitalization.none,
                                            label: AppHelpers.getTranslation(
                                              TrKeys.email,
                                            ).toUpperCase(),
                                            onChanged: event.setEmail,
                                            isError: state.isEmailInvalid,
                                            validation: (s) {
                                              if (s?.isEmpty ?? true) {
                                                return AppHelpers.getTranslation(
                                                  TrKeys.emailIsNotValid,
                                                );
                                              }
                                              return null;
                                            },
                                            descriptionText:
                                                state.isEmailInvalid
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
                                            event.setEmail(phoneNum);
                                          },
                                        ),
                                      )
                                    : OutlinedBorderTextField(
                                        textCapitalization:
                                            TextCapitalization.none,
                                        label: AppHelpers.getTranslation(
                                          TrKeys.email,
                                        ).toUpperCase(),
                                        onChanged: event.setEmail,
                                        isError: state.isEmailInvalid,
                                        validation: (s) {
                                          if (s?.isEmpty ?? true) {
                                            return AppHelpers.getTranslation(
                                              TrKeys.emailIsNotValid,
                                            );
                                          }
                                          return null;
                                        },
                                        descriptionText: state.isEmailInvalid
                                            ? AppHelpers.getTranslation(
                                                TrKeys.emailIsNotValid,
                                              )
                                            : null,
                                      ),
                              ),
                            if (!widget.isOnlyEmail)
                              Column(
                                children: [
                                  (state.verificationId.isEmpty)
                                      ? 30.verticalSpace
                                      : 0.verticalSpace,
                                  (state.verificationId.isEmpty)
                                      ? OutlinedBorderTextField(
                                          label: AppHelpers.getTranslation(
                                            TrKeys.phoneNumber,
                                          ).toUpperCase(),
                                          onChanged: event.setPhone,
                                        )
                                      : const SizedBox.shrink(),
                                  30.verticalSpace,
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width:
                                            (MediaQuery.sizeOf(context).width -
                                                40) /
                                            2,
                                        child: OutlinedBorderTextField(
                                          label: AppHelpers.getTranslation(
                                            TrKeys.firstname,
                                          ).toUpperCase(),
                                          onChanged: (name) =>
                                              event.setFirstName(name),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            (MediaQuery.sizeOf(context).width -
                                                40) /
                                            2,
                                        child: OutlinedBorderTextField(
                                          label: AppHelpers.getTranslation(
                                            TrKeys.surname,
                                          ).toUpperCase(),
                                          onChanged: (name) =>
                                              event.setLatName(name),
                                        ),
                                      ),
                                    ],
                                  ),
                                  30.verticalSpace,
                                  OutlinedBorderTextField(
                                    label: AppHelpers.getTranslation(
                                      TrKeys.password,
                                    ).toUpperCase(),
                                    obscure: state.showPassword,
                                    suffixIcon: IconButton(
                                      splashRadius: 25,
                                      icon: Icon(
                                        state.showPassword
                                            ? FlutterRemix.eye_line
                                            : FlutterRemix.eye_close_line,
                                        color: isDarkMode
                                            ? AppStyle.black
                                            : AppStyle.hintColor,
                                        size: 20.r,
                                      ),
                                      onPressed: () =>
                                          event.toggleShowPassword(),
                                    ),
                                    onChanged: (name) =>
                                        event.setPassword(name),
                                    isError: state.isPasswordInvalid,
                                    descriptionText: state.isPasswordInvalid
                                        ? AppHelpers.getTranslation(
                                            TrKeys
                                                .passwordShouldContainMinimum8Characters,
                                          )
                                        : null,
                                  ),
                                  34.verticalSpace,
                                  OutlinedBorderTextField(
                                    label: AppHelpers.getTranslation(
                                      TrKeys.password,
                                    ).toUpperCase(),
                                    obscure: state.showConfirmPassword,
                                    suffixIcon: IconButton(
                                      splashRadius: 25,
                                      icon: Icon(
                                        state.showConfirmPassword
                                            ? FlutterRemix.eye_line
                                            : FlutterRemix.eye_close_line,
                                        color: isDarkMode
                                            ? AppStyle.black
                                            : AppStyle.hintColor,
                                        size: 20.r,
                                      ),
                                      onPressed: () =>
                                          event.toggleShowConfirmPassword(),
                                    ),
                                    onChanged: (name) =>
                                        event.setConfirmPassword(name),
                                    isError: state.isConfirmPasswordInvalid,
                                    descriptionText:
                                        state.isConfirmPasswordInvalid
                                        ? AppHelpers.getTranslation(
                                            TrKeys.confirmPasswordIsNotTheSame,
                                          )
                                        : null,
                                  ),
                                  30.verticalSpace,
                                  OutlinedBorderTextField(
                                    label: AppHelpers.getTranslation(
                                      TrKeys.referral,
                                    ).toUpperCase(),
                                    onChanged: event.setReferral,
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 30.h),
                        child: CustomButton(
                          isLoading: state.isLoading,
                          title: AppHelpers.getTranslation(TrKeys.register),
                          onPressed: () {
                            if (widget.isOnlyEmail) {
                              if (!(formKey.currentState?.validate() ??
                                  false)) {
                                return;
                              }
                              if (event.checkEmail()) {
                                event.sendCode(context, () {
                                  Navigator.pop(context);
                                  AppHelpers.showCustomModalBottomSheet(
                                    context: context,
                                    modal: RegisterConfirmationPage(
                                      verificationId: "",
                                      userModel: UserModel(
                                        firstname: state.firstName,
                                        lastname: state.lastName,
                                        phone: state.phone,
                                        email: state.email,
                                        password: state.password,
                                        confirmPassword: state.confirmPassword,
                                      ),
                                    ),
                                    isDarkMode: isDarkMode,
                                  );
                                });
                              } else {
                                if (AppConstants.signUpType ==
                                    SignUpType.phone) {
                                  if (!(phoneNumKey.currentState?.validate() ??
                                      false)) {
                                    return;
                                  }
                                }
                                event.sendCodeToNumber(context, (s) {
                                  Navigator.pop(context);
                                  AppHelpers.showCustomModalBottomSheet(
                                    context: context,
                                    modal: RegisterConfirmationPage(
                                      verificationId: s,
                                      userModel: UserModel(
                                        firstname: state.firstName,
                                        lastname: state.lastName,
                                        phone: state.phone,
                                        email: state.email,
                                        password: state.password,
                                        confirmPassword: state.confirmPassword,
                                      ),
                                    ),
                                    isDarkMode: isDarkMode,
                                  );
                                });
                              }
                            } else {
                              if (state.verificationId.isEmpty) {
                                event.register(context);
                              } else {
                                if (AppConstants.isPhoneFirebase) {
                                  event.registerWithFirebase(context);
                                } else {
                                  event.registerWithPhone(context);
                                }
                              }
                            }
                          },
                        ),
                      ),
                      widget.isOnlyEmail
                          ? Column(
                              children: [
                                32.verticalSpace,
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Divider(
                                        color: AppStyle.black.withValues(
                                          alpha: 0.5,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        right: 12,
                                        left: 12,
                                      ),
                                      child: Text(
                                        AppHelpers.getTranslation(
                                          TrKeys.orAccessQuickly,
                                        ),
                                        style: AppStyle.interNormal(
                                          size: 12,
                                          color: AppStyle.textGrey,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(
                                        color: AppStyle.black.withValues(
                                          alpha: 0.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                22.verticalSpace,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
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
                              ],
                            )
                          : SizedBox(height: 32.h),
                    ],
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
