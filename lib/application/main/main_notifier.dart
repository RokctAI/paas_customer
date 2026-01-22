import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodyman/infrastructure/services/services.dart';

import 'main_state.dart';

class MainNotifier extends Notifier<MainState> {
  @override
  MainState build() => const MainState();

  void selectIndex(int index) {
    state = state.copyWith(selectIndex: index);
  }

  bool checkGuest() {
    return LocalStorage.getToken().isEmpty;
  }

  void changeScrolling(bool isScrolling) {
    state = state.copyWith(isScrolling: isScrolling);
  }
}
