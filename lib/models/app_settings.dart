import 'package:flutter/material.dart';
import 'pet_personality.dart';

/// All user-configurable application settings with serialization support.
class AppSettings {
  final String petName;
  final PersonalityType personalityType;
  final double petSize;
  final double animationIntensity;
  final bool autoGreeting;
  final bool idleAnimations;
  final bool timeBasedMessages;
  final bool batteryReactions;
  final bool hapticsEnabled;
  final bool voiceEnabled;
  final double voiceVolume;
  final bool autoSpeak;
  final ThemeMode themeMode;
  final String backgroundStyle;
  final bool notificationsEnabled;
  final bool isFirstLaunch;
  final bool onboardingComplete;
  final bool demoModeEnabled;

  const AppSettings({
    this.petName = 'Samir Pet',
    this.personalityType = PersonalityType.friendly,
    this.petSize = 1.0,
    this.animationIntensity = 0.8,
    this.autoGreeting = true,
    this.idleAnimations = true,
    this.timeBasedMessages = true,
    this.batteryReactions = true,
    this.hapticsEnabled = true,
    this.voiceEnabled = false,
    this.voiceVolume = 0.7,
    this.autoSpeak = false,
    this.themeMode = ThemeMode.dark,
    this.backgroundStyle = 'gradient',
    this.notificationsEnabled = true,
    this.isFirstLaunch = true,
    this.onboardingComplete = false,
    this.demoModeEnabled = false,
  });

  AppSettings copyWith({
    String? petName,
    PersonalityType? personalityType,
    double? petSize,
    double? animationIntensity,
    bool? autoGreeting,
    bool? idleAnimations,
    bool? timeBasedMessages,
    bool? batteryReactions,
    bool? hapticsEnabled,
    bool? voiceEnabled,
    double? voiceVolume,
    bool? autoSpeak,
    ThemeMode? themeMode,
    String? backgroundStyle,
    bool? notificationsEnabled,
    bool? isFirstLaunch,
    bool? onboardingComplete,
    bool? demoModeEnabled,
  }) {
    return AppSettings(
      petName: petName ?? this.petName,
      personalityType: personalityType ?? this.personalityType,
      petSize: petSize ?? this.petSize,
      animationIntensity: animationIntensity ?? this.animationIntensity,
      autoGreeting: autoGreeting ?? this.autoGreeting,
      idleAnimations: idleAnimations ?? this.idleAnimations,
      timeBasedMessages: timeBasedMessages ?? this.timeBasedMessages,
      batteryReactions: batteryReactions ?? this.batteryReactions,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      voiceEnabled: voiceEnabled ?? this.voiceEnabled,
      voiceVolume: voiceVolume ?? this.voiceVolume,
      autoSpeak: autoSpeak ?? this.autoSpeak,
      themeMode: themeMode ?? this.themeMode,
      backgroundStyle: backgroundStyle ?? this.backgroundStyle,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      demoModeEnabled: demoModeEnabled ?? this.demoModeEnabled,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'petName': petName,
      'personalityType': personalityType.name,
      'petSize': petSize,
      'animationIntensity': animationIntensity,
      'autoGreeting': autoGreeting,
      'idleAnimations': idleAnimations,
      'timeBasedMessages': timeBasedMessages,
      'batteryReactions': batteryReactions,
      'hapticsEnabled': hapticsEnabled,
      'voiceEnabled': voiceEnabled,
      'voiceVolume': voiceVolume,
      'autoSpeak': autoSpeak,
      'themeMode': themeMode.index,
      'backgroundStyle': backgroundStyle,
      'notificationsEnabled': notificationsEnabled,
      'isFirstLaunch': isFirstLaunch,
      'onboardingComplete': onboardingComplete,
      'demoModeEnabled': demoModeEnabled,
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    PersonalityType personality = PersonalityType.friendly;
    if (json['personalityType'] is String) {
      for (final v in PersonalityType.values) {
        if (v.name == json['personalityType']) {
          personality = v;
          break;
        }
      }
    }

    ThemeMode theme = ThemeMode.dark;
    if (json['themeMode'] is int) {
      final idx = json['themeMode'] as int;
      if (idx >= 0 && idx < ThemeMode.values.length) {
        theme = ThemeMode.values[idx];
      }
    }

    return AppSettings(
      petName: json['petName'] as String? ?? 'Samir Pet',
      personalityType: personality,
      petSize: (json['petSize'] as num?)?.toDouble() ?? 1.0,
      animationIntensity: (json['animationIntensity'] as num?)?.toDouble() ?? 0.8,
      autoGreeting: json['autoGreeting'] as bool? ?? true,
      idleAnimations: json['idleAnimations'] as bool? ?? true,
      timeBasedMessages: json['timeBasedMessages'] as bool? ?? true,
      batteryReactions: json['batteryReactions'] as bool? ?? true,
      hapticsEnabled: json['hapticsEnabled'] as bool? ?? true,
      voiceEnabled: json['voiceEnabled'] as bool? ?? false,
      voiceVolume: (json['voiceVolume'] as num?)?.toDouble() ?? 0.7,
      autoSpeak: json['autoSpeak'] as bool? ?? false,
      themeMode: theme,
      backgroundStyle: json['backgroundStyle'] as String? ?? 'gradient',
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      isFirstLaunch: json['isFirstLaunch'] as bool? ?? true,
      onboardingComplete: json['onboardingComplete'] as bool? ?? false,
      demoModeEnabled: json['demoModeEnabled'] as bool? ?? false,
    );
  }
}
