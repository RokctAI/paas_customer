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
import 'package:base_sdk/src/models/data/poi_data.dart';

import 'package:map_sdk/src/common/domain/interface/customer_poi.dart';
import 'package:map_sdk/src/common/infrastructure/repositories/customer_poi_repository.dart';

/// Offline twin of [CustomerPoiRepository], the same split every other
/// facade in the fleet has (delivery_sdk's `DemoDriverLoadRepository`).
///
/// It serves NO points, deliberately. A point of interest is a real place
/// an administrator checked and approved - a gate, a clinic, a landmark a
/// shopper navigates by. Standing places on an offline map would put
/// somewhere on the screen that nobody approved and that is not there,
/// which is worse than an empty map: a shopper would walk to it. So the
/// offline session meets the same map a connected shopper in an area with
/// no approved points meets.
class DemoCustomerPoiRepository implements CustomerPoiRepositoryFacade {
  @override
  Future<ApiResult<List<POIData>>> getCustomerPois({
    required double latitude,
    required double longitude,
    double radiusKm = CustomerPoiRepository.defaultRadiusKm,
  }) async =>
      const ApiResult.success(data: <POIData>[]);
}
