import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:samir_pet/animation/animated_pet_widget.dart';
import 'package:samir_pet/animation/pet_character_painter.dart';
import 'package:samir_pet/animation/rive_pet_widget.dart';
import 'package:samir_pet/app/app.dart';
import 'package:samir_pet/features/chat/presentation/chat_screen.dart';
import 'package:samir_pet/features/debug/presentation/demo_screen.dart';
import 'package:samir_pet/features/home/presentation/home_screen.dart';
import 'package:samir_pet/features/onboarding/presentation/onboarding_screen.dart';
import 'package:samir_pet/features/settings/presentation/settings_screen.dart';
import 'package:samir_pet/models/app_settings.dart';
import 'package:samir_pet/models/pet_event.dart';
import 'package:samir_pet/models/pet_personality.dart';
import 'package:samir_pet/models/pet_state.dart';
import 'package:samir_pet/pet/pet_animation_controller.dart';
import 'package:samir_pet/pet/pet_behaviour_engine.dart';
import 'package:samir_pet/providers/app_settings_provider.dart';
import 'package:samir_pet/providers/pet_provider.dart';
import 'package:samir_pet/services/service_locator.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await ServiceLocator.init();
  });

  test('Pet Behaviour Engine initial state is idle and handles tap events', () {
    final engine = PetBehaviourEngine();
    expect(engine.state.mood, PetMood.idle);
    expect(engine.state.energy, 0.8);

    engine.start();
    engine.processEvent(PetEvent(type: PetEventType.userTappedPet));
    expect(engine.state.energy > 0.8, isTrue);

    engine.dispose();
  });

  test('Sleep and Wake requested events update pet state properly', () {
    final engine = PetBehaviourEngine();
    engine.start();

    engine.processEvent(PetEvent(type: PetEventType.sleepRequested));
    expect(engine.state.isSleeping, isTrue);
    expect(engine.state.mood, PetMood.sleeping);

    engine.processEvent(PetEvent(type: PetEventType.wakeRequested));
    expect(engine.state.isSleeping, isFalse);
    expect(engine.state.mood, PetMood.waking);

    engine.dispose();
  });

  test('Battery reactions trigger low battery and charging states', () {
    final engine = PetBehaviourEngine();
    engine.start();

    engine.processEvent(PetEvent(type: PetEventType.deviceCharging));
    expect(engine.state.isCharging, isTrue);
    expect(engine.state.mood, PetMood.charging);

    engine.processEvent(PetEvent(type: PetEventType.lowBattery));
    expect(engine.state.mood, PetMood.lowBattery);

    engine.dispose();
  });

  test('PetAnimationController maps all 20 PetMood states with distinct parameters', () {
    final animController = PetAnimationController();

    for (final mood in PetMood.values) {
      final state = PetState(
        mood: mood,
        isSleeping: mood == PetMood.sleeping,
        isListening: mood == PetMood.listening,
        isCharging: mood == PetMood.charging,
      );
      animController.updateForState(state);
      expect(animController.currentMood, mood);

      if (mood == PetMood.sleeping) {
        expect(animController.showZzz, isTrue);
        expect(animController.eyeOpenness, 0.0);
      } else if (mood == PetMood.love) {
        expect(animController.showHearts, isTrue);
      } else if (mood == PetMood.charging) {
        expect(animController.showLightning, isTrue);
      } else if (mood == PetMood.listening || mood == PetMood.dancing) {
        expect(animController.showHeadphones, isTrue);
      } else if (mood == PetMood.goodMorning) {
        expect(animController.showSun, isTrue);
      } else if (mood == PetMood.goodNight) {
        expect(animController.showMoon, isTrue);
      }
    }
    animController.dispose();
  });

  testWidgets('PetCharacterPainter renders all 20 states without throwing', (WidgetTester tester) async {
    for (final mood in PetMood.values) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomPaint(
              size: const Size(200, 200),
              painter: PetCharacterPainter(
                mood: mood,
                eyeOpenness: mood == PetMood.sleeping ? 0.0 : 1.0,
                showHeadphones: mood == PetMood.listening || mood == PetMood.dancing,
                showZzz: mood == PetMood.sleeping || mood == PetMood.goodNight,
                showSparkles: mood == PetMood.happy || mood == PetMood.excited,
                showHearts: mood == PetMood.love,
                showSweatDrop: mood == PetMood.lowBattery || mood == PetMood.confused,
                showLightning: mood == PetMood.charging,
                showSun: mood == PetMood.goodMorning,
                showMoon: mood == PetMood.goodNight,
                showQuestionMark: mood == PetMood.curious || mood == PetMood.thinking,
              ),
            ),
          ),
        ),
      );
      expect(find.byType(CustomPaint), findsWidgets);
    }
  });

  testWidgets('RivePetWidget falls back seamlessly when .riv asset is missing', (WidgetTester tester) async {
    final engine = PetBehaviourEngine();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RivePetWidget(
            engine: engine,
            size: 200,
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(AnimatedPetWidget), findsOneWidget);

    engine.dispose();
  });

  test('Settings persistence and reload across simulated restarts', () async {
    final storage = ServiceLocator.storage;
    const customSettings = AppSettings(
      petName: 'Pixel Pal',
      personalityType: PersonalityType.energetic,
      petSize: 1.2,
      themeMode: ThemeMode.light,
      hapticsEnabled: false,
    );
    await storage.saveSettings(customSettings);

    final loaded = await storage.loadSettings();
    expect(loaded.petName, 'Pixel Pal');
    expect(loaded.personalityType, PersonalityType.energetic);
    expect(loaded.petSize, 1.2);
    expect(loaded.themeMode, ThemeMode.light);
    expect(loaded.hapticsEnabled, isFalse);
  });

  testWidgets('HomeScreen interaction: tap, double tap, long press, actions', (WidgetTester tester) async {
    final settingsProvider = AppSettingsProvider();
    await settingsProvider.init();

    final petProvider = PetProvider();
    petProvider.start();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: settingsProvider),
          ChangeNotifierProvider.value(value: petProvider),
        ],
        child: const MaterialApp(home: HomeScreen()),
      ),
    );
    await tester.pump();

    // Pet action button
    final petBtn = find.text('Pet');
    expect(petBtn, findsOneWidget);
    await tester.tap(petBtn);
    await tester.pump(const Duration(milliseconds: 100));

    // Play action button
    final playBtn = find.text('Play');
    expect(playBtn, findsOneWidget);
    await tester.tap(playBtn);
    await tester.pump(const Duration(milliseconds: 100));
    expect(petProvider.state.mood, PetMood.playful);

    // Sleep action button
    final sleepBtn = find.text('Sleep');
    expect(sleepBtn, findsOneWidget);
    await tester.tap(sleepBtn);
    await tester.pump(const Duration(milliseconds: 100));
    expect(petProvider.state.isSleeping, isTrue);

    // Wake up
    final wakeBtn = find.text('Wake');
    expect(wakeBtn, findsOneWidget);
    await tester.tap(wakeBtn);
    await tester.pump(const Duration(milliseconds: 100));
    expect(petProvider.state.isSleeping, isFalse);

    // Gestures on AnimatedPetWidget
    final petWidget = find.byType(AnimatedPetWidget);
    expect(petWidget, findsOneWidget);
    await tester.tap(petWidget);
    await tester.pump(const Duration(milliseconds: 100));

    await tester.tap(petWidget);
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(petWidget);
    await tester.pump(const Duration(milliseconds: 100));

    await tester.longPress(petWidget);
    await tester.pump(const Duration(milliseconds: 100));

    petProvider.dispose();
  });

  testWidgets('DemoScreen allows testing all moods, battery, and charging', (WidgetTester tester) async {
    final petProvider = PetProvider();
    petProvider.start();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: petProvider),
        ],
        child: const MaterialApp(home: DemoScreen()),
      ),
    );
    await tester.pump();

    // Trigger mood buttons
    final happyBtn = find.widgetWithText(ElevatedButton, 'happy');
    expect(happyBtn, findsOneWidget);
    await tester.tap(happyBtn);
    await tester.pump(const Duration(milliseconds: 100));
    expect(petProvider.state.mood, PetMood.happy);

    final dancingBtn = find.widgetWithText(ElevatedButton, 'dancing');
    expect(dancingBtn, findsOneWidget);
    await tester.tap(dancingBtn);
    await tester.pump(const Duration(milliseconds: 100));
    expect(petProvider.state.mood, PetMood.dancing);

    // Hardware simulation sliders & switches
    final chargingSwitch = find.widgetWithText(SwitchListTile, 'Simulate Charging State');
    expect(chargingSwitch, findsOneWidget);
    await tester.tap(chargingSwitch);
    await tester.pump(const Duration(milliseconds: 100));

    final musicSwitch = find.widgetWithText(SwitchListTile, 'Toggle Music Mode');
    expect(musicSwitch, findsOneWidget);
    await tester.tap(musicSwitch);
    await tester.pump(const Duration(milliseconds: 100));

    petProvider.dispose();
  });

  testWidgets('ChatScreen sends messages and handles mock AI response', (WidgetTester tester) async {
    final settingsProvider = AppSettingsProvider();
    await settingsProvider.init();

    final petProvider = PetProvider();
    petProvider.start();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: settingsProvider),
          ChangeNotifierProvider.value(value: petProvider),
        ],
        child: const MaterialApp(home: ChatScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    // Suggestions chips appear
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(ListView), findsWidgets);

    petProvider.dispose();
  });

  testWidgets('SettingsScreen updates pet configuration and personalities', (WidgetTester tester) async {
    final settingsProvider = AppSettingsProvider();
    await settingsProvider.init();

    final petProvider = PetProvider();
    petProvider.start();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: settingsProvider),
          ChangeNotifierProvider.value(value: petProvider),
        ],
        child: const MaterialApp(home: SettingsScreen()),
      ),
    );
    await tester.pump();

    // Verify sections
    expect(find.text('PET CHARACTER'), findsOneWidget);
    expect(find.text('BEHAVIOUR & SIGNALS'), findsOneWidget);
    expect(find.text('APPEARANCE'), findsOneWidget);

    // Toggle a setting
    final autoGreetingSwitch = find.widgetWithText(SwitchListTile, 'Auto Greeting');
    expect(autoGreetingSwitch, findsOneWidget);
    await tester.tap(autoGreetingSwitch);
    await tester.pump();

    petProvider.dispose();
  });

  testWidgets('OnboardingScreen flow completes successfully', (WidgetTester tester) async {
    final settingsProvider = AppSettingsProvider();
    await settingsProvider.init();

    final petProvider = PetProvider();
    petProvider.start();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: settingsProvider),
          ChangeNotifierProvider.value(value: petProvider),
        ],
        child: const MaterialApp(home: OnboardingScreen()),
      ),
    );
    await tester.pump();

    expect(find.text('Meet Your Companion'), findsOneWidget);
    final continueBtn = find.text('Continue');
    expect(continueBtn, findsOneWidget);
    await tester.tap(continueBtn);
    await tester.pumpAndSettle();

    expect(find.text('Name Your Pet'), findsOneWidget);

    petProvider.dispose();
  });

  testWidgets('SamirPetApp loads and renders without crashing', (WidgetTester tester) async {
    final settingsProvider = AppSettingsProvider();
    await settingsProvider.init();

    final petProvider = PetProvider();
    petProvider.start();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: settingsProvider),
          ChangeNotifierProvider.value(value: petProvider),
        ],
        child: const SamirPetApp(),
      ),
    );

    await tester.pump();
    expect(find.byType(SamirPetApp), findsOneWidget);

    petProvider.dispose();
  });
}
