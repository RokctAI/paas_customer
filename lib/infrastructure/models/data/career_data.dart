import 'package:foodyman/infrastructure/models/data/product_data.dart';

import 'translation.dart';

class CareerData {
  int? id;
  int? categoryId;
  bool? active;
  DateTime? createdAt;
  DateTime? updatedAt;
  Category? category;
  Translation? translation;
  List<Translation>? translations;
  List<String>? locales;

  CareerData({
    this.id,
    this.categoryId,
    this.active,
    this.createdAt,
    this.updatedAt,
    this.category,
    this.translation,
    this.translations,
    this.locales,
  });

  factory CareerData.fromJson(Map<String, dynamic> json) {
    return CareerData(
      id: json["id"],
      categoryId: json["category_id"],
      active: json["active"],
      createdAt: json["created_at"] == null
          ? null
          : DateTime.tryParse(json["created_at"]),
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.tryParse(json["updated_at"]),

      category: json["category"] == null
          ? null
          : Category.fromJson(json["category"]),

      translation: json["translation"] == null
          ? null
          : Translation.fromJson(json["translation"]),

      translations: json["translations"] == null
          ? []
          : List<Translation>.from(
              json["translations"].map((x) => Translation.fromJson(x)),
            ),

      locales: json["locales"] == null
          ? []
          : List<String>.from(json["locales"].map((x) => x)),
    );
  }
}
