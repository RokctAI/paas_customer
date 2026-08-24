import 'package:get_it/get_it.dart';

import '../domain/interface/loyalty_repository_facade.dart';
import '../infrastructure/repositories/local_loyalty_repository.dart';

class LoyaltySdkDependencies {
  /// Registers the offline default. Hosts backed by a loyalty service
  /// register their own [LoyaltyRepositoryFacade] BEFORE calling this (an
  /// existing registration is left untouched).
  static void register(GetIt getIt) {
    if (!getIt.isRegistered<LoyaltyRepositoryFacade>()) {
      getIt.registerLazySingleton<LoyaltyRepositoryFacade>(
        () => LocalLoyaltyRepository(),
      );
    }
  }
}
