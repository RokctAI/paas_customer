import 'package:get_it/get_it.dart';
import 'package:base_sdk/src/constants/app_constants.dart';
import 'package:base_sdk/src/domain/interface/currencies.dart';
import 'package:base_sdk/src/domain/interface/notification.dart';
import 'package:base_sdk/src/domain/interface/settings.dart';
import 'package:comms_sdk/src/infrastructure/repositories/customer/settings_repository.dart';
import 'package:comms_sdk/src/infrastructure/repositories/customer/mock_settings_repository.dart';
import 'package:comms_sdk/src/infrastructure/repositories/customer/currencies_repository.dart';
import 'package:comms_sdk/src/infrastructure/repositories/customer/notification_repository.dart';

/// Installer-convention DI hook: the composed app's generated `main.dart`
/// calls `CommsSdkDependencies.register(GetIt.instance)` for every
/// installed SDK. Registers this SDK's repositories against their base_sdk
/// facades (idempotently, so hand-wired hosts can call it too).
class CommsSdkDependencies {
  static void register(GetIt getIt) {
    if (!getIt.isRegistered<SettingsRepositoryFacade>()) {
      getIt.registerSingleton<SettingsRepositoryFacade>(
        AppConstants.isDemo ? MockSettingsRepository() : SettingsRepository(),
      );
    }
    if (!getIt.isRegistered<CurrenciesRepositoryFacade>()) {
      getIt.registerSingleton<CurrenciesRepositoryFacade>(CurrenciesRepository());
    }
    if (!getIt.isRegistered<NotificationRepositoryFacade>()) {
      getIt.registerSingleton<NotificationRepositoryFacade>(NotificationRepositoryImpl());
    }
  }
}
