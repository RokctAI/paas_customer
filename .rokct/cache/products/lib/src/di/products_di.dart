import 'package:get_it/get_it.dart';
import 'package:base_sdk/src/constants/app_constants.dart';
import 'package:base_sdk/src/domain/interface/brands.dart';
import 'package:base_sdk/src/domain/interface/categories.dart';
import 'package:base_sdk/src/domain/interface/gallery.dart';
import 'package:base_sdk/src/domain/interface/products.dart';
import 'package:products_sdk/src/infrastructure/repositories/customer/products_repository.dart';
import 'package:products_sdk/src/infrastructure/repositories/customer/mock_products_repository.dart';
import 'package:products_sdk/src/infrastructure/repositories/customer/categories_repository.dart';
import 'package:products_sdk/src/infrastructure/repositories/customer/mock_categories_repository.dart';
import 'package:products_sdk/src/infrastructure/repositories/customer/brands_repository.dart';
import 'package:products_sdk/src/infrastructure/repositories/customer/mock_brands_repository.dart';
import 'package:products_sdk/src/infrastructure/repositories/customer/gallery_repository.dart';

/// Installer-convention DI hook: the composed app's generated `main.dart`
/// calls `ProductsSdkDependencies.register(GetIt.instance)` for every
/// installed SDK. Registers this SDK's repositories against their base_sdk
/// facades (idempotently, so hand-wired hosts can call it too).
class ProductsSdkDependencies {
  static void register(GetIt getIt) {
    if (!getIt.isRegistered<ProductsRepositoryFacade>()) {
      getIt.registerSingleton<ProductsRepositoryFacade>(
        AppConstants.isDemo ? MockProductsRepository() : ProductsRepository(),
      );
    }
    if (!getIt.isRegistered<CategoriesRepositoryFacade>()) {
      getIt.registerSingleton<CategoriesRepositoryFacade>(
        AppConstants.isDemo ? MockCategoriesRepository() : CategoriesRepository(),
      );
    }
    if (!getIt.isRegistered<BrandsRepositoryFacade>()) {
      getIt.registerSingleton<BrandsRepositoryFacade>(
        AppConstants.isDemo ? MockBrandsRepository() : BrandsRepository(),
      );
    }
    if (!getIt.isRegistered<GalleryRepositoryFacade>()) {
      getIt.registerSingleton<GalleryRepositoryFacade>(GalleryRepository());
    }
  }
}
