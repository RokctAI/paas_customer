import 'dart:async';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

import '../../app_constants.dart';
import '../models/data/order_active_model.dart';
import 'local_storage.dart';

class WebSocketConnection {
  IOWebSocketChannel connect(String path) {
    return IOWebSocketChannel.connect(
      Uri.parse(AppConstants.wsBaseUrl + path),
      headers: {
        // "Origin": AppConstants.baseUrl,
        'Authorization': LocalStorage.getToken(),
      },
    );
  }
}

class WebSocketOrderClient {
  final int orderId;
  Function(double, double)? driverLocationEvent;
  ValueChanged<OrderActiveModel>? orderUpdateEvent;
  IOWebSocketChannel? _channel;
  Timer? _pingTimer;
  Timer? _reconnectTimer;

  WebSocketOrderClient({
    required this.orderId,
    this.orderUpdateEvent,
    this.driverLocationEvent,
  });

  void connect() {
    debugPrint('🔌 Connecting...');
  }

  void dispose() {
    _pingTimer?.cancel();
    _reconnectTimer?.cancel();
    _channel?.sink.close();
  }
}