import 'package:flutter/material.dart';

/// Opens a full-screen lightbox dialog to preview, zoom, and navigate vehicle images.
void showCarImagePreviewDialog(
  BuildContext context,
  List<String> images, {
  int initialIndex = 0,
}) {
  final validImages = images.where((e) => e.trim().isNotEmpty).toList();
  if (validImages.isEmpty) return;

  var currentIndex = initialIndex.clamp(0, validImages.length - 1);

  showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.85),
    builder: (ctx) {
      return StatefulBuilder(
        builder: (dialogCtx, setDialogState) {
          final currentUrl = validImages[currentIndex];
          final isNetwork = currentUrl.startsWith('http');
          final hasMultiple = validImages.length > 1;

          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
            child: Stack(
              alignment: Alignment.center,
              children: [
                InteractiveViewer(
                  key: ValueKey(currentUrl),
                  minScale: 0.8,
                  maxScale: 4.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: isNetwork
                        ? Image.network(
                            currentUrl,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.broken_image_outlined,
                              size: 48,
                              color: Colors.white70,
                            ),
                          )
                        : Image.asset(
                            currentUrl,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.broken_image_outlined,
                              size: 48,
                              color: Colors.white70,
                            ),
                          ),
                  ),
                ),

                // Top-right close button
                Positioned(
                  top: 8,
                  right: 8,
                  child: Material(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    elevation: 4,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => Navigator.of(ctx).pop(),
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.close,
                          size: 20,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),
                  ),
                ),

                // Previous (<) button when multiple photos exist
                if (hasMultiple)
                  Positioned(
                    left: 6,
                    child: Material(
                      color: Colors.black.withValues(alpha: 0.45),
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () {
                          setDialogState(() {
                            currentIndex = (currentIndex - 1 + validImages.length) %
                                validImages.length;
                          });
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.chevron_left,
                            size: 28,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                // Next (>) button when multiple photos exist
                if (hasMultiple)
                  Positioned(
                    right: 6,
                    child: Material(
                      color: Colors.black.withValues(alpha: 0.45),
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () {
                          setDialogState(() {
                            currentIndex =
                                (currentIndex + 1) % validImages.length;
                          });
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.chevron_right,
                            size: 28,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      );
    },
  );
}
