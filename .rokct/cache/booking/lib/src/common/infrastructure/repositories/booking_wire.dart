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
import 'package:base_sdk/src/services/app_helpers.dart';

/// Shared wire helpers for the booking repositories.
///
/// `PlatformGateway` hands back the interceptor-unwrapped `message`, which
/// for these endpoints is a Frappe doc (a map), a list of rows, or a
/// `{status, message}` acknowledgement.

Map<String, dynamic> asRow(dynamic body) {
  if (body is Map<String, dynamic>) return body;
  if (body is Map) return Map<String, dynamic>.from(body);
  if (body is List && body.isNotEmpty && body.first is Map) {
    return Map<String, dynamic>.from(body.first as Map);
  }
  return const {};
}

List<Map<String, dynamic>> asRows(dynamic body) {
  final list = body is Map && body['data'] is List ? body['data'] : body;
  if (list is! List) return const [];
  return list
      .whereType<Map>()
      .map((m) => Map<String, dynamic>.from(m))
      .toList();
}

/// Frappe Datetime wire form ("yyyy-MM-dd HH:mm:ss", local wall time).
String formatWireDateTime(DateTime dt) {
  String two(int v) => v.toString().padLeft(2, '0');
  return '${dt.year.toString().padLeft(4, '0')}-${two(dt.month)}-'
      '${two(dt.day)} ${two(dt.hour)}:${two(dt.minute)}:${two(dt.second)}';
}

ApiResult<T> bookingFailure<T>(Object e) => ApiResult.failure(
      error: AppHelpers.errorHandler(e),
      statusCode: NetworkExceptions.getDioStatus(e),
    );
