import 'package:foodyman/domain/handlers/api_result.dart';
import 'package:foodyman/domain/interface/shops.dart';
import 'package:foodyman/infrastructure/models/data/filter_model.dart';
import 'package:foodyman/infrastructure/models/data/shop_data.dart';
import 'package:foodyman/infrastructure/models/response/shops_paginate_response.dart';
import 'package:foodyman/infrastructure/models/response/single_shop_response.dart';
import 'package:foodyman/infrastructure/models/response/branch_response.dart';
import 'package:foodyman/infrastructure/models/response/tag_response.dart';
import 'package:foodyman/infrastructure/models/response/price_model_response.dart';
import 'package:foodyman/infrastructure/models/data/story_data.dart';
import 'package:foodyman/infrastructure/models/data/address_new_data.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MockShopsRepository implements ShopsRepositoryFacade {
  final ShopData _demoShop = ShopData(
    id: "demo_shop_1",
    uuid: "demo_shop_1",
    userId: 1,
    name: "Demo Pizza Shop",
    logoImg: "https://via.placeholder.com/150",
    backgroundImg: "https://via.placeholder.com/300x150",
    description: "Best pizza in the demo world.",
    open: true,
    rating: 4.5,
    deliveryTime: "30-40 min",
    deliveryType: "delivery",
    distance: 1.2,
    location: LocationModel(latitude: 37.7749, longitude: -122.4194),
  );

  @override
  Future<ApiResult<bool>> checkDriverZone(LatLng location, {String? shopId}) async {
    return ApiResult.success(data: true);
  }

  @override
  Future<ApiResult<void>> createShop({required double tax, required List<String> documents, required double deliveryTo, required double deliveryFrom, required String deliveryType, required String phone, required String name, required String category, required String description, required double startPrice, required double perKm, required AddressNewModel address, String? logoImage, String? backgroundImage}) async {
    return ApiResult.success(data: null);
  }

  @override
  Future<ApiResult<ShopsPaginateResponse>> getAllShops(int page, {String? categoryId, FilterModel? filterModel, required bool isOpen, bool? verify}) async {
    return ApiResult.success(
      data: ShopsPaginateResponse(
        data: [_demoShop, _demoShop.copyWith(id: "demo_shop_2", name: "Demo Burger Joint")],
      ),
    );
  }

  @override
  Future<ApiResult<ShopsPaginateResponse>> getNearbyShops(double latitude, double longitude) async {
    return ApiResult.success(
      data: ShopsPaginateResponse(
        data: [_demoShop],
      ),
    );
  }

  @override
  Future<ApiResult<ShopsPaginateResponse>> getPickupShops() async {
    return ApiResult.success(
      data: ShopsPaginateResponse(
        data: [_demoShop],
      ),
    );
  }

  @override
  Future<ApiResult<ShopsPaginateResponse>> getShopFilter({String? categoryId, required int page, String? subCategoryId}) async {
    return ApiResult.success(
      data: ShopsPaginateResponse(
        data: [_demoShop],
      ),
    );
  }

  @override
  Future<ApiResult<BranchResponse>> getShopBranch({required String uuid}) async {
      return ApiResult.success(data: BranchResponse(data: []));
  }

  @override
  Future<ApiResult<ShopsPaginateResponse>> getShopsByIds(List<String> shopIds) async {
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
  Future<ApiResult<SingleShopResponse>> getSingleShop({required String uuid}) async {
    return ApiResult.success(data: _demoShop);
  }

  @override
  Future<ApiResult<List<List<StoryModel?>?>?>> getStory(int page) async {
    return ApiResult.success(data: []);
  }

  @override
  Future<ApiResult<PriceModel>> getSuggestPrice() async {
    return ApiResult.success(data: PriceModel(min: 10, max: 100));
  }

  @override
  Future<ApiResult<TagResponse>> getTags(String categoryId) async {
    return ApiResult.success(data: TagResponse(data: []));
  }

  @override
  Future<ApiResult> joinOrder({required String shopId, required String name, required String cartId}) async {
    return ApiResult.success(data: "demo_uuid");
  }

  @override
  Future<ApiResult<ShopsPaginateResponse>> searchShops({required String text, String? categoryId}) async {
    return ApiResult.success(
      data: ShopsPaginateResponse(
        data: [_demoShop],
      ),
    );
  }
}
