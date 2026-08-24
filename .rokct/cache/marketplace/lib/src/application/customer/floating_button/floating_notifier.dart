import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:marketplace_sdk/src/application/customer/floating_button/floating_state.dart';

class FloatingNotifier extends StateNotifier<FloatingState> {
  FloatingNotifier() : super(const FloatingState());

  void changeScrolling(bool isScrolling) {
    state = state.copyWith(isScrolling: isScrolling);
  }
}
