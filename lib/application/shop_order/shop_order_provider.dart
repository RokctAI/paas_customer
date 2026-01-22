import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'shop_order_notifier.dart';
import 'shop_order_state.dart';

final shopOrderProvider = NotifierProvider<ShopOrderNotifier, ShopOrderState>(
  () => ShopOrderNotifier(),
);
