import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/presentation/theme/theme_wrapper.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:foodyman/infrastructure/services/services.dart';
import 'package:foodyman/app_constants.dart';
import 'package:foodyman/presentation/theme/theme.dart';

class PhoneTextField extends StatelessWidget {
  final Function(dynamic)? onChanged;
  final String? Function(dynamic)? validator;
  final String? initialValue;
  final String? label;
  final bool isError;
  final String? descriptionText;
  final bool isLtr;
  final TextEditingController? controller;
  final VoidCallback? onTap;
  final bool readOnly;

  const PhoneTextField({
    super.key,
    this.onChanged,
    this.validator,
    this.initialValue,
    this.label,
    this.isError = false,
    this.descriptionText,
    this.isLtr = true,
    this.controller,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return ThemeWrapper(
      builder: (colors, con) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (label != null)
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label!,
                    style: AppStyle.interNormal(
                      size: 9,
                      color: colors.textBlack,
                    ),
                  ),
                  8.verticalSpace,
                ],
              ),
            Directionality(
              textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
              child: IntlPhoneField(
                controller: controller,
                onChanged: onChanged,
                onTap: onTap,
                readOnly: readOnly,
                disableLengthCheck: !AppConstants.isNumberLengthAlwaysSame,
                validator: validator,
                keyboardType: TextInputType.phone,
                style: AppStyle.interNormal(color: colors.textBlack, size: 14),
                dropdownTextStyle: AppStyle.interNormal(
                  color: colors.textBlack,
                  size: 14,
                ),
                dropdownIcon: Icon(
                  Icons.arrow_drop_down,
                  color: colors.textBlack,
                  size: 20.r,
                ),
                initialCountryCode: AppConstants.countryCodeISO,
                initialValue: initialValue,
                invalidNumberMessage: AppHelpers.getTranslation(
                  TrKeys.phoneNumberIsNotValid,
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                showCountryFlag: AppConstants.showFlag,
                showDropdownIcon: AppConstants.showArrowIcon,
                autovalidateMode: AppConstants.isNumberLengthAlwaysSame
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  counterText: '',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide.merge(
                      const BorderSide(color: AppStyle.differBorderColor),
                      const BorderSide(color: AppStyle.differBorderColor),
                    ),
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide.merge(
                      const BorderSide(color: AppStyle.differBorderColor),
                      const BorderSide(color: AppStyle.differBorderColor),
                    ),
                  ),
                  border: const UnderlineInputBorder(),
                  focusedErrorBorder: const UnderlineInputBorder(),
                  disabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide.merge(
                      const BorderSide(color: AppStyle.differBorderColor),
                      const BorderSide(color: AppStyle.differBorderColor),
                    ),
                  ),
                  focusedBorder: const UnderlineInputBorder(),
                ),
              ),
            ),
            if (descriptionText != null)
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  4.verticalSpace,
                  Text(
                    descriptionText!,
                    style: AppStyle.interRegular(
                      letterSpacing: -0.3,
                      size: 12,
                      color: isError ? AppStyle.red : AppStyle.black,
                    ),
                  ),
                ],
              ),
          ],
        );
      },
    );
  }
}
