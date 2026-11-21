import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/crm_drawer.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/admin_profile_avatar.dart';

class InsuranceLead {
  final String id;
  final String ownerName;
  final String regNumber;
  final String phone;
  final String email;
  final String date;
  final String status;
  final Color statusColor;
  final String vehicleModel;
  final String policyType;
  bool isSelected;

  InsuranceLead({
    required this.id,
    required this.ownerName,
    required this.regNumber,
    required this.phone,
    required this.email,
    required this.date,
    required this.status,
    required this.statusColor,
    required this.vehicleModel,
    required this.policyType,
    this.isSelected = false,
  });
}

class InsuranceLeadsScreen extends StatefulWidget {
  const InsuranceLeadsScreen({super.key});

  @override
  State<InsuranceLeadsScreen> createState() => _InsuranceLeadsScreenState();
}

class _InsuranceLeadsScreenState extends State<InsuranceLeadsScreen> {
  bool _isDarkMode = false;
  int _entriesPerPage = 10;
  int _currentPage = 1;
  String _searchQuery = "";
  bool _selectAll = false;

  final TextEditingController _searchController = TextEditingController();

  final List<InsuranceLead> _leads = [
    InsuranceLead(
      id: "INS-2026-0981",
      ownerName: "RAJESH SHARMA",
      regNumber: "UK-07-AL-4455",
      phone: "+91 98971 23456",
      email: "rajesh.sharma@gmail.com",
      date: "18 Nov, 2026",
      status: "Pending",
      statusColor: const Color(0xFFB45309), // Amber/Brown matching screenshot
      vehicleModel: "Toyota Fortuner 2021",
      policyType: "Comprehensive Zero Dep",
    ),
    InsuranceLead(
      id: "INS-2026-0980",
      ownerName: "MOHD SAJID",
      regNumber: "UP-14-BT-8899",
      phone: "+91 98112 34567",
      email: "sajid.autocare@gmail.com",
      date: "17 Nov, 2026",
      status: "Follow Up",
      statusColor: const Color(0xFFC2410C), // Orange/Rust
      vehicleModel: "Hyundai Creta 2022",
      policyType: "Third Party + Own Damage",
    ),
    InsuranceLead(
      id: "INS-2026-0979",
      ownerName: "ANITA RANI",
      regNumber: "DL-03-CC-1234",
      phone: "+91 97123 45678",
      email: "anita.rani92@gmail.com",
      date: "15 Nov, 2026",
      status: "Quoted",
      statusColor: const Color(0xFF0F766E), // Teal
      vehicleModel: "Maruti Suzuki Brezza 2020",
      policyType: "Comprehensive Renewal",
    ),
    InsuranceLead(
      id: "INS-2026-0978",
      ownerName: "VIKRAM JEET SINGH",
      regNumber: "RJ-14-CV-9012",
      phone: "+91 99887 65432",
      email: "vikram.singh@gmail.com",
      date: "14 Nov, 2026",
      status: "Pending",
      statusColor: const Color(0xFFB45309),
      vehicleModel: "Mahindra Thar 2023",
      policyType: "Zero Depreciation Insurance",
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<InsuranceLead> get _filteredLeads {
    if (_searchQuery.trim().isEmpty) return _leads;
    final q = _searchQuery.toLowerCase();
    return _leads.where((lead) {
      return lead.id.toLowerCase().contains(q) ||
          lead.ownerName.toLowerCase().contains(q) ||
          lead.regNumber.toLowerCase().contains(q) ||
          lead.phone.contains(q) ||
          lead.email.toLowerCase().contains(q) ||
          lead.status.toLowerCase().contains(q);
    }).toList();
  }

  int get _selectedCount => _leads.where((l) => l.isSelected).length;

  void _deleteSelected() {
    final count = _selectedCount;
    if (count == 0) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        title: Text(
          "Delete Selected Leads",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: _isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        content: Text(
          "Are you sure you want to delete $count selected lead(s)?",
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
                _leads.removeWhere((l) => l.isSelected);
                _selectAll = false;
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("$count lead(s) deleted successfully!"),
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

  void _deleteLead(InsuranceLead lead) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        title: Text(
          "Delete Lead",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: _isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        content: Text(
          "Are you sure you want to delete lead ${lead.id}?",
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
                _leads.removeWhere((l) => l.id == lead.id);
                if (_leads.isEmpty) {
                  _selectAll = false;
                } else {
                  _selectAll = _leads.every((l) => l.isSelected);
                }
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Lead ${lead.id} deleted successfully!"),
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

  void _viewLeadDetails(InsuranceLead lead) {
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
                    "Lead Details (${lead.id})",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _isDarkMode ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: lead.statusColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      lead.status,
                      style: GoogleFonts.poppins(
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _buildDetailRow("Owner Name", lead.ownerName),
              _buildDetailRow("Registration No.", lead.regNumber),
              _buildDetailRow("Phone", lead.phone),
              _buildDetailRow("Email", lead.email),
              _buildDetailRow("Vehicle", lead.vehicleModel),
              _buildDetailRow("Policy Type", lead.policyType),
              _buildDetailRow("Submitted Date", lead.date),
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
            width: 130,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: _isDarkMode ? Colors.grey.shade400 : const Color(0xFF64748B),
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
    final filtered = _filteredLeads;
    final displayedLeads = filtered.take(_entriesPerPage).toList();

    return Scaffold(
      backgroundColor:
          _isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      drawer: const CrmDrawer(),
      appBar: AppBar(
        backgroundColor: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        elevation: 0.5,
        leading: CustomBackButton(isDarkMode: _isDarkMode),
        title: Text(
          "Insurance Leads",
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
            // 1. Heading Row: Circular (<) button + "Insurance Leads"
            Row(
              children: [
                InkWell(
                  onTap: () => Navigator.maybePop(context),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isDarkMode
                          ? const Color(0xFF1E293B)
                          : Colors.white,
                      border: Border.all(
                        color: _isDarkMode
                            ? const Color(0xFF334155)
                            : const Color(0xFFE2E8F0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                              alpha: _isDarkMode ? 0.2 : 0.03),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.chevron_left,
                      size: 20,
                      color: _isDarkMode
                          ? Colors.white
                          : const Color(0xFF334155),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "Insurance Leads",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _isDarkMode ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

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
                            for (var lead in _leads) {
                              lead.isSelected = _selectAll;
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

            // 3. Search and Entries Row: [ 🔍 Search insurance leads ] [ 10 ⌄ ]
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
                        hintText: "Search insurance leads",
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

            // 4. Insurance Leads Cards List (Exact Match to Screenshot)
            if (displayedLeads.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.assignment_late_outlined,
                        size: 44,
                        color: _isDarkMode
                            ? Colors.grey.shade600
                            : Colors.grey.shade400,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "No Insurance Leads Found",
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
                itemCount: displayedLeads.length,
                itemBuilder: (ctx, index) {
                  final lead = displayedLeads[index];

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
                        // Row 1: Checkbox + #S.N. + [LEAD ID] (Left) + [Status] Badge (Right)
                        Row(
                          children: [
                            // Checkbox
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Checkbox(
                                value: lead.isSelected,
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
                                    lead.isSelected = val ?? false;
                                    _selectAll =
                                        _leads.every((l) => l.isSelected);
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

                            // [LEAD ID]
                            Expanded(
                              child: Text(
                                lead.id,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: _isDarkMode
                                      ? Colors.white
                                      : const Color(0xFF0F172A),
                                ),
                              ),
                            ),

                            // [Status] Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3.5),
                              decoration: BoxDecoration(
                                color: lead.statusColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                lead.status,
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

                        // Row 2: Owner [OWNER NAME]
                        Row(
                          children: [
                            SizedBox(
                              width: 90,
                              child: Text(
                                "Owner",
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
                                lead.ownerName,
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

                        // Row 3: Reg Number [REG NUMBER]
                        Row(
                          children: [
                            SizedBox(
                              width: 90,
                              child: Text(
                                "Reg Number",
                                style: GoogleFonts.poppins(
                                  fontSize: 11.5,
                                  color: _isDarkMode
                                      ? Colors.grey.shade400
                                      : const Color(0xFF64748B),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
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
                                lead.regNumber,
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF2563EB),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),

                        // Row 4: Phone / Email
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 90,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Phone /",
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: _isDarkMode
                                          ? Colors.grey.shade400
                                          : const Color(0xFF64748B),
                                    ),
                                  ),
                                  Text(
                                    "Email",
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: _isDarkMode
                                          ? Colors.grey.shade400
                                          : const Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    lead.phone,
                                    style: GoogleFonts.poppins(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w600,
                                      color: _isDarkMode
                                          ? Colors.white70
                                          : const Color(0xFF334155),
                                    ),
                                  ),
                                  Text(
                                    lead.email,
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: _isDarkMode
                                          ? Colors.grey.shade400
                                          : const Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Dotted Divider
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: _isDarkMode
                              ? const Color(0xFF334155)
                              : const Color(0xFFF1F5F9),
                        ),
                        const SizedBox(height: 8),

                        // Row 5: Submitted on [DATE] (Left) + Eye & Delete Icons (Right)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Submitted on ${lead.date}",
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
                                  onTap: () => _viewLeadDetails(lead),
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
                                  onTap: () => _deleteLead(lead),
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

            // 5. Bottom Pagination Bar
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 20),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final textWidget = Text(
                    "Showing 1 to ${displayedLeads.length} of ${filtered.length} entries",
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
                          onTap: () => setState(() => _currentPage = 1),
                        ),
                        _buildPageButton(
                          text: "›",
                          onTap: () {},
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

  Widget _buildPageButton({
    required String text,
    bool isActive = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        constraints: const BoxConstraints(minWidth: 32),
        height: 32,
        margin: const EdgeInsets.only(right: 4),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive
              ? (_isDarkMode
                  ? const Color(0xFF334155)
                  : const Color(0xFFCBD5E1))
              : (_isDarkMode ? const Color(0xFF1E293B) : Colors.white),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isActive
                ? const Color(0xFF00A3FF)
                : (_isDarkMode
                    ? const Color(0xFF475569)
                    : const Color(0xFFCBD5E1)),
            width: isActive ? 1.5 : 1.0,
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: isActive
                ? (_isDarkMode ? Colors.white : const Color(0xFF0F172A))
                : (_isDarkMode
                    ? Colors.grey.shade300
                    : const Color(0xFF475569)),
          ),
        ),
      ),
    );
  }
}
