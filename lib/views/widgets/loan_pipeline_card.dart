import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/admin_dashboard_model.dart';

class LoanPipelineCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color badgeColor;
  final LoanCategoryStats stats;
  final VoidCallback? onTap;

  const LoanPipelineCard({
    super.key,
    required this.title,
    required this.icon,
    required this.badgeColor,
    required this.stats,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Loan Badge & Total Files Count
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 14, color: Colors.white),
                    const SizedBox(width: 6),
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  "${stats.totalFiles} Files",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Middle Box: Files in Bank Login (Screenshot 1 highlight)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: stats.inBankLogin > 0 ? const Color(0xFFEFF6FF) : const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: stats.inBankLogin > 0 ? const Color(0xFFBFDBFE) : Colors.grey.shade200,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.play_arrow_rounded,
                      size: 16,
                      color: stats.inBankLogin > 0 ? const Color(0xFF2563EB) : Colors.grey.shade500,
                    ),
                    const SizedBox(width: 4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "FILES IN BANK LOGIN",
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: stats.inBankLogin > 0 ? const Color(0xFF1E40AF) : Colors.grey.shade600,
                            letterSpacing: 0.3,
                          ),
                        ),
                        if (stats.inBankLogin > 0)
                          Text(
                            "• ${stats.inBankLogin} active files at bank",
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: const Color(0xFF3B82F6),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: stats.inBankLogin > 0 ? const Color(0xFF2563EB) : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "${stats.inBankLogin}",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: stats.inBankLogin > 0 ? Colors.white : Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

