// ==========================================
// [GENERATED TEMPLATE FILE]
// This file was installed from: base_sdk
// Feel free to modify and customize this code.
// Note: If you edit this file, the SDK installer will detect your changes
// and automatically skip overwriting it during future upgrades.
// ==========================================

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:base_sdk/base_sdk.dart';
import 'package:customer/presentation/theme/theme.dart';
import 'package:customer/presentation/app_widget.dart';
import 'package:customer/presentation/routes/app_router.dart';

// @generated-sdk-imports-start
import 'package:base_sdk/base_sdk.dart';
import 'package:auth_sdk/auth_sdk.dart';
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

/// AppRoutes.I: SDK-resident code (auth_sdk's login/register/reset-password
/// flows, map_sdk's map view) navigates through this indirection since it
/// cannot reference host-generated route classes directly. Leaving
/// AppRoutes.I unset was a missing composition step — the app hung right
/// after splash the first time auth_sdk tried to navigate post-auth
/// (AppRoutes.I threw "has not been set" on first real navigation).
///
/// Only the methods actually invoked by installed SDKs
/// (`grep -r "AppRoutes\.I\." Users/auth zones/map ...`) are wired for real:
/// - replaceUiTypeRoute: called throughout auth_sdk's login/register/reset
///   flows after a successful auth action; UiTypeRoute is already a
///   registered route in this app's AppRouter.
/// pushMapSearchRoute (map_sdk's view_map_page) is NOT wired: map_sdk's
/// MapSearchPage has never been given a @RoutePage shell or been added to
/// AppRouter.routes in this app, so there is no real destination to
/// delegate to yet. It keeps throwing via noSuchMethod until that route is
/// actually composed — faking a destination here would silently swallow a
/// missing-composition bug instead of surfacing it.
class _PaasCustomerAppRoutes implements AppRoutes {
  @override
  Future<Object?> replaceUiTypeRoute(BuildContext context) =>
      context.router.replace(UiTypeRoute());

  @override
  dynamic noSuchMethod(Invocation invocation) => throw StateError(
      'AppRoutes.I.${invocation.memberName} has not been implemented by '
      'paas_customer — only replaceUiTypeRoute is wired.');
}

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
  BaseSdkDependencies.register(GetIt.instance);
  AuthSdkDependencies.register(GetIt.instance);
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

  AppRoutes.I = _PaasCustomerAppRoutes();

  applyAppBrandColors();

  runApp(const ProviderScope(child: AppWidget()));
}
