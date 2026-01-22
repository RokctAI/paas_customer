import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'select_state.dart';
import 'select_notifier.dart';

final selectProvider =
    NotifierProvider.autoDispose<SelectNotifier, SelectState>(
      () => SelectNotifier(),
    );
