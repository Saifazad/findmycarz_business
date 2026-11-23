import 'dart:ui' as ui;
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
  bool _seoMetadataExpanded = true;
  bool _dragAndSortEnabled = true;

  // Publishing State (Image 1 & 2)
  bool _publishingExpanded = true;
  String _publishingStatus = "Published";
  String _location = "...";
  String _homepageVisibility = "Show";
  String _scheduleOption = "Immediately";
  final List<String> _publishingOptions = [
    "Published",
    "Draft",
    "Under Review",
    "Archived",
  ];

  // Home Sections & Tax Rules State (Image 1)
  List<String> _selectedHomeSections = [];
  String _selectedRtoRule = "1 rule";
  String _selectedTcsRule = "1 rule";

  final List<String> _homeSectionsList = [
    "Featured Vehicles",
    "Popular & Trending Cars",
    "Hot Deals of the Week",
    "Budget Friendly (< ₹5 Lakhs)",
    "Verified & Certified Cars",
    "Luxury & Premium Segment",
    "Recently Added Stock",
    "Zero Down Payment Eligible",
  ];

  final List<String> _rtoRulesList = [
    "1 rule",
    "Standard State RTO Rule (8% Life Time Tax)",
    "Delhi/NCR Transfer & Hypothecation Fee",
    "Commercial Vehicle Permitted Tax Rule",
    "Zero Tax Exemption Rule",
  ];

  final List<String> _tcsRulesList = [
    "1 rule",
    "1% TCS Applicable (Transaction above ₹10 Lakhs)",
    "No TCS Applicable (< ₹10 Lakhs)",
    "Form 27C TCS Exemption Submitted",
    "Section 206C(1F) Motor Vehicle Sale Rule",
  ];

  // Make, Model & Features State
  bool _manufacturerExpanded = true;
  final _manufacturerSearchCtrl = TextEditingController();
  bool _isAddingManufacturer = false;
  final _newManufacturerNameCtrl = TextEditingController();
  String? _newManufacturerImageMock;
  bool _modelExpanded = true;
  final _modelSearchCtrl = TextEditingController();
  bool _isAddingModel = false;
  final _newModelNameCtrl = TextEditingController();
  bool _bodyTypeExpanded = true;
  final _bodyTypeSearchCtrl = TextEditingController();
  bool _isAddingBodyType = false;
  final _newBodyTypeNameCtrl = TextEditingController();
  bool _exteriorColorExpanded = true;
  final _exteriorColorSearchCtrl = TextEditingController();
  bool _isAddingExteriorColor = false;
  final _newExteriorColorNameCtrl = TextEditingController();
  String _selectedManufacturer = "Select";
  String _selectedModel = "Select manufacturer first";
  String _selectedBodyType = "Select";
  String _selectedExteriorColor = "Select";
  List<String> _selectedFeatures = [];

  final List<String> _manufacturers = [
    "AUDI",
    "BMW",
    "BMW INDIA PVT LTD",
    "Citroen",
    "FORCE",
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
    "Mercedes-Benz",
  ];

  final Map<String, List<String>> _modelsByManufacturer = {
    "AUDI": ["A4", "A6", "Q3", "Q5", "Q7"],
    "Audi": ["A4", "A6", "Q3", "Q5", "Q7"],
    "BMW": ["3 Series", "5 Series", "X1", "X3", "X5"],
    "BMW INDIA PVT LTD": ["3 Series Gran Limousine", "5 Series", "X1", "X5"],
    "Citroen": ["C3", "C3 Aircross", "C5 Aircross", "eC3"],
    "FORCE": ["Gurkha", "Trax Cruiser", "Urbania"],
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
    "2 WHEELER",
    "5 DOOR STEEL SHELL",
    "BODY ON CHASSIS FRAME",
    "CAR (SEDAN)",
    "Electric",
    "E-RICKSHAW",
  ];

  final List<Map<String, dynamic>> _exteriorColors = [
    {"name": "White", "color": Colors.white, "border": true},
    {"name": "Pearl White", "color": const Color(0xFFFDFBF7), "border": true},
    {"name": "Silver", "color": const Color(0xFFC0C0C0), "border": false},
    {"name": "Grey", "color": const Color(0xFF808080), "border": false},
    {"name": "Black", "color": const Color(0xFF1E293B), "border": false},
    {"name": "Red", "color": const Color(0xFFDC2626), "border": false},
    {"name": "Blue", "color": const Color(0xFF2563EB), "border": false},
    {"name": "Brown", "color": const Color(0xFF78350F), "border": false},
    {"name": "Beige / Gold", "color": const Color(0xFFD4AF37), "border": false},
    {"name": "Green", "color": const Color(0xFF16A34A), "border": false},
    {"name": "Orange", "color": const Color(0xFFEA580C), "border": false},
    {"name": "Yellow", "color": const Color(0xFFCA8A04), "border": false},
  ];

  final List<String> _featuresList = [
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
  final _permanentUrlSlugCtrl = TextEditingController(text: "caruid979");
  final _metaKeywordsCtrl = TextEditingController();
  final _metaDescriptionCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final cleanUid =
        widget.carUid.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    _permanentUrlSlugCtrl.text =
        cleanUid.isNotEmpty ? cleanUid : "caruid979";
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
    _manufacturerSearchCtrl.dispose();
    _newManufacturerNameCtrl.dispose();
    _modelSearchCtrl.dispose();
    _newModelNameCtrl.dispose();
    _bodyTypeSearchCtrl.dispose();
    _newBodyTypeNameCtrl.dispose();
    _exteriorColorSearchCtrl.dispose();
    _newExteriorColorNameCtrl.dispose();
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
              const SizedBox(height: 14),

              // 2. Individual Slim Action Tiles (from Image 1: Publishing, Manufacturer, Model, Body Type, Exterior Color, Features, Home Sections, RTO Rules, TCS Rules)
              _buildSlimTilesSection(),
              const SizedBox(height: 6),

              // 3. Image Gallery Section (Card)
              _buildImageGalleryCard(),
              const SizedBox(height: 14),

              // 4. SEO & Metadata Section (Card from Image 2)
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

  // ================= 2. INDIVIDUAL SLIM ACTION TILES (IMAGE 1) =================
  Widget _buildSlimTilesSection() {
    return Column(
      children: [
        // 1. Publishing Card (Image 2)
        _buildPublishingCard(),

        // 2. Manufacturer * (Card - Image 2)
        _buildManufacturerCard(),

        // 3. Model * (Card - Image 2)
        _buildModelCard(),

        // 4. Body Type (Card - Image 1)
        _buildBodyTypeCard(),

        // 5. Exterior Color * (Card - Image 2)
        _buildExteriorColorCard(),

        // 6. Features
        _buildSlimActionTile(
          leadingIcon: const Icon(
            Icons.view_list_rounded,
            color: Color(0xFF10B981),
            size: 20,
          ),
          title: "Features",
          rightText: _selectedFeatures.isNotEmpty
              ? "${_selectedFeatures.length} selected"
              : null,
          onTap: _showFeaturesPicker,
        ),

        // 7. Home Sections
        _buildSlimActionTile(
          leadingIcon: const Icon(
            Icons.meeting_room_outlined,
            color: Color(0xFFEF4444),
            size: 20,
          ),
          title: "Home Sections",
          rightText: _selectedHomeSections.isNotEmpty
              ? "${_selectedHomeSections.length} selected"
              : null,
          onTap: _showHomeSectionsPicker,
        ),

        // 8. RTO Rules
        _buildSlimActionTile(
          leadingIcon: const Icon(
            Icons.architecture_rounded,
            color: Color(0xFFF97316),
            size: 20,
          ),
          title: "RTO Rules",
          rightText: _selectedRtoRule,
          onTap: _showRtoRulesPicker,
        ),

        // 9. TCS Rules
        _buildSlimActionTile(
          leadingIcon: const Icon(
            Icons.auto_awesome,
            color: Color(0xFF06B6D4),
            size: 19,
          ),
          title: "TCS Rules",
          rightText: _selectedTcsRule,
          onTap: _showTcsRulesPicker,
        ),
      ],
    );
  }

  Widget _buildSlimActionTile({
    required Widget leadingIcon,
    required String title,
    bool isRequired = false,
    String? rightText,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          child: Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Center(child: leadingIcon),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: RichText(
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
              ),
              if (rightText != null && rightText.isNotEmpty) ...[
                Text(
                  rightText,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(width: 4),
              ],
              const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: Color(0xFF94A3B8),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= PUBLISHING CARD (IMAGE 2) =================
  Widget _buildPublishingCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (Collapsible)
          InkWell(
            onTap: () {
              setState(() {
                _publishingExpanded = !_publishingExpanded;
              });
            },
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              child: Row(
                children: [
                  const Icon(
                    Icons.near_me_outlined,
                    color: Color(0xFF10B981),
                    size: 19,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Publishing",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    _publishingExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 22,
                    color: const Color(0xFF64748B),
                  ),
                ],
              ),
            ),
          ),

          if (_publishingExpanded) ...[
            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Buttons: Save Draft & Preview
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        onPressed: _saveDraft,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF4F46E5),
                          side: const BorderSide(color: Color(0xFF818CF8)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: Text(
                          "Save Draft",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      OutlinedButton(
                        onPressed: _showVehiclePreview,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF4F46E5),
                          side: const BorderSide(color: Color(0xFF818CF8)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: Text(
                          "Preview",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Divider(
                      height: 1, thickness: 1, color: Color(0xFFF1F5F9)),

                  // Row 1: Location
                  _buildPublishingDetailRow(
                    icon: Icons.location_on_outlined,
                    label: "Location:",
                    value: _location,
                    onEdit: _showLocationPicker,
                  ),
                  const Divider(
                      height: 1, thickness: 1, color: Color(0xFFF1F5F9)),

                  // Row 2: Status
                  _buildPublishingDetailRow(
                    icon: Icons.vpn_key_outlined,
                    label: "Status:",
                    value: _publishingStatus,
                    onEdit: _showPublishingStatusPicker,
                  ),
                  const Divider(
                      height: 1, thickness: 1, color: Color(0xFFF1F5F9)),

                  // Row 3: Homepage
                  _buildPublishingDetailRow(
                    icon: Icons.home_outlined,
                    label: "Homepage:",
                    value: _homepageVisibility,
                    onEdit: _showHomepagePicker,
                  ),
                  const Divider(
                      height: 1, thickness: 1, color: Color(0xFFF1F5F9)),

                  // Row 4: Schedule
                  _buildPublishingDetailRow(
                    icon: Icons.calendar_today_outlined,
                    label: "Schedule:",
                    value: _scheduleOption,
                    onEdit: _showSchedulePicker,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPublishingDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onEdit,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF94A3B8)),
          const SizedBox(width: 10),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF475569),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0F172A),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          InkWell(
            onTap: onEdit,
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              child: Text(
                "Edit",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0D9488),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= MANUFACTURER CARD (IMAGE 2) =================
  Widget _buildManufacturerCard() {
    final search = _manufacturerSearchCtrl.text.trim().toLowerCase();
    final filtered = _manufacturers
        .where((m) => m.toLowerCase().contains(search))
        .toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (Collapsible)
          InkWell(
            onTap: () {
              setState(() {
                _manufacturerExpanded = !_manufacturerExpanded;
              });
            },
            onLongPress: _showManufacturerPicker,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              child: Row(
                children: [
                  const Icon(
                    Icons.copyright_rounded,
                    color: Color(0xFFF97316),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Manufacturer",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        TextSpan(
                          text: " *",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!_manufacturerExpanded &&
                      _selectedManufacturer != "Select") ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _selectedManufacturer,
                        style: GoogleFonts.poppins(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2563EB),
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  Icon(
                    _manufacturerExpanded
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.keyboard_arrow_up_rounded,
                    size: 22,
                    color: const Color(0xFF64748B),
                  ),
                ],
              ),
            ),
          ),

          if (_manufacturerExpanded) ...[
            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),

            // Search Bar: Find manufacturer...
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
              child: TextField(
                controller: _manufacturerSearchCtrl,
                onChanged: (_) => setState(() {}),
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: const Color(0xFF0F172A),
                ),
                decoration: InputDecoration(
                  hintText: "Find manufacturer...",
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 12.5,
                    color: const Color(0xFF94A3B8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF003366)),
                  ),
                  isDense: true,
                ),
              ),
            ),

            // Manufacturer List
            Container(
              constraints: const BoxConstraints(maxHeight: 280),
              child: filtered.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: Text(
                          "No manufacturer found",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFF1F5F9),
                      ),
                      itemBuilder: (ctx, i) {
                        final mfg = filtered[i];
                        final isSelected = _selectedManufacturer == mfg;
                        return _buildManufacturerRowItem(mfg, isSelected);
                      },
                    ),
            ),

            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),

            // Footer Button: + Add Manufacturer
            InkWell(
              onTap: () {
                setState(() {
                  _isAddingManufacturer = !_isAddingManufacturer;
                });
              },
              onLongPress: _showAddManufacturerDialog,
              borderRadius: _isAddingManufacturer
                  ? BorderRadius.zero
                  : const BorderRadius.vertical(bottom: Radius.circular(10)),
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: _isAddingManufacturer
                      ? BorderRadius.zero
                      : const BorderRadius.vertical(bottom: Radius.circular(10)),
                ),
                child: Text(
                  "+ Add Manufacturer",
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF059669),
                  ),
                ),
              ),
            ),

            // Inline Add Manufacturer Form (Matching Image: media_1795244877941_05819741.png)
            if (_isAddingManufacturer) ...[
              const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Add Manufacturer ",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        Text(
                          "Manufacturer Image",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF4338CA),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Dashed border container for image
                    _buildDashedBorderContainer(
                      onTap: () {
                        setState(() {
                          if (_newManufacturerImageMock == null) {
                            _newManufacturerImageMock = "logo.png";
                          } else {
                            _newManufacturerImageMock = null;
                          }
                        });
                      },
                      child: _newManufacturerImageMock == null
                          ? const Icon(
                              Icons.image_outlined,
                              size: 32,
                              color: Color(0xFF818CF8),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: Color(0xFF14B8A6),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Image selected",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1E293B),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.close_rounded,
                                  size: 16,
                                  color: Color(0xFF94A3B8),
                                ),
                              ],
                            ),
                    ),

                    const SizedBox(height: 14),

                    Text(
                      "Manufacturer Name",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF4338CA),
                      ),
                    ),
                    const SizedBox(height: 8),

                    Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: double.infinity,
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(color: Color(0xFFE2E8F0)),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.drive_file_rename_outline_rounded,
                              size: 18,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _newManufacturerNameCtrl,
                              style: GoogleFonts.poppins(
                                fontSize: 13.5,
                                color: const Color(0xFF0F172A),
                              ),
                              decoration: InputDecoration(
                                hintText: "Name",
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: const Color(0xFF94A3B8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: _saveNewManufacturer,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF14B8A6),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text(
                            "Save",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isAddingManufacturer = false;
                              _newManufacturerNameCtrl.clear();
                              _newManufacturerImageMock = null;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF818CF8),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text(
                            "Cancel",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildManufacturerRowItem(
    String mfg,
    bool isSelected, {
    VoidCallback? onTapOverride,
    VoidCallback? onStateChange,
  }) {
    return InkWell(
      onTap: onTapOverride ??
          () {
            setState(() {
              _selectedManufacturer = mfg;
              if (_selectedModel == "Select manufacturer first") {
                _selectedModel = "Select model";
              }
            });
            onStateChange?.call();
          },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            // Radio button
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              size: 20,
              color: isSelected
                  ? const Color(0xFF2563EB)
                  : const Color(0xFFCBD5E1),
            ),
            const SizedBox(width: 12),

            // Brand Logo container
            _buildBrandLogoWidget(mfg),
            const SizedBox(width: 12),

            // Manufacturer Name
            Expanded(
              child: Text(
                mfg,
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: const Color(0xFF0F172A),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Action 1: Eye (View)
            InkWell(
              onTap: () => _viewManufacturerDetails(mfg),
              borderRadius: BorderRadius.circular(4),
              child: const Padding(
                padding: EdgeInsets.all(5),
                child: Icon(
                  Icons.visibility_outlined,
                  size: 19,
                  color: Color(0xFF14B8A6),
                ),
              ),
            ),
            const SizedBox(width: 4),

            // Action 2: Edit
            InkWell(
              onTap: () =>
                  _editManufacturerDialog(mfg, onUpdated: onStateChange),
              borderRadius: BorderRadius.circular(4),
              child: const Padding(
                padding: EdgeInsets.all(5),
                child: Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ),
            const SizedBox(width: 4),

            // Action 3: Delete
            InkWell(
              onTap: () =>
                  _deleteManufacturerDialog(mfg, onDeleted: onStateChange),
              borderRadius: BorderRadius.circular(4),
              child: const Padding(
                padding: EdgeInsets.all(5),
                child: Icon(
                  Icons.delete_outline_rounded,
                  size: 19,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleRing() {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF475569), width: 1.1),
      ),
    );
  }

  Widget _buildBrandLogoWidget(String mfg) {
    Widget inner;
    final upper = mfg.toUpperCase();

    if (upper.contains("AUDI")) {
      inner = SizedBox(
        width: 24,
        height: 10,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Positioned(left: 0, child: _buildCircleRing()),
            Positioned(left: 5, child: _buildCircleRing()),
            Positioned(left: 10, child: _buildCircleRing()),
            Positioned(left: 15, child: _buildCircleRing()),
          ],
        ),
      );
    } else if (upper.contains("BMW INDIA")) {
      inner = const Icon(
        Icons.directions_car_rounded,
        size: 16,
        color: Color(0xFF0F172A),
      );
    } else if (upper.contains("BMW")) {
      inner = Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF0F172A), width: 1.2),
          color: const Color(0xFF0284C7),
        ),
        child: Center(
          child: Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
      );
    } else if (upper.contains("CITROEN")) {
      inner = const Icon(
        Icons.keyboard_double_arrow_up_rounded,
        size: 16,
        color: Color(0xFFE11D48),
      );
    } else if (upper.contains("FORCE")) {
      inner = Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF2563EB), width: 1.2),
        ),
        child: const Center(
          child: Text(
            "F",
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2563EB),
            ),
          ),
        ),
      );
    } else if (upper.contains("MERCEDES")) {
      inner = const Icon(
        Icons.change_history_rounded,
        size: 15,
        color: Color(0xFF334155),
      );
    } else {
      inner = Text(
        mfg.isNotEmpty ? mfg.substring(0, 1).toUpperCase() : "M",
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF003366),
        ),
      );
    }

    return Container(
      width: 38,
      height: 26,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Center(child: inner),
    );
  }

  void _viewManufacturerDetails(String mfg) {
    final models = _modelsByManufacturer[mfg] ?? ["Standard Model Variants"];
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: Row(
            children: [
              _buildBrandLogoWidget(mfg),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  mfg,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "Status: Active Brand",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF15803D),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Registered Models (${models.length}):",
                style: GoogleFonts.poppins(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: models.map((mod) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      mod,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: const Color(0xFF334155),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                "Close",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF003366),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _editManufacturerDialog(String mfg, {VoidCallback? onUpdated}) {
    final editCtrl = TextEditingController(text: mfg);
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.edit_outlined,
                    color: Color(0xFF2563EB), size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                "Edit Manufacturer",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Manufacturer Name",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: editCtrl,
                autofocus: true,
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  color: const Color(0xFF0F172A),
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 11),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                "Cancel",
                style: GoogleFonts.poppins(color: const Color(0xFF64748B)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final newName = editCtrl.text.trim();
                if (newName.isNotEmpty && newName != mfg) {
                  setState(() {
                    final idx = _manufacturers.indexOf(mfg);
                    if (idx != -1) {
                      _manufacturers[idx] = newName;
                    }
                    if (_selectedManufacturer == mfg) {
                      _selectedManufacturer = newName;
                    }
                    if (_modelsByManufacturer.containsKey(mfg)) {
                      final models = _modelsByManufacturer.remove(mfg)!;
                      _modelsByManufacturer[newName] = models;
                    }
                  });
                  onUpdated?.call();
                }
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003366),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                "Update",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteManufacturerDialog(String mfg, {VoidCallback? onDeleted}) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.delete_outline_rounded,
                    color: Color(0xFFDC2626), size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                "Delete Manufacturer",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          content: Text(
            "Are you sure you want to remove \"$mfg\"? This action cannot be undone.",
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: const Color(0xFF475569),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                "Cancel",
                style: GoogleFonts.poppins(color: const Color(0xFF64748B)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _manufacturers.remove(mfg);
                  if (_selectedManufacturer == mfg) {
                    _selectedManufacturer = "Select";
                    _selectedModel = "Select manufacturer first";
                  }
                });
                onDeleted?.call();
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                "Delete",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  void _saveNewManufacturer() {
    final name = _newManufacturerNameCtrl.text.trim();
    if (name.isNotEmpty) {
      setState(() {
        if (!_manufacturers.contains(name)) {
          _manufacturers.insert(0, name);
        }
        _selectedManufacturer = name;
        if (_selectedModel == "Select manufacturer first") {
          _selectedModel = "Select model";
        }
        _isAddingManufacturer = false;
        _newManufacturerNameCtrl.clear();
        _newManufacturerImageMock = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Manufacturer '$name' added successfully!"),
          backgroundColor: const Color(0xFF059669),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showAddManufacturerDialog({VoidCallback? onAdded}) {
    final addCtrl = TextEditingController();
    String? mockImg;
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dCtx, setDState) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              insetPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Add Manufacturer ",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        Text(
                          "Manufacturer Image",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF4338CA),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    _buildDashedBorderContainer(
                      onTap: () {
                        setDState(() {
                          if (mockImg == null) {
                            mockImg = "logo.png";
                          } else {
                            mockImg = null;
                          }
                        });
                      },
                      child: mockImg == null
                          ? const Icon(
                              Icons.image_outlined,
                              size: 32,
                              color: Color(0xFF818CF8),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: Color(0xFF14B8A6),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Image selected",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1E293B),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.close_rounded,
                                  size: 16,
                                  color: Color(0xFF94A3B8),
                                ),
                              ],
                            ),
                    ),

                    const SizedBox(height: 14),

                    Text(
                      "Manufacturer Name",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF4338CA),
                      ),
                    ),
                    const SizedBox(height: 8),

                    Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: double.infinity,
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(color: Color(0xFFE2E8F0)),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.drive_file_rename_outline_rounded,
                              size: 18,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: addCtrl,
                              style: GoogleFonts.poppins(
                                fontSize: 13.5,
                                color: const Color(0xFF0F172A),
                              ),
                              decoration: InputDecoration(
                                hintText: "Name",
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: const Color(0xFF94A3B8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            final val = addCtrl.text.trim();
                            if (val.isNotEmpty &&
                                !_manufacturers.contains(val)) {
                              setState(() {
                                _manufacturers.insert(0, val);
                                _selectedManufacturer = val;
                                if (_selectedModel ==
                                    "Select manufacturer first") {
                                  _selectedModel = "Select model";
                                }
                              });
                              onAdded?.call();
                            }
                            Navigator.pop(ctx);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF14B8A6),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text(
                            "Save",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF818CF8),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text(
                            "Cancel",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDashedBorderContainer({
    required Widget child,
    double height = 76,
    double radius = 8,
    Color borderColor = const Color(0xFFCBD5E1),
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(radius),
      child: CustomPaint(
        painter: _DashedRectPainter(
          color: borderColor,
          strokeWidth: 1.2,
          dash: 5,
          gap: 3,
          radius: radius,
        ),
        child: Container(
          width: double.infinity,
          height: height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFFAFAFA),
            borderRadius: BorderRadius.circular(radius),
          ),
          child: child,
        ),
      ),
    );
  }

  // ================= MODEL CARD (IMAGE 2) =================
  Widget _buildModelCard() {
    final hasMfg = _selectedManufacturer.isNotEmpty &&
        _selectedManufacturer != "Select";
    final models = hasMfg
        ? (_modelsByManufacturer[_selectedManufacturer] ?? [])
        : <String>[];
    final search = _modelSearchCtrl.text.trim().toLowerCase();
    final filtered = models
        .where((m) => m.toLowerCase().contains(search))
        .toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (Collapsible)
          InkWell(
            onTap: () {
              setState(() {
                _modelExpanded = !_modelExpanded;
              });
            },
            onLongPress: _showModelPicker,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              child: Row(
                children: [
                  const Icon(
                    Icons.directions_car_filled_rounded,
                    color: Color(0xFF06B6D4),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Model",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        TextSpan(
                          text: " *",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!_modelExpanded &&
                      _selectedModel != "Select manufacturer first" &&
                      _selectedModel != "Select model") ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFEFF),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _selectedModel,
                        style: GoogleFonts.poppins(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0891B2),
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  Icon(
                    _modelExpanded
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.keyboard_arrow_up_rounded,
                    size: 22,
                    color: const Color(0xFF64748B),
                  ),
                ],
              ),
            ),
          ),

          if (_modelExpanded) ...[
            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),

            // Search Bar: Find model...
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
              child: TextField(
                controller: _modelSearchCtrl,
                onChanged: (_) => setState(() {}),
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: const Color(0xFF0F172A),
                ),
                decoration: InputDecoration(
                  hintText: "Find model...",
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 12.5,
                    color: const Color(0xFF94A3B8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF003366)),
                  ),
                  isDense: true,
                ),
              ),
            ),

            // Body
            if (!hasMfg)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 24),
                child: Center(
                  child: Text(
                    "Select Manufacturer First",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ),
              )
            else
              Container(
                constraints: const BoxConstraints(maxHeight: 280),
                child: filtered.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(20),
                        child: Center(
                          child: Text(
                            "No model found for $_selectedManufacturer",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: const Color(0xFF94A3B8),
                            ),
                          ),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const Divider(
                          height: 1,
                          thickness: 1,
                          color: Color(0xFFF1F5F9),
                        ),
                        itemBuilder: (ctx, i) {
                          final mod = filtered[i];
                          final isSelected = _selectedModel == mod;
                          return _buildModelRowItem(mod, isSelected);
                        },
                      ),
              ),

            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),

            // Footer Button: + Add Model
            InkWell(
              onTap: () {
                setState(() {
                  _isAddingModel = !_isAddingModel;
                });
              },
              onLongPress: _showAddModelDialog,
              borderRadius: _isAddingModel
                  ? BorderRadius.zero
                  : const BorderRadius.vertical(bottom: Radius.circular(10)),
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: _isAddingModel
                      ? BorderRadius.zero
                      : const BorderRadius.vertical(bottom: Radius.circular(10)),
                ),
                child: Text(
                  "+ Add Model",
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF059669),
                  ),
                ),
              ),
            ),

            // Inline Add Model Form (Matching Image: media_1795243797134_c5c8999b.png)
            if (_isAddingModel) ...[
              const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Add Model ",
                          style: GoogleFonts.poppins(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          "Model Name",
                          style: GoogleFonts.poppins(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF4F46E5),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(5)),
                              border: Border(
                                right: BorderSide(color: Color(0xFFCBD5E1)),
                              ),
                            ),
                            child: const Icon(
                              Icons.edit_note_rounded,
                              size: 19,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _newModelNameCtrl,
                              autofocus: true,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: const Color(0xFF0F172A),
                              ),
                              decoration: InputDecoration(
                                hintText: "Name",
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: const Color(0xFF94A3B8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              onSubmitted: (_) => _saveNewModel(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: _saveNewModel,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF14B8A6),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text(
                            "Save",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isAddingModel = false;
                              _newModelNameCtrl.clear();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF818CF8),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text(
                            "Cancel",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  void _saveNewModel() {
    final val = _newModelNameCtrl.text.trim();
    if (val.isNotEmpty) {
      final targetMfg = _selectedManufacturer != "Select"
          ? _selectedManufacturer
          : (_manufacturers.isNotEmpty
              ? _manufacturers.first
              : "Maruti Suzuki");

      setState(() {
        if (!_modelsByManufacturer.containsKey(targetMfg)) {
          _modelsByManufacturer[targetMfg] = [];
        }
        if (!_modelsByManufacturer[targetMfg]!.contains(val)) {
          _modelsByManufacturer[targetMfg]!.insert(0, val);
        }
        _selectedModel = val;
        if (_carNameCtrl.text.isEmpty) {
          _carNameCtrl.text = _selectedManufacturer != "Select"
              ? "$_selectedManufacturer $val"
              : val;
        }
        _isAddingModel = false;
        _newModelNameCtrl.clear();
      });
    }
  }

  Widget _buildModelRowItem(
    String mod,
    bool isSelected, {
    VoidCallback? onTapOverride,
    VoidCallback? onStateChange,
  }) {
    return InkWell(
      onTap: onTapOverride ??
          () {
            setState(() {
              _selectedModel = mod;
              if (_carNameCtrl.text.isEmpty) {
                _carNameCtrl.text = _selectedManufacturer != "Select"
                    ? "$_selectedManufacturer $mod"
                    : mod;
              }
            });
            onStateChange?.call();
          },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        child: Row(
          children: [
            // Radio button
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              size: 20,
              color: isSelected
                  ? const Color(0xFF2563EB)
                  : const Color(0xFFCBD5E1),
            ),
            const SizedBox(width: 12),

            // Model name
            Expanded(
              child: Text(
                mod,
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: const Color(0xFF0F172A),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Action 1: Eye (View)
            InkWell(
              onTap: () => _viewModelDetails(mod),
              borderRadius: BorderRadius.circular(4),
              child: const Padding(
                padding: EdgeInsets.all(5),
                child: Icon(
                  Icons.visibility_outlined,
                  size: 19,
                  color: Color(0xFF14B8A6),
                ),
              ),
            ),
            const SizedBox(width: 4),

            // Action 2: Edit
            InkWell(
              onTap: () => _editModelDialog(mod, onUpdated: onStateChange),
              borderRadius: BorderRadius.circular(4),
              child: const Padding(
                padding: EdgeInsets.all(5),
                child: Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ),
            const SizedBox(width: 4),

            // Action 3: Delete
            InkWell(
              onTap: () => _deleteModelDialog(mod, onDeleted: onStateChange),
              borderRadius: BorderRadius.circular(4),
              child: const Padding(
                padding: EdgeInsets.all(5),
                child: Icon(
                  Icons.delete_outline_rounded,
                  size: 19,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _viewModelDetails(String mod) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFEFF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.directions_car_filled_rounded,
                    color: Color(0xFF0891B2), size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  mod,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "Status: Active Production Model",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF15803D),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Manufacturer: ${_selectedManufacturer != 'Select' ? _selectedManufacturer : 'Generic / Multibrand'}",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Supported Variants: Petrol, Diesel, CNG, Hybrid",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                "Close",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF003366),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _editModelDialog(String mod, {VoidCallback? onUpdated}) {
    final editCtrl = TextEditingController(text: mod);
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.edit_outlined,
                    color: Color(0xFF2563EB), size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                "Edit Model",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Model Name",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: editCtrl,
                autofocus: true,
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  color: const Color(0xFF0F172A),
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 11),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                "Cancel",
                style: GoogleFonts.poppins(color: const Color(0xFF64748B)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final newName = editCtrl.text.trim();
                if (newName.isNotEmpty && newName != mod) {
                  setState(() {
                    for (var entry in _modelsByManufacturer.entries) {
                      final idx = entry.value.indexOf(mod);
                      if (idx != -1) {
                        entry.value[idx] = newName;
                      }
                    }
                    if (_selectedModel == mod) {
                      _selectedModel = newName;
                    }
                  });
                  onUpdated?.call();
                }
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003366),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                "Update",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteModelDialog(String mod, {VoidCallback? onDeleted}) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.delete_outline_rounded,
                    color: Color(0xFFDC2626), size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                "Delete Model",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          content: Text(
            "Are you sure you want to remove \"$mod\"? This action cannot be undone.",
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: const Color(0xFF475569),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                "Cancel",
                style: GoogleFonts.poppins(color: const Color(0xFF64748B)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  for (var entry in _modelsByManufacturer.entries) {
                    entry.value.remove(mod);
                  }
                  if (_selectedModel == mod) {
                    _selectedModel = "Select model";
                  }
                });
                onDeleted?.call();
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                "Delete",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAddModelDialog({VoidCallback? onAdded}) {
    final addCtrl = TextEditingController();
    String targetMfg = _selectedManufacturer != "Select"
        ? _selectedManufacturer
        : (_manufacturers.isNotEmpty ? _manufacturers.first : "Maruti Suzuki");

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.add_rounded,
                        color: Color(0xFF059669), size: 20),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Add Model",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Manufacturer",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFCBD5E1)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: targetMfg,
                        isExpanded: true,
                        items: _manufacturers.map((m) {
                          return DropdownMenuItem(
                            value: m,
                            child: Text(
                              m,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setDialogState(() => targetMfg = val);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Model Name *",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: addCtrl,
                    autofocus: true,
                    style: GoogleFonts.poppins(
                      fontSize: 13.5,
                      color: const Color(0xFF0F172A),
                    ),
                    decoration: InputDecoration(
                      hintText: "e.g. Slavia, Fronx, Elevate...",
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 12.5,
                        color: const Color(0xFF94A3B8),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 11),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.poppins(color: const Color(0xFF64748B)),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final val = addCtrl.text.trim();
                    if (val.isNotEmpty) {
                      setState(() {
                        if (!_modelsByManufacturer.containsKey(targetMfg)) {
                          _modelsByManufacturer[targetMfg] = [];
                        }
                        if (!_modelsByManufacturer[targetMfg]!.contains(val)) {
                          _modelsByManufacturer[targetMfg]!.insert(0, val);
                        }
                        if (_selectedManufacturer == targetMfg) {
                          _selectedModel = val;
                          if (_carNameCtrl.text.isEmpty) {
                            _carNameCtrl.text = "$targetMfg $val";
                          }
                        }
                      });
                      onAdded?.call();
                    }
                    Navigator.pop(ctx);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF059669),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(
                    "Save",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ================= BODY TYPE CARD (IMAGE 1) =================
  Widget _buildBodyTypeCard() {
    final search = _bodyTypeSearchCtrl.text.trim().toLowerCase();
    final filtered =
        _bodyTypes.where((b) => b.toLowerCase().contains(search)).toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (Collapsible)
          InkWell(
            onTap: () {
              setState(() {
                _bodyTypeExpanded = !_bodyTypeExpanded;
              });
            },
            onLongPress: _showBodyTypePicker,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              child: Row(
                children: [
                  const Icon(
                    Icons.local_shipping_outlined,
                    color: Color(0xFF8B5CF6),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Body Type",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  if (!_bodyTypeExpanded && _selectedBodyType != "Select") ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3E8FF),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _selectedBodyType,
                        style: GoogleFonts.poppins(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF7C3AED),
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  Icon(
                    _bodyTypeExpanded
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.keyboard_arrow_up_rounded,
                    size: 22,
                    color: const Color(0xFF64748B),
                  ),
                ],
              ),
            ),
          ),

          if (_bodyTypeExpanded) ...[
            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),

            // Search Bar: Find body type...
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
              child: TextField(
                controller: _bodyTypeSearchCtrl,
                onChanged: (_) => setState(() {}),
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: const Color(0xFF0F172A),
                ),
                decoration: InputDecoration(
                  hintText: "Find body type...",
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 12.5,
                    color: const Color(0xFF94A3B8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF003366)),
                  ),
                  isDense: true,
                ),
              ),
            ),

            // List of Body Types
            Container(
              constraints: const BoxConstraints(maxHeight: 280),
              child: filtered.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: Text(
                          "No body type found",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFF1F5F9),
                      ),
                      itemBuilder: (ctx, i) {
                        final bt = filtered[i];
                        final isSelected = _selectedBodyType == bt;
                        return _buildBodyTypeRowItem(bt, isSelected);
                      },
                    ),
            ),

            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),

            // Footer Button: + Add Body Type
            InkWell(
              onTap: () {
                setState(() {
                  _isAddingBodyType = !_isAddingBodyType;
                });
              },
              onLongPress: _showAddBodyTypeDialog,
              borderRadius: _isAddingBodyType
                  ? BorderRadius.zero
                  : const BorderRadius.vertical(bottom: Radius.circular(10)),
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: _isAddingBodyType
                      ? BorderRadius.zero
                      : const BorderRadius.vertical(bottom: Radius.circular(10)),
                ),
                child: Text(
                  "+ Add Body Type",
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF059669),
                  ),
                ),
              ),
            ),

            // Inline Add Body Type Form
            if (_isAddingBodyType) ...[
              const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Add Body Type ",
                          style: GoogleFonts.poppins(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          "Body Type Name",
                          style: GoogleFonts.poppins(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF4F46E5),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(5)),
                              border: Border(
                                right: BorderSide(color: Color(0xFFCBD5E1)),
                              ),
                            ),
                            child: const Icon(
                              Icons.edit_note_rounded,
                              size: 19,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _newBodyTypeNameCtrl,
                              autofocus: true,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: const Color(0xFF0F172A),
                              ),
                              decoration: InputDecoration(
                                hintText: "Name",
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: const Color(0xFF94A3B8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              onSubmitted: (_) => _saveNewBodyType(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: _saveNewBodyType,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF14B8A6),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text(
                            "Save",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isAddingBodyType = false;
                              _newBodyTypeNameCtrl.clear();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF818CF8),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text(
                            "Cancel",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  void _saveNewBodyType() {
    final val = _newBodyTypeNameCtrl.text.trim();
    if (val.isNotEmpty) {
      setState(() {
        if (!_bodyTypes.contains(val)) {
          _bodyTypes.insert(0, val);
        }
        _selectedBodyType = val;
        _isAddingBodyType = false;
        _newBodyTypeNameCtrl.clear();
      });
    }
  }

  Widget _buildBodyTypeRowItem(
    String bt,
    bool isSelected, {
    VoidCallback? onTapOverride,
    VoidCallback? onStateChange,
  }) {
    return InkWell(
      onTap: onTapOverride ??
          () {
            setState(() {
              _selectedBodyType = bt;
            });
            onStateChange?.call();
          },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            // Radio button
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              size: 20,
              color: isSelected
                  ? const Color(0xFF2563EB)
                  : const Color(0xFFCBD5E1),
            ),
            const SizedBox(width: 12),

            // Car icon badge
            Container(
              width: 38,
              height: 26,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Center(
                child: Icon(
                  Icons.directions_car_rounded,
                  size: 16,
                  color: Color(0xFF0F172A),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Body Type name
            Expanded(
              child: Text(
                bt,
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: const Color(0xFF0F172A),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Action 1: Eye (View)
            InkWell(
              onTap: () => _viewBodyTypeDetails(bt),
              borderRadius: BorderRadius.circular(4),
              child: const Padding(
                padding: EdgeInsets.all(5),
                child: Icon(
                  Icons.visibility_outlined,
                  size: 19,
                  color: Color(0xFF14B8A6),
                ),
              ),
            ),
            const SizedBox(width: 4),

            // Action 2: Edit
            InkWell(
              onTap: () => _editBodyTypeDialog(bt, onUpdated: onStateChange),
              borderRadius: BorderRadius.circular(4),
              child: const Padding(
                padding: EdgeInsets.all(5),
                child: Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ),
            const SizedBox(width: 4),

            // Action 3: Delete
            InkWell(
              onTap: () => _deleteBodyTypeDialog(bt, onDeleted: onStateChange),
              borderRadius: BorderRadius.circular(4),
              child: const Padding(
                padding: EdgeInsets.all(5),
                child: Icon(
                  Icons.delete_outline_rounded,
                  size: 19,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _viewBodyTypeDetails(String bt) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E8FF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.local_shipping_outlined,
                    color: Color(0xFF7C3AED), size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  bt,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "Status: Active Standard Category",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF15803D),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Category: Official Vehicle Body Classification",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Used for RTO registration & vehicle specification filtering.",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                "Close",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF003366),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _editBodyTypeDialog(String bt, {VoidCallback? onUpdated}) {
    final editCtrl = TextEditingController(text: bt);
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.edit_outlined,
                    color: Color(0xFF2563EB), size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                "Edit Body Type",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Body Type Name",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: editCtrl,
                autofocus: true,
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  color: const Color(0xFF0F172A),
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 11),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                "Cancel",
                style: GoogleFonts.poppins(color: const Color(0xFF64748B)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final newName = editCtrl.text.trim();
                if (newName.isNotEmpty && newName != bt) {
                  setState(() {
                    final idx = _bodyTypes.indexOf(bt);
                    if (idx != -1) {
                      _bodyTypes[idx] = newName;
                    }
                    if (_selectedBodyType == bt) {
                      _selectedBodyType = newName;
                    }
                  });
                  onUpdated?.call();
                }
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003366),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                "Update",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteBodyTypeDialog(String bt, {VoidCallback? onDeleted}) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.delete_outline_rounded,
                    color: Color(0xFFDC2626), size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                "Delete Body Type",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          content: Text(
            "Are you sure you want to remove \"$bt\"? This action cannot be undone.",
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: const Color(0xFF475569),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                "Cancel",
                style: GoogleFonts.poppins(color: const Color(0xFF64748B)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _bodyTypes.remove(bt);
                  if (_selectedBodyType == bt) {
                    _selectedBodyType = "Select";
                  }
                });
                onDeleted?.call();
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                "Delete",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAddBodyTypeDialog({VoidCallback? onAdded}) {
    final addCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.add_rounded,
                    color: Color(0xFF059669), size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                "Add Body Type",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Body Type Name *",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: addCtrl,
                autofocus: true,
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  color: const Color(0xFF0F172A),
                ),
                decoration: InputDecoration(
                  hintText: "e.g. CONVERTIBLE, VAN...",
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 12.5,
                    color: const Color(0xFF94A3B8),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 11),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                "Cancel",
                style: GoogleFonts.poppins(color: const Color(0xFF64748B)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final val = addCtrl.text.trim();
                if (val.isNotEmpty && !_bodyTypes.contains(val)) {
                  setState(() {
                    _bodyTypes.insert(0, val);
                    _selectedBodyType = val;
                  });
                  onAdded?.call();
                }
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF059669),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                "Save",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  // ================= EXTERIOR COLOR CARD (IMAGE 2) =================
  Widget _buildExteriorColorCard() {
    final search = _exteriorColorSearchCtrl.text.trim().toLowerCase();
    final filtered = _exteriorColors.where((item) {
      final name = (item["name"] as String).toLowerCase();
      return name.contains(search);
    }).toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (Collapsible)
          InkWell(
            onTap: () {
              setState(() {
                _exteriorColorExpanded = !_exteriorColorExpanded;
              });
            },
            onLongPress: _showColorPicker,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              child: Row(
                children: [
                  const Icon(
                    Icons.palette_outlined,
                    color: Color(0xFF10B981),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Exterior Color",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        TextSpan(
                          text: " *",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!_exteriorColorExpanded &&
                      _selectedExteriorColor != "Select") ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _selectedExteriorColor,
                        style: GoogleFonts.poppins(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF15803D),
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  Icon(
                    _exteriorColorExpanded
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.keyboard_arrow_up_rounded,
                    size: 22,
                    color: const Color(0xFF64748B),
                  ),
                ],
              ),
            ),
          ),

          if (_exteriorColorExpanded) ...[
            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),

            // Search Bar: Find color...
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
              child: TextField(
                controller: _exteriorColorSearchCtrl,
                onChanged: (_) => setState(() {}),
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: const Color(0xFF0F172A),
                ),
                decoration: InputDecoration(
                  hintText: "Find color...",
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 12.5,
                    color: const Color(0xFF94A3B8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF003366)),
                  ),
                  isDense: true,
                ),
              ),
            ),

            // List of Exterior Colors
            Container(
              constraints: const BoxConstraints(maxHeight: 280),
              child: filtered.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: Text(
                          "No color found",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFF1F5F9),
                      ),
                      itemBuilder: (ctx, i) {
                        final item = filtered[i];
                        final name = item["name"] as String;
                        final color = item["color"] as Color;
                        final border = (item["border"] ?? false) as bool;
                        final isSelected = _selectedExteriorColor == name;
                        return _buildExteriorColorRowItem(
                          name,
                          color,
                          border,
                          isSelected,
                        );
                      },
                    ),
            ),

            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),

            // Footer Button: + Add Color
            InkWell(
              onTap: () {
                setState(() {
                  _isAddingExteriorColor = !_isAddingExteriorColor;
                });
              },
              onLongPress: _showAddExteriorColorDialog,
              borderRadius: _isAddingExteriorColor
                  ? BorderRadius.zero
                  : const BorderRadius.vertical(bottom: Radius.circular(10)),
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: _isAddingExteriorColor
                      ? BorderRadius.zero
                      : const BorderRadius.vertical(bottom: Radius.circular(10)),
                ),
                child: Text(
                  "+ Add Color",
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF059669),
                  ),
                ),
              ),
            ),

            // Inline Add Color Form
            if (_isAddingExteriorColor) ...[
              const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Add Color ",
                          style: GoogleFonts.poppins(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          "Color Name",
                          style: GoogleFonts.poppins(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF4F46E5),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(5)),
                              border: Border(
                                right: BorderSide(color: Color(0xFFCBD5E1)),
                              ),
                            ),
                            child: const Icon(
                              Icons.edit_note_rounded,
                              size: 19,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _newExteriorColorNameCtrl,
                              autofocus: true,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: const Color(0xFF0F172A),
                              ),
                              decoration: InputDecoration(
                                hintText: "Name",
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: const Color(0xFF94A3B8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              onSubmitted: (_) => _saveNewExteriorColor(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: _saveNewExteriorColor,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF14B8A6),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text(
                            "Save",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isAddingExteriorColor = false;
                              _newExteriorColorNameCtrl.clear();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF818CF8),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text(
                            "Cancel",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  void _saveNewExteriorColor() {
    final val = _newExteriorColorNameCtrl.text.trim();
    if (val.isNotEmpty) {
      setState(() {
        final exists = _exteriorColors.any((c) =>
            (c["name"] as String).toLowerCase() == val.toLowerCase());
        if (!exists) {
          _exteriorColors.insert(0, {
            "name": val,
            "color": const Color(0xFF94A3B8),
            "border": false,
          });
        }
        _selectedExteriorColor = val;
        _isAddingExteriorColor = false;
        _newExteriorColorNameCtrl.clear();
      });
    }
  }

  Widget _buildExteriorColorRowItem(
    String name,
    Color color,
    bool border,
    bool isSelected, {
    VoidCallback? onTapOverride,
    VoidCallback? onStateChange,
  }) {
    return InkWell(
      onTap: onTapOverride ??
          () {
            setState(() {
              _selectedExteriorColor = name;
            });
            onStateChange?.call();
          },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            // Radio button
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              size: 20,
              color: isSelected
                  ? const Color(0xFF2563EB)
                  : const Color(0xFFCBD5E1),
            ),
            const SizedBox(width: 12),

            // Color circle
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: border
                      ? const Color(0xFFCBD5E1)
                      : color,
                  width: 1,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Color name
            Expanded(
              child: Text(
                name,
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: const Color(0xFF0F172A),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Action 1: Eye (View)
            InkWell(
              onTap: () => _viewExteriorColorDetails(name, color),
              borderRadius: BorderRadius.circular(4),
              child: const Padding(
                padding: EdgeInsets.all(5),
                child: Icon(
                  Icons.visibility_outlined,
                  size: 19,
                  color: Color(0xFF14B8A6),
                ),
              ),
            ),
            const SizedBox(width: 4),

            // Action 2: Edit
            InkWell(
              onTap: () =>
                  _editExteriorColorDialog(name, onUpdated: onStateChange),
              borderRadius: BorderRadius.circular(4),
              child: const Padding(
                padding: EdgeInsets.all(5),
                child: Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ),
            const SizedBox(width: 4),

            // Action 3: Delete
            InkWell(
              onTap: () =>
                  _deleteExteriorColorDialog(name, onDeleted: onStateChange),
              borderRadius: BorderRadius.circular(4),
              child: const Padding(
                padding: EdgeInsets.all(5),
                child: Icon(
                  Icons.delete_outline_rounded,
                  size: 19,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _viewExteriorColorDetails(String name, Color color) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "Status: Active Standard Finish",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF15803D),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Shade: Official Automotive OEM Grade Paint",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Used for vehicle body exterior styling & customer catalog filter.",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                "Close",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF003366),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _editExteriorColorDialog(String name, {VoidCallback? onUpdated}) {
    final editCtrl = TextEditingController(text: name);
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.edit_outlined,
                    color: Color(0xFF2563EB), size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                "Edit Exterior Color",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Color Name",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: editCtrl,
                autofocus: true,
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  color: const Color(0xFF0F172A),
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 11),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                "Cancel",
                style: GoogleFonts.poppins(color: const Color(0xFF64748B)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final newName = editCtrl.text.trim();
                if (newName.isNotEmpty && newName != name) {
                  setState(() {
                    for (var c in _exteriorColors) {
                      if (c["name"] == name) {
                        c["name"] = newName;
                        break;
                      }
                    }
                    if (_selectedExteriorColor == name) {
                      _selectedExteriorColor = newName;
                    }
                  });
                  onUpdated?.call();
                }
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003366),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                "Update",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteExteriorColorDialog(String name, {VoidCallback? onDeleted}) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.delete_outline_rounded,
                    color: Color(0xFFDC2626), size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                "Delete Exterior Color",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          content: Text(
            "Are you sure you want to remove \"$name\"? This action cannot be undone.",
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: const Color(0xFF475569),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                "Cancel",
                style: GoogleFonts.poppins(color: const Color(0xFF64748B)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _exteriorColors.removeWhere((c) => c["name"] == name);
                  if (_selectedExteriorColor == name) {
                    _selectedExteriorColor = "Select";
                  }
                });
                onDeleted?.call();
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                "Delete",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAddExteriorColorDialog({VoidCallback? onAdded}) {
    final addCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.add_rounded,
                    color: Color(0xFF059669), size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                "Add Exterior Color",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Color Name *",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: addCtrl,
                autofocus: true,
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  color: const Color(0xFF0F172A),
                ),
                decoration: InputDecoration(
                  hintText: "e.g. Bronze, Maroon...",
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 12.5,
                    color: const Color(0xFF94A3B8),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 11),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                "Cancel",
                style: GoogleFonts.poppins(color: const Color(0xFF64748B)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final val = addCtrl.text.trim();
                if (val.isNotEmpty) {
                  final exists = _exteriorColors.any((c) =>
                      (c["name"] as String).toLowerCase() ==
                      val.toLowerCase());
                  if (!exists) {
                    setState(() {
                      _exteriorColors.insert(0, {
                        "name": val,
                        "color": const Color(0xFF94A3B8),
                        "border": false,
                      });
                      _selectedExteriorColor = val;
                    });
                    onAdded?.call();
                  }
                }
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF059669),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                "Save",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  void _saveDraft() {
    setState(() {
      _publishingStatus = "Draft";
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Vehicle saved as Draft successfully!"),
        backgroundColor: Color(0xFF4F46E5),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showVehiclePreview() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.preview_rounded,
                    color: Color(0xFF2563EB), size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Vehicle Preview",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _carNameCtrl.text.isNotEmpty
                    ? _carNameCtrl.text
                    : "${_selectedManufacturer != 'Select' ? _selectedManufacturer : ''} ${_selectedModel != 'Select manufacturer first' ? _selectedModel : 'Vehicle Listing'}",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "UID: ${widget.carUid} • Status: $_publishingStatus",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF10B981),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Asking Price: ₹${_askingPriceCtrl.text.isNotEmpty ? _askingPriceCtrl.text : 'N/A'}",
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF003366),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Location: $_location • Homepage: $_homepageVisibility",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Features: ${_selectedFeatures.isNotEmpty ? _selectedFeatures.length : 0} selected • Photos: ${_uploadedImages.length}/20",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                "Close",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF003366),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showPublishingStatusPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Title and Close 'X' (Image 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select Publishing Status",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    color: const Color(0xFF0F172A),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),

              // Options: Published, Draft, Under Review, Archived (Image 1)
              ..._publishingOptions.map((item) {
                final isSelected = _publishingStatus == item;
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _publishingStatus = item;
                        });
                        Navigator.pop(ctx);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isSelected
                                    ? const Color(0xFF2563EB)
                                    : const Color(0xFF0F172A),
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check_circle,
                                size: 20,
                                color: Color(0xFF2563EB),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                        height: 1, thickness: 1, color: Color(0xFFF1F5F9)),
                  ],
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showLocationPicker() {
    final locations = [
      "Dehradun (UK-07)",
      "Delhi NCR",
      "Haridwar (UK-08)",
      "Rishikesh (UK-14)",
      "Noida (UP-16)",
      "Gurgaon (HR-26)",
      "Chandigarh",
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
          height: MediaQuery.of(context).size.height * 0.45,
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select Location",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(height: 1),
              Expanded(
                child: ListView.separated(
                  itemCount: locations.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (ctx, i) {
                    final loc = locations[i];
                    final isSelected = _location == loc;
                    return ListTile(
                      title: Text(
                        loc,
                        style: GoogleFonts.poppins(
                          fontSize: 13.5,
                          fontWeight: isSelected
                              ? FontWeight.w600
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
                        setState(() => _location = loc);
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

  void _showHomepagePicker() {
    final options = ["Show", "Hide"];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Homepage Visibility",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(height: 1),
              ...options.map((opt) {
                final isSelected = _homepageVisibility == opt;
                return ListTile(
                  title: Text(
                    opt == "Show"
                        ? "Show (Visible on homepage)"
                        : "Hide (Hidden from homepage)",
                    style: GoogleFonts.poppins(
                      fontSize: 13.5,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
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
                    setState(() => _homepageVisibility = opt);
                    Navigator.pop(ctx);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showSchedulePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Publishing Schedule",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(height: 1),
              ListTile(
                title: Text(
                  "Immediately",
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    fontWeight: _scheduleOption == "Immediately"
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: _scheduleOption == "Immediately"
                        ? const Color(0xFF2563EB)
                        : const Color(0xFF0F172A),
                  ),
                ),
                trailing: _scheduleOption == "Immediately"
                    ? const Icon(Icons.check_circle, color: Color(0xFF2563EB))
                    : null,
                onTap: () {
                  setState(() => _scheduleOption = "Immediately");
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                title: Text(
                  "Pick Custom Date & Time",
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    fontWeight: _scheduleOption != "Immediately"
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: _scheduleOption != "Immediately"
                        ? const Color(0xFF2563EB)
                        : const Color(0xFF0F172A),
                  ),
                ),
                trailing: const Icon(Icons.calendar_month_outlined,
                    color: Color(0xFF64748B)),
                onTap: () async {
                  Navigator.pop(ctx);
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    setState(() {
                      _scheduleOption =
                          DateFormat('dd MMM yyyy').format(picked);
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showHomeSectionsPicker() {
    final tempSelected = List<String>.from(_selectedHomeSections);

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
              height: MediaQuery.of(context).size.height * 0.65,
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
                            "Select Home Sections",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            tempSelected.isEmpty
                                ? "None selected"
                                : "${tempSelected.length} sections selected",
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
                            _selectedHomeSections = List.from(tempSelected);
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
                      itemCount: _homeSectionsList.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (ctx, i) {
                        final section = _homeSectionsList[i];
                        final isChecked = tempSelected.contains(section);
                        return CheckboxListTile(
                          value: isChecked,
                          title: Text(
                            section,
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
                                tempSelected.add(section);
                              } else {
                                tempSelected.remove(section);
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

  void _showRtoRulesPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.45,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select RTO Rule",
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
              const Divider(height: 1),
              Expanded(
                child: ListView.separated(
                  itemCount: _rtoRulesList.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (ctx, i) {
                    final item = _rtoRulesList[i];
                    final isSelected = _selectedRtoRule == item;
                    return ListTile(
                      title: Text(
                        item,
                        style: GoogleFonts.poppins(
                          fontSize: 13.5,
                          fontWeight: isSelected
                              ? FontWeight.w600
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
                          _selectedRtoRule = item;
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

  void _showTcsRulesPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.45,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select TCS Rule",
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
              const Divider(height: 1),
              Expanded(
                child: ListView.separated(
                  itemCount: _tcsRulesList.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (ctx, i) {
                    final item = _tcsRulesList[i];
                    final isSelected = _selectedTcsRule == item;
                    return ListTile(
                      title: Text(
                        item,
                        style: GoogleFonts.poppins(
                          fontSize: 13.5,
                          fontWeight: isSelected
                              ? FontWeight.w600
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
                          _selectedTcsRule = item;
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
              height: MediaQuery.of(context).size.height * 0.75,
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
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: const Color(0xFF0F172A),
                    ),
                    decoration: InputDecoration(
                      hintText: "Search manufacturer...",
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 12.5,
                        color: const Color(0xFF94A3B8),
                      ),
                      prefixIcon: const Icon(Icons.search,
                          size: 20, color: Color(0xFF94A3B8)),
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
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF003366)),
                      ),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(
                      height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
                  Expanded(
                    child: filtered.isEmpty
                        ? Center(
                            child: Text(
                              "No manufacturer found",
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: const Color(0xFF94A3B8),
                              ),
                            ),
                          )
                        : ListView.separated(
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) => const Divider(
                              height: 1,
                              thickness: 1,
                              color: Color(0xFFF1F5F9),
                            ),
                            itemBuilder: (ctx, i) {
                              final item = filtered[i];
                              final isSelected = _selectedManufacturer == item;
                              return _buildManufacturerRowItem(
                                item,
                                isSelected,
                                onTapOverride: () {
                                  setState(() {
                                    _selectedManufacturer = item;
                                    if (_selectedModel ==
                                        "Select manufacturer first") {
                                      _selectedModel = "Select model";
                                    }
                                  });
                                  Navigator.pop(ctx);
                                },
                                onStateChange: () => setModalState(() {}),
                              );
                            },
                          ),
                  ),
                  const Divider(
                      height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
                  InkWell(
                    onTap: () {
                      _showAddManufacturerDialog(
                        onAdded: () => setModalState(() {}),
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Center(
                        child: Text(
                          "+ Add Manufacturer",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF059669),
                          ),
                        ),
                      ),
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
    final hasMfg = _selectedManufacturer.isNotEmpty &&
        _selectedManufacturer != "Select";
    List<String> defaultModels = [
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
    List<String> baseModels = hasMfg
        ? (_modelsByManufacturer[_selectedManufacturer] ?? defaultModels)
        : defaultModels;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        String query = "";
        bool isAdding = false;
        final modalAddCtrl = TextEditingController();

        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            final filtered = baseModels
                .where((m) => m.toLowerCase().contains(query.toLowerCase()))
                .toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Select Model (${hasMfg ? _selectedManufacturer : 'All'})",
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
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: const Color(0xFF0F172A),
                    ),
                    decoration: InputDecoration(
                      hintText: "Search model...",
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 12.5,
                        color: const Color(0xFF94A3B8),
                      ),
                      prefixIcon: const Icon(Icons.search,
                          size: 20, color: Color(0xFF94A3B8)),
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
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF003366)),
                      ),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(
                      height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
                  Expanded(
                    child: filtered.isEmpty
                        ? Center(
                            child: Text(
                              hasMfg
                                  ? "No model found for $_selectedManufacturer"
                                  : "Select Manufacturer First",
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: const Color(0xFF94A3B8),
                              ),
                            ),
                          )
                        : ListView.separated(
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) => const Divider(
                              height: 1,
                              thickness: 1,
                              color: Color(0xFFF1F5F9),
                            ),
                            itemBuilder: (ctx, i) {
                              final item = filtered[i];
                              final isSelected = _selectedModel == item;
                              return _buildModelRowItem(
                                item,
                                isSelected,
                                onTapOverride: () {
                                  setState(() {
                                    _selectedModel = item;
                                    if (_carNameCtrl.text.isEmpty) {
                                      _carNameCtrl.text = hasMfg
                                          ? "$_selectedManufacturer $item"
                                          : item;
                                    }
                                  });
                                  Navigator.pop(ctx);
                                },
                                onStateChange: () => setModalState(() {}),
                              );
                            },
                          ),
                  ),
                  const Divider(
                      height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
                  InkWell(
                    onTap: () {
                      setModalState(() {
                        isAdding = !isAdding;
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Center(
                        child: Text(
                          "+ Add Model",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF059669),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Inline Add Model Form (Image: media_1795243797134_c5c8999b.png)
                  if (isAdding) ...[
                    const Divider(
                        height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 12, 4, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Add Model ",
                                style: GoogleFonts.poppins(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                              Text(
                                "Model Name",
                                style: GoogleFonts.poppins(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF4F46E5),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              border:
                                  Border.all(color: const Color(0xFFCBD5E1)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.horizontal(
                                        left: Radius.circular(5)),
                                    border: Border(
                                      right:
                                          BorderSide(color: Color(0xFFCBD5E1)),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.edit_note_rounded,
                                    size: 19,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: modalAddCtrl,
                                    autofocus: true,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: const Color(0xFF0F172A),
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Name",
                                      hintStyle: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: const Color(0xFF94A3B8),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 10),
                                      border: InputBorder.none,
                                      isDense: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  final val = modalAddCtrl.text.trim();
                                  if (val.isNotEmpty) {
                                    final targetMfg =
                                        _selectedManufacturer != "Select"
                                            ? _selectedManufacturer
                                            : (_manufacturers.isNotEmpty
                                                ? _manufacturers.first
                                                : "Maruti Suzuki");
                                    setState(() {
                                      if (!_modelsByManufacturer
                                          .containsKey(targetMfg)) {
                                        _modelsByManufacturer[targetMfg] = [];
                                      }
                                      if (!_modelsByManufacturer[targetMfg]!
                                          .contains(val)) {
                                        _modelsByManufacturer[targetMfg]!
                                            .insert(0, val);
                                      }
                                      _selectedModel = val;
                                      if (_carNameCtrl.text.isEmpty) {
                                        _carNameCtrl.text =
                                            _selectedManufacturer != "Select"
                                                ? "$_selectedManufacturer $val"
                                                : val;
                                      }
                                    });
                                    setModalState(() {
                                      isAdding = false;
                                      modalAddCtrl.clear();
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF14B8A6),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                child: Text(
                                  "Save",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () {
                                  setModalState(() {
                                    isAdding = false;
                                    modalAddCtrl.clear();
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF818CF8),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                child: Text(
                                  "Cancel",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showBodyTypePicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        String query = "";
        bool isAdding = false;
        final modalAddCtrl = TextEditingController();

        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            final filtered = _bodyTypes
                .where((b) => b.toLowerCase().contains(query.toLowerCase()))
                .toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
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
                  const SizedBox(height: 10),
                  TextField(
                    onChanged: (val) => setModalState(() => query = val),
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: const Color(0xFF0F172A),
                    ),
                    decoration: InputDecoration(
                      hintText: "Search body type...",
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 12.5,
                        color: const Color(0xFF94A3B8),
                      ),
                      prefixIcon: const Icon(Icons.search,
                          size: 20, color: Color(0xFF94A3B8)),
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
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF003366)),
                      ),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(
                      height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
                  Expanded(
                    child: filtered.isEmpty
                        ? Center(
                            child: Text(
                              "No body type found",
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: const Color(0xFF94A3B8),
                              ),
                            ),
                          )
                        : ListView.separated(
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) => const Divider(
                              height: 1,
                              thickness: 1,
                              color: Color(0xFFF1F5F9),
                            ),
                            itemBuilder: (ctx, i) {
                              final item = filtered[i];
                              final isSelected = _selectedBodyType == item;
                              return _buildBodyTypeRowItem(
                                item,
                                isSelected,
                                onTapOverride: () {
                                  setState(() => _selectedBodyType = item);
                                  Navigator.pop(ctx);
                                },
                                onStateChange: () => setModalState(() {}),
                              );
                            },
                          ),
                  ),
                  const Divider(
                      height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
                  InkWell(
                    onTap: () {
                      setModalState(() {
                        isAdding = !isAdding;
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Center(
                        child: Text(
                          "+ Add Body Type",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF059669),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Inline Add Body Type Form
                  if (isAdding) ...[
                    const Divider(
                        height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 12, 4, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Add Body Type ",
                                style: GoogleFonts.poppins(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                              Text(
                                "Body Type Name",
                                style: GoogleFonts.poppins(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF4F46E5),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              border:
                                  Border.all(color: const Color(0xFFCBD5E1)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.horizontal(
                                        left: Radius.circular(5)),
                                    border: Border(
                                      right:
                                          BorderSide(color: Color(0xFFCBD5E1)),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.edit_note_rounded,
                                    size: 19,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: modalAddCtrl,
                                    autofocus: true,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: const Color(0xFF0F172A),
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Name",
                                      hintStyle: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: const Color(0xFF94A3B8),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 10),
                                      border: InputBorder.none,
                                      isDense: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  final val = modalAddCtrl.text.trim();
                                  if (val.isNotEmpty) {
                                    setState(() {
                                      if (!_bodyTypes.contains(val)) {
                                        _bodyTypes.insert(0, val);
                                      }
                                      _selectedBodyType = val;
                                    });
                                    setModalState(() {
                                      isAdding = false;
                                      modalAddCtrl.clear();
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF14B8A6),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                child: Text(
                                  "Save",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () {
                                  setModalState(() {
                                    isAdding = false;
                                    modalAddCtrl.clear();
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF818CF8),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                child: Text(
                                  "Cancel",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
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
        String query = "";
        bool isAdding = false;
        final modalAddCtrl = TextEditingController();

        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            final filtered = _exteriorColors.where((item) {
              final name = (item["name"] as String).toLowerCase();
              return name.contains(query.toLowerCase());
            }).toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
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
                  TextField(
                    onChanged: (val) => setModalState(() => query = val),
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: const Color(0xFF0F172A),
                    ),
                    decoration: InputDecoration(
                      hintText: "Search color...",
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 12.5,
                        color: const Color(0xFF94A3B8),
                      ),
                      prefixIcon: const Icon(Icons.search,
                          size: 20, color: Color(0xFF94A3B8)),
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
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF003366)),
                      ),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(
                      height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
                  Expanded(
                    child: filtered.isEmpty
                        ? Center(
                            child: Text(
                              "No color found",
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: const Color(0xFF94A3B8),
                              ),
                            ),
                          )
                        : ListView.separated(
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) => const Divider(
                              height: 1,
                              thickness: 1,
                              color: Color(0xFFF1F5F9),
                            ),
                            itemBuilder: (ctx, i) {
                              final item = filtered[i];
                              final name = item["name"] as String;
                              final color = item["color"] as Color;
                              final border =
                                  (item["border"] ?? false) as bool;
                              final isSelected =
                                  _selectedExteriorColor == name;
                              return _buildExteriorColorRowItem(
                                name,
                                color,
                                border,
                                isSelected,
                                onTapOverride: () {
                                  setState(
                                      () => _selectedExteriorColor = name);
                                  Navigator.pop(ctx);
                                },
                                onStateChange: () => setModalState(() {}),
                              );
                            },
                          ),
                  ),
                  const Divider(
                      height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
                  InkWell(
                    onTap: () {
                      setModalState(() {
                        isAdding = !isAdding;
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Center(
                        child: Text(
                          "+ Add Color",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF059669),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Inline Add Color Form
                  if (isAdding) ...[
                    const Divider(
                        height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 12, 4, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Add Color ",
                                style: GoogleFonts.poppins(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                              Text(
                                "Color Name",
                                style: GoogleFonts.poppins(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF4F46E5),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              border:
                                  Border.all(color: const Color(0xFFCBD5E1)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.horizontal(
                                        left: Radius.circular(5)),
                                    border: Border(
                                      right:
                                          BorderSide(color: Color(0xFFCBD5E1)),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.edit_note_rounded,
                                    size: 19,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: modalAddCtrl,
                                    autofocus: true,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: const Color(0xFF0F172A),
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Name",
                                      hintStyle: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: const Color(0xFF94A3B8),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 10),
                                      border: InputBorder.none,
                                      isDense: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  final val = modalAddCtrl.text.trim();
                                  if (val.isNotEmpty) {
                                    final exists = _exteriorColors.any((c) =>
                                        (c["name"] as String)
                                            .toLowerCase() ==
                                        val.toLowerCase());
                                    if (!exists) {
                                      setState(() {
                                        _exteriorColors.insert(0, {
                                          "name": val,
                                          "color":
                                              const Color(0xFF94A3B8),
                                          "border": false,
                                        });
                                        _selectedExteriorColor = val;
                                      });
                                    } else {
                                      setState(() {
                                        _selectedExteriorColor = val;
                                      });
                                    }
                                    setModalState(() {
                                      isAdding = false;
                                      modalAddCtrl.clear();
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF14B8A6),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                child: Text(
                                  "Save",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () {
                                  setModalState(() {
                                    isAdding = false;
                                    modalAddCtrl.clear();
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF818CF8),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                child: Text(
                                  "Cancel",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
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
              height: MediaQuery.of(context).size.height * 0.78,
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
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () => _addNewFeatureDialog(
                              modalCtx,
                              setModalState,
                              tempSelected,
                            ),
                            icon: const Icon(Icons.add, size: 14),
                            label: Text(
                              "Add",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF003366),
                              side: const BorderSide(color: Color(0xFFCBD5E1)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                          const SizedBox(width: 8),
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
                            child: Text(
                              "Done",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
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
                        return InkWell(
                          onTap: () {
                            setModalState(() {
                              if (isChecked) {
                                tempSelected.remove(feature);
                              } else {
                                tempSelected.add(feature);
                              }
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 10),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Checkbox(
                                    value: isChecked,
                                    activeColor: const Color(0xFF003366),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    side: const BorderSide(
                                      color: Color(0xFF94A3B8),
                                      width: 1.5,
                                    ),
                                    onChanged: (val) {
                                      setModalState(() {
                                        if (val == true) {
                                          tempSelected.add(feature);
                                        } else {
                                          tempSelected.remove(feature);
                                        }
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    feature,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: isChecked
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                      color: const Color(0xFF0F172A),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),

                                // Action Buttons: Eye, Edit, Delete
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // 1. Eye (View)
                                    InkWell(
                                      onTap: () => _viewFeatureDetails(
                                          feature, isChecked),
                                      borderRadius: BorderRadius.circular(6),
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEFF6FF),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: const Icon(
                                          Icons.visibility_outlined,
                                          size: 16,
                                          color: Color(0xFF2563EB),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),

                                    // 2. Edit
                                    InkWell(
                                      onTap: () => _editFeatureDialog(
                                        feature,
                                        modalCtx,
                                        setModalState,
                                        tempSelected,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF0FDF4),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: const Icon(
                                          Icons.edit_outlined,
                                          size: 16,
                                          color: Color(0xFF16A34A),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),

                                    // 3. Delete
                                    InkWell(
                                      onTap: () => _deleteFeatureDialog(
                                        feature,
                                        modalCtx,
                                        setModalState,
                                        tempSelected,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFEF2F2),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: const Icon(
                                          Icons.delete_outline,
                                          size: 16,
                                          color: Color(0xFFDC2626),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
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

  void _viewFeatureDetails(String feature, bool isSelected) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.visibility_outlined,
                    color: Color(0xFF2563EB), size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Feature Details",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Feature Name",
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                feature,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Status in this vehicle",
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFDCFCE7)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isSelected ? "✓ Included / Selected" : "Not Selected",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? const Color(0xFF16A34A)
                        : const Color(0xFF64748B),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Description",
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "Factory fitted original OEM specification feature verified during multi-point vehicle inspection.",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: const Color(0xFF475569),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                "Close",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF003366),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _editFeatureDialog(
    String feature,
    BuildContext modalCtx,
    StateSetter setModalState,
    List<String> tempSelected,
  ) {
    final editCtrl = TextEditingController(text: feature);
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.edit_outlined,
                    color: Color(0xFF16A34A), size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Edit Feature",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Feature Name",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: editCtrl,
                autofocus: true,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: const Color(0xFF0F172A),
                ),
                decoration: InputDecoration(
                  hintText: "Enter feature name",
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(
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
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: Text(
                "Cancel",
                style: GoogleFonts.poppins(color: const Color(0xFF64748B)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final newName = editCtrl.text.trim();
                if (newName.isNotEmpty && newName != feature) {
                  setState(() {
                    final index = _featuresList.indexOf(feature);
                    if (index != -1) {
                      _featuresList[index] = newName;
                    }
                    if (_selectedFeatures.contains(feature)) {
                      _selectedFeatures.remove(feature);
                      _selectedFeatures.add(newName);
                    }
                  });
                  setModalState(() {
                    if (tempSelected.contains(feature)) {
                      tempSelected.remove(feature);
                      tempSelected.add(newName);
                    }
                  });
                }
                Navigator.pop(dialogCtx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003366),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text("Save",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            ),
          ],
        );
      },
    );
  }

  void _deleteFeatureDialog(
    String feature,
    BuildContext modalCtx,
    StateSetter setModalState,
    List<String> tempSelected,
  ) {
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.delete_outline,
                    color: Color(0xFFDC2626), size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Delete Feature",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            "Are you sure you want to remove '$feature' from features list?",
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: const Color(0xFF475569),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: Text(
                "Cancel",
                style: GoogleFonts.poppins(color: const Color(0xFF64748B)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _featuresList.remove(feature);
                  _selectedFeatures.remove(feature);
                });
                setModalState(() {
                  tempSelected.remove(feature);
                });
                Navigator.pop(dialogCtx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("'$feature' deleted successfully"),
                    backgroundColor: const Color(0xFFDC2626),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text("Delete",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            ),
          ],
        );
      },
    );
  }

  void _addNewFeatureDialog(
    BuildContext modalCtx,
    StateSetter setModalState,
    List<String> tempSelected,
  ) {
    final newCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.add_circle_outline,
                    color: Color(0xFF2563EB), size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Add New Feature",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Feature Name",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: newCtrl,
                autofocus: true,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: const Color(0xFF0F172A),
                ),
                decoration: InputDecoration(
                  hintText: "e.g. Panoramic Sunroof",
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(
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
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: Text(
                "Cancel",
                style: GoogleFonts.poppins(color: const Color(0xFF64748B)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final name = newCtrl.text.trim();
                if (name.isNotEmpty && !_featuresList.contains(name)) {
                  setState(() {
                    _featuresList.insert(0, name);
                  });
                  setModalState(() {
                    tempSelected.add(name);
                  });
                }
                Navigator.pop(dialogCtx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003366),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text("Add",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            ),
          ],
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
                  // 1. SEO meta title (Image 2)
                  _buildLabel("SEO meta title"),
                  const SizedBox(height: 6),
                  _buildTextField(
                    controller: _metaTitleCtrl,
                    hintText: "Enter SEO-friendly page title",
                  ),
                  const SizedBox(height: 14),

                  // 2. Permanent URL slug (Image 2)
                  _buildLabel("Permanent URL slug"),
                  const SizedBox(height: 6),
                  _buildTextField(
                    controller: _permanentUrlSlugCtrl,
                    hintText: "caruid979",
                  ),
                  const SizedBox(height: 14),

                  // 3. Keywords (Image 2)
                  _buildLabel("Keywords"),
                  const SizedBox(height: 6),
                  _buildTextField(
                    controller: _metaKeywordsCtrl,
                    hintText: "Type and press Enter...",
                  ),
                  const SizedBox(height: 14),

                  // 4. Meta description (Image 2)
                  _buildLabel("Meta description"),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _metaDescriptionCtrl,
                    maxLines: 4,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: const Color(0xFF0F172A),
                    ),
                    decoration: InputDecoration(
                      hintText: "Enter meta description",
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 12.5,
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

class _DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double dash;
  final double radius;

  _DashedRectPainter({
    this.color = const Color(0xFFCBD5E1),
    this.strokeWidth = 1.2,
    this.dash = 5,
    this.gap = 3,
    this.radius = 8,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(strokeWidth / 2, strokeWidth / 2,
          size.width - strokeWidth, size.height - strokeWidth),
      Radius.circular(radius),
    );

    final Path path = Path()..addRRect(rrect);
    final Path dashPath = Path();

    for (final ui.PathMetric metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final double len = (distance + dash < metric.length)
            ? dash
            : metric.length - distance;
        dashPath.addPath(
          metric.extractPath(distance, distance + len),
          Offset.zero,
        );
        distance += dash + gap;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
