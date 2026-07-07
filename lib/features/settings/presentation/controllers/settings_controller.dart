// ignore: unused_import
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/app_settings.dart';

class SettingsController extends StateNotifier<AppSettings> {
  SettingsController() : super(const AppSettings());
  void setThemeMode(AppThemeModeChoice m) => state = state.copyWith(themeMode: m);
  void setLanguage(AppLanguage l) => state = state.copyWith(language: l);
  void toggleNotifications(bool v) => state = state.copyWith(notificationsEnabled: v);
  void toggleBiometric(bool v) => state = state.copyWith(biometricEnabled: v);
  void toggleReduceMotion(bool v) => state = state.copyWith(reduceMotion: v);
  void toggleHighContrast(bool v) => state = state.copyWith(highContrast: v);
  void setTextScale(double v) => state = state.copyWith(textScale: v);
}
final settingsControllerProvider = StateNotifierProvider<SettingsController, AppSettings>((ref) => SettingsController());
