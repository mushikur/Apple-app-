import 'package:samir_pet/core/constants/app_constants.dart';

/// Time of day segments for pet personality.
enum TimeOfDay { morning, afternoon, evening, night }

/// Utilities for time-based pet behaviour.
class TimeUtils {
  TimeUtils._();

  static TimeOfDay getTimeOfDay([DateTime? now]) {
    final hour = (now ?? DateTime.now()).hour;
    if (hour >= AppConstants.morningStart && hour < AppConstants.afternoonStart) {
      return TimeOfDay.morning;
    } else if (hour >= AppConstants.afternoonStart && hour < AppConstants.eveningStart) {
      return TimeOfDay.afternoon;
    } else if (hour >= AppConstants.eveningStart && hour < AppConstants.nightStart) {
      return TimeOfDay.evening;
    } else {
      return TimeOfDay.night;
    }
  }

  static String getGreetingForTime(String petName, [DateTime? now]) {
    switch (getTimeOfDay(now)) {
      case TimeOfDay.morning:
        return 'Good morning, $petName ☀️';
      case TimeOfDay.afternoon:
        return 'Good afternoon, $petName';
      case TimeOfDay.evening:
        return 'Good evening, $petName 🌙';
      case TimeOfDay.night:
        return 'Hey $petName, it\'s getting late 😴';
    }
  }

  static bool isBedtime([DateTime? now]) {
    final hour = (now ?? DateTime.now()).hour;
    return hour >= 22 || hour < 6;
  }

  static bool isWakeTime([DateTime? now]) {
    final hour = (now ?? DateTime.now()).hour;
    return hour >= 6 && hour < 9;
  }
}
