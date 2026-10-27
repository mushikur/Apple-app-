import 'dart:async';
import 'package:flutter/material.dart';
import 'package:samir_pet/models/pet_event.dart';
import 'package:samir_pet/models/pet_personality.dart';
import 'package:samir_pet/models/pet_state.dart';
import 'package:samir_pet/pet/pet_behaviour_engine.dart';
import 'package:samir_pet/services/service_locator.dart';

/// PetProvider connects UI components with PetBehaviourEngine and hardware signals
class PetProvider extends ChangeNotifier {
  final PetBehaviourEngine _engine = PetBehaviourEngine();
  StreamSubscription? _batterySubscription;
  StreamSubscription? _chargingSubscription;
  StreamSubscription? _musicSubscription;

  PetBehaviourEngine get engine => _engine;
  PetState get state => _engine.state;
  PetPersonality get personality => _engine.personality;

  PetProvider() {
    _engine.addListener(notifyListeners);
    _initDeviceListeners();
  }

  void start() {
    _engine.start();
  }

  void pause() {
    _engine.pause();
  }

  void resume() {
    _engine.resume();
  }

  void processEvent(PetEvent event) {
    _engine.processEvent(event);
  }

  void setPetName(String name) {
    _engine.setPetName(name);
  }

  void setPersonality(PetPersonality personality) {
    _engine.setPersonality(personality);
  }

  void _initDeviceListeners() {
    // Battery level stream
    _batterySubscription = ServiceLocator.device.batteryLevelStream.listen((level) {
      if (level <= 0.20) {
        _engine.processEvent(PetEvent(type: PetEventType.lowBattery));
      }
    });

    // Charging state stream
    _chargingSubscription = ServiceLocator.device.chargingStream.listen((isCharging) {
      if (isCharging) {
        _engine.processEvent(PetEvent(type: PetEventType.deviceCharging));
      } else {
        _engine.processEvent(PetEvent(type: PetEventType.deviceUnplugged));
      }
    });

    // Music mode stream
    _musicSubscription = ServiceLocator.audio.musicModeStream.listen((musicActive) {
      if (musicActive) {
        _engine.processEvent(PetEvent(type: PetEventType.musicModeOn));
      } else {
        _engine.processEvent(PetEvent(type: PetEventType.musicModeOff));
      }
    });
  }

  @override
  void dispose() {
    _batterySubscription?.cancel();
    _chargingSubscription?.cancel();
    _musicSubscription?.cancel();
    _engine.removeListener(notifyListeners);
    _engine.dispose();
    super.dispose();
  }
}
