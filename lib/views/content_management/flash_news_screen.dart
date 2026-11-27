import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
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
  bool _isDarkMode = false;

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
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        backgroundColor: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Red Header
            Container(
              color: const Color(0xFFF43F5E),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Confirm Delete?",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(ctx),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            // Body Content
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "This action cannot be undone. Checks for dependencies will be performed.",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: _isDarkMode
                          ? Colors.grey.shade300
                          : const Color(0xFF475569),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF94A3B8),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF4444),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: Text(
                          "Delete",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          _isDarkMode ? const Color(0xFF0F172A) : AppColors.background,
      drawer: const CrmDrawer(),
      appBar: AppBar(
        backgroundColor: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        elevation: 0.5,
        leading: CustomBackButton(isDarkMode: _isDarkMode),
        titleSpacing: 0,
        title: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            "Flash News",
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _flashItems.isEmpty
                        ? "No Announcements"
                        : _flashItems.length == 1
                            ? "1 Announcement"
                            : "${_flashItems.length} Announcements",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _isDarkMode ? Colors.white : AppColors.text,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 38,
                  child: ElevatedButton.icon(
                    onPressed: _navigateToAdd,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.add, size: 16, color: Colors.white),
                    label: Text(
                      "Add New",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 4. Flash Items List
          Expanded(
            child: _flashItems.isEmpty
                ? Padding(
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
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                    itemCount: _flashItems.length,
                    itemBuilder: (ctx, index) {
                      final item = _flashItems[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: _isDarkMode
                              ? const Color(0xFF1E293B)
                              : Colors.white,
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
                            // Row 1: Badges Row (Order 0 + T Text Only on Left, ● Active on Right)
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
                                    borderRadius: BorderRadius.circular(6),
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

                                // T Text Only
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "T",
                                      style: TextStyle(
                                        fontFamily: 'serif',
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w600,
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

                                // Active / Inactive Badge with Bullet Dot
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 9, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: item.isActive
                                        ? AppColors.chipActiveBg
                                        : AppColors.chipInactiveBg,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          color: item.isActive
                                              ? AppColors.chipActiveText
                                              : AppColors.chipInactiveText,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        item.isActive ? "Active" : "Inactive",
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: item.isActive
                                              ? AppColors.chipActiveText
                                              : AppColors.chipInactiveText,
                                        ),
                                      ),
                                    ],
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
                                          color: AppColors.danger,
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
          ),
        ],
      ),
    );
  }
}
