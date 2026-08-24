import 'package:paas_customer/infrastructure/models/data/help_data.dart';
import 'package:paas_customer/infrastructure/models/data/notification_list_data.dart';

import 'package:paas_customer/domain/handlers/handlers.dart';
import 'package:paas_customer/infrastructure/models/data/translation.dart';
import 'package:paas_customer/infrastructure/models/models.dart';

abstract class SettingsRepositoryFacade {
  Future<ApiResult<GlobalSettingsResponse>> getGlobalSettings();

  Future<ApiResult<MobileTranslationsResponse>> getMobileTranslations();

  Future<ApiResult<LanguagesResponse>> getLanguages();

  Future<ApiResult<NotificationsListModel>> getNotificationList();

  Future<ApiResult<dynamic>> updateNotification(
    List<NotificationData>? notifications,
  );

  Future<ApiResult<HelpModel>> getFaq();

  Future<ApiResult<Translation>> getTerm();

  Future<ApiResult<Translation>> getPolicy();
}
