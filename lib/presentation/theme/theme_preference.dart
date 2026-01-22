import 'package:shared_preferences/shared_preferences.dart';

class ThemePreference {
  final SharedPreferences _preferences;

  static const prefKey = 'theme_mode';

  ThemePreference._(this._preferences);

  static Future<ThemePreference> get create async {
    final preference = await SharedPreferences.getInstance();
    return ThemePreference._(preference);
  }

  CustomThemeMode getMode() {
    final modeKey =
        _preferences.getString(ThemePreference.prefKey) ??
        CustomThemeMode.light.toKey;

    return CustomThemeModeX.toValue(modeKey);
  }

  Future<void> setMode(CustomThemeMode mode) async {
    await _preferences.setString(ThemePreference.prefKey, mode.toKey);
  }

  Future<void> clean() async {
    await _preferences.clear();
  }
}

extension CustomThemeModeX on CustomThemeMode {
  static const light = 'light';
  static const dark = 'dark';

  bool get isLight => this == CustomThemeMode.light;

  bool get isDark => this == CustomThemeMode.dark;

  String get toKey => toString().split('.')[1];

  static CustomThemeMode toValue(String key) {
    if (key == light) {
      return CustomThemeMode.light;
    }
    return CustomThemeMode.dark;
  }
}

enum CustomThemeMode { light, dark }
