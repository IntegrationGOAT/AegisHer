enum AppThemeModeChoice { system, light, dark }
enum AppLanguage { english, hindi, spanish }
class AppSettings {
  final AppThemeModeChoice themeMode;
  final AppLanguage language;
  final bool notificationsEnabled;
  final bool biometricEnabled;
  final bool reduceMotion;
  final bool highContrast;
  final double textScale;
  const AppSettings({
    this.themeMode = AppThemeModeChoice.system,
    this.language = AppLanguage.english,
    this.notificationsEnabled = true,
    this.biometricEnabled = false,
    this.reduceMotion = false,
    this.highContrast = false,
    this.textScale = 1.0,
  });
  AppSettings copyWith({AppThemeModeChoice? themeMode, AppLanguage? language, bool? notificationsEnabled, bool? biometricEnabled, bool? reduceMotion, bool? highContrast, double? textScale}) =>
      AppSettings(
        themeMode: themeMode ?? this.themeMode,
        language: language ?? this.language,
        notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
        biometricEnabled: biometricEnabled ?? this.biometricEnabled,
        reduceMotion: reduceMotion ?? this.reduceMotion,
        highContrast: highContrast ?? this.highContrast,
        textScale: textScale ?? this.textScale,
      );
}
