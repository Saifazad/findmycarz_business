import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/crm_drawer.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/admin_profile_avatar.dart';

class OwnerListedCar {
  final String id;
  final String title;
  final String yearModel;
  final String image;
  final String status; // "Active", "Inactive"
  final String ownerName;
  final String ownerPhone;
  final String price;
  final String kms;
  final String location;
  final String listedDate;

  OwnerListedCar({
    required this.id,
    required this.title,
    required this.yearModel,
    required this.image,
    required this.status,
    required this.ownerName,
    required this.ownerPhone,
    required this.price,
    required this.kms,
    required this.location,
    required this.listedDate,
  });
}

class OwnerListedCarsScreen extends StatefulWidget {
  const OwnerListedCarsScreen({super.key});

  @override
  State<OwnerListedCarsScreen> createState() => _OwnerListedCarsScreenState();
}

class _OwnerListedCarsScreenState extends State<OwnerListedCarsScreen> {
  bool _isDarkMode = false;
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  final List<OwnerListedCar> _cars = [
    OwnerListedCar(
      id: "OLC001",
      title: "HYUNDAI XCENT",
      yearModel: "2015 Model",
      image: "assets/images/car.webp",
      status: "Active",
      ownerName: "JUBIN ALI BHUTTA",
      ownerPhone: "0000000000",
      price: "₹200,000",
      kms: "90,000 kms",
      location: "Alwar",
      listedDate: "16 Nov, 2026",
    ),
    OwnerListedCar(
      id: "OLC002",
      title:
          "TATA MOTORS PASSENGER VEHICLES LTD TATA PUNCH ACC 1.2P BS6 MT",
      yearModel: "2022 Model",
      image: "assets/images/car1.webp",
      status: "Inactive",
      ownerName: "NILESH SARKAR",
      ownerPhone: "9368512186",
      price: "₹525,000",
      kms: "72,000 kms",
      location: "Saharanpur",
      listedDate: "28 Oct, 2026",
    ),
    OwnerListedCar(
      id: "OLC003",
      title: "MARUTI SUZUKI INDIA LTD SWIFT ZXI",
      yearModel: "2022 Model",
      image: "assets/images/car.webp",
      status: "Active",
      ownerName: "DEEPA SHARMA",
      ownerPhone: "9368512186",
      price: "₹560,000",
      kms: "55,000 kms",
      location: "Saharanpur",
      listedDate: "24 Oct, 2026",
    ),
    OwnerListedCar(
      id: "OLC004",
      title: "MAHINDRA SCORPIO-N Z8 DIESEL 4WD",
      yearModel: "2023 Model",
      image: "assets/images/car1.webp",
      status: "Active",
      ownerName: "VIKRAM SINGH",
      ownerPhone: "9811122334",
      price: "₹1,850,000",
      kms: "24,000 kms",
      location: "Dehradun",
      listedDate: "15 Oct, 2026",
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<OwnerListedCar> get _filteredCars {
    if (_searchQuery.trim().isEmpty) return _cars;
    final q = _searchQuery.toLowerCase();
    return _cars.where((car) {
      return car.title.toLowerCase().contains(q) ||
          car.ownerName.toLowerCase().contains(q) ||
          car.ownerPhone.contains(q) ||
          car.location.toLowerCase().contains(q) ||
          car.yearModel.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredCars;

    return Scaffold(
      backgroundColor:
          _isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      drawer: const CrmDrawer(),
      appBar: AppBar(
        backgroundColor: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        elevation: 0.5,
        leading: CustomBackButton(isDarkMode: _isDarkMode),
        title: Text(
          "Owner Listed Cars",
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
            // 1. Heading & Subtitle
            Text(
              "Owner Listed Cars",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _isDarkMode ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              "Manage cars listed directly by owners.",
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: _isDarkMode
                    ? Colors.grey.shade400
                    : const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 14),

            // 2. Search Field
            Container(
              height: 42,
              decoration: BoxDecoration(
                color: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _isDarkMode
                      ? const Color(0xFF334155)
                      : const Color(0xFFCBD5E1),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: _isDarkMode ? 0.2 : 0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
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
                  hintText: "Search owner or car...",
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 13,
                    color: _isDarkMode ? Colors.white38 : Colors.grey.shade400,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    size: 18,
                    color: _isDarkMode ? Colors.white54 : Colors.grey.shade500,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 14),

            // 3. Cars Cards List
            if (filtered.isEmpty)
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
                        "No Owner Listed Cars Found",
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
                  final car = filtered[index];
                  final isActive = car.status == "Active";

                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
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
                        // Row 1: Car Image + Model/Year Info + Status Box Badge
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Car Image with border
                            Container(
                              width: 80,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: _isDarkMode
                                    ? const Color(0xFF0F172A)
                                    : const Color(0xFFF1F5F9),
                                border: Border.all(
                                  color: _isDarkMode
                                      ? const Color(0xFF334155)
                                      : const Color(0xFFE2E8F0),
                                ),
                                image: DecorationImage(
                                  image: AssetImage(car.image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Car Title & Year Model
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    car.title,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold,
                                      color: _isDarkMode
                                          ? Colors.white
                                          : const Color(0xFF0F172A),
                                      letterSpacing: 0.2,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    car.yearModel,
                                    style: GoogleFonts.poppins(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF0D9488),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Status Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? const Color(0xFF0F766E) // Deep teal / green
                                    : const Color(0xFFB91C1C), // Deep crimson red
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                car.status,
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
                          color: _isDarkMode
                              ? const Color(0xFF334155)
                              : const Color(0xFFF1F5F9),
                        ),
                        const SizedBox(height: 10),

                        // Row 2: Owner Info (Left) + Price & Kms (Right)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Owner Icon & Name + Phone
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Green Circle User Icon
                                  Container(
                                    width: 18,
                                    height: 18,
                                    margin: const EdgeInsets.only(top: 1),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(0xFF10B981),
                                        width: 1.5,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.person,
                                      size: 11,
                                      color: Color(0xFF10B981),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          car.ownerName,
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
                                        const SizedBox(height: 1),
                                        Text(
                                          car.ownerPhone,
                                          style: GoogleFonts.poppins(
                                            fontSize: 10.5,
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
                            ),

                            // Price & Kms (Right-Aligned)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  car.price,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: _isDarkMode
                                        ? Colors.white
                                        : const Color(0xFF0F172A),
                                  ),
                                ),
                                Text(
                                  car.kms,
                                  style: GoogleFonts.poppins(
                                    fontSize: 10.5,
                                    color: _isDarkMode
                                        ? Colors.grey.shade400
                                        : const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Row 3: Location & Listed Date (Left) + Actions (Right)
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 13,
                              color: _isDarkMode
                                  ? Colors.grey.shade400
                                  : const Color(0xFF64748B),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                "${car.location} • Listed ${car.listedDate}",
                                style: GoogleFonts.poppins(
                                  fontSize: 10.5,
                                  color: _isDarkMode
                                      ? Colors.grey.shade400
                                      : const Color(0xFF64748B),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // Action Icons: Edit & Delete
                            InkWell(
                              onTap: () => _editCar(car),
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Icon(
                                  Icons.edit_outlined,
                                  size: 16,
                                  color: _isDarkMode
                                      ? Colors.grey.shade400
                                      : const Color(0xFF64748B),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () => _deleteCar(car),
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Icon(
                                  Icons.delete_outline,
                                  size: 16,
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
          ],
        ),
      ),
    );
  }

  void _editCar(OwnerListedCar car) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Editing ${car.title}"),
        backgroundColor: const Color(0xFF00A3FF),
      ),
    );
  }

  void _deleteCar(OwnerListedCar car) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        title: Text(
          "Delete Car",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: _isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        content: Text(
          "Are you sure you want to delete ${car.title} listed by ${car.ownerName}?",
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
                _cars.remove(car);
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Car deleted successfully!"),
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
}
