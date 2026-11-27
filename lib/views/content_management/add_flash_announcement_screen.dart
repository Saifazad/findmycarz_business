import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/admin_profile_avatar.dart';
import 'flash_news_screen.dart';

class AddFlashAnnouncementScreen extends StatefulWidget {
  final FlashNewsItem? existingItem;

  const AddFlashAnnouncementScreen({super.key, this.existingItem});

  @override
  State<AddFlashAnnouncementScreen> createState() =>
      _AddFlashAnnouncementScreenState();
}

class _AddFlashAnnouncementScreenState
    extends State<AddFlashAnnouncementScreen> {
  bool _isDarkMode = false;

  late TextEditingController _titleController;
  late TextEditingController _urlController;
  late TextEditingController _orderController;

  String _contentType = "Plain Text (No link)";
  String _status = "Active (Show on Website)";
  bool _openInNewTab = true;

  final List<String> _contentTypes = [
    "Plain Text (No link)",
    "Link (Shows Link Icon)",
    "PDF (Shows PDF Icon)",
    "Image (Shows Image Icon)",
  ];

  final List<String> _statuses = [
    "Active (Show on Website)",
    "Inactive (Draft)",
  ];

  @override
  void initState() {
    super.initState();
    final item = widget.existingItem;
    _titleController = TextEditingController(text: item?.text ?? "");
    _urlController = TextEditingController(text: item?.url ?? "");
    _orderController = TextEditingController(text: "${item?.order ?? 0}");

    if (item != null) {
      if (item.type.toLowerCase().contains("pdf")) {
        _contentType = "PDF (Shows PDF Icon)";
      } else if (item.type.toLowerCase().contains("image")) {
        _contentType = "Image (Shows Image Icon)";
      } else if (item.type.toLowerCase().contains("plain") ||
          item.type.toLowerCase().contains("text")) {
        _contentType = "Plain Text (No link)";
      } else {
        _contentType = "Link (Shows Link Icon)";
      }

      _status = item.isActive ? "Active (Show on Website)" : "Inactive (Draft)";
      _openInNewTab = item.linkTarget == "New Tab";
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _urlController.dispose();
    _orderController.dispose();
    super.dispose();
  }

  void _save() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter Announcement Title / Headline!"),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }

    final order = int.tryParse(_orderController.text.trim()) ?? 0;
    final isActive = _status.startsWith("Active");
    final linkTarget = _openInNewTab ? "New Tab" : "Same Tab";

    String itemType = "Link";
    if (_contentType.contains("PDF")) {
      itemType = "PDF";
    } else if (_contentType.contains("Image")) {
      itemType = "Image";
    } else if (_contentType.contains("Text Only") ||
        _contentType.contains("Plain")) {
      itemType = "Text Only";
    }

    final newItem = FlashNewsItem(
      id: widget.existingItem?.id ??
          "FLASH-${DateTime.now().millisecondsSinceEpoch}",
      text: title,
      order: order,
      type: itemType,
      isActive: isActive,
      linkTarget: linkTarget,
      url: _urlController.text.trim().isEmpty
          ? null
          : _urlController.text.trim(),
    );

    Navigator.pop(context, newItem);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existingItem != null;

    return Scaffold(
      backgroundColor:
          _isDarkMode ? const Color(0xFF0F172A) : AppColors.background,
      appBar: AppBar(
        backgroundColor: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        elevation: 0.5,
        leading: CustomBackButton(isDarkMode: _isDarkMode),
        titleSpacing: 0,
        title: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            isEdit ? "Edit Flash Announcement" : "Add Flash Announcement",
            style: GoogleFonts.poppins(
              fontSize: 16.5,
              fontWeight: FontWeight.bold,
              color: _isDarkMode ? Colors.white : const Color(0xFF0F172A),
            ),
            maxLines: 1,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_none_rounded,
              color: _isDarkMode ? Colors.white : const Color(0xFF334155),
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 4),
          const AdminProfileAvatar(),
          const SizedBox(width: 14),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section: Header Banner with Primary Gradient + [ Back ]
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isEdit ? Icons.edit_square : Icons.add_circle,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isEdit ? "Edit Flash Announcement" : "Add New Flash",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Form Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _isDarkMode
                      ? const Color(0xFF334155)
                      : const Color(0xFFE2E8F0),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withValues(alpha: _isDarkMode ? 0.2 : 0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Field 1: Select Content Type *
                  _buildFieldLabel("Select Content Type *"),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    initialValue: _contentType,
                    dropdownColor:
                        _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                    items: _contentTypes.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(
                          type,
                          style: GoogleFonts.poppins(
                            fontSize: 12.5,
                            color: _isDarkMode
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _contentType = val;
                        });
                      }
                    },
                    decoration: _inputDecoration(hint: ""),
                  ),
                  const SizedBox(height: 16),

                  // Field 2: Announcement Title / Headline *
                  _buildFieldLabel("Announcement Title / Headline *"),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _titleController,
                    maxLines: 3,
                    style: GoogleFonts.poppins(
                      fontSize: 12.5,
                      color: _isDarkMode ? Colors.white : Colors.black87,
                    ),
                    decoration: _inputDecoration(
                      hint:
                          "Welcome to Find My Car, your trusted destination for buying and selling new and pre-owned cars.",
                    ),
                  ),
                  if (!_contentType.contains("Plain")) ...[
                    const SizedBox(height: 16),
                    // Field 3: Target Web Link (URL)
                    Row(
                      children: [
                        const Icon(
                          Icons.link,
                          size: 18,
                          color: AppColors.inputIcon,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "Target Web Link (URL)",
                          style: GoogleFonts.poppins(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _urlController,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: _isDarkMode ? Colors.white : Colors.black87,
                      ),
                      decoration: _inputDecoration(
                        hint:
                            "e.g. /landing-page or https://findmycarz.com/loan/new",
                      ),
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: _isDarkMode
                              ? Colors.grey.shade400
                              : const Color(0xFF64748B),
                        ),
                        children: const [
                          TextSpan(text: "Enter internal path like "),
                          TextSpan(
                            text: "/cars",
                            style: TextStyle(
                              color: Color(0xFFEF4444),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(text: " or external URL like "),
                          TextSpan(
                            text: "https://...",
                            style: TextStyle(
                              color: Color(0xFFEF4444),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),

                  // Display Order (Sort Order)
                  _buildFieldLabel("Display Order (Sort Order)"),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _orderController,
                    keyboardType: TextInputType.number,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: _isDarkMode ? Colors.white : Colors.black87,
                    ),
                    decoration: _inputDecoration(hint: "0"),
                  ),
                  const SizedBox(height: 16),

                  // Status
                  _buildFieldLabel("Status"),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    initialValue: _status,
                    dropdownColor:
                        _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                    items: _statuses.map((s) {
                      return DropdownMenuItem(
                        value: s,
                        child: Text(
                          s,
                          style: GoogleFonts.poppins(
                            fontSize: 12.5,
                            color: _isDarkMode
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _status = val;
                        });
                      }
                    },
                    decoration: _inputDecoration(hint: ""),
                  ),
                  const SizedBox(height: 16),

                  // Open Target in
                  _buildFieldLabel("Open Target in"),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Switch(
                        value: _openInNewTab,
                        activeThumbColor: AppColors.primary,
                        activeTrackColor:
                            AppColors.primary.withValues(alpha: 0.5),
                        onChanged: (val) {
                          setState(() {
                            _openInNewTab = val;
                          });
                        },
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "Open in New Tab",
                        style: GoogleFonts.poppins(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: _isDarkMode
                              ? Colors.white
                              : const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Actions: [ Cancel ] [ Save / Update Flash Announcement ]
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          minimumSize: const Size(64, 38),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _save,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            minimumSize: const Size(0, 38),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (!isEdit) ...[
                                  const Icon(
                                    Icons.save_outlined,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 5),
                                ],
                                Text(
                                  isEdit
                                      ? "Update Flash Announcement"
                                      : "Save Flash Announcement",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    if (label.contains("*")) {
      final parts = label.split("*");
      return RichText(
        text: TextSpan(
          style: GoogleFonts.poppins(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
          children: [
            TextSpan(text: parts[0]),
            const TextSpan(
              text: "*",
              style: TextStyle(
                color: AppColors.danger, // Red asterisk
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }
    return Text(
      label,
      style: GoogleFonts.poppins(
        fontSize: 12.5,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint}) {
    return InputDecoration(
      hintText: hint.isNotEmpty ? hint : null,
      hintStyle: GoogleFonts.poppins(
        fontSize: 12,
        color: _isDarkMode ? Colors.white38 : Colors.grey.shade400,
      ),
      filled: true,
      fillColor: _isDarkMode ? const Color(0xFF0F172A) : Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color:
              _isDarkMode ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color:
              _isDarkMode ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(
          color: AppColors.primary,
          width: 1.5,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }
}
