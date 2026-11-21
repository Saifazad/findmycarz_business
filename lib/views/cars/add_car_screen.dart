import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/admin_profile_avatar.dart';

class AddCarScreen extends StatefulWidget {
  final String carUid;
  const AddCarScreen({super.key, this.carUid = "#CARUID979"});

  @override
  State<AddCarScreen> createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  final _formKey = GlobalKey<FormState>();

  // Accordion Expand/Collapse States
  bool _primaryDetailsExpanded = true;
  bool _makeModelFeaturesExpanded = true;
  bool _seoMetadataExpanded = true;
  bool _dragAndSortEnabled = true;

  // Make, Model & Features State
  String _selectedManufacturer = "Select";
  String _selectedModel = "Select manufacturer first";
  String _selectedBodyType = "Select";
  String _selectedExteriorColor = "Select";
  List<String> _selectedFeatures = [];

  final List<String> _manufacturers = [
    "Maruti Suzuki",
    "Hyundai",
    "Tata Motors",
    "Mahindra",
    "Toyota",
    "Honda",
    "Kia",
    "Volkswagen",
    "Skoda",
    "Renault",
    "MG Motors",
    "Ford",
    "Nissan",
    "BMW",
    "Mercedes-Benz",
    "Audi",
  ];

  final Map<String, List<String>> _modelsByManufacturer = {
    "Maruti Suzuki": [
      "Swift",
      "Baleno",
      "Brezza",
      "Dzire",
      "Ertiga",
      "WagonR",
      "Alto",
      "Grand Vitara",
      "Ciaz",
      "Fronx",
      "Jimny",
      "Invicto",
    ],
    "Hyundai": [
      "Creta",
      "Venue",
      "i20",
      "Verna",
      "Grand i10 Nios",
      "Exter",
      "Aura",
      "Alcazar",
      "Tucson",
      "Ioniq 5",
    ],
    "Tata Motors": [
      "Nexon",
      "Punch",
      "Harrier",
      "Safari",
      "Altroz",
      "Tiago",
      "Tigor",
      "Curvv",
      "Nexon EV",
    ],
    "Mahindra": [
      "Thar",
      "Thar Roxx",
      "Scorpio-N",
      "Scorpio Classic",
      "XUV700",
      "XUV3XO",
      "Bolero",
      "Bolero Neo",
    ],
    "Toyota": [
      "Fortuner",
      "Innova Crysta",
      "Innova Hycross",
      "Urban Cruiser Hyryder",
      "Glanza",
      "Hilux",
      "Camry",
      "Vellfire",
    ],
    "Honda": ["City", "Amaze", "Elevate", "WR-V"],
    "Kia": ["Seltos", "Sonet", "Carens", "Carnival", "EV6"],
    "Volkswagen": ["Virtus", "Taigun", "Polo", "Vento", "Tiguan"],
    "Skoda": ["Slavia", "Kushaq", "Octavia", "Superb", "Kodiaq"],
  };

  final List<String> _bodyTypes = [
    "Hatchback",
    "Sedan",
    "SUV",
    "Compact SUV",
    "MUV / MPV",
    "Coupe",
    "Convertible",
    "Pickup Truck",
    "Van",
  ];

  final List<Map<String, dynamic>> _exteriorColors = const [
    {"name": "White", "color": Colors.white, "border": true},
    {"name": "Pearl White", "color": Color(0xFFFDFBF7), "border": true},
    {"name": "Silver", "color": Color(0xFFC0C0C0), "border": false},
    {"name": "Grey", "color": Color(0xFF808080), "border": false},
    {"name": "Black", "color": Color(0xFF1E293B), "border": false},
    {"name": "Red", "color": Color(0xFFDC2626), "border": false},
    {"name": "Blue", "color": Color(0xFF2563EB), "border": false},
    {"name": "Brown", "color": Color(0xFF78350F), "border": false},
    {"name": "Beige / Gold", "color": Color(0xFFD4AF37), "border": false},
    {"name": "Green", "color": Color(0xFF16A34A), "border": false},
    {"name": "Orange", "color": Color(0xFFEA580C), "border": false},
    {"name": "Yellow", "color": Color(0xFFCA8A04), "border": false},
  ];

  final List<String> _featuresList = [
    "Airbags (Driver & Passenger)",
    "Anti-Lock Braking System (ABS) with EBD",
    "Electric Sunroof",
    "Alloy Wheels",
    "Touchscreen Infotainment System",
    "Apple CarPlay & Android Auto",
    "Reverse Parking Camera with Sensors",
    "Push Button Start / Stop",
    "Automatic Climate Control",
    "Cruise Control",
    "Leather Seat Upholstery",
    "Ventilated Front Seats",
    "LED Projector Headlamps",
    "Wireless Phone Charger",
    "Power Windows (Front & Rear)",
    "Steering Mounted Audio Controls",
    "Electronic Stability Control (ESC)",
    "Hill Hold Assist",
    "Tyre Pressure Monitoring System (TPMS)",
    "Electrically Foldable ORVMs",
  ];

  // Primary Details Controllers
  final _rcNumberCtrl = TextEditingController();
  final _carNameCtrl = TextEditingController();
  final _ownerNameCtrl = TextEditingController();
  final _engineCcCtrl = TextEditingController();
  final _grossWeightCtrl = TextEditingController();
  final _unladenWeightCtrl = TextEditingController();
  final _cylindersCtrl = TextEditingController();
  final _insuranceCompanyCtrl = TextEditingController();
  final _policyNumberCtrl = TextEditingController();
  final _engineNumberCtrl = TextEditingController();
  final _chassisNumberCtrl = TextEditingController();
  final _financerCtrl = TextEditingController();
  final _makeYearCtrl = TextEditingController();
  final _askingPriceCtrl = TextEditingController();
  final _discountCtrl = TextEditingController();
  final _mileageCtrl = TextEditingController();
  final _kmDrivenCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();

  // Date Controllers
  final _fitnessValidUptoCtrl = TextEditingController();
  final _registrationDateCtrl = TextEditingController();
  final _insuranceExpiryCtrl = TextEditingController();
  final _puccValidUptoCtrl = TextEditingController();

  // SEO Controllers
  final _metaTitleCtrl = TextEditingController();
  final _permanentUrlSlugCtrl = TextEditingController(text: "979");
  final _metaKeywordsCtrl = TextEditingController();
  final _metaDescriptionCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final digits = widget.carUid.replaceAll(RegExp(r'[^0-9]'), '');
    _permanentUrlSlugCtrl.text = digits.isNotEmpty ? digits : "979";
  }

  // Dropdown States
  String _vehicleType = "Used car";
  String _status = "Available";
  String _rtoCode = "Select RTO";
  String _seatingCapacity = "Select seats";
  String _rcStatus = "Select status";
  String _ownership = "Select ownership";
  String _transmission = "Select...";
  String _fuelType = "Select...";

  // Image Upload list
  final List<String> _uploadedImages = [];

  // Options
  final List<String> _vehicleTypes = ["Used car", "New car"];
  final List<String> _statusOptions = ["Available", "Sold", "Booked", "Reserved"];
  final List<String> _rtoOptions = [
    "Select RTO",
    "DL-01 (Delhi North)",
    "DL-02 (Delhi South)",
    "UK-07 (Dehradun)",
    "UK-01 (Almora)",
    "HR-26 (Gurgaon)",
    "UP-14 (Ghaziabad)",
    "UP-16 (Noida)",
    "MH-01 (Mumbai South)",
    "MH-02 (Mumbai West)",
    "RJ-14 (Jaipur)",
    "KA-01 (Bangalore)",
  ];
  final List<String> _seatingOptions = [
    "Select seats",
    "2 Seater",
    "4 Seater",
    "5 Seater",
    "6 Seater",
    "7 Seater",
    "8 Seater",
  ];
  final List<String> _rcStatusOptions = [
    "Select status",
    "Active",
    "Suspended",
    "Expired",
    "NOC Issued",
  ];
  final List<String> _ownershipOptions = [
    "Select ownership",
    "1st Owner",
    "2nd Owner",
    "3rd Owner",
    "4th Owner",
    "Commercial / Fleet",
  ];
  final List<String> _transmissionOptions = [
    "Select...",
    "Manual",
    "Automatic",
    "AMT",
    "IMT",
    "CVT",
    "DCT",
  ];
  final List<String> _fuelOptions = [
    "Select...",
    "Petrol",
    "Diesel",
    "CNG",
    "Electric",
    "Hybrid (Petrol + Electric)",
  ];

  @override
  void dispose() {
    _rcNumberCtrl.dispose();
    _carNameCtrl.dispose();
    _ownerNameCtrl.dispose();
    _engineCcCtrl.dispose();
    _grossWeightCtrl.dispose();
    _unladenWeightCtrl.dispose();
    _cylindersCtrl.dispose();
    _insuranceCompanyCtrl.dispose();
    _policyNumberCtrl.dispose();
    _engineNumberCtrl.dispose();
    _chassisNumberCtrl.dispose();
    _financerCtrl.dispose();
    _makeYearCtrl.dispose();
    _askingPriceCtrl.dispose();
    _discountCtrl.dispose();
    _mileageCtrl.dispose();
    _kmDrivenCtrl.dispose();
    _descriptionCtrl.dispose();
    _fitnessValidUptoCtrl.dispose();
    _registrationDateCtrl.dispose();
    _insuranceExpiryCtrl.dispose();
    _puccValidUptoCtrl.dispose();
    _metaTitleCtrl.dispose();
    _permanentUrlSlugCtrl.dispose();
    _metaKeywordsCtrl.dispose();
    _metaDescriptionCtrl.dispose();
    super.dispose();
  }

  // RC Auto-Fill Simulation
  void _fetchRcDetails() {
    final rc = _rcNumberCtrl.text.trim();
    if (rc.isEmpty) {
      _rcNumberCtrl.text = "DL01CA1234";
    }

    setState(() {
      _carNameCtrl.text = "Maruti Suzuki Swift VXI";
      _ownerNameCtrl.text = "Ramesh Kumar Gupta";
      _rtoCode = "DL-01 (Delhi North)";
      _seatingCapacity = "5 Seater";
      _engineCcCtrl.text = "1197";
      _grossWeightCtrl.text = "1335";
      _unladenWeightCtrl.text = "875";
      _cylindersCtrl.text = "4";
      _rcStatus = "Active";
      _registrationDateCtrl.text = "15-08-2022";
      _fitnessValidUptoCtrl.text = "14-08-2037";
      _insuranceExpiryCtrl.text = "10-09-2026";
      _insuranceCompanyCtrl.text = "HDFC ERGO General Insurance";
      _policyNumberCtrl.text = "POL-23094821";
      _engineNumberCtrl.text = "K12M9823411";
      _chassisNumberCtrl.text = "MA3EJEB1S00918234";
      _financerCtrl.text = "HDFC Bank Ltd.";
      _puccValidUptoCtrl.text = "22-12-2026";
      _ownership = "1st Owner";
      _makeYearCtrl.text = "2022";
      _fuelType = "Petrol";
      _transmission = "Manual";
      _mileageCtrl.text = "22.5";
      _kmDrivenCtrl.text = "38,500";
      _askingPriceCtrl.text = "6,45,000";
      _discountCtrl.text = "5";
      _descriptionCtrl.text =
          "Single owner, certified vehicle with zero accidental record. Complete service history at authorized service center. Mint condition.";
      _selectedManufacturer = "Maruti Suzuki";
      _selectedModel = "Swift";
      _selectedBodyType = "Hatchback";
      _selectedExteriorColor = "White";
      _selectedFeatures = [
        "Airbags (Driver & Passenger)",
        "Anti-Lock Braking System (ABS) with EBD",
        "Power Windows (Front & Rear)",
        "Steering Mounted Audio Controls",
      ];
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("RC Details fetched and fields auto-filled successfully!"),
        backgroundColor: Color(0xFF008844),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2040),
      builder: (ctx, child) {
        return Theme(
          data: Theme.of(ctx).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF003366),
              onPrimary: Colors.white,
              onSurface: Color(0xFF0F172A),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        controller.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  void _addMockImage() {
    if (_uploadedImages.length >= 20) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Maximum 20 images limit reached!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() {
      _uploadedImages.add("assets/images/car1.webp");
    });
  }

  void _submitForm() {
    if (_carNameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter the Car Name."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Vehicle ${widget.carUid} added successfully!"),
        backgroundColor: const Color(0xFF008844),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Strictly white background as requested
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: const CustomBackButton(isDarkMode: false),
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Add new car ",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
              TextSpan(
                text: widget.carUid,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF10B981),
                ),
              ),
            ],
          ),
        ),
        actions: const [
          AdminProfileAvatar(),
          SizedBox(width: 14),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Primary Details Section (Card)
              _buildPrimaryDetailsCard(),
              const SizedBox(height: 18),

              // 2. Make, model & features Section (Card)
              _buildMakeModelFeaturesCard(),
              const SizedBox(height: 18),

              // 3. Image Gallery Section (Card)
              _buildImageGalleryCard(),
              const SizedBox(height: 18),

              // 3. SEO & Metadata Section (Card)
              _buildSeoMetadataCard(),
              const SizedBox(height: 24),

              // Bottom Action Buttons
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003366),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.check_circle_outline, size: 18),
                      label: Text(
                        "Save Vehicle",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF64748B),
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ================= 1. PRIMARY DETAILS CARD =================
  Widget _buildPrimaryDetailsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header (Collapsible)
          InkWell(
            onTap: () {
              setState(() {
                _primaryDetailsExpanded = !_primaryDetailsExpanded;
              });
            },
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Primary details",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  Icon(
                    _primaryDetailsExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: const Color(0xFF64748B),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),

          if (_primaryDetailsExpanded)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row 1: Vehicle type *  &  RC verification (auto-fill fields)
                  _buildResponsiveRow(
                    children: [
                      _buildFlexibleField(
                        flex: 1,
                        label: "Vehicle type *",
                        child: _buildDropdown(
                          value: _vehicleType,
                          items: _vehicleTypes,
                          onChanged: (val) {
                            if (val != null) setState(() => _vehicleType = val);
                          },
                        ),
                      ),
                      _buildFlexibleField(
                        flex: 2,
                        label: "RC verification (auto-fill fields)",
                        labelColor: const Color(0xFF008844),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: _rcNumberCtrl,
                                hintText:
                                    "REGISTRATION NUMBER (E.G. DL01CA1234)",
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: _fetchRcDetails,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF06B6D4),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                "Fetch details",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Row 2: Status *, RTO code *, Car name *
                  _buildResponsiveRow(
                    children: [
                      _buildFlexibleField(
                        label: "Status *",
                        child: _buildDropdown(
                          value: _status,
                          items: _statusOptions,
                          onChanged: (val) {
                            if (val != null) setState(() => _status = val);
                          },
                        ),
                      ),
                      _buildFlexibleField(
                        label: "RTO code *",
                        child: _buildDropdown(
                          value: _rtoCode,
                          items: _rtoOptions,
                          onChanged: (val) {
                            if (val != null) setState(() => _rtoCode = val);
                          },
                        ),
                      ),
                      _buildFlexibleField(
                        label: "Car name *",
                        child: _buildTextField(
                          controller: _carNameCtrl,
                          hintText: "e.g. Swift",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Row 3: Owner name, Seating capacity, Cubic capacity (engine)
                  _buildResponsiveRow(
                    children: [
                      _buildFlexibleField(
                        label: "Owner name",
                        child: _buildTextField(
                          controller: _ownerNameCtrl,
                          hintText: "Owner name",
                        ),
                      ),
                      _buildFlexibleField(
                        label: "Seating capacity",
                        child: _buildDropdown(
                          value: _seatingCapacity,
                          items: _seatingOptions,
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _seatingCapacity = val);
                            }
                          },
                        ),
                      ),
                      _buildFlexibleField(
                        label: "Cubic capacity (engine)",
                        child: _buildTextField(
                          controller: _engineCcCtrl,
                          hintText: "CC",
                          suffixText: "cc",
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Row 4: Gross vehicle weight, Unladen weight, Cylinders
                  _buildResponsiveRow(
                    children: [
                      _buildFlexibleField(
                        label: "Gross vehicle weight",
                        child: _buildTextField(
                          controller: _grossWeightCtrl,
                          hintText: "Gross weight",
                          suffixText: "kg",
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      _buildFlexibleField(
                        label: "Unladen weight",
                        child: _buildTextField(
                          controller: _unladenWeightCtrl,
                          hintText: "Unladen weight",
                          suffixText: "kg",
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      _buildFlexibleField(
                        label: "Cylinders",
                        child: _buildTextField(
                          controller: _cylindersCtrl,
                          hintText: "No. of cylinders",
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Row 5: Fitness valid upto, RC status, Registration date
                  _buildResponsiveRow(
                    children: [
                      _buildFlexibleField(
                        label: "Fitness valid upto",
                        child: _buildDateField(
                          controller: _fitnessValidUptoCtrl,
                          hintText: "dd-mm-yyyy",
                        ),
                      ),
                      _buildFlexibleField(
                        label: "RC status",
                        child: _buildDropdown(
                          value: _rcStatus,
                          items: _rcStatusOptions,
                          onChanged: (val) {
                            if (val != null) setState(() => _rcStatus = val);
                          },
                        ),
                      ),
                      _buildFlexibleField(
                        label: "Registration date",
                        child: _buildDateField(
                          controller: _registrationDateCtrl,
                          hintText: "dd-mm-yyyy",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Row 6: Insurance expiry, Insurance company, Policy number
                  _buildResponsiveRow(
                    children: [
                      _buildFlexibleField(
                        label: "Insurance expiry",
                        child: _buildDateField(
                          controller: _insuranceExpiryCtrl,
                          hintText: "dd-mm-yyyy",
                        ),
                      ),
                      _buildFlexibleField(
                        label: "Insurance company",
                        child: _buildTextField(
                          controller: _insuranceCompanyCtrl,
                          hintText: "Insurance company",
                        ),
                      ),
                      _buildFlexibleField(
                        label: "Policy number",
                        child: _buildTextField(
                          controller: _policyNumberCtrl,
                          hintText: "Policy number",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Row 7: Engine number, Chassis number, Financer
                  _buildResponsiveRow(
                    children: [
                      _buildFlexibleField(
                        label: "Engine number",
                        child: _buildTextField(
                          controller: _engineNumberCtrl,
                          hintText: "Engine no.",
                        ),
                      ),
                      _buildFlexibleField(
                        label: "Chassis number",
                        child: _buildTextField(
                          controller: _chassisNumberCtrl,
                          hintText: "Chassis no.",
                        ),
                      ),
                      _buildFlexibleField(
                        label: "Financer",
                        child: _buildTextField(
                          controller: _financerCtrl,
                          hintText: "Bank / finance name",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Row 8: PUCC valid upto, Ownership *, Make year *
                  _buildResponsiveRow(
                    children: [
                      _buildFlexibleField(
                        label: "PUCC valid upto",
                        child: _buildDateField(
                          controller: _puccValidUptoCtrl,
                          hintText: "dd-mm-yyyy",
                        ),
                      ),
                      _buildFlexibleField(
                        label: "Ownership *",
                        child: _buildDropdown(
                          value: _ownership,
                          items: _ownershipOptions,
                          onChanged: (val) {
                            if (val != null) setState(() => _ownership = val);
                          },
                        ),
                      ),
                      _buildFlexibleField(
                        label: "Make year *",
                        child: _buildTextField(
                          controller: _makeYearCtrl,
                          hintText: "YYYY",
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Row 9: Asking price (₹) *, Discount (%), Transmission *
                  _buildResponsiveRow(
                    children: [
                      _buildFlexibleField(
                        label: "Asking price (₹) *",
                        child: _buildTextField(
                          controller: _askingPriceCtrl,
                          hintText: "Enter asking price",
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      _buildFlexibleField(
                        label: "Discount (%)",
                        child: _buildTextField(
                          controller: _discountCtrl,
                          hintText: "e.g. 10",
                          suffixText: "%",
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      _buildFlexibleField(
                        label: "Transmission *",
                        child: _buildDropdown(
                          value: _transmission,
                          items: _transmissionOptions,
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _transmission = val);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Row 10: Fuel type *, Mileage, KM driven
                  _buildResponsiveRow(
                    children: [
                      _buildFlexibleField(
                        label: "Fuel type *",
                        child: _buildDropdown(
                          value: _fuelType,
                          items: _fuelOptions,
                          onChanged: (val) {
                            if (val != null) setState(() => _fuelType = val);
                          },
                        ),
                      ),
                      _buildFlexibleField(
                        label: "Mileage",
                        child: _buildTextField(
                          controller: _mileageCtrl,
                          hintText: "e.g. 18",
                          suffixText: "km/l",
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      _buildFlexibleField(
                        label: "KM driven",
                        child: _buildTextField(
                          controller: _kmDrivenCtrl,
                          hintText: "e.g. 45,000",
                          suffixText: "km",
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Row 11: Description *
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Description *"),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _descriptionCtrl,
                        maxLines: 4,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: const Color(0xFF0F172A),
                        ),
                        decoration: InputDecoration(
                          hintText: "Enter vehicle description...",
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 12,
                            color: const Color(0xFF94A3B8),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.all(12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: Color(0xFFCBD5E1)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: Color(0xFFCBD5E1)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Color(0xFF003366), width: 1.5),
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
    );
  }

  // ================= 2. MAKE, MODEL & FEATURES CARD =================
  Widget _buildMakeModelFeaturesCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header (Collapsible)
          InkWell(
            onTap: () {
              setState(() {
                _makeModelFeaturesExpanded = !_makeModelFeaturesExpanded;
              });
            },
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Make, model & features",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  Icon(
                    _makeModelFeaturesExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: const Color(0xFF64748B),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),

          if (_makeModelFeaturesExpanded) ...[
            // 1. Manufacturer *
            _buildFeatureListItem(
              avatarLetter: "M",
              title: "Manufacturer",
              isRequired: true,
              subtitle: _selectedManufacturer,
              onTap: _showManufacturerPicker,
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),

            // 2. Model *
            _buildFeatureListItem(
              avatarLetter: "M",
              title: "Model",
              isRequired: true,
              subtitle: _selectedModel,
              onTap: _showModelPicker,
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),

            // 3. Body type
            _buildFeatureListItem(
              avatarLetter: "B",
              title: "Body type",
              isRequired: false,
              subtitle: _selectedBodyType,
              onTap: _showBodyTypePicker,
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),

            // 4. Exterior color *
            _buildFeatureListItem(
              avatarLetter: "E",
              title: "Exterior color",
              isRequired: true,
              subtitle: _selectedExteriorColor,
              onTap: _showColorPicker,
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),

            // 5. Features
            _buildFeatureListItem(
              avatarLetter: "F",
              title: "Features",
              isRequired: false,
              subtitle: _selectedFeatures.isEmpty
                  ? "None selected"
                  : "${_selectedFeatures.length} selected (${_selectedFeatures.take(2).join(', ')}${_selectedFeatures.length > 2 ? '...' : ''})",
              onTap: _showFeaturesPicker,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFeatureListItem({
    required String avatarLetter,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isRequired = false,
  }) {
    final isUnselected =
        subtitle.startsWith("Select") || subtitle == "None selected";

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFDBEAFE)),
              ),
              alignment: Alignment.center,
              child: Text(
                avatarLetter,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2563EB),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: title,
                          style: GoogleFonts.poppins(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        if (isRequired)
                          TextSpan(
                            text: " *",
                            style: GoogleFonts.poppins(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: isUnselected
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF2563EB),
                      fontWeight:
                          isUnselected ? FontWeight.normal : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 20,
              color: Color(0xFF94A3B8),
            ),
          ],
        ),
      ),
    );
  }

  void _showManufacturerPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        String query = "";
        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            final filtered = _manufacturers
                .where((m) => m.toLowerCase().contains(query.toLowerCase()))
                .toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.65,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Select Manufacturer",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    onChanged: (val) => setModalState(() => query = val),
                    decoration: InputDecoration(
                      hintText: "Search manufacturer...",
                      prefixIcon: const Icon(Icons.search, size: 20),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (ctx, i) {
                        final item = filtered[i];
                        final isSelected = _selectedManufacturer == item;
                        return ListTile(
                          title: Text(
                            item,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? const Color(0xFF2563EB)
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                          trailing: isSelected
                              ? const Icon(Icons.check_circle,
                                  color: Color(0xFF2563EB))
                              : null,
                          onTap: () {
                            setState(() {
                              _selectedManufacturer = item;
                              if (_selectedModel ==
                                  "Select manufacturer first") {
                                _selectedModel = "Select model";
                              }
                            });
                            Navigator.pop(ctx);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showModelPicker() {
    List<String> models = _modelsByManufacturer[_selectedManufacturer] ?? [
      "Swift",
      "Creta",
      "Nexon",
      "Thar",
      "City",
      "Fortuner",
      "Seltos",
      "Brezza",
      "Baleno",
      "Innova"
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select Model (${_selectedManufacturer != 'Select' ? _selectedManufacturer : 'All'})",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.separated(
                  itemCount: models.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (ctx, i) {
                    final item = models[i];
                    final isSelected = _selectedModel == item;
                    return ListTile(
                      title: Text(
                        item,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? const Color(0xFF2563EB)
                              : const Color(0xFF0F172A),
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle,
                              color: Color(0xFF2563EB))
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedModel = item;
                          if (_carNameCtrl.text.isEmpty) {
                            _carNameCtrl.text =
                                _selectedManufacturer != "Select"
                                    ? "$_selectedManufacturer $item"
                                    : item;
                          }
                        });
                        Navigator.pop(ctx);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showBodyTypePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select Body Type",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _bodyTypes.map((type) {
                  final isSelected = _selectedBodyType == type;
                  return ChoiceChip(
                    label: Text(type),
                    selected: isSelected,
                    selectedColor: const Color(0xFF003366),
                    backgroundColor: const Color(0xFFF1F5F9),
                    labelStyle: GoogleFonts.poppins(
                      color:
                          isSelected ? Colors.white : const Color(0xFF0F172A),
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                    onSelected: (val) {
                      setState(() => _selectedBodyType = type);
                      Navigator.pop(ctx);
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showColorPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.55,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select Exterior Color",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.separated(
                  itemCount: _exteriorColors.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (ctx, i) {
                    final item = _exteriorColors[i];
                    final name = item["name"] as String;
                    final color = item["color"] as Color;
                    final hasBorder = item["border"] as bool;
                    final isSelected = _selectedExteriorColor == name;

                    return ListTile(
                      leading: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: hasBorder
                                ? const Color(0xFFCBD5E1)
                                : Colors.transparent,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                      ),
                      title: Text(
                        name,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? const Color(0xFF2563EB)
                              : const Color(0xFF0F172A),
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle,
                              color: Color(0xFF2563EB))
                          : null,
                      onTap: () {
                        setState(() => _selectedExteriorColor = name);
                        Navigator.pop(ctx);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFeaturesPicker() {
    List<String> tempSelected = List.from(_selectedFeatures);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Select Vehicle Features",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            "${tempSelected.length} features selected",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedFeatures = List.from(tempSelected);
                          });
                          Navigator.pop(ctx);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF003366),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text("Done",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView.separated(
                      itemCount: _featuresList.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (ctx, i) {
                        final feature = _featuresList[i];
                        final isChecked = tempSelected.contains(feature);
                        return CheckboxListTile(
                          value: isChecked,
                          title: Text(
                            feature,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: isChecked
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          activeColor: const Color(0xFF003366),
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (val) {
                            setModalState(() {
                              if (val == true) {
                                tempSelected.add(feature);
                              } else {
                                tempSelected.remove(feature);
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ================= 3. IMAGE GALLERY CARD =================
  Widget _buildImageGalleryCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Drag & sort toggle and 0/20 badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLabel("Image gallery *"),
              Row(
                children: [
                  Switch(
                    value: _dragAndSortEnabled,
                    activeThumbColor: const Color(0xFF003366),
                    onChanged: (val) {
                      setState(() => _dragAndSortEnabled = val);
                    },
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "Drag & sort",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF475569),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "${_uploadedImages.length}/20",
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Upload Box (Dashed / Bordered Area)
          InkWell(
            onTap: _addMockImage,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFFCBD5E1),
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE0F2FE),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.cloud_upload_outlined,
                      size: 28,
                      color: Color(0xFF0284C7),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Drag & drop or click to upload",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "JPG, PNG or WebP · up to 20 photos",
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Display uploaded image thumbnails if any
          if (_uploadedImages.isNotEmpty) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(_uploadedImages.length, (idx) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.image,
                          color: Color(0xFF64748B), size: 28),
                    ),
                    Positioned(
                      top: -4,
                      right: -4,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _uploadedImages.removeAt(idx);
                          });
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(2),
                          child: const Icon(Icons.close,
                              color: Colors.white, size: 12),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ],
      ),
    );
  }

  // ================= 3. SEO & METADATA CARD =================
  Widget _buildSeoMetadataCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _seoMetadataExpanded = !_seoMetadataExpanded;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "SEO & metadata",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  Icon(
                    _seoMetadataExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: const Color(0xFF64748B),
                  ),
                ],
              ),
            ),
          ),
          if (_seoMetadataExpanded) ...[
            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Meta Title"),
                  const SizedBox(height: 6),
                  _buildTextField(
                    controller: _metaTitleCtrl,
                    hintText: "Enter meta title for search engines...",
                  ),
                  const SizedBox(height: 12),
                  _buildLabel("Permanent URL Slug"),
                  const SizedBox(height: 6),
                  _buildSlugField(),
                  const SizedBox(height: 12),
                  _buildLabel("Meta Keywords"),
                  const SizedBox(height: 6),
                  _buildTextField(
                    controller: _metaKeywordsCtrl,
                    hintText: "e.g. used swift, maruti car dehradun, buy car",
                  ),
                  const SizedBox(height: 12),
                  _buildLabel("Meta Description"),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _metaDescriptionCtrl,
                    maxLines: 3,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: const Color(0xFF0F172A),
                    ),
                    decoration: InputDecoration(
                      hintText: "Enter meta description for Google indexing...",
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 12,
                        color: const Color(0xFF94A3B8),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.all(12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: Color(0xFF003366), width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ================= HELPER UI BUILDERS =================
  Widget _buildSlugField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.horizontal(left: Radius.circular(7)),
              border: Border(
                right: BorderSide(color: Color(0xFFCBD5E1)),
              ),
            ),
            child: const Icon(
              Icons.link_rounded,
              size: 18,
              color: Color(0xFF64748B),
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: _permanentUrlSlugCtrl,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: const Color(0xFF0F172A),
              ),
              decoration: InputDecoration(
                hintText: "e.g. 979",
                hintStyle: GoogleFonts.poppins(
                  fontSize: 12,
                  color: const Color(0xFF94A3B8),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponsiveRow({required List<Widget> children}) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        if (constraints.maxWidth > 580) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children
                .map((child) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: child,
                      ),
                    ))
                .toList(),
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children
                .map((child) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: child,
                    ))
                .toList(),
          );
        }
      },
    );
  }

  Widget _buildFlexibleField({
    required String label,
    required Widget child,
    Color? labelColor,
    int flex = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label, color: labelColor),
        const SizedBox(height: 6),
        child,
      ],
    );
  }

  Widget _buildLabel(String text, {Color? color}) {
    final isRequired = text.contains("*");
    final cleanText = text.replaceAll("*", "").trim();

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: cleanText,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color ?? const Color(0xFF334155),
            ),
          ),
          if (isRequired)
            TextSpan(
              text: " *",
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    String? suffixText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(
        fontSize: 13,
        color: const Color(0xFF0F172A),
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(
          fontSize: 12,
          color: const Color(0xFF94A3B8),
        ),
        suffixText: suffixText,
        suffixStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF64748B),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF003366), width: 1.5),
        ),
      ),
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: () => _pickDate(controller),
      style: GoogleFonts.poppins(
        fontSize: 13,
        color: const Color(0xFF0F172A),
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(
          fontSize: 12,
          color: const Color(0xFF94A3B8),
        ),
        suffixIcon: const Icon(
          Icons.calendar_today_outlined,
          size: 16,
          color: Color(0xFF64748B),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF003366), width: 1.5),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(value) ? value : items.first,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: Color(0xFF64748B)),
          style: GoogleFonts.poppins(
            fontSize: 12.5,
            color: const Color(0xFF0F172A),
          ),
          onChanged: onChanged,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 12.5,
                  color: item.startsWith("Select")
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF0F172A),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
