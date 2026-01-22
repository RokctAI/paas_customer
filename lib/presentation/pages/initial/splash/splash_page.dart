import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodyman/app_constants.dart';
import 'package:foodyman/infrastructure/services/services.dart';
import 'package:foodyman/presentation/routes/app_router.dart';
import 'package:foodyman/application/splash/splash_provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

@RoutePage()
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(splashProvider.notifier).getTranslations(context);
      ref
          .read(splashProvider.notifier)
          .getToken(
            context,
            goMain: () {
              FlutterNativeSplash.remove();
              if (LocalStorage.getFirstEntry()) {
                LocalStorage.setFirstEntry(false);
                if (AppConstants.isDemo) {
                  context.replaceRoute(UiTypeRoute());
                  return;
                }
                context.replaceRoute(PermissionLocationRoute());
              } else {
                context.replaceRoute(MainRoute());
              }
            },
            goLogin: () {
              FlutterNativeSplash.remove();
              if (LocalStorage.getFirstEntry()) {
                LocalStorage.setFirstEntry(false);
                if (AppConstants.isDemo) {
                  context.replaceRoute(UiTypeRoute());
                  return;
                }
                context.replaceRoute(PermissionLocationRoute());
              } else {
                if (LocalStorage.getAddressSelected() == null) {
                  context.replaceRoute(PermissionLocationRoute());
                } else {
                  context.replaceRoute(MainRoute());
                }
              }
            },
            goNoInternet: () {
              FlutterNativeSplash.remove();
              context.replaceRoute(const NoConnectionRoute());
            },
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset("assets/images/splash.png", fit: BoxFit.fill);
  }
}
