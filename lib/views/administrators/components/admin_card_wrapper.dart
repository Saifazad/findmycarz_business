import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminCardWrapper extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> children;

  const AdminCardWrapper({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}
