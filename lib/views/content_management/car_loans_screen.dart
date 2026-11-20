import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/crm_drawer.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/admin_profile_avatar.dart';

class CarLoanContentItem {
  final String id;
  String title;
  String category;
  String publishedDate;
  bool isActive;
  String description;

  CarLoanContentItem({
    required this.id,
    required this.title,
    required this.category,
    required this.publishedDate,
    required this.isActive,
    this.description = "",
  });
}

class CarLoansScreen extends StatefulWidget {
  const CarLoansScreen({super.key});

  @override
  State<CarLoansScreen> createState() => _CarLoansScreenState();
}

class _CarLoansScreenState extends State<CarLoansScreen> {
  bool _isDarkMode = false;
  int _entriesPerPage = 10;
  String _searchQuery = "";

  final TextEditingController _searchController = TextEditingController();

  final List<CarLoanContentItem> _loanContents = [
    CarLoanContentItem(
      id: "LOAN-001",
      title: "Sale Purchase",
      category: "Used Car Loan",
      publishedDate: "08 Dec, 2025",
      isActive: true,
      description: "Quick finance for pre-owned car purchase with low interest rates.",
    ),
    CarLoanContentItem(
      id: "LOAN-002",
      title: "New Car Loan",
      category: "New Car Loan",
      publishedDate: "08 Dec, 2025",
      isActive: true,
      description: "Up to 100% on-road funding for brand new cars from top banks.",
    ),
    CarLoanContentItem(
      id: "LOAN-003",
      title: "BT + Topup Car Loan",
      category: "Used Car Loan",
      publishedDate: "08 Dec, 2025",
      isActive: true,
      description: "Balance transfer your existing car loan and get extra top-up cash.",
    ),
    CarLoanContentItem(
      id: "LOAN-004",
      title: "Refinance",
      category: "Used Car Loan",
      publishedDate: "08 Dec, 2025",
      isActive: true,
      description: "Unlock cash against your fully paid car with quick refinance approval.",
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CarLoanContentItem> get _filteredList {
    if (_searchQuery.trim().isEmpty) return _loanContents;
    final q = _searchQuery.toLowerCase();
    return _loanContents.where((item) {
      return item.title.toLowerCase().contains(q) ||
          item.category.toLowerCase().contains(q) ||
          item.publishedDate.toLowerCase().contains(q) ||
          item.description.toLowerCase().contains(q);
    }).toList();
  }

  void _showAddDialog() {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String category = "Used Car Loan";
    bool isActive = true;

    final categories = ["Used Car Loan", "New Car Loan", "BT + Topup", "Refinance"];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor:
              _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            "Add New Loan Content",
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
                  "Loan Content Title",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color:
                        _isDarkMode ? Colors.white70 : const Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: titleCtrl,
                  decoration: InputDecoration(
                    hintText: "e.g. Sale Purchase, Refinance",
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
                  "Category",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color:
                        _isDarkMode ? Colors.white70 : const Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: category,
                  dropdownColor:
                      _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                  items: categories.map((cat) {
                    return DropdownMenuItem(
                      value: cat,
                      child: Text(cat, style: GoogleFonts.poppins(fontSize: 12)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setDialogState(() {
                        category = val;
                      });
                    }
                  },
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
                  "Description (Optional)",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color:
                        _isDarkMode ? Colors.white70 : const Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: descCtrl,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: "Enter short description...",
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
                if (titleCtrl.text.trim().isEmpty) return;
                setState(() {
                  _loanContents.insert(
                    0,
                    CarLoanContentItem(
                      id: "LOAN-${DateTime.now().millisecondsSinceEpoch}",
                      title: titleCtrl.text.trim(),
                      category: category,
                      publishedDate: "Today",
                      isActive: isActive,
                      description: descCtrl.text.trim(),
                    ),
                  );
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Loan content added successfully!"),
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

  void _showEditDialog(CarLoanContentItem item) {
    final titleCtrl = TextEditingController(text: item.title);
    final descCtrl = TextEditingController(text: item.description);
    String category = item.category;
    bool isActive = item.isActive;

    final categories = ["Used Car Loan", "New Car Loan", "BT + Topup", "Refinance"];
    if (!categories.contains(category)) {
      categories.add(category);
    }

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor:
              _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            "Edit Loan Content",
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
                  "Loan Content Title",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color:
                        _isDarkMode ? Colors.white70 : const Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: titleCtrl,
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
                  "Category",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color:
                        _isDarkMode ? Colors.white70 : const Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: category,
                  dropdownColor:
                      _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                  items: categories.map((cat) {
                    return DropdownMenuItem(
                      value: cat,
                      child: Text(cat, style: GoogleFonts.poppins(fontSize: 12)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setDialogState(() {
                        category = val;
                      });
                    }
                  },
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
                  "Description (Optional)",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color:
                        _isDarkMode ? Colors.white70 : const Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: descCtrl,
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
                  item.title = titleCtrl.text.trim();
                  item.category = category;
                  item.description = descCtrl.text.trim();
                  item.isActive = isActive;
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Loan content updated successfully!"),
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

  void _deleteLoanContent(CarLoanContentItem item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        title: Text(
          "Delete Loan Content",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: _isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        content: Text(
          "Are you sure you want to delete '${item.title}'?",
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
                _loanContents.removeWhere((l) => l.id == item.id);
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Loan content deleted successfully!"),
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
          "Admin Dashboard",
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
            // 1. Heading: Manage Car Loans
            Text(
              "Manage Car Loans",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _isDarkMode ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 12),

            // 2. Full-Width "+ Add New Loan Content" Button
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
                  "+ Add New Loan Content",
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 3. Subheading: "All Car Loan Contents"
            Text(
              "All Car Loan Contents",
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

            // 5. Loan Content Cards List
            if (displayedList.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.directions_car_outlined,
                        size: 44,
                        color: _isDarkMode
                            ? Colors.grey.shade600
                            : Colors.grey.shade400,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "No Car Loan Contents Found",
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
                        // Row 1: Badges Row (#S.N. + Category Badge on Left, Active Badge on Right)
                        Row(
                          children: [
                            // #S.N. Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: _isDarkMode
                                    ? const Color(0xFF334155)
                                    : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(4),
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
                            const SizedBox(width: 8),

                            // Category Badge (e.g. "Used Car Loan", "New Car Loan")
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2.5),
                              decoration: BoxDecoration(
                                color: _isDarkMode
                                    ? const Color(0xFF134E4A)
                                    : const Color(0xFFCCFBF1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                item.category,
                                style: GoogleFonts.poppins(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.bold,
                                  color: _isDarkMode
                                      ? const Color(0xFF5EEAD4)
                                      : const Color(0xFF0F766E),
                                ),
                              ),
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

                        // Title
                        Text(
                          item.title,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: _isDarkMode
                                ? Colors.white
                                : const Color(0xFF0F172A),
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

                        // Row 3: Published Date (Left) + Edit & Delete Icons (Right)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Published ${item.publishedDate}",
                              style: GoogleFonts.poppins(
                                fontSize: 11,
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
                                  onTap: () => _deleteLoanContent(item),
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
