import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paas_customer/domain/di/dependency_manager.dart';

import 'language_notifier.dart';
import 'language_state.dart';

final languageProvider = StateNotifierProvider<LanguageNotifier, LanguageState>(
  (ref) => LanguageNotifier(settingsRepository),
);
