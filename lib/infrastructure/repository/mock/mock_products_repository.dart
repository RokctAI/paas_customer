import 'package:foodyman/domain/handlers/api_result.dart';
import 'package:foodyman/domain/interface/products.dart';
import 'package:foodyman/infrastructure/models/data/cart_product_data.dart';
import 'package:foodyman/infrastructure/models/data/product_data.dart';
import 'package:foodyman/infrastructure/models/data/product_calculate.dart';
import 'package:foodyman/infrastructure/models/response/all_products_response.dart';
import 'package:foodyman/infrastructure/models/response/products_paginate_response.dart';
import 'package:foodyman/infrastructure/models/response/single_product_response.dart';
import 'package:foodyman/infrastructure/models/response/product_calculate_response.dart';
import 'package:foodyman/infrastructure/models/data/translation.dart';

class MockProductsRepository implements ProductsRepositoryFacade {
  final ProductData _demoProduct = ProductData(
    id: "demo_product_1",
    uuid: "demo_product_1",
    shopId: "demo_shop_1",
    categoryId: "demo_cat_1",
    brandId: "demo_brand_1",
    price: 15.99,
    tax: 1.5,
    barCode: "1234567890",
    status: "active",
    active: true,
    img: "https://via.placeholder.com/150",
    translation: Translation(
      title: "Demo Burger",
      description: "A delicious demo burger.",
    ),
    quantity: 1,
    minQty: 1,
    maxQty: 10,
    interval: 1,
  );

  @override
  Future<ApiResult<void>> addReview(String productUuid, String comment, double rating, String? imageUrl) async {
    return ApiResult.success(data: null);
  }

  @override
  Future<ApiResult<ProductCalculateResponse>> getAllCalculations(List<CartProductData> cartProducts) async {
    double total = cartProducts.fold(0, (sum, item) => sum + (item.price ?? 0) * (item.quantity ?? 1));
    return ApiResult.success(
      data: ProductCalculateResponse(
        data: ProductCalculate(
            totalPrice: total,
            totalTax: total * 0.1,
            totalShopTax: total * 0.05,
            price: total,
             products: cartProducts.map((e) => ProductCalculate(
                 price: (e.price ?? 0) * (e.quantity ?? 1),
                 totalPrice: (e.price ?? 0) * (e.quantity ?? 1),
                  totalTax: ((e.price ?? 0) * (e.quantity ?? 1)) * 0.1,
                  shopTax: ((e.price ?? 0) * (e.quantity ?? 1)) * 0.05,
             )).toList()
        ),
      ),
    );
  }

  @override
  Future<ApiResult<AllProductsResponse>> getAllProducts({required String shopId}) async {
    return ApiResult.success(
      data: AllProductsResponse(
        data: AllProductsData(
          all: [
             All(
                 translation: Translation(title: "Burgers"),
                 products: [_demoProduct, _demoProduct.copyWith(id: "demo_product_2", translation: Translation(title: "Cheese Burger"))]
             )
          ],
          recommended: [_demoProduct],
        ),
      ),
    );
  }

  @override
  Future<ApiResult<ProductsPaginateResponse>> getDiscountProducts({String? shopId, String? brandId, String? categoryId, int? page}) async {
     return ApiResult.success(
      data: ProductsPaginateResponse(
        data: [_demoProduct],
      ),
    );
  }

  @override
  Future<ApiResult<ProductsPaginateResponse>> getMostSoldProducts({String? shopId, String? categoryId, String? brandId}) async {
     return ApiResult.success(
      data: ProductsPaginateResponse(
        data: [_demoProduct],
      ),
    );
  }

  @override
  Future<ApiResult<ProductsPaginateResponse>> getNewProducts({String? shopId, String? brandId, String? categoryId, int? page}) async {
     return ApiResult.success(
      data: ProductsPaginateResponse(
        data: [_demoProduct],
      ),
    );
  }

  @override
  Future<ApiResult<ProductCalculateResponse>> getProductCalculations(String stockId, int quantity) async {
      return ApiResult.success(
      data: ProductCalculateResponse(
        data: ProductCalculate(
            price: 15.99 * quantity,
            totalPrice: 15.99 * quantity,
            totalTax: (15.99 * quantity) * 0.1,
        ),
      ),
    );
  }

  @override
  Future<ApiResult<SingleProductResponse>> getProductDetails(String uuid) async {
     return ApiResult.success(data: SingleProductResponse(data: _demoProduct));
  }

  @override
  Future<ApiResult<ProductsPaginateResponse>> getProductsByIds(List<String> ids) async {
     return ApiResult.success(
      data: ProductsPaginateResponse(
        data: [_demoProduct],
      ),
    );
  }

  @override
  Future<ApiResult<ProductsPaginateResponse>> getProductsByCategoryPaginate({String? shopId, required int page, required String categoryId}) async {
     return ApiResult.success(
      data: ProductsPaginateResponse(
        data: [_demoProduct],
      ),
    );
  }

  @override
  Future<ApiResult<ProductsPaginateResponse>> getProductsPaginate({String? shopId, String? categoryId, String? brandId, required int page, String? orderBy}) async {
     return ApiResult.success(
      data: ProductsPaginateResponse(
        data: [_demoProduct],
      ),
    );
  }

  @override
  Future<ApiResult<ProductsPaginateResponse>> getProductsPopularPaginate({String? shopId, required int page}) async {
     return ApiResult.success(
      data: ProductsPaginateResponse(
        data: [_demoProduct],
      ),
    );
  }

  @override
  Future<ApiResult<ProductsPaginateResponse>> getProductsShopByCategoryPaginate({String? shopId, List<String>? brands, int? sortIndex, required int page, required String categoryId}) async {
     return ApiResult.success(
      data: ProductsPaginateResponse(
        data: [_demoProduct],
      ),
    );
  }

  @override
  Future<ApiResult<ProductsPaginateResponse>> getProfitableProducts({String? brandId, String? categoryId, int? page}) async {
     return ApiResult.success(
      data: ProductsPaginateResponse(
        data: [_demoProduct],
      ),
    );
  }

  @override
  Future<ApiResult<ProductsPaginateResponse>> getRelatedProducts(String? brandId, String? shopId, String? categoryId) async {
     return ApiResult.success(
      data: ProductsPaginateResponse(
        data: [_demoProduct],
      ),
    );
  }

  @override
  Future<ApiResult<ProductsPaginateResponse>> searchProducts({required String text, int page}) async {
     return ApiResult.success(
      data: ProductsPaginateResponse(
        data: [_demoProduct],
      ),
    );
  }
}
