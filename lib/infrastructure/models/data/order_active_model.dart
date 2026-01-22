import 'package:foodyman/infrastructure/models/data/refund_data.dart';
import 'package:foodyman/infrastructure/models/data/user.dart';
import 'package:foodyman/infrastructure/models/data/repeat_data.dart';
import '../models.dart';
import 'addons_data.dart';

class OrderActiveModel {
  OrderActiveModel({
    this.id,
    this.userId,
    this.totalPrice,
    this.originPrice,
    this.coupon,
    this.rate,
    this.tax,
    this.tips,
    this.commissionFee,
    this.status,
    this.location,
    this.address,
    this.deliveryType,
    this.deliveryMan,
    this.deliveryFee,
    this.otp,
    this.deliveryDate,
    this.deliveryTime,
    this.totalDiscount,
    this.serviceFee,
    this.createdAt,
    this.updatedAt,
    this.shop,
    this.repeat,
    this.user,
    this.details,
    this.currencyModel,
    this.transaction,
    this.review,
    this.refunds,
    this.ponumHistories,
    this.afterDeliveredImage,
    this.km,
    this.minute,
    this.orderStatusesData,
  });

  int? id;
  num? userId;
  num? totalPrice;
  num? originPrice;
  num? coupon;
  num? rate;
  num? tax;
  num? commissionFee;
  String? status;
  Location? location;
  AddressModel? address;
  String? deliveryType;
  num? tips;
  String? afterDeliveredImage;
  num? deliveryFee;
  num? otp;
  CurrencyModel? currencyModel;
  UserModel? deliveryMan;
  DateTime? deliveryDate;
  String? deliveryTime;
  num? totalDiscount;
  num? serviceFee;
  num? km;
  num? minute;
  DateTime? createdAt;
  DateTime? updatedAt;
  ShopData? shop;
  RepeatData? repeat;
  UserModel? user;
  List<OrderProduct>? details;
  List<RefundModel>? refunds;
  TransactionData? transaction;
  dynamic review;
  List<dynamic>? ponumHistories;
  OrderStatusesData? orderStatusesData;

  factory OrderActiveModel.fromJson(Map<String, dynamic> json) =>
      OrderActiveModel(
        id: json["data"]["id"],
        userId: json["data"]["user_id"],
        afterDeliveredImage: json["data"]["image_after_delivered"],
        totalPrice: json["data"]["total_price"],
        originPrice: json["data"]["origin_price"],
        coupon: json["data"]?["coupon"]?["price"],
        rate: json["data"]["rate"],
        tax: json["data"]["tax"],
        tips: json["data"]["tips"],
        currencyModel: json["data"]["currency"] != null
            ? CurrencyModel.fromJson(json["data"]["currency"])
            : null,
        commissionFee: json["data"]["commission_fee"],
        status: json["data"]["status"],
        location: json["data"]["location"] != null
            ? Location.fromJson(json["data"]["location"])
            : null,
        address: json["data"]["address"] != null
            ? AddressModel.fromJson(json["data"]["address"])
            : null,
        deliveryType: json["data"]["delivery_type"],
        deliveryFee: json["data"]["delivery_fee"],
        km: json["data"]["km"],
        minute: json["data"]["minute"],
        otp: json["data"]["otp"],
        deliveryMan: json["data"]["deliveryman"] != null
            ? UserModel.fromJson(json["data"]["deliveryman"])
            : null,
        orderStatusesData: json["data"]["data"] != null
            ? OrderStatusesData.fromJson(json["data"]["data"])
            : null,
        deliveryDate:
        DateTime.tryParse(json["data"]?["delivery_date"] ?? '')?.toLocal(),
        deliveryTime: json["data"]["delivery_time"],
        totalDiscount: json["data"]["total_discount"],
        serviceFee: json["data"]["service_fee"],
        createdAt: DateTime.tryParse(json["data"]["created_at"])?.toLocal(),
        updatedAt: DateTime.tryParse(json["data"]["updated_at"])?.toLocal(),
        shop: json["data"]["shop"] != null
            ? ShopData.fromJson(json["data"]["shop"])
            : null,
        repeat: json["data"]["repeat"] != null
            ? RepeatData.fromJson(json["data"]["repeat"])
            : null,
        user: json["data"]["user"] != null
            ? UserModel.fromJson(json["data"]["user"])
            : null,
        details: List<OrderProduct>.from(
            json["data"]["details"].map((x) => OrderProduct.fromJson(x))),
        transaction: json["data"]["transaction"] != null
            ? TransactionData.fromJson(json["data"]["transaction"])
            : null,
        refunds: json["data"]["order_refunds"] != null
            ? List<RefundModel>.from(json["data"]["order_refunds"]
            .map((x) => RefundModel.fromJson(x)))
            : [],
        review: json["data"]["review"],
      );

  factory OrderActiveModel.fromJsonWithoutData(Map<String, dynamic> json) {
    return OrderActiveModel(
      id: json["id"] ?? 0,
      userId: json["user_id"],
      afterDeliveredImage: json["image_after_delivered"],
      totalPrice: json["total_price"],
      originPrice: json["origin_price"],
      coupon: json["coupon"]?["price"],
      rate: json["rate"],
      tax: json["tax"],
      tips: json["tips"],
      currencyModel: json["currency"] != null
          ? CurrencyModel.fromJson(json["currency"])
          : null,
      commissionFee: json["commission_fee"],
      status: json["status"],
      location:
      json["location"] != null ? Location.fromJson(json["location"]) : null,
      orderStatusesData: json["data"] != null
          ? OrderStatusesData.fromJson(json["data"])
          : null,
      address: AddressModel.fromJson(json["address"]),
      deliveryType: json["delivery_type"],
      deliveryFee: json["delivery_fee"],
      km: json["km"],
      minute: json["minute"],
      otp: json["otp"],
      serviceFee: json["service_fee"],
      deliveryMan: json["deliveryman"] != null
          ? UserModel.fromJson(json["deliveryman"])
          : null,
      deliveryDate: DateTime.tryParse(json["delivery_date"] ?? '')?.toLocal(),
      deliveryTime: json["delivery_time"],
      totalDiscount: json["total_discount"],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json["created_at"])?.toLocal()
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json["updated_at"])?.toLocal()
          : null,
      shop: json["shop"] != null ? ShopData.fromJson(json["shop"]) : null,
      repeat:
      json["repeat"] != null ? RepeatData.fromJson(json["repeat"]) : null,
      user: json["user"] != null ? UserModel.fromJson(json["user"]) : null,
      details: json["details"] != null
          ? List<OrderProduct>.from(
          json["details"].map((x) => OrderProduct.fromJson(x)))
          : null,
      transaction: json["transaction"] != null
          ? TransactionData.fromJson(json["transaction"])
          : null,
      review: json["review"],
    );
  }

  OrderActiveModel copyWith({
    int? id,
    num? userId,
    num? totalPrice,
    num? originPrice,
    num? coupon,
    num? rate,
    num? tax,
    num? tips,
    num? commissionFee,
    String? status,
    Location? location,
    AddressModel? address,
    String? deliveryType,
    String? afterDeliveredImage,
    num? deliveryFee,
    num? otp,
    CurrencyModel? currencyModel,
    UserModel? deliveryMan,
    DateTime? deliveryDate,
    String? deliveryTime,
    num? totalDiscount,
    num? serviceFee,
    num? km,
    num? minute,
    DateTime? createdAt,
    DateTime? updatedAt,
    ShopData? shop,
    RepeatData? repeat,
    UserModel? user,
    List<OrderProduct>? details,
    List<RefundModel>? refunds,
    TransactionData? transaction,
    dynamic review,
    List<dynamic>? ponumHistories,
    OrderStatusesData? orderStatusesData,
  }) =>
      OrderActiveModel(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        totalPrice: totalPrice ?? this.totalPrice,
        originPrice: originPrice ?? this.originPrice,
        coupon: coupon ?? this.coupon,
        rate: rate ?? this.rate,
        tax: tax ?? this.tax,
        tips: tips ?? this.tips,
        commissionFee: commissionFee ?? this.commissionFee,
        status: status ?? this.status,
        location: location ?? this.location,
        address: address ?? this.address,
        deliveryType: deliveryType ?? this.deliveryType,
        afterDeliveredImage: afterDeliveredImage ?? this.afterDeliveredImage,
        deliveryFee: deliveryFee ?? this.deliveryFee,
        otp: otp ?? this.otp,
        currencyModel: currencyModel ?? this.currencyModel,
        deliveryMan: deliveryMan ?? this.deliveryMan,
        deliveryDate: deliveryDate ?? this.deliveryDate,
        deliveryTime: deliveryTime ?? this.deliveryTime,
        totalDiscount: totalDiscount ?? this.totalDiscount,
        serviceFee: serviceFee ?? this.serviceFee,
        km: km ?? this.km,
        minute: minute ?? this.minute,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        shop: shop ?? this.shop,
        repeat: repeat ?? this.repeat,
        user: user ?? this.user,
        details: details ?? this.details,
        refunds: refunds ?? this.refunds,
        transaction: transaction ?? this.transaction,
        review: review ?? this.review,
        ponumHistories: ponumHistories ?? this.ponumHistories,
        orderStatusesData: orderStatusesData ?? this.orderStatusesData,
      );
}

class OrderProduct {
  OrderProduct(
      {this.id,
        this.orderId,
        this.stockId,
        this.originPrice,
        this.totalPrice,
        this.tax,
        this.customName,
        this.discount,
        this.quantity,
        this.bonus,
        this.bonusShop,
        this.note,
        this.createdAt,
        this.updatedAt,
        this.stock,
        this.addons});

  num? id;
  num? orderId;
  num? stockId;
  num? originPrice;
  num? totalPrice;
  num? tax;
  num? discount;
  String? note;
  String? customName;
  int? quantity;
  bool? bonus;
  bool? bonusShop;
  DateTime? createdAt;
  DateTime? updatedAt;
  Stocks? stock;
  List<Addons>? addons;

  factory OrderProduct.fromJson(Map<String, dynamic> json) {
    return OrderProduct(
      id: json["id"] ?? 0,
      orderId: json["order_id"],
      stockId: json["stock_id"],
      originPrice: json["origin_price"],
      totalPrice: json["total_price"],
      tax: json["tax"],
      note: json["note"],
      customName: json["custom_name"],
      discount: json["discount"],
      quantity: json["quantity"],
      bonus: (json["bonus"].runtimeType == int)
          ? json["bonus"] == 1
          : json["bonus"],
      bonusShop: (json["bonus_shop"].runtimeType == int)
          ? json["bonus_shop"] == 1
          : json["bonus_shop"],
      createdAt: DateTime.tryParse(json["created_at"])?.toLocal(),
      updatedAt: DateTime.tryParse(json["updated_at"])?.toLocal(),
      addons: json['addons'] != null
          ? List<Addons>.from(json["addons"].map((x) {
        if (x["product"] != null || x["stock"] != null || x != null) {
          return Addons.fromJson(x);
        }
      }))
          : null,
      stock: json["stock"] != null ? Stocks.fromJson(json["stock"]) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_id": orderId,
    "stock_id": stockId,
    "origin_price": originPrice,
    "total_price": totalPrice,
    "tax": tax,
    "discount": discount,
    "quantity": quantity,
    "bonus": bonus,
    "custom_name": customName,
    "bonus_shop": bonusShop,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "stock": stock?.toJson(),
  };
}

class CurrencyModel {
  int? id;
  String? symbol;
  String? title;
  bool? active;

  CurrencyModel({this.id, this.symbol, this.title, this.active});

  CurrencyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    symbol = json['symbol'];
    title = json['title'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['symbol'] = symbol;
    data['title'] = title;
    data['active'] = active;
    return data;
  }
}

class OrderStatusesData {
  OrderStatusesData({
    OrderStatusesEditDate? statuses,
  }) {
    _statuses = statuses;
  }

  OrderStatusesData.fromJson(dynamic json) {
    _statuses = json['statuses'] != null
        ? OrderStatusesEditDate.fromJson(json['statuses'])
        : null;
  }

  OrderStatusesEditDate? _statuses;

  OrderStatusesData copyWith({
    OrderStatusesEditDate? statuses,
  }) =>
      OrderStatusesData(
        statuses: statuses ?? _statuses,
      );

  OrderStatusesEditDate? get statuses => _statuses;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_statuses != null) {
      map['statuses'] = _statuses?.toJson();
    }
    return map;
  }
}

class OrderStatusesEditDate {
  OrderStatusesEditDate({
    String? newStatus,
    String? accepted,
    String? cooking,
    String? ready,
    String? onAWay,
    String? delivered,
  }) {
    _new = newStatus;
    _accepted = accepted;
    _cooking = cooking;
    _ready = ready;
    _onAWay = onAWay;
    _delivered = delivered;
  }

  OrderStatusesEditDate.fromJson(dynamic json) {
    _new = json['new'];
    _accepted = json['accepted'];
    _cooking = json['cooking'];
    _ready = json['ready'];
    _onAWay = json['on_a_way'];
    _delivered = json['delivered'];
  }

  String? _new;
  String? _accepted;
  String? _cooking;
  String? _ready;
  String? _onAWay;
  String? _delivered;

  OrderStatusesEditDate copyWith({
    String? newStatus,
    String? accepted,
    String? cooking,
    String? ready,
    String? onAWay,
    String? delivered,
  }) =>
      OrderStatusesEditDate(
        newStatus: newStatus ?? _new,
        accepted: accepted ?? _accepted,
        cooking: cooking ?? _cooking,
        ready: ready ?? _ready,
        onAWay: onAWay ?? _onAWay,
        delivered: delivered ?? _delivered,
      );

  String? get newStatus => _new;

  String? get accepted => _accepted;

  String? get cooking => _cooking;

  String? get ready => _ready;

  String? get onAWay => _onAWay;

  String? get delivered => _delivered;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['new'] = _new;
    map['accepted'] = _accepted;
    map['cooking'] = _cooking;
    map['ready'] = _ready;
    map['on_a_way'] = _onAWay;
    return map;
  }
}