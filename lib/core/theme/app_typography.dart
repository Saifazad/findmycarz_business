import 'app_colors.dart';
import '../utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  // --- HEADINGS ---
  // "Your Dream Car" (Home Main Heading)
  static TextStyle get mainHeading => GoogleFonts.poppins(
    fontSize: getRelativeWidth(6.5),
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
    letterSpacing: -0.5,
  );

  // "Browse by Body Type", "Top Brands" (Section Titles)
  static TextStyle get sectionTitle => GoogleFonts.poppins(
    fontSize: getRelativeWidth(4.5),
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  // "Car Details", "Owner Details" (Form Section Headers)
  static TextStyle get formHeader => GoogleFonts.poppins(
    fontSize: getRelativeWidth(5),
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  // --- BODY & LABELS ---
  // "Hello, Discover" (Sub-headings)
  static TextStyle get subHeading => GoogleFonts.poppins(
    fontSize: getRelativeWidth(3.75),
    fontWeight: FontWeight.w400,
    color: Colors.orange.shade700, // Aapke screenshot ka golden/orange color
  );

  // Field Labels like "Car Name *", "Brand *"
  static TextStyle get fieldLabel => GoogleFonts.poppins(
    fontSize: getRelativeWidth(3.25),
    fontWeight: FontWeight.w600,
    color: Colors.black54,
  );

  // Input Text / Placeholder
  static TextStyle get inputText => GoogleFonts.poppins(
    fontSize: getRelativeWidth(3.5),
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );

  // --- SMALL TEXT ---
  // Category names like "SUV", "Sedan"
  static TextStyle get categoryName => GoogleFonts.poppins(
    fontSize: getRelativeWidth(3),
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  );

  // "View All" buttons
  static TextStyle get viewAll => GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: const Color(0xFFC5A021), // Golden color from your UI
  );

  // Navigation Bar text
  static TextStyle get navText => GoogleFonts.poppins(
    fontSize: 10,
    fontWeight: FontWeight.w500,
  );

  // --- BUTTONS ---
  // "Submit Listing", "Search"
  static TextStyle get buttonText => GoogleFonts.poppins(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 1.0,
  );
}