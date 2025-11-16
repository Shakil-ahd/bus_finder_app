import 'package:flutter/material.dart';

class AppColors {
  // Text Colors
  static const Color primaryTextLight = Color(0xFF1F2937);
  static const Color secondaryTextLight = Color(0xFF4B5563);
  static const Color placeholderTextLight =
      Color(0xFF9CA3AF);

  static const Color primaryTextDark = Color(0xFFF9FAFB);
  static const Color secondaryTextDark = Color(0xFFE5E7EB);
  static const Color placeholderTextDark =
      Color(0xFF9CA3AF);

  // Background Colors
  static const Color backgroundLight = Color(0xFFF9FAFB);
  static const Color backgroundDark =
      Color(0xFF111827); // Darker background

  // Card Colors
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark =
      Color(0xFF1F2937); // Darker card

  // --- Your Gradient Colors ---
  static const Color gradientPink = Color(0xFFEC4899);
  static const Color gradientPurple = Color(0xFF8B5CF6);
  static const Color gradientRed = Color(0xFFEF4444);

  // Gradients
  static const LinearGradient primaryGradient =
      LinearGradient(
    colors: [gradientPink, gradientPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient primaryGradientReversed =
      LinearGradient(
    colors: [gradientPurple, gradientPink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient =
      LinearGradient(
    colors: [gradientRed, gradientPink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradientLight =
      LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF9FAFB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradientDark =
      LinearGradient(
    colors: [Color(0xFF374151), Color(0xFF1F2937)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
