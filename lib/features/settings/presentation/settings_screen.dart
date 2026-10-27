import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samir_pet/core/constants/app_colors.dart';
import 'package:samir_pet/core/constants/app_typography.dart';
import 'package:samir_pet/models/pet_personality.dart';
import 'package:samir_pet/providers/app_settings_provider.dart';
import 'package:samir_pet/providers/pet_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<AppSettingsProvider>();
    final petProvider = context.watch<PetProvider>();
    final settings = settingsProvider.settings;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark ? AppColors.darkBgGradient : AppColors.lightBgGradient,
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            // PET SECTION
            _buildSectionHeader('PET CHARACTER', isDark),
            _buildCard(
              isDark,
              children: [
                ListTile(
                  title: const Text('Pet Name'),
                  subtitle: Text(settings.petName),
                  trailing: const Icon(Icons.edit_rounded, size: 20),
                  onTap: () => _showEditNameDialog(context, settingsProvider, petProvider),
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Personality'),
                  subtitle: Text(settings.personalityType.name.toUpperCase()),
                  trailing: DropdownButton<PersonalityType>(
                    value: settings.personalityType,
                    underline: const SizedBox(),
                    items: PersonalityType.values.map((p) {
                      return DropdownMenuItem(
                        value: p,
                        child: Text(p.name[0].toUpperCase() + p.name.substring(1)),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        settingsProvider.setPersonality(val);
                        petProvider.setPersonality(PetPersonality.forType(val));
                      }
                    },
                  ),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Pet Scale'),
                          Text('${(settings.petSize * 100).toInt()}%'),
                        ],
                      ),
                      Slider(
                        value: settings.petSize,
                        min: 0.7,
                        max: 1.3,
                        divisions: 6,
                        onChanged: (val) => settingsProvider.setPetSize(val),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // BEHAVIOUR SECTION
            _buildSectionHeader('BEHAVIOUR & SIGNALS', isDark),
            _buildCard(
              isDark,
              children: [
                SwitchListTile(
                  title: const Text('Auto Greeting'),
                  subtitle: const Text('Greet when opening the app'),
                  value: settings.autoGreeting,
                  onChanged: (val) => settingsProvider.updateSettings(
                    settings.copyWith(autoGreeting: val),
                  ),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Idle Animations'),
                  subtitle: const Text('Blink, look around, and express feelings'),
                  value: settings.idleAnimations,
                  onChanged: (val) {
                    settingsProvider.updateSettings(settings.copyWith(idleAnimations: val));
                    petProvider.engine.setIdleAnimationsEnabled(val);
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Battery Reactions'),
                  subtitle: const Text('React to low battery & charging signals'),
                  value: settings.batteryReactions,
                  onChanged: (val) => settingsProvider.updateSettings(
                    settings.copyWith(batteryReactions: val),
                  ),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Haptic Feedback'),
                  subtitle: const Text('Subtle vibrations when interacting'),
                  value: settings.hapticsEnabled,
                  onChanged: (val) => settingsProvider.setHapticsEnabled(val),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // APPEARANCE SECTION
            _buildSectionHeader('APPEARANCE', isDark),
            _buildCard(
              isDark,
              children: [
                ListTile(
                  title: const Text('Theme Mode'),
                  trailing: SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment(value: ThemeMode.dark, icon: Icon(Icons.dark_mode_rounded)),
                      ButtonSegment(value: ThemeMode.light, icon: Icon(Icons.light_mode_rounded)),
                      ButtonSegment(value: ThemeMode.system, icon: Icon(Icons.auto_mode_rounded)),
                    ],
                    selected: {settings.themeMode},
                    onSelectionChanged: (set) {
                      if (set.isNotEmpty) settingsProvider.setThemeMode(set.first);
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // DEVELOPER / PRIVACY
            _buildSectionHeader('DEVELOPER & PRIVACY', isDark),
            _buildCard(
              isDark,
              children: [
                SwitchListTile(
                  title: const Text('Developer Demo Panel'),
                  subtitle: const Text('Quick state trigger dashboard'),
                  value: settings.demoModeEnabled,
                  onChanged: (val) => settingsProvider.setDemoMode(val),
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Privacy & Sandboxing'),
                  subtitle: const Text('Learn how Samir Pet respects Apple and device sandboxes'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => _showPrivacyDialog(context),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        title,
        style: AppTypography.sectionHeader.copyWith(
          color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
        ),
      ),
    );
  }

  Widget _buildCard(bool isDark, {required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(children: children),
    );
  }

  void _showEditNameDialog(
    BuildContext context,
    AppSettingsProvider settingsProvider,
    PetProvider petProvider,
  ) {
    final controller = TextEditingController(text: settingsProvider.settings.petName);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rename Pet'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Pet Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newName = controller.text.trim();
              if (newName.isNotEmpty) {
                settingsProvider.setPetName(newName);
                petProvider.setPetName(newName);
              }
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Privacy & Compliance'),
        content: const SingleChildScrollView(
          child: Text(
            'Samir Pet is built to run 100% locally and safely.\n\n'
            '• No invasive tracking or private APIs.\n'
            '• In-app AI companion respects device limits.\n'
            '• Complies strictly with Apple App Store Guidelines and sandboxing policies.\n'
            '• Battery and charging states use official system APIs with zero unauthorized background monitoring.',
            style: TextStyle(height: 1.4),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Understood')),
        ],
      ),
    );
  }
}
