import 'package:foodyman/domain/handlers/api_result.dart';
import 'package:foodyman/domain/interface/shops.dart';
import 'package:foodyman/infrastructure/models/data/shop_data.dart';
import 'package:foodyman/infrastructure/models/data/location.dart';
import 'package:foodyman/infrastructure/models/data/translation.dart';
import 'package:foodyman/infrastructure/models/response/shops_paginate_response.dart';
import 'package:foodyman/infrastructure/models/response/single_shop_response.dart';
import 'package:foodyman/infrastructure/models/response/stories_response.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MockShopsRepository implements ShopsRepositoryFacade {
  final ShopData _demoShop = ShopData(
    id: "1",
    userId: "1",
    tax: 10,
    pricePerKm: 5,
    minPrice: 10,
    percentage: 15,
    phone: "+1234567890",
    visibility: true,
    openTime: "09:00",
    open: true,
    verify: true,
    closeTime: "22:00",
    backgroundImg: "https://via.placeholder.com/600x400",
    logoImg: "https://via.placeholder.com/150",
    minAmount: 50,
    status: "approved",
    type: "restaurant",
    deliveryTime: DeliveryTime(to: "30", from: "45", type: "min"),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    location: Location(latitude: 37.7749, longitude: -122.4194),
    productsCount: 100,
    translation: Translation(title: "Demo Shop", description: "Best demo food in town", address: "123 Demo St"),
    locales: ["en"],
    seller: Seller(id: "1", firstname: "John", lastname: "Doe", active: true, role: "seller"),
    avgRate: "4.5",
    rateCount: "120",
    enableCod: true,
  );

  @override
  Future<ApiResult<ShopsPaginateResponse>> getAllShops(int page, {
    int? categoryId,
    bool? isOpen,
    bool? verify,
    bool? hasDiscount,
    double? minPrice,
    double? maxPrice,
    int? sort,
    int? type,
    int? deliveryType,
  }) async {
    return ApiResult.success(
      data: ShopsPaginateResponse(
        data: [_demoShop, _demoShop],
      ),
    );
  }

  @override
  Future<ApiResult<ShopsPaginateResponse>> getNearbyShops(int page, {
    int? categoryId,
    bool? isOpen,
    bool? verify,
    bool? hasDiscount,
    double? minPrice,
    double? maxPrice,
    int? sort,
    int? type,
    int? deliveryType,
  }) async {
      return ApiResult.success(
      data: ShopsPaginateResponse(
        data: [_demoShop],
      ),
    );
  }


  @override
  Future<ApiResult<ShopsPaginateResponse>> getShopsRecommend(int page) async {
      return ApiResult.success(
      data: ShopsPaginateResponse(
        data: [_demoShop],
      ),
    );
  }

  @override
  Future<ApiResult<SingleShopResponse>> getShopById(int shopId) async {
    return ApiResult.success(
      data: SingleShopResponse(
        data: _demoShop,
      ),
    );
  }

  @override
  Future<ApiResult<SingleShopResponse>> getShopBySlug(String slug) async {
      return ApiResult.success(
      data: SingleShopResponse(
        data: _demoShop,
      ),
    );
  }

  @override
  Future<ApiResult<StoriesResponse>> getShopStories(int page) async {
    return ApiResult.success(data: StoriesResponse(data: []));
  }
  
  @override
  Future<ApiResult<ShopsPaginateResponse>> searchShops(String text, int page) async {
       return ApiResult.success(
      data: ShopsPaginateResponse(
        data: [_demoShop],
      ),
    );
  }

  // Implementing missing methods from interface if any, returning empty/default
  @override
  Future<ApiResult<dynamic>> createShop({required ShopData shop}) async {
      return ApiResult.success(data: null);
  }

  @override
  Future<ApiResult<ShopsPaginateResponse>> getPickupShops(int page, {int? categoryId, bool? isOpen, bool? verify, bool? hasDiscount, double? minPrice, double? maxPrice, int? sort, int? type, int? deliveryType}) async{
      return ApiResult.success(
      data: ShopsPaginateResponse(
        data: [_demoShop],
      ),
    );
  }
}
