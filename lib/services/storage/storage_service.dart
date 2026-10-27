import 'package:samir_pet/models/app_settings.dart';
import 'package:samir_pet/models/pet_personality.dart';

/// Abstract storage service for persistence.
abstract class StorageService {
  Future<void> init();
  Future<void> saveSettings(AppSettings settings);
  Future<AppSettings> loadSettings();
  Future<void> savePetName(String name);
  Future<String> getPetName();
  Future<void> setFirstLaunch(bool value);
  Future<bool> isFirstLaunch();
  Future<void> savePersonality(PersonalityType type);
  Future<PersonalityType> loadPersonality();
}
