import 'package:get_it/get_it.dart';
import 'package:base_sdk/src/constants/app_constants.dart';
import 'package:base_sdk/src/domain/interface/banners.dart';
import 'package:promotions_sdk/src/infrastructure/repositories/customer/banners_repository.dart';
import 'package:promotions_sdk/src/infrastructure/repositories/customer/mock_banners_repository.dart';

/// Installer-convention DI hook: the composed app's generated `main.dart`
/// calls `PromotionsSdkDependencies.register(GetIt.instance)` for every
/// installed SDK. Registers this SDK's repositories against their base_sdk
/// facades (idempotently, so hand-wired hosts can call it too).
class PromotionsSdkDependencies {
  static void register(GetIt getIt) {
    if (!getIt.isRegistered<BannersRepositoryFacade>()) {
      getIt.registerSingleton<BannersRepositoryFacade>(
        AppConstants.isDemo ? MockBannersRepository() : BannersRepository(),
      );
    }
  }
}
