import 'package:get_it/get_it.dart';
import 'package:google_place/google_place.dart';
import 'package:base_sdk/src/domain/interface/address.dart';
import 'package:base_sdk/src/domain/interface/auth.dart';
import 'package:base_sdk/src/domain/interface/banners.dart';
import 'package:base_sdk/src/domain/interface/blogs.dart';
import 'package:base_sdk/src/domain/interface/brands.dart';
import 'package:base_sdk/src/domain/interface/cart.dart';
import 'package:base_sdk/src/domain/interface/categories.dart';
import 'package:base_sdk/src/domain/interface/currencies.dart';
import 'package:base_sdk/src/domain/interface/draw.dart';
import 'package:base_sdk/src/domain/interface/gallery.dart';
import 'package:base_sdk/src/domain/interface/notification.dart';
import 'package:base_sdk/src/domain/interface/orders.dart';
import 'package:base_sdk/src/domain/interface/parcel.dart';
import 'package:base_sdk/src/domain/interface/payments.dart';
import 'package:base_sdk/src/domain/interface/products.dart';
import 'package:base_sdk/src/domain/interface/settings.dart';
import 'package:base_sdk/src/domain/interface/shops.dart';
import 'package:base_sdk/src/domain/interface/user.dart';
import 'package:users_sdk/src/infrastructure/repositories/customer/address_repository.dart';
import 'package:auth_sdk/src/infrastructure/repositories/customer/auth_repository.dart';
import 'package:promotions_sdk/src/infrastructure/repositories/customer/banners_repository.dart';
import 'package:corporate_sdk/src/infrastructure/repositories/customer/blogs_repository.dart';
import 'package:products_sdk/src/infrastructure/repositories/customer/brands_repository.dart';
import 'package:orders_sdk/src/infrastructure/repositories/customer/cart_repository.dart';
import 'package:products_sdk/src/infrastructure/repositories/customer/categories_repository.dart';
import 'package:comms_sdk/src/infrastructure/repositories/customer/currencies_repository.dart';
import 'package:map_sdk/src/infrastructure/repositories/customer/draw_repository.dart';
import 'package:products_sdk/src/infrastructure/repositories/customer/gallery_repository.dart';
import 'package:comms_sdk/src/infrastructure/repositories/customer/notification_repository.dart';
import 'package:orders_sdk/src/infrastructure/repositories/customer/orders_repository.dart';
import 'package:orders_sdk/src/infrastructure/repositories/customer/parcel_repository.dart';
import 'package:payments_sdk/src/infrastructure/repositories/customer/payments_repository.dart';
import 'package:products_sdk/src/infrastructure/repositories/customer/products_repository.dart';
import 'package:comms_sdk/src/infrastructure/repositories/customer/settings_repository.dart';
import 'package:merchants_sdk/src/infrastructure/repositories/customer/shops_repository.dart';
import 'package:users_sdk/src/infrastructure/repositories/customer/user_repository.dart';
import 'package:base_sdk/src/constants/app_constants.dart';
import 'package:base_sdk/src/services/local_storage.dart';
import 'package:polaris_sdk/src/infrastructure/repositories/customer/loans_repository.dart';
import 'package:wallet_sdk/src/infrastructure/repositories/customer/wallet_repository.dart';
import 'package:base_sdk/src/handlers/http_service.dart';
import 'package:base_sdk/src/domain/interface/loans.dart';
import 'package:base_sdk/src/domain/interface/wallet.dart';
import 'package:base_sdk/src/domain/interface/delivery_points.dart';
import 'package:delivery_sdk/src/infrastructure/repositories/customer/delivery_points_repository.dart';

import 'package:auth_sdk/src/infrastructure/repositories/customer/mock_auth_repository.dart';
import 'package:comms_sdk/src/infrastructure/repositories/customer/mock_settings_repository.dart';
import 'package:merchants_sdk/src/infrastructure/repositories/customer/mock_shops_repository.dart';
import 'package:products_sdk/src/infrastructure/repositories/customer/mock_products_repository.dart';
import 'package:products_sdk/src/infrastructure/repositories/customer/mock_categories_repository.dart';
import 'package:promotions_sdk/src/infrastructure/repositories/customer/mock_banners_repository.dart';
import 'package:orders_sdk/src/infrastructure/repositories/customer/mock_cart_repository.dart';
import 'package:orders_sdk/src/infrastructure/repositories/customer/mock_orders_repository.dart';
import 'package:users_sdk/src/infrastructure/repositories/customer/mock_address_repository.dart';
import 'package:products_sdk/src/infrastructure/repositories/customer/mock_brands_repository.dart';

final GetIt getIt = GetIt.instance;

Future<void> setUpDependencies() async {
  getIt.registerLazySingleton<HttpService>(() => HttpService());

  if (AppConstants.isDemo) {
    getIt.registerSingleton<SettingsRepositoryFacade>(MockSettingsRepository());
    getIt.registerSingleton<AuthRepositoryFacade>(MockAuthRepository());
    getIt.registerSingleton<ShopsRepositoryFacade>(MockShopsRepository());
    getIt.registerSingleton<ProductsRepositoryFacade>(MockProductsRepository());
    getIt.registerSingleton<CategoriesRepositoryFacade>(
      MockCategoriesRepository(),
    );
    getIt.registerSingleton<BannersRepositoryFacade>(MockBannersRepository());
    getIt.registerSingleton<CartRepositoryFacade>(MockCartRepository());
    getIt.registerSingleton<OrdersRepositoryFacade>(MockOrdersRepository());
    getIt.registerSingleton<AddressRepositoryFacade>(MockAddressRepository());
    getIt.registerSingleton<BrandsRepositoryFacade>(MockBrandsRepository());
  } else {
    getIt.registerSingleton<SettingsRepositoryFacade>(SettingsRepository());
    getIt.registerSingleton<AuthRepositoryFacade>(AuthRepository());
    getIt.registerSingleton<ShopsRepositoryFacade>(ShopsRepository());
    getIt.registerSingleton<ProductsRepositoryFacade>(ProductsRepository());
    getIt.registerSingleton<CategoriesRepositoryFacade>(CategoriesRepository());
    getIt.registerSingleton<BannersRepositoryFacade>(BannersRepository());
    getIt.registerSingleton<CartRepositoryFacade>(CartRepository());
    getIt.registerSingleton<OrdersRepositoryFacade>(OrdersRepository());
    getIt.registerSingleton<AddressRepositoryFacade>(AddressRepository());
    getIt.registerSingleton<BrandsRepositoryFacade>(BrandsRepository());
  }

  getIt.registerSingleton<GalleryRepositoryFacade>(GalleryRepository());
  getIt.registerSingleton<CurrenciesRepositoryFacade>(CurrenciesRepository());
  getIt.registerSingleton<GooglePlace>(GooglePlace(AppConstants.googleApiKey));
  getIt.registerSingleton<PaymentsRepositoryFacade>(PaymentsRepository());
  getIt.registerSingleton<UserRepositoryFacade>(UserRepository());
  getIt.registerSingleton<BlogsRepositoryFacade>(BlogsRepository());
  getIt.registerSingleton<DrawRepositoryFacade>(DrawRepository());
  getIt.registerSingleton<ParcelRepositoryFacade>(ParcelRepository());
  getIt.registerSingleton<NotificationRepositoryFacade>(
    NotificationRepositoryImpl(),
  );
  getIt.registerSingleton<Map>(LocalStorage.getTranslations());
  getIt.registerSingleton<WalletRepositoryFacade>(WalletRepository());
  getIt.registerSingleton<LoansRepositoryFacade>(LoansRepository());
  getIt.registerSingleton<DeliveryPointsRepositoryFacade>(
    DeliveryPointsRepository(),
  );
}

final dioHttp = getIt.get<HttpService>();
final notificationRepo = getIt.get<NotificationRepositoryFacade>();
final drawRepository = getIt.get<DrawRepositoryFacade>();
final settingsRepository = getIt.get<SettingsRepositoryFacade>();
final authRepository = getIt.get<AuthRepositoryFacade>();
final productsRepository = getIt.get<ProductsRepositoryFacade>();
final shopsRepository = getIt.get<ShopsRepositoryFacade>();
final brandsRepository = getIt.get<BrandsRepositoryFacade>();
final galleryRepository = getIt.get<GalleryRepositoryFacade>();
final categoriesRepository = getIt.get<CategoriesRepositoryFacade>();
final currenciesRepository = getIt.get<CurrenciesRepositoryFacade>();
final addressesRepository = getIt.get<AddressRepositoryFacade>();
final bannersRepository = getIt.get<BannersRepositoryFacade>();
final googlePlace = getIt.get<GooglePlace>();
final paymentsRepository = getIt.get<PaymentsRepositoryFacade>();
final ordersRepository = getIt.get<OrdersRepositoryFacade>();
final userRepository = getIt.get<UserRepositoryFacade>();
final blogsRepository = getIt.get<BlogsRepositoryFacade>();
final cartRepository = getIt.get<CartRepositoryFacade>();
final parcelRepository = getIt.get<ParcelRepositoryFacade>();
final translation = getIt.get<Map>();
//final walletRepository = WalletRepository();
final walletRepository = getIt.get<WalletRepositoryFacade>();
final loansRepository = getIt.get<LoansRepositoryFacade>();
final deliveryPointsRepository = getIt.get<DeliveryPointsRepositoryFacade>();
