import 'package:get_it/get_it.dart';

/// Installer-convention DI hook: the composed app's generated `main.dart`
/// calls `MarketplaceSdkDependencies.register(GetIt.instance)` for every
/// installed SDK. Registers this SDK's repositories against their base_sdk
/// facades (idempotently, so hand-wired hosts can call it too).
class MarketplaceSdkDependencies {
  static void register(GetIt getIt) {
    // No registrations: UI/glue-only SDK.
  }
}
