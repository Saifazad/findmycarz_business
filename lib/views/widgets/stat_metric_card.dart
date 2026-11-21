import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatMetricCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;
  final Color accentColor;
  final Color countColor;
  final String subtitle;
  final String actionText;
  final VoidCallback? onTap;
  final bool isDarkMode;
  final Color? iconColor;
  final Color? iconBgColor;
  final Color? subtitleColor;
  final Color? actionColor;
  final Color? titleColor;

  const StatMetricCard({
    super.key,
    required this.title,
    required this.count,
    required this.icon,
    required this.accentColor,
    required this.countColor,
    required this.subtitle,
    required this.actionText,
    this.onTap,
    this.isDarkMode = false,
    this.iconColor,
    this.iconBgColor,
    this.subtitleColor,
    this.actionColor,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTitleColor = titleColor ??
        (isDarkMode ? Colors.grey.shade200 : const Color(0xFF1E293B));
    final effectiveIconColor = iconColor ?? accentColor;
    final effectiveIconBgColor =
        iconBgColor ?? accentColor.withValues(alpha: isDarkMode ? 0.25 : 0.12);
    final effectiveSubtitleColor = subtitleColor ??
        (isDarkMode ? Colors.grey.shade300 : const Color(0xFF334155));
    final effectiveActionColor = actionColor ??
        (isDarkMode ? Colors.grey.shade300 : const Color(0xFF334155));

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color:
                isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDarkMode ? 0.2 : 0.02),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top Row: Title & Mini Icon Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: effectiveTitleColor,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: effectiveIconBgColor,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Icon(icon, size: 14, color: effectiveIconColor),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Middle: Big Metric Number
            Text(
              count,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: (countColor == Colors.black87 && isDarkMode)
                    ? Colors.white
                    : countColor,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),

            // Bottom: Subtitle & Action Link
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: effectiveSubtitleColor,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      actionText,
                      style: GoogleFonts.poppins(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                        color: effectiveActionColor,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: 11,
                      color: effectiveActionColor,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
