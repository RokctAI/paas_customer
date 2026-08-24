import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paas_customer/domain/di/dependency_manager.dart';

import 'setting_notifier.dart';
import 'setting_state.dart';

final settingProvider = StateNotifierProvider<SettingNotifier, SettingState>(
  (ref) => SettingNotifier(settingsRepository, userRepository),
);
