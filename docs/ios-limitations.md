# iOS Limitations & Supported Capabilities

## What iOS DOES Support (App Store Safe)

### In-App Experience
- ✅ Full interactive pet within the app
- ✅ Custom animations (Rive + Flutter Canvas)
- ✅ Gesture recognition (tap, swipe, long press)
- ✅ Haptic feedback (UIFeedbackGenerator via Flutter)
- ✅ Local data persistence

### Device Information
- ✅ Battery level monitoring (`UIDevice.batteryLevel`)
- ✅ Charging state detection (`UIDevice.batteryState`)
- ✅ Device orientation / motion (CoreMotion)
- ✅ Local time and timezone
- ✅ Locale and language

### Notifications
- ✅ Local notifications (UNUserNotificationCenter)
- ✅ Scheduled notifications (morning greeting, bedtime)
- ✅ Notification actions

### iOS Native Extensions (Future)
- ✅ Home Screen Widgets (WidgetKit)
- ✅ Lock Screen Widgets (WidgetKit)
- ✅ Live Activities (ActivityKit) — for persistent pet status
- ✅ App Intents / Siri Shortcuts
- ✅ App Clips (potential)

### Audio
- ✅ Text-to-speech (AVSpeechSynthesizer)
- ✅ Speech recognition (SFSpeechRecognizer, with permission)
- ✅ Playing local audio files
- ✅ User-activated "Music Mode" within the app

## What iOS Does NOT Support

### System-Wide Overlay
- ❌ **Cannot draw pet over other apps** — iOS does not allow third-party floating windows/overlays
- ❌ No Picture-in-Picture for non-video content
- ❌ No always-on-top windows

### Audio Monitoring
- ❌ **Cannot detect what music other apps are playing** — No API to inspect Spotify/Apple Music playback from a third-party app
- ❌ Cannot record system audio
- ❌ Cannot access other apps' audio sessions
- ✅ **Alternative**: User-activated Music Mode that triggers dance animations

### Background Execution
- ❌ Cannot run arbitrary code in the background indefinitely
- ❌ No persistent background process for pet simulation
- ✅ Background fetch (limited, system-scheduled)
- ✅ Background notifications
- ✅ Live Activities for visible persistent state

### System Access
- ❌ No access to other apps' data
- ❌ No screen recording/capture of other apps
- ❌ No accessibility service overlay (Android-only concept)
- ❌ No custom keyboard that draws over apps

## Design Decisions

Given these constraints, Samir Pet is designed as:

1. **An in-app companion** — The pet lives within the app, not floating over the OS
2. **Widget presence** — iOS Widgets give the pet a presence on the home/lock screen
3. **Local notifications** — The pet can "reach out" via notifications
4. **User-driven modes** — Music mode, sleep mode are user-activated, not auto-detected
5. **Battery-aware** — Uses supported battery APIs for genuine reactions
6. **Time-aware** — Uses local time for greetings and personality

## Apple Developer Requirements

To deploy to a real iPhone:
- Apple Developer account
- Xcode on macOS
- Provisioning profile and signing certificate
- Bundle identifier: `com.samirpet.app`

For Widgets/Live Activities:
- Additional widget extension target in Xcode
- WidgetKit framework
- App Groups for shared data between app and widget
