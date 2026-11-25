import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LiveStaffBadge extends StatelessWidget {
  final String name;
  final String username;
  final String? roleName;
  final bool isActive;
  final String? profilePhotoPath;

  const LiveStaffBadge({
    super.key,
    required this.name,
    required this.username,
    required this.roleName,
    required this.isActive,
    this.profilePhotoPath,
  });

  @override
  Widget build(BuildContext context) {
    final displayName =
        name.trim().isNotEmpty ? name.trim() : "Staff Member Name";
    final displayRole = roleName ?? "Designation Pending";
    final displayUser =
        username.trim().isNotEmpty ? "@${username.trim()}" : "@username";
    final initial =
        displayName.isNotEmpty ? displayName[0].toUpperCase() : "A";

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF003366), Color(0xFF0A4F9E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF003366).withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white,
            backgroundImage: profilePhotoPath != null
                ? AssetImage(profilePhotoPath!)
                : null,
            child: profilePhotoPath == null
                ? Text(
                    initial,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF003366),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        displayName,
                        style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isActive
                            ? const Color(0xFF10B981)
                            : Colors.redAccent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        isActive ? "ACTIVE" : "INACTIVE",
                        style: GoogleFonts.poppins(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Text(
                  "$displayUser • Find My Carz CRM",
                  style:
                      GoogleFonts.poppins(fontSize: 11, color: Colors.white70),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    displayRole,
                    style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
