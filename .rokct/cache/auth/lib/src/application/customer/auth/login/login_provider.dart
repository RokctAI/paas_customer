import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:base_sdk/src/di/injection.dart';

import 'package:auth_sdk/src/application/customer/auth/login/login_notifier.dart';
import 'package:auth_sdk/src/application/customer/auth/login/login_state.dart';

final loginProvider =
    StateNotifierProvider.autoDispose<LoginNotifier, LoginState>(
  (ref) => LoginNotifier(authRepository, settingsRepository, userRepository),
);
