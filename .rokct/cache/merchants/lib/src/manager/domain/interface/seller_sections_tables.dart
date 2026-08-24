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

import 'package:base_sdk/src/handlers/handlers.dart';
import 'package:merchants_sdk/src/manager/infrastructure/models/data/sections_tables.dart';

/// Owner-side contract for shop sections and dine-in tables
/// (`seller_operations.py` domain) — the counterpart of orders_sdk's ADR-005
/// consumer seam [`PosSectionsTablesFacade`].
///
/// orders_sdk owns the POS section/table picker screens but must not import
/// this SDK; it declares its facade in its own model terms, and the manager
/// host's installed adapter (`orders_sdk templates/adapters/manager/
/// orders_adapters.dart` → `lib/presentation/routes/orders_adapters.dart`)
/// binds it to this repository. `getSections`/`getTables` deliberately match
/// that facade's method shapes so the adapter body is a mechanical
/// delegation; the wire shapes of the response models also match orders_sdk's
/// (`{data: [...]}` with the legacy keys, tolerant of the current bare-list
/// Frappe returns).
///
/// CRUD stays here with the owner: the legacy `TableInterface`'s booking /
/// statistics members are NOT carried over — no page in the manager app's
/// restaurant vertical reads them (they belonged to an unrouted booking
/// screen); the endpoint story is recorded in
/// `merchants/dart/docs/frappe-endpoint-contract.md`.
abstract class SellerSectionsTablesRepositoryFacade {
  Future<ApiResult<SellerSectionsResponse>> getSections({
    int? page,
    String? query,
  });

  Future<ApiResult<SellerTablesResponse>> getTables({
    int? page,
    String? query,
    int? shopSectionId,
  });

  Future<ApiResult<void>> createSection({
    required String name,
    required num area,
  });

  Future<ApiResult<void>> deleteTable({required String tableId});
}
