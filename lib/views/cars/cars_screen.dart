import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/crm_drawer.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/admin_profile_avatar.dart';
import 'add_car_screen.dart';

class InventoryVehicle {
  final String id;
  final String makeModel;
  final String subtitle;
  final String image;
  final String condition; // "Used" or "New"
  final String year;
  final String availability; // "Available", "Sold", "Booked"
  final String company;
  final String agent;
  final String phone;
  final String location;
  final String date;
  final String status; // "Inactive", "Published"
  final String visibility; // "Public", "Private"
  bool isSelected;

  InventoryVehicle({
    required this.id,
    required this.makeModel,
    required this.subtitle,
    required this.image,
    required this.condition,
    required this.year,
    required this.availability,
    required this.company,
    required this.agent,
    required this.phone,
    required this.location,
    required this.date,
    required this.status,
    required this.visibility,
    this.isSelected = false,
  });
}

class CarsScreen extends StatefulWidget {
  final String title;
  const CarsScreen({super.key, this.title = "Live Inventory"});

  @override
  State<CarsScreen> createState() => _CarsScreenState();
}

class _CarsScreenState extends State<CarsScreen> {
  final bool _isDarkMode = false;
  String _activeTab = "All Cars"; // "All Cars", "New Cars", "Used Cars"
  int _entriesPerPage = 10;
  int _currentPage = 1;
  String _searchQuery = "";

  final TextEditingController _searchController = TextEditingController();

  final List<InventoryVehicle> _vehicles = [
    InventoryVehicle(
      id: "#CARUID0978",
      makeModel: "TOYOTA KIRLOSKAR MOTOR PVT LTD | FORTUNER",
      subtitle: "TOYOTA KIRLOSKAR MOTOR PVT LTD FORTUNER",
      image: "assets/images/car1.webp",
      condition: "Used",
      year: "2013",
      availability: "Available",
      company: "Find My Car",
      agent: "Auto Care Mohammad Sajid",
      phone: "9897323603",
      location: "Dehradun, Uttaranchal",
      date: "17 Nov 2026",
      status: "Inactive",
      visibility: "Public",
    ),
    InventoryVehicle(
      id: "#CARUID0977",
      makeModel: "HYUNDAI | XCENT",
      subtitle: "2015 HYUNDAI MOTOR XCENT CRDI S",
      image: "assets/images/car.webp",
      condition: "Used",
      year: "2015",
      availability: "Available",
      company: "Owner",
      agent: "VAAHAN BAZA – NITIN KHATRI",
      phone: "9314651357",
      location: "Bikaner, Rajasthan",
      date: "16 Nov 2026",
      status: "Published",
      visibility: "Public",
    ),
    InventoryVehicle(
      id: "#CARUID0976",
      makeModel: "MARUTI SUZUKI | BREZZA",
      subtitle: "2020 MARUTI SUZUKI VITARA BREZZA ZXI",
      image: "assets/images/car1.webp",
      condition: "Used",
      year: "2020",
      availability: "Available",
      company: "Find My Car",
      agent: "MANOJ NEGI",
      phone: "9876543210",
      location: "Dehradun, Uttarakhand",
      date: "14 Nov 2026",
      status: "Published",
      visibility: "Public",
    ),
    InventoryVehicle(
      id: "#CARUID0975",
      makeModel: "MAHINDRA | THAR ROXX",
      subtitle: "2024 MAHINDRA THAR ROXX AX7L 4WD",
      image: "assets/images/car.webp",
      condition: "New",
      year: "2024",
      availability: "Available",
      company: "Dealership",
      agent: "KARAN",
      phone: "9811234567",
      location: "Haridwar, Uttarakhand",
      date: "12 Nov 2026",
      status: "Published",
      visibility: "Public",
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<InventoryVehicle> get _filteredVehicles {
    return _vehicles.where((v) {
      if (_activeTab == "New Cars" && v.condition.toLowerCase() != "new") {
        return false;
      }
      if (_activeTab == "Used Cars" && v.condition.toLowerCase() != "used") {
        return false;
      }

      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final match = v.id.toLowerCase().contains(q) ||
            v.makeModel.toLowerCase().contains(q) ||
            v.subtitle.toLowerCase().contains(q) ||
            v.phone.contains(q) ||
            v.location.toLowerCase().contains(q) ||
            v.agent.toLowerCase().contains(q) ||
            v.company.toLowerCase().contains(q);
        if (!match) return false;
      }

      return true;
    }).toList();
  }

  void showAddVehicleModal() {
    final uidCtrl =
        TextEditingController(text: "#CARUID0${970 + _vehicles.length}");
    final makeModelCtrl = TextEditingController();
    final subtitleCtrl = TextEditingController();
    final yearCtrl = TextEditingController(text: "2023");
    final phoneCtrl = TextEditingController();
    final locationCtrl = TextEditingController(text: "Dehradun, Uttaranchal");
    final companyCtrl = TextEditingController(text: "Find My Car");
    final agentCtrl = TextEditingController(text: "Auto Care Mohammad Sajid");
    String condition = "Used";
    String status = "Published";

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
                bottom: MediaQuery.of(modalCtx).viewInsets.bottom + 20,
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
                            "Add New Vehicle",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _isDarkMode
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            color: _isDarkMode ? Colors.white70 : Colors.black54,
                            onPressed: () => Navigator.pop(ctx),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      _buildFormField(
                        label: "Vehicle Make & Model",
                        controller: makeModelCtrl,
                        hint: "e.g. TOYOTA | INNOVA CRYSTA",
                        validator: (val) =>
                            val == null || val.trim().isEmpty ? "Required" : null,
                      ),
                      const SizedBox(height: 12),

                      _buildFormField(
                        label: "Variant / Subtitle",
                        controller: subtitleCtrl,
                        hint: "e.g. 2.4 ZX 7 STR DIESEL",
                        validator: (val) =>
                            val == null || val.trim().isEmpty ? "Required" : null,
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: _buildFormField(
                              label: "Year",
                              controller: yearCtrl,
                              hint: "e.g. 2022",
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Condition",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: _isDarkMode
                                        ? Colors.white70
                                        : const Color(0xFF334155),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: _isDarkMode
                                          ? const Color(0xFF475569)
                                          : const Color(0xFFCBD5E1),
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: condition,
                                      isExpanded: true,
                                      dropdownColor: _isDarkMode
                                          ? const Color(0xFF1E293B)
                                          : Colors.white,
                                      items: ["Used", "New"].map((c) {
                                        return DropdownMenuItem(
                                          value: c,
                                          child: Text(
                                            c,
                                            style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              color: _isDarkMode
                                                  ? Colors.white
                                                  : Colors.black87,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        if (val != null) {
                                          setModalState(() => condition = val);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      _buildFormField(
                        label: "Company / Client",
                        controller: companyCtrl,
                        hint: "e.g. Find My Car",
                      ),
                      const SizedBox(height: 12),

                      _buildFormField(
                        label: "Agent",
                        controller: agentCtrl,
                        hint: "e.g. Auto Care Mohammad Sajid",
                      ),
                      const SizedBox(height: 12),

                      _buildFormField(
                        label: "Phone Number",
                        controller: phoneCtrl,
                        hint: "e.g. 9897323603",
                      ),
                      const SizedBox(height: 12),

                      _buildFormField(
                        label: "Location",
                        controller: locationCtrl,
                        hint: "e.g. Dehradun, Uttaranchal",
                      ),
                      const SizedBox(height: 18),

                      SizedBox(
                        width: double.infinity,
                        height: 46,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00A3FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            if (formKey.currentState?.validate() ?? false) {
                              setState(() {
                                _vehicles.insert(
                                  0,
                                  InventoryVehicle(
                                    id: uidCtrl.text.trim(),
                                    makeModel: makeModelCtrl.text.trim().toUpperCase(),
                                    subtitle: subtitleCtrl.text.trim(),
                                    image: "assets/images/car1.webp",
                                    condition: condition,
                                    year: yearCtrl.text.trim(),
                                    availability: "Available",
                                    company: companyCtrl.text.trim(),
                                    agent: agentCtrl.text.trim(),
                                    phone: phoneCtrl.text.trim().isNotEmpty
                                        ? phoneCtrl.text.trim()
                                        : "9897323603",
                                    location: locationCtrl.text.trim(),
                                    date: "Today",
                                    status: status,
                                    visibility: "Public",
                                  ),
                                );
                              });
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Vehicle added successfully!"),
                                  backgroundColor: Color(0xFF10B981),
                                ),
                              );
                            }
                          },
                          child: Text(
                            "Save Vehicle",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
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

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    String? hint,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: _isDarkMode ? Colors.white70 : const Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: validator,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: _isDarkMode ? Colors.white : Colors.black87,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              fontSize: 13,
              color: _isDarkMode ? Colors.white38 : Colors.grey.shade400,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: _isDarkMode
                    ? const Color(0xFF475569)
                    : const Color(0xFFCBD5E1),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: _isDarkMode
                    ? const Color(0xFF475569)
                    : const Color(0xFFCBD5E1),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _exportToExcel() {
    final selectedCount = _vehicles.where((v) => v.isSelected).length;
    final message = selectedCount > 0
        ? "Exporting $selectedCount selected vehicles to Excel..."
        : "Exporting all ${_vehicles.length} vehicles to Excel...";
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text(message, style: GoogleFonts.poppins(fontSize: 13)),
          ],
        ),
        backgroundColor: const Color(0xFF00A389),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredVehicles;
    final displayedVehicles = filtered.take(_entriesPerPage).toList();
    final selectedCount = _vehicles.where((v) => v.isSelected).length;

    return Scaffold(
      backgroundColor:
          _isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      drawer: const CrmDrawer(),
      bottomNavigationBar: selectedCount > 0
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: _isDarkMode ? 0.3 : 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
                border: Border(
                  top: BorderSide(
                    color: _isDarkMode
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
              ),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Checkbox + "2 selected"
                    InkWell(
                      onTap: () {
                        setState(() {
                          final allSelected =
                              _vehicles.every((v) => v.isSelected);
                          for (var v in _vehicles) {
                            v.isSelected = !allSelected;
                          }
                        });
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            width: 22,
                            height: 22,
                            child: Checkbox(
                              value: true,
                              activeColor: const Color(0xFF00A3FF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              onChanged: (val) {
                                setState(() {
                                  final allSelected =
                                      _vehicles.every((v) => v.isSelected);
                                  for (var v in _vehicles) {
                                    v.isSelected = !allSelected;
                                  }
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "$selectedCount selected",
                            style: GoogleFonts.poppins(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: _isDarkMode
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // "Export Selected" Green Button
                    ElevatedButton(
                      onPressed: _exportToExcel,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00A389),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Export Selected",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
      appBar: AppBar(
        backgroundColor: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        elevation: 0.5,
        leading: CustomBackButton(isDarkMode: _isDarkMode),
        title: Text(
          widget.title,
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Top Buttons Row: "+ Add Vehicle" (Blue) & "Export to Excel" (Green)
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: 42,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const AddCarScreen()),
                        );
                      },
                      icon: const Icon(Icons.add, size: 16, color: Colors.white),
                      label: Text(
                        "Add Vehicle",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00A3FF),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 42,
                    child: ElevatedButton(
                      onPressed: _exportToExcel,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00A389),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Export to Excel",
                        style: GoogleFonts.poppins(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // 2. Tabs: All Cars | New Cars | Used Cars
            Row(
              children: [
                _buildTab("All Cars"),
                const SizedBox(width: 22),
                _buildTab("New Cars"),
                const SizedBox(width: 22),
                _buildTab("Used Cars"),
              ],
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: _isDarkMode
                  ? const Color(0xFF334155)
                  : const Color(0xFFE2E8F0),
            ),
            const SizedBox(height: 12),

            // 3. Search and Entries Filter Row: [ 🔍 Search.. ] [ 10 ⌄ ]
            Row(
              children: [
                // Search TextField
                Expanded(
                  child: SizedBox(
                    height: 40,
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
                        hintText: "Search..",
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 13,
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
                            const EdgeInsets.symmetric(vertical: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: _isDarkMode
                                ? const Color(0xFF475569)
                                : const Color(0xFFCBD5E1),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: _isDarkMode
                                ? const Color(0xFF475569)
                                : const Color(0xFFCBD5E1),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Dropdown [ 10 ⌄ ]
                Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _isDarkMode
                          ? const Color(0xFF475569)
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

            // 4. Vehicle Cards List (Matching Image 1 Format)
            if (displayedVehicles.isEmpty)
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
                        "No Vehicles Found",
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
                itemCount: displayedVehicles.length,
                itemBuilder: (ctx, index) {
                  final vehicle = displayedVehicles[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
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
                        // Top Row: Checkbox + Car Image with Badges + Info Column
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Checkbox
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: SizedBox(
                                width: 22,
                                height: 22,
                                child: Checkbox(
                                  value: vehicle.isSelected,
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
                                      vehicle.isSelected = val ?? false;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Car Thumbnail with Used & Available Badges
                            Container(
                              width: 82,
                              height: 58,
                              decoration: BoxDecoration(
                                color: _isDarkMode
                                    ? const Color(0xFF334155)
                                    : const Color(0xFFB0BEC5),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Icon(
                                      Icons.directions_car_rounded,
                                      size: 26,
                                      color: _isDarkMode
                                          ? Colors.white60
                                          : const Color(0xFF546E7A),
                                    ),
                                  ),
                                  // Top-Left: Used/New badge
                                  Positioned(
                                    top: 3,
                                    left: 3,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 1.5),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF10B981),
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: Text(
                                        vehicle.condition,
                                        style: GoogleFonts.poppins(
                                          fontSize: 8.5,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Bottom: Available banner
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      padding:
                                          const EdgeInsets.symmetric(vertical: 2),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFB45309), // amber/gold
                                        borderRadius: BorderRadius.vertical(
                                            bottom: Radius.circular(6)),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        vehicle.availability,
                                        style: GoogleFonts.poppins(
                                          fontSize: 8.5,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),

                            // Right Details: UID, Year, Serial#, Make & Model, Subtitle
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        vehicle.id,
                                        style: GoogleFonts.poppins(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF0D9488),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 1.5),
                                        decoration: BoxDecoration(
                                          color: _isDarkMode
                                              ? const Color(0xFF334155)
                                              : const Color(0xFFF1F5F9),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          vehicle.year,
                                          style: GoogleFonts.poppins(
                                            fontSize: 9.5,
                                            fontWeight: FontWeight.w600,
                                            color: _isDarkMode
                                                ? Colors.white70
                                                : const Color(0xFF334155),
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        "#${index + 1}",
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: _isDarkMode
                                              ? Colors.grey.shade400
                                              : const Color(0xFF475569),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    vehicle.makeModel,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: _isDarkMode
                                          ? Colors.white
                                          : const Color(0xFF0F172A),
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    vehicle.subtitle,
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
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

                        // Middle Details: C: Find My Car
                        Row(
                          children: [
                            Text(
                              "C:  ",
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: _isDarkMode
                                    ? Colors.grey.shade400
                                    : const Color(0xFF64748B),
                              ),
                            ),
                            Text(
                              vehicle.company,
                              style: GoogleFonts.poppins(
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                                color: _isDarkMode
                                    ? Colors.white
                                    : const Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),

                        // A: Auto Care Mohammad Sajid
                        Row(
                          children: [
                            Text(
                              "A:  ",
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: _isDarkMode
                                    ? Colors.grey.shade400
                                    : const Color(0xFF64748B),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                vehicle.agent,
                                style: GoogleFonts.poppins(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                  color: _isDarkMode
                                      ? Colors.white
                                      : const Color(0xFF0F172A),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        // Ph • Location • Date
                        Text(
                          "Ph  ${vehicle.phone} • ${vehicle.location} • ${vehicle.date}",
                          style: GoogleFonts.poppins(
                            fontSize: 10.5,
                            color: _isDarkMode
                                ? Colors.grey.shade400
                                : const Color(0xFF475569),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),

                        // Bottom Row: Status Pills on Left + Action Icons on Right
                        Row(
                          children: [
                            // Status 1: Inactive or Published
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: vehicle.status == "Inactive"
                                    ? const Color(0xFFDC2626) // Red
                                    : const Color(0xFF0D9488), // Teal
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                vehicle.status,
                                style: GoogleFonts.poppins(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),

                            // Status 2: Public
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0EA5E9), // Cyan / Blue
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                vehicle.visibility,
                                style: GoogleFonts.poppins(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),

                            // Status 3: Available
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFF16A34A), // Green
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                vehicle.availability,
                                style: GoogleFonts.poppins(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            const Spacer(),

                            // Action Icons: Edit, Delete, History
                            InkWell(
                              onTap: () => _editVehicle(vehicle),
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Icon(
                                  Icons.edit_outlined,
                                  size: 17,
                                  color: _isDarkMode
                                      ? Colors.grey.shade400
                                      : const Color(0xFF64748B),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () => _deleteVehicle(vehicle),
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Icon(
                                  Icons.delete_outline,
                                  size: 17,
                                  color: _isDarkMode
                                      ? Colors.grey.shade400
                                      : const Color(0xFF64748B),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () => _viewVehicleLogs(vehicle),
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Icon(
                                  Icons.history,
                                  size: 17,
                                  color: _isDarkMode
                                      ? Colors.grey.shade400
                                      : const Color(0xFF64748B),
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

            // 5. Bottom Pagination Bar (Exact match to Image 1)
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final textWidget = Text(
                    "Showing 1 to ${_entriesPerPage < 901 ? _entriesPerPage : 901} of 901 entries",
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
                          text: "2",
                          isActive: _currentPage == 2,
                          onTap: () => setState(() => _currentPage = 2),
                        ),
                        _buildPageButton(
                          text: "3",
                          isActive: _currentPage == 3,
                          onTap: () => setState(() => _currentPage = 3),
                        ),
                        _buildPageButton(
                          text: "4",
                          isActive: _currentPage == 4,
                          onTap: () => setState(() => _currentPage = 4),
                        ),
                        _buildPageButton(
                          text: "5",
                          isActive: _currentPage == 5,
                          onTap: () => setState(() => _currentPage = 5),
                        ),
                        _buildPageButton(
                          text: "6",
                          isActive: _currentPage == 6,
                          onTap: () => setState(() => _currentPage = 6),
                        ),
                        _buildPageButton(
                          text: "7",
                          isActive: _currentPage == 7,
                          onTap: () => setState(() => _currentPage = 7),
                        ),
                        _buildPageButton(text: "...", isDots: true),
                        _buildPageButton(
                          text: "91",
                          isActive: _currentPage == 91,
                          onTap: () => setState(() => _currentPage = 91),
                        ),
                        _buildPageButton(
                          text: "›",
                          onTap: () {
                            if (_currentPage < 91) {
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

  // Tab Item with Blue Indicator
  Widget _buildTab(String title) {
    final isActive = _activeTab == title;
    return InkWell(
      onTap: () {
        setState(() {
          _activeTab = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? const Color(0xFF00A3FF) : Colors.transparent,
              width: 2.2,
            ),
          ),
        ),
        child: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: isActive
                ? const Color(0xFF00A3FF)
                : (_isDarkMode
                    ? Colors.grey.shade400
                    : const Color(0xFF64748B)),
          ),
        ),
      ),
    );
  }

  void _editVehicle(InventoryVehicle v) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddCarScreen(
          carUid: v.id,
          existingVehicle: v,
          isEditMode: true,
        ),
      ),
    );
  }

  void _deleteVehicle(InventoryVehicle v) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAlias,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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
                        _vehicles.remove(v);
                      });
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Vehicle deleted successfully!"),
                          backgroundColor: Color(0xFFEF4D56),
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

  void _viewVehicleLogs(InventoryVehicle v) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 12, 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0284C7).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.history_rounded,
                        color: Color(0xFF0284C7),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Vehicle Logs",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _isDarkMode
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0284C7).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              v.id,
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF0284C7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        size: 20,
                        color: _isDarkMode ? Colors.white60 : Colors.black45,
                      ),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: _isDarkMode
                    ? const Color(0xFF334155)
                    : const Color(0xFFF1F5F9),
              ),
              // Body Content
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
                child: Column(
                  children: [
                    // Vehicle Info Card
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _isDarkMode
                            ? const Color(0xFF0F172A)
                            : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _isDarkMode
                              ? const Color(0xFF334155)
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color:
                                  const Color(0xFF0284C7).withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.directions_car_filled_outlined,
                              size: 18,
                              color: Color(0xFF0284C7),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  v.makeModel,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: _isDarkMode
                                        ? Colors.white
                                        : const Color(0xFF0F172A),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "${v.condition} • ${v.year}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 11.5,
                                    color: _isDarkMode
                                        ? Colors.white60
                                        : const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Log Detail Items
                    _buildLogRow(
                      icon: Icons.calendar_today_outlined,
                      label: "Listed Date",
                      value: v.date,
                      isDarkMode: _isDarkMode,
                    ),
                    _buildLogRow(
                      icon: Icons.location_on_outlined,
                      label: "Location",
                      value: v.location,
                      isDarkMode: _isDarkMode,
                    ),
                    _buildLogRow(
                      icon: Icons.person_outline_rounded,
                      label: "Managed by",
                      value: v.agent,
                      isDarkMode: _isDarkMode,
                    ),
                    _buildLogRow(
                      icon: Icons.business_outlined,
                      label: "Company",
                      value: v.company,
                      isDarkMode: _isDarkMode,
                    ),
                    _buildLogRow(
                      icon: Icons.info_outline_rounded,
                      label: "Status & Availability",
                      value: "${v.status} (${v.availability})",
                      customValue: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: (v.status.toLowerCase() == "published"
                                      ? const Color(0xFF059669)
                                      : const Color(0xFFDC2626))
                                  .withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              v.status,
                              style: GoogleFonts.poppins(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: v.status.toLowerCase() == "published"
                                    ? const Color(0xFF059669)
                                    : const Color(0xFFDC2626),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD97706).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              v.availability,
                              style: GoogleFonts.poppins(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFD97706),
                              ),
                            ),
                          ),
                        ],
                      ),
                      isDarkMode: _isDarkMode,
                    ),
                  ],
                ),
              ),
              // Footer Action
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0284C7),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(
                      "Close",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogRow({
    required IconData icon,
    required String label,
    required String value,
    Widget? customValue,
    required bool isDarkMode,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isDarkMode
                  ? const Color(0xFF334155)
                  : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 16,
              color: isDarkMode
                  ? const Color(0xFF94A3B8)
                  : const Color(0xFF64748B),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: isDarkMode ? Colors.white54 : const Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 1),
                customValue ??
                    Text(
                      value,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode
                            ? Colors.white
                            : const Color(0xFF1E293B),
                      ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
