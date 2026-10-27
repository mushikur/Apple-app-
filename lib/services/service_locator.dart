import 'package:samir_pet/services/storage/storage_service.dart';
import 'package:samir_pet/services/storage/shared_prefs_storage_service.dart';
import 'package:samir_pet/services/device/device_service.dart';
import 'package:samir_pet/services/device/mock_device_service.dart';
import 'package:samir_pet/services/ai/ai_companion_service.dart';
import 'package:samir_pet/services/ai/mock_ai_service.dart';
import 'package:samir_pet/services/voice/voice_service.dart';
import 'package:samir_pet/services/voice/mock_voice_service.dart';
import 'package:samir_pet/services/notifications/notification_service.dart';
import 'package:samir_pet/services/notifications/mock_notification_service.dart';
import 'package:samir_pet/services/audio/audio_service.dart';
import 'package:samir_pet/services/audio/mock_audio_service.dart';

/// Simple service locator for dependency injection.
class ServiceLocator {
  ServiceLocator._();

  static late StorageService storage;
  static late DeviceService device;
  static late AICompanionService ai;
  static late VoiceService voice;
  static late NotificationService notifications;
  static late AudioService audio;

  static bool _initialized = false;
  static bool get isInitialized => _initialized;

  /// Initialize all services. Uses mock implementations on Windows.
  static Future<void> init() async {
    if (_initialized) return;

    // Storage (platform-agnostic)
    storage = SharedPrefsStorageService();
    await storage.init();

    // Device (mock for now, real implementation on iOS via battery_plus)
    device = MockDeviceService();
    await device.init();

    // AI
    ai = MockAIService();

    // Voice
    voice = MockVoiceService();
    await voice.init();

    // Notifications
    notifications = MockNotificationService();
    await notifications.init();

    // Audio
    audio = MockAudioService();
    await audio.init();

    _initialized = true;
  }

  /// Get the mock device service for demo/debug control.
  static MockDeviceService? get mockDevice {
    if (device is MockDeviceService) return device as MockDeviceService;
    return null;
  }

  /// Get the mock audio service for demo/debug control.
  static MockAudioService? get mockAudio {
    if (audio is MockAudioService) return audio as MockAudioService;
    return null;
  }

  static void dispose() {
    device.dispose();
    voice.dispose();
    notifications.dispose();
    audio.dispose();
    _initialized = false;
  }
}
