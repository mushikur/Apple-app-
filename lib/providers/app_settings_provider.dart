import 'package:flutter/material.dart';
import 'package:samir_pet/models/app_settings.dart';
import 'package:samir_pet/models/pet_personality.dart';
import 'package:samir_pet/services/service_locator.dart';

/// AppSettingsProvider for reactive application settings persistence and state
class AppSettingsProvider extends ChangeNotifier {
  AppSettings _settings = const AppSettings();
  bool _isLoading = true;

  AppSettings get settings => _settings;
  bool get isLoading => _isLoading;

  Future<void> init() async {
    _settings = await ServiceLocator.storage.loadSettings();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateSettings(AppSettings newSettings) async {
    _settings = newSettings;
    notifyListeners();
    await ServiceLocator.storage.saveSettings(_settings);
  }

  Future<void> setPetName(String name) async {
    await updateSettings(_settings.copyWith(petName: name));
  }

  Future<void> setPersonality(PersonalityType type) async {
    await updateSettings(_settings.copyWith(personalityType: type));
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await updateSettings(_settings.copyWith(themeMode: mode));
  }

  Future<void> setPetSize(double size) async {
    await updateSettings(_settings.copyWith(petSize: size));
  }

  Future<void> setAnimationIntensity(double intensity) async {
    await updateSettings(_settings.copyWith(animationIntensity: intensity));
  }

  Future<void> setHapticsEnabled(bool enabled) async {
    await updateSettings(_settings.copyWith(hapticsEnabled: enabled));
  }

  Future<void> setVoiceEnabled(bool enabled) async {
    await updateSettings(_settings.copyWith(voiceEnabled: enabled));
  }

  Future<void> setDemoMode(bool enabled) async {
    await updateSettings(_settings.copyWith(demoModeEnabled: enabled));
  }

  Future<void> completeOnboarding() async {
    await updateSettings(_settings.copyWith(
      isFirstLaunch: false,
      onboardingComplete: true,
    ));
  }
}
