import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samir_pet/animation/pet_widget.dart';
import 'package:samir_pet/core/constants/app_colors.dart';
import 'package:samir_pet/models/pet_event.dart';
import 'package:samir_pet/models/pet_state.dart';
import 'package:samir_pet/providers/pet_provider.dart';
import 'package:samir_pet/services/service_locator.dart';

class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  double _batterySim = 0.85;
  bool _chargingSim = false;

  @override
  Widget build(BuildContext context) {
    final petProvider = context.watch<PetProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Developer Demo Panel'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark ? AppColors.darkBgGradient : AppColors.lightBgGradient,
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            // Centered Mini Pet preview
            Center(
              child: PetWidget(
                engine: petProvider.engine,
                size: 140,
                interactive: true,
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Current State: ${petProvider.state.mood.name.toUpperCase()} (Energy: ${(petProvider.state.energy * 100).toInt()}%)',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
            const SizedBox(height: 20),

            // Mood Trigger Grid
            const Text('TRIGGER PET MOODS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: PetMood.values.map((mood) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.glassColor(Theme.of(context).brightness),
                    foregroundColor: isDark ? Colors.white : AppColors.lightTextPrimary,
                    side: BorderSide(color: AppColors.glassBorder(Theme.of(context).brightness)),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  ),
                  onPressed: () {
                    petProvider.engine.debugSetMood(mood);
                  },
                  child: Text(mood.name),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Hardware Simulation Section
            const Text('HARDWARE SIGNALS SIMULATION', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Battery Level'),
                        Text('${(_batterySim * 100).toInt()}%'),
                      ],
                    ),
                    Slider(
                      value: _batterySim,
                      min: 0.05,
                      max: 1.0,
                      onChanged: (val) {
                        setState(() => _batterySim = val);
                        ServiceLocator.mockDevice?.setBatteryLevel(val);
                      },
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Simulate Charging State'),
                      value: _chargingSim,
                      onChanged: (val) {
                        setState(() => _chargingSim = val);
                        ServiceLocator.mockDevice?.setCharging(val);
                      },
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Toggle Music Mode'),
                      value: ServiceLocator.audio.isMusicModeActive,
                      onChanged: (val) {
                        ServiceLocator.audio.setMusicMode(val);
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Quick Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      petProvider.processEvent(PetEvent(type: PetEventType.appOpened));
                    },
                    child: const Text('App Opened Event'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      petProvider.engine.debugSetEnergy(1.0);
                    },
                    child: const Text('Full Energy (100%)'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
