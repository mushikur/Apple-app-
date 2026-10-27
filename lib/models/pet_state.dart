import 'package:flutter/foundation.dart';

/// Represents all expressive emotional and behavioral states of Samir Pet.
enum PetMood {
  idle,
  hello,
  happy,
  sad,
  sleeping,
  waking,
  curious,
  surprised,
  thinking,
  excited,
  dancing,
  listening,
  charging,
  lowBattery,
  love,
  bored,
  confused,
  playful,
  goodMorning,
  goodNight,
}

/// Immutable state representation for Samir Pet.
@immutable
class PetState {
  /// Current emotional mood/animation state of the pet.
  final PetMood mood;

  /// Pet energy level ranging from 0.0 (exhausted) to 1.0 (fully charged).
  final double energy;

  /// Pet happiness level ranging from 0.0 (depressed) to 1.0 (ecstatic).
  final double happiness;

  /// Whether the pet is currently sleeping.
  final bool isSleeping;

  /// Whether the pet is currently listening for user input/voice.
  final bool isListening;

  /// Whether the device is plugged in and charging.
  final bool isCharging;

  /// Optional custom message or thought bubble content.
  final String? statusMessage;

  /// Timestamp of the last interaction with the pet.
  final DateTime lastInteraction;

  PetState({
    this.mood = PetMood.idle,
    double energy = 0.8,
    double happiness = 0.7,
    this.isSleeping = false,
    this.isListening = false,
    this.isCharging = false,
    this.statusMessage,
    DateTime? lastInteraction,
  })  : energy = energy.clamp(0.0, 1.0),
        happiness = happiness.clamp(0.0, 1.0),
        lastInteraction = lastInteraction ?? DateTime.now();

  /// Human-readable status string describing the pet's current mood or custom message.
  String get statusText {
    if (statusMessage != null && statusMessage!.trim().isNotEmpty) {
      return statusMessage!;
    }
    return defaultStatusForMood(mood);
  }

  /// Appropriate emoji character representing the pet's mood.
  String get moodEmoji {
    switch (mood) {
      case PetMood.idle:
        return '😌';
      case PetMood.hello:
        return '👋';
      case PetMood.happy:
        return '😊';
      case PetMood.sad:
        return '🥺';
      case PetMood.sleeping:
        return '😴';
      case PetMood.waking:
        return '🥱';
      case PetMood.curious:
        return '🧐';
      case PetMood.surprised:
        return '😲';
      case PetMood.thinking:
        return '💭';
      case PetMood.excited:
        return '🤩';
      case PetMood.dancing:
        return '💃';
      case PetMood.listening:
        return '👂';
      case PetMood.charging:
        return '⚡';
      case PetMood.lowBattery:
        return '🪫';
      case PetMood.love:
        return '🥰';
      case PetMood.bored:
        return '😑';
      case PetMood.confused:
        return '😵‍💫';
      case PetMood.playful:
        return '🎾';
      case PetMood.goodMorning:
        return '🌅';
      case PetMood.goodNight:
        return '🌙';
    }
  }

  /// Default descriptive text for a given [PetMood].
  static String defaultStatusForMood(PetMood mood) {
    switch (mood) {
      case PetMood.idle:
        return 'Relaxing peacefully';
      case PetMood.hello:
        return 'Greeting you with a warm smile!';
      case PetMood.happy:
        return 'Feeling joyful and upbeat!';
      case PetMood.sad:
        return 'Feeling a little down... could use a pet';
      case PetMood.sleeping:
        return 'Catching some sweet dreams... zzz';
      case PetMood.waking:
        return 'Stretching and waking up!';
      case PetMood.curious:
        return 'Wondering what we are doing next?';
      case PetMood.surprised:
        return 'Whoa! Did not see that coming!';
      case PetMood.thinking:
        return 'Pondering deep digital thoughts...';
      case PetMood.excited:
        return 'Super excited to hang out with you!';
      case PetMood.dancing:
        return 'Grooving to the inner rhythm!';
      case PetMood.listening:
        return 'Listening closely to you...';
      case PetMood.charging:
        return 'Absorbing sweet electrical power...';
      case PetMood.lowBattery:
        return 'Running low on juice... Need power soon!';
      case PetMood.love:
        return 'Feeling so much love and gratitude!';
      case PetMood.bored:
        return 'A bit bored... Want to tap or play?';
      case PetMood.confused:
        return 'Hmm, not quite sure what happened there...';
      case PetMood.playful:
        return 'Ready for fun and games!';
      case PetMood.goodMorning:
        return 'Good morning! Ready for a wonderful day!';
      case PetMood.goodNight:
        return 'Good night! Rest well and sleep tight!';
    }
  }

  /// Creates a copy of this state with updated values.
  PetState copyWith({
    PetMood? mood,
    double? energy,
    double? happiness,
    bool? isSleeping,
    bool? isListening,
    bool? isCharging,
    String? statusMessage,
    bool clearStatusMessage = false,
    DateTime? lastInteraction,
  }) {
    return PetState(
      mood: mood ?? this.mood,
      energy: energy ?? this.energy,
      happiness: happiness ?? this.happiness,
      isSleeping: isSleeping ?? this.isSleeping,
      isListening: isListening ?? this.isListening,
      isCharging: isCharging ?? this.isCharging,
      statusMessage: clearStatusMessage ? null : (statusMessage ?? this.statusMessage),
      lastInteraction: lastInteraction ?? this.lastInteraction,
    );
  }

  /// Converts the state to a JSON-serializable Map.
  Map<String, dynamic> toJson() {
    return {
      'mood': mood.name,
      'energy': energy,
      'happiness': happiness,
      'isSleeping': isSleeping,
      'isListening': isListening,
      'isCharging': isCharging,
      'statusMessage': statusMessage,
      'lastInteraction': lastInteraction.toIso8601String(),
    };
  }

  /// Constructs a [PetState] from a JSON map.
  factory PetState.fromJson(Map<String, dynamic> json) {
    PetMood parsedMood = PetMood.idle;
    if (json['mood'] is String) {
      for (final value in PetMood.values) {
        if (value.name == json['mood']) {
          parsedMood = value;
          break;
        }
      }
    }

    return PetState(
      mood: parsedMood,
      energy: (json['energy'] as num?)?.toDouble() ?? 0.8,
      happiness: (json['happiness'] as num?)?.toDouble() ?? 0.7,
      isSleeping: json['isSleeping'] as bool? ?? false,
      isListening: json['isListening'] as bool? ?? false,
      isCharging: json['isCharging'] as bool? ?? false,
      statusMessage: json['statusMessage'] as String?,
      lastInteraction: json['lastInteraction'] is String
          ? DateTime.tryParse(json['lastInteraction'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PetState &&
          runtimeType == other.runtimeType &&
          mood == other.mood &&
          energy == other.energy &&
          happiness == other.happiness &&
          isSleeping == other.isSleeping &&
          isListening == other.isListening &&
          isCharging == other.isCharging &&
          statusMessage == other.statusMessage &&
          lastInteraction == other.lastInteraction;

  @override
  int get hashCode =>
      mood.hashCode ^
      energy.hashCode ^
      happiness.hashCode ^
      isSleeping.hashCode ^
      isListening.hashCode ^
      isCharging.hashCode ^
      (statusMessage?.hashCode ?? 0) ^
      lastInteraction.hashCode;

  @override
  String toString() {
    return 'PetState(mood: $mood, energy: ${energy.toStringAsFixed(2)}, happiness: ${happiness.toStringAsFixed(2)}, sleeping: $isSleeping, listening: $isListening, charging: $isCharging, status: "$statusText")';
  }
}
