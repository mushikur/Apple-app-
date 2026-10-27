/// Event types that drive pet behaviour transitions.
enum PetEventType {
  appOpened,
  userTappedPet,
  userDoubleTappedPet,
  userLongPressedPet,
  userSwipedPet,
  deviceCharging,
  deviceUnplugged,
  lowBattery,
  longIdle,
  morning,
  afternoon,
  evening,
  night,
  musicActivity,
  musicModeOn,
  musicModeOff,
  userSpeaking,
  aiResponse,
  appReturnedToForeground,
  appWentToBackground,
  motionEvent,
  sleepRequested,
  wakeRequested,
  playRequested,
  danceRequested,
  thinkRequested,
}

/// Priority levels for event processing.
enum EventPriority {
  critical,
  high,
  normal,
  low,
  background,
}

/// An event that drives the pet behaviour engine.
class PetEvent {
  final PetEventType type;
  final EventPriority priority;
  final DateTime timestamp;
  final Map<String, dynamic>? data;

  PetEvent({
    required this.type,
    EventPriority? priority,
    DateTime? timestamp,
    this.data,
  })  : priority = priority ?? PetEvent.priorityFor(type),
        timestamp = timestamp ?? DateTime.now();

  /// Default priority mapping for each event type.
  static EventPriority priorityFor(PetEventType type) {
    switch (type) {
      case PetEventType.lowBattery:
        return EventPriority.critical;
      case PetEventType.deviceCharging:
      case PetEventType.deviceUnplugged:
        return EventPriority.critical;
      case PetEventType.appOpened:
      case PetEventType.userTappedPet:
      case PetEventType.userDoubleTappedPet:
      case PetEventType.userLongPressedPet:
      case PetEventType.userSwipedPet:
      case PetEventType.appReturnedToForeground:
        return EventPriority.high;
      case PetEventType.morning:
      case PetEventType.afternoon:
      case PetEventType.evening:
      case PetEventType.night:
      case PetEventType.musicModeOn:
      case PetEventType.musicModeOff:
      case PetEventType.musicActivity:
      case PetEventType.sleepRequested:
      case PetEventType.wakeRequested:
      case PetEventType.playRequested:
      case PetEventType.danceRequested:
      case PetEventType.thinkRequested:
      case PetEventType.userSpeaking:
      case PetEventType.aiResponse:
        return EventPriority.normal;
      case PetEventType.longIdle:
      case PetEventType.motionEvent:
        return EventPriority.low;
      case PetEventType.appWentToBackground:
        return EventPriority.background;
    }
  }

  @override
  String toString() => 'PetEvent($type, priority: $priority)';
}
