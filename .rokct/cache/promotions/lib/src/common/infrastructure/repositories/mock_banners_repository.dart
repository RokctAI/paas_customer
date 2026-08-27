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

import 'package:base_sdk/src/handlers/api_result.dart';
import 'package:base_sdk/src/domain/interface/banners.dart';
import 'package:base_sdk/src/models/data/shop_data.dart';
import 'package:base_sdk/src/models/data/translation.dart';
import 'package:base_sdk/src/models/response/banners_paginate_response.dart';

class MockBannersRepository implements BannersRepositoryFacade {
  final BannerData _demoBanner = BannerData(
    id: '1',
    shops: [
      ShopData(
        id: "demo_shop_1",
        translation: Translation(title: "Demo Pizza Shop"),
      ),
    ],
    img: "https://via.placeholder.com/800x400",
    active: true,
    translation: Translation(
      title: "Demo Offer",
      description: "Get 50% off on all items!",
      locale: "en",
    ),
    createdAt: DateTime.now().toString(),
    updatedAt: DateTime.now().toString(),
  );

  @override
  Future<ApiResult<BannerData>> getAdsById(String bannerId) async {
    return ApiResult.success(data: _demoBanner);
  }

  @override
  Future<ApiResult<BannersPaginateResponse>> getAdsPaginate({
    required int page,
  }) async {
    return ApiResult.success(
      data: BannersPaginateResponse(data: [_demoBanner]),
    );
  }

  @override
  Future<ApiResult<BannerData>> getBannerById(String bannerId) async {
    return ApiResult.success(data: _demoBanner);
  }

  @override
  Future<ApiResult<BannersPaginateResponse>> getBannersPaginate({
    required int page,
  }) async {
    return ApiResult.success(
      data: BannersPaginateResponse(
        data: [
          _demoBanner,
          _demoBanner.copyWith(
            id: '2',
            translation: Translation(title: "New Arrivals"),
          ),
        ],
      ),
    );
  }

  @override
  Future<ApiResult<void>> likeBanner(String bannerId) async {
    return ApiResult.success(data: null);
  }
}
