/// Abstract notification service for local notifications.
abstract class NotificationService {
  Future<void> init();
  Future<void> showGreeting(String petName, String message);
  Future<void> showPetMissesYou(String petName);
  Future<void> scheduleMorningGreeting(String petName, int hour);
  Future<void> scheduleNightReminder(String petName, int hour);
  Future<void> cancelAll();
  Future<bool> requestPermission();
  void dispose();
}
