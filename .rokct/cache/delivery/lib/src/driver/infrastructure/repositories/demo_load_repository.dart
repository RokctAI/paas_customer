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

import 'package:delivery_sdk/src/driver/domain/interface/load.dart';
import 'package:delivery_sdk/src/driver/infrastructure/models/data/driver_load.dart';

/// Offline twin of [DriverLoadRepository], the same split every other
/// courier facade has.
///
/// It serves NO load, deliberately. A load is stock a real shop physically
/// handed to a real driver, and the three write calls move money: a sale
/// is cash owed, a close is a wallet charge. Standing in a warehouse that
/// does not exist would let an offline session practise a money movement
/// that can never settle. So the offline driver meets the same empty state
/// a driver with no load meets, and the three writes answer the one honest
/// sentence.
class DemoDriverLoadRepository implements DriverLoadRepositoryFacade {
  static const _offline = 'This needs a live connection to the shop.';

  @override
  Future<ApiResult<List<DriverLoad>>> getMyLoad() async =>
      const ApiResult.success(data: <DriverLoad>[]);

  @override
  Future<ApiResult<DriverLoadSale>> createLoadSale({
    required String loadOrder,
    required List<DriverLoadMovement> items,
    String? customer,
    String? note,
    String? poi,
  }) async =>
      const ApiResult.failure(error: _offline, statusCode: 503);

  @override
  Future<ApiResult<DriverLoad>> returnLoad({
    required String loadOrder,
    required List<DriverLoadMovement> items,
  }) async =>
      const ApiResult.failure(error: _offline, statusCode: 503);

  @override
  Future<ApiResult<DriverLoad>> closeLoad({required String loadOrder}) async =>
      const ApiResult.failure(error: _offline, statusCode: 503);
}
