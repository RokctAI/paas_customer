// Copyright (c) 2026 ROKCT INTELLIGENCE (PTY) LTD
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import 'package:base_sdk/src/models/data/product_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:base_sdk/src/application/shop_order/shop_order_provider.dart';

import 'package:base_sdk/src/services/app_helpers.dart';
import 'package:base_sdk/src/domain/interface/product_detail_sheet.dart';
import 'package:get_it/get_it.dart';
import 'package:base_sdk/src/utils/products/brand_utils.dart';
import 'package:base_sdk/src/utils/products/product_card.dart';
import 'package:base_sdk/src/utils/products/product_utils.dart';

class DiscountedProductsSection extends ConsumerWidget {
  final List<ProductData> products;
  final String? cartId;

  const DiscountedProductsSection({
    super.key,
    required this.products,
    this.cartId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shopOrderState = ref.watch(shopOrderProvider);

    // Filter for products with valid discounts
    final validDiscountProducts = products.where((product) {
      return ProductUtils.hasValidActiveDiscount(product);
    }).toList();

    // Debug information
    debugPrint("Building DiscountedProductsSection");
    debugPrint("Products count: ${products.length}");
    debugPrint("Valid discount products: ${validDiscountProducts.length}");

    // Filter for products from shops that are available
    final filteredProducts = validDiscountProducts.where((product) {
      final shopName = BrandUtils.getShopNameFromId(product.shopId, ref);
      return shopName != null;
    }).toList();

    return SizedBox(
      height: 200.h,
      child: AnimationLimiter(
        child: ListView.builder(
          padding: EdgeInsets.only(left: 16.w, right: 16.w),
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: filteredProducts.length,
          itemBuilder: (context, index) {
            final product = filteredProducts[index];
            final String imageUrl = product.img ?? "";
            final bool isTransparentFormat =
                ProductUtils.hasTransparentBackground(imageUrl);

            // Get cart quantity
            int cartQuantity = 0;
            if (shopOrderState.cart != null) {
              for (var userCart in shopOrderState.cart!.userCarts ?? []) {
                if (userCart.cartDetails != null) {
                  for (var cartDetail in userCart.cartDetails!) {
                    if (cartDetail.stock?.id == product.stock?.id) {
                      final qtyInt =
                          int.tryParse(cartDetail.quantity.toString()) ?? 0;
                      cartQuantity += qtyInt;
                    }
                  }
                }
              }
            }

            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(
                  child: Container(
                    width: 150.w,
                    margin: EdgeInsets.only(right: 12.w),
                    child: GestureDetector(
                      onTap: () {
                        _openProductDetail(context, product);
                      },
                      child: ProductCard(
                        product: product,
                        hasTransparentBg: isTransparentFormat,
                        cartQuantity: cartQuantity,
                        cartId: cartId,
                        onTap: () {
                          _openProductDetail(context, product);
                        },
                        showShopName: true,
                        canAddDirectly: _hasSimpleExtrasAddons(product),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Opens the product detail sheet via base_sdk's [ProductDetailSheet]
  /// seam. The page itself lives in products_sdk, which ADR-005 forbids
  /// importing from here; apps that compose products_sdk register an
  /// implementation at startup. Unregistered (an app that doesn't sell
  /// products) leaves the tap inert rather than crashing.
  void _openProductDetail(BuildContext context, ProductData product) {
    if (!GetIt.instance.isRegistered<ProductDetailSheet>()) return;
    final sheet = GetIt.instance.get<ProductDetailSheet>();
    AppHelpers.showCustomModalBottomDragSheet(
      context: context,
      modal: (c) => sheet.build(
        context,
        controller: c,
        data: product,
        cartId: cartId,
      ),
      isDarkMode: false,
      isDrag: true,
      radius: 16,
    );
  }

  // Function to check if a product has simple options,
  // now only used to pass to ProductCard for canAddDirectly property

  // Check if product has simple extras/addons (only one option per group)
  bool _hasSimpleExtrasAddons(ProductData product) {
    // Check if there are stocks
    if (product.stocks == null || product.stocks!.isEmpty) {
      return true; // No stocks means it's simple (default)
    }

    // If there are multiple stocks, it's complex
    if (product.stocks!.length > 1) {
      return false;
    }

    // Get the first stock
    final stock = product.stocks!.first;

    // Check for extras
    if (stock.extras != null && stock.extras!.isNotEmpty) {
      // If any extras exist, it's complex
      return false;
    }

    // Check for addons
    if (stock.addons != null && stock.addons!.isNotEmpty) {
      // If any addons exist, it's complex
      return false;
    }

    // No extras or addons means it's simple
    return true;
  }
}
