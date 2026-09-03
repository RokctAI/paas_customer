// Copyright (c) 2026 ROKCT INTELLIGENCE (PTY) LTD
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published
// by the Free Software Foundation, version 3.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.


// ignore_for_file: unused_result

// Host-side route shell + profile-host wiring for marketplace_sdk.
//
// auto_route's generator only scans the host package, so the SDK-resident
// profile host is wrapped in a thin @RoutePage shell here (the same pattern
// as base_sdk's route_pages.dart and lms_sdk's lms_route_pages.dart).
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:base_sdk/src/application/profile/profile_provider.dart';
import 'package:base_sdk/src/application/shop_order/shop_order_provider.dart';
import 'package:base_sdk/src/navigation/app_routes.dart';
import 'package:base_sdk/src/presentation/components/buttons/pop_button.dart';
import 'package:base_sdk/src/presentation/pages/profile/generic_profile_page.dart'
    as pages;
import 'package:base_sdk/src/presentation/pages/profile/profile_section_registry.dart';
import 'package:marketplace_sdk/src/common/presentation/pages/home/home_zero/filter/result_filter.dart';
import 'package:marketplace_sdk/src/common/presentation/pages/home/home_zero/widgets/recommended_one_screen.dart';
import 'package:marketplace_sdk/src/common/presentation/pages/home/home_zero/widgets/recommended_screen.dart';
import 'package:marketplace_sdk/src/common/presentation/pages/home/home_zero/widgets/recommended_three_screen.dart';
import 'package:marketplace_sdk/src/common/presentation/pages/home/home_zero/widgets/recommended_two_screen.dart';
import 'package:marketplace_sdk/src/common/presentation/pages/home/home_zero/widgets/shops_banner_page.dart';
import 'package:marketplace_sdk/src/common/presentation/pages/like/like_page.dart';
import 'package:marketplace_sdk/src/common/presentation/pages/main/customer_main_page.dart';
import 'package:marketplace_sdk/src/common/presentation/pages/profile/address_list.dart';
import 'package:marketplace_sdk/src/common/presentation/pages/profile/become_seller/create_shop.dart';
import 'package:marketplace_sdk/src/common/presentation/pages/profile/help_page.dart';
import 'package:marketplace_sdk/src/common/presentation/pages/profile/marketplace_profile_sections.dart';
import 'package:marketplace_sdk/src/common/presentation/pages/profile/notification_page.dart';
import 'package:marketplace_sdk/src/common/presentation/pages/profile/share_referral_faq.dart';
import 'package:marketplace_sdk/src/common/presentation/pages/profile/share_referral_page.dart';
import 'package:marketplace_sdk/src/common/presentation/pages/profile/widgets/my_account.dart';
import 'package:marketplace_sdk/src/common/presentation/pages/search/search_page.dart';

/// Registers every marketplace profile section with base_sdk's
/// [ProfileSectionRegistry] — called once at boot from this SDK's
/// `di_hooks` manifest entry. Everything routes through base_sdk seams
/// (AppRoutes / EmbeddedWidgets), so no generated route class is needed
/// here beyond the shell below.
void registerMarketplaceProfileSections() {
  // Header edit affordance (the in-card pencil): MyAccount is the settings
  // hub that carries Edit account (plus password/addresses/notifications/
  // language/currency) — the mapping that shipped with the host adoption.
  // The old identity-strip settings gear itself is back as the header
  // card's corner slot with the same MyAccount action (see
  // MarketplaceSettingsCorner in marketplace_profile_sections.dart).
  ProfileSectionRegistry.I.onEditProfile = (context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MyAccount(isBackButton: false),
      ),
    );
  };

  // Top-row sign-out affordance — the confirmed branch of the old page's
  // DeleteScreen dialog, verbatim; the host page already ran its own
  // logout confirmation, so no second dialog.
  ProfileSectionRegistry.I.onLogout = (context) {
    MarketplaceNotificationsAction.cancelNotificationTimer();
    final container = ProviderScope.containerOf(context, listen: false);
    container.read(profileProvider.notifier).logOut();
    container.refresh(shopOrderProvider);
    container.refresh(profileProvider);
    context.router.popUntilRoot();
    AppRoutes.I.replaceLoginRoute(context);
  };

  MarketplaceProfileSections.register();
}

/// Host route shell for the customer profile, now rendering base_sdk's
/// generic profile host. Route name (ProfileRoute) and constructor params
/// match the deprecated marketplace ProfilePage, so existing navigation
/// call-sites keep working; the sections come from
/// [registerMarketplaceProfileSections].
@RoutePage(name: 'ProfileRoute')
class ProfileRouteView extends StatelessWidget {
  final bool isBackButton;
  final Function()? onCardAdded;

  const ProfileRouteView({
    super.key,
    this.onCardAdded,
    this.isBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    // Sections are registered at boot; the per-navigation card-added
    // callback rides this slot instead of a constructor param.
    MarketplaceProfileSections.onCardAdded = onCardAdded;
    return Stack(
      children: [
        const pages.GenericProfilePage(),
        // The old page's floating back button (FAB startFloat + 16.w pad).
        if (isBackButton)
          Positioned(
            left: 32.w,
            bottom: 16.h,
            child: const SafeArea(child: PopButton()),
          ),
      ],
    );
  }
}

/// Host route shell for the customer app's main destination (the customer
/// twin of merchants_sdk's manager MainRoute): marketplace_sdk is the
/// customer home SDK, so it owns the surface `AppHelpers.goHome()` lands
/// on. Declared as `/main` + `replaceMainRoute` in this SDK's manifest —
/// before this shell the customer compose had no main route at all, and
/// every post-login / post-registration / guest-skip goHome() threw
/// _HostAppRoutes' noSuchMethod StateError, stranding the user (after
/// registering: on the registration-steps shell's spinner).
@RoutePage(name: 'MainRoute')
class MainRouteView extends StatelessWidget {
  const MainRouteView({super.key});

  @override
  Widget build(BuildContext context) => const CustomerMainPage();
}

// ---------------------------------------------------------------------------
// The rest of the pre-fork customer route table (fix-wave 2026-09-02 route
// map, rows 14/18-20/22/24/26/27/29/30/32/34/37/40): one shell per
// marketplace-owned page, named exactly as base_sdk's AppRoutes seam expects
// (`pushSearchRoute` -> SearchRoute, ...), paths unchanged from
// paas_customer so deep links keep resolving. WalletHistoryPage is
// deliberately NOT declared here: wallet_sdk's `/wallet-history`
// (WalletHistoryRoute) is canonical and a second declaration would clash in
// the generated router. NotificationListRoute is the same class name comms_sdk
// uses for its manager/driver `/list-notification`; that only collides if
// comms ever gains a customer block (recorded in the fix plan).
// ---------------------------------------------------------------------------

/// `/searchPage`
@RoutePage(name: 'SearchRoute')
class SearchRouteView extends StatelessWidget {
  final bool isBackButton;

  const SearchRouteView({super.key, this.isBackButton = true});

  @override
  Widget build(BuildContext context) => SearchPage(isBackButton: isBackButton);
}

/// `/recommended`
@RoutePage(name: 'RecommendedRoute')
class RecommendedRouteView extends StatelessWidget {
  final bool isNewsOfPage;
  final bool isShop;

  const RecommendedRouteView({
    super.key,
    this.isNewsOfPage = false,
    this.isShop = false,
  });

  @override
  Widget build(BuildContext context) =>
      RecommendedPage(isNewsOfPage: isNewsOfPage, isShop: isShop);
}

/// `/recommended_one`
@RoutePage(name: 'RecommendedOneRoute')
class RecommendedOneRouteView extends StatelessWidget {
  final bool isNewsOfPage;
  final bool isShop;

  const RecommendedOneRouteView({
    super.key,
    this.isNewsOfPage = false,
    this.isShop = false,
  });

  @override
  Widget build(BuildContext context) =>
      RecommendedOnePage(isNewsOfPage: isNewsOfPage, isShop: isShop);
}

/// `/recommended_two`
@RoutePage(name: 'RecommendedTwoRoute')
class RecommendedTwoRouteView extends StatelessWidget {
  final bool isNewsOfPage;
  final bool isShop;
  final bool isPopular;

  const RecommendedTwoRouteView({
    super.key,
    this.isNewsOfPage = false,
    this.isShop = false,
    this.isPopular = false,
  });

  @override
  Widget build(BuildContext context) => RecommendedTwoPage(
        isNewsOfPage: isNewsOfPage,
        isShop: isShop,
        isPopular: isPopular,
      );
}

/// `/recommended_three`
@RoutePage(name: 'RecommendedThreeRoute')
class RecommendedThreeRouteView extends StatelessWidget {
  final bool isNewsOfPage;
  final bool isShop;
  final bool isPopular;

  const RecommendedThreeRouteView({
    super.key,
    this.isNewsOfPage = false,
    this.isShop = false,
    this.isPopular = false,
  });

  @override
  Widget build(BuildContext context) => RecommendedThreePage(
        isNewsOfPage: isNewsOfPage,
        isShop: isShop,
        isPopular: isPopular,
      );
}

/// `/help`
@RoutePage(name: 'HelpRoute')
class HelpRouteView extends StatelessWidget {
  const HelpRouteView({super.key});

  @override
  Widget build(BuildContext context) => const HelpPage();
}

/// `/result_filter`
@RoutePage(name: 'ResultFilterRoute')
class ResultFilterRouteView extends StatelessWidget {
  final String categoryId;

  const ResultFilterRouteView({
    super.key,
    @QueryParam('categoryId') this.categoryId = '',
  });

  @override
  Widget build(BuildContext context) =>
      ResultFilterPage(categoryId: categoryId);
}

/// `/create_shop`
@RoutePage(name: 'CreateShopRoute')
class CreateShopRouteView extends StatelessWidget {
  const CreateShopRouteView({super.key});

  @override
  Widget build(BuildContext context) => const CreateShopPage();
}

/// `/shops_banner`
@RoutePage(name: 'ShopsBannerRoute')
class ShopsBannerRouteView extends StatelessWidget {
  final String bannerId;
  final String title;
  final bool isAds;

  const ShopsBannerRouteView({
    super.key,
    @QueryParam('bannerId') this.bannerId = '',
    @QueryParam('title') this.title = '',
    this.isAds = false,
  });

  @override
  Widget build(BuildContext context) =>
      ShopsBannerPage(bannerId: bannerId, title: title, isAds: isAds);
}

/// `/share_referral`
@RoutePage(name: 'ShareReferralRoute')
class ShareReferralRouteView extends StatelessWidget {
  const ShareReferralRouteView({super.key});

  @override
  Widget build(BuildContext context) => const ShareReferralPage();
}

/// `/share_referral_faq`
@RoutePage(name: 'ShareReferralFaqRoute')
class ShareReferralFaqRouteView extends StatelessWidget {
  final String terms;

  const ShareReferralFaqRouteView({super.key, this.terms = ''});

  @override
  Widget build(BuildContext context) => ShareReferralFaqPage(terms: terms);
}

/// `/notification_list_page`
@RoutePage(name: 'NotificationListRoute')
class NotificationListRouteView extends StatelessWidget {
  const NotificationListRouteView({super.key});

  @override
  Widget build(BuildContext context) => const NotificationListPage();
}

/// `/like_page`
@RoutePage(name: 'LikeRoute')
class LikeRouteView extends StatelessWidget {
  final bool isBackButton;

  const LikeRouteView({super.key, this.isBackButton = true});

  @override
  Widget build(BuildContext context) => LikePage(isBackButton: isBackButton);
}

/// `/address_list_page`
@RoutePage(name: 'AddressListRoute')
class AddressListRouteView extends StatelessWidget {
  const AddressListRouteView({super.key});

  @override
  Widget build(BuildContext context) => const AddressListPage();
}
