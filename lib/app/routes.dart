import 'package:flutter/material.dart';
import 'package:samir_pet/features/chat/presentation/chat_screen.dart';
import 'package:samir_pet/features/debug/presentation/demo_screen.dart';
import 'package:samir_pet/features/home/presentation/home_screen.dart';
import 'package:samir_pet/features/onboarding/presentation/onboarding_screen.dart';
import 'package:samir_pet/features/settings/presentation/settings_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String chat = '/chat';
  static const String settings = '/settings';
  static const String onboarding = '/onboarding';
  static const String demo = '/demo';

  static Map<String, WidgetBuilder> get routes => {
        home: (context) => const HomeScreen(),
        chat: (context) => const ChatScreen(),
        settings: (context) => const SettingsScreen(),
        onboarding: (context) => const OnboardingScreen(),
        demo: (context) => const DemoScreen(),
      };
}
