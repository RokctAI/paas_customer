import 'package:flutter/material.dart';
import 'package:foodyman/domain/di/dependency_manager.dart';
import 'package:foodyman/domain/interface/products.dart';
import 'package:foodyman/infrastructure/models/models.dart';
import 'package:foodyman/infrastructure/models/response/all_products_response.dart';
import 'package:foodyman/domain/handlers/handlers.dart';
import '../services/app_helpers.dart';

class ProductsRepository implements ProductsRepositoryFacade {
  @override
  Future<ApiResult<ProductsPaginateResponse>> searchProducts(
      {required String text, int? page}) async {
    final params = {
      'search': text,
      'limit_start': ((page ?? 1) - 1) * 14,
      'limit_page_length': 14,
    };
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/method/paas.api.product.product.get_products',
        queryParameters: params,
      );
      return ApiResult.success(
        data: ProductsPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<SingleProductResponse>> getProductDetails(
    String uuid,
  ) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/method/paas.api.product.product.get_product_by_uuid',
        queryParameters: {'uuid': uuid},
      );
      return ApiResult.success(
        data: SingleProductResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get product details failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<ProductsPaginateResponse>> getProductsPaginate({
    String? shopId,
    int? categoryId,
    int? brandId,
    int? page,
    String? orderBy,
  }) async {
    final params = {
      'limit_start': ((page ?? 1) - 1) * 14,
      'limit_page_length': 14,
      if (shopId != null) 'shop_id': shopId,
      if (categoryId != null) 'category_id': categoryId,
      if (brandId != null) 'brand_id': brandId,
      if (orderBy != null) 'order_by': orderBy,
    };
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/method/paas.api.product.product.get_products',
        queryParameters: params,
      );
      return ApiResult.success(
        data: ProductsPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> getProductsPaginate failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<ProductsPaginateResponse>> getMostSoldProducts({
    int? shopId,
    int? categoryId,
    int? brandId,
  }) async {
    final params = {
      'limit_page_length': 14,
      if (shopId != null) 'shop_id': shopId,
      if (categoryId != null) 'category_id': categoryId,
      if (brandId != null) 'brand_id': brandId,
    };
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/method/paas.api.product.product.most_sold_products',
        queryParameters: params,
      );
      return ApiResult.success(
        data: ProductsPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get most sold products failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<ProductCalculateResponse>> getAllCalculations(
    List<CartProductData> cartProducts,
  ) async {
    final products = cartProducts
        .map((p) =>
            {'product_id': p.selectedStock?.id, 'quantity': p.quantity})
        .toList();

    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.post(
        '/api/method/paas.api.product.product.order_products_calculate',
        data: {'products': products},
      );
      return ApiResult.success(
        data: ProductCalculateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get all calculations failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<ProductsPaginateResponse>> getProductsByIds(
    List<int> ids,
  ) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/method/paas.api.product.product.get_products_by_ids',
        queryParameters: {'ids': ids},
      );
      return ApiResult.success(
        data: ProductsPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get products by ids failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<void>> addReview(
    String productUuid,
    String comment,
    double rating,
    String? imageUrl,
  ) async {
    final data = {
      'uuid': productUuid,
      'rating': rating,
      if (comment.isNotEmpty) 'comment': comment,
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/method/paas.api.product.product.add_product_review',
        data: data,
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      debugPrint('==> add review failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<ProductsPaginateResponse>> getDiscountProducts({
    int? shopId,
    int? brandId,
    int? categoryId,
    int? page,
  }) async {
     final params = {
      'limit_start': ((page ?? 1) - 1) * 14,
      'limit_page_length': 14,
      if (shopId != null) 'shop_id': shopId,
      if (categoryId != null) 'category_id': categoryId,
      if (brandId != null) 'brand_id': brandId,
    };
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/method/paas.api.product.product.get_discounted_products',
        queryParameters: params,
      );
      return ApiResult.success(
        data: ProductsPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get discount products failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  // NOTE: The following methods are now covered by the enhanced getProductsPaginate method
  // or are no longer needed.
  // - getProductsByCategoryPaginate
  // - getAllProducts
  // - getProductsShopByCategoryPaginate
  // - getProductsPopularPaginate
  // - getRelatedProducts
  // - getProductCalculations
  // - getNewProducts
  // - getProfitableProducts

  @override
  Future<ApiResult<AllProductsResponse>> getAllProducts(
      {required String shopId}) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/method/paas.api.product.product.get_products',
        queryParameters: {'shop_id': shopId, 'limit_page_length': 100},
      );
      return ApiResult.success(
        data: AllProductsResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get all products failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<ProductsPaginateResponse>> getNewProducts(
      {int? shopId, int? brandId, int? categoryId, int? page}) async {
    return getProductsPaginate(
      shopId: shopId?.toString(),
      brandId: brandId,
      categoryId: categoryId,
      page: page,
      orderBy: 'created_at',
    );
  }

  @override
  Future<ApiResult<ProductCalculateResponse>> getProductCalculations(
      int stockId, int quantity) async {
    return getAllCalculations([
      CartProductData(
        selectedStock: Stocks(id: stockId),
        quantity: quantity,
      )
    ]);
  }

  @override
  Future<ApiResult<ProductsPaginateResponse>> getProductsByCategoryPaginate(
      {String? shopId, required int page, required int categoryId}) async {
    return getProductsPaginate(
      shopId: shopId,
      categoryId: categoryId,
      page: page,
    );
  }

  @override
  Future<ApiResult<ProductsPaginateResponse>> getProductsPopularPaginate(
      {String? shopId, required int page}) async {
    return getProductsPaginate(
      shopId: shopId,
      page: page,
      orderBy: 'rating',
    );
  }

  @override
  Future<ApiResult<ProductsPaginateResponse>>
      getProductsShopByCategoryPaginate(
          {String? shopId,
          List<int>? brands,
          int? sortIndex,
          required int page,
          required int categoryId}) async {
    return getProductsPaginate(
      shopId: shopId,
      categoryId: categoryId,
      page: page,
      // Implement sort index logic if needed
    );
  }

  @override
  Future<ApiResult<ProductsPaginateResponse>> getProfitableProducts(
      {int? brandId, int? categoryId, int? page}) async {
    return getProductsPaginate(
      brandId: brandId,
      categoryId: categoryId,
      page: page,
      orderBy: 'discount',
    );
  }

  @override
  Future<ApiResult<ProductsPaginateResponse>> getRelatedProducts(
      int? brandId, int? shopId, int? categoryId) async {
    return getProductsPaginate(
      shopId: shopId?.toString(),
      brandId: brandId,
      categoryId: categoryId,
      page: 1,
    );
  }
}
