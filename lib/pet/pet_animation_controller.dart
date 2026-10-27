import 'package:flutter/foundation.dart';
import 'package:samir_pet/models/pet_state.dart';

/// Bridges the PetBehaviourEngine and the rendering layer (Canvas/Rive) with distinct expression coordinates for all 20 PetMood states.
class PetAnimationController extends ChangeNotifier {
  PetMood _currentMood = PetMood.idle;
  final bool _isTransitioning = false;
  double _eyeOpenness = 1.0;
  double _pupilOffsetX = 0.0;
  double _pupilOffsetY = 0.0;
  double _mouthCurve = 0.5; // 0.0 neutral, 1.0 smile, -1.0 sad
  double _mouthOpenness = 0.0; // 0.0 closed, 1.0 wide open
  final double _bodyBounce = 0.0;
  double _blushIntensity = 0.3;
  double _headTilt = 0.0;
  double _leftEyebrowAngle = 0.0;
  double _rightEyebrowAngle = 0.0;
  double _leftEyebrowOffsetY = 0.0;
  double _rightEyebrowOffsetY = 0.0;
  double _leftArmAngle = 0.0;
  double _rightArmAngle = 0.0;
  bool _showHeadphones = false;
  bool _showZzz = false;
  bool _showSparkles = false;
  bool _showHearts = false;
  bool _showSweatDrop = false;
  bool _showLightning = false;
  bool _showSun = false;
  bool _showMoon = false;
  bool _showQuestionMark = false;

  PetMood get currentMood => _currentMood;
  bool get isTransitioning => _isTransitioning;
  double get eyeOpenness => _eyeOpenness;
  double get pupilOffsetX => _pupilOffsetX;
  double get pupilOffsetY => _pupilOffsetY;
  double get mouthCurve => _mouthCurve;
  double get mouthOpenness => _mouthOpenness;
  double get bodyBounce => _bodyBounce;
  double get blushIntensity => _blushIntensity;
  double get headTilt => _headTilt;
  double get leftEyebrowAngle => _leftEyebrowAngle;
  double get rightEyebrowAngle => _rightEyebrowAngle;
  double get leftEyebrowOffsetY => _leftEyebrowOffsetY;
  double get rightEyebrowOffsetY => _rightEyebrowOffsetY;
  double get leftArmAngle => _leftArmAngle;
  double get rightArmAngle => _rightArmAngle;
  bool get showHeadphones => _showHeadphones;
  bool get showZzz => _showZzz;
  bool get showSparkles => _showSparkles;
  bool get showHearts => _showHearts;
  bool get showSweatDrop => _showSweatDrop;
  bool get showLightning => _showLightning;
  bool get showSun => _showSun;
  bool get showMoon => _showMoon;
  bool get showQuestionMark => _showQuestionMark;

  /// Update animation parameters based on all 20 PetMood values
  void updateForState(PetState state) {
    _currentMood = state.mood;
    _showHeadphones = state.isListening;
    _showZzz = state.isSleeping;
    _showSparkles = false;
    _showHearts = false;
    _showSweatDrop = false;
    _showLightning = false;
    _showSun = false;
    _showMoon = false;
    _showQuestionMark = false;
    _mouthOpenness = 0.0;
    _leftArmAngle = 0.0;
    _rightArmAngle = 0.0;
    _leftEyebrowAngle = 0.0;
    _rightEyebrowAngle = 0.0;
    _leftEyebrowOffsetY = 0.0;
    _rightEyebrowOffsetY = 0.0;

    switch (state.mood) {
      case PetMood.idle:
        _eyeOpenness = 1.0;
        _pupilOffsetX = 0.0;
        _pupilOffsetY = 0.0;
        _mouthCurve = 0.35;
        _blushIntensity = 0.25;
        _headTilt = 0.0;
        break;

      case PetMood.hello:
        _eyeOpenness = 1.0;
        _pupilOffsetX = 0.0;
        _pupilOffsetY = -0.1;
        _mouthCurve = 0.85;
        _mouthOpenness = 0.35;
        _blushIntensity = 0.65;
        _headTilt = 0.08;
        _rightArmAngle = -0.9; // Waving right arm
        _showSparkles = true;
        _leftEyebrowOffsetY = -4.0;
        _rightEyebrowOffsetY = -4.0;
        break;

      case PetMood.happy:
        _eyeOpenness = 1.0;
        _pupilOffsetX = 0.0;
        _pupilOffsetY = 0.0;
        _mouthCurve = 1.0;
        _mouthOpenness = 0.45;
        _blushIntensity = 0.75;
        _headTilt = 0.04;
        _showSparkles = true;
        _leftEyebrowAngle = -0.1;
        _rightEyebrowAngle = 0.1;
        break;

      case PetMood.sad:
        _eyeOpenness = 0.75;
        _pupilOffsetX = 0.0;
        _pupilOffsetY = 0.35;
        _mouthCurve = -0.75;
        _blushIntensity = 0.1;
        _headTilt = -0.08;
        _leftEyebrowAngle = 0.25; // Droopy sad brows
        _rightEyebrowAngle = -0.25;
        _leftEyebrowOffsetY = 3.0;
        _rightEyebrowOffsetY = 3.0;
        break;

      case PetMood.sleeping:
        _eyeOpenness = 0.0;
        _pupilOffsetX = 0.0;
        _pupilOffsetY = 0.0;
        _mouthCurve = 0.15;
        _blushIntensity = 0.4;
        _headTilt = 0.12;
        _showZzz = true;
        break;

      case PetMood.waking:
        _eyeOpenness = 0.5;
        _pupilOffsetX = 0.0;
        _pupilOffsetY = 0.0;
        _mouthCurve = 0.4;
        _mouthOpenness = 0.65; // Big morning yawn
        _blushIntensity = 0.5;
        _leftArmAngle = -0.5; // Stretching arms
        _rightArmAngle = 0.5;
        _leftEyebrowOffsetY = -5.0;
        _rightEyebrowOffsetY = -5.0;
        break;

      case PetMood.curious:
        _eyeOpenness = 1.0;
        _pupilOffsetX = 0.45;
        _pupilOffsetY = -0.35;
        _mouthCurve = 0.2;
        _headTilt = 0.22; // Inquisitive head tilt
        _showQuestionMark = true;
        _leftEyebrowOffsetY = -8.0; // One raised eyebrow
        _rightEyebrowOffsetY = 1.0;
        _leftEyebrowAngle = -0.15;
        break;

      case PetMood.surprised:
        _eyeOpenness = 1.0;
        _pupilOffsetX = 0.0;
        _pupilOffsetY = 0.0;
        _mouthCurve = 0.0;
        _mouthOpenness = 0.85; // Wide open 'O' mouth
        _blushIntensity = 0.45;
        _headTilt = 0.0;
        _leftEyebrowOffsetY = -10.0; // Both eyebrows raised high
        _rightEyebrowOffsetY = -10.0;
        _showSparkles = true;
        break;

      case PetMood.thinking:
        _eyeOpenness = 0.88;
        _pupilOffsetX = -0.55;
        _pupilOffsetY = -0.65; // Looking up into thought
        _mouthCurve = 0.1;
        _headTilt = -0.16;
        _leftEyebrowAngle = 0.18;
        _rightEyebrowAngle = -0.05;
        _showQuestionMark = true;
        break;

      case PetMood.excited:
        _eyeOpenness = 1.0;
        _pupilOffsetX = 0.0;
        _pupilOffsetY = -0.1;
        _mouthCurve = 1.0;
        _mouthOpenness = 0.6;
        _blushIntensity = 0.85;
        _headTilt = 0.06;
        _leftArmAngle = -0.7; // Arms up in excitement
        _rightArmAngle = 0.7;
        _showSparkles = true;
        break;

      case PetMood.dancing:
        _eyeOpenness = 1.0;
        _pupilOffsetX = 0.15;
        _pupilOffsetY = 0.0;
        _mouthCurve = 0.95;
        _mouthOpenness = 0.4;
        _blushIntensity = 0.75;
        _headTilt = 0.18;
        _leftArmAngle = 0.6;
        _rightArmAngle = -0.8;
        _showSparkles = true;
        _showHeadphones = true;
        break;

      case PetMood.listening:
        _eyeOpenness = 1.0;
        _pupilOffsetX = 0.0;
        _pupilOffsetY = 0.0;
        _mouthCurve = 0.35;
        _showHeadphones = true;
        _headTilt = 0.08;
        break;

      case PetMood.charging:
        _eyeOpenness = 1.0;
        _pupilOffsetX = 0.0;
        _pupilOffsetY = -0.1;
        _mouthCurve = 0.8;
        _mouthOpenness = 0.3;
        _blushIntensity = 0.8;
        _showLightning = true;
        _showSparkles = true;
        break;

      case PetMood.lowBattery:
        _eyeOpenness = 0.55;
        _pupilOffsetX = 0.0;
        _pupilOffsetY = 0.4;
        _mouthCurve = -0.5;
        _blushIntensity = 0.0;
        _headTilt = -0.12;
        _showSweatDrop = true;
        _leftEyebrowAngle = 0.2;
        _rightEyebrowAngle = -0.2;
        break;

      case PetMood.love:
        _eyeOpenness = 1.0;
        _mouthCurve = 0.95;
        _mouthOpenness = 0.25;
        _blushIntensity = 0.95;
        _headTilt = 0.1;
        _showHearts = true;
        _showSparkles = true;
        break;

      case PetMood.bored:
        _eyeOpenness = 0.65;
        _pupilOffsetX = 0.65; // Looking sideways
        _pupilOffsetY = 0.0;
        _mouthCurve = -0.2;
        _blushIntensity = 0.1;
        _headTilt = -0.06;
        _leftEyebrowAngle = -0.1;
        _rightEyebrowAngle = 0.1;
        break;

      case PetMood.confused:
        _eyeOpenness = 0.82;
        _pupilOffsetX = -0.3;
        _pupilOffsetY = 0.2;
        _mouthCurve = -0.15;
        _headTilt = 0.26;
        _showSweatDrop = true;
        _leftEyebrowAngle = -0.22;
        _rightEyebrowAngle = 0.22;
        break;

      case PetMood.playful:
        _eyeOpenness = 1.0;
        _pupilOffsetX = 0.0;
        _pupilOffsetY = -0.1;
        _mouthCurve = 0.95;
        _mouthOpenness = 0.5;
        _blushIntensity = 0.7;
        _headTilt = -0.14;
        _showSparkles = true;
        _leftArmAngle = -0.6;
        _rightArmAngle = 0.4;
        break;

      case PetMood.goodMorning:
        _eyeOpenness = 0.92;
        _pupilOffsetX = 0.0;
        _pupilOffsetY = 0.0;
        _mouthCurve = 0.85;
        _mouthOpenness = 0.3;
        _blushIntensity = 0.65;
        _showSun = true;
        _showSparkles = true;
        break;

      case PetMood.goodNight:
        _eyeOpenness = 0.25;
        _pupilOffsetX = 0.0;
        _pupilOffsetY = 0.3;
        _mouthCurve = 0.3;
        _blushIntensity = 0.4;
        _showMoon = true;
        _showZzz = true;
        _headTilt = 0.14;
        break;
    }
    notifyListeners();
  }

  void blink() {
    _eyeOpenness = 0.0;
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 160), () {
      if (_currentMood != PetMood.sleeping && _currentMood != PetMood.goodNight) {
        _eyeOpenness = 1.0;
        notifyListeners();
      }
    });
  }

  void look(double x, double y) {
    _pupilOffsetX = x;
    _pupilOffsetY = y;
    notifyListeners();
  }
}
