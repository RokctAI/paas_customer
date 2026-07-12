import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:base_sdk/src/navigation/app_routes.dart';
import 'package:base_sdk/src/navigation/embedded_widgets.dart';
import 'package:base_sdk/src/services/local_storage.dart';
import 'package:base_sdk/src/presentation/theme/theme.dart';
import 'package:foodyman/domain/di/dependency_manager.dart';
import 'package:foodyman/presentation/routes/app_routes_impl.dart';
import 'package:foodyman/presentation/routes/embedded_widgets_impl.dart';
import 'package:foodyman/presentation/app_widget.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:foodyman/utils/app_initializer_widget.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

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
  setUpDependencies();
  // SDK-resident code navigates/embeds through these host-backed registries.
  AppRoutes.I = AppRoutesImpl();
  EmbeddedWidgets.I = EmbeddedWidgetsImpl();
  runApp(ProviderScope(child: AppInitializerWidget(child: AppWidget())));
}
