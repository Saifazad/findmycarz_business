import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  final bool _isDarkMode = false;
  int _entriesPerPage = 10;
  String _searchQuery = "";
  bool _selectAll = false;

  final TextEditingController _searchController = TextEditingController();

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
                fontWeight: FontWeight.w600,
                color: _isDarkMode
                    ? Colors.grey.shade300
                    : const Color(0xFF475569),
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
        title: Text(
          "Contact Enquiries",
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color:
                          _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
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

            // 3. Search and Entries Row: [ 🔍 Search enquiries... ] [ 10 ⌄ ]
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
                        color: const Color(0xFF00A3FF),
                        width: 1.2,
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
                        hintText: "Search enquiries...",
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 12.5,
                          color: _isDarkMode
                              ? Colors.white38
                              : Colors.grey.shade400,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          size: 18,
                          color: Color(0xFF00A3FF),
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
                    color: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
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
                      items: [5, 10, 15, 20, 25].map((int val) {
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

            // 4. Contact Enquiry Cards List
            if (displayedEnquiries.isEmpty)
              Padding(
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
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: displayedEnquiries.length,
                itemBuilder: (ctx, index) {
                  final enq = displayedEnquiries[index];

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
                                    _selectAll =
                                        _enquiries.every((e) => e.isSelected);
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 8),

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
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: _isDarkMode
                                      ? Colors.white70
                                      : const Color(0xFF334155),
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
                                  color: _isDarkMode
                                      ? Colors.white
                                      : const Color(0xFF0F172A),
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
                                  fontWeight: FontWeight.w600,
                                  color: _isDarkMode
                                      ? Colors.grey.shade300
                                      : const Color(0xFF475569),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                enq.phone,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: _isDarkMode
                                      ? Colors.white
                                      : const Color(0xFF0F172A),
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
                                  fontWeight: FontWeight.w600,
                                  color: _isDarkMode
                                      ? Colors.grey.shade300
                                      : const Color(0xFF475569),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                enq.email,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: _isDarkMode
                                      ? Colors.white
                                      : const Color(0xFF0F172A),
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
                                  fontWeight: FontWeight.w600,
                                  color: _isDarkMode
                                      ? Colors.grey.shade300
                                      : const Color(0xFF475569),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                enq.city,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: _isDarkMode
                                      ? Colors.white
                                      : const Color(0xFF0F172A),
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
                          color: _isDarkMode
                              ? const Color(0xFF334155)
                              : const Color(0xFFF1F5F9),
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
                                fontWeight: FontWeight.w600,
                                color: _isDarkMode
                                    ? Colors.grey.shade300
                                    : const Color(0xFF475569),
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
                },
              ),

            // 5. Bottom Pagination / Showing entries
            Padding(
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
          ],
        ),
      ),
    );
  }
}
