# Samir Pet 🐾

A premium interactive AI companion and virtual pet application built with Flutter.

## Overview

Samir Pet is an iPhone-first interactive virtual pet that feels like a living character. The pet has a strong personality, reacts to user interaction, shows many facial expressions, and responds to device signals like battery level and time of day.

## Features

### Core Pet Experience
- 🎭 **20+ emotional states** — happy, sad, curious, surprised, thinking, dancing, and more
- 🎨 **Custom-drawn animated character** — smooth 60fps vector animations
- 👆 **Rich interactions** — tap, double-tap, long press, and swipe gestures
- 🔋 **Battery awareness** — reacts to charging, low battery, and full charge
- ⏰ **Time-based personality** — morning greetings, bedtime reminders
- 😴 **Sleep system** — pet can sleep with dim environment and gentle breathing
- 🎵 **Music mode** — pet dances and reacts to music
- 💬 **Chat interface** — conversation with your pet companion

### Architecture
- 🏗️ Clean architecture with separation of concerns
- 🔌 Platform abstraction (works on Windows + iOS)
- 🤖 AI service abstraction (mock + future API integration)
- 🗣️ Voice service abstraction
- 💾 Local-first with persistent settings
- 🎯 Event-driven behaviour engine with priority system

### Design
- 🌙 Dark and light theme support
- ✨ Premium glassmorphic UI elements
- 📱 Responsive layout (iPhone + iPad + Windows)
- ♿ Accessibility support
- 🎬 Smooth transitions and micro-interactions

## Project Structure

```
lib/
  main.dart                    # App entry point
  app/                         # App configuration
    app.dart                   # Root widget
    routes.dart                # Navigation
    theme.dart                 # Theme definitions
  core/                        # Core utilities
    constants/                 # Colors, typography, constants
    utils/                     # Haptics, time utilities
    errors/                    # Error handling
  models/                      # Data models
    pet_state.dart             # Pet state & mood
    pet_event.dart             # Event system
    pet_personality.dart       # Personality system
    app_settings.dart          # App settings model
  services/                    # Business services
    storage/                   # Local persistence
    device/                    # Device info (battery)
    ai/                        # AI companion service
    voice/                     # Voice I/O
    audio/                     # Audio/music mode
    notifications/             # Local notifications
    service_locator.dart       # Service registry
  pet/                         # Pet behaviour core
    pet_behaviour_engine.dart  # Central brain
    pet_animation_controller.dart
    idle_behaviour_controller.dart
  animation/                   # Animation system
    pet_character_painter.dart # Custom-drawn pet
    animated_pet_widget.dart   # Animated wrapper
    rive_pet_widget.dart       # Rive integration
    pet_widget.dart            # Unified pet widget
  features/                    # UI features
    home/                      # Home screen
    chat/                      # Chat screen
    settings/                  # Settings screen
    onboarding/                # First-launch flow
    debug/                     # Dev demo panel
  providers/                   # State management
    app_settings_provider.dart
    pet_provider.dart
  platform/                    # Platform-specific
    windows/                   # Windows mocks
    ios/                       # iOS native bridges
```

## Setup

### Prerequisites
- Flutter 3.47.5+ (stable)
- Dart SDK ^3.13.4
- VS Code or Android Studio

### Windows Development
```bash
flutter pub get
flutter run -d windows
```

### iOS Build (requires Mac)
```bash
flutter pub get
flutter build ios
```

See [docs/development.md](docs/development.md) for detailed setup.

## Rive Integration

The pet animation system supports Rive assets. Place your `.riv` file at:
```
assets/rive/samir_pet.riv
```

Without a Rive asset, the app uses a beautiful custom-drawn Flutter vector pet.

See [docs/rive-animation-spec.md](docs/rive-animation-spec.md) for the full Rive specification.

## AI Configuration

The app includes a mock AI service for offline use. To connect a real AI provider:

1. Create an implementation of `AICompanionService`
2. Configure via environment variables (never hard-code API keys)
3. Register in `ServiceLocator`

See [docs/architecture.md](docs/architecture.md) for details.

## iOS Limitations

This app respects all Apple sandbox, privacy, and API restrictions:

- ❌ No system-wide overlays (not supported on iOS)
- ❌ No private API usage
- ❌ No background audio snooping
- ✅ In-app pet experience
- ✅ Local notifications
- ✅ Battery monitoring via supported APIs
- ✅ Haptic feedback
- ✅ Prepared for Widgets, Live Activities, App Intents

See [docs/ios-limitations.md](docs/ios-limitations.md) for full details.

## Testing

```bash
flutter test
flutter analyze
```

## License

Private project. All rights reserved.
