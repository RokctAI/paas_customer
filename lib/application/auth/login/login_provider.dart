import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'login_notifier.dart';
import 'login_state.dart';

final loginProvider = NotifierProvider.autoDispose<LoginNotifier, LoginState>(
  () => LoginNotifier(),
);
