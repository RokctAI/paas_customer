import 'package:get_it/get_it.dart';
import 'package:base_sdk/src/constants/app_constants.dart';
import 'package:base_sdk/src/domain/interface/cart.dart';
import 'package:base_sdk/src/domain/interface/orders.dart';
import 'package:base_sdk/src/domain/interface/parcel.dart';
import 'package:orders_sdk/src/infrastructure/repositories/customer/orders_repository.dart';
import 'package:orders_sdk/src/infrastructure/repositories/customer/mock_orders_repository.dart';
import 'package:orders_sdk/src/infrastructure/repositories/customer/cart_repository.dart';
import 'package:orders_sdk/src/infrastructure/repositories/customer/mock_cart_repository.dart';
import 'package:orders_sdk/src/infrastructure/repositories/customer/parcel_repository.dart';

/// Installer-convention DI hook: the composed app's generated `main.dart`
/// calls `OrdersSdkDependencies.register(GetIt.instance)` for every
/// installed SDK. Registers this SDK's repositories against their base_sdk
/// facades (idempotently, so hand-wired hosts can call it too).
class OrdersSdkDependencies {
  static void register(GetIt getIt) {
    if (!getIt.isRegistered<OrdersRepositoryFacade>()) {
      getIt.registerSingleton<OrdersRepositoryFacade>(
        AppConstants.isDemo ? MockOrdersRepository() : OrdersRepository(),
      );
    }
    if (!getIt.isRegistered<CartRepositoryFacade>()) {
      getIt.registerSingleton<CartRepositoryFacade>(
        AppConstants.isDemo ? MockCartRepository() : CartRepository(),
      );
    }
    if (!getIt.isRegistered<ParcelRepositoryFacade>()) {
      getIt.registerSingleton<ParcelRepositoryFacade>(ParcelRepository());
    }
  }
}
