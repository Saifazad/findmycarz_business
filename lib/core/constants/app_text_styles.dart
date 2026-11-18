// // lib/core/constants/app_text_styles.dart
//
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'app_colors.dart';
//
// /// Centralised typography system.
// /// Uses Google Fonts: Sora (display/headings) + DM Sans (body/UI).
// class AppTextStyles {
//   AppTextStyles._();
//
//   // ─── Display / Hero ───────────────────────────────────────────────────────
//   static TextStyle get displayLarge => GoogleFonts.sora(
//     fontSize: 32,
//     fontWeight: FontWeight.w700,
//     color: AppColors.textPrimary,
//     letterSpacing: -0.5,
//     height: 1.2,
//   );
//
//   static TextStyle get displayMedium => GoogleFonts.sora(
//     fontSize: 26,
//     fontWeight: FontWeight.w700,
//     color: AppColors.textPrimary,
//     letterSpacing: -0.3,
//     height: 1.25,
//   );
//
//   // ─── Headings ─────────────────────────────────────────────────────────────
//   static TextStyle get heading1 => GoogleFonts.sora(
//     fontSize: 22,
//     fontWeight: FontWeight.w700,
//     color: AppColors.textPrimary,
//     letterSpacing: -0.2,
//     height: 1.3,
//   );
//
//   static TextStyle get heading2 => GoogleFonts.sora(
//     fontSize: 18,
//     fontWeight: FontWeight.w600,
//     color: AppColors.textPrimary,
//     height: 1.35,
//   );
//
//   static TextStyle get heading3 => GoogleFonts.sora(
//     fontSize: 16,
//     fontWeight: FontWeight.w600,
//     color: AppColors.textPrimary,
//     height: 1.4,
//   );
//
//   // ─── Body ─────────────────────────────────────────────────────────────────
//   static TextStyle get bodyLarge => GoogleFonts.dmSans(
//     fontSize: 16,
//     fontWeight: FontWeight.w400,
//     color: AppColors.textPrimary,
//     height: 1.6,
//   );
//
//   static TextStyle get bodyMedium => GoogleFonts.dmSans(
//     fontSize: 14,
//     fontWeight: FontWeight.w400,
//     color: AppColors.textSecondary,
//     height: 1.5,
//   );
//
//   static TextStyle get bodySmall => GoogleFonts.dmSans(
//     fontSize: 12,
//     fontWeight: FontWeight.w400,
//     color: AppColors.textSecondary,
//     height: 1.5,
//   );
//
//   // ─── Labels & Captions ────────────────────────────────────────────────────
//   static TextStyle get labelLarge => GoogleFonts.dmSans(
//     fontSize: 14,
//     fontWeight: FontWeight.w600,
//     color: AppColors.textPrimary,
//     letterSpacing: 0.1,
//   );
//
//   static TextStyle get labelMedium => GoogleFonts.dmSans(
//     fontSize: 12,
//     fontWeight: FontWeight.w600,
//     color: AppColors.textPrimary,
//     letterSpacing: 0.2,
//   );
//
//   static TextStyle get labelSmall => GoogleFonts.dmSans(
//     fontSize: 10,
//     fontWeight: FontWeight.w500,
//     color: AppColors.textSecondary,
//     letterSpacing: 0.3,
//   );
//
//   static TextStyle get caption => GoogleFonts.dmSans(
//     fontSize: 11,
//     fontWeight: FontWeight.w400,
//     color: AppColors.textHint,
//     height: 1.4,
//   );
//
//   // ─── Special Use Cases ────────────────────────────────────────────────────
//
//   /// Car name on cards – bold, primary color
//   static TextStyle get carName => GoogleFonts.sora(
//     fontSize: 14,
//     fontWeight: FontWeight.w700,
//     color: AppColors.textPrimary,
//     height: 1.3,
//   );
//
//   /// Price tag – accent orange, bold
//   static TextStyle get price => GoogleFonts.sora(
//     fontSize: 16,
//     fontWeight: FontWeight.w700,
//     color: AppColors.accent,
//     letterSpacing: -0.2,
//   );
//
//   static TextStyle get priceLarge => GoogleFonts.sora(
//     fontSize: 22,
//     fontWeight: FontWeight.w700,
//     color: AppColors.accent,
//     letterSpacing: -0.3,
//   );
//
//   /// Spec chip label (Year, km, Fuel)
//   static TextStyle get spec => GoogleFonts.dmSans(
//     fontSize: 11,
//     fontWeight: FontWeight.w500,
//     color: AppColors.textSecondary,
//   );
//
//   /// Navigation bar labels
//   static TextStyle get navLabel => GoogleFonts.dmSans(
//     fontSize: 10,
//     fontWeight: FontWeight.w600,
//     letterSpacing: 0.2,
//   );
//
//   /// Section title ("Popular Brands", "Featured Cars")
//   static TextStyle get sectionTitle => GoogleFonts.sora(
//     fontSize: 17,
//     fontWeight: FontWeight.w700,
//     color: AppColors.textPrimary,
//   );
//
//   /// Hint/placeholder inside TextFields
//   static TextStyle get hint => GoogleFonts.dmSans(
//     fontSize: 14,
//     fontWeight: FontWeight.w400,
//     color: AppColors.textHint,
//   );
//
//   /// Button text
//   static TextStyle get button => GoogleFonts.dmSans(
//     fontSize: 15,
//     fontWeight: FontWeight.w600,
//     letterSpacing: 0.3,
//   );
//
//   /// Inverse text (on dark backgrounds)
//   static TextStyle get inverse => GoogleFonts.dmSans(
//     fontSize: 14,
//     fontWeight: FontWeight.w500,
//     color: AppColors.textInverse,
//   );
// }