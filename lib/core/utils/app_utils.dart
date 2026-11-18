// // lib/core/utils/app_utils.dart
//
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../constants/app_constants.dart';
//
// /// Stateless utility methods used across the app.
// class AppUtils {
//   AppUtils._();
//
//   // ─── Number Formatting ────────────────────────────────────────────────────
//
//   /// Formats price to Indian number system.
//   /// 1500000 → "₹15.00 Lakh"  |  2500000 → "₹25.00 Lakh"  |  10000000 → "₹1.00 Cr"
//   static String formatPrice(double price) {
//     if (price >= 10000000) {
//       final crore = price / 10000000;
//       return '₹${crore.toStringAsFixed(2)} Cr';
//     } else if (price >= 100000) {
//       final lakh = price / 100000;
//       return '₹${lakh.toStringAsFixed(2)} Lakh';
//     } else if (price >= 1000) {
//       final thousand = price / 1000;
//       return '₹${thousand.toStringAsFixed(1)}K';
//     }
//     return '₹${NumberFormat('#,##,###').format(price)}';
//   }
//
//   /// Formats mileage with comma separator.
//   /// 45000 → "45,000 km"
//   static String formatMileage(int km) {
//     return '${NumberFormat('#,##,###').format(km)} km';
//   }
//
//   // ─── Date Formatting ──────────────────────────────────────────────────────
//
//   /// Returns how long ago a listing was posted.
//   static String timeAgo(DateTime date) {
//     final now = DateTime.now();
//     final diff = now.difference(date);
//     if (diff.inDays > 30) return '${(diff.inDays / 30).floor()} months ago';
//     if (diff.inDays > 0) return '${diff.inDays} days ago';
//     if (diff.inHours > 0) return '${diff.inHours} hours ago';
//     return 'Just now';
//   }
//
//   // ─── WhatsApp ─────────────────────────────────────────────────────────────
//
//   /// Opens WhatsApp with a pre-filled inquiry message.
//   static Future<void> openWhatsAppInquiry({
//     required BuildContext context,
//     required String carName,
//     required String carId,
//     String? phoneNumber,
//   }) async {
//     final number = phoneNumber ?? AppConstants.whatsappNumber;
//     final message = Uri.encodeComponent(
//       'Hi! I am interested in the *$carName* (ID: #$carId) listed on Find My Carz. '
//           'Could you please share more details?\n\nApp: ${AppConstants.appName}',
//     );
//     final uri = Uri.parse(
//       '${AppConstants.whatsappBaseUrl}$number?text=$message',
//     );
//
//     try {
//       if (await canLaunchUrl(uri)) {
//         await launchUrl(uri, mode: LaunchMode.externalApplication);
//       } else {
//         if (context.mounted) {
//           _showSnackBar(
//             context,
//             'WhatsApp is not installed on this device.',
//             isError: true,
//           );
//         }
//       }
//     } catch (e) {
//       if (context.mounted) {
//         _showSnackBar(context, 'Could not open WhatsApp.', isError: true);
//       }
//     }
//   }
//
//   /// Opens a URL in the default browser / external app.
//   static Future<void> launchExternalUrl(
//       BuildContext context,
//       String url,
//       ) async {
//     final uri = Uri.parse(url);
//     try {
//       if (await canLaunchUrl(uri)) {
//         await launchUrl(uri, mode: LaunchMode.externalApplication);
//       } else {
//         if (context.mounted) {
//           _showSnackBar(context, 'Could not open link.', isError: true);
//         }
//       }
//     } catch (_) {
//       if (context.mounted) {
//         _showSnackBar(context, 'Could not open link.', isError: true);
//       }
//     }
//   }
//
//   // ─── UI Helpers ───────────────────────────────────────────────────────────
//
//   static void _showSnackBar(
//       BuildContext context,
//       String message, {
//         bool isError = false,
//       }) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: isError ? Colors.red[700] : Colors.green[700],
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       ),
//     );
//   }
//
//   /// Returns a colour pair [background, text] for a given fuel type badge.
//   static List<Color> fuelBadgeColors(String fuelType) {
//     switch (fuelType.toLowerCase()) {
//       case 'petrol':
//         return [const Color(0xFFEBF8FF), const Color(0xFF2B6CB0)];
//       case 'diesel':
//         return [const Color(0xFFFFFAF0), const Color(0xFF744210)];
//       case 'cng':
//         return [const Color(0xFFF0FFF4), const Color(0xFF276749)];
//       case 'electric':
//         return [const Color(0xFFFAF5FF), const Color(0xFF553C9A)];
//       case 'hybrid':
//         return [const Color(0xFFFFF5F5), const Color(0xFF9B2C2C)];
//       default:
//         return [const Color(0xFFF7FAFC), const Color(0xFF4A5568)];
//     }
//   }
//
//   /// Returns appropriate fuel icon emoji.
//   static String fuelIcon(String fuelType) {
//     switch (fuelType.toLowerCase()) {
//       case 'petrol':
//         return '⛽';
//       case 'diesel':
//         return '🛢️';
//       case 'cng':
//         return '💨';
//       case 'electric':
//         return '⚡';
//       case 'hybrid':
//         return '🔋';
//       default:
//         return '⛽';
//     }
//   }
//
//   // ─── Responsive Helpers ───────────────────────────────────────────────────
//
//   /// Returns true if running on a tablet (width ≥ 600dp).
//   static bool isTablet(BuildContext context) =>
//       MediaQuery.of(context).size.width >= 600;
//
//   /// Returns safe horizontal padding based on screen width.
//   static double horizontalPadding(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     if (width >= 1200) return 80;
//     if (width >= 900) return 48;
//     if (width >= 600) return 32;
//     return 16;
//   }
// }