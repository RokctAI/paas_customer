import 'package:foodyman/domain/handlers/api_result.dart';
import 'package:foodyman/domain/interface/products.dart';
import 'package:foodyman/infrastructure/models/data/product_data.dart';
import 'package:foodyman/infrastructure/models/data/translation.dart';
import 'package:foodyman/infrastructure/models/response/products_paginate_response.dart';
import 'package:foodyman/infrastructure/models/response/single_product_response.dart';
import 'package:foodyman/infrastructure/models/response/product_calculate_response.dart';

class MockProductsRepository implements ProductsRepositoryFacade {
  final ProductData _demoProduct = ProductData(
    id: "1",
    uuid: "demo_product_uuid",
    shopId: "1",
    categoryId: "1",
    keywords: "demo, product",
    brandId: "1",
    tax: 5,
    interval: 1,
    minQty: 1,
    maxQty: 100,
    active: true,
    img: "https://via.placeholder.com/150",
    createdAt: DateTime.now().toString(),
    updatedAt: DateTime.now().toString(),
    ratingAvg: 4.5,
    ordersCount: 50,
    translation: Translation(
      title: "Demo Product",
      description: "This is a demo product description",
      lang: "en",
    ),
    stocks: [
      Stocks(
        id: "1",
        price: 150,
        quantity: 100,
        totalPrice: 150,
      )
    ],
  );

  @override
  Future<ApiResult<ProductsPaginateResponse>> getProductsPaginate(int page, {int? categoryId, int? brandId, int? shopId, bool? verify, bool? hasDiscount, double? minPrice, double? maxPrice, int? sort}) async {
    return ApiResult.success(
      data: ProductsPaginateResponse(
        data: [_demoProduct, _demoProduct.copyWith(id: "2", translation: Translation(title: "Another Product"))],
      ),
    );
  }

  @override
  Future<ApiResult<ProductsPaginateResponse>> searchProducts(String query, int page) async {
    return ApiResult.success(
      data: ProductsPaginateResponse(
        data: [_demoProduct],
      ),
    );
  }

  @override
  Future<ApiResult<SingleProductResponse>> getProductDetails(String uuid) async {
    return ApiResult.success(
      data: SingleProductResponse(
        data: _demoProduct,
      ),
    );
  }

  @override
  Future<ApiResult<ProductCalculateResponse>> getProductsCalculations(int stockId, int quantity) async {
    // Mock calculation logic
    double price = 150.0;
    double total = price * quantity;
    return ApiResult.success(
      data: ProductCalculateResponse(
        data: CalculatedData(
            products: [
                CalculatedProduct(
                    id: stockId,
                    qty: quantity,
                    price: price,
                    totalPrice: total,
                    tax: 0,
                    shopTax: 0,
                    discount: 0,
                    priceWithoutTax: price
                )
            ],
            productTotal: total,
            orderTotal: total,
            productTax: 0,
            orderTax: 0
        )
      ),
    );
  }

  @override
  Future<ApiResult<ProductsPaginateResponse>> getMostSoldProducts(int page, {int? shopId, int? categoryId, int? brandId}) async{
    return ApiResult.success(
      data: ProductsPaginateResponse(
        data: [_demoProduct],
      ),
    );
  }
 
  @override
  Future<ApiResult<ProductsPaginateResponse>> getRelatedProducts(String productUuid, int page) async{
       return ApiResult.success(
      data: ProductsPaginateResponse(
        data: [_demoProduct],
      ),
    );
  }

  @override
  Future<ApiResult> addReview(String productUuid, String comment, double rating, {String? img}) async{
      return ApiResult.success(data: null);
  }
}
