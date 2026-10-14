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


// compliance-ignore-file: flutter-http-timeout (Dio injected from base_sdk HttpService (see the DI), whose BaseOptions set connect/receive/send timeouts centrally)

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:base_sdk/base_sdk.dart';
import '../../domain/interface/subscription_facade.dart';
import '../models/data/subscriptions_data.dart';
import '../models/response/subscriptions_response.dart';
import '../models/response/transactions_response.dart';

/// Calls `agent/subscriptions/frappe`'s composed module over the app's
/// shared Dio client, through the universal platform gateway: every call is
/// a POST to [_gatewayPath] with a `{"cmd", "payload"}` body. Cmd names
/// mirror that module's `manifest.json` whitelisted-method aliases with the
/// `{app_name}` segment dropped (`api.subscription.*`), same as the sibling
/// SDK clients ([HttpLmsRepository], `FrappeStationsSource`) — the
/// Laravel-era `/api/v1/...` REST marketplace paths are not served by the
/// composed Frappe backend.
class SubscriptionsRepository implements SubscriptionsFacade {
  /// The universal platform gateway entry point. Kept on the injected
  /// [_client] (rather than base_sdk's [PlatformGateway]) so tests and
  /// non-standard hosts keep controlling the transport.
  static const _gatewayPath = '/api/v1/method/rokct.platform.api';

  /// Prefix-free cmd base: the old `paas.api.subscription.*` dotted
  /// endpoints with the leading app segment stripped.
  static const _cmd = 'api.subscription';

  final Dio _client;
  final AppDatabase _database;
  final String? Function()? _localeCallback;

  SubscriptionsRepository(this._client, this._database, {String? Function()? localeCallback})
    : _localeCallback = localeCallback;

  /// Page size asked of `list_subscriptions` (its server-side maximum).
  static const int catalogPageSize = 100;

  /// Safety stop for the paging loop: never more than this many pages.
  static const int _maxCatalogPages = 50;

  @override
  Future<ApiResult<SubscriptionResponse>> getSubscriptions({
    required int page,
    String? locale,
  }) async {
    final activeLocale = locale ?? _localeCallback?.call();
    // Page 1 returns the WHOLE plan catalog: list_subscriptions is paged
    // server-side (start/limit), and this walks every page until a short
    // one, so a catalog bigger than one page is never cut off. Later pages
    // are reported empty so load-more footers terminate instead of
    // re-appending the same rows.
    if (page > 1) {
      return ApiResult.success(data: SubscriptionResponse(data: const []));
    }
    try {
      final all = <SubscriptionData>[];
      for (var i = 0; i < _maxCatalogPages; i++) {
        final response = await _client.post(
          _gatewayPath,
          // Frappe drops kwargs the whitelisted method does not declare, so
          // `lang` is inert today; it stays on the wire to keep the
          // facade's locale contract when the composed backend grows
          // translations.
          data: {
            'cmd': '$_cmd.list_subscriptions',
            'payload': {
              'lang': activeLocale,
              'start': all.length,
              'limit': catalogPageSize,
            },
          },
        );
        final rows = _parseSubscriptionList(response.data).data ?? const [];
        all.addAll(rows);
        if (rows.length < catalogPageSize) break;
      }
      // NOT cached as the user's subscription: these are the plan CATALOG
      // (`active` there means "published"), not anything the user holds.
      // The user's own subscription is cached from the purchase result
      // (see purchaseSubscription).
      return ApiResult.success(data: SubscriptionResponse(data: all));
    } catch (e, s) {
      debugPrint('==> get subscription failure: $e,$s');
      return ApiResult.failure(
        error: NetworkHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  /// FrappeResponseInterceptor already unwraps `{'message': ...}` on 2xx;
  /// tolerate both shapes for overridden clients, plus the legacy
  /// `{data: [...]}` envelope, and map a bare Frappe row list into the
  /// response type the facade promises.
  SubscriptionResponse _parseSubscriptionList(dynamic body) {
    final message =
        body is Map && body.containsKey('message') ? body['message'] : body;
    if (message is List) {
      return SubscriptionResponse(
        data: message
            .whereType<Map>()
            .map((e) => SubscriptionData.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
      );
    }
    if (message is Map) {
      return SubscriptionResponse.fromJson(Map<String, dynamic>.from(message));
    }
    return SubscriptionResponse(data: const []);
  }

  /// Writes the user's OWN subscription — the Shop Subscription row
  /// `subscribe_my_shop` returns after a paid purchase — into the shared
  /// database's generic 'user_subscriptions' box, keyed by the
  /// authenticated user (persisted at login by auth_sdk, read through
  /// [LocalStorage.getUser]). The row is MERGED, so keys other SDKs keep
  /// there survive. Only fields the purchase row actually carries are
  /// written: no title is made up (the row names its plan by docname, not
  /// a display title), and missing subjects keep the last-known-good
  /// value. Failures are logged but never break the purchase result.
  Future<void> _cacheOwnSubscription(Map<String, dynamic> row) async {
    final userId = LocalStorage.getUser()?.id?.toString();
    if (userId == null || userId.isEmpty) {
      debugPrint(
        '==> skipping subscription cache write: no authenticated user in session',
      );
      return;
    }
    try {
      final held = SubscriptionData.fromJson(row);
      final existing =
          await _database.getItem('user_subscriptions', userId) ?? {};
      await _database.putItem('user_subscriptions', userId, {
        ...existing,
        'userId': userId,
        'status': held.type ?? existing['status'] ?? 'inactive',
        'active': held.active ?? false,
        'expiryDate': held.expiredAt?.toIso8601String(),
        if (held.allowedSubjects != null)
          'allowedSubjects': jsonEncode(held.allowedSubjects),
      });
    } catch (dbErr, st) {
      debugPrint('==> subscription local cache write failure: $dbErr\n$st');
    }
  }

  @override
  Future<ApiResult> purchaseSubscription({
    required int id,
    required int paymentId,
    String? ref,
    String? beneficiaryUserId,
  }) async {
    final data = {
      // subscribe_my_shop's own argument: the plan's Frappe document name
      // ([ref]) when the row carries one, falling back to the legacy
      // numeric id for stored rows that predate the composed backend.
      'subscription_id': ref ?? id,
      // Not consumed by subscribe_my_shop (Frappe drops undeclared kwargs;
      // the server charges the caller's wallet itself); kept on the wire
      // per decision log #23/#30 until the owner decides the card-payment
      // path.
      'payment_sys_id': paymentId,
      // Delegated billing (see the facade doc): only sent when purchasing
      // for another account, so the self-purchase wire shape is unchanged.
      if (beneficiaryUserId != null) 'beneficiary_user_id': beneficiaryUserId,
    };
    try {
      final response = await _client.post(
        _gatewayPath,
        data: {'cmd': '$_cmd.subscribe_my_shop', 'payload': data},
      );
      // subscribe_my_shop charges the caller's wallet and only then
      // returns the new, active Shop Subscription document (plus
      // `charged` / `wallet_balance`); an unpaid request is refused with
      // an error and activates nothing. Its Frappe `name` identifies the
      // purchase. The legacy `{data: {id}}` envelope is still tolerated
      // for overridden clients.
      final body = response.data;
      final message =
          body is Map && body.containsKey('message') ? body['message'] : body;
      final dynamic identifier = message is Map
          ? (message['name'] ??
              (message['data'] is Map ? message['data']['id'] : null))
          : null;
      // A paid purchase IS the user's own subscription: cache it for
      // offline readers (never the catalog rows).
      if (message is Map && message['name'] != null) {
        await _cacheOwnSubscription(Map<String, dynamic>.from(message));
      }
      return ApiResult.success(data: identifier);
    } catch (e) {
      debugPrint('==> purchase ads failure: $e');
      return ApiResult.failure(
        error: NetworkHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  /// DEAD LEGACY SEAM — no longer part of the purchase flow:
  /// `subscribe_my_shop` now charges the wallet itself and activates only
  /// once paid, so the notifier no longer calls this. Kept only so existing
  /// facade implementers still compile.
  ///
  /// Deliberately NOT migrated to `paas.api.*`. The
  /// composed Frappe backend exposes no payment-transaction alias (see
  /// `agent/subscriptions/frappe/manifest.json`): `subscribe_my_shop` is the
  /// entire purchase, and decision log #30 records this transactions path as
  /// belonging to the external legacy marketplace backend. Pointing it at an
  /// invented `paas.api.subscription.*` path would fabricate a payment
  /// record, so it stays on the legacy path (and fails honestly) until the
  /// real payment integration (decision #33/#34 direction) lands.
  @Deprecated('subscribe_my_shop charges and activates in one call.')
  @override
  Future<ApiResult<SubscriptionTransactionsResponse>> createTransaction({
    required Object id,
    required int paymentId,
    String? beneficiaryUserId,
  }) async {
    final data = {
      'payment_sys_id': paymentId,
      if (beneficiaryUserId != null) 'beneficiary_user_id': beneficiaryUserId,
    };
    debugPrint('===> create transaction body: ${jsonEncode(data)}');
    debugPrint('===> create transaction subscriptions id: $id');
    try {
      final response = await _client.post(
        '/api/v1/payments/subscription/$id/transactions',
        data: data,
      );
      return ApiResult.success(
        data: SubscriptionTransactionsResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> create transaction failure: $e');
      return ApiResult.failure(
        error: NetworkHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }
}
