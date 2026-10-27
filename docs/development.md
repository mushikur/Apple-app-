# Development Guide

## Environment Setup

### Windows Development
- Windows 11
- Flutter 3.47.5+ stable
- Dart SDK ^3.13.4
- VS Code or Android Studio

### Running on Windows
```bash
flutter pub get
flutter run -d windows
```

On Windows, all iOS-specific device signals (battery, charging, audio, haptics) run through **`MockDeviceService`**, **`MockAudioService`**, and **`MockNotificationService`**.

You can simulate device state changes in real-time via the built-in **Developer Demo Panel** (`AppRoutes.demo` or the developer icon on the home screen in debug mode).

---

## iOS Build Preparation

When building for an iPhone or Simulator on macOS:

### 1. Requirements
- macOS with Xcode 15+ installed
- CocoaPods (`sudo gem install cocoapods`)
- Apple Developer Account (for device provisioning)

### 2. Configuration Steps
1. Clone the repository on macOS.
2. Run `flutter pub get`.
3. Open `ios/Runner.xcworkspace` in Xcode.
4. Set Bundle Identifier to `com.samirpet.app`.
5. Under **Signing & Capabilities**, select your Apple Developer Team and ensure a valid provisioning profile is generated.
6. Verify deployment target is iOS 15.0 or higher.

### 3. Build Commands
```bash
# Debug on iOS Simulator
flutter run -d "iPhone 15"

# Release build for device
flutter build ios --release
```

---

## Rive Asset Integration

1. The pet renders with a high-fidelity CustomPainter vector character by default.
2. To use a custom Rive animation, place the compiled `.riv` file at:
   `assets/rive/samir_pet.riv`
3. See [`docs/rive-animation-spec.md`](rive-animation-spec.md) for artboard specifications, triggers, and state machine inputs.
4. If the `.riv` asset is missing or fails to decode, the app automatically falls back to the native vector pet without crashing.

---

## Testing & Quality Assurance

Run the automated test suite and analyzer:
```bash
# Static analysis
flutter analyze

# Unit & Widget tests
flutter test
```
