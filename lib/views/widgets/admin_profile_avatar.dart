import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';

class AdminProfileAvatar extends StatelessWidget {
  final double radius;

  const AdminProfileAvatar({super.key, this.radius = 16});

  @override
  Widget build(BuildContext context) {
    String initial = "S";
    String? imageUrl;

    try {
      final authVM = Provider.of<AuthViewModel>(context, listen: false);
      if (authVM.userName != null && authVM.userName!.trim().isNotEmpty) {
        initial = authVM.userName!.trim()[0].toUpperCase();
      }
      imageUrl = authVM.profileImageUrl;
    } catch (_) {
      // Fallback
    }

    if (imageUrl != null && imageUrl.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: const Color(0xFF003366),
        backgroundImage: imageUrl.startsWith('http')
            ? NetworkImage(imageUrl) as ImageProvider
            : AssetImage(imageUrl),
      );
    }

    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: const BoxDecoration(
        color: Color(0xFF003366), // Deep Navy Blue matching reference image
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: GoogleFonts.poppins(
          fontSize: radius * 0.85,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
