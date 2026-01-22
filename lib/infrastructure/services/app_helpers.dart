import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/infrastructure/services/extension.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:foodyman/infrastructure/models/models.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../presentation/theme/app_style.dart';
import 'package:foodyman/infrastructure/services/local_storage.dart';
import '../../app_constants.dart';
import 'enums.dart';

abstract class AppHelpers {
  AppHelpers._();

  static String numberFormat(num? number, {String? symbol, bool? isOrder}) {
    if (LocalStorage.getSelectedCurrency()?.position == "before") {
      return NumberFormat.currency(
        customPattern: '\u00a4#,###.#',
        symbol: (isOrder ?? false)
            ? symbol ?? LocalStorage.getSelectedCurrency()?.symbol
            : LocalStorage.getSelectedCurrency()?.symbol,
        decimalDigits: 2,
      ).format(number ?? 0);
    } else {
      return NumberFormat.currency(
        customPattern: '#,###.#\u00a4',
        symbol: (isOrder ?? false)
            ? symbol ?? LocalStorage.getSelectedCurrency()?.symbol
            : LocalStorage.getSelectedCurrency()?.symbol,
        decimalDigits: 2,
      ).format(number ?? 0);
    }
  }

  static SignUpType getAuthOption() {
    final List<SettingsData> settings = LocalStorage.getSettingsList();
    for (final setting in settings) {
      if (setting.key == 'auth_option') {
        switch (setting.value) {
          case 'phone':
            return SignUpType.phone;
          case 'email':
            return SignUpType.email;
          default:
            return SignUpType.both;
        }
      }
    }
    return SignUpType.both;
  }

  static List<IconData> getSocialAuth() {
    List<IconData> socials = [];
    final List<SettingsData> settings = LocalStorage.getSettingsList();

    bool enableGoogle = settings
        .map((e) => e.key)
        .toList()
        .contains('social_auth_google');
    bool enableApple = settings
        .map((e) => e.key)
        .toList()
        .contains('social_auth_apple');
    bool enableFacebook = settings
        .map((e) => e.key)
        .toList()
        .contains('social_auth_facebook');

    if (!enableGoogle && !enableApple && !enableFacebook) {
      return AppConstants.socialSignIn;
    } else {
      for (final setting in settings) {
        if (setting.key == 'social_auth_google' && setting.value != "0") {
          socials.add(FlutterRemix.google_fill);
        }
        if (Platform.isIOS &&
            setting.key == 'social_auth_apple' &&
            setting.value != "0") {
          socials.add(FlutterRemix.apple_fill);
        }
        if (setting.key == 'social_auth_facebook' && setting.value != "0") {
          socials.add(FlutterRemix.facebook_fill);
        }
      }
    }
    return socials;
  }

  static String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-.';
    final random = Random.secure();
    return List.generate(
      length,
      (i) => charset[random.nextInt(charset.length)],
    ).join();
  }

  static bool checkYesterday(String? startTime, String? endTime) {
    final now = DateTime.now().subtract(const Duration(days: 1));
    final format = DateFormat('HH:mm');

    DateTime start = format.parse(startTime.toSingleTime);
    DateTime end = format.parse(endTime.toSingleTime);

    start = DateTime(
      now.year,
      now.month,
      now.day,
      start.hour,
      start.minute,
      start.second,
    );
    end = DateTime(
      now.year,
      now.month,
      now.day,
      end.hour,
      end.minute,
      end.second,
    );
    return end.isBefore(start);
  }

  static void showNoConnectionSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    final snackBar = SnackBar(
      backgroundColor: AppStyle.primary,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
      content: Text(
        'No internet connection',
        style: AppStyle.interNoSemi(size: 14, color: AppStyle.white),
      ),
      action: SnackBarAction(
        label: 'Close',
        disabledTextColor: AppStyle.black,
        textColor: AppStyle.black,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static ExtrasType getExtraTypeByValue(String? value) {
    switch (value) {
      case 'color':
        return ExtrasType.color;
      case 'text':
        return ExtrasType.text;
      case 'image':
        return ExtrasType.image;
      default:
        return ExtrasType.text;
    }
  }

  static OrderStatus getOrderStatus(String? value) {
    switch (value) {
      case 'new':
        return OrderStatus.open;
      case 'accepted':
        return OrderStatus.accepted;
      case 'ready':
        return OrderStatus.ready;
      case 'on_a_way':
        return OrderStatus.onWay;
      case 'delivered':
        return OrderStatus.delivered;
      case 'canceled':
        return OrderStatus.canceled;
      default:
        return OrderStatus.accepted;
    }
  }

  static String? getOrderByString(String value) {
    switch (getTranslationReverse(value)) {
      case "new":
        return "new";
      case "trust_you":
        return "trust_you";
      case 'highly_rated':
        return "high_rating";
      case 'best_sale':
        return "best_sale";
      case 'low_sale':
        return "low_sale";
      case 'low_rating':
        return "low_rating";
    }
    return null;
  }

  static String getOrderStatusText(OrderStatus value) {
    switch (value) {
      case OrderStatus.open:
        return "new";
      case OrderStatus.accepted:
        return "accepted";
      case OrderStatus.ready:
        return "ready";
      case OrderStatus.onWay:
        return "on_a_way";
      case OrderStatus.delivered:
        return "delivered";
      case OrderStatus.canceled:
        return "canceled";
    }
  }

  static void showCheckTopSnackBar(BuildContext context, String text) {
    return showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.error(
        message: text.isEmpty
            ? "Please check your credentials and try again"
            : text,
      ),
      animationDuration: const Duration(milliseconds: 700),
      reverseAnimationDuration: const Duration(milliseconds: 700),
      displayDuration: const Duration(milliseconds: 700),
    );
  }

  static void showCheckTopSnackBarInfo(
    BuildContext context,
    String text, {
    VoidCallback? onTap,
  }) {
    return showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.info(message: text),
      animationDuration: const Duration(milliseconds: 700),
      reverseAnimationDuration: const Duration(milliseconds: 700),
      displayDuration: const Duration(milliseconds: 700),
      onTap: onTap,
    );
  }

  static void showCheckTopSnackBarDone(BuildContext context, String text) {
    return showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.success(message: text),
      animationDuration: const Duration(milliseconds: 700),
      reverseAnimationDuration: const Duration(milliseconds: 700),
      displayDuration: const Duration(milliseconds: 700),
    );
  }

  static void showCheckTopSnackBarInfoCustom(
    BuildContext context,
    String text, {
    VoidCallback? onTap,
  }) {
    return showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.info(
        message: text,
        icon: const SizedBox.shrink(),
        backgroundColor: AppStyle.primary,
        textStyle: AppStyle.interNormal(),
      ),
      animationDuration: const Duration(milliseconds: 700),
      reverseAnimationDuration: const Duration(milliseconds: 700),
      displayDuration: const Duration(milliseconds: 700),
      onTap: onTap,
    );
  }

  static double getOrderStatusProgress(String? status) {
    switch (status) {
      case 'new':
        return 0.2;
      case 'accepted':
        return 0.4;
      case 'ready':
        return 0.6;
      case 'on_a_way':
        return 0.8;
      case 'delivered':
        return 1;
      default:
        return 0.4;
    }
  }

  static String? getAppName() {
    final List<SettingsData> settings = LocalStorage.getSettingsList();
    for (final setting in settings) {
      if (setting.key == 'title') {
        return setting.value;
      }
    }
    return '';
  }

  static String? getAppLogo() {
    final List<SettingsData> settings = LocalStorage.getSettingsList();
    for (final setting in settings) {
      if (setting.key == 'logo') {
        return setting.value;
      }
    }
    return '';
  }

  static int getType() {
    if (AppConstants.isDemo) {
      return LocalStorage.getUiType() ?? 0;
    }
    final List<SettingsData> settings = LocalStorage.getSettingsList();
    for (final setting in settings) {
      if (setting.key == 'ui_type') {
        return (int.tryParse(setting.value ?? "1") ?? 1) - 1;
      }
    }
    return 0;
  }

  static bool getGroupOrder() {
    final List<SettingsData> settings = LocalStorage.getSettingsList();
    for (final setting in settings) {
      if (setting.key == 'group_order') {
        return setting.value == "1";
      }
    }
    return true;
  }

  static bool getParcel() {
    final List<SettingsData> settings = LocalStorage.getSettingsList();
    for (final setting in settings) {
      if (setting.key == 'active_parcel') {
        return setting.value == "1";
      }
    }
    return false;
  }

  static bool getReferralActive() {
    final List<SettingsData> settings = LocalStorage.getSettingsList();
    for (final setting in settings) {
      if (setting.key == 'referral_active') {
        return setting.value == "1";
      }
    }
    return false;
  }

  static String? getAppPhone() {
    final List<SettingsData> settings = LocalStorage.getSettingsList();
    for (final setting in settings) {
      if (setting.key == 'phone') {
        return setting.value;
      }
    }
    return '';
  }

  static String? getPaymentType() {
    final List<SettingsData> settings = LocalStorage.getSettingsList();
    for (final setting in settings) {
      if (setting.key == 'payment_type') {
        return setting.value;
      }
    }
    return 'admin';
  }

  static bool getPhoneRequired() {
    final List<SettingsData> settings = LocalStorage.getSettingsList();
    for (final setting in settings) {
      if (setting.key == 'before_order_phone_required') {
        return setting.value == "1";
      }
    }
    return false;
  }

  static bool getReservationEnable() {
    final List<SettingsData> settings = LocalStorage.getSettingsList();
    for (final setting in settings) {
      if (setting.key == 'reservation_enable_for_user') {
        return setting.value == "1";
      }
    }
    return false;
  }

  static String? getAppAddressName() {
    final List<SettingsData> settings = LocalStorage.getSettingsList();
    for (final setting in settings) {
      if (setting.key == 'address') {
        return setting.value;
      }
    }
    return '';
  }

  static String getTranslation(String trKey) {
    final Map<String, dynamic> translations = LocalStorage.getTranslations();
    return translations[trKey] ??
        (trKey.isNotEmpty
            ? trKey
                  .replaceAll(".", " ")
                  .replaceAll("_", " ")
                  .replaceFirst(
                    trKey.substring(0, 1),
                    trKey.substring(0, 1).toUpperCase(),
                  )
            : '');
  }

  static String getTranslationReverse(String trKey) {
    final Map<String, dynamic> translations = LocalStorage.getTranslations();
    for (int i = 0; i < translations.values.length; i++) {
      if (trKey == translations.values.elementAt(i)) {
        return translations.keys.elementAt(i);
      }
    }
    return trKey;
  }

  static String formatAddress(Placemark p) {
    final parts = <String>[];

    // 1. Ko'cha + Uy raqami (combined for better readability)
    String street = '';
    if (p.thoroughfare != null && p.thoroughfare!.isNotEmpty) {
      street = p.thoroughfare!;
    } else if (p.street != null && p.street!.isNotEmpty) {
      street = p.street!;
    }

    // Add house number to street
    if (street.isNotEmpty) {
      if (p.subThoroughfare != null && p.subThoroughfare!.isNotEmpty) {
        street = '$street ${p.subThoroughfare!}';
      }
      parts.add(street);
    } else if (p.subThoroughfare != null && p.subThoroughfare!.isNotEmpty) {
      // If no street, just add house number
      parts.add(p.subThoroughfare!);
    }

    // 2. Name (if different from street)
    if (p.name != null &&
        p.name!.isNotEmpty &&
        p.name != street &&
        !street.contains(p.name!)) {
      parts.add(p.name!);
    }

    // 3. Tuman (subLocality)
    if (p.subLocality != null && p.subLocality!.isNotEmpty) {
      parts.add(p.subLocality!);
    }

    // 4. Shahar (locality)
    if (p.locality != null && p.locality!.isNotEmpty) {
      parts.add(p.locality!);
    }

    // 5. Viloyat (administrativeArea)
    if (p.administrativeArea != null &&
        p.administrativeArea!.isNotEmpty &&
        p.administrativeArea != p.locality) {
      parts.add(p.administrativeArea!);
    }

    debugPrint('Formatted address parts: $parts');
    return parts.join(', ');
  }

  /// Extracts house/building number from Placemark
  /// Returns the house number or empty string if not found
  static String extractHouseNumber(Placemark p) {
    // Priority 1: subThoroughfare (most reliable)
    if (p.subThoroughfare != null && p.subThoroughfare!.isNotEmpty) {
      return p.subThoroughfare!;
    }

    // Priority 2: Extract from street name
    if (p.street != null && p.street!.isNotEmpty) {
      final match = RegExp(r'\b(\d+[A-Za-z]?)\b').firstMatch(p.street!);
      if (match != null) {
        return match.group(1) ?? '';
      }
    }

    // Priority 3: Extract from name
    if (p.name != null && p.name!.isNotEmpty) {
      final match = RegExp(r'\b(\d+[A-Za-z]?)\b').firstMatch(p.name!);
      if (match != null) {
        return match.group(1) ?? '';
      }
    }

    return '';
  }

  /// Gets detailed address information from Placemark
  /// Returns a map with separate fields
  static Map<String, String> getDetailedAddress(Placemark p) {
    return {
      'street': p.thoroughfare ?? p.street ?? '',
      'houseNumber': extractHouseNumber(p),
      'district': p.subLocality ?? '',
      'city': p.locality ?? '',
      'region': p.administrativeArea ?? '',
      'country': p.country ?? '',
      'postalCode': p.postalCode ?? '',
      'fullAddress': formatAddress(p),
    };
  }

  static bool checkIsSvg(String? url) {
    if (url == null || (url.length) < 3) {
      return false;
    }
    final length = url.length;
    return url.substring(length - 3, length) == 'svg';
  }

  static double? getInitialLatitude() {
    final List<SettingsData> settings = LocalStorage.getSettingsList();
    for (final setting in settings) {
      if (setting.key == 'location') {
        final String? latString = setting.value?.substring(
          0,
          setting.value?.indexOf(','),
        );
        if (latString == null) {
          return null;
        }
        final double? lat = double.tryParse(latString);
        return lat;
      }
    }
    return null;
  }

  static double? getInitialLongitude() {
    final List<SettingsData> settings = LocalStorage.getSettingsList();
    for (final setting in settings) {
      if (setting.key == 'location') {
        final String? latString = setting.value?.substring(
          0,
          setting.value?.indexOf(','),
        );
        if (latString == null) {
          return null;
        }
        final String? lonString = setting.value?.substring(
          (latString.length) + 2,
          setting.value?.length,
        );
        if (lonString == null) {
          return null;
        }
        final double? lon = double.tryParse(lonString);
        return lon;
      }
    }
    return null;
  }

  static void showCustomModalBottomSheet({
    required BuildContext context,
    required Widget modal,
    required bool isDarkMode,
    double radius = 16,
    bool isDrag = true,
    bool isDismissible = true,
    double paddingTop = 200,
    Color? backgroundColor,
  }) {
    showModalBottomSheet(
      isDismissible: isDismissible,
      enableDrag: isDrag,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radius.r),
          topRight: Radius.circular(radius.r),
        ),
      ),
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height - paddingTop.r,
      ),
      backgroundColor: backgroundColor,
      context: context,
      builder: (context) => modal,
    );
  }

  static void showCustomModalBottomDragSheet({
    required BuildContext context,
    required Function(ScrollController controller) modal,
    bool isDarkMode = false,
    double radius = 16,
    bool isDrag = true,
    bool isDismissible = true,
    double paddingTop = 100,
    double maxChildSize = 0.9,
  }) {
    showModalBottomSheet(
      isDismissible: isDismissible,
      enableDrag: isDrag,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radius.r),
          topRight: Radius.circular(radius.r),
        ),
      ),
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height - paddingTop.r,
      ),
      backgroundColor: AppStyle.transparent,
      context: context,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: maxChildSize,
        maxChildSize: maxChildSize,
        expand: false,
        builder: (BuildContext context, ScrollController scrollController) {
          return modal(scrollController);
        },
      ),
    );
  }

  static void showAlertDialog({
    required BuildContext context,
    required Widget child,
    Color? backgroundColor,
    double radius = 16,
  }) {
    AlertDialog alert = AlertDialog(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius.r)),
      ),
      contentPadding: EdgeInsets.all(20.r),
      iconPadding: EdgeInsets.zero,
      content: child,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static String errorHandler(dynamic e) {
    try {
      return (e.runtimeType == DioException)
          ? ((e as DioException).response?.data["message"] == "Bad request."
                ? (e.response?.data["params"] as Map).values.first[0]
                : e.response?.data["message"])
          : e.toString();
    } catch (s) {
      try {
        return (e.runtimeType == DioException)
            ? ((e as DioException).response?.data.toString().substring(
                (e.response?.data.toString().indexOf("<title>") ?? 0) + 7,
                e.response?.data.toString().indexOf("</title") ?? 0,
              )).toString()
            : e.toString();
      } catch (r) {
        try {
          return (e.runtimeType == DioException)
              ? ((e as DioException).response?.data["error"]["message"])
                    .toString()
              : e.toString();
        } catch (f) {
          return e.toString();
        }
      }
    }
  }
}

extension TimeOfDayExtension on TimeOfDay {
  TimeOfDay plusMinutes({required int minute}) {
    DateTime today = DateTime.now();
    DateTime customDateTime = DateTime(
      today.year,
      today.month,
      today.day,
      hour,
      this.minute,
    );
    return TimeOfDay.fromDateTime(
      customDateTime.add(Duration(minutes: minute)),
    );
  }
}

extension ExtendedIterable<E> on Iterable<E> {
  Iterable mapIndexed<T>(T Function(E e, int i) f) {
    var i = 0;
    return map((e) => f(e, i++));
  }
}
