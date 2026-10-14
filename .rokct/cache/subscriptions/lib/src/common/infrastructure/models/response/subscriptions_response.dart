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


import '../data/subscriptions_data.dart';

class SubscriptionResponse {
  DateTime? timestamp;
  bool? status;
  String? message;
  List<SubscriptionData>? data;

  SubscriptionResponse({this.timestamp, this.status, this.message, this.data});

  SubscriptionResponse copyWith({
    DateTime? timestamp,
    bool? status,
    String? message,
    List<SubscriptionData>? data,
  }) => SubscriptionResponse(
    timestamp: timestamp ?? this.timestamp,
    status: status ?? this.status,
    message: message ?? this.message,
    data: data ?? this.data,
  );

  factory SubscriptionResponse.fromJson(Map<String, dynamic> json) =>
      SubscriptionResponse(
        timestamp: json["timestamp"] == null
            ? null
            : DateTime.parse(json["timestamp"]),
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<SubscriptionData>.from(
                json["data"]!.map((x) => SubscriptionData.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "timestamp": timestamp?.toIso8601String(),
    "status": status,
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}
