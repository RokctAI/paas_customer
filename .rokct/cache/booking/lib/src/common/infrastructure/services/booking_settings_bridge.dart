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

import 'package:get_it/get_it.dart';

import 'package:base_sdk/src/domain/interface/settings.dart';
import 'package:base_sdk/src/handlers/handlers.dart';
import 'package:base_sdk/src/models/data/help_data.dart';
import 'package:base_sdk/src/models/data/notification_list_data.dart';
import 'package:base_sdk/src/models/data/translation.dart';
import 'package:base_sdk/src/models/models.dart';
import 'package:base_sdk/src/services/local_storage.dart';
import 'package:booking_sdk/src/common/domain/interface/booking.dart';

/// The visibility flag, without touching core.
///
/// base_sdk's `AppHelpers.getReservationEnable()` (and marketplace's
/// profile gate on it) reads the `reservation_enable_for_user` key from the
/// cached global settings list, which comms_sdk's splash fills from
/// `get_global_settings` every boot. That core endpoint does not serve the
/// key; the booking-owned `api.booking.get_booking_settings` does. So this
/// decorator wraps whatever [SettingsRepositoryFacade] is registered and
/// merges the booking flag into `getGlobalSettings()`'s result before the
/// splash caches it. Every other facade method is delegated unchanged.
///
/// Installed from booking_sdk's `booking-settings-bridge` di_hook, which
/// the installer emits AFTER the generated `*SdkDependencies.register`
/// block - i.e. after comms_sdk registered the facade. Fail-open: a
/// booking failure returns the inner result untouched, and a compose with
/// no settings facade falls back to a one-shot merge into the cached list.
class BookingSettingsBridge implements SettingsRepositoryFacade {
  static const String flagKey = 'reservation_enable_for_user';

  final SettingsRepositoryFacade _inner;
  final BookingRepositoryFacade _booking;

  BookingSettingsBridge(this._inner, this._booking);

  static void install(GetIt getIt) {
    if (!getIt.isRegistered<BookingRepositoryFacade>()) return;
    final booking = getIt<BookingRepositoryFacade>();
    if (!getIt.isRegistered<SettingsRepositoryFacade>()) {
      // No comms_sdk in this compose: nothing refreshes the cached
      // settings, so merge the flag into the cache directly, once.
      // ignore: discarded_futures
      refreshCachedFlag(booking);
      return;
    }
    final current = getIt<SettingsRepositoryFacade>();
    if (current is BookingSettingsBridge) return;
    getIt.unregister<SettingsRepositoryFacade>();
    getIt.registerSingleton<SettingsRepositoryFacade>(
      BookingSettingsBridge(current, booking),
    );
  }

  /// Writes the flag straight into `LocalStorage`'s cached settings list.
  static Future<void> refreshCachedFlag(BookingRepositoryFacade booking) async {
    final result = await booking.getBookingSettings();
    switch (result) {
      case Success(:final data):
        await LocalStorage.setSettingsList(
          mergeFlag(LocalStorage.getSettingsList(), data.reservationsEnabled),
        );
      case Failure():
        return;
    }
  }

  /// [settings] with `reservation_enable_for_user` set to [enabled]
  /// (replacing an existing row, else appending one).
  static List<SettingsData> mergeFlag(
      List<SettingsData>? settings, bool enabled) {
    final out = <SettingsData>[
      for (final s in settings ?? const <SettingsData>[])
        if (s.key != flagKey) s,
    ];
    out.add(SettingsData(key: flagKey, value: enabled ? '1' : '0'));
    return out;
  }

  @override
  Future<ApiResult<GlobalSettingsResponse>> getGlobalSettings() async {
    final result = await _inner.getGlobalSettings();
    switch (result) {
      case Failure():
        return result;
      case Success(:final data):
        final flag = await _booking.getBookingSettings();
        switch (flag) {
          case Failure():
            return result;
          case Success(data: final settings):
            return ApiResult.success(
              data: data.copyWith(
                data: mergeFlag(data.data, settings.reservationsEnabled),
              ),
            );
        }
    }
  }

  @override
  Future<ApiResult<MobileTranslationsResponse>> getMobileTranslations() =>
      _inner.getMobileTranslations();

  @override
  Future<ApiResult<LanguagesResponse>> getLanguages() => _inner.getLanguages();

  @override
  Future<ApiResult<NotificationsListModel>> getNotificationList() =>
      _inner.getNotificationList();

  @override
  Future<ApiResult<dynamic>> updateNotification(
          List<NotificationData>? notifications) =>
      _inner.updateNotification(notifications);

  @override
  Future<ApiResult<HelpModel>> getFaq() => _inner.getFaq();

  @override
  Future<ApiResult<Translation>> getTerm() => _inner.getTerm();

  @override
  Future<ApiResult<Translation>> getPolicy() => _inner.getPolicy();
}
