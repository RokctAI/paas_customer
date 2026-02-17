import 'package:foodyman/domain/handlers/api_result.dart';
import 'package:foodyman/domain/interface/settings.dart';
import 'package:foodyman/infrastructure/models/data/help_data.dart';
import 'package:foodyman/infrastructure/models/data/notification_list_data.dart';
import 'package:foodyman/infrastructure/models/data/translation.dart';
import 'package:foodyman/infrastructure/models/response/global_settings_response.dart';
import 'package:foodyman/infrastructure/models/response/languages_response.dart';
import 'package:foodyman/infrastructure/models/response/mobile_translations_response.dart';

class MockSettingsRepository implements SettingsRepositoryFacade {
  @override
  Future<ApiResult<HelpModel>> getFaq() async {
    return ApiResult.success(
      data: HelpModel(
        data: [
          HelpData(
            id: 1,
            question: "How to order?",
            answer: "Select items, add to cart, and checkout.",
            translation: Translation(title: "How to order?", description: "Select items and checkout"),
          )
        ],
      ),
    );
  }

  @override
  Future<ApiResult<GlobalSettingsResponse>> getGlobalSettings() async {
    return ApiResult.success(
      data: GlobalSettingsResponse(
        data: [
          SettingsData(key: "app_name", value: "Juvo Demo"),
          SettingsData(key: "default_currency", value: "USD"),
          SettingsData(key: "default_tax", value: "10"),
          SettingsData(key: "deliveryman_order_acceptance_time", value: "30"),
          SettingsData(key: "google_maps_key", value: "DEMO_KEY"),
        ],
      ),
    );
  }

  @override
  Future<ApiResult<LanguagesResponse>> getLanguages() async {
    return ApiResult.success(
      data: LanguagesResponse(
        data: [
          LanguageData(
            id: 1,
            title: "English",
            backward: false,
            isDefault: true,
            locale: "en",
          ),
        ],
      ),
    );
  }

  @override
  Future<ApiResult<MobileTranslationsResponse>> getMobileTranslations() async {
    return ApiResult.success(
      data: MobileTranslationsResponse(
        data: {
          "home": "Home",
          "cart": "Cart",
          "profile": "Profile",
        },
      ),
    );
  }

  @override
  Future<ApiResult<NotificationsListModel>> getNotificationList() async {
     return ApiResult.success(
      data: NotificationsListModel(
        data: [
           NotificationData(
            id: 1,
            type: "order",
            title: "Order Update",
            body: "Your order has been placed.",
            readAt: null,
            createdAt: DateTime.now().toIso8601String(),
           )
        ]
      ),
    );
  }

  @override
  Future<ApiResult<Translation>> getPolicy() async {
    return ApiResult.success(
      data: Translation(
        title: "Privacy Policy",
        description: "This is a demo privacy policy.",
      ),
    );
  }

  @override
  Future<ApiResult<Translation>> getTerm() async {
     return ApiResult.success(
      data: Translation(
        title: "Terms of Service",
        description: "These are demo terms of service.",
      ),
    );
  }

  @override
  Future<ApiResult> updateNotification(List<NotificationData>? notifications) async {
    return ApiResult.success(data: null);
  }
}
