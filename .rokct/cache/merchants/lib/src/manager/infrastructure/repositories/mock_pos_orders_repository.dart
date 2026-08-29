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
import 'package:merchants_sdk/src/manager/domain/interface/pos_orders.dart';

/// Demo (`--dart-define=IS_DEMO=true`) implementation of
/// [PosOrdersFacade]: the strip's render fixtures with zero backend
/// contact, so headless tours and the standalone POS test harness
/// exercise the full checkout — customer attach, credit split,
/// send-for-delivery — end to end. Mirrors `MockProductsRepository`'s
/// role for the catalog seam.
class MockPosOrdersRepository implements PosOrdersFacade {
  /// The design strip's demo customer (frames 11g–11i).
  static const PosCustomer demoCustomer = PosCustomer(
    id: 'demo-customer',
    firstname: 'Thabo',
    lastname: 'Mokoena',
    phone: '072 114 8890',
  );

  /// The strip's "owes R89.50" outstanding chip.
  static const double demoOutstanding = 89.50;

  /// Sales submitted this session; demo never syncs, so each stays
  /// pending — which is exactly what the pending-sync indicator renders.
  final List<PosSaleDraft> submitted = [];

  @override
  Future<ApiResult<List<PosCustomer>>> searchCustomers({
    String? query,
    int page = 1,
  }) async {
    final q = (query ?? '').trim().toLowerCase();
    final match = q.isEmpty ||
        demoCustomer.fullName.toLowerCase().contains(q) ||
        (demoCustomer.phone ?? '').replaceAll(' ', '').contains(q);
    return ApiResult.success(data: match ? const [demoCustomer] : const []);
  }

  @override
  Future<double?> customerCreditOutstanding(String customerId) async =>
      customerId == demoCustomer.id ? demoOutstanding : 0;

  @override
  Future<ApiResult<String>> submitSale(PosSaleDraft draft) async {
    submitted.add(draft);
    return ApiResult.success(data: 'offline:demo-${submitted.length}');
  }

  @override
  Future<int> pendingSaleCount() async => submitted.length;
}
