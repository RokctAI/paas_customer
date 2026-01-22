
import '../data/translation.dart';

class PagesResponse {
  final List<PageData> data;

  PagesResponse({required this.data});

  factory PagesResponse.fromJson(Map<String, dynamic> json) {
    return PagesResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => PageData.fromJson(e))
          .toList(),
    );
  }
}

class PageData {
  final int id;
  final String type;
  final String img;
  final bool active;
  final Buttons? buttons;
  final String? createdAt;
  final String? updatedAt;
  final Translation? translation;
  final List<Translation> translations;
  final List<String> locales;

  PageData({
    required this.id,
    required this.type,
    required this.img,
    required this.active,
    required this.buttons,
    required this.createdAt,
    required this.updatedAt,
    required this.translation,
    required this.translations,
    required this.locales,
  });

  factory PageData.fromJson(Map<String, dynamic> json) {
    return PageData(
      id: json['id'],
      type: json['type'] ?? '',
      img: json['img'] ?? '',
      active: json['active'] ?? false,
      buttons:
      json['buttons'] != null ? Buttons.fromJson(json['buttons']) : null,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      translation: json['translation'] != null
          ? Translation.fromJson(json['translation'])
          : null,
      translations: (json['translations'] as List<dynamic>)
          .map((e) => Translation.fromJson(e))
          .toList(),
      locales: List<String>.from(json['locales'] ?? []),
    );
  }
}

class Buttons {
  final String? appStoreButtonLink;
  final String? googlePlayButtonLink;

  Buttons({
    this.appStoreButtonLink,
    this.googlePlayButtonLink,
  });

  factory Buttons.fromJson(Map<String, dynamic> json) {
    return Buttons(
      appStoreButtonLink: json['app_store_button_link'],
      googlePlayButtonLink: json['google_play_button_link'],
    );
  }
}


