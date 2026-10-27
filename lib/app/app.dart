import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samir_pet/app/routes.dart';
import 'package:samir_pet/app/theme.dart';
import 'package:samir_pet/providers/app_settings_provider.dart';

class SamirPetApp extends StatelessWidget {
  const SamirPetApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<AppSettingsProvider>();

    if (settingsProvider.isLoading) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final initialRoute = settingsProvider.settings.isFirstLaunch
        ? AppRoutes.onboarding
        : AppRoutes.home;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Samir Pet',
      theme: SamirPetTheme.lightTheme(),
      darkTheme: SamirPetTheme.darkTheme(),
      themeMode: settingsProvider.settings.themeMode,
      initialRoute: initialRoute,
      routes: AppRoutes.routes,
    );
  }
}
