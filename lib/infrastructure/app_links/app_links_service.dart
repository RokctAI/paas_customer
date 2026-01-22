import 'dart:async';
import 'dart:developer';
import 'package:app_links/app_links.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:foodyman/app_constants.dart';

// Removed unused imports
import 'package:foodyman/presentation/routes/app_router.dart';

abstract class AppLinksService {
  AppLinksService._();

  static late AppLinks _appLinks;
  static StreamSubscription<Uri>? _linkSubscription;

  static Future<void> init(BuildContext context, {bool isMain = false}) async {
    _appLinks = AppLinks();

    // Handle initial link if app was launched from a link
    try {
      final Uri? initialLink = await _appLinks.getInitialLink();
      if (initialLink != null) {
        log("Initial app link: $initialLink");
        if (context.mounted) {
          _handleDeepLink(context, initialLink);
        }
      }
    } catch (e) {
      log("Error getting initial app link: $e");
    }

    // Listen for incoming app links
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (Uri uri) {
        log("Incoming app link: $uri");
        if (context.mounted) {
          _handleDeepLink(context, uri);
        }
      },
      onError: (err) {
        log("Error listening to app links: $err");
      },
    );
  }

  static void _handleDeepLink(BuildContext context, Uri uri) {
    final String path = uri.path;
    final Map<String, String> queryParams = uri.queryParameters;

    log("Handling deep link - Path: $path, Query params: $queryParams");

    // Handle group order links (same as Firebase Dynamic Links)
    if (queryParams.containsKey('group') || path.contains('group')) {
      context.router.popUntilRoot();
      context.pushRoute(
        ShopRoute(
          shopId: uri.pathSegments.last,
          cartId: queryParams['group'] ?? queryParams['g'],
          ownerId: int.tryParse(
            queryParams['owner_id'] ?? queryParams['o'] ?? '',
          ),
        ),
      );
      return;
    }

    // Handle shop links (same as Firebase Dynamic Links)
    if (path.contains('shop') || path.contains('restaurant')) {
      if (!queryParams.containsKey('product')) {
        // Shop only
        context.router.popUntilRoot();
        context.pushRoute(ShopRoute(shopId: uri.pathSegments.last));
      } else {
        // Shop with product
        context.router.popUntilRoot();
        context.pushRoute(
          ShopRoute(
            shopId: uri.pathSegments.last,
            productId: queryParams['product'],
          ),
        );
      }
      return;
    }

    // Handle legacy shop links with query parameters
    if (queryParams.containsKey('shop_id')) {
      final String? shopIdStr = queryParams['shop_id'];
      if (shopIdStr != null) {
        final int? shopId = int.tryParse(shopIdStr);
        if (shopId != null) {
          context.pushRoute(ShopRoute(shopId: shopId.toString()));
          return;
        }
      }
    }

    // Handle product links
    if (queryParams.containsKey('product_id')) {
      final String? productId = queryParams['product_id'];
      final String? shopId = queryParams['shop_id'];
      log("Product deep link: $productId, shop: $shopId");
      if (shopId != null) {
        context.pushRoute(ShopRoute(shopId: shopId, productId: productId));
      }
      return;
    }

    // Handle category links
    if (queryParams.containsKey('category_id')) {
      final String? categoryId = queryParams['category_id'];
      final String? shopId = queryParams['shop_id'];
      log("Category deep link: $categoryId, shop: $shopId");
      // Add your category navigation logic here
      return;
    }

    log("Unhandled deep link: $uri");
  }

  static void showJoin(BuildContext context, Uri? link) {
    // TODO: Implement join dialog for group orders
    log("Show join dialog for link: $link");
  }

  static void dispose() {
    _linkSubscription?.cancel();
  }

  /// Create a deep link URL for sharing using appslink
  static String createDeepLink({
    required String path,
    required Map<String, String> parameters,
  }) {
    final Uri uri = Uri(
      scheme: 'https',
      host: AppConstants.deepLinkHost,
      path: path,
      queryParameters: parameters,
    );
    return uri.toString();
  }
}
