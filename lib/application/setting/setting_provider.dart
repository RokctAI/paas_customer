import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'setting_notifier.dart';
import 'setting_state.dart';

final settingProvider = NotifierProvider<SettingNotifier, SettingState>(
  () => SettingNotifier(),
);
