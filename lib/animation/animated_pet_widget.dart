import 'dart:async';
import 'package:flutter/material.dart';
import 'package:samir_pet/animation/pet_character_painter.dart';
import 'package:samir_pet/core/utils/haptic_utils.dart';
import 'package:samir_pet/models/pet_event.dart';
import 'package:samir_pet/models/pet_state.dart';
import 'package:samir_pet/pet/pet_animation_controller.dart';
import 'package:samir_pet/pet/pet_behaviour_engine.dart';

/// Animated pet widget displaying the vector character with live physics and gesture triggers
class AnimatedPetWidget extends StatefulWidget {
  final PetBehaviourEngine engine;
  final double size;
  final bool interactive;

  const AnimatedPetWidget({
    super.key,
    required this.engine,
    this.size = 240,
    this.interactive = true,
  });

  @override
  State<AnimatedPetWidget> createState() => _AnimatedPetWidgetState();
}

class _AnimatedPetWidgetState extends State<AnimatedPetWidget> with TickerProviderStateMixin {
  late final PetAnimationController _animController;
  late final AnimationController _breathingController;
  late final AnimationController _bounceController;
  StreamSubscription? _idleSubscription;

  @override
  void initState() {
    super.initState();
    _animController = PetAnimationController();
    _animController.updateForState(widget.engine.state);

    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    widget.engine.addListener(_onEngineStateChanged);
    _animController.addListener(_onAnimControllerChanged);

    _idleSubscription = widget.engine.idleBehaviourStream.listen((behaviour) {
      if (!mounted) return;
      switch (behaviour) {
        case IdleBehaviour.blink:
          _animController.blink();
          break;
        case IdleBehaviour.lookLeft:
          _animController.look(-0.6, 0.0);
          Future.delayed(const Duration(milliseconds: 1500), () {
            if (mounted) _animController.look(0.0, 0.0);
          });
          break;
        case IdleBehaviour.lookRight:
          _animController.look(0.6, 0.0);
          Future.delayed(const Duration(milliseconds: 1500), () {
            if (mounted) _animController.look(0.0, 0.0);
          });
          break;
        case IdleBehaviour.lookUp:
          _animController.look(0.0, -0.6);
          Future.delayed(const Duration(milliseconds: 1500), () {
            if (mounted) _animController.look(0.0, 0.0);
          });
          break;
        case IdleBehaviour.headTilt:
          _triggerBounce();
          break;
        default:
          break;
      }
    });
  }

  void _onEngineStateChanged() {
    if (!mounted) return;
    _animController.updateForState(widget.engine.state);
    if (widget.engine.state.mood == PetMood.happy ||
        widget.engine.state.mood == PetMood.dancing ||
        widget.engine.state.mood == PetMood.excited ||
        widget.engine.state.mood == PetMood.playful ||
        widget.engine.state.mood == PetMood.hello) {
      _triggerBounce();
    }
  }

  void _onAnimControllerChanged() {
    if (mounted) setState(() {});
  }

  void _triggerBounce() {
    if (!_bounceController.isAnimating) {
      _bounceController.forward(from: 0.0).then((_) {
        if (mounted) _bounceController.reverse();
      });
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedPetWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.engine != widget.engine) {
      oldWidget.engine.removeListener(_onEngineStateChanged);
      widget.engine.addListener(_onEngineStateChanged);
      _animController.updateForState(widget.engine.state);
    }
  }

  @override
  void dispose() {
    widget.engine.removeListener(_onEngineStateChanged);
    _animController.removeListener(_onAnimControllerChanged);
    _animController.dispose();
    _idleSubscription?.cancel();
    _breathingController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pet = AnimatedBuilder(
      animation: Listenable.merge([_breathingController, _bounceController]),
      builder: (context, _) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: PetCharacterPainter(
            mood: _animController.currentMood,
            eyeOpenness: _animController.eyeOpenness,
            pupilOffsetX: _animController.pupilOffsetX,
            pupilOffsetY: _animController.pupilOffsetY,
            mouthCurve: _animController.mouthCurve,
            mouthOpenness: _animController.mouthOpenness,
            bodyBounce: _bounceController.value * -0.8,
            blushIntensity: _animController.blushIntensity,
            headTilt: _animController.headTilt,
            leftEyebrowAngle: _animController.leftEyebrowAngle,
            rightEyebrowAngle: _animController.rightEyebrowAngle,
            leftEyebrowOffsetY: _animController.leftEyebrowOffsetY,
            rightEyebrowOffsetY: _animController.rightEyebrowOffsetY,
            leftArmAngle: _animController.leftArmAngle,
            rightArmAngle: _animController.rightArmAngle,
            showHeadphones: _animController.showHeadphones,
            showZzz: _animController.showZzz,
            showSparkles: _animController.showSparkles,
            showHearts: _animController.showHearts,
            showSweatDrop: _animController.showSweatDrop,
            showLightning: _animController.showLightning,
            showSun: _animController.showSun,
            showMoon: _animController.showMoon,
            showQuestionMark: _animController.showQuestionMark,
            breathingProgress: _breathingController.value,
          ),
        );
      },
    );

    if (!widget.interactive) return pet;

    return GestureDetector(
      onTap: () {
        HapticUtils.lightTap();
        _triggerBounce();
        widget.engine.processEvent(PetEvent(type: PetEventType.userTappedPet));
      },
      onDoubleTap: () {
        HapticUtils.mediumTap();
        _triggerBounce();
        widget.engine.processEvent(PetEvent(type: PetEventType.userDoubleTappedPet));
      },
      onLongPress: () {
        HapticUtils.heavyTap();
        _triggerBounce();
        widget.engine.processEvent(PetEvent(type: PetEventType.userLongPressedPet));
      },
      onPanEnd: (_) {
        HapticUtils.selectionTap();
        _triggerBounce();
        widget.engine.processEvent(PetEvent(type: PetEventType.userSwipedPet));
      },
      child: pet,
    );
  }
}
