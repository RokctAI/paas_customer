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
import 'package:base_sdk/src/models/data/product_data.dart';
import 'package:base_sdk/src/models/data/translation.dart';
import 'package:base_sdk/src/models/response/products_paginate_response.dart';
import 'package:merchants_sdk/src/manager/domain/interface/pos_catalog.dart';

/// Demo-mode POS catalog (`--dart-define=IS_DEMO=true` routes the till's
/// barcode lookup here, `ManagerMerchantsDependencies.register`): any
/// barcode or search text resolves to one "Demo Product" at 150.00, the
/// same demo identity products_sdk's mock serves — so headless tours and
/// the standalone test harness scan, cart and check out with zero backend
/// contact.
class MockProductsRepository implements PosCatalogRepositoryFacade {
  static final ProductData demoProduct = ProductData(
    id: '1',
    uuid: 'demo_product_uuid',
    shopId: '1',
    active: true,
    translation: Translation(
      title: 'Demo Product',
      description: 'This is a demo product description',
      locale: 'en',
    ),
    stocks: [Stocks(id: '1', price: 150, quantity: 100, totalPrice: 150)],
  );

  @override
  Future<ApiResult<ProductsPaginateResponse>> searchProducts({
    required String text,
    int page = 1,
  }) async {
    return ApiResult.success(
      data: ProductsPaginateResponse(data: [demoProduct]),
    );
  }
}
