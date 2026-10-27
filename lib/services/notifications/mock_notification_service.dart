import 'package:flutter/foundation.dart';
import 'notification_service.dart';

/// Mock notification service for development.
class MockNotificationService implements NotificationService {
  @override
  Future<void> init() async {}

  @override
  Future<void> showGreeting(String petName, String message) async {
    debugPrint('[Notification] $petName: $message');
  }

  @override
  Future<void> showPetMissesYou(String petName) async {
    debugPrint('[Notification] $petName misses you!');
  }

  @override
  Future<void> scheduleMorningGreeting(String petName, int hour) async {
    debugPrint('[Notification] Scheduled morning greeting at $hour:00');
  }

  @override
  Future<void> scheduleNightReminder(String petName, int hour) async {
    debugPrint('[Notification] Scheduled night reminder at $hour:00');
  }

  @override
  Future<void> cancelAll() async {
    debugPrint('[Notification] All cancelled');
  }

  @override
  Future<bool> requestPermission() async => true;

  @override
  void dispose() {}
}
