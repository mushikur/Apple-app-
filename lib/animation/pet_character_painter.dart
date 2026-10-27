import 'dart:math';
import 'package:flutter/material.dart';
import 'package:samir_pet/core/constants/app_colors.dart';
import 'package:samir_pet/models/pet_state.dart';

/// Premium custom painter for Samir Pet character with distinct expressions for all 20 PetMood states.
class PetCharacterPainter extends CustomPainter {
  final PetMood mood;
  final double eyeOpenness;
  final double pupilOffsetX;
  final double pupilOffsetY;
  final double mouthCurve;
  final double mouthOpenness;
  final double bodyBounce;
  final double blushIntensity;
  final double headTilt;
  final double leftEyebrowAngle;
  final double rightEyebrowAngle;
  final double leftEyebrowOffsetY;
  final double rightEyebrowOffsetY;
  final double leftArmAngle;
  final double rightArmAngle;
  final bool showHeadphones;
  final bool showZzz;
  final bool showSparkles;
  final bool showHearts;
  final bool showSweatDrop;
  final bool showLightning;
  final bool showSun;
  final bool showMoon;
  final bool showQuestionMark;
  final double breathingProgress;

  PetCharacterPainter({
    required this.mood,
    this.eyeOpenness = 1.0,
    this.pupilOffsetX = 0.0,
    this.pupilOffsetY = 0.0,
    this.mouthCurve = 0.5,
    this.mouthOpenness = 0.0,
    this.bodyBounce = 0.0,
    this.blushIntensity = 0.4,
    this.headTilt = 0.0,
    this.leftEyebrowAngle = 0.0,
    this.rightEyebrowAngle = 0.0,
    this.leftEyebrowOffsetY = 0.0,
    this.rightEyebrowOffsetY = 0.0,
    this.leftArmAngle = 0.0,
    this.rightArmAngle = 0.0,
    this.showHeadphones = false,
    this.showZzz = false,
    this.showSparkles = false,
    this.showHearts = false,
    this.showSweatDrop = false,
    this.showLightning = false,
    this.showSun = false,
    this.showMoon = false,
    this.showQuestionMark = false,
    this.breathingProgress = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) * 0.38;

    canvas.save();
    // Head tilt and bounce
    canvas.translate(center.dx, center.dy + bodyBounce * 14);
    canvas.rotate(headTilt);

    // 1. Ambient drop shadow under feet
    _drawShadow(canvas, radius);

    // 2. Cute Little Feet
    _drawFeet(canvas, radius);

    // 3. Cute Little Tail (wagging slightly with breathing)
    _drawTail(canvas, radius);

    // 4. Little Stubby Arms (before or after body depending on gesture)
    _drawArms(canvas, radius);

    // 5. Ears on top with inner ear gradients
    _drawEars(canvas, radius);

    // 6. Main Body & Belly
    _drawBody(canvas, radius);

    // 7. Cheeks & Blush
    if (blushIntensity > 0) {
      _drawBlush(canvas, radius);
    }

    // 8. Eyebrows (expressive curves)
    _drawEyebrows(canvas, radius);

    // 9. Eyes, Pupils, Highlights, Special Shapes (Hearts, Stars, X)
    _drawEyes(canvas, radius);

    // 10. Cute Button Nose
    _drawNose(canvas, radius);

    // 11. Expressive Mouth (dynamic curve and open mouth interior)
    _drawMouth(canvas, radius);

    // 12. Head accessories: Headphones
    if (showHeadphones) {
      _drawHeadphones(canvas, radius);
    }

    // 13. State-specific floating visual particle effects
    _drawStateEffects(canvas, radius);

    canvas.restore();
  }

  void _drawShadow(Canvas canvas, double radius) {
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.22)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(0, radius + 22),
        width: radius * 1.6,
        height: 22,
      ),
      shadowPaint,
    );
  }

  void _drawFeet(Canvas canvas, double radius) {
    final feetPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppColors.petBody, AppColors.petBodyDark],
      ).createShader(Rect.fromLTWH(-radius, radius * 0.7, radius * 2, radius * 0.5));

    // Left foot
    canvas.drawOval(
      Rect.fromCenter(center: Offset(-radius * 0.38, radius * 0.88), width: radius * 0.38, height: radius * 0.24),
      feetPaint,
    );
    // Right foot
    canvas.drawOval(
      Rect.fromCenter(center: Offset(radius * 0.38, radius * 0.88), width: radius * 0.38, height: radius * 0.24),
      feetPaint,
    );
  }

  void _drawTail(Canvas canvas, double radius) {
    final wag = sin(breathingProgress * 2 * pi) * 0.15;
    final tailPaint = Paint()
      ..color = AppColors.petBodyDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    final tailPath = Path()
      ..moveTo(radius * 0.7, radius * 0.4)
      ..cubicTo(
        radius * 1.05 + (wag * 20), radius * 0.2,
        radius * 1.1 + (wag * 30), radius * -0.1,
        radius * 0.95 + (wag * 25), radius * -0.25,
      );
    canvas.drawPath(tailPath, tailPaint);

    // Fluffy tail tip
    final tipPaint = Paint()..color = AppColors.petBodyLight;
    canvas.drawCircle(Offset(radius * 0.95 + (wag * 25), radius * -0.25), 10, tipPaint);
  }

  void _drawArms(Canvas canvas, double radius) {
    final armPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppColors.petBody, AppColors.petBodyDark],
      ).createShader(Rect.fromLTWH(-radius, 0, radius * 2, radius));

    // Left Arm
    canvas.save();
    canvas.translate(-radius * 0.85, radius * 0.25);
    canvas.rotate(leftArmAngle);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: const Offset(0, 0), width: radius * 0.26, height: radius * 0.42),
        const Radius.circular(14),
      ),
      armPaint,
    );
    canvas.restore();

    // Right Arm (can wave for hello/dancing)
    canvas.save();
    canvas.translate(radius * 0.85, radius * 0.25);
    canvas.rotate(rightArmAngle);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: const Offset(0, 0), width: radius * 0.26, height: radius * 0.42),
        const Radius.circular(14),
      ),
      armPaint,
    );
    canvas.restore();
  }

  void _drawEars(Canvas canvas, double radius) {
    final earPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppColors.petBodyDark, AppColors.petBody],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: radius));

    // Left ear
    final leftEar = Path()
      ..moveTo(-radius * 0.72, -radius * 0.35)
      ..quadraticBezierTo(-radius * 0.98, -radius * 0.98, -radius * 0.32, -radius * 0.76)
      ..close();
    canvas.drawPath(leftEar, earPaint);

    // Right ear
    final rightEar = Path()
      ..moveTo(radius * 0.72, -radius * 0.35)
      ..quadraticBezierTo(radius * 0.98, -radius * 0.98, radius * 0.32, -radius * 0.76)
      ..close();
    canvas.drawPath(rightEar, earPaint);

    // Inner pink ears
    final innerEarPaint = Paint()..color = AppColors.petBlush.withValues(alpha: 0.65);
    final innerLeftEar = Path()
      ..moveTo(-radius * 0.66, -radius * 0.42)
      ..quadraticBezierTo(-radius * 0.86, -radius * 0.86, -radius * 0.38, -radius * 0.7)
      ..close();
    canvas.drawPath(innerLeftEar, innerEarPaint);

    final innerRightEar = Path()
      ..moveTo(radius * 0.66, -radius * 0.42)
      ..quadraticBezierTo(radius * 0.86, -radius * 0.86, radius * 0.38, -radius * 0.7)
      ..close();
    canvas.drawPath(innerRightEar, innerEarPaint);
  }

  void _drawBody(Canvas canvas, double radius) {
    final breathScale = 1.0 + (sin(breathingProgress * 2 * pi) * 0.025);
    final bodyRect = Rect.fromCenter(
      center: Offset(0, radius * 0.05),
      width: radius * 1.95 * breathScale,
      height: radius * 1.88 * breathScale,
    );

    // Main Body with 3-stop rich gradient
    final bodyPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.25, -0.35),
        radius: 1.15,
        colors: [
          AppColors.petBodyLight,
          AppColors.petBody,
          AppColors.petBodyDark,
        ],
      ).createShader(bodyRect);

    canvas.drawRRect(
      RRect.fromRectAndRadius(bodyRect, Radius.circular(radius * 0.92)),
      bodyPaint,
    );

    // Top Gloss Highlight
    final highlightPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.center,
        colors: [
          Colors.white.withValues(alpha: 0.40),
          Colors.white.withValues(alpha: 0.0),
        ],
      ).createShader(bodyRect);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(0, -radius * 0.42),
          width: radius * 1.45,
          height: radius * 0.7,
        ),
        Radius.circular(radius * 0.45),
      ),
      highlightPaint,
    );

    // Creamy Soft Belly
    final bellyPaint = Paint()..color = Colors.white.withValues(alpha: 0.24);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(0, radius * 0.38),
        width: radius * 1.15,
        height: radius * 0.85,
      ),
      bellyPaint,
    );
  }

  void _drawBlush(Canvas canvas, double radius) {
    final blushPaint = Paint()
      ..color = AppColors.petBlush.withValues(alpha: blushIntensity.clamp(0.0, 1.0))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawOval(
      Rect.fromCenter(center: Offset(-radius * 0.55, radius * 0.14), width: 36, height: 20),
      blushPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(radius * 0.55, radius * 0.14), width: 36, height: 20),
      blushPaint,
    );
  }

  void _drawEyebrows(Canvas canvas, double radius) {
    final browPaint = Paint()
      ..color = const Color(0xFF263238)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round;

    final eyeCenterY = -radius * 0.12;

    // Left eyebrow
    canvas.save();
    canvas.translate(-radius * 0.35, eyeCenterY - 26 + leftEyebrowOffsetY);
    canvas.rotate(leftEyebrowAngle);
    final leftBrow = Path()
      ..moveTo(-16, 2)
      ..quadraticBezierTo(0, -3, 16, 2);
    canvas.drawPath(leftBrow, browPaint);
    canvas.restore();

    // Right eyebrow
    canvas.save();
    canvas.translate(radius * 0.35, eyeCenterY - 26 + rightEyebrowOffsetY);
    canvas.rotate(rightEyebrowAngle);
    final rightBrow = Path()
      ..moveTo(-16, 2)
      ..quadraticBezierTo(0, -3, 16, 2);
    canvas.drawPath(rightBrow, browPaint);
    canvas.restore();
  }

  void _drawEyes(Canvas canvas, double radius) {
    final leftCenter = Offset(-radius * 0.35, -radius * 0.08);
    final rightCenter = Offset(radius * 0.35, -radius * 0.08);
    final eyeRadius = radius * 0.27;

    _drawSingleEye(canvas, leftCenter, eyeRadius, isLeft: true);
    _drawSingleEye(canvas, rightCenter, eyeRadius, isLeft: false);
  }

  void _drawSingleEye(Canvas canvas, Offset eyeCenter, double eyeRadius, {required bool isLeft}) {
    // 1. Sleeping State: Curved sleepy crescent arcs
    if (eyeOpenness <= 0.05 || mood == PetMood.sleeping || mood == PetMood.goodNight) {
      final sleepEyePaint = Paint()
        ..color = const Color(0xFF1E293B)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.0
        ..strokeCap = StrokeCap.round;

      final arcPath = Path()
        ..moveTo(eyeCenter.dx - eyeRadius * 0.7, eyeCenter.dy + 4)
        ..quadraticBezierTo(
          eyeCenter.dx,
          eyeCenter.dy + 12,
          eyeCenter.dx + eyeRadius * 0.7,
          eyeCenter.dy + 4,
        );
      canvas.drawPath(arcPath, sleepEyePaint);
      return;
    }

    // 2. Love State: Glowing pink heart eyes
    if (mood == PetMood.love) {
      _drawHeart(canvas, eyeCenter, eyeRadius * 0.9, const Color(0xFFFF4081));
      return;
    }

    // 3. Excited / Playful State: Sparkly star pupils
    final isExcited = mood == PetMood.excited || mood == PetMood.playful;

    // Normal Sclera (White of the eye)
    final eyeHeight = eyeRadius * 1.30 * eyeOpenness;
    final eyeRect = Rect.fromCenter(
      center: eyeCenter,
      width: eyeRadius * 1.15,
      height: eyeHeight,
    );
    final scleraPaint = Paint()..color = AppColors.petEyeWhite;
    canvas.drawOval(eyeRect, scleraPaint);

    // Clip to eye socket for pupils & highlights
    canvas.save();
    canvas.clipRRect(RRect.fromRectAndRadius(eyeRect, Radius.circular(eyeRadius)));

    final pupilCenter = Offset(
      eyeCenter.dx + (pupilOffsetX * eyeRadius * 0.38),
      eyeCenter.dy + (pupilOffsetY * eyeRadius * 0.38),
    );

    if (isExcited) {
      final starPaint = Paint()..color = AppColors.petPupil;
      _drawStar(canvas, pupilCenter, eyeRadius * 0.65, starPaint);
    } else {
      // Deep Iris & Pupil
      final pupilPaint = Paint()..color = AppColors.petPupil;
      canvas.drawCircle(pupilCenter, eyeRadius * 0.66, pupilPaint);
    }

    // Dual Specular Highlights for lively reflection
    final highlightPaint = Paint()..color = Colors.white;
    canvas.drawCircle(
      Offset(pupilCenter.dx - eyeRadius * 0.22, pupilCenter.dy - eyeRadius * 0.22),
      eyeRadius * 0.24,
      highlightPaint,
    );
    canvas.drawCircle(
      Offset(pupilCenter.dx + eyeRadius * 0.18, pupilCenter.dy + eyeRadius * 0.18),
      eyeRadius * 0.12,
      highlightPaint,
    );

    canvas.restore();
  }

  void _drawNose(Canvas canvas, double radius) {
    final nosePaint = Paint()..color = const Color(0xFF243342);
    final nosePath = Path()
      ..moveTo(0, radius * 0.05)
      ..quadraticBezierTo(-4.5, radius * 0.11, 0, radius * 0.14)
      ..quadraticBezierTo(4.5, radius * 0.11, 0, radius * 0.05);
    canvas.drawPath(nosePath, nosePaint);
  }

  void _drawMouth(Canvas canvas, double radius) {
    final mouthCenter = Offset(0, radius * 0.24);
    final mouthWidth = radius * 0.28;

    final mouthPaint = Paint()
      ..color = const Color(0xFF1E293B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.6
      ..strokeCap = StrokeCap.round;

    if (mouthOpenness > 0.2) {
      // Open mouth (Talking, Laughing, Surprised, Waking yawn)
      final mouthRect = Rect.fromCenter(
        center: Offset(mouthCenter.dx, mouthCenter.dy + 4),
        width: mouthWidth * (0.8 + mouthOpenness * 0.4),
        height: mouthWidth * mouthOpenness,
      );

      final openMouthBg = Paint()..color = const Color(0xFF261828);
      canvas.drawOval(mouthRect, openMouthBg);

      // Pink Tongue
      canvas.save();
      canvas.clipRRect(RRect.fromRectAndRadius(mouthRect, const Radius.circular(10)));
      final tonguePaint = Paint()..color = const Color(0xFFFF6B8B);
      canvas.drawCircle(Offset(mouthCenter.dx, mouthCenter.dy + 12), mouthWidth * 0.45, tonguePaint);
      canvas.restore();

      // Border outline
      canvas.drawOval(mouthRect, mouthPaint);
    } else {
      // Closed expressive curve
      final mouthPath = Path();
      if (mouthCurve > 0.2) {
        // Big smile
        mouthPath.moveTo(mouthCenter.dx - mouthWidth * 0.65, mouthCenter.dy - 1);
        mouthPath.quadraticBezierTo(
          mouthCenter.dx,
          mouthCenter.dy + (mouthCurve * 15),
          mouthCenter.dx + mouthWidth * 0.65,
          mouthCenter.dy - 1,
        );
      } else if (mouthCurve < -0.2) {
        // Sad / concerned frown
        mouthPath.moveTo(mouthCenter.dx - mouthWidth * 0.55, mouthCenter.dy + 8);
        mouthPath.quadraticBezierTo(
          mouthCenter.dx,
          mouthCenter.dy - 4,
          mouthCenter.dx + mouthWidth * 0.55,
          mouthCenter.dy + 8,
        );
      } else {
        // Cute neutral / curious line
        mouthPath.moveTo(mouthCenter.dx - mouthWidth * 0.4, mouthCenter.dy);
        mouthPath.lineTo(mouthCenter.dx + mouthWidth * 0.4, mouthCenter.dy);
      }
      canvas.drawPath(mouthPath, mouthPaint);
    }
  }

  void _drawHeadphones(Canvas canvas, double radius) {
    final bandPaint = Paint()
      ..color = const Color(0xFF1E293B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7.0
      ..strokeCap = StrokeCap.round;

    final bandPath = Path()
      ..moveTo(-radius * 0.92, -radius * 0.1)
      ..cubicTo(
        -radius * 0.92, -radius * 1.35,
        radius * 0.92, -radius * 1.35,
        radius * 0.92, -radius * 0.1,
      );
    canvas.drawPath(bandPath, bandPaint);

    final cupPaint = Paint()..color = AppColors.secondary;
    final cupBorder = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final leftCup = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(-radius * 0.94, -radius * 0.05), width: 24, height: 48),
      const Radius.circular(9),
    );
    final rightCup = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(radius * 0.94, -radius * 0.05), width: 24, height: 48),
      const Radius.circular(9),
    );

    canvas.drawRRect(leftCup, cupPaint);
    canvas.drawRRect(leftCup, cupBorder);
    canvas.drawRRect(rightCup, cupPaint);
    canvas.drawRRect(rightCup, cupBorder);
  }

  void _drawStateEffects(Canvas canvas, double radius) {
    if (showZzz || mood == PetMood.sleeping) {
      _drawZzzText(canvas, radius);
    }
    if (showSparkles || mood == PetMood.happy || mood == PetMood.charging || mood == PetMood.dancing) {
      _drawSparkleParticles(canvas, radius);
    }
    if (showHearts || mood == PetMood.love) {
      _drawHeartParticles(canvas, radius);
    }
    if (showSweatDrop || mood == PetMood.lowBattery || mood == PetMood.confused) {
      _drawSweatDrop(canvas, radius);
    }
    if (showLightning || mood == PetMood.charging) {
      _drawLightning(canvas, radius);
    }
    if (showQuestionMark || mood == PetMood.curious || mood == PetMood.thinking) {
      _drawThoughtSymbol(canvas, radius);
    }
    if (showSun || mood == PetMood.goodMorning) {
      _drawSunSymbol(canvas, radius);
    }
    if (showMoon || mood == PetMood.goodNight) {
      _drawMoonSymbol(canvas, radius);
    }
  }

  void _drawZzzText(Canvas canvas, double radius) {
    final floatY = sin(breathingProgress * 2 * pi) * 6;
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'Zzz...',
        style: TextStyle(
          color: Color(0xFF93C5FD),
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, Offset(radius * 0.55, -radius * 0.95 + floatY));
  }

  void _drawSparkleParticles(Canvas canvas, double radius) {
    final sparklePaint = Paint()..color = const Color(0xFFFDE047);
    _drawStar(canvas, Offset(radius * 0.85, -radius * 0.65), 8, sparklePaint);
    _drawStar(canvas, Offset(-radius * 0.88, -radius * 0.55), 10, sparklePaint);
    _drawStar(canvas, Offset(radius * 0.70, radius * 0.55), 6, sparklePaint);
  }

  void _drawHeartParticles(Canvas canvas, double radius) {
    _drawHeart(canvas, Offset(radius * 0.75, -radius * 0.75), 16, const Color(0xFFFF4081));
    _drawHeart(canvas, Offset(-radius * 0.8, -radius * 0.65), 12, const Color(0xFFFF80AB));
  }

  void _drawSweatDrop(Canvas canvas, double radius) {
    final sweatPaint = Paint()..color = const Color(0xFF60A5FA);
    final dropPath = Path()
      ..moveTo(radius * 0.82, -radius * 0.45)
      ..quadraticBezierTo(radius * 0.90, -radius * 0.35, radius * 0.82, -radius * 0.25)
      ..quadraticBezierTo(radius * 0.74, -radius * 0.35, radius * 0.82, -radius * 0.45)
      ..close();
    canvas.drawPath(dropPath, sweatPaint);
  }

  void _drawLightning(Canvas canvas, double radius) {
    final boltPaint = Paint()
      ..color = const Color(0xFFFACC15)
      ..style = PaintingStyle.fill;
    final boltPath = Path()
      ..moveTo(-radius * 0.85, -radius * 0.8)
      ..lineTo(-radius * 0.72, -radius * 0.6)
      ..lineTo(-radius * 0.78, -radius * 0.6)
      ..lineTo(-radius * 0.65, -radius * 0.35)
      ..lineTo(-radius * 0.76, -radius * 0.55)
      ..lineTo(-radius * 0.70, -radius * 0.55)
      ..close();
    canvas.drawPath(boltPath, boltPaint);
  }

  void _drawThoughtSymbol(Canvas canvas, double radius) {
    final isCurious = mood == PetMood.curious;
    final text = isCurious ? '?' : '💭';
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: isCurious ? const Color(0xFFFBBF24) : Colors.white70,
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, Offset(radius * 0.68, -radius * 0.92));
  }

  void _drawSunSymbol(Canvas canvas, double radius) {
    final sunCenter = Offset(-radius * 0.85, -radius * 0.85);
    final sunPaint = Paint()..color = const Color(0xFFFBBF24);
    canvas.drawCircle(sunCenter, 14, sunPaint);
  }

  void _drawMoonSymbol(Canvas canvas, double radius) {
    final moonCenter = Offset(radius * 0.85, -radius * 0.85);
    final moonPaint = Paint()..color = const Color(0xFFE2E8F0);
    canvas.drawCircle(moonCenter, 14, moonPaint);
    final cutoutPaint = Paint()..color = AppColors.darkBg;
    canvas.drawCircle(Offset(moonCenter.dx - 6, moonCenter.dy - 4), 12, cutoutPaint);
  }

  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path()
      ..moveTo(center.dx, center.dy - size)
      ..quadraticBezierTo(center.dx, center.dy, center.dx + size, center.dy)
      ..quadraticBezierTo(center.dx, center.dy, center.dx, center.dy + size)
      ..quadraticBezierTo(center.dx, center.dy, center.dx - size, center.dy)
      ..quadraticBezierTo(center.dx, center.dy, center.dx, center.dy - size)
      ..close();
    canvas.drawPath(path, paint);
  }

  void _drawHeart(Canvas canvas, Offset center, double size, Color color) {
    final heartPaint = Paint()..color = color;
    final path = Path();
    path.moveTo(center.dx, center.dy + size * 0.35);
    path.cubicTo(
      center.dx - size * 0.7, center.dy - size * 0.4,
      center.dx - size * 0.7, center.dy - size * 0.9,
      center.dx, center.dy - size * 0.5,
    );
    path.cubicTo(
      center.dx + size * 0.7, center.dy - size * 0.9,
      center.dx + size * 0.7, center.dy - size * 0.4,
      center.dx, center.dy + size * 0.35,
    );
    path.close();
    canvas.drawPath(path, heartPaint);
  }

  @override
  bool shouldRepaint(covariant PetCharacterPainter oldDelegate) {
    return oldDelegate.mood != mood ||
        oldDelegate.eyeOpenness != eyeOpenness ||
        oldDelegate.pupilOffsetX != pupilOffsetX ||
        oldDelegate.pupilOffsetY != pupilOffsetY ||
        oldDelegate.mouthCurve != mouthCurve ||
        oldDelegate.mouthOpenness != mouthOpenness ||
        oldDelegate.bodyBounce != bodyBounce ||
        oldDelegate.blushIntensity != blushIntensity ||
        oldDelegate.headTilt != headTilt ||
        oldDelegate.leftEyebrowAngle != leftEyebrowAngle ||
        oldDelegate.rightEyebrowAngle != rightEyebrowAngle ||
        oldDelegate.leftEyebrowOffsetY != leftEyebrowOffsetY ||
        oldDelegate.rightEyebrowOffsetY != rightEyebrowOffsetY ||
        oldDelegate.leftArmAngle != leftArmAngle ||
        oldDelegate.rightArmAngle != rightArmAngle ||
        oldDelegate.showHeadphones != showHeadphones ||
        oldDelegate.showZzz != showZzz ||
        oldDelegate.showSparkles != showSparkles ||
        oldDelegate.showHearts != showHearts ||
        oldDelegate.showSweatDrop != showSweatDrop ||
        oldDelegate.showLightning != showLightning ||
        oldDelegate.showSun != showSun ||
        oldDelegate.showMoon != showMoon ||
        oldDelegate.showQuestionMark != showQuestionMark ||
        oldDelegate.breathingProgress != breathingProgress;
  }
}
