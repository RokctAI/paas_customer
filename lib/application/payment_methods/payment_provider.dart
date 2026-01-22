import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'payment_notifier.dart';
import 'payment_state.dart';

final paymentProvider = NotifierProvider<PaymentNotifier, PaymentState>(
  () => PaymentNotifier(),
);
