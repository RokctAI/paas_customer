// Copyright (c) 2026 RokctAI
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

import 'package:flutter/material.dart';
import 'package:base_sdk/src/domain/interface/banners.dart';
import 'package:base_sdk/src/models/models.dart';
import 'package:base_sdk/src/handlers/handlers.dart';
import 'package:base_sdk/src/handlers/platform_gateway.dart';
import 'package:base_sdk/src/services/app_helpers.dart';
import 'package:base_sdk/src/services/local_storage.dart';

class BannersRepository implements BannersRepositoryFacade {
  /// Universal platform gateway (fleet rule 2026-08-15): banner cmds are the
  /// promotions module's `manifest.json` whitelisted-method keys with the
  /// app segment dropped (`api.banner.*`).
  static const _gateway = PlatformGateway();

  @override
  Future<ApiResult<BannersPaginateResponse>> getBannersPaginate({
    required int page,
    int? pageSize,
  }) async {
    final params = {
      'page': page,
      'limit_page_length': pageSize ?? 10,
      'lang': LocalStorage.getLanguage()?.locale,
    };
    try {
      final response = await _gateway.call(
        'api.banner.get_banners',
        payload: params,
        requireAuth: false,
      );
      return ApiResult.success(
        data: BannersPaginateResponse.fromJson(response),
      );
    } catch (e) {
      debugPrint('==> get banners failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<BannerData>> getBannerById(int? bannerId) async {
    try {
      final response = await _gateway.call(
        'api.banner.get_banner',
        payload: {
          'id': bannerId,
          'lang': LocalStorage.getLanguage()?.locale,
        },
        requireAuth: false,
      );
      return ApiResult.success(data: BannerData.fromJson(response));
    } catch (e) {
      debugPrint('==> get banner by id failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  // NOTE: The following methods are not supported by the new backend.
  // - getAdsPaginate
  // - getAdsById
  // - likeBanner

  @override
  Future<ApiResult<BannersPaginateResponse>> getAdsPaginate({
    required int page,
    int? pageSize,
  }) async {
    final params = {
      'page': page,
      'limit_page_length': pageSize ?? 10,
      'lang': LocalStorage.getLanguage()?.locale,
    };
    try {
      final response = await _gateway.call(
        'api.banner.get_ads',
        payload: params,
        requireAuth: false,
      );
      return ApiResult.success(
        data: BannersPaginateResponse.fromJson(response),
      );
    } catch (e) {
      debugPrint('==> get ads failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<BannerData>> getAdsById(int? bannerId) async {
    try {
      final response = await _gateway.call(
        'api.banner.get_ad',
        payload: {
          'id': bannerId,
          'lang': LocalStorage.getLanguage()?.locale,
        },
        requireAuth: false,
      );
      return ApiResult.success(data: BannerData.fromJson(response));
    } catch (e) {
      debugPrint('==> get ad by id failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<void>> likeBanner(int? bannerId) async {
    try {
      await _gateway.tenant(
        'api.banner.like_banner',
        {'id': bannerId, 'lang': LocalStorage.getLanguage()?.locale},
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      debugPrint('==> like banner failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }
}
