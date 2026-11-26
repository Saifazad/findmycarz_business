import 'dart:ui';
import 'package:flutter/material.dart';

class AppColors {
  // ─── Central Brand & Theme Colors ──────────────────────────────────────────
  /// Royal Blue - Primary brand color
  static const Color primary = Color(0xFF0B4FA8);

  /// Deep Royal Navy - Primary Dark
  static const Color primaryDark = Color(0xFF003C8F);

  /// Add Blog / Create Loan Lead Navy Gradient & Form Surfaces
  static const Color navyStart = Color(0xFF0B4DA2);
  static const Color navyEnd = Color(0xFF003B8E);
  static const Color formFieldBg = Color(0xFFF5F7FB);
  static const Color formFieldBorder = Color(0xFFD9E0EC);
  static const Color formPlaceholder = Color(0xFF9CA3AF);
  static const Color formLabel = Color(0xFF111827);

  /// Dashboard Hero Navy Gradient & Neutral Surfaces
  static const Color heroNavyStart = Color(0xFF0B3C8C);
  static const Color heroNavyEnd = Color(0xFF082A66);
  static const Color sectionHeading = Color(0xFF374151);
  static const Color cardBorder = Color(0xFFE5E7EB);
  static const Color iconSurface = Color(0xFFEEF2F7);
  static const Color neutralText = Color(0xFF4B5563);
  static const Color neutralMuted = Color(0xFF6B7280);
  static const Color neutralBadgeBg = Color(0xFFF3F4F6);

  /// Car Management & Pipeline Card Accent Palette
  static const Color paletteBlue = Color(0xFF3B82F6);
  static const Color paletteGreen = Color(0xFF10B981);
  static const Color paletteOrange = Color(0xFFF97316);
  static const Color paletteCyan = Color(0xFF06B6D4);
  static const Color palettePurple = Color(0xFF8B5CF6);
  static const Color paletteRed = Color(0xFFEF4444);

  /// Success Green
  static const Color success = Color(0xFF16A34A);

  /// Danger Red
  static const Color danger = Color(0xFFE53935);

  /// Light Surface Background
  static const Color background = Color(0xFFF5F8FC);

  /// Dark Slate Navy Text
  static const Color text = Color(0xFF1B2B40);

  // ─── Status Chip Tints ──────────────────────────────────────────────────────
  /// Public: Background #E3EEFB, Text #0B4FA8
  static const Color chipPublicBg = Color(0xFFE3EEFB);
  static const Color chipPublicText = Color(0xFF0B4FA8);

  /// Available: Background #E3F6EA, Text #166534
  static const Color chipAvailableBg = Color(0xFFE3F6EA);
  static const Color chipAvailableText = Color(0xFF166534);

  /// Active: Background #E3F6EA, Text #166534
  static const Color chipActiveBg = Color(0xFFE3F6EA);
  static const Color chipActiveText = Color(0xFF166534);

  /// Inactive: Background #FDE8E8, Text #B91C1C
  static const Color chipInactiveBg = Color(0xFFFDE8E8);
  static const Color chipInactiveText = Color(0xFFB91C1C);

  /// Published: Background #DDF3F0, Text #0F766E
  static const Color chipPublishedBg = Color(0xFFDDF3F0);
  static const Color chipPublishedText = Color(0xFF0F766E);

  /// Used Car Loan: Background #E3EEFB, Text #0B4FA8
  static const Color chipUsedCarLoanBg = Color(0xFFE3EEFB);
  static const Color chipUsedCarLoanText = Color(0xFF0B4FA8);

  /// New Car Loan: Background #DDF3F0, Text #0F766E
  static const Color chipNewCarLoanBg = Color(0xFFDDF3F0);
  static const Color chipNewCarLoanText = Color(0xFF0F766E);

  // ─── Stepper & Form Colors ──────────────────────────────────────────────────
  /// Inactive Step Circle Background #EEF3FA
  static const Color stepInactiveBg = Color(0xFFEEF3FA);

  /// Inactive Step Circle Border #D5DEEB
  static const Color stepInactiveBorder = Color(0xFFD5DEEB);

  /// Inactive Step Text & Input Icon #6B7C93
  static const Color stepInactiveText = Color(0xFF6B7C93);
  static const Color inputIcon = Color(0xFF6B7C93);

  // ─── Existing Brand Palette Preserved ───────────────────────────────────────
  static const Color secondary = Color(0xFF1A2B44); // light blue
  static const Color accent = Color(0xFFF57C00); // orange
  static const Color bgColor = Color(0xFFF8F9FB); // light gray

  static const List<Color> primaryGredient = [
    Color(0xFF1A334E),
    Color(0xFF2A4E78),
  ];

  // Text color
  static const Color textGray = Color(0xFF757575);
  static const Color textBlack = Color(0xFF011627);
  static const Color textDark = Color(0xFF212121);

  // Text size
  static const FontWeight sm = FontWeight(21);
}
