import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:orders_sdk/src/application/customer/auto_order/auto_order_state.dart';
import 'package:orders_sdk/src/application/customer/auto_order/auto_order_notifier.dart';

final autoOrderProvider =
    StateNotifierProvider.autoDispose<AutoOrderNotifier, AutoOrderState>(
  (ref) => AutoOrderNotifier(),
);
