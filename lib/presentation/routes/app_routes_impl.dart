import 'package:auto_route/auto_route.dart';
import 'package:base_sdk/base_sdk.dart';
import 'package:base_sdk/src/navigation/app_routes.dart';
import 'package:flutter/widgets.dart';
import 'package:foodyman/presentation/routes/app_router.dart';

/// Host-side implementation of [AppRoutes] over the generated router.
class AppRoutesImpl implements AppRoutes {
  @override
  Future<Object?> pushAddressListRoute(BuildContext context) =>
      context.router.push(AddressListRoute());
  @override
  Future<Object?> pushChatRoute(BuildContext context, {dynamic name, dynamic roleId}) =>
      context.router.push(ChatRoute(name: name, roleId: roleId));
  @override
  Future<Object?> replaceClosedRoute(BuildContext context) =>
      context.router.replace(ClosedRoute());
  @override
  Future<Object?> pushCreateShopRoute(BuildContext context) =>
      context.router.push(CreateShopRoute());
  @override
  Future<Object?> pushHelpRoute(BuildContext context) =>
      context.router.push(HelpRoute());
  @override
  Future<Object?> pushInfoRoute(BuildContext context, {dynamic index}) =>
      context.router.push(InfoRoute(index: index));
  @override
  Future<Object?> replaceInfoRoute(BuildContext context, {dynamic index}) =>
      context.router.replace(InfoRoute(index: index));
  @override
  Future<Object?> pushLikeRoute(BuildContext context) =>
      context.router.push(LikeRoute());
  @override
  Future<Object?> pushLoginRoute(BuildContext context) =>
      context.router.push(LoginRoute());
  @override
  Future<Object?> replaceLoginRoute(BuildContext context) =>
      context.router.replace(LoginRoute());
  @override
  Future<Object?> pushMapSearchRoute(BuildContext context) =>
      context.router.push(MapSearchRoute());
  @override
  Future<Object?> replaceNoConnectionRoute(BuildContext context) =>
      context.router.replace(NoConnectionRoute());
  @override
  Future<Object?> pushNotificationListRoute(BuildContext context) =>
      context.router.push(NotificationListRoute());
  @override
  Future<Object?> pushOrderProgressRoute(BuildContext context, {dynamic orderId}) =>
      context.router.push(OrderProgressRoute(orderId: orderId));
  @override
  Future<Object?> pushOrderRoute(BuildContext context) =>
      context.router.push(OrderRoute());
  @override
  Future<Object?> pushOrdersListRoute(BuildContext context) =>
      context.router.push(OrdersListRoute());
  @override
  Future<Object?> replaceOrdersListRoute(BuildContext context) =>
      context.router.replace(OrdersListRoute());
  @override
  Future<Object?> pushParcelListRoute(BuildContext context) =>
      context.router.push(ParcelListRoute());
  @override
  Future<Object?> replaceParcelListRoute(BuildContext context) =>
      context.router.replace(ParcelListRoute());
  @override
  Future<Object?> pushParcelProgressRoute(BuildContext context, {dynamic parcelId}) =>
      context.router.push(ParcelProgressRoute(parcelId: parcelId));
  @override
  Future<Object?> pushParcelRoute(BuildContext context) =>
      context.router.push(ParcelRoute());
  @override
  Future<Object?> pushProfileRoute(BuildContext context) =>
      context.router.push(ProfileRoute());
  @override
  Future<Object?> pushRecommendedOneRoute(BuildContext context, {dynamic isNewsOfPage, dynamic isShop}) =>
      context.router.push(RecommendedOneRoute(isNewsOfPage: isNewsOfPage, isShop: isShop));
  @override
  Future<Object?> pushRecommendedRoute(BuildContext context, {dynamic isShop, dynamic isNewsOfPage}) =>
      context.router.push(RecommendedRoute(isShop: isShop ?? false, isNewsOfPage: isNewsOfPage ?? false));
  @override
  Future<Object?> pushRecommendedThreeRoute(BuildContext context, {dynamic isNewsOfPage, dynamic isShop}) =>
      context.router.push(RecommendedThreeRoute(isNewsOfPage: isNewsOfPage, isShop: isShop));
  @override
  Future<Object?> pushRecommendedTwoRoute(BuildContext context, {dynamic isNewsOfPage, dynamic isPopular, dynamic isShop}) =>
      context.router.push(RecommendedTwoRoute(isNewsOfPage: isNewsOfPage, isPopular: isPopular, isShop: isShop));
  @override
  Future<Object?> pushResultFilterRoute(BuildContext context, {dynamic categoryId}) =>
      context.router.push(ResultFilterRoute(categoryId: categoryId));
  @override
  Future<Object?> pushSearchRoute(BuildContext context) =>
      context.router.push(SearchRoute());
  @override
  Future<Object?> pushServiceTwoCategoryRoute(BuildContext context, {dynamic index}) =>
      context.router.push(ServiceTwoCategoryRoute(index: index));
  @override
  Future<Object?> pushSettingRoute(BuildContext context) =>
      context.router.push(SettingRoute());
  @override
  Future<Object?> pushShareReferralFaqRoute(BuildContext context, {dynamic terms}) =>
      context.router.push(ShareReferralFaqRoute(terms: terms));
  @override
  Future<Object?> pushShareReferralRoute(BuildContext context) =>
      context.router.push(ShareReferralRoute());
  @override
  Future<Object?> pushShopDetailRoute(BuildContext context, {dynamic shop, dynamic workTime}) =>
      context.router.push(ShopDetailRoute(shop: shop, workTime: workTime));
  @override
  Future<Object?> pushShopRoute(BuildContext context, {dynamic productId, dynamic shop, dynamic shopId}) =>
      context.router.push(ShopRoute(productId: productId, shop: shop, shopId: shopId));
  @override
  Future<Object?> replaceShopRoute(BuildContext context, {dynamic productId, dynamic shop, dynamic shopId}) =>
      context.router.replace(ShopRoute(productId: productId, shop: shop, shopId: shopId));
  @override
  Future<Object?> replaceMainRoute(BuildContext context) =>
      context.router.replace(const MainRoute());
  @override
  Future<Object?> pushShopsBannerRoute(BuildContext context, {dynamic bannerId, dynamic isAds, dynamic title}) =>
      context.router.push(ShopsBannerRoute(bannerId: bannerId, isAds: isAds, title: title));
  @override
  Future<Object?> replaceSplashRoute(BuildContext context) =>
      context.router.replace(SplashRoute());
  @override
  Future<Object?> pushStoryListRoute(BuildContext context, {dynamic controller, dynamic index}) =>
      context.router.push(StoryListRoute(controller: controller, index: index));
  @override
  Future<Object?> replaceUiTypeRoute(BuildContext context) =>
      context.router.replace(UiTypeRoute());
  @override
  Future<Object?> pushViewMapRoute(BuildContext context, {dynamic address, dynamic indexAddress, dynamic isParcel, dynamic isPop, dynamic isShopLocation, dynamic shopId}) =>
      context.router.push(ViewMapRoute(address: address, indexAddress: indexAddress, isParcel: isParcel, isPop: isPop, isShopLocation: isShopLocation, shopId: shopId));
  @override
  Future<Object?> pushWalletHistoryRoute(BuildContext context) =>
      context.router.push(WalletHistoryRoute());
}
