import 'package:get_it/get_it.dart';
import 'package:base_sdk/src/domain/interface/payments.dart';
import 'package:payments_sdk/src/infrastructure/repositories/customer/payments_repository.dart';

/// Installer-convention DI hook: the composed app's generated `main.dart`
/// calls `PaymentsSdkDependencies.register(GetIt.instance)` for every
/// installed SDK. Registers this SDK's repositories against their base_sdk
/// facades (idempotently, so hand-wired hosts can call it too).
class PaymentsSdkDependencies {
  static void register(GetIt getIt) {
    if (!getIt.isRegistered<PaymentsRepositoryFacade>()) {
      getIt.registerSingleton<PaymentsRepositoryFacade>(PaymentsRepository());
    }
  }
}
