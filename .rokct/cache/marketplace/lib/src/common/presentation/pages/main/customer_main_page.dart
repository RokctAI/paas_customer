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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proste_indexed_stack/proste_indexed_stack.dart';
import 'package:remixicon/remixicon.dart';

import 'package:base_sdk/base_sdk.dart'
    show
        AppConstants,
        AppRoutes,
        FloatingBottomNav,
        FloatingNavAction,
        FloatingNavProfile,
        FloatingNavTab,
        FloatingNavTabsMode,
        LocalStorage;
import 'package:base_sdk/src/application/home/home_provider.dart';
import 'package:base_sdk/src/application/main/main_provider.dart';
import 'package:base_sdk/src/application/shop_order/shop_order_provider.dart';
import 'package:base_sdk/src/models/data/cart_data.dart';
import 'package:base_sdk/src/presentation/components/keyboard_dismisser.dart';
import 'package:base_sdk/src/presentation/pages/profile/generic_profile_page.dart';
import 'package:base_sdk/src/presentation/theme/app_style.dart';
import 'package:base_sdk/src/services/app_helpers.dart';
import 'package:base_sdk/src/services/tr_keys.dart';
import 'package:base_sdk/src/guide/guide_anchor.dart';
import 'package:base_sdk/src/guide/guide_definition.dart';
import 'package:base_sdk/src/guide/guide_host.dart';

import '../home/home_four/home_page_four.dart';
import '../home/home_zero/home_page.dart';
import '../like/like_page.dart';
import '../search/search_page.dart';

const GuideDefinition marketplaceCartGuide = GuideDefinition(id: 'marketplace.cart', steps: [GuideStep(id: 'marketplace.cart.open', anchor: 'marketplace.cart', title: 'Your cart', body: 'Tap Cart to see what you have added.')]);

/// The customer app's main destination — marketplace_sdk is the customer
/// home SDK, so it owns the surface `AppHelpers.goHome()` lands on
/// (`AppRoutes.replaceMainRoute`, declared in this SDK's manifest the same
/// way merchants_sdk owns the manager `/main`).
///
/// Until this landed the customer compose had NO main route at all — the
/// route table carried only the auth/initial/profile shells — so every
/// goHome() call (post-login, post-registration, guest Skip) threw
/// `_HostAppRoutes`' noSuchMethod StateError and the user was stranded on
/// whatever screen was up (after registering: the registration-steps
/// shell's one-frame spinner, which is exactly the endless "loading icon
/// instead of the home shimmers" report this page fixes — with a real home
/// to land on, the home page's own shimmer placeholders show while its
/// content loads).
///
/// The FLOATING NAV is back (Ray, 2026-10-12: "then let marketplace use
/// floating nav"). The lean page this replaced drew a docked Material bar;
/// the legacy paas_customer shell (main_page.dart before the 2026-08-24
/// re-fork) floated base_sdk's pill over the page instead, with the
/// person's picture as its last entry, a basket button beside it with the
/// cart count, and, in fixed-nav builds, a "you are shopping at" bar above
/// it. All three are restored on base_sdk's FloatingBottomNav
/// (FloatingNavTabsMode.profile and .companion, base_sdk >= 1.87.0).
///
/// Still lean in what it routes to (parcel, wallet history, service tabs
/// and the one/two/three ui-type navigators are not here): Home, Search
/// and Liked are tabs, and the picture is the fourth destination.
/// Home follows the backend `ui_type` setting the way the legacy shell did
/// for the two variants this SDK kept (home_zero default, home_four for
/// type 4); the retired one/two/three variants fall back to home_zero.
/// Tabs are lazy (preload only Home) so the search/like/profile providers
/// don't all fetch at boot.
class CustomerMainPage extends ConsumerWidget {
  const CustomerMainPage({super.key});

  /// The profile's index in the stack. Not one of the pill's tabs: the
  /// picture is drawn as [FloatingNavTabsMode.profile].
  static const int profileIndex = 3;

  /// Key the tests and the guided tour use to find the cart button.
  static const Key cartKey = ValueKey<String>('customer-nav-cart');

  /// Key for the "you are shopping at" bar.
  static const Key cartBarKey = ValueKey<String>('customer-nav-cart-bar');

  /// The page sits under its own GuideHost, so its coach-mark shows here only
  /// and never in the app's MaterialApp builder.
  @override
  Widget build(BuildContext context, WidgetRef ref) => GuideHost(definition: marketplaceCartGuide, child: _buildPage(context, ref));

  Widget _buildPage(BuildContext context, WidgetRef ref) {
    final int selectedIndex = ref.watch(
      mainProvider.select((state) => state.selectIndex),
    );
    final Cart? cart = ref.watch(shopOrderProvider.select((s) => s.cart));
    final int cartCount = cartItemCount(cart);
    final bool signedIn = LocalStorage.getToken().isNotEmpty;
    final mainNotifier = ref.read(mainProvider.notifier);

    void select(int index) {
      mainNotifier.changeScrolling(false);
      mainNotifier.selectIndex(index);
    }

    // Signed out, the basket and the bar go to sign-in first, as the
    // legacy shell's did; the order page needs a session.
    void openCart() {
      if (!signedIn) {
        AppRoutes.I.pushLoginRoute(context);
        return;
      }
      AppRoutes.I.pushOrderRoute(context);
    }

    // The legacy rule: with a scrolling (non-fixed) nav the basket only
    // shows once something is in the cart; a fixed nav always shows it.
    final bool showCart = AppConstants.fixed || cartCount > 0;

    return KeyboardDismisser(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Positioned.fill(
              child: ProsteIndexedStack(
                index: selectedIndex,
                children: [
                  IndexedStackChild(
                    child: AppHelpers.getType() == 4
                        ? const HomePageFour()
                        : const HomePage(),
                    preload: true,
                  ),
                  IndexedStackChild(
                    child: const SearchPage(isBackButton: false),
                  ),
                  IndexedStackChild(
                    child: const LikePage(isBackButton: false),
                  ),
                  IndexedStackChild(child: const GenericProfilePage()),
                ],
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (AppConstants.fixed && cartCount > 0)
                      _CartBar(
                        key: cartBarKey,
                        shopName: _cartShopName(cart, ref),
                        totalPrice: cart?.totalPrice,
                        onTap: openCart,
                      ),
                    // Coach-mark target for the cart step: a zero-height anchor
                    // at the top of the nav, so the bubble sits above it and
                    // the layout is unchanged.
                    const GuideAnchor(id: 'marketplace.cart', child: SizedBox.shrink()),
                    FloatingBottomNav(
                      mode: FloatingNavTabsMode(
                        tabs: [
                          FloatingNavTab(
                            selectIcon: Remix.home_5_fill,
                            unSelectIcon: Remix.home_5_line,
                            label: AppHelpers.getTranslation(TrKeys.home),
                          ),
                          FloatingNavTab(
                            selectIcon: Remix.search_2_fill,
                            unSelectIcon: Remix.search_2_line,
                            label: AppHelpers.getTranslation(TrKeys.search),
                          ),
                          FloatingNavTab(
                            selectIcon: Remix.heart_3_fill,
                            unSelectIcon: Remix.heart_3_line,
                            label: AppHelpers.getTranslation(TrKeys.liked),
                          ),
                        ],
                        currentIndex: selectedIndex,
                        onSelect: select,
                        profile: FloatingNavProfile(
                          user: signedIn ? LocalStorage.getUser() : null,
                          label: AppHelpers.getTranslation(
                            signedIn ? TrKeys.profile : TrKeys.login,
                          ),
                          active: selectedIndex == profileIndex,
                          // Signed out the picture is the way in: home stays
                          // underneath and the login page goes on top.
                          onTap: () {
                            if (!signedIn) {
                              select(0);
                              AppRoutes.I.pushLoginRoute(context);
                              return;
                            }
                            select(profileIndex);
                          },
                        ),
                        companion: showCart
                            ? FloatingNavAction(
                                icon: Remix.shopping_basket_2_fill,
                                label: AppHelpers.getTranslation(TrKeys.cart),
                                badgeCount: cartCount,
                                onTap: openCart,
                              )
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// How many lines the current cart holds: the first user cart's details,
  /// the count the legacy basket badge showed.
  static int cartItemCount(Cart? cart) {
    final carts = cart?.userCarts;
    if (carts == null || carts.isEmpty) return 0;
    return carts.first.cartDetails?.length ?? 0;
  }

  /// The name of the shop the cart belongs to, looked up among the shops
  /// home already loaded, as the legacy bar did. Empty when not found.
  static String _cartShopName(Cart? cart, WidgetRef ref) {
    final String? shopId = cart?.shopId;
    if (shopId == null) return '';
    final home = ref.watch(homeProvider);
    for (final shops in [
      home.shops,
      home.newShops,
      home.allShops,
      home.shopsRecommend,
      home.filterShops,
    ]) {
      for (final shop in shops) {
        if (shop.id == shopId) return shop.translation?.title ?? '';
      }
    }
    return '';
  }
}

/// The customer floating nav on a PUSHED profile (a single pane): Home,
/// Search and Liked with the person's picture lit, instead of a bare back
/// pill (standing rule, Ray 2026-10-30). [onSelect] gets the tab index.
class CustomerProfileNav extends StatelessWidget {
  final ValueChanged<int> onSelect;

  const CustomerProfileNav({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return FloatingBottomNav(
      mode: FloatingNavTabsMode(
        tabs: [
          FloatingNavTab(
            selectIcon: Remix.home_5_fill,
            unSelectIcon: Remix.home_5_line,
            label: AppHelpers.getTranslation(TrKeys.home),
          ),
          FloatingNavTab(
            selectIcon: Remix.search_2_fill,
            unSelectIcon: Remix.search_2_line,
            label: AppHelpers.getTranslation(TrKeys.search),
          ),
          FloatingNavTab(
            selectIcon: Remix.heart_3_fill,
            unSelectIcon: Remix.heart_3_line,
            label: AppHelpers.getTranslation(TrKeys.liked),
          ),
        ],
        // No tab is current: the picture is.
        currentIndex: -1,
        onSelect: onSelect,
        profile: FloatingNavProfile(
          user: LocalStorage.getUser(),
          label: AppHelpers.getTranslation(TrKeys.profile),
          active: true,
          onTap: () {},
        ),
      ),
    );
  }
}

/// The legacy shell's "you are shopping at" bar: the cart's shop and its
/// total, drawn above the floating nav in fixed-nav builds while the cart
/// has something in it. Tapping it opens the order, like the basket.
class _CartBar extends StatelessWidget {
  final String shopName;
  final num? totalPrice;
  final VoidCallback onTap;

  const _CartBar({
    super.key,
    required this.shopName,
    required this.totalPrice,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.8,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: AppStyle.primary.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                '${AppHelpers.getTranslation(TrKeys.shopping)} $shopName',
                style: AppStyle.interRegular(size: 14, color: AppStyle.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              AppHelpers.numberFormat(number: totalPrice),
              style: AppStyle.interSemi(size: 16, color: AppStyle.white),
            ),
          ],
        ),
      ),
    );
  }
}
