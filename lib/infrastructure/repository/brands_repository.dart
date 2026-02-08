import 'package:flutter/material.dart';
import 'package:foodyman/domain/di/dependency_manager.dart';
import 'package:foodyman/domain/interface/brands.dart';
import 'package:foodyman/infrastructure/models/models.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/domain/handlers/handlers.dart';
import 'package:foodyman/infrastructure/services/local_storage.dart';

class BrandsRepository implements BrandsRepositoryFacade {
  @override
  Future<ApiResult<BrandsPaginateResponse>> getBrandsPaginate(int page, {int? pageSize, String? search}) async {
    final params = {
      'limit_start': (page - 1) * (pageSize ?? 18),
      'limit_page_length': pageSize ?? 18,
      'lang': LocalStorage.getLanguage()?.locale,
      if (search != null) 'search': search,
    };
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/method/paas.api.brand.brand.get_brands',
        queryParameters: params,
      );
      return ApiResult.success(
        data: BrandsPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get brands paginate failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<SingleBrandResponse>> getSingleBrand(String uuid) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/method/paas.api.brand.brand.get_brand_by_uuid',
        queryParameters: {
          'uuid': uuid,
          'lang': LocalStorage.getLanguage()?.locale,
        },
      );
      return ApiResult.success(
        data: SingleBrandResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get brand failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<BrandsPaginateResponse>> getAllBrands({int? categoryId, String? shopId}) {
    return getBrandsPaginate(1);
  }

  @override
  Future<ApiResult<BrandsPaginateResponse>> searchBrands(String query) {
    return getBrandsPaginate(1, search: query);
  }
}
