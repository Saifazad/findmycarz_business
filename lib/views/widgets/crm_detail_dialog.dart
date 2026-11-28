import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class CrmDetailRow {
  final IconData icon;
  final String label;
  final String value;
  final Widget? customValue;

  const CrmDetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.customValue,
  });
}

/// Shows a clean, icon-aligned detail dialog matching the Vehicle Logs design.
void showCrmDetailDialog({
  required BuildContext context,
  required bool isDarkMode,
  required IconData headerIcon,
  required String title,
  required String badgeText,
  required IconData summaryIcon,
  required String summaryTitle,
  required String summarySubtitle,
  required List<CrmDetailRow> rows,
}) {
  showDialog<void>(
    context: context,
    builder: (ctx) => Dialog(
      backgroundColor: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 12, 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      headerIcon,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                        if (badgeText.trim().isNotEmpty)
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              badgeText,
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 20,
                      color: isDarkMode ? Colors.white60 : Colors.black45,
                    ),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: isDarkMode
                  ? const Color(0xFF334155)
                  : const Color(0xFFF1F5F9),
            ),

            // Body Content
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
              child: Column(
                children: [
                  // Summary Card
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? const Color(0xFF0F172A)
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDarkMode
                            ? const Color(0xFF334155)
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            summaryIcon,
                            size: 18,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                summaryTitle,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: isDarkMode
                                      ? Colors.white
                                      : const Color(0xFF0F172A),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (summarySubtitle.trim().isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text(
                                  summarySubtitle,
                                  style: GoogleFonts.poppins(
                                    fontSize: 11.5,
                                    color: isDarkMode
                                        ? Colors.white60
                                        : const Color(0xFF64748B),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Detail Rows
                  for (final row in rows)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? const Color(0xFF0F172A)
                                  : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              row.icon,
                              size: 16,
                              color: isDarkMode
                                  ? Colors.white60
                                  : const Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  row.label,
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: isDarkMode
                                        ? Colors.white54
                                        : const Color(0xFF64748B),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                row.customValue ??
                                    Text(
                                      row.value.trim().isEmpty
                                          ? '--'
                                          : row.value,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w600,
                                        color: isDarkMode
                                            ? Colors.white
                                            : const Color(0xFF0F172A),
                                      ),
                                    ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Footer Close Button
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
              child: SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(
                    "Close",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 13.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
