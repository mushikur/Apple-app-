import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samir_pet/animation/pet_widget.dart';
import 'package:samir_pet/app/routes.dart';
import 'package:samir_pet/core/constants/app_colors.dart';
import 'package:samir_pet/core/constants/app_typography.dart';
import 'package:samir_pet/features/home/widgets/action_bar.dart';
import 'package:samir_pet/features/home/widgets/greeting_header.dart';
import 'package:samir_pet/features/home/widgets/pet_status_bubble.dart';
import 'package:samir_pet/models/pet_event.dart';
import 'package:samir_pet/providers/app_settings_provider.dart';
import 'package:samir_pet/providers/pet_provider.dart';
import 'package:samir_pet/services/service_locator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final petProvider = context.watch<PetProvider>();
    final settingsProvider = context.watch<AppSettingsProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final petSize = 240.0 * settingsProvider.settings.petSize;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark ? AppColors.darkBgGradient : AppColors.lightBgGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar Greeting & Settings Shortcut
              GreetingHeader(
                petName: settingsProvider.settings.petName,
                onSettingsTap: () => Navigator.pushNamed(context, AppRoutes.settings),
                onDemoTap: (kDebugMode || settingsProvider.settings.demoModeEnabled)
                    ? () => Navigator.pushNamed(context, AppRoutes.demo)
                    : null,
              ),

              const Spacer(flex: 1),

              // Pet Visual Hero
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PetWidget(
                      engine: petProvider.engine,
                      size: petSize,
                      interactive: true,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      settingsProvider.settings.petName,
                      style: AppTypography.petName.copyWith(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    PetStatusBubble(state: petProvider.state),
                  ],
                ),
              ),

              const Spacer(flex: 2),

              // Bottom Actions
              ActionBar(
                isMusicActive: ServiceLocator.audio.isMusicModeActive,
                isSleeping: petProvider.state.isSleeping,
                onPet: () {
                  petProvider.processEvent(PetEvent(type: PetEventType.userTappedPet));
                },
                onTalk: () {
                  Navigator.pushNamed(context, AppRoutes.chat);
                },
                onMusic: () {
                  final active = !ServiceLocator.audio.isMusicModeActive;
                  ServiceLocator.audio.setMusicMode(active);
                },
                onSleep: () {
                  if (petProvider.state.isSleeping) {
                    petProvider.processEvent(PetEvent(type: PetEventType.wakeRequested));
                  } else {
                    petProvider.processEvent(PetEvent(type: PetEventType.sleepRequested));
                  }
                },
                onPlay: () {
                  petProvider.processEvent(PetEvent(type: PetEventType.playRequested));
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
