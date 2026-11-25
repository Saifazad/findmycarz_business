import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminStepperHeader extends StatelessWidget {
  final int currentStep;
  final bool isStep1Complete;
  final bool isStep2Complete;
  final int uploadedDocsCount;
  final void Function(int step) onStepTap;

  const AdminStepperHeader({
    super.key,
    required this.currentStep,
    required this.isStep1Complete,
    required this.isStep2Complete,
    required this.uploadedDocsCount,
    required this.onStepTap,
  });

  @override
  Widget build(BuildContext context) {
    const stepTitles = [
      "Account & Role",
      "Bank & Address",
      "KYC Documents",
      "Outward Payout",
      "Modular Access",
    ];

    const stepShortTitles = [
      "Account",
      "Bank",
      "Docs",
      "Payout",
      "Access",
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Step ${currentStep + 1}: ${stepTitles[currentStep]}",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                ),
              ),
              Text(
                "${((currentStep + 1) * 20)}% Completed",
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF10B981),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(5, (index) {
              final isCompleted = index < currentStep ||
                  (index == 0 && isStep1Complete && index != currentStep) ||
                  (index == 1 && isStep2Complete && index != currentStep) ||
                  (index == 2 && uploadedDocsCount > 0 && index != currentStep);
              final isCurrent = index == currentStep;

              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => onStepTap(index),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isCompleted
                                    ? const Color(0xFF10B981)
                                    : isCurrent
                                        ? const Color(0xFF003366)
                                        : const Color(0xFFF1F5F9),
                                border: Border.all(
                                  color: isCurrent
                                      ? const Color(0xFF003366)
                                      : isCompleted
                                          ? const Color(0xFF10B981)
                                          : const Color(0xFFCBD5E1),
                                  width: isCurrent ? 2 : 1,
                                ),
                                boxShadow: isCurrent
                                    ? [
                                        BoxShadow(
                                          color: const Color(0xFF003366)
                                              .withValues(alpha: 0.25),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              alignment: Alignment.center,
                              child: isCompleted
                                  ? const Icon(Icons.check_rounded,
                                      color: Colors.white, size: 16)
                                  : Text(
                                      "${index + 1}",
                                      style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: isCurrent
                                            ? Colors.white
                                            : const Color(0xFF64748B),
                                      ),
                                    ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              stepShortTitles[index],
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: isCurrent
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isCurrent
                                    ? const Color(0xFF003366)
                                    : isCompleted
                                        ? const Color(0xFF10B981)
                                        : const Color(0xFF94A3B8),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (index < 4)
                      Container(
                        width: 12,
                        height: 2,
                        margin: const EdgeInsets.only(bottom: 16),
                        color: isCompleted
                            ? const Color(0xFF10B981)
                            : const Color(0xFFE2E8F0),
                      ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
