import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/crm_drawer.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/admin_profile_avatar.dart';
import 'add_flash_announcement_screen.dart';

class FlashNewsItem {
  final String id;
  String text;
  int order;
  String type;
  bool isActive;
  String linkTarget;
  String? url;

  FlashNewsItem({
    required this.id,
    required this.text,
    this.order = 0,
    this.type = "Text Only",
    this.isActive = true,
    this.linkTarget = "New Tab",
    this.url,
  });
}

class FlashNewsScreen extends StatefulWidget {
  const FlashNewsScreen({super.key});

  @override
  State<FlashNewsScreen> createState() => _FlashNewsScreenState();
}

class _FlashNewsScreenState extends State<FlashNewsScreen> {
  final bool _isDarkMode = false;

  final List<FlashNewsItem> _flashItems = [
    FlashNewsItem(
      id: "FLASH-001",
      text:
          "Welcome to Find My Car, your trusted destination for buying and selling new and pre-owned cars.",
      order: 0,
      type: "Text Only",
      isActive: true,
      linkTarget: "New Tab",
    ),
  ];

  Future<void> _navigateToAdd() async {
    final newItem = await Navigator.push<FlashNewsItem>(
      context,
      MaterialPageRoute(
        builder: (_) => const AddFlashAnnouncementScreen(),
      ),
    );

    if (newItem != null) {
      setState(() {
        _flashItems.add(newItem);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Flash announcement saved successfully!"),
            backgroundColor: Color(0xFF0F766E),
          ),
        );
      }
    }
  }

  Future<void> _navigateToEdit(FlashNewsItem item) async {
    final updatedItem = await Navigator.push<FlashNewsItem>(
      context,
      MaterialPageRoute(
        builder: (_) => AddFlashAnnouncementScreen(existingItem: item),
      ),
    );

    if (updatedItem != null) {
      setState(() {
        item.text = updatedItem.text;
        item.order = updatedItem.order;
        item.type = updatedItem.type;
        item.linkTarget = updatedItem.linkTarget;
        item.isActive = updatedItem.isActive;
        item.url = updatedItem.url;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Flash announcement updated successfully!"),
            backgroundColor: Color(0xFF1E6FD9),
          ),
        );
      }
    }
  }

  void _deleteItem(FlashNewsItem item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        title: Text(
          "Delete Flash Item",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: _isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        content: Text(
          "Are you sure you want to delete this flash announcement?",
          style: GoogleFonts.poppins(
            color: _isDarkMode ? Colors.white70 : Colors.black54,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC2626)),
            onPressed: () {
              setState(() {
                _flashItems.removeWhere((i) => i.id == item.id);
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Flash item deleted successfully!"),
                  backgroundColor: Color(0xFFDC2626),
                ),
              );
            },
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          _isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      drawer: const CrmDrawer(),
      appBar: AppBar(
        backgroundColor: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        elevation: 0.5,
        leading: CustomBackButton(isDarkMode: _isDarkMode),
        title: Text(
          "Flash News",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _isDarkMode ? Colors.white : const Color(0xFF0F172A),
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
            // 1. Heading with Green Megaphone
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  margin: const EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.campaign_rounded,
                    color: Color(0xFF059669),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Flash News & Marquee Management",
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color:
                          _isDarkMode ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Description text
            Text(
              "Manage ticker announcements, direct web links, downloadable PDFs, and image attachments displayed on the website top marquee bar.",
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: _isDarkMode
                    ? Colors.grey.shade400
                    : const Color(0xFF64748B),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 14),

            // 2. Full-Width "+ Add New Flash Item" Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _navigateToAdd,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E6FD9),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "+ Add New Flash Item",
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 3. Subheading: "All Flash Announcements" + "Total Items: N"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "All Flash Announcements",
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: _isDarkMode
                        ? Colors.grey.shade300
                        : const Color(0xFF1E293B),
                  ),
                ),
                Text(
                  "Total Items: ${_flashItems.length}",
                  style: GoogleFonts.poppins(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F766E),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 4. Flash Items List
            if (_flashItems.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.campaign_outlined,
                        size: 44,
                        color: _isDarkMode
                            ? Colors.grey.shade600
                            : Colors.grey.shade400,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "No Flash Announcements",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _isDarkMode
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _flashItems.length,
                itemBuilder: (ctx, index) {
                  final item = _flashItems[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color:
                          _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
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
                        // Row 1: Badges Row (Order 0 + A Text Only on Left, Active on Right)
                        Row(
                          children: [
                            // Order N Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2.5),
                              decoration: BoxDecoration(
                                color: _isDarkMode
                                    ? const Color(0xFF334155)
                                    : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                "Order ${item.order}",
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: _isDarkMode
                                      ? Colors.white70
                                      : const Color(0xFF334155),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),

                            // A Text Only
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "A",
                                  style: GoogleFonts.poppins(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.bold,
                                    color: _isDarkMode
                                        ? Colors.grey.shade400
                                        : const Color(0xFF64748B),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  item.type,
                                  style: GoogleFonts.poppins(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w500,
                                    color: _isDarkMode
                                        ? Colors.grey.shade400
                                        : const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),

                            // Active / Inactive Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2.5),
                              decoration: BoxDecoration(
                                color: item.isActive
                                    ? const Color(0xFF0F766E)
                                    : const Color(0xFFDC2626),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                item.isActive ? "Active" : "Inactive",
                                style: GoogleFonts.poppins(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Announcement Text
                        Text(
                          item.text,
                          style: GoogleFonts.poppins(
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            color: _isDarkMode
                                ? Colors.white
                                : const Color(0xFF0F172A),
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Divider
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: _isDarkMode
                              ? const Color(0xFF334155)
                              : const Color(0xFFF1F5F9),
                        ),
                        const SizedBox(height: 8),

                        // Row 3: Target Chip (Left) + Edit & Delete Icons (Right)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _isDarkMode
                                    ? const Color(0xFF334155)
                                    : const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: _isDarkMode
                                      ? const Color(0xFF475569)
                                      : const Color(0xFFCBD5E1),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.open_in_new,
                                    size: 13,
                                    color: _isDarkMode
                                        ? Colors.grey.shade300
                                        : const Color(0xFF475569),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    item.linkTarget,
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: _isDarkMode
                                          ? Colors.grey.shade300
                                          : const Color(0xFF475569),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () => _navigateToEdit(item),
                                  borderRadius: BorderRadius.circular(4),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Icon(
                                      Icons.edit_outlined,
                                      size: 18,
                                      color: _isDarkMode
                                          ? Colors.grey.shade400
                                          : const Color(0xFF64748B),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                InkWell(
                                  onTap: () => _deleteItem(item),
                                  borderRadius: BorderRadius.circular(4),
                                  child: const Padding(
                                    padding: EdgeInsets.all(4),
                                    child: Icon(
                                      Icons.delete_outline,
                                      size: 18,
                                      color: Color(0xFFDC2626),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
