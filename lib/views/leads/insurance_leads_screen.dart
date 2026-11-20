import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InsuranceLeadsScreen extends StatelessWidget {
  const InsuranceLeadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          "Insurance Leads",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: const SizedBox.expand(),
    );
  }
}
