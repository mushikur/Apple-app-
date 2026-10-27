# Architecture

## Overview

Samir Pet follows a clean, layered architecture designed for maintainability, testability, and platform abstraction.

```
┌─────────────────────────────────────────┐
│              UI Layer                    │
│  (Screens, Widgets, Providers)          │
├─────────────────────────────────────────┤
│           Pet Engine Layer              │
│  (Behaviour Engine, Animation Ctrl)     │
├─────────────────────────────────────────┤
│           Service Layer                 │
│  (Storage, Device, AI, Voice, Audio)    │
├─────────────────────────────────────────┤
│           Model Layer                   │
│  (PetState, PetEvent, Settings)         │
├─────────────────────────────────────────┤
│         Platform Layer                  │
│  (iOS Native, Windows Mock)            │
└─────────────────────────────────────────┘
```

## State Management

Uses `ChangeNotifier` + `Provider` for lightweight, maintainable state.

### Key State Objects

- **`PetBehaviourEngine`** — Central brain. Processes events, manages pet state, runs idle simulation.
- **`AppSettingsProvider`** — User settings with persistence.
- **`PetProvider`** — UI-facing wrapper around the engine.

## Event-Driven Architecture

All interactions flow through the event system:

```
User Gesture / Device Signal / Timer
        ↓
    PetEvent (with priority)
        ↓
    PetBehaviourEngine.processEvent()
        ↓
    State Transition
        ↓
    notifyListeners()
        ↓
    UI Update + Animation
```

### Event Priorities

| Priority   | Examples                              | Behaviour                    |
|-----------|---------------------------------------|------------------------------|
| CRITICAL  | Low battery, charging                 | Always interrupts            |
| HIGH      | User tap, app opened                  | Interrupts except critical   |
| NORMAL    | Time greeting, music mode             | Queued if busy               |
| LOW       | Idle suggestion, subtle reaction      | Ignored if busy/sleeping     |
| BACKGROUND| Analytics, state logging              | Never interrupts             |

## Service Abstraction

All services use abstract interfaces with platform-specific implementations:

```dart
abstract class DeviceService {
  Stream<bool> get chargingStream;
  Future<double> getBatteryLevel();
}

// iOS: Uses battery_plus plugin
// Windows: Mock with simulated values
```

## AI Integration

```dart
abstract class AICompanionService {
  Future<String> sendMessage(String message);
  Future<String> generateGreeting(String petName, String timeOfDay);
}

// Local: MockAIService with curated responses
// Future: OpenAI, Gemini, or other provider
```

## Platform Architecture

```
ServiceLocator.init()
  ├── Platform.isIOS → Real implementations
  │   ├── BatteryPlusDeviceService
  │   ├── IOSNotificationService
  │   └── IOSAudioService
  └── Platform.isWindows → Mock implementations
      ├── MockDeviceService
      ├── MockNotificationService
      └── MockAudioService
```
