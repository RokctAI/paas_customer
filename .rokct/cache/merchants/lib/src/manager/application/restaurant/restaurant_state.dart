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

import 'package:base_sdk/src/models/data/shop_data.dart';

/// Plain immutable state rather than a `freezed` union — merchants_sdk
/// convention (see `application/main/main_state.dart`).
///
/// [shop] is base_sdk's [ShopData]; the legacy manager twin is not carried
/// over. `orderPayment` mirrors the legacy field that base's model lacks.
class RestaurantState {
  const RestaurantState({
    this.isLoading = false,
    this.backgroundImageFile,
    this.logoImageFile,
    this.orderPayment,
    this.shop,
    this.pendingSync = false,
  });

  final bool isLoading;
  final String? backgroundImageFile;
  final String? logoImageFile;
  final String? orderPayment;
  final ShopData? shop;

  /// True while [shop] is a local-first record not yet accepted by the
  /// backend (offline create awaiting sync) — widgets read this for the
  /// "pending sync" badge.
  final bool pendingSync;

  RestaurantState copyWith({
    bool? isLoading,
    String? backgroundImageFile,
    String? logoImageFile,
    String? orderPayment,
    ShopData? shop,
    bool? pendingSync,
    bool clearBackgroundImageFile = false,
    bool clearLogoImageFile = false,
  }) =>
      RestaurantState(
        isLoading: isLoading ?? this.isLoading,
        backgroundImageFile: clearBackgroundImageFile
            ? null
            : (backgroundImageFile ?? this.backgroundImageFile),
        logoImageFile:
            clearLogoImageFile ? null : (logoImageFile ?? this.logoImageFile),
        orderPayment: orderPayment ?? this.orderPayment,
        shop: shop ?? this.shop,
        pendingSync: pendingSync ?? this.pendingSync,
      );
}
