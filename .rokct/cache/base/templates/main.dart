import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:base_sdk/base_sdk.dart';
import 'package:base_sdk/src/presentation/theme/theme.dart';
import 'package:${package}/core/presentation/app_widget.dart';

// @generated-sdk-imports-start
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
  // @generated-sdk-di-end

  // NOTE: if any installed SDK navigates through AppRoutes.I (base_sdk's
  // navigation indirection) or embeds cross-SDK widgets via
  // EmbeddedWidgets.I, assign host implementations here BEFORE runApp —
  // see paas_customer/lib/presentation/routes/app_routes_impl.dart for the
  // reference implementation. Unassigned registries throw a descriptive
  // StateError on first use rather than failing silently.

  runApp(const ProviderScope(child: AppWidget()));
}
