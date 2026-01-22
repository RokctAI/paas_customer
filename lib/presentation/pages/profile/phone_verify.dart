import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/presentation/theme/theme_wrapper.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:foodyman/infrastructure/models/data/user.dart';
import 'package:foodyman/infrastructure/services/services.dart';
import 'package:foodyman/presentation/pages/auth/confirmation/register_confirmation_page.dart';
import 'package:foodyman/presentation/theme/app_style.dart';
import 'package:foodyman/app_constants.dart';
import 'package:foodyman/application/auth/auth.dart';

import 'package:foodyman/presentation/components/components.dart';

class PhoneVerify extends ConsumerWidget {
  const PhoneVerify({super.key});

  @override
  Widget build(BuildContext context, ref) {
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
                      Column(
                        children: [
                          AppBarBottomSheet(
                            title: AppHelpers.getTranslation(
                              TrKeys.phoneNumber,
                            ),
                          ),
                          Directionality(
                            textDirection: isLtr
                                ? TextDirection.ltr
                                : TextDirection.rtl,
                            child: IntlPhoneField(
                              style: TextStyle(color: colors.textBlack),
                              dropdownTextStyle: TextStyle(
                                color: colors.textBlack,
                              ),
                              onChanged: (phoneNum) {
                                event.setEmail(phoneNum.completeNumber);
                              },
                              disableLengthCheck:
                                  !AppConstants.isNumberLengthAlwaysSame,
                              validator: (s) {
                                if (AppConstants.isNumberLengthAlwaysSame &&
                                    (s?.isValidNumber() ?? true)) {
                                  return AppHelpers.getTranslation(
                                    TrKeys.phoneNumberIsNotValid,
                                  );
                                }
                                return null;
                              },
                              keyboardType: TextInputType.phone,
                              initialCountryCode: AppConstants.countryCodeISO,
                              invalidNumberMessage: AppHelpers.getTranslation(
                                TrKeys.phoneNumberIsNotValid,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              showCountryFlag: AppConstants.showFlag,
                              showDropdownIcon: AppConstants.showArrowIcon,
                              autovalidateMode:
                                  AppConstants.isNumberLengthAlwaysSame
                                  ? AutovalidateMode.onUserInteraction
                                  : AutovalidateMode.disabled,
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                counterText: '',
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.merge(
                                    const BorderSide(
                                      color: AppStyle.differBorderColor,
                                    ),
                                    const BorderSide(
                                      color: AppStyle.differBorderColor,
                                    ),
                                  ),
                                ),
                                errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.merge(
                                    const BorderSide(
                                      color: AppStyle.differBorderColor,
                                    ),
                                    const BorderSide(
                                      color: AppStyle.differBorderColor,
                                    ),
                                  ),
                                ),
                                border: const UnderlineInputBorder(),
                                focusedErrorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.merge(
                                    const BorderSide(
                                      color: AppStyle.differBorderColor,
                                    ),
                                    const BorderSide(
                                      color: AppStyle.differBorderColor,
                                    ),
                                  ),
                                ),
                                disabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.merge(
                                    const BorderSide(
                                      color: AppStyle.differBorderColor,
                                    ),
                                    const BorderSide(
                                      color: AppStyle.differBorderColor,
                                    ),
                                  ),
                                ),
                                focusedBorder: const UnderlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 30.h),
                        child: CustomButton(
                          background: !state.email.trim().isNotEmpty
                              ? AppStyle.textGrey
                              : colors.primary,
                          isLoading: state.isLoading,
                          title: AppHelpers.getTranslation(TrKeys.next),
                          onPressed: () {
                            if (state.email.trim().isNotEmpty) {
                              event.sendCodeToNumber(context, (s) {
                                Navigator.pop(context);
                                AppHelpers.showCustomModalBottomSheet(
                                  context: context,
                                  modal: RegisterConfirmationPage(
                                    verificationId: s,
                                    editPhone: true,
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
                          },
                        ),
                      ),
                      32.verticalSpace,
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
