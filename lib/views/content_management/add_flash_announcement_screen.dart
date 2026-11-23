import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  String _contentType = "Link (Shows Link Icon)";
  String _status = "Active (Show on Website)";
  bool _openInNewTab = true;

  final List<String> _contentTypes = [
    "Link (Shows Link Icon)",
    "PDF (Shows PDF Icon)",
    "Image (Shows Image Icon)",
    "Text Only (Shows Text Icon)",
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
      if (item.type.toLowerCase().contains("link")) {
        _contentType = "Link (Shows Link Icon)";
      } else if (item.type.toLowerCase().contains("pdf")) {
        _contentType = "PDF (Shows PDF Icon)";
      } else if (item.type.toLowerCase().contains("image")) {
        _contentType = "Image (Shows Image Icon)";
      } else {
        _contentType = "Text Only (Shows Text Icon)";
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
          backgroundColor: Color(0xFFDC2626),
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
    } else if (_contentType.contains("Text Only")) {
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
          _isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        elevation: 0.5,
        leading: CustomBackButton(isDarkMode: _isDarkMode),
        title: Text(
          "Add Flash Announcement",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _isDarkMode ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        actions: [
          IconButton(
            tooltip:
                _isDarkMode ? "Switch to Light Mode" : "Switch to Dark Mode",
            icon: Icon(
              _isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_outlined,
              color: _isDarkMode
                  ? const Color(0xFFFBBF24)
                  : const Color(0xFF334155),
            ),
            onPressed: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
            },
          ),
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
            // Top Section: Header with [+] Add New Flash Announcement + [ ← Back to List ]
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 26,
                        height: 26,
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981), // Emerald Green
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          isEdit
                              ? "Edit Flash Announcement"
                              : "Add New Flash Announcement",
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: _isDarkMode
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                // [ ← Back to List ] Button
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back,
                      size: 14, color: Colors.white),
                  label: Text(
                    "Back to List",
                    style: GoogleFonts.poppins(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B9BB4), // Slate/Grey-blue
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Subtitle Description
            Text(
              "Select type (Link, PDF, or Image) and enter details. The corresponding icon will automatically show on the marquee.",
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: _isDarkMode
                    ? Colors.grey.shade400
                    : const Color(0xFF64748B),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),

            // Form Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _isDarkMode
                      ? const Color(0xFF334155)
                      : const Color(0xFFE2E8F0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withValues(alpha: _isDarkMode ? 0.2 : 0.03),
                    blurRadius: 8,
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
                        child: Row(
                          children: [
                            Icon(
                              type.contains("PDF")
                                  ? Icons.picture_as_pdf_outlined
                                  : type.contains("Image")
                                      ? Icons.image_outlined
                                      : type.contains("Text")
                                          ? Icons.text_snippet_outlined
                                          : Icons.link,
                              size: 16,
                              color: _isDarkMode
                                  ? Colors.grey.shade300
                                  : const Color(0xFF64748B),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              type,
                              style: GoogleFonts.poppins(
                                fontSize: 12.5,
                                color: _isDarkMode
                                    ? Colors.white
                                    : const Color(0xFF0F172A),
                              ),
                            ),
                          ],
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
                    maxLines: 2,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: _isDarkMode ? Colors.white : Colors.black87,
                    ),
                    decoration: _inputDecoration(
                      hint:
                          "e.g. Lowest Interest Rates on Car Loans starting at 8.99% per annum! Apply online now.",
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Field 3: Target Web Link (URL)
                  Row(
                    children: [
                      const Icon(
                        Icons.link,
                        size: 18,
                        color: Color(0xFFF59E0B), // Amber/Orange Link icon
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Target Web Link (URL)",
                        style: GoogleFonts.poppins(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: _isDarkMode
                              ? Colors.white
                              : const Color(0xFF0F172A),
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
                  // Rich Text Helper: Enter internal path like /cars or external URL like https://...
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
                            color: Color(0xFFEF4444), // Red
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(text: " or external URL like "),
                        TextSpan(
                          text: "https://...",
                          style: TextStyle(
                            color: Color(0xFFEF4444), // Red
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Responsive Row/Wrap: Display Order + Status + Open Target in
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final orderWidget = Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel("Display Order (Sort Order)"),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _orderController,
                            keyboardType: TextInputType.number,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color:
                                  _isDarkMode ? Colors.white : Colors.black87,
                            ),
                            decoration: _inputDecoration(hint: "0"),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Lower number appears first (0, 1, 2...)",
                            style: GoogleFonts.poppins(
                              fontSize: 10.5,
                              color: _isDarkMode
                                  ? Colors.grey.shade400
                                  : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      );

                      final statusWidget = Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel("Status"),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            initialValue: _status,
                            dropdownColor: _isDarkMode
                                ? const Color(0xFF1E293B)
                                : Colors.white,
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
                        ],
                      );

                      final targetWidget = Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel("Open Target in"),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Switch(
                                value: _openInNewTab,
                                activeThumbColor:
                                    const Color(0xFF10B981), // Emerald Green
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
                                  fontWeight: FontWeight.w600,
                                  color: _isDarkMode
                                      ? Colors.white
                                      : const Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );

                      if (constraints.maxWidth > 650) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: orderWidget),
                            const SizedBox(width: 14),
                            Expanded(child: statusWidget),
                            const SizedBox(width: 14),
                            Expanded(child: targetWidget),
                          ],
                        );
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            orderWidget,
                            const SizedBox(height: 14),
                            statusWidget,
                            const SizedBox(height: 14),
                            targetWidget,
                          ],
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 24),

                  // Actions: [ Cancel ] [ 💾 Save Flash Announcement ]
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          backgroundColor: _isDarkMode
                              ? const Color(0xFF334155)
                              : const Color(0xFFF1F5F9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.poppins(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: _isDarkMode
                                ? Colors.white70
                                : const Color(0xFF334155),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: _save,
                        icon: const Icon(
                          Icons.save_outlined,
                          size: 16,
                          color: Colors.white,
                        ),
                        label: Text(
                          "Save Flash Announcement",
                          style: GoogleFonts.poppins(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0284C7), // Sky/Blue
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
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
            color: _isDarkMode ? Colors.white : const Color(0xFF0F172A),
          ),
          children: [
            TextSpan(text: parts[0]),
            const TextSpan(
              text: "*",
              style: TextStyle(
                color: Color(0xFFDC2626), // Red asterisk
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
        color: _isDarkMode ? Colors.white : const Color(0xFF0F172A),
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
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: Color(0xFF0284C7),
          width: 1.5,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }
}
