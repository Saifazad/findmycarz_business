import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/crm_drawer.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/admin_profile_avatar.dart';

class RegisteredUser {
  final String id;
  String name;
  String email;
  String phone;
  String city;
  String registrationDate;
  String status;

  RegisteredUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.city,
    required this.registrationDate,
    this.status = "Active",
  });
}

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  bool _isDarkMode = false;
  final int _entriesPerPage = 10;
  String _searchQuery = "";

  final TextEditingController _searchController = TextEditingController();

  late final PagingController<int, RegisteredUser> _pagingController =
      PagingController(
    getNextPageKey: (state) {
      if (state.keys == null || state.keys!.isEmpty) return 1;
      final lastPage = state.pages?.last;
      if (lastPage == null || lastPage.length < _entriesPerPage) return null;
      return (state.keys!.last) + 1;
    },
    fetchPage: (pageKey) async {
      final allFiltered = _filteredUsers;
      final startIndex = (pageKey - 1) * _entriesPerPage;
      if (startIndex >= allFiltered.length) return [];
      final endIndex =
          (startIndex + _entriesPerPage).clamp(0, allFiltered.length);
      return allFiltered.sublist(startIndex, endIndex);
    },
  );

  final List<RegisteredUser> _users = [
    RegisteredUser(
      id: "USR-001",
      name: "test",
      email: "testt2@gmail.com",
      phone: "7079622295",
      city: "HYD",
      registrationDate: "12 Nov, 2026",
      status: "Active",
    ),
    RegisteredUser(
      id: "USR-002",
      name: "Rahul Verma",
      email: "rahul.verma@gmail.com",
      phone: "9876543210",
      city: "DEL",
      registrationDate: "10 Nov, 2026",
      status: "Active",
    ),
    RegisteredUser(
      id: "USR-003",
      name: "Sameer Khan",
      email: "sameer.khan@yahoo.com",
      phone: "9812345678",
      city: "MUM",
      registrationDate: "08 Nov, 2026",
      status: "Active",
    ),
    RegisteredUser(
      id: "USR-004",
      name: "Pooja Sharma",
      email: "pooja.sharma@outlook.com",
      phone: "9765432109",
      city: "BLR",
      registrationDate: "05 Nov, 2026",
      status: "Active",
    ),
    RegisteredUser(
      id: "USR-005",
      name: "Amit Patel",
      email: "amit.patel@gmail.com",
      phone: "9654321098",
      city: "AHM",
      registrationDate: "01 Nov, 2026",
      status: "Active",
    ),
  ];

  @override
  void dispose() {
    _pagingController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<RegisteredUser> get _filteredUsers {
    if (_searchQuery.trim().isEmpty) return _users;
    final q = _searchQuery.toLowerCase();
    return _users.where((u) {
      return u.id.toLowerCase().contains(q) ||
          u.name.toLowerCase().contains(q) ||
          u.email.toLowerCase().contains(q) ||
          u.phone.contains(q) ||
          u.city.toLowerCase().contains(q) ||
          u.status.toLowerCase().contains(q);
    }).toList();
  }

  void _deleteUser(RegisteredUser user) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        clipBehavior: Clip.antiAlias,
        backgroundColor: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              color: const Color(0xFFEF4D56),
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
              child: Text(
                "This action cannot be undone. Checks for dependencies will be performed.",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: _isDarkMode ? Colors.white70 : const Color(0xFF4A5568),
                  height: 1.4,
                ),
              ),
            ),
            // Actions
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF95A0C5),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      minimumSize: const Size(74, 36),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(
                      "Cancel",
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF4D56),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      minimumSize: const Size(70, 36),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _users.removeWhere((u) => u.id == user.id);
                      });
                      _pagingController.refresh();
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text("User '${user.name}' deleted successfully!"),
                          backgroundColor: const Color(0xFFDC2626),
                        ),
                      );
                    },
                    child: Text(
                      "Delete",
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
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
  }

  void _showUserDetails(RegisteredUser user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "User Details",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color:
                          _isDarkMode ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildModalDetailRow("User ID", user.id),
              _buildModalDetailRow("Full Name", user.name),
              _buildModalDetailRow("Email", user.email),
              _buildModalDetailRow("Phone", user.phone),
              _buildModalDetailRow("City / Location", user.city),
              _buildModalDetailRow("Status", user.status),
              _buildModalDetailRow("Joined On", user.registrationDate),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00A3FF),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(
                    "Close",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModalDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: _isDarkMode
                    ? Colors.grey.shade400
                    : const Color(0xFF64748B),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 12.5,
                fontWeight: FontWeight.bold,
                color: _isDarkMode ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
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
          "Users",
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Heading: "Registered Users"
                Text(
                  "Registered Users",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _isDarkMode ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 14),

                // 2. Search TextField (Full Width)
                TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                    _pagingController.refresh();
                  },
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: _isDarkMode ? Colors.white : Colors.black87,
                  ),
                  decoration: InputDecoration(
                    hintText: "Search registered users...",
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 13,
                      color: const Color(0xFF94A3B8),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 20,
                      color: _isDarkMode
                          ? Colors.grey.shade400
                          : const Color(0xFF003366),
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = "";
                              });
                              _pagingController.refresh();
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: _isDarkMode
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF8FAFC),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: _isDarkMode
                            ? const Color(0xFF334155)
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: _isDarkMode
                            ? const Color(0xFF334155)
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: _isDarkMode
                            ? const Color(0xFF00A3FF)
                            : const Color(0xFF003366),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 3. Registered Users Cards List (without checkboxes)
          Expanded(
            child: PagingListener<int, RegisteredUser>(
              controller: _pagingController,
              builder: (context, state, fetchNextPage) => RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () => Future.sync(() => _pagingController.refresh()),
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                      sliver: PagedSliverList<int, RegisteredUser>(
                        state: state,
                        fetchNextPage: fetchNextPage,
                        builderDelegate:
                            PagedChildBuilderDelegate<RegisteredUser>(
                          itemBuilder: (ctx, user, index) =>
                              _buildUserCard(user, index),
                          noItemsFoundIndicatorBuilder: (ctx) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.groups_outlined,
                                    size: 44,
                                    color: _isDarkMode
                                        ? Colors.grey.shade600
                                        : Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "No Registered Users Found",
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
                          ),
                          firstPageProgressIndicatorBuilder: (ctx) =>
                              const Padding(
                            padding: EdgeInsets.symmetric(vertical: 30),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          newPageProgressIndicatorBuilder: (ctx) =>
                              const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(RegisteredUser user, int index) {
    final sn = index + 1;

    // Generate user initials for avatar
    final nameWords = user.name.trim().split(RegExp(r'\s+'));
    final String initials;
    if (nameWords.isEmpty || user.name.trim().isEmpty) {
      initials = "U";
    } else if (nameWords.length == 1) {
      initials = nameWords[0].length >= 2
          ? nameWords[0].substring(0, 2).toUpperCase()
          : nameWords[0].toUpperCase();
    } else {
      initials = (nameWords[0][0] + nameWords[1][0]).toUpperCase();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color:
              _isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: _isDarkMode ? 0.2 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Avatar + (Name & City & Joined) + Status Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Circular Avatar with S.N. Badge
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isDarkMode
                          ? const Color(0xFF0F2B48)
                          : const Color(0xFFEFF6FF),
                      border: Border.all(
                        color: _isDarkMode
                            ? const Color(0xFF1D4ED8)
                            : const Color(0xFFBFDBFE),
                        width: 1.2,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      initials,
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF00A3FF),
                      ),
                    ),
                  ),
                  Positioned(
                    top: -4,
                    left: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _isDarkMode
                              ? const Color(0xFF1E293B)
                              : Colors.white,
                          width: 1.2,
                        ),
                      ),
                      child: Text(
                        "#$sn",
                        style: GoogleFonts.poppins(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),

              // User Name, City Chip & Joined Date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => _showUserDetails(user),
                      child: Text(
                        user.name,
                        style: GoogleFonts.poppins(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: _isDarkMode
                              ? Colors.white
                              : const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: _isDarkMode
                                ? const Color(0xFF0F172A)
                                : const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: _isDarkMode
                                  ? const Color(0xFF334155)
                                  : const Color(0xFFDBEAFE),
                            ),
                          ),
                          child: Text(
                            user.city,
                            style: GoogleFonts.poppins(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2563EB),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Joined ${user.registrationDate}",
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: _isDarkMode
                                ? Colors.grey.shade400
                                : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Status Badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
                decoration: BoxDecoration(
                  color: user.status == "Active"
                      ? const Color(0xFF0F766E)
                      : const Color(0xFFDC2626),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  user.status,
                  style: GoogleFonts.poppins(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Divider
          Divider(
            height: 1,
            thickness: 1,
            color:
                _isDarkMode ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
          ),
          const SizedBox(height: 10),

          // Row 2: Phone & Email with Icons + Delete Button
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Phone Row
                    Row(
                      children: [
                        Icon(
                          Icons.phone_outlined,
                          size: 14,
                          color: _isDarkMode
                              ? const Color(0xFF60A5FA)
                              : const Color(0xFF0284C7),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          user.phone,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: _isDarkMode
                                ? Colors.white70
                                : const Color(0xFF334155),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Email Row
                    Row(
                      children: [
                        Icon(
                          Icons.mail_outline_rounded,
                          size: 14,
                          color: _isDarkMode
                              ? Colors.grey.shade400
                              : const Color(0xFF64748B),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            user.email,
                            style: GoogleFonts.poppins(
                              fontSize: 11.5,
                              color: _isDarkMode
                                  ? Colors.grey.shade400
                                  : const Color(0xFF64748B),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Delete Action Button
              InkWell(
                onTap: () => _deleteUser(user),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _isDarkMode
                        ? const Color(0xFF3E1D24)
                        : const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _isDarkMode
                          ? const Color(0xFF7F1D1D)
                          : const Color(0xFFFEE2E2),
                    ),
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    size: 18,
                    color: Color(0xFFDC2626),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
