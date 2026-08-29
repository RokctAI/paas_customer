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
import 'package:base_sdk/src/models/response/products_paginate_response.dart';

/// The POS till's product-lookup seam (barcode scans and the manual
/// "Add Items" lane both resolve through it).
///
/// Deliberately narrower than base_sdk's `ProductsRepositoryFacade`: the
/// till only ever searches. The real implementation delegates to the
/// composed app's registered products facade (products_sdk registers it in
/// every manager compose); the demo implementation
/// (`MockProductsRepository`, this SDK's) answers locally so headless
/// tours and the standalone test harness never touch a backend.
abstract class PosCatalogRepositoryFacade {
  /// Product search by free text or barcode — the same call the legacy
  /// Spazafy scanner made (`searchProducts(text: barcode)` → first match).
  Future<ApiResult<ProductsPaginateResponse>> searchProducts({
    required String text,
    int page = 1,
  });
}
