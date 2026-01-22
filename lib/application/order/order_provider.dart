import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'order_notifier.dart';
import 'order_state.dart';

final orderProvider = NotifierProvider.autoDispose<OrderNotifier, OrderState>(
  () => OrderNotifier(),
);
