import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class DocumentViewerModal {
  static void viewDocument({
    required BuildContext context,
    String? remoteUrl,
    String? localPath,
    required String label,
  }) {
    // If local file on device
    if (localPath != null && localPath.isNotEmpty) {
      final lower = localPath.toLowerCase();
      final isImage = lower.endsWith('.png') ||
          lower.endsWith('.jpg') ||
          lower.endsWith('.jpeg') ||
          lower.endsWith('.webp');
      if (isImage) {
        showLocalImageDialog(context, localPath, label);
        return;
      }
    }

    // Determine target URL
    String? targetUrl = remoteUrl?.trim();
    if (targetUrl == null || targetUrl.isEmpty) {
      if (localPath != null && localPath.isNotEmpty) {
        showDocumentViewerOptions(
          context: context,
          targetUrl: localPath,
          label: label,
          localPath: localPath,
        );
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("No document URL available for $label",
              style: GoogleFonts.poppins()),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Ensure fully-qualified URL
    if (!targetUrl.startsWith('http://') && !targetUrl.startsWith('https://')) {
      if (targetUrl.startsWith('/')) {
        targetUrl = "https://awsdemo.co.in$targetUrl";
      } else {
        targetUrl = "https://awsdemo.co.in/findmycarz/$targetUrl";
      }
    }

    final lowerUrl = targetUrl.toLowerCase();
    final isImage = lowerUrl.endsWith('.png') ||
        lowerUrl.endsWith('.jpg') ||
        lowerUrl.endsWith('.jpeg') ||
        lowerUrl.endsWith('.webp');

    if (isImage) {
      showRemoteImageDialog(context, targetUrl, label);
      return;
    }

    // For PDF documents: show options modal with Online View (Google Docs Viewer) & Direct Link
    showDocumentViewerOptions(
      context: context,
      targetUrl: targetUrl,
      label: label,
      localPath: localPath,
    );
  }

  static void showDocumentViewerOptions({
    required BuildContext context,
    required String targetUrl,
    required String label,
    String? localPath,
  }) {
    final fileName = targetUrl.split('/').last.split('?').first;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF003366).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.picture_as_pdf_rounded,
                        color: Color(0xFF003366), size: 26),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          fileName,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: const Color(0xFF64748B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFF94A3B8)),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Option 1: View Online (Google Docs Viewer)
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                tileColor: const Color(0xFFF1F5F9),
                leading: const Icon(Icons.chrome_reader_mode_rounded,
                    color: Color(0xFF003366), size: 24),
                title: Text(
                  "View Online (Instant)",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                subtitle: Text(
                  "Render PDF in browser instantly with Google Docs Viewer",
                  style: GoogleFonts.poppins(
                      fontSize: 11, color: const Color(0xFF64748B)),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded,
                    size: 14, color: Color(0xFF94A3B8)),
                onTap: () {
                  Navigator.pop(ctx);
                  final gDocsUrl =
                      "https://docs.google.com/viewer?url=${Uri.encodeComponent(targetUrl)}";
                  openUrl(context, gDocsUrl,
                      mode: LaunchMode.externalApplication);
                },
              ),
              const SizedBox(height: 10),

              // Option 2: Open Direct Link
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                tileColor: const Color(0xFFF8FAFC),
                leading: const Icon(Icons.open_in_browser_rounded,
                    color: Color(0xFF2563EB), size: 24),
                title: Text(
                  "Open Direct Link",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                subtitle: Text(
                  "Open in default browser or download original file",
                  style: GoogleFonts.poppins(
                      fontSize: 11, color: const Color(0xFF64748B)),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded,
                    size: 14, color: Color(0xFF94A3B8)),
                onTap: () {
                  Navigator.pop(ctx);
                  openUrl(context, targetUrl,
                      mode: LaunchMode.externalApplication);
                },
              ),
              const SizedBox(height: 10),

              // Option 3: Copy URL
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                leading: const Icon(Icons.copy_rounded,
                    color: Color(0xFF64748B), size: 22),
                title: Text(
                  "Copy Document Link",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF334155),
                  ),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  Clipboard.setData(ClipboardData(text: targetUrl));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Document link copied to clipboard!",
                          style: GoogleFonts.poppins()),
                      backgroundColor: const Color(0xFF003366),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  static void showLocalImageDialog(
      BuildContext context, String filePath, String label) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  color: const Color(0xFF003366),
                  child: Row(
                    children: [
                      const Icon(Icons.image, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          label,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close,
                            color: Colors.white, size: 20),
                        onPressed: () => Navigator.pop(ctx),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: InteractiveViewer(
                    panEnabled: true,
                    minScale: 0.5,
                    maxScale: 4.0,
                    child: Image.file(
                      File(filePath),
                      fit: BoxFit.contain,
                      errorBuilder: (context, _, __) => Container(
                        height: 200,
                        alignment: Alignment.center,
                        child: Text("Unable to preview local image",
                            style: GoogleFonts.poppins(
                                fontSize: 12, color: Colors.grey)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void showRemoteImageDialog(
      BuildContext context, String url, String label) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  color: const Color(0xFF003366),
                  child: Row(
                    children: [
                      const Icon(Icons.image, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          label,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close,
                            color: Colors.white, size: 20),
                        onPressed: () => Navigator.pop(ctx),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: InteractiveViewer(
                    panEnabled: true,
                    minScale: 0.5,
                    maxScale: 4.0,
                    child: CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.contain,
                      placeholder: (context, _) => const SizedBox(
                        height: 250,
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF003366),
                          ),
                        ),
                      ),
                      errorWidget: (context, _, __) => Container(
                        height: 200,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.broken_image,
                                size: 40, color: Colors.grey),
                            const SizedBox(height: 8),
                            Text("Failed to load image preview",
                                style: GoogleFonts.poppins(
                                    fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () => openUrl(context, url),
                        icon: const Icon(Icons.open_in_browser,
                            size: 16, color: Color(0xFF003366)),
                        label: Text(
                          "Open in Browser",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF003366),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<void> openUrl(BuildContext context, String rawUrl,
      {LaunchMode mode = LaunchMode.externalApplication}) async {
    final uri = Uri.parse(rawUrl);
    bool launched = false;
    try {
      launched = await launchUrl(uri, mode: mode);
    } catch (e) {
      debugPrint("launchUrl with mode $mode failed: $e");
    }

    if (!launched) {
      try {
        launched = await launchUrl(uri, mode: LaunchMode.platformDefault);
      } catch (e) {
        debugPrint("launchUrl with platformDefault failed: $e");
      }
    }

    if (!launched) {
      try {
        launched = await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
      } catch (e) {
        debugPrint("launchUrl with inAppBrowserView failed: $e");
      }
    }

    if (!launched && context.mounted) {
      Clipboard.setData(ClipboardData(text: rawUrl));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Unable to open browser. URL copied to clipboard!",
              style: GoogleFonts.poppins()),
          backgroundColor: const Color(0xFF003366),
        ),
      );
    }
  }
}
