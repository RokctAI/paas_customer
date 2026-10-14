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


/// Response of the subscription transaction-creation endpoint.
///
/// Owned by subscriptions_sdk so the facade carries no compile dependency on
/// wallet_sdk. The purchase flow currently only branches on the request's
/// success/failure; the raw `data` payload is kept available for callers
/// that need transaction details.
class SubscriptionTransactionsResponse {
  final Map<String, dynamic>? data;

  SubscriptionTransactionsResponse({this.data});

  factory SubscriptionTransactionsResponse.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      return SubscriptionTransactionsResponse();
    }
    final data = json['data'];
    return SubscriptionTransactionsResponse(
      data: data is Map<String, dynamic> ? data : null,
    );
  }

  Map<String, dynamic> toJson() => {'data': data};
}
