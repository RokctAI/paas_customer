import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'add_card_notifier.dart';
import 'add_card_state.dart';

final addCardProvider = NotifierProvider<AddCardNotifier, AddCardState>(
  () => AddCardNotifier(),
);
