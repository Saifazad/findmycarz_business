import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/crm_drawer.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/admin_profile_avatar.dart';

class ContactEnquiry {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String city;
  final String date;
  final String message;
  bool isSelected;

  ContactEnquiry({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.city,
    required this.date,
    required this.message,
    this.isSelected = false,
  });
}

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  bool _isDarkMode = false;
  final int _entriesPerPage = 10;
  String _searchQuery = "";
  bool _selectAll = false;

  final TextEditingController _searchController = TextEditingController();

  late final PagingController<int, ContactEnquiry> _pagingController =
      PagingController(
    getNextPageKey: (state) {
      if (state.keys == null || state.keys!.isEmpty) return 1;
      final lastPage = state.pages?.last;
      if (lastPage == null || lastPage.length < _entriesPerPage) return null;
      return (state.keys!.last) + 1;
    },
    fetchPage: (pageKey) async {
      final allFiltered = _filteredEnquiries;
      final startIndex = (pageKey - 1) * _entriesPerPage;
      if (startIndex >= allFiltered.length) return [];
      final endIndex =
          (startIndex + _entriesPerPage).clamp(0, allFiltered.length);
      return allFiltered.sublist(startIndex, endIndex);
    },
  );

  final List<ContactEnquiry> _enquiries = [
    ContactEnquiry(
      id: "ENQ-001",
      name: "Security Test",
      phone: "9876543210",
      email: "sectest2026@proton.me",
      city: "--",
      date: "17 Oct, 2026 13:43",
      message: "Security audit and penetration testing enquiry for portal.",
    ),
    ContactEnquiry(
      id: "ENQ-002",
      name: "faiz",
      phone: "7078451278",
      email: "faz@gmail.com",
      city: "muz",
      date: "09 Jun, 2026 15:34",
      message:
          "Looking for used Swift or i20 in good condition with financing.",
    ),
    ContactEnquiry(
      id: "ENQ-003",
      name: "Aadil",
      phone: "8533872922",
      email: "findmycarz01@gmail.com",
      city: "Dehradun",
      date: "18 May, 2026 15:01",
      message:
          "Interested in dealer partnership and inventory listing integration.",
    ),
    ContactEnquiry(
      id: "ENQ-004",
      name: "saif",
      phone: "4230923333",
      email: "ilzymplyp@cloud-temp.com",
      city: "delhi",
      date: "08 May, 2026 12:29",
      message:
          "Inquiring about car finance interest rates and down payment terms.",
    ),
    ContactEnquiry(
      id: "ENQ-005",
      name: "faix",
      phone: "7077095678",
      email: "john@gmail.com",
      city: "Delhi",
      date: "08 May, 2026 12:03",
      message:
          "Need quotation for comprehensive insurance renewal and warranty package.",
    ),
  ];

  @override
  void dispose() {
    _pagingController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<ContactEnquiry> get _filteredEnquiries {
    if (_searchQuery.trim().isEmpty) return _enquiries;
    final q = _searchQuery.toLowerCase();
    return _enquiries.where((item) {
      return item.name.toLowerCase().contains(q) ||
          item.phone.contains(q) ||
          item.email.toLowerCase().contains(q) ||
          item.city.toLowerCase().contains(q) ||
          item.message.toLowerCase().contains(q);
    }).toList();
  }

  int get _selectedCount => _enquiries.where((e) => e.isSelected).length;

  void _deleteSelected() {
    final count = _selectedCount;
    if (count == 0) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        title: Text(
          "Delete Selected Enquiries",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: _isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        content: Text(
          "Are you sure you want to delete $count selected enquiry(ies)?",
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
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626)),
            onPressed: () {
              setState(() {
                _enquiries.removeWhere((e) => e.isSelected);
                _selectAll = false;
              });
              _pagingController.refresh();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("$count enquiry(ies) deleted successfully!"),
                  backgroundColor: const Color(0xFFDC2626),
                ),
              );
            },
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _deleteSingleEnquiry(ContactEnquiry enquiry) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        title: Text(
          "Delete Enquiry",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: _isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        content: Text(
          "Are you sure you want to delete enquiry from ${enquiry.name}?",
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
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626)),
            onPressed: () {
              setState(() {
                _enquiries.removeWhere((e) => e.id == enquiry.id);
                if (_enquiries.isEmpty) {
                  _selectAll = false;
                } else {
                  _selectAll = _enquiries.every((e) => e.isSelected);
                }
              });
              _pagingController.refresh();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Enquiry deleted successfully!"),
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

  void _viewEnquiryDetails(ContactEnquiry enquiry) {
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
                    "Enquiry Details",
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
              _buildDetailRow("Name", enquiry.name),
              _buildDetailRow("Phone", enquiry.phone),
              _buildDetailRow("Email", enquiry.email),
              _buildDetailRow("City", enquiry.city),
              _buildDetailRow("Date & Time", enquiry.date),
              _buildDetailRow("Message", enquiry.message),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
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
    final filtered = _filteredEnquiries;
    final displayedEnquiries = filtered.take(_entriesPerPage).toList();

    return Scaffold(
      backgroundColor:
          _isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
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
            "Contact Enquiries",
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 2. Action Row: [ ] Select all  +  [ 🗑 Delete Selected (0) ]
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Select all Checkbox
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 22,
                          height: 22,
                          child: Checkbox(
                            value: _selectAll,
                            activeColor: const Color(0xFF00A3FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            side: BorderSide(
                              color: _isDarkMode
                                  ? const Color(0xFF64748B)
                                  : const Color(0xFF94A3B8),
                              width: 1.5,
                            ),
                            onChanged: (val) {
                              setState(() {
                                _selectAll = val ?? false;
                                for (var enq in _enquiries) {
                                  enq.isSelected = _selectAll;
                                }
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Select all",
                          style: GoogleFonts.poppins(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: _isDarkMode
                                ? Colors.grey.shade300
                                : const Color(0xFF475569),
                          ),
                        ),
                      ],
                    ),

                    // Delete Selected (N) Button
                    InkWell(
                      onTap: _selectedCount > 0 ? _deleteSelected : null,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: _isDarkMode
                              ? const Color(0xFF1E293B)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _selectedCount > 0
                                ? const Color(0xFFDC2626)
                                : (_isDarkMode
                                    ? const Color(0xFF334155)
                                    : const Color(0xFFCBD5E1)),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.delete_outline,
                              size: 15,
                              color: _selectedCount > 0
                                  ? const Color(0xFFDC2626)
                                  : (_isDarkMode
                                      ? Colors.grey.shade400
                                      : const Color(0xFF64748B)),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "Delete Selected ($_selectedCount)",
                              style: GoogleFonts.poppins(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w500,
                                color: _selectedCount > 0
                                    ? const Color(0xFFDC2626)
                                    : (_isDarkMode
                                        ? Colors.grey.shade400
                                        : const Color(0xFF64748B)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // 3. Search Field
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
                    hintText: "Search enquiries...",
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

          // 4. Contact Enquiry Cards List
          Expanded(
            child: PagingListener<int, ContactEnquiry>(
              controller: _pagingController,
              builder: (context, state, fetchNextPage) => RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () => Future.sync(() => _pagingController.refresh()),
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                      sliver: PagedSliverList<int, ContactEnquiry>(
                        state: state,
                        fetchNextPage: fetchNextPage,
                        builderDelegate:
                            PagedChildBuilderDelegate<ContactEnquiry>(
                          itemBuilder: (ctx, enq, index) =>
                              _buildEnquiryCard(enq, index),
                          noItemsFoundIndicatorBuilder: (ctx) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.mail_outline_rounded,
                                    size: 44,
                                    color: _isDarkMode
                                        ? Colors.grey.shade600
                                        : Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "No Contact Enquiries Found",
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
                    if (displayedEnquiries.isNotEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 20),
                          child: Center(
                            child: Text(
                              "Showing 1 to ${displayedEnquiries.length} of ${filtered.length} entries",
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

  Widget _buildEnquiryCard(ContactEnquiry enq, int index) {
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
          // Row 1: Checkbox + #S.N. + Name
          Row(
            children: [
              // Checkbox
              SizedBox(
                width: 20,
                height: 20,
                child: Checkbox(
                  value: enq.isSelected,
                  activeColor: const Color(0xFF00A3FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  side: BorderSide(
                    color: _isDarkMode
                        ? const Color(0xFF64748B)
                        : const Color(0xFF94A3B8),
                    width: 1.5,
                  ),
                  onChanged: (val) {
                    setState(() {
                      enq.isSelected = val ?? false;
                      _selectAll = _enquiries.every((e) => e.isSelected);
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),

              // #S.N. Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _isDarkMode
                      ? const Color(0xFF334155)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  "#${index + 1}",
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color:
                        _isDarkMode ? Colors.white70 : const Color(0xFF334155),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Name
              Expanded(
                child: Text(
                  enq.name,
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: _isDarkMode ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Row 2: Phone
          Row(
            children: [
              SizedBox(
                width: 75,
                child: Text(
                  "Phone",
                  style: GoogleFonts.poppins(
                    fontSize: 11.5,
                    color: _isDarkMode
                        ? Colors.grey.shade400
                        : const Color(0xFF64748B),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  enq.phone,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _isDarkMode ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Row 3: Email
          Row(
            children: [
              SizedBox(
                width: 75,
                child: Text(
                  "Email",
                  style: GoogleFonts.poppins(
                    fontSize: 11.5,
                    color: _isDarkMode
                        ? Colors.grey.shade400
                        : const Color(0xFF64748B),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  enq.email,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _isDarkMode ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Row 4: City
          Row(
            children: [
              SizedBox(
                width: 75,
                child: Text(
                  "City",
                  style: GoogleFonts.poppins(
                    fontSize: 11.5,
                    color: _isDarkMode
                        ? Colors.grey.shade400
                        : const Color(0xFF64748B),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  enq.city,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _isDarkMode ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Divider Line
          Divider(
            height: 1,
            thickness: 1,
            color:
                _isDarkMode ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
          ),
          const SizedBox(height: 8),

          // Row 5: Date Time (Left) + Eye & Delete Icons (Right)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                enq.date,
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
                    onTap: () => _viewEnquiryDetails(enq),
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.visibility_outlined,
                        size: 18,
                        color: _isDarkMode
                            ? Colors.grey.shade400
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () => _deleteSingleEnquiry(enq),
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
  }
}
