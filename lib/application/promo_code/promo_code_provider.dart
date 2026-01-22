import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'promo_code_notifier.dart';
import 'promo_code_state.dart';

final promoCodeProvider = NotifierProvider<PromoCodeNotifier, PromoCodeState>(
  () => PromoCodeNotifier(),
);
