// ==========================================
// [GENERATED TEMPLATE FILE]
// This file was installed from: base_sdk
// Feel free to modify and customize this code.
// Note: If you edit this file, the SDK installer will detect your changes
// and automatically skip overwriting it during future upgrades.
// ==========================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:base_sdk/base_sdk.dart';
import 'package:base_sdk/src/presentation/theme/theme.dart';
import 'package:customer/core/presentation/app_widget.dart';

// @generated-sdk-imports-start
import 'package:auth_sdk/auth_sdk.dart';
import 'package:base_sdk/base_sdk.dart';
import 'package:comms_sdk/comms_sdk.dart';
import 'package:corporate_sdk/corporate_sdk.dart';
import 'package:delivery_sdk/delivery_sdk.dart';
import 'package:fav_sdk/fav_sdk.dart';
import 'package:loyalty_sdk/loyalty_sdk.dart';
import 'package:map_sdk/map_sdk.dart';
import 'package:marketplace_sdk/marketplace_sdk.dart';
import 'package:merchants_sdk/merchants_sdk.dart';
import 'package:orders_sdk/orders_sdk.dart';
import 'package:payments_sdk/payments_sdk.dart';
import 'package:processing_sdk/processing_sdk.dart';
import 'package:products_sdk/products_sdk.dart';
import 'package:promotions_sdk/promotions_sdk.dart';
import 'package:users_sdk/users_sdk.dart';
import 'package:wallet_sdk/wallet_sdk.dart';
// @generated-sdk-imports-end

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppStyle.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: AppStyle.transparent,
      systemNavigationBarDividerColor: AppStyle.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  await LocalStorage.init();
  BaseSdkDependencies.register(GetIt.instance);
  // @generated-sdk-di-start
  AuthSdkDependencies.register(GetIt.instance);
  BaseSdkDependencies.register(GetIt.instance);
  CommsSdkDependencies.register(GetIt.instance);
  CorporateSdkDependencies.register(GetIt.instance);
  DeliverySdkDependencies.register(GetIt.instance);
  FavSdkDependencies.register(GetIt.instance);
  LoyaltySdkDependencies.register(GetIt.instance);
  MapSdkDependencies.register(GetIt.instance);
  MarketplaceSdkDependencies.register(GetIt.instance);
  MerchantsSdkDependencies.register(GetIt.instance);
  OrdersSdkDependencies.register(GetIt.instance);
  PaymentsSdkDependencies.register(GetIt.instance);
  ProcessingSdkDependencies.register(GetIt.instance);
  ProductsSdkDependencies.register(GetIt.instance);
  PromotionsSdkDependencies.register(GetIt.instance);
  UsersSdkDependencies.register(GetIt.instance);
  WalletSdkDependencies.register(GetIt.instance);
// @generated-sdk-di-end

  // NOTE: if any installed SDK navigates through AppRoutes.I (base_sdk's
  // navigation indirection) or embeds cross-SDK widgets via
  // EmbeddedWidgets.I, assign host implementations here BEFORE runApp —
  // see paas_customer/lib/presentation/routes/app_routes_impl.dart for the
  // reference implementation. Unassigned registries throw a descriptive
  // StateError on first use rather than failing silently.

  runApp(const ProviderScope(child: AppWidget()));
}
