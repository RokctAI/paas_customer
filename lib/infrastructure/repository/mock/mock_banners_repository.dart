import 'package:foodyman/domain/handlers/api_result.dart';
import 'package:foodyman/domain/interface/banners.dart';
import 'package:foodyman/infrastructure/models/data/banner_data.dart';
import 'package:foodyman/infrastructure/models/data/product_data.dart';
import 'package:foodyman/infrastructure/models/data/shop_data.dart';
import 'package:foodyman/infrastructure/models/data/translation.dart';
import 'package:foodyman/infrastructure/models/response/banners_paginate_response.dart';

class MockBannersRepository implements BannersRepositoryFacade {
  final BannerData _demoBanner = BannerData(
    id: 1,
    products: [],
    shops: [ShopData(id: "demo_shop_1", name: "Demo Pizza Shop")],
    img: "https://via.placeholder.com/800x400",
    active: true,
    translation: Translation(
      title: "Demo Offer",
      description: "Get 50% off on all items!",
      lang: "en",
    ),
    createdAt: DateTime.now().toString(),
    updatedAt: DateTime.now().toString(),
  );

  @override
  Future<ApiResult<BannerData>> getAdsById(int? bannerId) async {
    return ApiResult.success(data: _demoBanner);
  }

  @override
  Future<ApiResult<BannersPaginateResponse>> getAdsPaginate({required int page}) async {
    return ApiResult.success(
      data: BannersPaginateResponse(
        data: [_demoBanner],
      ),
    );
  }

  @override
  Future<ApiResult<BannerData>> getBannerById(int? bannerId) async {
    return ApiResult.success(data: _demoBanner);
  }

  @override
  Future<ApiResult<BannersPaginateResponse>> getBannersPaginate({required int page}) async {
    return ApiResult.success(
      data: BannersPaginateResponse(
        data: [_demoBanner, _demoBanner.copyWith(id: 2, translation: Translation(title: "New Arrivals"))],
      ),
    );
  }

  @override
  Future<ApiResult<void>> likeBanner(int? bannerId) async {
    return ApiResult.success(data: null);
  }
}
