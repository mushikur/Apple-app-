import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samir_pet/animation/pet_widget.dart';
import 'package:samir_pet/app/routes.dart';
import 'package:samir_pet/core/constants/app_colors.dart';
import 'package:samir_pet/core/constants/app_typography.dart';
import 'package:samir_pet/models/pet_event.dart';
import 'package:samir_pet/models/pet_personality.dart';
import 'package:samir_pet/providers/app_settings_provider.dart';
import 'package:samir_pet/providers/pet_provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _nameController = TextEditingController(text: 'Samir Pet');
  int _currentPage = 0;
  PersonalityType _selectedPersonality = PersonalityType.friendly;

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _finishOnboarding() async {
    final settingsProvider = context.read<AppSettingsProvider>();
    final petProvider = context.read<PetProvider>();

    final name = _nameController.text.trim().isEmpty ? 'Samir Pet' : _nameController.text.trim();
    await settingsProvider.setPetName(name);
    await settingsProvider.setPersonality(_selectedPersonality);
    await settingsProvider.completeOnboarding();

    petProvider.setPetName(name);
    petProvider.setPersonality(PetPersonality.forType(_selectedPersonality));
    petProvider.processEvent(PetEvent(type: PetEventType.appOpened));

    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final petProvider = context.watch<PetProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark ? AppColors.darkBgGradient : AppColors.lightBgGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Skip button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, top: 8),
                  child: TextButton(
                    onPressed: _finishOnboarding,
                    child: Text(
                      _currentPage < 2 ? 'Skip' : '',
                      style: TextStyle(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                ),
              ),

              // Page Content
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (page) => setState(() => _currentPage = page),
                  children: [
                    // Page 1: Welcome
                    _buildPage(
                      petWidget: PetWidget(
                        engine: petProvider.engine,
                        size: 200,
                        interactive: true,
                      ),
                      title: 'Meet Your Companion',
                      description:
                          'A living, expressive AI companion designed to keep you company, react to your day, and share cheerful moments.',
                    ),

                    // Page 2: Name Your Pet
                    _buildPage(
                      petWidget: PetWidget(
                        engine: petProvider.engine,
                        size: 160,
                        interactive: true,
                      ),
                      title: 'Name Your Pet',
                      description: 'What would you like to call your companion?',
                      extraContent: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                        child: TextField(
                          controller: _nameController,
                          textAlign: TextAlign.center,
                          style: AppTypography.petName.copyWith(
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.glassColor(Theme.of(context).brightness),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Page 3: Personality
                    _buildPage(
                      petWidget: PetWidget(
                        engine: petProvider.engine,
                        size: 150,
                        interactive: true,
                      ),
                      title: 'Choose a Vibe',
                      description: 'Pick the personality archetype that fits you best.',
                      extraContent: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: PersonalityType.values.take(4).map((type) {
                          final isSelected = _selectedPersonality == type;
                          return ChoiceChip(
                            label: Text(type.name[0].toUpperCase() + type.name.substring(1)),
                            selected: isSelected,
                            selectedColor: AppColors.primary,
                            onSelected: (val) {
                              if (val) setState(() => _selectedPersonality = type);
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom Navigation & Dots
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Dots
                    Row(
                      children: List.generate(3, (index) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.only(right: 6),
                          width: _currentPage == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? AppColors.primary
                                : (isDark ? Colors.white24 : Colors.black12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),

                    // Next / Finish Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                      onPressed: () {
                        if (_currentPage < 2) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        } else {
                          _finishOnboarding();
                        }
                      },
                      child: Text(_currentPage < 2 ? 'Continue' : 'Get Started'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage({
    required Widget petWidget,
    required String title,
    required String description,
    Widget? extraContent,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          petWidget,
          const SizedBox(height: 32),
          Text(
            title,
            style: AppTypography.heading.copyWith(
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: AppTypography.body.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          if (extraContent != null) ...[
            const SizedBox(height: 16),
            extraContent,
          ],
        ],
      ),
    );
  }
}
