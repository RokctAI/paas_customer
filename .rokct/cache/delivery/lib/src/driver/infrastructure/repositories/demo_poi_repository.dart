// Copyright (c) 2026 ROKCT INTELLIGENCE (PTY) LTD
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published
// by the Free Software Foundation, version 3.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.

import 'package:base_sdk/src/handlers/handlers.dart';

import 'package:delivery_sdk/src/driver/domain/interface/poi.dart';
import 'package:delivery_sdk/src/driver/infrastructure/models/data/driver_poi.dart';
import 'package:delivery_sdk/src/driver/infrastructure/models/data/route_stop.dart';

/// Offline twin of [DriverPoiRepository], the same split every other
/// courier facade has.
///
/// It knows NO points, deliberately. A point of interest is a real place a
/// real driver stood in front of, and filing one puts it on every other
/// driver's map — and, for an approved kind of place, on the customer map
/// too. An offline session standing in front of nothing must not add to
/// what the round believes. So the reads answer empty, the same state a
/// round nobody has filed anything on is in, and the write answers the one
/// honest sentence. The shop picker answers empty for the same reason: an
/// offline session is not delivering for anybody, so it offers nobody.
class DemoDriverPoiRepository implements DriverPoiRepositoryFacade {
  static const _offline = 'This needs a live connection.';

  @override
  Future<ApiResult<List<DriverPoiType>>> types() async =>
      const ApiResult.success(data: <DriverPoiType>[]);

  @override
  Future<ApiResult<List<DriverPoi>>> nearby({
    required double latitude,
    required double longitude,
    double? radiusKm,
    String? type,
    String? shop,
  }) async =>
      const ApiResult.success(data: <DriverPoi>[]);

  @override
  Future<ApiResult<DriverPoiFiling>> create({
    required String label,
    required String type,
    required double latitude,
    required double longitude,
    String? customType,
    String? shop,
    String? address,
    String? note,
    String? ownerFirstName,
    String? ownerLastName,
    String? ownerPhone,
    bool ownerConfirmedUser = false,
  }) async =>
      const ApiResult.failure(error: _offline, statusCode: 503);

  /// An owner lookup answers "nobody", not a failure: the question is
  /// whether the platform holds this number, and offline it holds none.
  /// Answering a clash offline would ask the driver to confirm somebody
  /// who does not exist.
  @override
  Future<ApiResult<DriverPoiOwner>> lookupOwner({
    required String phone,
  }) async =>
      const ApiResult.success(data: DriverPoiOwner());

  @override
  Future<ApiResult<DriverPoiShopChoices>> myShops() async =>
      const ApiResult.success(data: DriverPoiShopChoices());

  @override
  Future<ApiResult<List<RouteStopData>>> route({
    double? latitude,
    double? longitude,
    String? type,
    String? shop,
  }) async =>
      const ApiResult.success(data: <RouteStopData>[]);

  @override
  Future<ApiResult<DriverPoiSales>> sales({
    required String poi,
    int limit = 50,
  }) async =>
      const ApiResult.success(data: DriverPoiSales());
}
