import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/crm_drawer.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/admin_profile_avatar.dart';

class TestimonialItem {
  final String id;
  String name;
  int rating;
  bool isActive;
  String feedback;

  TestimonialItem({
    required this.id,
    required this.name,
    required this.rating,
    required this.isActive,
    this.feedback = "",
  });
}

class TestimonialsScreen extends StatefulWidget {
  const TestimonialsScreen({super.key});

  @override
  State<TestimonialsScreen> createState() => _TestimonialsScreenState();
}

class _TestimonialsScreenState extends State<TestimonialsScreen> {
  bool _isDarkMode = false;
  int _entriesPerPage = 10;
  String _searchQuery = "";

  final TextEditingController _searchController = TextEditingController();

  final List<TestimonialItem> _testimonials = [
    TestimonialItem(
      id: "TEST-001",
      name: "Sameer Chaudhary",
      rating: 5,
      isActive: true,
      feedback: "Great service and seamless car purchase experience!",
    ),
    TestimonialItem(
      id: "TEST-002",
      name: "Saurabh",
      rating: 5,
      isActive: true,
      feedback: "Quick loan approval and very helpful staff.",
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<TestimonialItem> get _filteredList {
    if (_searchQuery.trim().isEmpty) return _testimonials;
    final q = _searchQuery.toLowerCase();
    return _testimonials.where((item) {
      return item.name.toLowerCase().contains(q) ||
          item.feedback.toLowerCase().contains(q);
    }).toList();
  }

  void _showAddDialog() {
    final nameCtrl = TextEditingController();
    final feedbackCtrl = TextEditingController();
    int rating = 5;
    bool isActive = true;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor:
              _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            "Add New Testimonial",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: _isDarkMode ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Customer Name",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color:
                        _isDarkMode ? Colors.white70 : const Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    hintText: "Enter customer name...",
                    hintStyle: GoogleFonts.poppins(fontSize: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Rating (Stars)",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color:
                        _isDarkMode ? Colors.white70 : const Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: List.generate(5, (index) {
                    final starNum = index + 1;
                    return InkWell(
                      onTap: () {
                        setDialogState(() {
                          rating = starNum;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Icon(
                          starNum <= rating
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          size: 28,
                          color: const Color(0xFFF59E0B),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 12),
                Text(
                  "Review / Feedback",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color:
                        _isDarkMode ? Colors.white70 : const Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: feedbackCtrl,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: "Enter customer feedback...",
                    hintStyle: GoogleFonts.poppins(fontSize: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Status: ${isActive ? 'Active' : 'Inactive'}",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isActive
                            ? const Color(0xFF0F766E)
                            : const Color(0xFFDC2626),
                      ),
                    ),
                    Switch(
                      value: isActive,
                      activeThumbColor: const Color(0xFF00A3FF),
                      onChanged: (val) {
                        setDialogState(() {
                          isActive = val;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E6FD9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                if (nameCtrl.text.trim().isEmpty) return;
                setState(() {
                  _testimonials.insert(
                    0,
                    TestimonialItem(
                      id: "TEST-${DateTime.now().millisecondsSinceEpoch}",
                      name: nameCtrl.text.trim(),
                      rating: rating,
                      isActive: isActive,
                      feedback: feedbackCtrl.text.trim(),
                    ),
                  );
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Testimonial added successfully!"),
                    backgroundColor: Color(0xFF0F766E),
                  ),
                );
              },
              child: const Text("Add",
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(TestimonialItem item) {
    final nameCtrl = TextEditingController(text: item.name);
    final feedbackCtrl = TextEditingController(text: item.feedback);
    int rating = item.rating;
    bool isActive = item.isActive;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor:
              _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            "Edit Testimonial",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: _isDarkMode ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Customer Name",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color:
                        _isDarkMode ? Colors.white70 : const Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Rating (Stars)",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color:
                        _isDarkMode ? Colors.white70 : const Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: List.generate(5, (index) {
                    final starNum = index + 1;
                    return InkWell(
                      onTap: () {
                        setDialogState(() {
                          rating = starNum;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Icon(
                          starNum <= rating
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          size: 28,
                          color: const Color(0xFFF59E0B),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 12),
                Text(
                  "Review / Feedback",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color:
                        _isDarkMode ? Colors.white70 : const Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: feedbackCtrl,
                  maxLines: 2,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Status: ${isActive ? 'Active' : 'Inactive'}",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isActive
                            ? const Color(0xFF0F766E)
                            : const Color(0xFFDC2626),
                      ),
                    ),
                    Switch(
                      value: isActive,
                      activeThumbColor: const Color(0xFF00A3FF),
                      onChanged: (val) {
                        setDialogState(() {
                          isActive = val;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E6FD9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                setState(() {
                  item.name = nameCtrl.text.trim();
                  item.rating = rating;
                  item.feedback = feedbackCtrl.text.trim();
                  item.isActive = isActive;
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Testimonial updated successfully!"),
                    backgroundColor: Color(0xFF1E6FD9),
                  ),
                );
              },
              child: const Text("Save",
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteTestimonial(TestimonialItem item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        title: Text(
          "Delete Testimonial",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: _isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        content: Text(
          "Are you sure you want to delete testimonial by '${item.name}'?",
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
                _testimonials.removeWhere((t) => t.id == item.id);
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Testimonial deleted successfully!"),
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
    final filtered = _filteredList;
    final displayedList = filtered.take(_entriesPerPage).toList();

    return Scaffold(
      backgroundColor:
          _isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      drawer: const CrmDrawer(),
      appBar: AppBar(
        backgroundColor: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        elevation: 0.5,
        leading: CustomBackButton(isDarkMode: _isDarkMode),
        title: Text(
          "Testimonials",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _isDarkMode ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        actions: [
          IconButton(
            tooltip: _isDarkMode ? "Switch to Light Mode" : "Switch to Dark Mode",
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
            // 1. Heading: Manage Testimonials
            Text(
              "Manage Testimonials",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _isDarkMode ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 12),

            // 2. Full-Width "+ Add New Testimonial" Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _showAddDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E6FD9),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "+ Add New Testimonial",
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 3. Subheading: "All Testimonials"
            Text(
              "All Testimonials",
              style: GoogleFonts.poppins(
                fontSize: 13.5,
                fontWeight: FontWeight.bold,
                color: _isDarkMode ? Colors.grey.shade300 : const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 10),

            // 4. Search and Entries Row: [ 🔍 Search... ] [ 10 ⌄ ]
            Row(
              children: [
                // Search TextField
                Expanded(
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color:
                          _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _isDarkMode
                            ? const Color(0xFF334155)
                            : const Color(0xFFCBD5E1),
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val;
                        });
                      },
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: _isDarkMode ? Colors.white : Colors.black87,
                      ),
                      decoration: InputDecoration(
                        hintText: "Search...",
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 12.5,
                          color: _isDarkMode
                              ? Colors.white38
                              : Colors.grey.shade400,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          size: 18,
                          color: _isDarkMode
                              ? Colors.white54
                              : Colors.grey.shade500,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Dropdown [ 10 ⌄ ]
                Container(
                  height: 42,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color:
                        _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _isDarkMode
                          ? const Color(0xFF334155)
                          : const Color(0xFFCBD5E1),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: _entriesPerPage,
                      dropdownColor:
                          _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        size: 18,
                        color: _isDarkMode
                            ? Colors.white
                            : const Color(0xFF1E293B),
                      ),
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _isDarkMode
                            ? Colors.white
                            : const Color(0xFF1E293B),
                      ),
                      items: [10, 25, 50, 100].map((int val) {
                        return DropdownMenuItem<int>(
                          value: val,
                          child: Text("$val"),
                        );
                      }).toList(),
                      onChanged: (int? newVal) {
                        if (newVal != null) {
                          setState(() {
                            _entriesPerPage = newVal;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // 5. Testimonial Cards List
            if (displayedList.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.chat_bubble_outline_rounded,
                        size: 44,
                        color: _isDarkMode
                            ? Colors.grey.shade600
                            : Colors.grey.shade400,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "No Testimonials Found",
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
                itemCount: displayedList.length,
                itemBuilder: (ctx, index) {
                  final item = displayedList[index];

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
                        // Row: Avatar + (Badges & Name & Stars)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Circular Avatar with First Letter
                            CircleAvatar(
                              radius: 22,
                              backgroundColor: _isDarkMode
                                  ? const Color(0xFF334155)
                                  : const Color(0xFFE2E8F0),
                              child: Text(
                                item.name.isNotEmpty
                                    ? item.name[0].toUpperCase()
                                    : "S",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: _isDarkMode
                                      ? Colors.white70
                                      : const Color(0xFF475569),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Badges & Name & Stars
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Badges: #S.N. + Active/Inactive
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: _isDarkMode
                                              ? const Color(0xFF334155)
                                              : const Color(0xFFF1F5F9),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          "#${index + 1}",
                                          style: GoogleFonts.poppins(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.bold,
                                            color: _isDarkMode
                                                ? Colors.white70
                                                : const Color(0xFF334155),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: item.isActive
                                              ? const Color(0xFF0F766E) // Teal/Green
                                              : const Color(0xFFDC2626), // Red
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          item.isActive
                                              ? "Active"
                                              : "Inactive",
                                          style: GoogleFonts.poppins(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),

                                  // Customer Name
                                  Text(
                                    item.name,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.bold,
                                      color: _isDarkMode
                                          ? Colors.white
                                          : const Color(0xFF0F172A),
                                    ),
                                  ),
                                  const SizedBox(height: 4),

                                  // Gold Rating Stars
                                  Row(
                                    children: List.generate(5, (starIdx) {
                                      return Icon(
                                        starIdx < item.rating
                                            ? Icons.star_rounded
                                            : Icons.star_outline_rounded,
                                        size: 18,
                                        color: const Color(0xFFF59E0B),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
                        const SizedBox(height: 6),

                        // Card Footer: Action Label + Action Icons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Action",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _isDarkMode
                                    ? Colors.grey.shade400
                                    : const Color(0xFF64748B),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () => _showEditDialog(item),
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
                                  onTap: () => _deleteTestimonial(item),
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

            // 6. Bottom Showing Entries
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 20),
              child: Center(
                child: Text(
                  "Showing 1 to ${displayedList.length} of ${filtered.length} entries",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: _isDarkMode
                        ? Colors.grey.shade400
                        : const Color(0xFF64748B),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
