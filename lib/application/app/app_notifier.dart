import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodyman/infrastructure/models/models.dart';
import 'package:foodyman/infrastructure/services/services.dart';
import 'app_state.dart';

class AppNotifier extends Notifier<AppState> {
  @override
  AppState build() {
    final state = const AppState();
    Future.microtask(() => fetchThemeAndLocale());
    return state;
  }

  Future<void> fetchThemeAndLocale() async {
    final isDarkMode = LocalStorage.getAppThemeMode();
    final lang = LocalStorage.getLanguage();
    final ltr = LocalStorage.getLangLtr();
    state = state.copyWith(
      isDarkMode: isDarkMode,
      activeLanguage: lang,
      isLtr: ltr,
    );
  }


  Future<void> changeLocale(LanguageData? language) async {
    await LocalStorage.setLanguageData(language);
    await LocalStorage.setLangLtr(language?.backward);
    state = state.copyWith(
      activeLanguage: language,
      isLtr: !(language?.backward ?? false),
    );
  }
}
