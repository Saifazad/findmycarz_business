import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class UploadSourceModal {
  static void show({
    required BuildContext context,
    required String docType,
    required void Function(String filePath) onFilePicked,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Upload $docType",
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A)),
              ),
              const SizedBox(height: 6),
              Text(
                "Choose a source to attach official verified document",
                style: GoogleFonts.poppins(
                    fontSize: 12, color: const Color(0xFF64748B)),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: const Color(0xFF003366).withValues(alpha: 0.08),
                      shape: BoxShape.circle),
                  child: const Icon(Icons.camera_alt_outlined,
                      color: Color(0xFF003366)),
                ),
                title: Text("Take Photo with Camera",
                    style: GoogleFonts.poppins(
                        fontSize: 14, fontWeight: FontWeight.w600)),
                onTap: () async {
                  Navigator.pop(ctx);
                  try {
                    final picker = ImagePicker();
                    final picked = await picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 85,
                    );
                    if (picked != null) {
                      HapticFeedback.lightImpact();
                      onFilePicked(picked.path);
                    }
                  } catch (e) {
                    debugPrint("Camera pick error: $e");
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Error capturing photo: $e",
                              style: GoogleFonts.poppins()),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  }
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.12),
                      shape: BoxShape.circle),
                  child: const Icon(Icons.file_present_outlined,
                      color: Color(0xFF10B981)),
                ),
                title: Text("Choose File (PDF, PNG, JPG)",
                    style: GoogleFonts.poppins(
                        fontSize: 14, fontWeight: FontWeight.w600)),
                onTap: () async {
                  Navigator.pop(ctx);
                  try {
                    final result = await FilePicker.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
                    );
                    if (result.isNotEmpty && result.first.path != null) {
                      HapticFeedback.lightImpact();
                      onFilePicked(result.first.path!);
                    }
                  } catch (e) {
                    debugPrint("File pick error: $e");
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Error selecting file: $e",
                              style: GoogleFonts.poppins()),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
