/// Application-wide constants for Samir Pet.
class AppConstants {
  AppConstants._();

  // App identity
  static const String appName = 'Samir Pet';
  static const String bundleId = 'com.samirpet.app';
  static const String defaultPetName = 'Samir Pet';

  // Animation durations (milliseconds)
  static const int moodTransitionMs = 600;
  static const int blinkDurationMs = 250;
  static const int pageTransitionMs = 350;
  static const int statusBubbleShowMs = 400;
  static const int statusBubbleHideMs = 300;
  static const int statusBubbleVisibleMs = 4000;
  static const int greetingAnimationMs = 2000;
  static const int moodDisplayMs = 3000;

  // Idle behaviour intervals (seconds)
  static const int idleMinIntervalSec = 3;
  static const int idleMaxIntervalSec = 8;
  static const int yawnMinIntervalSec = 30;
  static const int yawnMaxIntervalSec = 60;
  static const int statusMessageMinSec = 120;
  static const int statusMessageMaxSec = 300;

  // Energy system
  static const double energyDecayPerMinute = 0.002;
  static const double energySleepyThreshold = 0.2;
  static const double energySleepThreshold = 0.1;
  static const double energyTapBoost = 0.05;
  static const double energySleepRecoveryPerMinute = 0.03;

  // Battery thresholds
  static const double batteryLowThreshold = 0.20;
  static const double batteryCriticalThreshold = 0.10;

  // Pet sizing
  static const double petMinSize = 0.5;
  static const double petMaxSize = 1.5;
  static const double petDefaultSize = 1.0;

  // Layout
  static const double actionButtonSize = 56.0;
  static const double petAreaRatio = 0.5;

  // Time of day boundaries (hours)
  static const int morningStart = 6;
  static const int afternoonStart = 12;
  static const int eveningStart = 17;
  static const int nightStart = 21;

  // Storage keys
  static const String settingsKey = 'app_settings';
}
