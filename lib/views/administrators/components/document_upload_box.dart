import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../modals/document_viewer_modal.dart';

class DocumentUploadBox extends StatelessWidget {
  final String label;
  final bool isUploaded;
  final String? remoteUrl;
  final String? localPath;
  final VoidCallback onSelectOrReplace;

  const DocumentUploadBox({
    super.key,
    required this.label,
    required this.isUploaded,
    this.remoteUrl,
    this.localPath,
    required this.onSelectOrReplace,
  });

  @override
  Widget build(BuildContext context) {
    final fileName = localPath?.split(Platform.pathSeparator).last ??
        remoteUrl?.split('/').last;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUploaded ? const Color(0xFFECFDF5) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              isUploaded ? const Color(0xFF10B981) : const Color(0xFFCBD5E1),
          width: isUploaded ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isUploaded
                      ? const Color(0xFF10B981).withValues(alpha: 0.12)
                      : const Color(0xFF64748B).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isUploaded
                      ? Icons.verified_rounded
                      : Icons.cloud_upload_outlined,
                  size: 26,
                  color: isUploaded
                      ? const Color(0xFF10B981)
                      : const Color(0xFF64748B),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isUploaded ? "$label Uploaded" : "Upload $label",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isUploaded
                            ? const Color(0xFF065F46)
                            : const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      fileName ?? "PDF, PNG or JPG up to 5MB",
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: isUploaded
                            ? const Color(0xFF047857)
                            : const Color(0xFF94A3B8),
                        fontWeight:
                            isUploaded ? FontWeight.w500 : FontWeight.normal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (isUploaded) ...[
            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xFFD1FAE5)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if ((remoteUrl != null && remoteUrl!.isNotEmpty) ||
                    (localPath != null && localPath!.isNotEmpty)) ...[
                  TextButton.icon(
                    onPressed: () => DocumentViewerModal.viewDocument(
                      context: context,
                      remoteUrl: remoteUrl,
                      localPath: localPath,
                      label: label,
                    ),
                    icon: const Icon(Icons.open_in_new_rounded,
                        size: 16, color: Color(0xFF003366)),
                    label: Text(
                      "View File 📄",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF003366),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                ElevatedButton.icon(
                  onPressed: onSelectOrReplace,
                  icon: const Icon(Icons.sync_rounded,
                      size: 15, color: Colors.white),
                  label: Text(
                    "Replace",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003366),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ] else ...[
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: onSelectOrReplace,
              icon: const Icon(Icons.upload_file_rounded,
                  size: 16, color: Colors.white),
              label: Text(
                "Select $label",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003366),
                elevation: 0,
                minimumSize: const Size(double.infinity, 38),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
