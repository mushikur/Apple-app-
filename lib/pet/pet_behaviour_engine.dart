import 'dart:async';
import 'dart:collection';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:samir_pet/models/pet_state.dart';
import 'package:samir_pet/models/pet_event.dart';
import 'package:samir_pet/models/pet_personality.dart';
import 'package:samir_pet/core/constants/app_constants.dart';
import 'package:samir_pet/core/utils/time_utils.dart';

/// Idle behaviour actions for subtle life simulation.
enum IdleBehaviour { blink, lookLeft, lookRight, lookUp, smallSmile, breathe, stretch, yawn, tailWag, headTilt, earTwitch }

/// The central brain of Samir Pet. Processes events, manages state, runs idle simulation.
class PetBehaviourEngine extends ChangeNotifier {
  PetState _state = PetState();
  PetPersonality _personality = PetPersonality.defaultPersonality();
  final Random _random = Random();
  final Queue<PetEvent> _eventQueue = Queue();

  Timer? _idleTimer;
  Timer? _energyDecayTimer;
  Timer? _moodResetTimer;
  bool _isActive = false;
  bool _idleAnimationsEnabled = true;

  // Idle behaviour stream for animation system
  final _idleBehaviourController = StreamController<IdleBehaviour>.broadcast();
  Stream<IdleBehaviour> get idleBehaviourStream => _idleBehaviourController.stream;

  PetState get state => _state;
  PetPersonality get personality => _personality;
  bool get isActive => _isActive;

  /// Start the behaviour engine — begins idle simulation and timers.
  void start() {
    if (_isActive) return;
    _isActive = true;
    _startIdleTimer();
    _startEnergyDecay();
    _checkTimeOfDay();
    notifyListeners();
  }

  /// Pause engine when app goes to background.
  void pause() {
    _isActive = false;
    _idleTimer?.cancel();
    _energyDecayTimer?.cancel();
    _moodResetTimer?.cancel();
  }

  /// Resume engine when app returns to foreground.
  void resume() {
    if (_isActive) return;
    _isActive = true;
    _startIdleTimer();
    _startEnergyDecay();
    notifyListeners();
  }

  void setPetName(String name) {
    _state = _state.copyWith(statusMessage: null, clearStatusMessage: true);
    notifyListeners();
  }

  void setPersonality(PetPersonality p) {
    _personality = p;
    notifyListeners();
  }

  void setIdleAnimationsEnabled(bool enabled) {
    _idleAnimationsEnabled = enabled;
    if (!enabled) {
      _idleTimer?.cancel();
    } else if (_isActive) {
      _startIdleTimer();
    }
  }

  /// Process an incoming event.
  void processEvent(PetEvent event) {
    if (!_isActive && event.priority != EventPriority.critical) return;

    // Priority check: if sleeping, only critical/high events wake the pet
    if (_state.isSleeping) {
      if (event.priority == EventPriority.low || event.priority == EventPriority.background) {
        return; // Ignore low priority events during sleep
      }
      if (event.priority == EventPriority.normal &&
          event.type != PetEventType.wakeRequested) {
        _eventQueue.add(event); // Queue for later
        return;
      }
      // Wake up for critical/high events
      _wakeUp();
    }

    _handleEvent(event);
  }

  void _handleEvent(PetEvent event) {
    switch (event.type) {
      case PetEventType.appOpened:
      case PetEventType.appReturnedToForeground:
        _transitionTo(PetMood.hello, message: _pickGreeting());
        break;
      case PetEventType.userTappedPet:
        _onTap();
        break;
      case PetEventType.userDoubleTappedPet:
        _transitionTo(PetMood.love, message: _pickReaction(PetMood.love));
        _boostEnergy(AppConstants.energyTapBoost * 2);
        break;
      case PetEventType.userLongPressedPet:
        _transitionTo(PetMood.happy, message: _pickReaction(PetMood.happy));
        break;
      case PetEventType.userSwipedPet:
        _transitionTo(PetMood.playful, message: _pickReaction(PetMood.playful));
        break;
      case PetEventType.deviceCharging:
        _state = _state.copyWith(isCharging: true);
        _transitionTo(PetMood.charging, message: _pickReaction(PetMood.charging));
        break;
      case PetEventType.deviceUnplugged:
        _state = _state.copyWith(isCharging: false);
        _transitionTo(PetMood.happy, duration: const Duration(seconds: 2));
        break;
      case PetEventType.lowBattery:
        _transitionTo(PetMood.lowBattery, message: _pickReaction(PetMood.lowBattery));
        break;
      case PetEventType.sleepRequested:
        _goToSleep();
        break;
      case PetEventType.wakeRequested:
        _wakeUp();
        break;
      case PetEventType.musicModeOn:
        _state = _state.copyWith(isListening: true);
        _transitionTo(PetMood.listening, message: 'Putting on headphones! 🎧');
        Future.delayed(const Duration(seconds: 2), () {
          if (_state.isListening) {
            _transitionTo(PetMood.dancing, message: _pickReaction(PetMood.dancing), persistent: true);
          }
        });
        break;
      case PetEventType.musicModeOff:
        _state = _state.copyWith(isListening: false);
        _transitionTo(PetMood.happy, message: 'That was fun! 🎵');
        break;
      case PetEventType.playRequested:
        _transitionTo(PetMood.playful, message: _pickReaction(PetMood.playful));
        break;
      case PetEventType.danceRequested:
        _transitionTo(PetMood.dancing, message: _pickReaction(PetMood.dancing));
        break;
      case PetEventType.thinkRequested:
        _transitionTo(PetMood.thinking, message: _pickReaction(PetMood.thinking));
        break;
      case PetEventType.morning:
        _transitionTo(PetMood.goodMorning, message: 'Good morning! ☀️');
        break;
      case PetEventType.night:
        _transitionTo(PetMood.goodNight, message: 'Getting sleepy... 🌙');
        break;
      case PetEventType.longIdle:
        _transitionTo(PetMood.bored, message: _pickReaction(PetMood.bored));
        break;
      default:
        break;
    }

    _state = _state.copyWith(lastInteraction: DateTime.now());
  }

  void _onTap() {
    _boostEnergy(AppConstants.energyTapBoost);
    final moods = [PetMood.happy, PetMood.curious, PetMood.surprised, PetMood.love];
    final mood = moods[_random.nextInt(moods.length)];
    _transitionTo(mood, message: _pickReaction(mood));
  }

  void _transitionTo(PetMood mood, {String? message, Duration? duration, bool persistent = false}) {
    _moodResetTimer?.cancel();
    _state = _state.copyWith(
      mood: mood,
      statusMessage: message,
      happiness: (mood == PetMood.happy || mood == PetMood.love || mood == PetMood.excited)
          ? (_state.happiness + 0.1).clamp(0.0, 1.0)
          : (mood == PetMood.sad ? (_state.happiness - 0.1).clamp(0.0, 1.0) : null),
    );
    notifyListeners();

    if (!persistent && mood != PetMood.sleeping && mood != PetMood.idle) {
      final dur = duration ?? Duration(milliseconds: AppConstants.moodDisplayMs);
      _moodResetTimer = Timer(dur, _returnToIdle);
    }
  }

  void _returnToIdle() {
    if (_state.isSleeping) return;
    _state = _state.copyWith(mood: PetMood.idle, clearStatusMessage: true);
    notifyListeners();
  }

  void _goToSleep() {
    _idleTimer?.cancel();
    _state = _state.copyWith(
      mood: PetMood.sleeping,
      isSleeping: true,
      statusMessage: 'Zzz... 💤',
    );
    notifyListeners();
    // Slowly recover energy while sleeping
    _energyDecayTimer?.cancel();
    _energyDecayTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (_state.isSleeping) {
        _state = _state.copyWith(
          energy: (_state.energy + AppConstants.energySleepRecoveryPerMinute / 6).clamp(0.0, 1.0),
        );
        notifyListeners();
      }
    });
  }

  void _wakeUp() {
    _state = _state.copyWith(
      mood: PetMood.waking,
      isSleeping: false,
      statusMessage: '*yawns and stretches* 🥱',
    );
    notifyListeners();
    Future.delayed(const Duration(seconds: 2), () {
      _transitionTo(PetMood.hello, message: _pickGreeting());
      _startIdleTimer();
      _startEnergyDecay();
    });
  }

  void _boostEnergy(double amount) {
    _state = _state.copyWith(energy: (_state.energy + amount).clamp(0.0, 1.0));
  }

  // === Idle Behaviour System ===

  void _startIdleTimer() {
    _idleTimer?.cancel();
    if (!_idleAnimationsEnabled) return;
    final interval = AppConstants.idleMinIntervalSec +
        _random.nextInt(AppConstants.idleMaxIntervalSec - AppConstants.idleMinIntervalSec + 1);
    _idleTimer = Timer(Duration(seconds: interval), _onIdleTick);
  }

  void _onIdleTick() {
    if (!_isActive || _state.isSleeping || _state.mood != PetMood.idle) {
      _startIdleTimer();
      return;
    }

    // Weighted random idle behaviour (blink is most common)
    final roll = _random.nextDouble();
    IdleBehaviour behaviour;
    if (roll < 0.35) {
      behaviour = IdleBehaviour.blink;
    } else if (roll < 0.50) {
      behaviour = IdleBehaviour.lookLeft;
    } else if (roll < 0.65) {
      behaviour = IdleBehaviour.lookRight;
    } else if (roll < 0.75) {
      behaviour = IdleBehaviour.smallSmile;
    } else if (roll < 0.82) {
      behaviour = IdleBehaviour.headTilt;
    } else if (roll < 0.88) {
      behaviour = IdleBehaviour.breathe;
    } else if (roll < 0.93) {
      behaviour = IdleBehaviour.tailWag;
    } else {
      behaviour = IdleBehaviour.earTwitch;
    }

    _idleBehaviourController.add(behaviour);
    _startIdleTimer();
  }

  void _startEnergyDecay() {
    _energyDecayTimer?.cancel();
    _energyDecayTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (!_isActive || _state.isSleeping) return;
      final newEnergy = (_state.energy - AppConstants.energyDecayPerMinute).clamp(0.0, 1.0);
      _state = _state.copyWith(energy: newEnergy);

      if (newEnergy <= AppConstants.energySleepThreshold && !_state.isSleeping) {
        _goToSleep();
      } else if (newEnergy <= AppConstants.energySleepyThreshold) {
        if (_state.mood == PetMood.idle) {
          _transitionTo(PetMood.bored, message: 'Getting sleepy...', duration: const Duration(seconds: 5));
        }
      }
      notifyListeners();
    });
  }

  void _checkTimeOfDay() {
    final time = TimeUtils.getTimeOfDay();
    switch (time) {
      case TimeOfDay.morning:
        processEvent(PetEvent(type: PetEventType.morning));
        break;
      case TimeOfDay.night:
        if (TimeUtils.isBedtime()) {
          processEvent(PetEvent(type: PetEventType.night));
        }
        break;
      default:
        processEvent(PetEvent(type: PetEventType.appOpened));
        break;
    }
  }

  // === Helpers ===

  String _pickGreeting() {
    if (_personality.greetings.isEmpty) return 'Hello! 👋';
    return _personality.greetings[_random.nextInt(_personality.greetings.length)];
  }

  String? _pickReaction(PetMood mood) {
    final reactions = _personality.reactions[mood];
    if (reactions == null || reactions.isEmpty) return null;
    return reactions[_random.nextInt(reactions.length)];
  }

  /// Force a specific mood (for demo/debug purposes).
  void debugSetMood(PetMood mood) {
    _transitionTo(mood, message: PetState.defaultStatusForMood(mood));
  }

  /// Force set energy level (for demo/debug).
  void debugSetEnergy(double energy) {
    _state = _state.copyWith(energy: energy);
    notifyListeners();
  }

  @override
  void dispose() {
    _idleTimer?.cancel();
    _energyDecayTimer?.cancel();
    _moodResetTimer?.cancel();
    _idleBehaviourController.close();
    super.dispose();
  }
}
