import 'package:get_it/get_it.dart';
import 'package:base_sdk/src/domain/interface/wallet.dart';
import 'package:wallet_sdk/src/infrastructure/repositories/customer/wallet_repository.dart';

/// Installer-convention DI hook: the composed app's generated `main.dart`
/// calls `WalletSdkDependencies.register(GetIt.instance)` for every
/// installed SDK. Registers this SDK's repositories against their base_sdk
/// facades (idempotently, so hand-wired hosts can call it too).
class WalletSdkDependencies {
  static void register(GetIt getIt) {
    if (!getIt.isRegistered<WalletRepositoryFacade>()) {
      getIt.registerSingleton<WalletRepositoryFacade>(WalletRepository());
    }
  }
}
