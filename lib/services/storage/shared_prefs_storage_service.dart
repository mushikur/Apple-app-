import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:samir_pet/models/app_settings.dart';
import 'package:samir_pet/models/pet_personality.dart';
import 'package:samir_pet/core/constants/app_constants.dart';
import 'storage_service.dart';

/// SharedPreferences-based storage implementation.
class SharedPrefsStorageService implements StorageService {
  SharedPreferences? _prefs;

  @override
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get _p {
    assert(_prefs != null, 'StorageService not initialized. Call init() first.');
    return _prefs!;
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    try {
      await _p.setString(AppConstants.settingsKey, jsonEncode(settings.toJson()));
    } catch (_) {}
  }

  @override
  Future<AppSettings> loadSettings() async {
    try {
      final raw = _p.getString(AppConstants.settingsKey);
      if (raw != null) {
        return AppSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      }
    } catch (_) {}
    return const AppSettings();
  }

  @override
  Future<void> savePetName(String name) async {
    try {
      final settings = await loadSettings();
      await saveSettings(settings.copyWith(petName: name));
    } catch (_) {}
  }

  @override
  Future<String> getPetName() async {
    final settings = await loadSettings();
    return settings.petName;
  }

  @override
  Future<void> setFirstLaunch(bool value) async {
    try {
      final settings = await loadSettings();
      await saveSettings(settings.copyWith(isFirstLaunch: value));
    } catch (_) {}
  }

  @override
  Future<bool> isFirstLaunch() async {
    final settings = await loadSettings();
    return settings.isFirstLaunch;
  }

  @override
  Future<void> savePersonality(PersonalityType type) async {
    try {
      final settings = await loadSettings();
      await saveSettings(settings.copyWith(personalityType: type));
    } catch (_) {}
  }

  @override
  Future<PersonalityType> loadPersonality() async {
    final settings = await loadSettings();
    return settings.personalityType;
  }
}
