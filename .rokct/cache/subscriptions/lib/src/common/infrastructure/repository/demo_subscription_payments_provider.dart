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

import 'package:base_sdk/base_sdk.dart';

import '../../domain/interface/subscription_payments_provider.dart';

/// Demo-only [SubscriptionPaymentsProvider] twin: one wallet method, so the
/// payment sheet renders without the host's payments adapter.
class DemoSubscriptionPaymentsProvider implements SubscriptionPaymentsProvider {
  @override
  Future<ApiResult<List<SubscriptionPaymentMethod>>> getPaymentMethods() async =>
      const ApiResult.success(
        data: [SubscriptionPaymentMethod(id: 1, tag: 'wallet')],
      );

  @override
  Future<ApiResult<String>> paymentSubscriptionWebView({
    required String name,
    required String subscriptionId,
  }) async =>
      const ApiResult.success(data: '');
}
