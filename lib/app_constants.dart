import 'package:foodyman/infrastructure/services/tr_keys.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:foodyman/presentation/app_assets.dart';

import 'infrastructure/services/enums.dart';


abstract class AppConstants {
  AppConstants._();

  static const bool isDemo = false;
  static const bool isPhoneFirebase = true;
  static const int scheduleInterval = 60;
  static const SignUpType signUpType = SignUpType.phone;
  static const bool use24Format = true;
  static const double radius = 16;

  /// api urls
  static const String baseUrl = String.fromEnvironment('BASE_URL');
  static const String wsBaseUrl = String.fromEnvironment('WS_BASE_URL');
  static const String wsSecret = String.fromEnvironment('WS_SECRET');
  static const String webUrl = String.fromEnvironment('WEB_URL');
  static String drawingBaseUrl = String.fromEnvironment('ROUTING_API');
  static String adminPageUrl = String.fromEnvironment('ADMIN_URL');
  static String googleApiKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY',
  );
  static String firebaseWebKey = String.fromEnvironment(
    'FIREBASE_API_KEY',
  );
  static String geminiKey = String.fromEnvironment('GEMINI_KEY');
  static String uriPrefix = String.fromEnvironment('URL_PREFIX');
  static String routingBaseUrl = String.fromEnvironment('ROUTING_API');
  static String routingKey = String.fromEnvironment('ROUTING_KEY');
  static String deepLinkHost = String.fromEnvironment('DEEP_LINK_URL');
  static const String androidPackageName = String.fromEnvironment('CUSTOMER_ANDROID_PACKAGE_NAME');
  static const String iosPackageName = String.fromEnvironment('CUSTOMER_IOS_PACKAGE_NAME');

  /// newStores and Recommendation Time
  static int newShopDays = 60;

  /// Operating time
  static String isOpen = '6am';
  static String isClosed = '10pm';
  static bool isMaintain = false;
  static bool bgImg = true;

  /// Google Maps POI
  static bool showGooglePOILayer = true;

  /// hero tags
  static const String heroTagSelectUser = 'heroTagSelectUser';
  static const String heroTagSelectAddress = 'heroTagSelectAddress';
  static const String heroTagSelectCurrency = 'heroTagSelectCurrency';

  /// PayFast
  static const String passphrase = String.fromEnvironment('PAYFAST_PASSPHRASE');
  static const String merchantId = String.fromEnvironment(
    'PAYFAST_MERCHANT_ID',
  );
  static const String merchantKey = String.fromEnvironment(
    'PAYFAST_MERCHANT_KEY',
  );

  static const String demoUserLogin = 'user@githubit.com';
  static const String demoUserPassword = 'githubit';

  /// locales
  static String localeCodeEn = 'en';

  /// auth phone fields
  static bool isNumberLengthAlwaysSame = true;
  static String countryCodeISO = String.fromEnvironment('COUNTRY_ISO');
  static bool showFlag = true;
  static bool showArrowIcon = true;

  /// location
  static double demoLatitude = double.parse(const String.fromEnvironment('DEMO_LATITUDE'));
  static double demoLongitude = double.parse(const String.fromEnvironment('DEMO_LONGITUDE'));
  static double pinLoadingMin = 0.116666667;
  static double pinLoadingMax = 0.611111111;

  /// Weather
  static const String openWeatherApiKey = String.fromEnvironment('OPEN_WEATHER_API_KEY');
  static const bool weatherIcon = true;
  static const int rainPOP = 60;

  static const Duration timeRefresh = Duration(seconds: 30);

  /// social sign-in
  static const socialSignIn = [
    FlutterRemix.google_fill,
    FlutterRemix.facebook_fill,
    FlutterRemix.apple_fill,
  ];

  static const socialSignInAndroid = [
    FlutterRemix.google_fill,
    FlutterRemix.facebook_fill,
  ];

  static const List infoImage = [
    Assets.imagesSave,
    Assets.imagesDelivery,
    Assets.imagesFast,
    Assets.imagesSet,
  ];

  static const List infoTitle = [
    TrKeys.saveTime,
    TrKeys.deliveryRestriction,
    TrKeys.fast,
    TrKeys.set,
  ];

  static const payLater = [
    "progress",
    "canceled",
    "rejected",
  ];
  static const genderList = [
    "male",
    "female",
  ];

  static const bool fixed = true;

  static bool cardDirect = false;

  /// Marketplace Settings
  static bool enableMarketplace = true;
  static String defaultShopId = "";
}
