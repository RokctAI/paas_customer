import 'package:get_it/get_it.dart';
import 'package:google_place/google_place.dart';
import 'package:paas_customer/domain/interface/address.dart';
import 'package:paas_customer/domain/interface/auth.dart';
import 'package:paas_customer/domain/interface/banners.dart';
import 'package:paas_customer/domain/interface/blogs.dart';
import 'package:paas_customer/domain/interface/brands.dart';
import 'package:paas_customer/domain/interface/cart.dart';
import 'package:paas_customer/domain/interface/categories.dart';
import 'package:paas_customer/domain/interface/currencies.dart';
import 'package:paas_customer/domain/interface/draw.dart';
import 'package:paas_customer/domain/interface/gallery.dart';
import 'package:paas_customer/domain/interface/notification.dart';
import 'package:paas_customer/domain/interface/orders.dart';
import 'package:paas_customer/domain/interface/parcel.dart';
import 'package:paas_customer/domain/interface/payments.dart';
import 'package:paas_customer/domain/interface/products.dart';
import 'package:paas_customer/domain/interface/settings.dart';
import 'package:paas_customer/domain/interface/shops.dart';
import 'package:paas_customer/domain/interface/user.dart';
import 'package:paas_customer/infrastructure/repository/address_repository.dart';
import 'package:paas_customer/infrastructure/repository/auth_repository.dart';
import 'package:paas_customer/infrastructure/repository/banners_repository.dart';
import 'package:paas_customer/infrastructure/repository/blogs_repository.dart';
import 'package:paas_customer/infrastructure/repository/brands_repository.dart';
import 'package:paas_customer/infrastructure/repository/cart_repository.dart';
import 'package:paas_customer/infrastructure/repository/categories_repository.dart';
import 'package:paas_customer/infrastructure/repository/currencies_repository.dart';
import 'package:paas_customer/infrastructure/repository/draw_repository.dart';
import 'package:paas_customer/infrastructure/repository/gallery_repository.dart';
import 'package:paas_customer/infrastructure/repository/notification_repository.dart';
import 'package:paas_customer/infrastructure/repository/orders_repository.dart';
import 'package:paas_customer/infrastructure/repository/parcel_repository.dart';
import 'package:paas_customer/infrastructure/repository/payments_repository.dart';
import 'package:paas_customer/infrastructure/repository/products_repository.dart';
import 'package:paas_customer/infrastructure/repository/settings_repository.dart';
import 'package:paas_customer/infrastructure/repository/shops_repository.dart';
import 'package:paas_customer/infrastructure/repository/user_repository.dart';
import 'package:paas_customer/app_constants.dart';
import 'package:paas_customer/infrastructure/services/local_storage.dart';

import '../../infrastructure/repository/loans_repository.dart';
import '../../infrastructure/repository/wallet_repository.dart';
import '../handlers/http_service.dart';
import '../interface/loans.dart';
import '../interface/wallet.dart';

import 'package:paas_customer/domain/interface/delivery_points.dart';
import 'package:paas_customer/infrastructure/repository/delivery_points_repository.dart';

import 'package:paas_customer/infrastructure/repository/mock/mock_auth_repository.dart';
import 'package:paas_customer/infrastructure/repository/mock/mock_settings_repository.dart';
import 'package:paas_customer/infrastructure/repository/mock/mock_shops_repository.dart';
import 'package:paas_customer/infrastructure/repository/mock/mock_products_repository.dart';
import 'package:paas_customer/infrastructure/repository/mock/mock_categories_repository.dart';
import 'package:paas_customer/infrastructure/repository/mock/mock_banners_repository.dart';
import 'package:paas_customer/infrastructure/repository/mock/mock_cart_repository.dart';
import 'package:paas_customer/infrastructure/repository/mock/mock_orders_repository.dart';
import 'package:paas_customer/infrastructure/repository/mock/mock_address_repository.dart';
import 'package:paas_customer/infrastructure/repository/mock/mock_brands_repository.dart';

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
