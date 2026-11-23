import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/crm_drawer.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/admin_profile_avatar.dart';

class AdminUser {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String status;
  final String createdAt;

  AdminUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.status = "Active",
    required this.createdAt,
  });
}

class AdministratorsScreen extends StatefulWidget {
  const AdministratorsScreen({super.key});

  @override
  State<AdministratorsScreen> createState() => _AdministratorsScreenState();
}

class _AdministratorsScreenState extends State<AdministratorsScreen> {
  bool _isDarkMode = false;
  String _searchQuery = "";
  String _activeStatusTab = "Approved"; // "Approved" or "UnApproved"
  int _entriesPerPage = 10;
  int _currentPage = 1;
  final TextEditingController _searchController = TextEditingController();

  final List<AdminUser> _admins = [
    AdminUser(
      id: "AFMC0188",
      name: "Test",
      email: "test123@gmail.com",
      phone: "+91 99999 88888",
      role: "Tele Caller Finance",
      status: "Active",
      createdAt: "20 Mar 2024",
    ),
    AdminUser(
      id: "AFMC0187",
      name: "VAAHAN BAZA – NITIN KHATRI",
      email: "nitink345@gmail.com",
      phone: "+91 98123 45678",
      role: "Dealer (Classified Business)",
      status: "Active",
      createdAt: "15 Mar 2024",
    ),
    AdminUser(
      id: "AFMC0186",
      name: "MANOJ NEGI",
      email: "mnegi4972@gmail.com",
      phone: "+91 98765 43210",
      role: "Sales Manager (Finance)",
      status: "Active",
      createdAt: "12 Jan 2024",
    ),
    AdminUser(
      id: "AFMC0185",
      name: "KARAN",
      email: "karanvivaan97@gmail.com",
      phone: "+91 98112 34567",
      role: "SM Finance Dehradun",
      status: "Active",
      createdAt: "18 Feb 2024",
    ),
    AdminUser(
      id: "AFMC0184",
      name: "GAURAV KUMAR CHAUHAN",
      email: "gauravchauhan672@gmail.com",
      phone: "+91 97234 56789",
      role: "Area Sales Manager (Finance)",
      status: "Active",
      createdAt: "05 Mar 2024",
    ),
    AdminUser(
      id: "AFMC0183",
      name: "AYESHA",
      email: "ayesha.finance@findmycarz.com",
      phone: "+91 98345 67890",
      role: "Finance Officer",
      status: "Active",
      createdAt: "22 Apr 2024",
    ),
    AdminUser(
      id: "AFMC0182",
      name: "VIKAS SINGH",
      email: "vikas.ops@findmycarz.com",
      phone: "+91 98111 22334",
      role: "Branch Executive",
      status: "UnApproved",
      createdAt: "Yesterday",
    ),
    AdminUser(
      id: "AFMC0181",
      name: "NEHA PATEL",
      email: "neha.finance@findmycarz.com",
      phone: "+91 97222 33445",
      role: "Loan Associate",
      status: "UnApproved",
      createdAt: "2 days ago",
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<AdminUser> get _filteredAdmins {
    final list = _admins.where((admin) {
      final matchesStatus = _activeStatusTab == "Approved"
          ? (admin.status.toLowerCase() == "approved" ||
              admin.status.toLowerCase() == "active")
          : admin.status.toLowerCase() == "unapproved";

      final matchesSearch = admin.name
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          admin.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          admin.phone.contains(_searchQuery) ||
          admin.role.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesStatus && matchesSearch;
    }).toList();

    return list.take(_entriesPerPage).toList();
  }

  void _showAddAdminModal() {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    String selectedRole = "Sales Manager (Finance)";
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
              ),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Add New Administrator",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _isDarkMode
                                  ? Colors.white
                                  : const Color(0xFF1E293B),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close,
                                color: _isDarkMode
                                    ? Colors.white70
                                    : Colors.black54),
                            onPressed: () => Navigator.pop(ctx),
                          ),
                        ],
                      ),
                      const Divider(),
                      const SizedBox(height: 10),
                      Text(
                        "Full Name",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _isDarkMode
                              ? Colors.grey.shade300
                              : const Color(0xFF334155),
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: nameCtrl,
                        decoration: _inputDecoration("Enter full name"),
                        style: TextStyle(
                            color: _isDarkMode ? Colors.white : Colors.black87),
                        validator: (v) =>
                            v == null || v.isEmpty ? "Name is required" : null,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        "Email Address",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _isDarkMode
                              ? Colors.grey.shade300
                              : const Color(0xFF334155),
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _inputDecoration("admin@example.com"),
                        style: TextStyle(
                            color: _isDarkMode ? Colors.white : Colors.black87),
                        validator: (v) =>
                            v == null || v.isEmpty ? "Email is required" : null,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        "Phone Number",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _isDarkMode
                              ? Colors.grey.shade300
                              : const Color(0xFF334155),
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: phoneCtrl,
                        keyboardType: TextInputType.phone,
                        decoration: _inputDecoration("+91 98765 43210"),
                        style: TextStyle(
                            color: _isDarkMode ? Colors.white : Colors.black87),
                        validator: (v) =>
                            v == null || v.isEmpty ? "Phone is required" : null,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        "Role",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _isDarkMode
                              ? Colors.grey.shade300
                              : const Color(0xFF334155),
                        ),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        initialValue: selectedRole,
                        dropdownColor: _isDarkMode
                            ? const Color(0xFF1E293B)
                            : Colors.white,
                        decoration: _inputDecoration("Select role"),
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: _isDarkMode ? Colors.white : Colors.black87,
                        ),
                        items: [
                          "Sales Manager (Finance)",
                          "SM Finance Dehradun",
                          "Area Sales Manager (Finance)",
                          "Finance Officer",
                          "Branch Admin",
                          "Super Admin"
                        ]
                            .map((r) => DropdownMenuItem(
                                  value: r,
                                  child: Text(r),
                                ))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setModalState(() => selectedRole = val);
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 46,
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState?.validate() == true) {
                              setState(() {
                                _admins.insert(
                                  0,
                                  AdminUser(
                                    id: "AFMC01${87 + _admins.length}",
                                    name: nameCtrl.text.trim().toUpperCase(),
                                    email: emailCtrl.text.trim(),
                                    phone: phoneCtrl.text.trim(),
                                    role: selectedRole,
                                    status: "Active",
                                    createdAt: "Today",
                                  ),
                                );
                              });
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "${nameCtrl.text.trim()} added successfully!",
                                    style: GoogleFonts.poppins(),
                                  ),
                                  backgroundColor: const Color(0xFF10B981),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E70CD),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "Add Administrator",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(
        fontSize: 13,
        color: _isDarkMode ? Colors.white38 : Colors.grey.shade400,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      filled: true,
      fillColor: _isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: _isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: _isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF1E70CD)),
      ),
    );
  }

  Widget _buildPageButton({
    required String text,
    bool isActive = false,
    bool isDots = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: isDots ? null : onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        constraints: const BoxConstraints(minWidth: 32),
        height: 32,
        margin: const EdgeInsets.only(right: 4),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF00A3FF)
              : (_isDarkMode ? const Color(0xFF1E293B) : Colors.white),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isActive
                ? const Color(0xFF00A3FF)
                : (_isDarkMode
                    ? const Color(0xFF334155)
                    : const Color(0xFFE2E8F0)),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: isActive
                ? Colors.white
                : (_isDarkMode
                    ? Colors.grey.shade300
                    : const Color(0xFF475569)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredAdmins;

    return Scaffold(
      backgroundColor:
          _isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      drawer: const CrmDrawer(),
      appBar: AppBar(
        backgroundColor: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        elevation: 0.5,
        leading: CustomBackButton(isDarkMode: _isDarkMode),
        title: Text(
          "All Administrators",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _isDarkMode ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        actions: [
          IconButton(
<<<<<<< HEAD
=======
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
>>>>>>> parent of 2e72acd (Merge pull request #5 from Saifazad/feat/api-suite-integration)
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Full-Width "+ Add New" button (Image 1 reference)
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton.icon(
                onPressed: _showAddAdminModal,
                icon: const Icon(Icons.add, size: 18, color: Colors.white),
                label: Text(
                  "Add New",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E70CD),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 14),

            // 2. Status Tabs: Approved (152) & UnApproved (2)
            Row(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _activeStatusTab = "Approved";
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: _activeStatusTab == "Approved"
                              ? const Color(0xFF00A3FF)
                              : Colors.transparent,
                          width: 2.2,
                        ),
                      ),
                    ),
                    child: Text(
                      "Approved (152)",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: _activeStatusTab == "Approved"
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: _activeStatusTab == "Approved"
                            ? (_isDarkMode
                                ? Colors.white
                                : const Color(0xFF1E293B))
                            : (_isDarkMode
                                ? Colors.grey.shade400
                                : const Color(0xFF64748B)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                InkWell(
                  onTap: () {
                    setState(() {
                      _activeStatusTab = "UnApproved";
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: _activeStatusTab == "UnApproved"
                              ? const Color(0xFF00A3FF)
                              : Colors.transparent,
                          width: 2.2,
                        ),
                      ),
                    ),
                    child: Text(
                      "UnApproved (2)",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: _activeStatusTab == "UnApproved"
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: _activeStatusTab == "UnApproved"
                            ? (_isDarkMode
                                ? Colors.white
                                : const Color(0xFF1E293B))
                            : (_isDarkMode
                                ? Colors.grey.shade400
                                : const Color(0xFF64748B)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // 3. Full-width Search Bar (Image 1 reference)
            Container(
              height: 44,
              decoration: BoxDecoration(
                color: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _isDarkMode
                      ? const Color(0xFF334155)
                      : const Color(0xFFE2E8F0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: _isDarkMode ? 0.2 : 0.02),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 14),
                  Icon(
                    Icons.search,
                    size: 18,
                    color: _isDarkMode
                        ? Colors.grey.shade400
                        : const Color(0xFF64748B),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) => setState(() => _searchQuery = val),
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: _isDarkMode ? Colors.white : Colors.black87,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: "Search administrators...",
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 13,
                          color: _isDarkMode
                              ? Colors.grey.shade500
                              : const Color(0xFF94A3B8),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  if (_searchQuery.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        setState(() => _searchQuery = "");
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(Icons.clear, size: 16, color: Colors.grey),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // 4. Entries per page Row (Image 1 reference)
            Row(
              children: [
                Container(
                  height: 34,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(8),
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
                      icon: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          size: 16,
                          color: _isDarkMode
                              ? Colors.white
                              : const Color(0xFF1E293B),
                        ),
                      ),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
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
                const SizedBox(width: 8),
                Text(
                  "entries per page",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: _isDarkMode
                        ? Colors.grey.shade400
                        : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // 5. Administrators Cards List (Matching Image 1 Format)
            if (filtered.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.person_off_outlined,
                          size: 40,
                          color: _isDarkMode
                              ? Colors.grey.shade600
                              : Colors.grey.shade400),
                      const SizedBox(height: 10),
                      Text(
                        "No Administrators Found",
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
                itemCount: filtered.length,
                itemBuilder: (ctx, index) {
                  final admin = filtered[index];
                  final words = admin.name.trim().split(RegExp(r'\s+'));
                  final String initials;
                  if (words.isEmpty || admin.name.trim().isEmpty) {
                    initials = "A";
                  } else if (words.length == 1) {
                    initials = words[0].length >= 2
                        ? words[0].substring(0, 2).toUpperCase()
                        : words[0].toUpperCase();
                  } else {
                    initials = words
                        .take(2)
                        .map((w) => w.isNotEmpty ? w[0] : '')
                        .join()
                        .toUpperCase();
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color:
                          _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
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
                        // Row 1: Avatar + Name / Role + Status Pill
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Circular Initials Badge with S.N. Badge
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFDBEAFE),
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    initials,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF1E40AF),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: -4,
                                  left: -4,
                                  child: Container(
                                    width: 18,
                                    height: 18,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0F172A),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: _isDarkMode
                                            ? const Color(0xFF1E293B)
                                            : Colors.white,
                                        width: 1.5,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "${index + 1}",
                                      style: GoogleFonts.poppins(
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        height: 1.1,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 12),

                            // Name & Role Subtitle
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    admin.name,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: _isDarkMode
                                          ? Colors.white
                                          : const Color(0xFF0F172A),
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    admin.role,
                                    style: GoogleFonts.poppins(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF0D9488),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Status Filled Pill
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: admin.status == "UnApproved"
                                    ? const Color(0xFFD97706)
                                    : const Color(0xFF059669),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                admin.status,
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Row 2: ID Badge & Email
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: _isDarkMode
                                    ? const Color(0xFF0F172A)
                                    : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                admin.id,
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: _isDarkMode
                                      ? Colors.grey.shade300
                                      : const Color(0xFF475569),
                                ),
                              ),
                            ),
                            Text(
                              admin.email,
                              style: GoogleFonts.poppins(
                                fontSize: 11.5,
                                color: _isDarkMode
                                    ? Colors.grey.shade400
                                    : const Color(0xFF475569),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Row 3: Action Buttons & Auto Login Button
                        Row(
                          children: [
                            // Edit Box
                            InkWell(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Edit ${admin.name}",
                                        style: GoogleFonts.poppins()),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: _isDarkMode
                                      ? const Color(0xFF0F172A)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: _isDarkMode
                                        ? const Color(0xFF334155)
                                        : const Color(0xFFCBD5E1),
                                  ),
                                ),
                                child: Icon(Icons.edit_outlined,
                                    size: 16,
                                    color: _isDarkMode
                                        ? Colors.white70
                                        : const Color(0xFF475569)),
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Delete Box
                            InkWell(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Delete ${admin.name}",
                                        style: GoogleFonts.poppins()),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: _isDarkMode
                                      ? const Color(0xFF0F172A)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: _isDarkMode
                                        ? const Color(0xFF334155)
                                        : const Color(0xFFCBD5E1),
                                  ),
                                ),
                                child: Icon(Icons.delete_outline,
                                    size: 16,
                                    color: _isDarkMode
                                        ? Colors.white70
                                        : const Color(0xFF475569)),
                              ),
                            ),
                            const SizedBox(width: 10),

                            // Full Auto Login Blue Button
                            Expanded(
                              child: SizedBox(
                                height: 36,
                                child: ElevatedButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            "Auto login as ${admin.name}",
                                            style: GoogleFonts.poppins()),
                                        backgroundColor:
                                            const Color(0xFF1E70CD),
                                        duration: const Duration(seconds: 1),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1E70CD),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    elevation: 0,
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: Text(
                                    "Auto Login",
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),

            // 6. Bottom Pagination Controls (Screenshot 1 Reference)
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 20),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final textWidget = Text(
                    "Showing 1 to ${_entriesPerPage < 152 ? _entriesPerPage : 152} of 152 entries",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: _isDarkMode
                          ? Colors.grey.shade400
                          : const Color(0xFF64748B),
                    ),
                  );

                  final paginationWidget = SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildPageButton(
                            text: "1",
                            isActive: _currentPage == 1,
                            onTap: () => setState(() => _currentPage = 1)),
                        _buildPageButton(
                            text: "2",
                            isActive: _currentPage == 2,
                            onTap: () => setState(() => _currentPage = 2)),
                        _buildPageButton(
                            text: "3",
                            isActive: _currentPage == 3,
                            onTap: () => setState(() => _currentPage = 3)),
                        _buildPageButton(
                            text: "4",
                            isActive: _currentPage == 4,
                            onTap: () => setState(() => _currentPage = 4)),
                        _buildPageButton(
                            text: "5",
                            isActive: _currentPage == 5,
                            onTap: () => setState(() => _currentPage = 5)),
                        _buildPageButton(
                            text: "6",
                            isActive: _currentPage == 6,
                            onTap: () => setState(() => _currentPage = 6)),
                        _buildPageButton(
                            text: "7",
                            isActive: _currentPage == 7,
                            onTap: () => setState(() => _currentPage = 7)),
                        _buildPageButton(text: "...", isDots: true),
                        _buildPageButton(
                            text: "16",
                            isActive: _currentPage == 16,
                            onTap: () => setState(() => _currentPage = 16)),
                        _buildPageButton(
                          text: "›",
                          onTap: () {
                            if (_currentPage < 16) {
                              setState(() => _currentPage++);
                            }
                          },
                        ),
                      ],
                    ),
                  );

                  if (constraints.maxWidth > 580) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        textWidget,
                        paginationWidget,
                      ],
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textWidget,
                        const SizedBox(height: 10),
                        paginationWidget,
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
