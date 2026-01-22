import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_notifier.dart';
import 'app_state.dart';

final appProvider = NotifierProvider<AppNotifier, AppState>(
  () => AppNotifier(),
);
