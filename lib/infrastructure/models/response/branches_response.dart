import 'package:foodyman/infrastructure/models/data/order_body_data.dart';
import 'package:foodyman/infrastructure/models/data/shop_data.dart';

import '../data/links.dart';
import '../data/meta.dart';
import '../data/translation.dart';

class BranchResponse {
  BranchResponse({this.data, this.links, this.meta});

  List<BranchModel>? data;
  Links? links;
  Meta? meta;

  BranchResponse copyWith({
    List<BranchModel>? data,
    Links? links,
    Meta? meta,
  }) => BranchResponse(
    data: data ?? this.data,
    links: links ?? this.links,
    meta: meta ?? this.meta,
  );

  factory BranchResponse.fromJson(Map<String, dynamic> json) => BranchResponse(
    data: json["data"] == null
        ? []
        : List<BranchModel>.from(
            json["data"]!.map((x) => BranchModel.fromJson(x)),
          ),
    links: json["links"] == null ? null : Links.fromJson(json["links"]),
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
    "links": links?.toJson(),
    "meta": meta?.toJson(),
  };
}

class BranchModel {
  BranchModel({
    this.id,
    this.address,
    this.location,
    this.createdAt,
    this.updatedAt,
    this.shop,
    this.translation,
    this.locales,
  });

  int? id;
  AddressModel? address;
  Location? location;
  DateTime? createdAt;
  DateTime? updatedAt;
  ShopData? shop;
  Translation? translation;
  List<String>? locales;

  BranchModel copyWith({
    int? id,
    AddressModel? address,
    Location? location,
    DateTime? createdAt,
    DateTime? updatedAt,
    ShopData? shop,
    Translation? translation,
    List<String>? locales,
  }) => BranchModel(
    id: id ?? this.id,
    address: address ?? this.address,
    location: location ?? this.location,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    shop: shop ?? this.shop,
    translation: translation ?? this.translation,
    locales: locales ?? this.locales,
  );

  factory BranchModel.fromJson(Map<String, dynamic> json) => BranchModel(
    id: json["id"],
    address: json["address"] == null
        ? null
        : AddressModel.fromJson(json["address"]),
    location: json["location"] == null
        ? null
        : Location.fromJson(json["location"]),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.tryParse(json["created_at"])?.toLocal(),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.tryParse(json["updated_at"])?.toLocal(),
    shop: json["shop"] == null ? null : ShopData.fromJson(json["shop"]),
    translation: json["translation"] == null
        ? null
        : Translation.fromJson(json["translation"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "address": address?.toJson(),
    "location": location?.toJson(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "shop": shop?.toJson(),
    "translation": translation?.toJson(),
    "locales": locales == null
        ? []
        : List<dynamic>.from(locales!.map((x) => x)),
  };
}
