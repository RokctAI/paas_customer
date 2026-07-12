// Host-side route shells for SDK-resident pages.
//
// auto_route's generator only scans the host package, so each SDK page
// gets a thin @RoutePage wrapper here. Wrappers forward constructor
// arguments verbatim; route names match the pre-refork router, so
// existing XRoute(...) call sites keep working.
// ignore_for_file: unused_import
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:base_sdk/src/models/data/address_new_data.dart';
import 'package:base_sdk/src/models/data/shop_data.dart';
import 'package:base_sdk/src/models/data/user.dart';

import 'package:auth_sdk/src/presentation/pages/auth/login/login_page.dart' as pages;
import 'package:auth_sdk/src/presentation/pages/auth/register/register_page.dart' as pages;
import 'package:auth_sdk/src/presentation/pages/auth/reset/reset_password_page.dart' as pages;
import 'package:base_sdk/src/presentation/pages/initial/closed/closed_page.dart' as pages;
import 'package:base_sdk/src/presentation/pages/initial/no_connection/no_connection_page.dart' as pages;
import 'package:base_sdk/src/presentation/pages/initial/splash/splash_page.dart' as pages;
import 'package:base_sdk/src/presentation/pages/initial/ui_type/ui_type_page.dart' as pages;
import 'package:comms_sdk/src/presentation/pages/chat/chat/chat_page.dart' as pages;
import 'package:comms_sdk/src/presentation/pages/setting/setting_page.dart' as pages;
import 'package:corporate_sdk/src/presentation/pages/policy_term/policy_page.dart' as pages;
import 'package:corporate_sdk/src/presentation/pages/policy_term/term_page.dart' as pages;
import 'package:map_sdk/src/presentation/pages/view_map/map_search_page.dart' as pages;
import 'package:map_sdk/src/presentation/pages/view_map/view_map_page.dart' as pages;
import 'package:marketplace_sdk/src/presentation/pages/home/filter/result_filter.dart' as pages;
import 'package:marketplace_sdk/src/presentation/pages/home/home_four/widgets/recommended_screen.dart' as pages;
import 'package:marketplace_sdk/src/presentation/pages/home/home_one/widget/recommended_one_screen.dart' as pages;
import 'package:marketplace_sdk/src/presentation/pages/home/home_three/widgets/recommended_three_screen.dart' as pages;
import 'package:marketplace_sdk/src/presentation/pages/home/home_two/widget/recommended_two_screen.dart' as pages;
import 'package:marketplace_sdk/src/presentation/pages/home/widgets/shops_banner_page.dart' as pages;
import 'package:marketplace_sdk/src/presentation/pages/like/like_page.dart' as pages;
import 'package:marketplace_sdk/src/presentation/pages/profile/address_list.dart' as pages;
import 'package:marketplace_sdk/src/presentation/pages/profile/become_seller/create_shop.dart' as pages;
import 'package:marketplace_sdk/src/presentation/pages/profile/help_page.dart' as pages;
import 'package:marketplace_sdk/src/presentation/pages/profile/notification_page.dart' as pages;
import 'package:marketplace_sdk/src/presentation/pages/profile/profile_page.dart' as pages;
import 'package:marketplace_sdk/src/presentation/pages/profile/share_referral_faq.dart' as pages;
import 'package:marketplace_sdk/src/presentation/pages/profile/share_referral_page.dart' as pages;
import 'package:marketplace_sdk/src/presentation/pages/profile/wallet_history.dart' as pages;
import 'package:marketplace_sdk/src/presentation/pages/search/search_page.dart' as pages;
import 'package:merchants_sdk/src/presentation/pages/shop/shop_detail.dart' as pages;
import 'package:merchants_sdk/src/presentation/pages/shop/shop_page.dart' as pages;
import 'package:onboarding_sdk/src/presentation/pages/intro/intro_page.dart' as pages;
import 'package:orders_sdk/src/presentation/pages/order/order_screen/order_progress_screen.dart' as pages;
import 'package:orders_sdk/src/presentation/pages/order/order_screen/order_screen.dart' as pages;
import 'package:orders_sdk/src/presentation/pages/order/orders_main.dart' as pages;
import 'package:orders_sdk/src/presentation/pages/order/orders_page.dart' as pages;
import 'package:orders_sdk/src/presentation/pages/parcel/parcel_list_page.dart' as pages;
import 'package:orders_sdk/src/presentation/pages/parcel/parcel_order_page.dart' as pages;
import 'package:orders_sdk/src/presentation/pages/parcel/parcel_page.dart' as pages;
import 'package:orders_sdk/src/presentation/pages/parcel/widgets/info_screen.dart' as pages;
import 'package:polaris_sdk/src/presentation/pages/loans/loan_screen.dart' as pages;
import 'package:polaris_sdk/src/presentation/pages/loans/widgets/loan_eligibility_screen.dart' as pages;
import 'package:promotions_sdk/src/presentation/pages/story_page/story_page.dart' as pages;
import 'package:auth_sdk/src/presentation/pages/auth/confirmation/register_confirmation_page.dart' as pages;
import 'package:marketplace_sdk/src/presentation/pages/service/service_two_category_page.dart' as pages;
import 'package:polaris_sdk/src/presentation/pages/loans/widgets/loan_document_upload_screen.dart' as pages;

/// Host route shell for [pages.AddressListPage] (SDK-resident page).
@RoutePage(name: 'AddressListRoute')
class AddressListRouteView extends StatelessWidget {

  const AddressListRouteView({super.key});

  @override
  Widget build(BuildContext context) => pages.AddressListPage();
}

/// Host route shell for [pages.ChatPage] (SDK-resident page).
@RoutePage(name: 'ChatRoute')
class ChatRouteView extends StatelessWidget {
  final String roleId;
  final String name;
  const ChatRouteView({super.key, required this.roleId, required this.name});

  @override
  Widget build(BuildContext context) => pages.ChatPage(roleId: roleId, name: name);
}

/// Host route shell for [pages.ClosedPage] (SDK-resident page).
@RoutePage(name: 'ClosedRoute')
class ClosedRouteView extends StatelessWidget {

  const ClosedRouteView({super.key});

  @override
  Widget build(BuildContext context) => pages.ClosedPage();
}

/// Host route shell for [pages.CreateShopPage] (SDK-resident page).
@RoutePage(name: 'CreateShopRoute')
class CreateShopRouteView extends StatelessWidget {

  const CreateShopRouteView({super.key});

  @override
  Widget build(BuildContext context) => pages.CreateShopPage();
}

/// Host route shell for [pages.HelpPage] (SDK-resident page).
@RoutePage(name: 'HelpRoute')
class HelpRouteView extends StatelessWidget {

  const HelpRouteView({super.key});

  @override
  Widget build(BuildContext context) => pages.HelpPage();
}

/// Host route shell for [pages.InfoPage] (SDK-resident page).
@RoutePage(name: 'InfoRoute')
class InfoRouteView extends StatelessWidget {
  final int index;
  const InfoRouteView({super.key, required this.index});

  @override
  Widget build(BuildContext context) => pages.InfoPage(index: index);
}

/// Host route shell for [pages.IntroPage] (SDK-resident page).
@RoutePage(name: 'IntroRoute')
class IntroRouteView extends StatelessWidget {

  const IntroRouteView({super.key});

  @override
  Widget build(BuildContext context) => pages.IntroPage();
}

/// Host route shell for [pages.LikePage] (SDK-resident page).
@RoutePage(name: 'LikeRoute')
class LikeRouteView extends StatelessWidget {
  final bool isBackButton;
  const LikeRouteView({super.key, this.isBackButton = true});

  @override
  Widget build(BuildContext context) => pages.LikePage(isBackButton: isBackButton);
}

/// Host route shell for [pages.LoanEligibilityScreen] (SDK-resident page).
@RoutePage(name: 'LoanEligibilityRoute')
class LoanEligibilityRouteView extends StatelessWidget {
  final Map<String, dynamic>? financialDetails;
  const LoanEligibilityRouteView({super.key, this.financialDetails});

  @override
  Widget build(BuildContext context) => pages.LoanEligibilityScreen(financialDetails: financialDetails);
}

/// Host route shell for [pages.LoanScreen] (SDK-resident page).
@RoutePage(name: 'LoanRoute')
class LoanRouteView extends StatelessWidget {

  const LoanRouteView({super.key});

  @override
  Widget build(BuildContext context) => pages.LoanScreen();
}

/// Host route shell for [pages.LoginPage] (SDK-resident page).
@RoutePage(name: 'LoginRoute')
class LoginRouteView extends StatelessWidget {

  const LoginRouteView({super.key});

  @override
  Widget build(BuildContext context) => pages.LoginPage();
}

/// Host route shell for [pages.MapSearchPage] (SDK-resident page).
@RoutePage(name: 'MapSearchRoute')
class MapSearchRouteView extends StatelessWidget {

  const MapSearchRouteView({super.key});

  @override
  Widget build(BuildContext context) => pages.MapSearchPage();
}

/// Host route shell for [pages.NoConnectionPage] (SDK-resident page).
@RoutePage(name: 'NoConnectionRoute')
class NoConnectionRouteView extends StatelessWidget {

  const NoConnectionRouteView({super.key});

  @override
  Widget build(BuildContext context) => pages.NoConnectionPage();
}

/// Host route shell for [pages.NotificationListPage] (SDK-resident page).
@RoutePage(name: 'NotificationListRoute')
class NotificationListRouteView extends StatelessWidget {

  const NotificationListRouteView({super.key});

  @override
  Widget build(BuildContext context) => pages.NotificationListPage();
}

/// Host route shell for [pages.OrderProgressPage] (SDK-resident page).
@RoutePage(name: 'OrderProgressRoute')
class OrderProgressRouteView extends StatelessWidget {
  final String? orderId;
  const OrderProgressRouteView({super.key, this.orderId});

  @override
  Widget build(BuildContext context) => pages.OrderProgressPage(orderId: orderId);
}

/// Host route shell for [pages.OrderPage] (SDK-resident page).
@RoutePage(name: 'OrderRoute')
class OrderRouteView extends StatelessWidget {

  const OrderRouteView({super.key});

  @override
  Widget build(BuildContext context) => pages.OrderPage();
}

/// Host route shell for [pages.OrdersListPage] (SDK-resident page).
@RoutePage(name: 'OrdersListRoute')
class OrdersListRouteView extends StatelessWidget {

  const OrdersListRouteView({super.key});

  @override
  Widget build(BuildContext context) => pages.OrdersListPage();
}

/// Host route shell for [pages.OrdersMainPage] (SDK-resident page).
@RoutePage(name: 'OrdersMainRoute')
class OrdersMainRouteView extends StatelessWidget {

  const OrdersMainRouteView({super.key});

  @override
  Widget build(BuildContext context) => pages.OrdersMainPage();
}

/// Host route shell for [pages.ParcelListPage] (SDK-resident page).
@RoutePage(name: 'ParcelListRoute')
class ParcelListRouteView extends StatelessWidget {

  const ParcelListRouteView({super.key});

  @override
  Widget build(BuildContext context) => pages.ParcelListPage();
}

/// Host route shell for [pages.ParcelProgressPage] (SDK-resident page).
@RoutePage(name: 'ParcelProgressRoute')
class ParcelProgressRouteView extends StatelessWidget {
  final String? parcelId;
  const ParcelProgressRouteView({super.key, this.parcelId});

  @override
  Widget build(BuildContext context) => pages.ParcelProgressPage(parcelId: parcelId);
}

/// Host route shell for [pages.ParcelPage] (SDK-resident page).
@RoutePage(name: 'ParcelRoute')
class ParcelRouteView extends StatelessWidget {
  final bool isBackButton;
  const ParcelRouteView({super.key, this.isBackButton = true});

  @override
  Widget build(BuildContext context) => pages.ParcelPage(isBackButton: isBackButton);
}

/// Host route shell for [pages.PolicyPage] (SDK-resident page).
@RoutePage(name: 'PolicyRoute')
class PolicyRouteView extends StatelessWidget {

  const PolicyRouteView({super.key});

  @override
  Widget build(BuildContext context) => pages.PolicyPage();
}

/// Host route shell for [pages.ProfilePage] (SDK-resident page).
@RoutePage(name: 'ProfileRoute')
class ProfileRouteView extends StatelessWidget {
  final dynamic Function()? onCardAdded;
  final bool isBackButton;
  const ProfileRouteView({super.key, this.onCardAdded, this.isBackButton = true});

  @override
  Widget build(BuildContext context) => pages.ProfilePage(onCardAdded: onCardAdded, isBackButton: isBackButton);
}

/// Host route shell for [pages.RecommendedOnePage] (SDK-resident page).
@RoutePage(name: 'RecommendedOneRoute')
class RecommendedOneRouteView extends StatelessWidget {
  final bool isNewsOfPage;
  final bool isShop;
  const RecommendedOneRouteView({super.key, this.isNewsOfPage = false, this.isShop = false});

  @override
  Widget build(BuildContext context) => pages.RecommendedOnePage(isNewsOfPage: isNewsOfPage, isShop: isShop);
}

/// Host route shell for [pages.RecommendedPage] (SDK-resident page).
@RoutePage(name: 'RecommendedRoute')
class RecommendedRouteView extends StatelessWidget {
  final bool isNewsOfPage;
  final bool isShop;
  const RecommendedRouteView({super.key, this.isNewsOfPage = false, this.isShop = false});

  @override
  Widget build(BuildContext context) => pages.RecommendedPage(isNewsOfPage: isNewsOfPage, isShop: isShop);
}

/// Host route shell for [pages.RecommendedThreePage] (SDK-resident page).
@RoutePage(name: 'RecommendedThreeRoute')
class RecommendedThreeRouteView extends StatelessWidget {
  final bool isNewsOfPage;
  final bool isShop;
  final bool isPopular;
  const RecommendedThreeRouteView({super.key, this.isNewsOfPage = false, this.isShop = false, this.isPopular = false});

  @override
  Widget build(BuildContext context) => pages.RecommendedThreePage(isNewsOfPage: isNewsOfPage, isShop: isShop, isPopular: isPopular);
}

/// Host route shell for [pages.RecommendedTwoPage] (SDK-resident page).
@RoutePage(name: 'RecommendedTwoRoute')
class RecommendedTwoRouteView extends StatelessWidget {
  final bool isNewsOfPage;
  final bool isShop;
  final bool isPopular;
  const RecommendedTwoRouteView({super.key, this.isNewsOfPage = false, this.isShop = false, this.isPopular = false});

  @override
  Widget build(BuildContext context) => pages.RecommendedTwoPage(isNewsOfPage: isNewsOfPage, isShop: isShop, isPopular: isPopular);
}

/// Host route shell for [pages.RegisterPage] (SDK-resident page).
@RoutePage(name: 'RegisterRoute')
class RegisterRouteView extends StatelessWidget {
  final bool isOnlyEmail;
  const RegisterRouteView({super.key, required this.isOnlyEmail});

  @override
  Widget build(BuildContext context) => pages.RegisterPage(isOnlyEmail: isOnlyEmail);
}

/// Host route shell for [pages.ResetPasswordPage] (SDK-resident page).
@RoutePage(name: 'ResetPasswordRoute')
class ResetPasswordRouteView extends StatelessWidget {

  const ResetPasswordRouteView({super.key});

  @override
  Widget build(BuildContext context) => pages.ResetPasswordPage();
}

/// Host route shell for [pages.ResultFilterPage] (SDK-resident page).
@RoutePage(name: 'ResultFilterRoute')
class ResultFilterRouteView extends StatelessWidget {
  final String categoryId;
  const ResultFilterRouteView({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) => pages.ResultFilterPage(categoryId: categoryId);
}

/// Host route shell for [pages.SearchPage] (SDK-resident page).
@RoutePage(name: 'SearchRoute')
class SearchRouteView extends StatelessWidget {
  final bool isBackButton;
  const SearchRouteView({super.key, this.isBackButton = true});

  @override
  Widget build(BuildContext context) => pages.SearchPage(isBackButton: isBackButton);
}

/// Host route shell for [pages.SettingPage] (SDK-resident page).
@RoutePage(name: 'SettingRoute')
class SettingRouteView extends StatelessWidget {

  const SettingRouteView({super.key});

  @override
  Widget build(BuildContext context) => pages.SettingPage();
}

/// Host route shell for [pages.ShareReferralFaqPage] (SDK-resident page).
@RoutePage(name: 'ShareReferralFaqRoute')
class ShareReferralFaqRouteView extends StatelessWidget {
  final String terms;
  const ShareReferralFaqRouteView({super.key, required this.terms});

  @override
  Widget build(BuildContext context) => pages.ShareReferralFaqPage(terms: terms);
}

/// Host route shell for [pages.ShareReferralPage] (SDK-resident page).
@RoutePage(name: 'ShareReferralRoute')
class ShareReferralRouteView extends StatelessWidget {

  const ShareReferralRouteView({super.key});

  @override
  Widget build(BuildContext context) => pages.ShareReferralPage();
}

/// Host route shell for [pages.ShopDetailPage] (SDK-resident page).
@RoutePage(name: 'ShopDetailRoute')
class ShopDetailRouteView extends StatelessWidget {
  final ShopData shop;
  final String workTime;
  const ShopDetailRouteView({super.key, required this.shop, required this.workTime});

  @override
  Widget build(BuildContext context) => pages.ShopDetailPage(shop: shop, workTime: workTime);
}

/// Host route shell for [pages.ShopPage] (SDK-resident page).
@RoutePage(name: 'ShopRoute')
class ShopRouteView extends StatelessWidget {
  final String shopId;
  final String? productId;
  final String? cartId;
  final ShopData? shop;
  final String? ownerId;
  const ShopRouteView({super.key, required this.shopId, this.productId, this.cartId, this.shop, this.ownerId});

  @override
  Widget build(BuildContext context) => pages.ShopPage(shopId: shopId, productId: productId, cartId: cartId, shop: shop, ownerId: ownerId);
}

/// Host route shell for [pages.ShopsBannerPage] (SDK-resident page).
@RoutePage(name: 'ShopsBannerRoute')
class ShopsBannerRouteView extends StatelessWidget {
  final int bannerId;
  final String title;
  final bool isAds;
  const ShopsBannerRouteView({super.key, required this.bannerId, required this.title, this.isAds = false});

  @override
  Widget build(BuildContext context) => pages.ShopsBannerPage(bannerId: bannerId, title: title, isAds: isAds);
}

/// Host route shell for [pages.SplashPage] (SDK-resident page).
@RoutePage(name: 'SplashRoute')
class SplashRouteView extends StatelessWidget {

  const SplashRouteView({super.key});

  @override
  Widget build(BuildContext context) => pages.SplashPage();
}

/// Host route shell for [pages.StoryListPage] (SDK-resident page).
@RoutePage(name: 'StoryListRoute')
class StoryListRouteView extends StatelessWidget {
  final int index;
  final RefreshController controller;
  const StoryListRouteView({super.key, required this.index, required this.controller});

  @override
  Widget build(BuildContext context) => pages.StoryListPage(index: index, controller: controller);
}

/// Host route shell for [pages.TermPage] (SDK-resident page).
@RoutePage(name: 'TermRoute')
class TermRouteView extends StatelessWidget {

  const TermRouteView({super.key});

  @override
  Widget build(BuildContext context) => pages.TermPage();
}

/// Host route shell for [pages.UiTypePage] (SDK-resident page).
@RoutePage(name: 'UiTypeRoute')
class UiTypeRouteView extends StatelessWidget {
  final bool isBack;
  const UiTypeRouteView({super.key, this.isBack = false});

  @override
  Widget build(BuildContext context) => pages.UiTypePage(isBack: isBack);
}

/// Host route shell for [pages.ViewMapPage] (SDK-resident page).
@RoutePage(name: 'ViewMapRoute')
class ViewMapRouteView extends StatelessWidget {
  final bool isParcel;
  final bool isPop;
  final bool isShopLocation;
  final String? shopId;
  final int? indexAddress;
  final AddressNewModel? address;
  const ViewMapRouteView({super.key, this.isParcel = false, this.isPop = true, this.isShopLocation = false, this.shopId, this.indexAddress, this.address});

  @override
  Widget build(BuildContext context) => pages.ViewMapPage(isParcel: isParcel, isPop: isPop, isShopLocation: isShopLocation, shopId: shopId, indexAddress: indexAddress, address: address);
}

/// Host route shell for [pages.WalletHistoryPage] (SDK-resident page).
@RoutePage(name: 'WalletHistoryRoute')
class WalletHistoryRouteView extends StatelessWidget {
  final bool isBackButton;
  const WalletHistoryRouteView({super.key, this.isBackButton = true});

  @override
  Widget build(BuildContext context) => pages.WalletHistoryPage(isBackButton: isBackButton);
}

/// Host route shell for [pages.RegisterConfirmationPage] (SDK-resident page).
@RoutePage(name: 'RegisterConfirmationRoute')
class RegisterConfirmationRouteView extends StatelessWidget {
  final UserModel userModel;
  final bool isResetPassword;
  final String verificationId;
  final bool editPhone;
  const RegisterConfirmationRouteView({
    super.key,
    required this.userModel,
    this.isResetPassword = false,
    required this.verificationId,
    this.editPhone = false,
  });

  @override
  Widget build(BuildContext context) => pages.RegisterConfirmationPage(
        userModel: userModel,
        isResetPassword: isResetPassword,
        verificationId: verificationId,
        editPhone: editPhone,
      );
}

/// Host route shell for [pages.ServiceTwoCategoryPage] (SDK-resident page).
@RoutePage(name: 'ServiceTwoCategoryRoute')
class ServiceTwoCategoryRouteView extends StatelessWidget {
  final int index;
  const ServiceTwoCategoryRouteView({super.key, required this.index});

  @override
  Widget build(BuildContext context) => pages.ServiceTwoCategoryPage(index: index);
}

/// Host route shell for [pages.LoanDocumentUploadScreen] (SDK-resident page).
@RoutePage(name: 'LoanDocumentUploadRoute')
class LoanDocumentUploadRouteView extends StatelessWidget {
  final String? prefilledIdNumber;
  const LoanDocumentUploadRouteView({super.key, this.prefilledIdNumber});

  @override
  Widget build(BuildContext context) =>
      pages.LoanDocumentUploadScreen(prefilledIdNumber: prefilledIdNumber);
}
