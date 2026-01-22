import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'orders_list_notifier.dart';
import 'orders_list_state.dart';

final ordersListProvider =
    NotifierProvider<OrdersListNotifier, OrdersListState>(
      () => OrdersListNotifier(),
    );
