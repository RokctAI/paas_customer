import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'language_notifier.dart';
import 'language_state.dart';

final languageProvider = NotifierProvider<LanguageNotifier, LanguageState>(
  () => LanguageNotifier(),
);
