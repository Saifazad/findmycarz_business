// // lib/core/constants/app_colors.dart
//
// import 'package:flutter/material.dart';
//
// /// All brand colors in one place.
// /// Always reference these instead of raw hex values.
// class AppColors {
//   AppColors._();
//
//   // ─── Brand Palette ────────────────────────────────────────────────────────
//   /// Oxford Blue – Primary brand color
//   static const Color primary = Color(0xFF002147);
//
//   /// Coral Orange – Accent / CTA color
//   static const Color accent = Color(0xFFFF704D);
//
//   /// Pure white – Main background
//   static const Color background = Color(0xFFFFFFFF);
//
//   // ─── Primary Shades ───────────────────────────────────────────────────────
//   static const Color primaryLight = Color(0xFF003366);
//   static const Color primaryDark = Color(0xFF001530);
//   static const Color primarySurface = Color(0xFFE8EEF5); // 5% primary tint
//
//   // ─── Accent Shades ────────────────────────────────────────────────────────
//   static const Color accentLight = Color(0xFFFF9070);
//   static const Color accentDark = Color(0xFFE5532A);
//   static const Color accentSurface = Color(0xFFFFF0EC); // 5% accent tint
//
//   // ─── Neutrals ─────────────────────────────────────────────────────────────
//   static const Color textPrimary = Color(0xFF0D1B2A);
//   static const Color textSecondary = Color(0xFF4A5568);
//   static const Color textHint = Color(0xFFA0AEC0);
//   static const Color textInverse = Color(0xFFFFFFFF);
//
//   // ─── Surface & Cards ──────────────────────────────────────────────────────
//   static const Color surface = Color(0xFFFFFFFF);
//   static const Color surfaceVariant = Color(0xFFF7F9FC);
//   static const Color cardBackground = Color(0xFFFFFFFF);
//   static const Color shimmerBase = Color(0xFFE8ECF0);
//   static const Color shimmerHighlight = Color(0xFFF5F7FA);
//
//   // ─── Borders & Dividers ───────────────────────────────────────────────────
//   static const Color border = Color(0xFFE2E8F0);
//   static const Color divider = Color(0xFFEDF2F7);
//
//   // ─── Status Colors ────────────────────────────────────────────────────────
//   static const Color success = Color(0xFF38A169);
//   static const Color warning = Color(0xFFD69E2E);
//   static const Color error = Color(0xFFE53E3E);
//   static const Color info = Color(0xFF3182CE);
//
//   // ─── Fuel Type Badge Colors ───────────────────────────────────────────────
//   static const Color petrolBadge = Color(0xFFEBF8FF);
//   static const Color petrolBadgeText = Color(0xFF2B6CB0);
//   static const Color dieselBadge = Color(0xFFFFFAF0);
//   static const Color dieselBadgeText = Color(0xFF744210);
//   static const Color cngBadge = Color(0xFFF0FFF4);
//   static const Color cngBadgeText = Color(0xFF276749);
//   static const Color electricBadge = Color(0xFFFAF5FF);
//   static const Color electricBadgeText = Color(0xFF553C9A);
//
//   // ─── Gradients ────────────────────────────────────────────────────────────
//   static const LinearGradient primaryGradient = LinearGradient(
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//     colors: [primary, primaryLight],
//   );
//
//   static const LinearGradient accentGradient = LinearGradient(
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//     colors: [accent, accentLight],
//   );
//
//   static const LinearGradient sellBannerGradient = LinearGradient(
//     begin: Alignment.centerLeft,
//     end: Alignment.centerRight,
//     colors: [Color(0xFF002147), Color(0xFF003A7A)],
//   );
//
//   static const LinearGradient loanBannerGradient = LinearGradient(
//     begin: Alignment.centerLeft,
//     end: Alignment.centerRight,
//     colors: [Color(0xFFFF704D), Color(0xFFFF9070)],
//   );
//
//   // ─── Shadow ───────────────────────────────────────────────────────────────
//   static List<BoxShadow> cardShadow = [
//     BoxShadow(
//       color: const Color(0xFF002147).withOpacity(0.08),
//       blurRadius: 16,
//       offset: const Offset(0, 4),
//     ),
//   ];
//
//   static List<BoxShadow> elevatedShadow = [
//     BoxShadow(
//       color: const Color(0xFF002147).withOpacity(0.12),
//       blurRadius: 24,
//       offset: const Offset(0, 8),
//     ),
//   ];
// }