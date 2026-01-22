import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'currency_notifier.dart';
import 'currency_state.dart';

final currencyProvider = NotifierProvider<CurrencyNotifier, CurrencyState>(
  () => CurrencyNotifier(),
);
