import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samir_pet/app/app.dart';
import 'package:samir_pet/providers/app_settings_provider.dart';
import 'package:samir_pet/providers/pet_provider.dart';
import 'package:samir_pet/services/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize service locator (Storage, Device, AI, Voice, Notifications, Audio)
  await ServiceLocator.init();

  // Initialize AppSettingsProvider
  final settingsProvider = AppSettingsProvider();
  await settingsProvider.init();

  // Initialize PetProvider & PetBehaviourEngine
  final petProvider = PetProvider();
  petProvider.setPetName(settingsProvider.settings.petName);
  petProvider.start();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: settingsProvider),
        ChangeNotifierProvider.value(value: petProvider),
      ],
      child: const SamirPetApp(),
    ),
  );
}