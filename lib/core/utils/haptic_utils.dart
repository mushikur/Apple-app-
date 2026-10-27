import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Utility for providing haptic feedback with platform and setting awareness.
class HapticUtils {
  HapticUtils._();

  static bool enabled = true;

  static Future<void> lightTap() async {
    if (!enabled || kIsWeb) return;
    try {
      await HapticFeedback.lightImpact();
    } catch (_) {}
  }

  static Future<void> mediumTap() async {
    if (!enabled || kIsWeb) return;
    try {
      await HapticFeedback.mediumImpact();
    } catch (_) {}
  }

  static Future<void> heavyTap() async {
    if (!enabled || kIsWeb) return;
    try {
      await HapticFeedback.heavyImpact();
    } catch (_) {}
  }

  static Future<void> selectionTap() async {
    if (!enabled || kIsWeb) return;
    try {
      await HapticFeedback.selectionClick();
    } catch (_) {}
  }
}
