import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/admin_dashboard_model.dart';

class LoanPipelineCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color badgeColor;
  final LoanCategoryStats stats;
  final VoidCallback? onTap;
  final VoidCallback? onViewLoggedIn;
  final VoidCallback? onAllLeads;
  final bool isDarkMode;

  const LoanPipelineCard({
    super.key,
    required this.title,
    required this.icon,
    required this.badgeColor,
    required this.stats,
    this.onTap,
    this.onViewLoggedIn,
    this.onAllLeads,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasActiveLogin = stats.inBankLogin > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDarkMode ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Top Row: Icon Box + Pill Title & Files Count
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: badgeColor.withValues(alpha: isDarkMode ? 0.25 : 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, size: 18, color: badgeColor),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 5),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? const Color(0xFF0F172A)
                      : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDarkMode
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Text(
                  "${stats.totalFiles} ${stats.totalFiles == 1 ? 'File' : 'Files'}",
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white70 : const Color(0xFF1E293B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 2. Middle Banner: Files in Bank Login
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: hasActiveLogin
                  ? (isDarkMode
                      ? const Color(0xFF1E3A8A).withValues(alpha: 0.35)
                      : const Color(0xFFEFF6FF))
                  : (isDarkMode
                      ? const Color(0xFF0F172A)
                      : const Color(0xFFF8FAFC)),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: hasActiveLogin
                    ? (isDarkMode
                        ? const Color(0xFF2563EB).withValues(alpha: 0.6)
                        : const Color(0xFFBFDBFE))
                    : (isDarkMode
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.play_arrow_rounded,
                          size: 14,
                          color: Color(0xFF10B981),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "FILES IN BANK LOGIN",
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            color: const Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    if (hasActiveLogin)
                      Row(
                        children: [
                          const Text(
                            "● ",
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFF2563EB),
                            ),
                          ),
                          Text(
                            "${stats.inBankLogin} active file${stats.inBankLogin > 1 ? 's' : ''} at bank",
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: isDarkMode
                                  ? const Color(0xFF93C5FD)
                                  : const Color(0xFF1D4ED8),
                            ),
                          ),
                        ],
                      )
                    else
                      Row(
                        children: [
                          Icon(
                            Icons.radio_button_unchecked,
                            size: 10,
                            color: isDarkMode
                                ? Colors.grey.shade300
                                : const Color(0xFF334155),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "No active file in login",
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode
                                  ? Colors.grey.shade300
                                  : const Color(0xFF334155),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: hasActiveLogin
                        ? const Color(0xFF2563EB)
                        : (isDarkMode
                            ? const Color(0xFF1E293B)
                            : Colors.white),
                    borderRadius: BorderRadius.circular(8),
                    border: hasActiveLogin
                        ? null
                        : Border.all(
                            color: isDarkMode
                                ? const Color(0xFF334155)
                                : const Color(0xFFE2E8F0),
                          ),
                  ),
                  child: Text(
                    "${stats.inBankLogin}",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: hasActiveLogin
                          ? Colors.white
                          : (isDarkMode
                              ? Colors.white70
                              : const Color(0xFF1E293B)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 3. Stats Row: APPROVED | DISBURSED | TOTAL LEADS
          Row(
            children: [
              Expanded(
                child: _buildStatCell(
                  label: "APPROVED",
                  value: "${stats.approved}",
                  valueColor: const Color(0xFF10B981),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatCell(
                  label: "DISBURSED",
                  value: "${stats.disbursed}",
                  valueColor: const Color(0xFF10B981),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatCell(
                  label: "TOTAL LEADS",
                  value: "${stats.totalLeads}",
                  valueColor:
                      isDarkMode ? Colors.white : const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 4. Bottom Actions Row: Left Filter / View Logged In & Right All Leads
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              hasActiveLogin
                  ? InkWell(
                      onTap: onViewLoggedIn ?? onTap,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2563EB),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.filter_alt_rounded,
                              size: 13,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "View Logged In (${stats.inBankLogin})",
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : InkWell(
                      onTap: onTap,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? const Color(0xFF0F172A)
                              : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isDarkMode
                                ? const Color(0xFF334155)
                                : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.filter_alt_outlined,
                              size: 13,
                              color: isDarkMode
                                  ? Colors.grey.shade300
                                  : const Color(0xFF334155),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "0 In Login",
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode
                                    ? Colors.grey.shade300
                                    : const Color(0xFF334155),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              InkWell(
                onTap: onAllLeads ?? onTap,
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "All Leads",
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode
                              ? Colors.white70
                              : const Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 16,
                        color: isDarkMode
                            ? Colors.white60
                            : Colors.grey.shade600,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCell({
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.4,
              color: isDarkMode ? Colors.grey.shade300 : const Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
