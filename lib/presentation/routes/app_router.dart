import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
// Route shells for SDK-resident pages (see route_pages.dart).
import 'package:foodyman/presentation/routes/route_pages.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:foodyman/presentation/pages/main/main_page.dart';
import 'package:base_sdk/src/models/data/address_new_data.dart';
import 'package:base_sdk/src/models/data/shop_data.dart';
import 'package:base_sdk/src/models/data/user.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        MaterialRoute(path: '/', page: SplashRoute.page),
        MaterialRoute(path: '/no-connection', page: NoConnectionRoute.page),
        MaterialRoute(path: '/login', page: LoginRoute.page),
        MaterialRoute(path: '/ui-type', page: UiTypeRoute.page),
        MaterialRoute(path: '/reset', page: ResetPasswordRoute.page),
        MaterialRoute(
          path: '/register-confirmation',
          page: RegisterConfirmationRoute.page,
        ),
        MaterialRoute(path: '/register', page: RegisterRoute.page),
        MaterialRoute(path: '/main', page: MainRoute.page),
        MaterialRoute(path: '/shop', page: ShopRoute.page),
        MaterialRoute(path: '/order', page: OrdersListRoute.page),
        MaterialRoute(path: '/setting', page: SettingRoute.page),
        MaterialRoute(path: '/orderScreen', page: OrderRoute.page),
        MaterialRoute(path: '/searchPage', page: SearchRoute.page),
        MaterialRoute(path: '/ProfilePage', page: ProfileRoute.page),
        MaterialRoute(path: '/map', page: ViewMapRoute.page),
        MaterialRoute(path: "/storyList", page: StoryListRoute.page),
        MaterialRoute(path: '/recommended', page: RecommendedRoute.page),
        MaterialRoute(path: '/recommended_one', page: RecommendedOneRoute.page),
        MaterialRoute(path: '/recommended_two', page: RecommendedTwoRoute.page),
        MaterialRoute(path: '/map_search', page: MapSearchRoute.page),
        MaterialRoute(path: '/help', page: HelpRoute.page),
        MaterialRoute(path: '/order_progress', page: OrderProgressRoute.page),
        MaterialRoute(path: '/result_filter', page: ResultFilterRoute.page),
        MaterialRoute(path: '/wallet_history', page: WalletHistoryRoute.page),
        MaterialRoute(path: '/create_shop', page: CreateShopRoute.page),
        MaterialRoute(path: '/shops_banner', page: ShopsBannerRoute.page),
        MaterialRoute(path: '/shops_detail', page: ShopDetailRoute.page),
        MaterialRoute(path: '/share_referral', page: ShareReferralRoute.page),
        MaterialRoute(
          path: '/share_referral_faq',
          page: ShareReferralFaqRoute.page,
        ),
        MaterialRoute(path: '/chat', page: ChatRoute.page),
        MaterialRoute(
          path: '/notification_list_page',
          page: NotificationListRoute.page,
        ),
        MaterialRoute(
          path: '/service_two_category_page',
          page: ServiceTwoCategoryRoute.page,
        ),
        MaterialRoute(
            path: '/recommended_three', page: RecommendedThreeRoute.page),
        MaterialRoute(path: '/parcel_page', page: ParcelRoute.page),
        MaterialRoute(path: '/info_screen', page: InfoRoute.page),
        MaterialRoute(path: '/like_page', page: LikeRoute.page),
        MaterialRoute(path: '/parcel_list_page', page: ParcelListRoute.page),
        MaterialRoute(
          path: '/parcel_progress_page',
          page: ParcelProgressRoute.page,
        ),
        // MaterialRoute(path: '/sub_category_page', page: SubCategoryRoute.page),
        MaterialRoute(path: '/address_list_page', page: AddressListRoute.page),
        MaterialRoute(path: '/term', page: TermRoute.page),
        MaterialRoute(path: '/policy', page: PolicyRoute.page),
        MaterialRoute(path: '/ClosedPage', page: ClosedRoute.page),
        MaterialRoute(path: '/IntroPage', page: IntroRoute.page),
        MaterialRoute(path: '/OrdesMainPage', page: OrdersMainRoute.page),
        MaterialRoute(
          path: '/LoanEligibilityScreen',
          page: LoanEligibilityRoute.page,
        ),
        MaterialRoute(
          path: '/LoanDocumentUploadScreen',
          page: LoanDocumentUploadRoute.page,
        ),
        MaterialRoute(path: '/LoanScreen', page: LoanRoute.page),
      ];
}
