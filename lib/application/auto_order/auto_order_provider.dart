import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auto_order_state.dart';
import 'auto_order_notifier.dart';

final autoOrderProvider =
    NotifierProvider.autoDispose<AutoOrderNotifier, AutoOrderState>(
      () => AutoOrderNotifier(),
    );
