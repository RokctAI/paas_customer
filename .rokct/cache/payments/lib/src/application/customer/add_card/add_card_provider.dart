import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:payments_sdk/src/application/customer/add_card/add_card_notifier.dart';
import 'package:payments_sdk/src/application/customer/add_card/add_card_state.dart';

final addCardProvider = StateNotifierProvider<AddCardNotifier, AddCardState>(
  (ref) => AddCardNotifier(),
);
