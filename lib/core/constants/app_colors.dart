import 'package:flutter/material.dart';

/// Premium color palette for Samir Pet.
class AppColors {
  AppColors._();

  // === Dark Theme ===
  static const Color darkBg = Color(0xFF0A0E1A);
  static const Color darkSurface = Color(0xFF141929);
  static const Color darkCard = Color(0xFF1C2237);
  static const Color darkBorder = Color(0xFF252B42);

  // === Light Theme ===
  static const Color lightBg = Color(0xFFF5F7FC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFF0F2F8);
  static const Color lightBorder = Color(0xFFE2E6F0);

  // === Accent Colors ===
  static const Color primary = Color(0xFF6C8EFF);
  static const Color primaryLight = Color(0xFF8EAAFF);
  static const Color primaryDark = Color(0xFF4A6CD9);
  static const Color secondary = Color(0xFFB07CFF);
  static const Color accent = Color(0xFFFF7EB3);
  static const Color accentGreen = Color(0xFF6DFFB0);

  // === Pet Colors ===
  static const Color petBodyLight = Color(0xFF9AB7FA);
  static const Color petBody = Color(0xFF7B9EF7);
  static const Color petBodyDark = Color(0xFF5B7FD7);
  static const Color petBlush = Color(0xFFFFB8C6);
  static const Color petEyeWhite = Color(0xFFF8F9FF);
  static const Color petPupil = Color(0xFF2D3436);
  static const Color petHighlight = Color(0xFFFFFFFF);
  static const Color petGlow = Color(0x306C8EFF);

  // === Status Colors ===
  static const Color success = Color(0xFF4ADE80);
  static const Color warning = Color(0xFFFBBF24);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF60A5FA);

  // === Text Colors ===
  static const Color darkTextPrimary = Color(0xFFEEF0F8);
  static const Color darkTextSecondary = Color(0xFF9CA3BF);
  static const Color darkTextTertiary = Color(0xFF636B85);
  static const Color lightTextPrimary = Color(0xFF1A1E2E);
  static const Color lightTextSecondary = Color(0xFF6B7280);
  static const Color lightTextTertiary = Color(0xFF9CA3AF);

  // === Gradients ===
  static const LinearGradient darkBgGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF101522), Color(0xFF050710)],
  );

  static const LinearGradient lightBgGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFF0F4FF), Color(0xFFE8ECF8)],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6C8EFF), Color(0xFFB07CFF)],
  );

  static const RadialGradient petGlowGradient = RadialGradient(
    colors: [Color(0x206C8EFF), Color(0x006C8EFF)],
    radius: 0.8,
  );

  /// Returns glass-morphic surface color based on brightness.
  static Color glassColor(Brightness brightness) {
    return brightness == Brightness.dark
        ? Colors.white.withValues(alpha: 0.06)
        : Colors.white.withValues(alpha: 0.7);
  }

  static Color glassBorder(Brightness brightness) {
    return brightness == Brightness.dark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.white.withValues(alpha: 0.4);
  }
}
