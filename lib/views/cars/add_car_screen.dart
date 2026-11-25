import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/admin_profile_avatar.dart';

class AddCarScreen extends StatefulWidget {
  final String carUid;
  final bool isEdit;
  const AddCarScreen({
    super.key,
    this.carUid = "#CARUID979",
    this.isEdit = false,
  });

  @override
  State<AddCarScreen> createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  int _currentStep = 0;

  bool get _isEditMode =>
      widget.isEdit ||
      (widget.carUid != "#CARUID979" && widget.carUid.isNotEmpty);

  // Accordion Expand/Collapse States
  bool _seoMetadataExpanded = true;
  bool _dragAndSortEnabled = true;

  // Publishing State (Image 1 & 2)
  bool _publishingExpanded = true;
  String _publishingStatus = "Published";
  String _location = "VAAHAN BAZA – NITIN KHATRI";
  String _homepageVisibility = "Show";
  String _scheduleOption = "Immediately";
  final List<String> _publishingOptions = [
    "Published",
    "Draft",
    "Inactive",
    "Pending",
  ];
  bool _isEditingLocation = false;
  String _selectedLocationWithId = "VAAHAN BAZA – NITIN KHATRI [#187]";
  final List<String> _locationOptions = [
    "VAAHAN BAZA – NITIN KHATRI [#187]",
    "Auto Care Mohammad Sajid [#188]",
    "Dehradun Main Hub [#101]",
    "Delhi NCR Hub [#102]",
    "Find My Car Head Office [#103]",
  ];
  bool _isEditingStatus = false;
  String _tempPublishingStatus = "Draft";
  final List<String> _statusOptionsList = [
    "Draft",
    "Published",
    "Inactive",
    "Pending",
  ];
  bool _isEditingHomepage = false;
  String _tempHomepageVisibility = "Show";
  final List<String> _homepageOptionsList = [
    "Show",
    "Hide",
  ];
  bool _isEditingSchedule = false;
  final _scheduleCtrl = TextEditingController();

  // Home Sections & Tax Rules State (Image 1)
  List<String> _selectedHomeSections = [];
  bool _homeSectionsExpanded = true;
  bool _isAddingHomeSection = false;
  final _newHomeSectionNameCtrl = TextEditingController();
  bool _newHomeSectionHasPriceTabs = false;
  final Set<String> _hiddenHomeSections = {"Inspected Cars"};
  String _selectedRtoRule = "Gujarat: Max ₹500,000 (12.00%)";
  bool _rtoRulesExpanded = true;
  bool _isAddingRtoRule = false;
  int? _editingRtoRuleIndex;
  String _newRtoState = "State";
  final _newRtoMaxPriceCtrl = TextEditingController();
  final _newRtoPercentageCtrl = TextEditingController();
  String _editRtoState = "State";
  final _editRtoMaxPriceCtrl = TextEditingController();
  final _editRtoPercentageCtrl = TextEditingController(text: "0");
  final Set<String> _hiddenRtoRules = {};
  String _selectedTcsRule = "Above ₹500,000 @ 12.00%";
  bool _tcsRulesExpanded = true;
  bool _isAddingTcsRule = false;
  int? _editingTcsRuleIndex;
  final _newTcsAbovePriceCtrl = TextEditingController();
  final _newTcsPercentageCtrl = TextEditingController();
  final _editTcsAbovePriceCtrl = TextEditingController();
  final _editTcsPercentageCtrl = TextEditingController(text: "12.00");
  final Set<String> _hiddenTcsRules = {};

  final List<String> _indianStates = [
    "State",
    "Gujarat",
    "Maharashtra",
    "Delhi",
    "Karnataka",
    "Tamil Nadu",
    "Rajasthan",
    "Uttar Pradesh",
    "Haryana",
    "Punjab",
    "West Bengal",
    "Kerala",
    "Telangana",
    "Andhra Pradesh",
    "Madhya Pradesh",
    "Bihar",
  ];

  final List<Map<String, dynamic>> _homeSectionsList = [
    {"name": "Certified Car", "hasPriceTabs": false},
    {"name": "Electric Car", "hasPriceTabs": false},
    {"name": "Explore Hatchbacks by Price", "hasPriceTabs": true},
    {"name": "Explore Sedans by Price", "hasPriceTabs": true},
    {"name": "Explore SUVs by Price", "hasPriceTabs": true},
    {"name": "Inspected Cars", "hasPriceTabs": false},
    {"name": "Featured Vehicles", "hasPriceTabs": false},
    {"name": "Popular & Trending Cars", "hasPriceTabs": false},
    {"name": "Hot Deals of the Week", "hasPriceTabs": false},
    {"name": "Budget Friendly (< ₹5 Lakhs)", "hasPriceTabs": true},
    {"name": "Verified & Certified Cars", "hasPriceTabs": false},
    {"name": "Luxury & Premium Segment", "hasPriceTabs": false},
    {"name": "Recently Added Stock", "hasPriceTabs": false},
    {"name": "Zero Down Payment Eligible", "hasPriceTabs": false},
  ];

  final List<Map<String, dynamic>> _rtoRulesList = [
    {
      "state": "Gujarat",
      "maxPrice": "500,000",
      "percentage": "12.00",
    },
    {
      "state": "Maharashtra",
      "maxPrice": "1,000,000",
      "percentage": "11.00",
    },
    {
      "state": "Delhi",
      "maxPrice": "800,000",
      "percentage": "10.00",
    },
    {
      "state": "Karnataka",
      "maxPrice": "1,200,000",
      "percentage": "14.00",
    },
  ];

  final List<Map<String, dynamic>> _tcsRulesList = [
    {
      "abovePrice": "500,000",
      "percentage": "12.00",
    },
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
  String? _editingModel;
  final _editModelNameCtrl = TextEditingController();
  bool _bodyTypeExpanded = true;
  final _bodyTypeSearchCtrl = TextEditingController();
  bool _isAddingBodyType = false;
  final _newBodyTypeNameCtrl = TextEditingController();
  String? _newBodyTypeImageMock;
  bool _exteriorColorExpanded = true;
  final _exteriorColorSearchCtrl = TextEditingController();
  bool _isAddingExteriorColor = false;
  final _newExteriorColorNameCtrl = TextEditingController();
  final _newExteriorColorCodeCtrl = TextEditingController(text: "#000000");
  String? _newExteriorColorImageMock;
  bool _featuresExpanded = true;
  final _featuresSearchCtrl = TextEditingController();
  bool _isAddingFeature = false;
  final _newFeatureNameCtrl = TextEditingController();
  String _selectedManufacturer = "Select";
  String _selectedModel = "Select manufacturer first";
  String _selectedBodyType = "Select";
  String _selectedExteriorColor = "Select";
  List<String> _selectedFeatures = [];
  final Set<String> _hiddenManufacturers = {};
  final Set<String> _hiddenModels = {};
  final Set<String> _hiddenBodyTypes = {};
  final Set<String> _hiddenExteriorColors = {};
  final Set<String> _hiddenFeatures = {};

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
      "ALCAZAR",
      "ALCAZAR 1.5 AT PLATINUM(O) 6S",
      "ALCAZAR 1.5 MT PLATINUM 7S",
      "Aura",
      "AURA 1.2MT CNG S",
      "AURA 1.2MT KAPPA S",
    ],
    "HYUNDAI": [
      "ALCAZAR",
      "ALCAZAR 1.5 AT PLATINUM(O) 6S",
      "ALCAZAR 1.5 MT PLATINUM 7S",
      "Aura",
      "AURA 1.2MT CNG S",
      "AURA 1.2MT KAPPA S",
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
    "Alloy Wheels",
    "Auxiliary Heating",
    "Bluetooth",
    "Electric side mirror",
    "Exterior - extra clean",
    "Floor Mats",
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
    _permanentUrlSlugCtrl.text = cleanUid.isNotEmpty ? cleanUid : "caruid979";
    if (_isEditMode) {
      _selectedManufacturer = "Hyundai";
      _selectedModel = "ALCAZAR";
      if (_carNameCtrl.text.isEmpty) {
        _carNameCtrl.text = "Hyundai ALCAZAR";
      }
    }
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
  final List<String> _statusOptions = [
    "Available",
    "Sold",
    "Booked",
    "Reserved"
  ];
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
    _scrollController.dispose();
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
    _editModelNameCtrl.dispose();
    _bodyTypeSearchCtrl.dispose();
    _newBodyTypeNameCtrl.dispose();
    _exteriorColorSearchCtrl.dispose();
    _newExteriorColorNameCtrl.dispose();
    _newExteriorColorCodeCtrl.dispose();
    _featuresSearchCtrl.dispose();
    _newFeatureNameCtrl.dispose();
    _newHomeSectionNameCtrl.dispose();
    _newRtoMaxPriceCtrl.dispose();
    _newRtoPercentageCtrl.dispose();
    _editRtoMaxPriceCtrl.dispose();
    _editRtoPercentageCtrl.dispose();
    _newTcsAbovePriceCtrl.dispose();
    _newTcsPercentageCtrl.dispose();
    _editTcsAbovePriceCtrl.dispose();
    _editTcsPercentageCtrl.dispose();
    _scheduleCtrl.dispose();
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
        content:
            Text("RC Details fetched and fields auto-filled successfully!"),
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

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    }
  }

  void _nextStep() {
    if (_currentStep == 0) {
      if (_carNameCtrl.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please enter the Car Name before continuing."),
            backgroundColor: Color(0xFFDC2626),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }
    }
    if (_currentStep < 6) {
      setState(() {
        _currentStep++;
      });
      _scrollToTop();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _scrollToTop();
    }
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
        content: Text(
          _isEditMode
              ? "Vehicle ${widget.carUid} updated successfully!"
              : "Vehicle ${widget.carUid} added successfully!",
        ),
        backgroundColor: const Color(0xFF008844),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentStep == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_currentStep > 0) {
          _previousStep();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: CustomBackButton(
            isDarkMode: false,
            onPressed: () {
              if (_currentStep > 0) {
                _previousStep();
              } else {
                Navigator.pop(context);
              }
            },
          ),
          title: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: _isEditMode ? "Edit Used Car " : "Add new car ",
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
        body: Column(
          children: [
            // Sticky 7-Step Progress Header
            _buildStepProgressBar(),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),

            // Active Step Content
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStepContent(),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: _buildStickyBottomBar(),
      ),
    );
  }

  // ================= 7-STEP STEPPER HEADER =================
  Widget _buildStepProgressBar() {
    final steps = [
      {"title": "Basic", "icon": Icons.directions_car_filled_outlined},
      {"title": "Specs", "icon": Icons.speed_rounded},
      {"title": "Price", "icon": Icons.currency_rupee_rounded},
      {"title": "Brand", "icon": Icons.branding_watermark_outlined},
      {"title": "Features", "icon": Icons.tune_rounded},
      {"title": "Photos", "icon": Icons.photo_library_outlined},
      {"title": "Publish", "icon": Icons.rocket_launch_outlined},
    ];

    final stepTitles = [
      "Vehicle Identity & Basic Info",
      "Technical Specs, RTO & Insurance",
      "Pricing, Odometer & Description",
      "Brand, Model & Exterior",
      "Features & Equipment Checklist",
      "Image Gallery (Car Photos)",
      "Publishing, Visibility & SEO",
    ];

    final progressPct = ((_currentStep + 1) * 100 ~/ 7);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step circles with connecting lines (scrollable if screen is narrow)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: List.generate(steps.length * 2 - 1, (index) {
                if (index.isOdd) {
                  final stepIdx = index ~/ 2;
                  final isPassed = stepIdx < _currentStep;
                  return Container(
                    width: 20,
                    height: 2,
                    color: isPassed
                        ? const Color(0xFF10B981)
                        : const Color(0xFFE2E8F0),
                  );
                }
                final stepIdx = index ~/ 2;
                final isCurrent = stepIdx == _currentStep;
                final isPassed = stepIdx < _currentStep;

                return InkWell(
                  onTap: () {
                    setState(() => _currentStep = stepIdx);
                    _scrollToTop();
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: isCurrent ? 32 : 26,
                          height: isCurrent ? 32 : 26,
                          decoration: BoxDecoration(
                            color: isCurrent
                                ? const Color(0xFF003366)
                                : (isPassed
                                    ? const Color(0xFF10B981)
                                    : const Color(0xFFF1F5F9)),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isCurrent
                                  ? const Color(0xFF003366)
                                  : (isPassed
                                      ? const Color(0xFF10B981)
                                      : const Color(0xFFCBD5E1)),
                              width: isCurrent ? 2 : 1,
                            ),
                            boxShadow: isCurrent
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFF003366)
                                          .withValues(alpha: 0.25),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    )
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: isPassed
                                ? const Icon(Icons.check_rounded,
                                    size: 14, color: Colors.white)
                                : (isCurrent
                                    ? Icon(steps[stepIdx]["icon"] as IconData,
                                        size: 15, color: Colors.white)
                                    : Text(
                                        "${stepIdx + 1}",
                                        style: GoogleFonts.poppins(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF64748B),
                                        ),
                                      )),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          steps[stepIdx]["title"] as String,
                          style: GoogleFonts.poppins(
                            fontSize: 9,
                            fontWeight:
                                isCurrent ? FontWeight.bold : FontWeight.w500,
                            color: isCurrent
                                ? const Color(0xFF003366)
                                : (isPassed
                                    ? const Color(0xFF10B981)
                                    : const Color(0xFF64748B)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 10),
          // Active step title banner with progress percentage
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF003366),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    "Step ${_currentStep + 1} of 7",
                    style: GoogleFonts.poppins(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    stepTitles[_currentStep],
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0F172A),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  "$progressPct%",
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= STICKY BOTTOM NAVIGATION BAR =================
  Widget _buildStickyBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Left Action Button
            if (_currentStep > 0) ...[
              Expanded(
                flex: 1,
                child: OutlinedButton.icon(
                  onPressed: _previousStep,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF0F172A),
                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.arrow_back_rounded, size: 16),
                  label: Text(
                    "Back",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ] else ...[
              Expanded(
                flex: 1,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF64748B),
                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],

            // Right Action Button (Next or Submit)
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: _currentStep < 6 ? _nextStep : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003366),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                icon: Icon(
                  _currentStep < 6
                      ? Icons.arrow_forward_rounded
                      : Icons.check_circle_outline,
                  size: 17,
                ),
                label: Text(
                  _currentStep < 6
                      ? "Next Step (${_currentStep + 1}/7)"
                      : (_isEditMode ? "Update Vehicle" : "Save Vehicle"),
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= REUSABLE STEP CARD CONTAINER =================
  Widget _buildStepCard({
    required String title,
    required Widget child,
    String? subtitle,
    IconData? icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: const Color(0xFF003366)),
                const SizedBox(width: 8),
              ],
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14.5,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 3),
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: const Color(0xFF64748B),
              ),
            ),
          ],
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
          ),
          child,
        ],
      ),
    );
  }

  // ================= ACTIVE STEP CONTENT SELECTOR =================
  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildStep1BasicInfo();
      case 1:
        return _buildStep2TechnicalAndDocs();
      case 2:
        return _buildStep3PriceAndDescription();
      case 3:
        return _buildStep4BrandAndModel();
      case 4:
        return _buildStep5Features();
      case 5:
        return _buildStep6ImageGallery();
      case 6:
        return _buildStep7PublishingAndSeo();
      default:
        return _buildStep1BasicInfo();
    }
  }

  // ================= STEP 1: VEHICLE IDENTITY & BASIC INFO (FROM IMAGE) =================
  Widget _buildStep1BasicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. RC Auto-fetch & Vehicle Type Card
        _buildStepCard(
          title: "Registration & Vehicle Type",
          subtitle: "Enter registration number to auto-fill vehicle details",
          icon: Icons.qr_code_scanner_rounded,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                            hintText: "REGISTRATION NUMBER (E.G. DL01CA1234)",
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
            ],
          ),
        ),

        // 2. Basic Information Card (Car Name, Status, Owner, Year, Fuel, Transmission)
        _buildStepCard(
          title: "Basic Car Information",
          subtitle: "Car name, status, owner details, year and powertrain",
          icon: Icons.directions_car_filled_outlined,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                    label: "Car name *",
                    child: _buildTextField(
                      controller: _carNameCtrl,
                      hintText: "e.g. Swift",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
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
                    label: "Transmission *",
                    child: _buildDropdown(
                      value: _transmission,
                      items: _transmissionOptions,
                      onChanged: (val) {
                        if (val != null) setState(() => _transmission = val);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ================= STEP 2: TECHNICAL, RTO & INSURANCE (FROM IMAGE) =================
  Widget _buildStep2TechnicalAndDocs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Engine & Seating Specifications Card
        _buildStepCard(
          title: "Engine & Seating Specifications",
          subtitle: "Engine size, seating capacity, cylinders & vehicle weights",
          icon: Icons.speed_rounded,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildResponsiveRow(
                children: [
                  _buildFlexibleField(
                    label: "Seating capacity",
                    child: _buildDropdown(
                      value: _seatingCapacity,
                      items: _seatingOptions,
                      onChanged: (val) {
                        if (val != null) setState(() => _seatingCapacity = val);
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
                ],
              ),
            ],
          ),
        ),

        // 2. RTO & Registration Card
        _buildStepCard(
          title: "Registration & Validity",
          subtitle: "RTO jurisdiction, fitness certificate & PUCC dates",
          icon: Icons.verified_user_outlined,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildResponsiveRow(
                children: [
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
                    label: "PUCC valid upto",
                    child: _buildDateField(
                      controller: _puccValidUptoCtrl,
                      hintText: "dd-mm-yyyy",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // 3. Insurance & Finance Card
        _buildStepCard(
          title: "Insurance & Finance Details",
          subtitle: "Policy information, bank hypothecation & engine numbers",
          icon: Icons.shield_outlined,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
            ],
          ),
        ),
      ],
    );
  }

  // ================= STEP 3: PRICING, ODOMETER & DESCRIPTION (FROM IMAGE) =================
  Widget _buildStep3PriceAndDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Pricing Card
        _buildStepCard(
          title: "Pricing & Discounts",
          subtitle: "Set asking selling price and customer discounts",
          icon: Icons.currency_rupee_rounded,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                ],
              ),
            ],
          ),
        ),

        // 2. Odometer & Mileage Card
        _buildStepCard(
          title: "Odometer & Mileage",
          subtitle: "Distance driven and fuel efficiency",
          icon: Icons.av_timer_rounded,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildResponsiveRow(
                children: [
                  _buildFlexibleField(
                    label: "KM driven",
                    child: _buildTextField(
                      controller: _kmDrivenCtrl,
                      hintText: "e.g. 45,000",
                      suffixText: "km",
                      keyboardType: TextInputType.number,
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
                ],
              ),
            ],
          ),
        ),

        // 3. Vehicle Description Card
        _buildStepCard(
          title: "Vehicle Description",
          subtitle: "Highlight condition, service records, and special features",
          icon: Icons.notes_rounded,
          child: Column(
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
                    borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: Color(0xFF003366), width: 1.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ================= STEP 4: BRAND, MODEL & EXTERIOR =================
  Widget _buildStep4BrandAndModel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Manufacturer Card
        _buildManufacturerCard(),

        // 2. Model Card
        _buildModelCard(),

        // 3. Body Type Card
        _buildBodyTypeCard(),

        // 4. Exterior Color Card
        _buildExteriorColorCard(),
      ],
    );
  }

  // ================= STEP 5: FEATURES CHECKLIST =================
  Widget _buildStep5Features() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFeaturesCard(),
      ],
    );
  }

  // ================= STEP 6: IMAGE GALLERY (CAR PHOTOS) =================
  Widget _buildStep6ImageGallery() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildImageGalleryCard(),
      ],
    );
  }

  // ================= STEP 7: PUBLISHING, VISIBILITY & SEO =================
  Widget _buildStep7PublishingAndSeo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Publishing Card
        _buildPublishingCard(),

        // 2. Home Sections Card
        _buildHomeSectionsCard(),

        // 3. RTO Rules Card
        _buildRtoRulesCard(),

        // 4. TCS Rules Card
        _buildTcsRulesCard(),

        // 5. SEO Metadata Card
        _buildSeoMetadataCard(),
      ],
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
                  // Top Buttons: Save Draft & Preview (ONLY in Add Mode)
                  if (!_isEditMode) ...[
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
                  ],

                  // Row 1: Location
                  _buildPublishingDetailRow(
                    icon: Icons.location_on_outlined,
                    label: "Location:",
                    value: _location,
                    onEdit: () {
                      setState(() {
                        _isEditingLocation = !_isEditingLocation;
                      });
                    },
                    onLongPress: _showLocationPicker,
                  ),
                  if (_isEditingLocation) ...[
                    const SizedBox(height: 4),
                    _buildPublishingDropdown(
                      value: _locationOptions.contains(_selectedLocationWithId)
                          ? _selectedLocationWithId
                          : _locationOptions.first,
                      items: _locationOptions,
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedLocationWithId = val;
                            _location =
                                val.replaceAll(RegExp(r'\s*\[#\d+\]'), '');
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildInlineOkButton(
                      onTap: () {
                        setState(() {
                          _isEditingLocation = false;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                  ],
                  const Divider(
                      height: 1, thickness: 1, color: Color(0xFFF1F5F9)),

                  // Row 2: Status
                  _buildPublishingDetailRow(
                    icon: Icons.vpn_key_outlined,
                    label: "Status:",
                    value: _publishingStatus,
                    onEdit: () {
                      setState(() {
                        _isEditingStatus = !_isEditingStatus;
                        _tempPublishingStatus = _publishingStatus;
                      });
                    },
                    onLongPress: _showPublishingStatusPicker,
                  ),
                  if (_isEditingStatus) ...[
                    const SizedBox(height: 4),
                    _buildPublishingDropdown(
                      value: _statusOptionsList.contains(_tempPublishingStatus)
                          ? _tempPublishingStatus
                          : "Draft",
                      items: _statusOptionsList,
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _tempPublishingStatus = val;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildInlineOkButton(
                      onTap: () {
                        setState(() {
                          _publishingStatus = _tempPublishingStatus;
                          _isEditingStatus = false;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                  ],
                  const Divider(
                      height: 1, thickness: 1, color: Color(0xFFF1F5F9)),

                  // Row 3: Homepage
                  _buildPublishingDetailRow(
                    icon: Icons.home_outlined,
                    label: "Homepage:",
                    value: _homepageVisibility,
                    onEdit: () {
                      setState(() {
                        _isEditingHomepage = !_isEditingHomepage;
                        _tempHomepageVisibility = _homepageVisibility;
                      });
                    },
                    onLongPress: _showHomepagePicker,
                  ),
                  if (_isEditingHomepage) ...[
                    const SizedBox(height: 4),
                    _buildPublishingDropdown(
                      value:
                          _homepageOptionsList.contains(_tempHomepageVisibility)
                              ? _tempHomepageVisibility
                              : "Show",
                      items: _homepageOptionsList,
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _tempHomepageVisibility = val;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildInlineOkButton(
                      onTap: () {
                        setState(() {
                          _homepageVisibility = _tempHomepageVisibility;
                          _isEditingHomepage = false;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                  ],
                  const Divider(
                      height: 1, thickness: 1, color: Color(0xFFF1F5F9)),

                  // Row 4: Schedule
                  _buildPublishingDetailRow(
                    icon: Icons.calendar_today_outlined,
                    label: "Schedule:",
                    value: _scheduleOption,
                    onEdit: () {
                      setState(() {
                        _isEditingSchedule = !_isEditingSchedule;
                        _scheduleCtrl.text = _scheduleOption == "Immediately"
                            ? ""
                            : _scheduleOption;
                      });
                    },
                    onLongPress: _showSchedulePicker,
                  ),
                  if (_isEditingSchedule) ...[
                    const SizedBox(height: 4),
                    Container(
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                      ),
                      child: TextField(
                        controller: _scheduleCtrl,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: const Color(0xFF0F172A),
                        ),
                        decoration: InputDecoration(
                          hintText: "",
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          border: InputBorder.none,
                          isDense: true,
                          suffixIcon: InkWell(
                            onTap: () async {
                              final pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2035),
                              );
                              if (pickedDate != null) {
                                if (!mounted) return;
                                final pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (pickedTime != null) {
                                  final formatted =
                                      "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')} ${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";
                                  _scheduleCtrl.text = formatted;
                                }
                              }
                            },
                            child: const Icon(
                              Icons.calendar_today_outlined,
                              size: 17,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildInlineOkButton(
                      onTap: () {
                        setState(() {
                          _scheduleOption = _scheduleCtrl.text.trim().isNotEmpty
                              ? _scheduleCtrl.text.trim()
                              : "Immediately";
                          _isEditingSchedule = false;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                  ],
                ],
              ),
            ),

            // Footer Button: Update Vehicle (ONLY in Edit Mode, matching Image 1)
            if (_isEditMode) ...[
              const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: const BoxDecoration(
                  color: Color(0xFFF8FAFC),
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(10)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0EA5E9),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Text(
                        "Update Vehicle",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  Widget _buildPublishingDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onEdit,
    VoidCallback? onLongPress,
  }) {
    return InkWell(
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
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
      ),
    );
  }

  Widget _buildPublishingDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(value) ? value : items.first,
          isExpanded: true,
          icon: const Padding(
            padding: EdgeInsets.only(right: 10),
            child:
                Icon(Icons.arrow_drop_down, color: Color(0xFF64748B), size: 22),
          ),
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: const Color(0xFF1E293B),
            fontWeight: FontWeight.normal,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          items: items.map((opt) {
            return DropdownMenuItem<String>(
              value: opt,
              child: Text(
                opt,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: const Color(0xFF1E293B),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildInlineOkButton({required VoidCallback onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFCBD5E1)),
            ),
            child: Text(
              "OK",
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF0F172A),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ================= MANUFACTURER CARD (IMAGE 2) =================
  Widget _buildManufacturerCard() {
    final search = _manufacturerSearchCtrl.text.trim().toLowerCase();
    final filtered =
        _manufacturers.where((m) => m.toLowerCase().contains(search)).toList();

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
                      : const BorderRadius.vertical(
                          bottom: Radius.circular(10)),
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
    final isHidden = _hiddenManufacturers.contains(mfg);
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
      child: Container(
        decoration: isSelected
            ? const BoxDecoration(
                border: Border(
                  left: BorderSide(color: Color(0xFF2563EB), width: 3.5),
                ),
              )
            : null,
        padding: EdgeInsets.symmetric(
            horizontal: isSelected ? 10.5 : 14, vertical: 10),
        child: Row(
          children: [
            // Radio button
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              size: 20,
              color: isSelected
                  ? const Color(0xFF10B981)
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
                  color: isHidden
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF0F172A),
                  decoration: isHidden ? TextDecoration.lineThrough : null,
                  decorationColor: const Color(0xFF94A3B8),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Action 1: Eye (Toggle Hide & Select)
            InkWell(
              onTap: () {
                setState(() {
                  _selectedManufacturer = mfg;
                  if (_selectedModel == "Select manufacturer first") {
                    _selectedModel = "Select model";
                  }
                  if (_hiddenManufacturers.contains(mfg)) {
                    _hiddenManufacturers.remove(mfg);
                  } else {
                    _hiddenManufacturers.add(mfg);
                  }
                });
                onStateChange?.call();
              },
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Icon(
                  isHidden
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 19,
                  color: isHidden
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF14B8A6),
                ),
              ),
            ),
            const SizedBox(width: 4),

            // Action 2: Edit
            InkWell(
              onTap: () {
                setState(() {
                  _selectedManufacturer = mfg;
                  if (_selectedModel == "Select manufacturer first") {
                    _selectedModel = "Select model";
                  }
                });
                onStateChange?.call();
                _editManufacturerDialog(mfg, onUpdated: onStateChange);
              },
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

  Widget _buildCircleRingDetailed({double size = 28, double stroke = 2.2}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF475569), width: stroke),
      ),
    );
  }

  Widget _buildBrandLogoDetailed(String mfg) {
    final upper = mfg.toUpperCase();
    if (upper.contains("AUDI")) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 84,
            height: 28,
            child: Stack(
              children: [
                Positioned(
                    left: 0,
                    child: _buildCircleRingDetailed(size: 28, stroke: 2.2)),
                Positioned(
                    left: 18,
                    child: _buildCircleRingDetailed(size: 28, stroke: 2.2)),
                Positioned(
                    left: 36,
                    child: _buildCircleRingDetailed(size: 28, stroke: 2.2)),
                Positioned(
                    left: 54,
                    child: _buildCircleRingDetailed(size: 28, stroke: 2.2)),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "Audi",
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: const Color(0xFFE50914),
              letterSpacing: 0.5,
            ),
          ),
        ],
      );
    } else if (upper.contains("BMW INDIA")) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.directions_car_rounded,
            size: 30,
            color: Color(0xFF0F172A),
          ),
          const SizedBox(height: 4),
          Text(
            "BMW INDIA",
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
            ),
          ),
        ],
      );
    } else if (upper.contains("BMW")) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF0F172A), width: 2),
              color: const Color(0xFF0284C7),
            ),
            child: Center(
              child: Container(
                width: 14,
                height: 14,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "BMW",
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
            ),
          ),
        ],
      );
    } else if (upper.contains("CITROEN")) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.keyboard_double_arrow_up_rounded,
            size: 28,
            color: Color(0xFFE11D48),
          ),
          const SizedBox(height: 4),
          Text(
            "CITROËN",
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFE11D48),
            ),
          ),
        ],
      );
    } else if (upper.contains("FORCE")) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF2563EB), width: 2),
            ),
            child: const Center(
              child: Text(
                "F",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2563EB),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "FORCE",
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2563EB),
            ),
          ),
        ],
      );
    } else if (upper.contains("MERCEDES")) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.change_history_rounded,
            size: 28,
            color: Color(0xFF334155),
          ),
          const SizedBox(height: 4),
          Text(
            "Mercedes-Benz",
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF334155),
            ),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFEFF6FF),
              border: Border.all(color: const Color(0xFF3B82F6), width: 1.5),
            ),
            alignment: Alignment.center,
            child: Text(
              mfg.isNotEmpty ? mfg.substring(0, 1).toUpperCase() : "M",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1D4ED8),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            mfg,
            style: GoogleFonts.poppins(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0F172A),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      );
    }
  }

  void _editManufacturerDialog(String mfg, {VoidCallback? onUpdated}) {
    final editCtrl = TextEditingController(text: mfg);
    bool hasLogo = true;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDState) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              insetPadding: const EdgeInsets.symmetric(horizontal: 20),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Edit Brand ",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        Text(
                          "Manufacturer Logo",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF4338CA),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Dashed border container with logo or upload placeholder
                    _buildDashedBorderContainer(
                      height: 88,
                      onTap: () {
                        setDState(() {
                          hasLogo = !hasLogo;
                        });
                      },
                      child: hasLogo
                          ? Stack(
                              children: [
                                Center(
                                  child: _buildBrandLogoDetailed(mfg),
                                ),
                                Positioned(
                                  top: 6,
                                  right: 6,
                                  child: GestureDetector(
                                    onTap: () {
                                      setDState(() {
                                        hasLogo = false;
                                      });
                                    },
                                    child: Container(
                                      width: 18,
                                      height: 18,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFEF4444),
                                        shape: BoxShape.circle,
                                      ),
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        Icons.close_rounded,
                                        size: 13,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.image_outlined,
                                  size: 30,
                                  color: Color(0xFF818CF8),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E293B),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    "No file chosen",
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
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
                              controller: editCtrl,
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
                            final newName = editCtrl.text.trim();
                            if (newName.isNotEmpty) {
                              setState(() {
                                final idx = _manufacturers.indexOf(mfg);
                                if (idx != -1) {
                                  _manufacturers[idx] = newName;
                                }
                                if (_selectedManufacturer == mfg) {
                                  _selectedManufacturer = newName;
                                }
                                if (_hiddenManufacturers.contains(mfg)) {
                                  _hiddenManufacturers.remove(mfg);
                                  _hiddenManufacturers.add(newName);
                                }
                                if (_modelsByManufacturer.containsKey(mfg)) {
                                  final models =
                                      _modelsByManufacturer.remove(mfg)!;
                                  _modelsByManufacturer[newName] = models;
                                }
                              });
                              onUpdated?.call();
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
    final hasMfg =
        _selectedManufacturer.isNotEmpty && _selectedManufacturer != "Select";
    final models = hasMfg
        ? (_modelsByManufacturer[_selectedManufacturer] ??
            _modelsByManufacturer["Hyundai"] ??
            [])
        : (_isEditMode ? (_modelsByManufacturer["Hyundai"] ?? []) : <String>[]);
    final search = _modelSearchCtrl.text.trim().toLowerCase();
    final filtered =
        models.where((m) => m.toLowerCase().contains(search)).toList();

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
                  hintText: "Find models...",
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
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildModelRowItem(mod, isSelected),
                              if (_editingModel == mod) ...[
                                _buildInlineEditModelForm(mod),
                              ],
                            ],
                          );
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
                      : const BorderRadius.vertical(
                          bottom: Radius.circular(10)),
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
    final isHidden = _hiddenModels.contains(mod);
    return InkWell(
      onTap: onTapOverride ??
          () {
            setState(() {
              if (_hiddenModels.contains(mod)) {
                _hiddenModels.remove(mod);
              }
              _selectedModel = mod;
              if (_carNameCtrl.text.isEmpty) {
                _carNameCtrl.text = _selectedManufacturer != "Select"
                    ? "$_selectedManufacturer $mod"
                    : mod;
              }
            });
            onStateChange?.call();
          },
      child: Container(
        decoration: (isSelected && !isHidden)
            ? const BoxDecoration(
                color: Color(0xFFEFF6FF),
                border: Border(
                  left: BorderSide(color: Color(0xFF2563EB), width: 3.5),
                ),
              )
            : null,
        padding: EdgeInsets.symmetric(
            horizontal: (isSelected && !isHidden) ? 12.5 : 16, vertical: 12),
        child: Row(
          children: [
            // Model name (Blue when selected, strikethrough when hidden)
            Expanded(
              child: Text(
                mod,
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  fontWeight: (isSelected && !isHidden)
                      ? FontWeight.w600
                      : FontWeight.w500,
                  color: isHidden
                      ? const Color(0xFF94A3B8)
                      : (isSelected
                          ? const Color(0xFF2563EB)
                          : const Color(0xFF0F172A)),
                  decoration: isHidden ? TextDecoration.lineThrough : null,
                  decorationColor: const Color(0xFF94A3B8),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Action 1: Eye (Toggle Hide & Select)
            InkWell(
              onTap: () {
                setState(() {
                  if (_hiddenModels.contains(mod)) {
                    _hiddenModels.remove(mod);
                    _selectedModel = mod;
                  } else {
                    _hiddenModels.add(mod);
                    if (_selectedModel == mod) {
                      _selectedModel = "";
                    }
                  }
                });
                onStateChange?.call();
              },
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Icon(
                  isHidden
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 19,
                  color: isHidden
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF14B8A6),
                ),
              ),
            ),
            const SizedBox(width: 4),

            // Action 2: Edit
            InkWell(
              onTap: () {
                setState(() {
                  _selectedModel = mod;
                  if (_editingModel == mod) {
                    _editingModel = null;
                  } else {
                    _editingModel = mod;
                    _editModelNameCtrl.text = mod;
                    _isAddingModel = false;
                  }
                  if (_carNameCtrl.text.isEmpty) {
                    _carNameCtrl.text = _selectedManufacturer != "Select"
                        ? "$_selectedManufacturer $mod"
                        : mod;
                  }
                });
                onStateChange?.call();
              },
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

  Widget _buildInlineEditModelForm(String mod, {VoidCallback? onStateChange}) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFE2E8F0)),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Edit Model ",
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8FAFC),
                    borderRadius:
                        BorderRadius.horizontal(left: Radius.circular(5)),
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
                    controller: _editModelNameCtrl,
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
                    onSubmitted: (_) {
                      _saveEditedModel(mod);
                      onStateChange?.call();
                    },
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
                  _saveEditedModel(mod);
                  onStateChange?.call();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF14B8A6),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
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
                    _editingModel = null;
                  });
                  onStateChange?.call();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF818CF8),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
    );
  }

  void _saveEditedModel(String mod) {
    final newName = _editModelNameCtrl.text.trim();
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
        if (_carNameCtrl.text.contains(mod)) {
          _carNameCtrl.text = _carNameCtrl.text.replaceAll(mod, newName);
        }
        if (_hiddenModels.contains(mod)) {
          _hiddenModels.remove(mod);
          _hiddenModels.add(newName);
        }
        _editingModel = null;
      });
    } else {
      setState(() {
        _editingModel = null;
      });
    }
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
                      : const BorderRadius.vertical(
                          bottom: Radius.circular(10)),
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

            // Inline Add Body Type Form (Matching Image)
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
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        Text(
                          "Body Type Image",
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
                          if (_newBodyTypeImageMock == null) {
                            _newBodyTypeImageMock = "body_type.png";
                          } else {
                            _newBodyTypeImageMock = null;
                          }
                        });
                      },
                      child: _newBodyTypeImageMock == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.image_outlined,
                                  size: 26,
                                  color: Color(0xFF94A3B8),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E293B),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    "No file chosen",
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
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
                      "Body Type Name",
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
                              controller: _newBodyTypeNameCtrl,
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
                              onSubmitted: (_) => _saveNewBodyType(),
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
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isAddingBodyType = false;
                              _newBodyTypeNameCtrl.clear();
                              _newBodyTypeImageMock = null;
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
        _newBodyTypeImageMock = null;
      });
    }
  }

  Widget _buildBodyTypeRowItem(
    String bt,
    bool isSelected, {
    VoidCallback? onTapOverride,
    VoidCallback? onStateChange,
  }) {
    final isHidden = _hiddenBodyTypes.contains(bt);
    return InkWell(
      onTap: onTapOverride ??
          () {
            setState(() {
              _selectedBodyType = bt;
            });
            onStateChange?.call();
          },
      child: Container(
        decoration: isSelected
            ? const BoxDecoration(
                border: Border(
                  left: BorderSide(color: Color(0xFF2563EB), width: 3.5),
                ),
              )
            : null,
        padding: EdgeInsets.symmetric(
            horizontal: isSelected ? 10.5 : 14, vertical: 10),
        child: Row(
          children: [
            // Radio button
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              size: 20,
              color: isSelected
                  ? const Color(0xFF10B981)
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
                  color: isHidden
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF0F172A),
                  decoration: isHidden ? TextDecoration.lineThrough : null,
                  decorationColor: const Color(0xFF94A3B8),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Action 1: Eye (Toggle Hide & Select)
            InkWell(
              onTap: () {
                setState(() {
                  // Toggle hide
                  if (_hiddenBodyTypes.contains(bt)) {
                    _hiddenBodyTypes.remove(bt);
                  } else {
                    _hiddenBodyTypes.add(bt);
                  }
                  // Also select this body type
                  _selectedBodyType = bt;
                });
                onStateChange?.call();
              },
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Icon(
                  isHidden
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 19,
                  color: isHidden
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF14B8A6),
                ),
              ),
            ),
            const SizedBox(width: 4),

            // Action 2: Edit
            InkWell(
              onTap: () {
                setState(() {
                  _selectedBodyType = bt;
                });
                onStateChange?.call();
                _editBodyTypeDialog(bt, onUpdated: onStateChange);
              },
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

  void _editBodyTypeDialog(String bt, {VoidCallback? onUpdated}) {
    final editCtrl = TextEditingController(text: bt);
    bool hasImage = true;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDState) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              insetPadding: const EdgeInsets.symmetric(horizontal: 20),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Edit Body Type ",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        Text(
                          "Body Type Image",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF4338CA),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Dashed border container with car illustration or upload placeholder
                    _buildDashedBorderContainer(
                      height: 88,
                      onTap: () {
                        setDState(() {
                          hasImage = !hasImage;
                        });
                      },
                      child: hasImage
                          ? Stack(
                              children: [
                                Center(
                                  child: SizedBox(
                                    width: 120,
                                    height: 56,
                                    child: CustomPaint(
                                      painter: CarIllustrationPainter(),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 6,
                                  right: 6,
                                  child: GestureDetector(
                                    onTap: () {
                                      setDState(() {
                                        hasImage = false;
                                      });
                                    },
                                    child: Container(
                                      width: 18,
                                      height: 18,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFEF4444),
                                        shape: BoxShape.circle,
                                      ),
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        Icons.close_rounded,
                                        size: 13,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.image_outlined,
                                  size: 30,
                                  color: Color(0xFF818CF8),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E293B),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    "No file chosen",
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),

                    const SizedBox(height: 14),

                    Text(
                      "Body Type Name",
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
                              controller: editCtrl,
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
                            final newName = editCtrl.text.trim();
                            if (newName.isNotEmpty) {
                              setState(() {
                                final idx = _bodyTypes.indexOf(bt);
                                if (idx != -1) {
                                  _bodyTypes[idx] = newName;
                                }
                                if (_selectedBodyType == bt) {
                                  _selectedBodyType = newName;
                                }
                                if (_hiddenBodyTypes.contains(bt)) {
                                  _hiddenBodyTypes.remove(bt);
                                  _hiddenBodyTypes.add(newName);
                                }
                              });
                              onUpdated?.call();
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
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
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
                      : const BorderRadius.vertical(
                          bottom: Radius.circular(10)),
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

            // Inline Add Color Form (Matching Image: media_1795420672799_121eec9c.png)
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
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        Text(
                          "Color Swatch (Image)",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF4338CA),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Dashed border container
                    _buildDashedBorderContainer(
                      height: 88,
                      onTap: () {
                        setState(() {
                          if (_newExteriorColorImageMock == null) {
                            _newExteriorColorImageMock = "swatch.png";
                          } else {
                            _newExteriorColorImageMock = null;
                          }
                        });
                      },
                      child: _newExteriorColorImageMock == null
                          ? const Center(
                              child: Icon(
                                Icons.image_outlined,
                                size: 32,
                                color: Color(0xFF818CF8),
                              ),
                            )
                          : Stack(
                              children: [
                                Center(
                                  child: Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: _parseHexColor(
                                          _newExteriorColorCodeCtrl.text
                                              .trim()),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(0xFFCBD5E1),
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 6,
                                  right: 6,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _newExteriorColorImageMock = null;
                                      });
                                    },
                                    child: Container(
                                      width: 18,
                                      height: 18,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFEF4444),
                                        shape: BoxShape.circle,
                                      ),
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        Icons.close_rounded,
                                        size: 13,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),

                    const SizedBox(height: 14),

                    Text(
                      "Color Code",
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
                              Icons.colorize_rounded,
                              size: 18,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _newExteriorColorCodeCtrl,
                              style: GoogleFonts.poppins(
                                fontSize: 13.5,
                                color: const Color(0xFF0F172A),
                              ),
                              decoration: InputDecoration(
                                hintText: "#000000",
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

                    Text(
                      "Color Name",
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
                              controller: _newExteriorColorNameCtrl,
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
                              onSubmitted: (_) => _saveNewExteriorColor(),
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
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isAddingExteriorColor = false;
                              _newExteriorColorNameCtrl.clear();
                              _newExteriorColorCodeCtrl.text = "#000000";
                              _newExteriorColorImageMock = null;
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

  void _saveNewExteriorColor() {
    final name = _newExteriorColorNameCtrl.text.trim();
    final code = _newExteriorColorCodeCtrl.text.trim();
    if (name.isNotEmpty) {
      final parsedColor = _parseHexColor(code.isNotEmpty ? code : "#000000");
      setState(() {
        final exists = _exteriorColors.any(
            (c) => (c["name"] as String).toLowerCase() == name.toLowerCase());
        if (!exists) {
          _exteriorColors.insert(0, {
            "name": name,
            "code": code.isNotEmpty ? code : "#000000",
            "color": parsedColor,
            "border": parsedColor == Colors.white,
          });
        }
        _selectedExteriorColor = name;
        _isAddingExteriorColor = false;
        _newExteriorColorNameCtrl.clear();
        _newExteriorColorCodeCtrl.text = "#000000";
        _newExteriorColorImageMock = null;
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
    final isHidden = _hiddenExteriorColors.contains(name);
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
                  ? const Color(0xFF10B981)
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
                  color: border ? const Color(0xFFCBD5E1) : color,
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
                  color: isHidden
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF0F172A),
                  decoration: isHidden ? TextDecoration.lineThrough : null,
                  decorationColor: const Color(0xFF94A3B8),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Action 1: Eye (Toggle Hide & Select)
            InkWell(
              onTap: () {
                setState(() {
                  // Toggle hide
                  if (_hiddenExteriorColors.contains(name)) {
                    _hiddenExteriorColors.remove(name);
                  } else {
                    _hiddenExteriorColors.add(name);
                  }
                  // Also select this exterior color
                  _selectedExteriorColor = name;
                });
                onStateChange?.call();
              },
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Icon(
                  isHidden
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 19,
                  color: isHidden
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF14B8A6),
                ),
              ),
            ),
            const SizedBox(width: 4),

            // Action 2: Edit
            InkWell(
              onTap: () {
                setState(() {
                  _selectedExteriorColor = name;
                });
                onStateChange?.call();
                _editExteriorColorDialog(name, onUpdated: onStateChange);
              },
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

  Color _parseHexColor(String hex) {
    try {
      final clean = hex.replaceAll("#", "").trim();
      if (clean.length == 6) {
        return Color(int.parse("0xFF$clean"));
      } else if (clean.length == 8) {
        return Color(int.parse("0x$clean"));
      }
    } catch (_) {}
    return const Color(0xFF1E293B);
  }

  void _editExteriorColorDialog(String name, {VoidCallback? onUpdated}) {
    final existing = _exteriorColors.firstWhere(
      (c) => c["name"] == name,
      orElse: () => {"name": name, "color": const Color(0xFF000000)},
    );
    final existingColor =
        (existing["color"] as Color?) ?? const Color(0xFF000000);
    final initialCode = (existing["code"] as String?) ??
        '#${existingColor.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
    final codeCtrl = TextEditingController(text: initialCode);
    final nameCtrl = TextEditingController(text: name);
    bool hasImage = false;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDState) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              insetPadding: const EdgeInsets.symmetric(horizontal: 20),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Edit Color ",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        Text(
                          "Color Swatch (Image)",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF4338CA),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Dashed border container
                    _buildDashedBorderContainer(
                      height: 88,
                      onTap: () {
                        setDState(() {
                          hasImage = !hasImage;
                        });
                      },
                      child: hasImage
                          ? Stack(
                              children: [
                                Center(
                                  child: Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color:
                                          _parseHexColor(codeCtrl.text.trim()),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(0xFFCBD5E1),
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 6,
                                  right: 6,
                                  child: GestureDetector(
                                    onTap: () {
                                      setDState(() {
                                        hasImage = false;
                                      });
                                    },
                                    child: Container(
                                      width: 18,
                                      height: 18,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFEF4444),
                                        shape: BoxShape.circle,
                                      ),
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        Icons.close_rounded,
                                        size: 13,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const Center(
                              child: Icon(
                                Icons.image_outlined,
                                size: 32,
                                color: Color(0xFF818CF8),
                              ),
                            ),
                    ),

                    const SizedBox(height: 14),

                    Text(
                      "Color Code",
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
                              Icons.colorize_rounded,
                              size: 18,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: codeCtrl,
                              style: GoogleFonts.poppins(
                                fontSize: 13.5,
                                color: const Color(0xFF0F172A),
                              ),
                              decoration: InputDecoration(
                                hintText: "#000000",
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

                    Text(
                      "Color Name",
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
                              controller: nameCtrl,
                              style: GoogleFonts.poppins(
                                fontSize: 13.5,
                                color: const Color(0xFF0F172A),
                              ),
                              decoration: InputDecoration(
                                hintText: "Color Name",
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
                            final newName = nameCtrl.text.trim();
                            final newCode = codeCtrl.text.trim();
                            if (newName.isNotEmpty) {
                              setState(() {
                                for (var c in _exteriorColors) {
                                  if (c["name"] == name) {
                                    c["name"] = newName;
                                    if (newCode.isNotEmpty) {
                                      c["code"] = newCode;
                                      c["color"] = _parseHexColor(newCode);
                                    }
                                    break;
                                  }
                                }
                                if (_selectedExteriorColor == name) {
                                  _selectedExteriorColor = newName;
                                }
                                if (_hiddenExteriorColors.contains(name)) {
                                  _hiddenExteriorColors.remove(name);
                                  _hiddenExteriorColors.add(newName);
                                }
                              });
                              onUpdated?.call();
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
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
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
                      (c["name"] as String).toLowerCase() == val.toLowerCase());
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
                      ? const Icon(Icons.check_circle, color: Color(0xFF2563EB))
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

  // ================= HOME SECTIONS CARD (IMAGE 1) =================
  Widget _buildHomeSectionsCard() {
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
                _homeSectionsExpanded = !_homeSectionsExpanded;
              });
            },
            onLongPress: _showHomeSectionsPicker,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              child: Row(
                children: [
                  const Icon(
                    Icons.desktop_windows_outlined,
                    color: Color(0xFFEF4444),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Home Sections",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  if (!_homeSectionsExpanded &&
                      _selectedHomeSections.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "${_selectedHomeSections.length} selected",
                        style: GoogleFonts.poppins(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFDC2626),
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  Icon(
                    _homeSectionsExpanded
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.keyboard_arrow_up_rounded,
                    size: 22,
                    color: const Color(0xFF64748B),
                  ),
                ],
              ),
            ),
          ),

          if (_homeSectionsExpanded) ...[
            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),

            // List of Home Sections (No search bar as per Image 1)
            Container(
              constraints: const BoxConstraints(maxHeight: 300),
              child: _homeSectionsList.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: Text(
                          "No home sections found",
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
                      itemCount: _homeSectionsList.length,
                      separatorBuilder: (_, __) => const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFF1F5F9),
                      ),
                      itemBuilder: (ctx, i) {
                        final item = _homeSectionsList[i];
                        final name = item["name"] as String;
                        final hasPriceTabs =
                            item["hasPriceTabs"] as bool? ?? false;
                        final isSelected = _selectedHomeSections.contains(name);
                        return _buildHomeSectionRowItem(
                            name, hasPriceTabs, isSelected);
                      },
                    ),
            ),

            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),

            // Footer Button: + Add Entry
            InkWell(
              onTap: () {
                setState(() {
                  _isAddingHomeSection = !_isAddingHomeSection;
                });
              },
              borderRadius: _isAddingHomeSection
                  ? BorderRadius.zero
                  : const BorderRadius.vertical(bottom: Radius.circular(10)),
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: _isAddingHomeSection
                      ? BorderRadius.zero
                      : const BorderRadius.vertical(
                          bottom: Radius.circular(10)),
                ),
                child: Text(
                  "+ Add Entry",
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF059669),
                  ),
                ),
              ),
            ),

            // Inline Add Home Panel Form (Image 2)
            if (_isAddingHomeSection) ...[
              const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Add Home Panel ",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        Text(
                          "Panel Name",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF4338CA),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Panel Name input field (height 44px)
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
                                horizontal: 12, vertical: 11),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(5)),
                              border: Border(
                                right: BorderSide(color: Color(0xFFCBD5E1)),
                              ),
                            ),
                            child: const Icon(
                              Icons.drive_file_rename_outline_rounded,
                              size: 18,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _newHomeSectionNameCtrl,
                              autofocus: true,
                              style: GoogleFonts.poppins(
                                fontSize: 13.5,
                                color: const Color(0xFF0F172A),
                              ),
                              decoration: InputDecoration(
                                hintText:
                                    "Name (e.g. Explore Hatchbacks by Price, Recently Added)",
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: const Color(0xFF94A3B8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Price Filter Tabs Card with Toggle
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.sell_outlined,
                                      size: 16,
                                      color: Color(0xFF10B981),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Price Filter Tabs",
                                      style: GoogleFonts.poppins(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF334155),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  "Show / Hide budget tabs on homepage",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _newHomeSectionHasPriceTabs =
                                    !_newHomeSectionHasPriceTabs;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              width: 44,
                              height: 24,
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: _newHomeSectionHasPriceTabs
                                    ? const Color(0xFF14B8A6)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _newHomeSectionHasPriceTabs
                                      ? const Color(0xFF14B8A6)
                                      : const Color(0xFFCBD5E1),
                                ),
                              ),
                              child: Align(
                                alignment: _newHomeSectionHasPriceTabs
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Container(
                                  width: 18,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _newHomeSectionHasPriceTabs
                                        ? Colors.white
                                        : const Color(0xFF94A3B8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Update and Cancel buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: _saveNewHomeSection,
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
                            "Update",
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
                              _isAddingHomeSection = false;
                              _newHomeSectionNameCtrl.clear();
                              _newHomeSectionHasPriceTabs = false;
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

  void _saveNewHomeSection() {
    final val = _newHomeSectionNameCtrl.text.trim();
    if (val.isNotEmpty) {
      setState(() {
        final existingIndex = _homeSectionsList.indexWhere((item) =>
            (item["name"] as String).toLowerCase() == val.toLowerCase());
        if (existingIndex == -1) {
          _homeSectionsList.insert(0, {
            "name": val,
            "hasPriceTabs": _newHomeSectionHasPriceTabs,
          });
        } else {
          _homeSectionsList[existingIndex]["hasPriceTabs"] =
              _newHomeSectionHasPriceTabs;
        }
        if (!_selectedHomeSections.contains(val)) {
          _selectedHomeSections.add(val);
        }
        _isAddingHomeSection = false;
        _newHomeSectionNameCtrl.clear();
        _newHomeSectionHasPriceTabs = false;
      });
    }
  }

  Widget _buildHomeSectionRowItem(
    String name,
    bool hasPriceTabs,
    bool isSelected, {
    VoidCallback? onTapOverride,
    VoidCallback? onStateChange,
  }) {
    final isHidden = _hiddenHomeSections.contains(name);
    return InkWell(
      onTap: onTapOverride ??
          () {
            setState(() {
              if (isSelected) {
                _selectedHomeSections.remove(name);
              } else {
                _selectedHomeSections.add(name);
              }
            });
            onStateChange?.call();
          },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            // Square Checkbox
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF10B981) : Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF10B981)
                      : const Color(0xFFCBD5E1),
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Center(
                      child: Icon(
                        Icons.check_rounded,
                        size: 13,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),

            // Section Name
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      name,
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: isHidden
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF0F172A),
                        decoration:
                            isHidden ? TextDecoration.lineThrough : null,
                        decorationColor: const Color(0xFF94A3B8),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (hasPriceTabs) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "Price Tabs",
                        style: GoogleFonts.poppins(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF059669),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Action 1: Eye (Toggle Hide & Select)
            InkWell(
              onTap: () {
                setState(() {
                  if (_hiddenHomeSections.contains(name)) {
                    _hiddenHomeSections.remove(name);
                  } else {
                    _hiddenHomeSections.add(name);
                  }
                  if (!_selectedHomeSections.contains(name)) {
                    _selectedHomeSections.add(name);
                  }
                });
                onStateChange?.call();
              },
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Icon(
                  isHidden
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 19,
                  color: isHidden
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF14B8A6),
                ),
              ),
            ),
            const SizedBox(width: 4),

            // Action 2: Edit (Select & open edit dialog)
            InkWell(
              onTap: () {
                setState(() {
                  if (!_selectedHomeSections.contains(name)) {
                    _selectedHomeSections.add(name);
                  }
                });
                onStateChange?.call();
                _editHomePanelCustomDialog(name, hasPriceTabs,
                    onUpdated: onStateChange);
              },
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
                  _deleteHomeSectionDialog(name, onDeleted: onStateChange),
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

  // Edit Home Panel Dialog (Image 3)
  void _editHomePanelCustomDialog(
    String name,
    bool initialHasPriceTabs, {
    VoidCallback? onUpdated,
  }) {
    final editCtrl = TextEditingController(text: name);
    bool hasPriceTabs = initialHasPriceTabs;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDState) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              insetPadding: const EdgeInsets.symmetric(horizontal: 20),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Edit Home Panel ",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        Text(
                          "Panel Name",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF4338CA),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Panel Name input
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
                                horizontal: 12, vertical: 11),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(5)),
                              border: Border(
                                right: BorderSide(color: Color(0xFFCBD5E1)),
                              ),
                            ),
                            child: const Icon(
                              Icons.drive_file_rename_outline_rounded,
                              size: 18,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: editCtrl,
                              autofocus: true,
                              style: GoogleFonts.poppins(
                                fontSize: 13.5,
                                color: const Color(0xFF0F172A),
                              ),
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Price Filter Tabs card
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.sell_outlined,
                                      size: 16,
                                      color: Color(0xFF10B981),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Price Filter Tabs",
                                      style: GoogleFonts.poppins(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF334155),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  "Show / Hide budget tabs on homepage",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setDState(() {
                                hasPriceTabs = !hasPriceTabs;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              width: 44,
                              height: 24,
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: hasPriceTabs
                                    ? const Color(0xFF14B8A6)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: hasPriceTabs
                                      ? const Color(0xFF14B8A6)
                                      : const Color(0xFFCBD5E1),
                                ),
                              ),
                              child: Align(
                                alignment: hasPriceTabs
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Container(
                                  width: 18,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: hasPriceTabs
                                        ? Colors.white
                                        : const Color(0xFF94A3B8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Update and Cancel buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            final val = editCtrl.text.trim();
                            if (val.isNotEmpty) {
                              setState(() {
                                final idx = _homeSectionsList
                                    .indexWhere((item) => item["name"] == name);
                                if (idx != -1) {
                                  _homeSectionsList[idx] = {
                                    "name": val,
                                    "hasPriceTabs": hasPriceTabs,
                                  };
                                }
                                if (_selectedHomeSections.contains(name)) {
                                  _selectedHomeSections.remove(name);
                                  _selectedHomeSections.add(val);
                                }
                                if (_hiddenHomeSections.contains(name)) {
                                  _hiddenHomeSections.remove(name);
                                  _hiddenHomeSections.add(val);
                                }
                              });
                              onUpdated?.call();
                              Navigator.pop(ctx);
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
                            "Update",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
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
                              fontWeight: FontWeight.w600,
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

  void _deleteHomeSectionDialog(String name, {VoidCallback? onDeleted}) {
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
                "Delete Home Section",
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
                  _homeSectionsList.removeWhere((item) => item["name"] == name);
                  _selectedHomeSections.remove(name);
                  _hiddenHomeSections.remove(name);
                });
                onDeleted?.call();
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
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
                        final item = _homeSectionsList[i];
                        final name = item["name"] as String;
                        final hasPriceTabs =
                            item["hasPriceTabs"] as bool? ?? false;
                        final isChecked = tempSelected.contains(name);
                        return _buildHomeSectionRowItem(
                          name,
                          hasPriceTabs,
                          isChecked,
                          onTapOverride: () {
                            setModalState(() {
                              if (isChecked) {
                                tempSelected.remove(name);
                              } else {
                                tempSelected.add(name);
                              }
                            });
                          },
                          onStateChange: () {
                            setModalState(() {});
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

  // ================= RTO RULES CARD (IMAGE 1) =================
  Widget _buildRtoRulesCard() {
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
                _rtoRulesExpanded = !_rtoRulesExpanded;
              });
            },
            onLongPress: _showRtoRulesPicker,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              child: Row(
                children: [
                  const Icon(
                    Icons.account_balance_outlined,
                    color: Color(0xFFF43F5E),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "RTO Rules",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    _rtoRulesExpanded
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.keyboard_arrow_up_rounded,
                    size: 22,
                    color: const Color(0xFF64748B),
                  ),
                ],
              ),
            ),
          ),

          if (_rtoRulesExpanded) ...[
            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),

            // List of RTO Rules
            Column(
              children: List.generate(_rtoRulesList.length, (i) {
                final item = _rtoRulesList[i];
                final state = item['state'] as String? ?? "State";
                final maxPrice = item['maxPrice'] as String? ?? "0";
                final percentage = item['percentage'] as String? ?? "0";
                final formattedRule = "$state: Max ₹$maxPrice ($percentage%)";
                final isSelected = _selectedRtoRule == formattedRule;
                final isHidden = _hiddenRtoRules.contains(formattedRule);

                return Column(
                  children: [
                    if (i > 0)
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFF1F5F9),
                      ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _selectedRtoRule = formattedRule;
                        });
                      },
                      child: Container(
                        decoration: (isSelected && !isHidden)
                            ? const BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color: Color(0xFF2563EB),
                                    width: 3.5,
                                  ),
                                ),
                              )
                            : null,
                        padding: EdgeInsets.symmetric(
                          horizontal: (isSelected && !isHidden) ? 12.5 : 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            // Rule Text (Blue when selected, strikethrough when hidden)
                            Expanded(
                              child: Text(
                                formattedRule,
                                style: GoogleFonts.poppins(
                                  fontSize: 13.5,
                                  fontWeight: (isSelected && !isHidden)
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  color: isHidden
                                      ? const Color(0xFF94A3B8)
                                      : (isSelected
                                          ? const Color(0xFF2563EB)
                                          : const Color(0xFF0F172A)),
                                  decoration: isHidden
                                      ? TextDecoration.lineThrough
                                      : null,
                                  decorationColor: const Color(0xFF94A3B8),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            // Action 1: Eye (Toggle Hide & Select)
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (_hiddenRtoRules.contains(formattedRule)) {
                                    _hiddenRtoRules.remove(formattedRule);
                                    _selectedRtoRule = formattedRule;
                                  } else {
                                    _hiddenRtoRules.add(formattedRule);
                                    if (_selectedRtoRule == formattedRule) {
                                      _selectedRtoRule = "";
                                    }
                                  }
                                });
                              },
                              borderRadius: BorderRadius.circular(4),
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Icon(
                                  isHidden
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  size: 19,
                                  color: isHidden
                                      ? const Color(0xFF94A3B8)
                                      : const Color(0xFF14B8A6),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),

                            // Action 2: Edit (Select & Toggle Inline Edit Form)
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedRtoRule = formattedRule;
                                  if (_editingRtoRuleIndex == i) {
                                    _editingRtoRuleIndex = null;
                                  } else {
                                    _editingRtoRuleIndex = i;
                                    _isAddingRtoRule = false;
                                    _editRtoState = state;
                                    _editRtoMaxPriceCtrl.text = maxPrice;
                                    _editRtoPercentageCtrl.text = percentage;
                                  }
                                });
                              },
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
                                  _deleteRtoRuleDialog(i, formattedRule),
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
                    ),

                    // Inline Edit RTO Rule Form (Image 3)
                    if (_editingRtoRuleIndex == i) ...[
                      const Divider(
                          height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Edit Rto ",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1E293B),
                                  ),
                                ),
                                Text(
                                  "State",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF4338CA),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            // State Dropdown
                            _buildRtoStateDropdown(
                              value: _editRtoState,
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _editRtoState = val);
                                }
                              },
                            ),
                            const SizedBox(height: 12),

                            // Max Price Limit
                            Text(
                              "Max Price Limit",
                              style: GoogleFonts.poppins(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF475569),
                              ),
                            ),
                            const SizedBox(height: 6),
                            _buildRtoPrefixInput(
                              prefix: "₹",
                              controller: _editRtoMaxPriceCtrl,
                              hintText: "Max Price",
                            ),
                            const SizedBox(height: 12),

                            // Percentage
                            Text(
                              "Percentage",
                              style: GoogleFonts.poppins(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF475569),
                              ),
                            ),
                            const SizedBox(height: 6),
                            _buildRtoPercentageInput(
                              controller: _editRtoPercentageCtrl,
                              hintText: "Percentage",
                            ),
                            const SizedBox(height: 14),

                            // Save and Cancel buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () => _saveEditedRtoRule(i),
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
                                      _editingRtoRuleIndex = null;
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
                );
              }),
            ),

            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),

            // Footer Button: + Add Entry
            InkWell(
              onTap: () {
                setState(() {
                  _isAddingRtoRule = !_isAddingRtoRule;
                  if (_isAddingRtoRule) {
                    _editingRtoRuleIndex = null;
                  }
                });
              },
              borderRadius: _isAddingRtoRule
                  ? BorderRadius.zero
                  : const BorderRadius.vertical(bottom: Radius.circular(10)),
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: _isAddingRtoRule
                      ? BorderRadius.zero
                      : const BorderRadius.vertical(
                          bottom: Radius.circular(10)),
                ),
                child: Text(
                  "+ Add Entry",
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF059669),
                  ),
                ),
              ),
            ),

            // Inline Add RTO Rule Form (Image 2)
            if (_isAddingRtoRule) ...[
              const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Add RTO Rule ",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        Text(
                          "State",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF4338CA),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // State Dropdown
                    _buildRtoStateDropdown(
                      value: _newRtoState,
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _newRtoState = val);
                        }
                      },
                    ),
                    const SizedBox(height: 12),

                    // Max Price Limit
                    Text(
                      "Max Price Limit",
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(height: 6),
                    _buildRtoPrefixInput(
                      prefix: "₹",
                      controller: _newRtoMaxPriceCtrl,
                      hintText: "Max Price",
                    ),
                    const SizedBox(height: 12),

                    // Percentage
                    Text(
                      "Percentage",
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(height: 6),
                    _buildRtoPercentageInput(
                      controller: _newRtoPercentageCtrl,
                      hintText: "Percentage",
                    ),
                    const SizedBox(height: 14),

                    // Save and Cancel buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: _saveNewRtoRule,
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
                              _isAddingRtoRule = false;
                              _newRtoMaxPriceCtrl.clear();
                              _newRtoPercentageCtrl.clear();
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

  Widget _buildRtoStateDropdown({
    required String value,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.horizontal(left: Radius.circular(5)),
              border: Border(
                right: BorderSide(color: Color(0xFFCBD5E1)),
              ),
            ),
            child: const Icon(
              Icons.map_outlined,
              size: 18,
              color: Color(0xFF64748B),
            ),
          ),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value:
                    _indianStates.contains(value) ? value : _indianStates.first,
                isExpanded: true,
                icon: const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(Icons.arrow_drop_down, color: Color(0xFF64748B)),
                ),
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  color: const Color(0xFF0F172A),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                items: _indianStates.map((s) {
                  return DropdownMenuItem<String>(
                    value: s,
                    child: Text(
                      s,
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        color: s == "State"
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF0F172A),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRtoPrefixInput({
    required String prefix,
    required TextEditingController controller,
    required String hintText,
  }) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.horizontal(left: Radius.circular(5)),
              border: Border(
                right: BorderSide(color: Color(0xFFCBD5E1)),
              ),
            ),
            child: Text(
              prefix,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF64748B),
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: GoogleFonts.poppins(
                fontSize: 13.5,
                color: const Color(0xFF0F172A),
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: GoogleFonts.poppins(
                  fontSize: 13,
                  color: const Color(0xFF94A3B8),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRtoPercentageInput({
    required TextEditingController controller,
    required String hintText,
  }) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.horizontal(left: Radius.circular(5)),
              border: Border(
                right: BorderSide(color: Color(0xFFCBD5E1)),
              ),
            ),
            child: Text(
              "%",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF64748B),
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: GoogleFonts.poppins(
                fontSize: 13.5,
                color: const Color(0xFF0F172A),
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: GoogleFonts.poppins(
                  fontSize: 13,
                  color: const Color(0xFF94A3B8),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          // Stepper up/down
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  final cur = double.tryParse(controller.text) ?? 0;
                  final next = cur + 1;
                  controller.text = next == next.toInt()
                      ? next.toInt().toString()
                      : next.toStringAsFixed(2);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                  child: Icon(Icons.arrow_drop_up,
                      size: 16, color: Color(0xFF64748B)),
                ),
              ),
              InkWell(
                onTap: () {
                  final cur = double.tryParse(controller.text) ?? 0;
                  if (cur > 0) {
                    final next = cur - 1;
                    final valid = next < 0 ? 0.0 : next;
                    controller.text = valid == valid.toInt()
                        ? valid.toInt().toString()
                        : valid.toStringAsFixed(2);
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                  child: Icon(Icons.arrow_drop_down,
                      size: 16, color: Color(0xFF64748B)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _saveNewRtoRule() {
    final state = _newRtoState == "State" ? "Gujarat" : _newRtoState;
    final maxPrice = _newRtoMaxPriceCtrl.text.trim().isEmpty
        ? "500,000"
        : _newRtoMaxPriceCtrl.text.trim();
    final percentage = _newRtoPercentageCtrl.text.trim().isEmpty
        ? "12.00"
        : _newRtoPercentageCtrl.text.trim();

    final formattedRule = "$state: Max ₹$maxPrice ($percentage%)";
    setState(() {
      _rtoRulesList.insert(0, {
        "state": state,
        "maxPrice": maxPrice,
        "percentage": percentage,
      });
      _selectedRtoRule = formattedRule;
      _isAddingRtoRule = false;
      _newRtoMaxPriceCtrl.clear();
      _newRtoPercentageCtrl.clear();
      _newRtoState = "State";
    });
  }

  void _saveEditedRtoRule(int index) {
    if (index >= 0 && index < _rtoRulesList.length) {
      final state = _editRtoState == "State"
          ? (_rtoRulesList[index]["state"] as String? ?? "Gujarat")
          : _editRtoState;
      final maxPrice = _editRtoMaxPriceCtrl.text.trim().isEmpty
          ? (_rtoRulesList[index]["maxPrice"] as String? ?? "500,000")
          : _editRtoMaxPriceCtrl.text.trim();
      final percentage = _editRtoPercentageCtrl.text.trim().isEmpty
          ? (_rtoRulesList[index]["percentage"] as String? ?? "0")
          : _editRtoPercentageCtrl.text.trim();

      final oldRuleString =
          "${_rtoRulesList[index]['state']}: Max ₹${_rtoRulesList[index]['maxPrice']} (${_rtoRulesList[index]['percentage']}%)";
      final newRuleString = "$state: Max ₹$maxPrice ($percentage%)";

      setState(() {
        _rtoRulesList[index] = {
          "state": state,
          "maxPrice": maxPrice,
          "percentage": percentage,
        };
        if (_selectedRtoRule == oldRuleString) {
          _selectedRtoRule = newRuleString;
        }
        if (_hiddenRtoRules.contains(oldRuleString)) {
          _hiddenRtoRules.remove(oldRuleString);
          _hiddenRtoRules.add(newRuleString);
        }
        _editingRtoRuleIndex = null;
      });
    }
  }

  void _deleteRtoRuleDialog(int index, String ruleString) {
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
                "Delete RTO Rule",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          content: Text(
            "Are you sure you want to remove \"$ruleString\"? This action cannot be undone.",
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
                  if (index >= 0 && index < _rtoRulesList.length) {
                    _rtoRulesList.removeAt(index);
                  }
                  if (_selectedRtoRule == ruleString) {
                    _selectedRtoRule = _rtoRulesList.isNotEmpty
                        ? "${_rtoRulesList.first['state']}: Max ₹${_rtoRulesList.first['maxPrice']} (${_rtoRulesList.first['percentage']}%)"
                        : "Select";
                  }
                  _hiddenRtoRules.remove(ruleString);
                  if (_editingRtoRuleIndex == index) {
                    _editingRtoRuleIndex = null;
                  }
                });
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
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
                    final state = item['state'] as String? ?? "State";
                    final maxPrice = item['maxPrice'] as String? ?? "0";
                    final percentage = item['percentage'] as String? ?? "0";
                    final formattedRule =
                        "$state: Max ₹$maxPrice ($percentage%)";
                    final isSelected = _selectedRtoRule == formattedRule;
                    return ListTile(
                      title: Text(
                        formattedRule,
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
                        setState(() {
                          _selectedRtoRule = formattedRule;
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

  // ================= TCS RULES CARD (IMAGE 1) =================
  Widget _buildTcsRulesCard() {
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
                _tcsRulesExpanded = !_tcsRulesExpanded;
              });
            },
            onLongPress: _showTcsRulesPicker,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              child: Row(
                children: [
                  const Icon(
                    Icons.percent,
                    color: Color(0xFF0D9488),
                    size: 19,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "TCS Rules",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    _tcsRulesExpanded
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.keyboard_arrow_up_rounded,
                    size: 22,
                    color: const Color(0xFF64748B),
                  ),
                ],
              ),
            ),
          ),

          if (_tcsRulesExpanded) ...[
            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),

            // List of TCS Rules
            Column(
              children: List.generate(_tcsRulesList.length, (i) {
                final item = _tcsRulesList[i];
                final abovePrice = item['abovePrice'] as String? ?? "0";
                final percentage = item['percentage'] as String? ?? "0";
                final formattedRule = "Above ₹$abovePrice @ $percentage%";
                final isSelected = _selectedTcsRule == formattedRule;
                final isHidden = _hiddenTcsRules.contains(formattedRule);

                return Column(
                  children: [
                    if (i > 0)
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFF1F5F9),
                      ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _selectedTcsRule = formattedRule;
                        });
                      },
                      child: Container(
                        decoration: (isSelected && !isHidden)
                            ? const BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color: Color(0xFF2563EB),
                                    width: 3.5,
                                  ),
                                ),
                              )
                            : null,
                        padding: EdgeInsets.symmetric(
                          horizontal: (isSelected && !isHidden) ? 12.5 : 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            // Rule Text (Blue when selected, strikethrough when hidden)
                            Expanded(
                              child: Text(
                                formattedRule,
                                style: GoogleFonts.poppins(
                                  fontSize: 13.5,
                                  fontWeight: (isSelected && !isHidden)
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  color: isHidden
                                      ? const Color(0xFF94A3B8)
                                      : (isSelected
                                          ? const Color(0xFF2563EB)
                                          : const Color(0xFF0F172A)),
                                  decoration: isHidden
                                      ? TextDecoration.lineThrough
                                      : null,
                                  decorationColor: const Color(0xFF94A3B8),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            // Action 1: Eye (Toggle Hide & Select)
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (_hiddenTcsRules.contains(formattedRule)) {
                                    _hiddenTcsRules.remove(formattedRule);
                                    _selectedTcsRule = formattedRule;
                                  } else {
                                    _hiddenTcsRules.add(formattedRule);
                                    if (_selectedTcsRule == formattedRule) {
                                      _selectedTcsRule = "";
                                    }
                                  }
                                });
                              },
                              borderRadius: BorderRadius.circular(4),
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Icon(
                                  isHidden
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  size: 19,
                                  color: isHidden
                                      ? const Color(0xFF94A3B8)
                                      : const Color(0xFF14B8A6),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),

                            // Action 2: Edit (Select & Toggle Inline Edit Form)
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedTcsRule = formattedRule;
                                  if (_editingTcsRuleIndex == i) {
                                    _editingTcsRuleIndex = null;
                                  } else {
                                    _editingTcsRuleIndex = i;
                                    _isAddingTcsRule = false;
                                    _editTcsAbovePriceCtrl.text = abovePrice;
                                    _editTcsPercentageCtrl.text = percentage;
                                  }
                                });
                              },
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
                                  _deleteTcsRuleDialog(i, formattedRule),
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
                    ),

                    // Inline Edit TCS Rule Form (Image 3)
                    if (_editingTcsRuleIndex == i) ...[
                      const Divider(
                          height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Edit Tcs ",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1E293B),
                                  ),
                                ),
                                Text(
                                  "Above Price",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF4338CA),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            // Above Price Input
                            _buildRtoPrefixInput(
                              prefix: "₹",
                              controller: _editTcsAbovePriceCtrl,
                              hintText: "Above Price",
                            ),
                            const SizedBox(height: 12),

                            // Percentage Label
                            Text(
                              "Percentage",
                              style: GoogleFonts.poppins(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF475569),
                              ),
                            ),
                            const SizedBox(height: 6),
                            _buildRtoPrefixInput(
                              prefix: "%",
                              controller: _editTcsPercentageCtrl,
                              hintText: "Percentage",
                            ),
                            const SizedBox(height: 14),

                            // Save and Cancel buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () => _saveEditedTcsRule(i),
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
                                      _editingTcsRuleIndex = null;
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
                );
              }),
            ),

            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),

            // Footer Button: + Add Entry
            InkWell(
              onTap: () {
                setState(() {
                  _isAddingTcsRule = !_isAddingTcsRule;
                  if (_isAddingTcsRule) {
                    _editingTcsRuleIndex = null;
                  }
                });
              },
              borderRadius: _isAddingTcsRule
                  ? BorderRadius.zero
                  : const BorderRadius.vertical(bottom: Radius.circular(10)),
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: _isAddingTcsRule
                      ? BorderRadius.zero
                      : const BorderRadius.vertical(
                          bottom: Radius.circular(10)),
                ),
                child: Text(
                  "+ Add Entry",
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF059669),
                  ),
                ),
              ),
            ),

            // Inline Add TCS Rule Form (Image 2)
            if (_isAddingTcsRule) ...[
              const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Add Tcs ",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        Text(
                          "Above Price",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF4338CA),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Above Price Input
                    _buildRtoPrefixInput(
                      prefix: "₹",
                      controller: _newTcsAbovePriceCtrl,
                      hintText: "Above Price",
                    ),
                    const SizedBox(height: 12),

                    // Percentage Label
                    Text(
                      "Percentage",
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(height: 6),
                    _buildRtoPrefixInput(
                      prefix: "%",
                      controller: _newTcsPercentageCtrl,
                      hintText: "Percentage",
                    ),
                    const SizedBox(height: 14),

                    // Save and Cancel buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: _saveNewTcsRule,
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
                              _isAddingTcsRule = false;
                              _newTcsAbovePriceCtrl.clear();
                              _newTcsPercentageCtrl.clear();
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

  void _saveNewTcsRule() {
    final abovePrice = _newTcsAbovePriceCtrl.text.trim().isEmpty
        ? "500,000"
        : _newTcsAbovePriceCtrl.text.trim();
    final percentage = _newTcsPercentageCtrl.text.trim().isEmpty
        ? "12.00"
        : _newTcsPercentageCtrl.text.trim();

    final formattedRule = "Above ₹$abovePrice @ $percentage%";
    setState(() {
      _tcsRulesList.insert(0, {
        "abovePrice": abovePrice,
        "percentage": percentage,
      });
      _selectedTcsRule = formattedRule;
      _isAddingTcsRule = false;
      _newTcsAbovePriceCtrl.clear();
      _newTcsPercentageCtrl.clear();
    });
  }

  void _saveEditedTcsRule(int index) {
    if (index >= 0 && index < _tcsRulesList.length) {
      final abovePrice = _editTcsAbovePriceCtrl.text.trim().isEmpty
          ? (_tcsRulesList[index]["abovePrice"] as String? ?? "500,000")
          : _editTcsAbovePriceCtrl.text.trim();
      final percentage = _editTcsPercentageCtrl.text.trim().isEmpty
          ? (_tcsRulesList[index]["percentage"] as String? ?? "12.00")
          : _editTcsPercentageCtrl.text.trim();

      final oldRuleString =
          "Above ₹${_tcsRulesList[index]['abovePrice']} @ ${_tcsRulesList[index]['percentage']}%";
      final newRuleString = "Above ₹$abovePrice @ $percentage%";

      setState(() {
        _tcsRulesList[index] = {
          "abovePrice": abovePrice,
          "percentage": percentage,
        };
        if (_selectedTcsRule == oldRuleString) {
          _selectedTcsRule = newRuleString;
        }
        if (_hiddenTcsRules.contains(oldRuleString)) {
          _hiddenTcsRules.remove(oldRuleString);
          _hiddenTcsRules.add(newRuleString);
        }
        _editingTcsRuleIndex = null;
      });
    }
  }

  void _deleteTcsRuleDialog(int index, String ruleString) {
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
                "Delete TCS Rule",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          content: Text(
            "Are you sure you want to remove \"$ruleString\"? This action cannot be undone.",
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
                  if (index >= 0 && index < _tcsRulesList.length) {
                    _tcsRulesList.removeAt(index);
                  }
                  if (_selectedTcsRule == ruleString) {
                    _selectedTcsRule = _tcsRulesList.isNotEmpty
                        ? "Above ₹${_tcsRulesList.first['abovePrice']} @ ${_tcsRulesList.first['percentage']}%"
                        : "Select";
                  }
                  _hiddenTcsRules.remove(ruleString);
                  if (_editingTcsRuleIndex == index) {
                    _editingTcsRuleIndex = null;
                  }
                });
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
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
                    final abovePrice = item['abovePrice'] as String? ?? "0";
                    final percentage = item['percentage'] as String? ?? "0";
                    final formattedRule = "Above ₹$abovePrice @ $percentage%";
                    final isSelected = _selectedTcsRule == formattedRule;
                    return ListTile(
                      title: Text(
                        formattedRule,
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
                        setState(() {
                          _selectedTcsRule = formattedRule;
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
    final hasMfg =
        _selectedManufacturer.isNotEmpty && _selectedManufacturer != "Select";
    List<String> defaultModels = [
      "ALCAZAR",
      "ALCAZAR 1.5 AT PLATINUM(O) 6S",
      "ALCAZAR 1.5 MT PLATINUM 7S",
      "Aura",
      "AURA 1.2MT CNG S",
      "AURA 1.2MT KAPPA S",
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
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildModelRowItem(
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
                                  ),
                                  if (_editingModel == item) ...[
                                    _buildInlineEditModelForm(item,
                                        onStateChange: () =>
                                            setModalState(() {})),
                                  ],
                                ],
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
                              final border = (item["border"] ?? false) as bool;
                              final isSelected = _selectedExteriorColor == name;
                              return _buildExteriorColorRowItem(
                                name,
                                color,
                                border,
                                isSelected,
                                onTapOverride: () {
                                  setState(() => _selectedExteriorColor = name);
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

  // ================= FEATURES CARD (IMAGE 1) =================
  Widget _buildFeaturesCard() {
    final search = _featuresSearchCtrl.text.trim().toLowerCase();
    final filtered =
        _featuresList.where((f) => f.toLowerCase().contains(search)).toList();

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
                _featuresExpanded = !_featuresExpanded;
              });
            },
            onLongPress: _showFeaturesPicker,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              child: Row(
                children: [
                  const Icon(
                    Icons.format_list_bulleted_rounded,
                    color: Color(0xFF10B981),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Features",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  if (!_featuresExpanded && _selectedFeatures.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "${_selectedFeatures.length} selected",
                        style: GoogleFonts.poppins(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF16A34A),
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  Icon(
                    _featuresExpanded
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.keyboard_arrow_up_rounded,
                    size: 22,
                    color: const Color(0xFF64748B),
                  ),
                ],
              ),
            ),
          ),

          if (_featuresExpanded) ...[
            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),

            // Search Bar: Find features...
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
              child: TextField(
                controller: _featuresSearchCtrl,
                onChanged: (_) => setState(() {}),
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: const Color(0xFF0F172A),
                ),
                decoration: InputDecoration(
                  hintText: "Find features...",
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

            // List of Features
            Container(
              constraints: const BoxConstraints(maxHeight: 280),
              child: filtered.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: Text(
                          "No features found",
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
                        final feature = filtered[i];
                        final isSelected = _selectedFeatures.contains(feature);
                        return _buildFeatureRowItem(feature, isSelected);
                      },
                    ),
            ),

            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),

            // Footer Button: + Add Entry
            InkWell(
              onTap: () {
                setState(() {
                  _isAddingFeature = !_isAddingFeature;
                });
              },
              borderRadius: _isAddingFeature
                  ? BorderRadius.zero
                  : const BorderRadius.vertical(bottom: Radius.circular(10)),
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: _isAddingFeature
                      ? BorderRadius.zero
                      : const BorderRadius.vertical(
                          bottom: Radius.circular(10)),
                ),
                child: Text(
                  "+ Add Entry",
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF059669),
                  ),
                ),
              ),
            ),

            // Inline Add Feature Form (Image 2)
            if (_isAddingFeature) ...[
              const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Add Feature ",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        Text(
                          "Feature Name",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF4338CA),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Feature Name input field (height 44px)
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
                                horizontal: 12, vertical: 11),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(5)),
                              border: Border(
                                right: BorderSide(color: Color(0xFFCBD5E1)),
                              ),
                            ),
                            child: const Icon(
                              Icons.drive_file_rename_outline_rounded,
                              size: 18,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _newFeatureNameCtrl,
                              autofocus: true,
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
                                    horizontal: 12, vertical: 10),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Save and Cancel buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: _saveNewFeature,
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
                              _isAddingFeature = false;
                              _newFeatureNameCtrl.clear();
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

  void _saveNewFeature() {
    final val = _newFeatureNameCtrl.text.trim();
    if (val.isNotEmpty) {
      setState(() {
        if (!_featuresList.contains(val)) {
          _featuresList.insert(0, val);
        }
        if (!_selectedFeatures.contains(val)) {
          _selectedFeatures.add(val);
        }
        _isAddingFeature = false;
        _newFeatureNameCtrl.clear();
      });
    }
  }

  Widget _buildFeatureRowItem(
    String feature,
    bool isSelected, {
    VoidCallback? onTapOverride,
    VoidCallback? onStateChange,
  }) {
    final isHidden = _hiddenFeatures.contains(feature);
    return InkWell(
      onTap: onTapOverride ??
          () {
            setState(() {
              if (isSelected) {
                _selectedFeatures.remove(feature);
              } else {
                _selectedFeatures.add(feature);
              }
            });
            onStateChange?.call();
          },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            // Checkbox (Square matching Image 1)
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF10B981) : Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF10B981)
                      : const Color(0xFFCBD5E1),
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Center(
                      child: Icon(
                        Icons.check_rounded,
                        size: 13,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),

            // Feature Name
            Expanded(
              child: Text(
                feature,
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: isHidden
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF0F172A),
                  decoration: isHidden ? TextDecoration.lineThrough : null,
                  decorationColor: const Color(0xFF94A3B8),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Action 1: Eye (Toggle Hide & Select checkbox)
            InkWell(
              onTap: () {
                setState(() {
                  // Toggle hide
                  if (_hiddenFeatures.contains(feature)) {
                    _hiddenFeatures.remove(feature);
                  } else {
                    _hiddenFeatures.add(feature);
                  }
                  // Auto-select checkbox
                  if (!_selectedFeatures.contains(feature)) {
                    _selectedFeatures.add(feature);
                  }
                });
                onStateChange?.call();
              },
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Icon(
                  isHidden
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 19,
                  color: isHidden
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF14B8A6),
                ),
              ),
            ),
            const SizedBox(width: 4),

            // Action 2: Edit (Select checkbox & open edit dialog)
            InkWell(
              onTap: () {
                setState(() {
                  if (!_selectedFeatures.contains(feature)) {
                    _selectedFeatures.add(feature);
                  }
                });
                onStateChange?.call();
                _editFeatureCustomDialog(feature, onUpdated: onStateChange);
              },
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
                  _deleteFeatureDialogDirect(feature, onDeleted: onStateChange),
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

  // Edit Feature Dialog (Image 3)
  void _editFeatureCustomDialog(String feature, {VoidCallback? onUpdated}) {
    final editCtrl = TextEditingController(text: feature);

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDState) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              insetPadding: const EdgeInsets.symmetric(horizontal: 20),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Edit Feature ",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        Text(
                          "Feature Name",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF4338CA),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Feature Name input
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
                                horizontal: 12, vertical: 11),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(5)),
                              border: Border(
                                right: BorderSide(color: Color(0xFFCBD5E1)),
                              ),
                            ),
                            child: const Icon(
                              Icons.drive_file_rename_outline_rounded,
                              size: 18,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: editCtrl,
                              autofocus: true,
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
                                    horizontal: 12, vertical: 10),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Save and Cancel buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            final val = editCtrl.text.trim();
                            if (val.isNotEmpty) {
                              setState(() {
                                final idx = _featuresList.indexOf(feature);
                                if (idx != -1) {
                                  _featuresList[idx] = val;
                                }
                                if (_selectedFeatures.contains(feature)) {
                                  _selectedFeatures.remove(feature);
                                  _selectedFeatures.add(val);
                                }
                                if (_hiddenFeatures.contains(feature)) {
                                  _hiddenFeatures.remove(feature);
                                  _hiddenFeatures.add(val);
                                }
                              });
                              onUpdated?.call();
                              Navigator.pop(ctx);
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
                              fontWeight: FontWeight.w600,
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

  void _deleteFeatureDialogDirect(String feature, {VoidCallback? onDeleted}) {
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
                "Delete Feature",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          content: Text(
            "Are you sure you want to remove \"$feature\"? This action cannot be undone.",
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
                  _featuresList.remove(feature);
                  _selectedFeatures.remove(feature);
                  _hiddenFeatures.remove(feature);
                });
                onDeleted?.call();
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
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
                                      color: _hiddenFeatures.contains(feature)
                                          ? const Color(0xFF94A3B8)
                                          : const Color(0xFF0F172A),
                                      decoration:
                                          _hiddenFeatures.contains(feature)
                                              ? TextDecoration.lineThrough
                                              : null,
                                      decorationColor: const Color(0xFF94A3B8),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),

                                // Action Buttons: Eye, Edit, Delete
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // 1. Eye (Toggle Hide & Select)
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (_hiddenFeatures
                                              .contains(feature)) {
                                            _hiddenFeatures.remove(feature);
                                          } else {
                                            _hiddenFeatures.add(feature);
                                          }
                                          if (!_selectedFeatures
                                              .contains(feature)) {
                                            _selectedFeatures.add(feature);
                                          }
                                        });
                                        setModalState(() {
                                          if (!tempSelected.contains(feature)) {
                                            tempSelected.add(feature);
                                          }
                                        });
                                      },
                                      borderRadius: BorderRadius.circular(6),
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF0FDFA),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Icon(
                                          _hiddenFeatures.contains(feature)
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_outlined,
                                          size: 16,
                                          color:
                                              _hiddenFeatures.contains(feature)
                                                  ? const Color(0xFF94A3B8)
                                                  : const Color(0xFF14B8A6),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),

                                    // 2. Edit
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (!_selectedFeatures
                                              .contains(feature)) {
                                            _selectedFeatures.add(feature);
                                          }
                                        });
                                        setModalState(() {
                                          if (!tempSelected.contains(feature)) {
                                            tempSelected.add(feature);
                                          }
                                        });
                                        _editFeatureCustomDialog(
                                          feature,
                                          onUpdated: () => setModalState(() {}),
                                        );
                                      },
                                      borderRadius: BorderRadius.circular(6),
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF8FAFC),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: const Icon(
                                          Icons.edit_outlined,
                                          size: 16,
                                          color: Color(0xFF94A3B8),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),

                                    // 3. Delete
                                    InkWell(
                                      onTap: () => _deleteFeatureDialogDirect(
                                        feature,
                                        onDeleted: () {
                                          setModalState(() {
                                            tempSelected.remove(feature);
                                          });
                                        },
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
                                          color: Color(0xFF94A3B8),
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
                    borderSide:
                        const BorderSide(color: Color(0xFF003366), width: 1.5),
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
      Rect.fromLTWH(strokeWidth / 2, strokeWidth / 2, size.width - strokeWidth,
          size.height - strokeWidth),
      Radius.circular(radius),
    );

    final Path path = Path()..addRRect(rrect);
    final Path dashPath = Path();

    for (final ui.PathMetric metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final double len =
            (distance + dash < metric.length) ? dash : metric.length - distance;
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

class CarIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = const Color(0xFF0F172A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final blackFill = Paint()
      ..color = const Color(0xFF0F172A)
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    final wheelRadius = h * 0.22;
    final wheelY = h * 0.78;
    final frontWheelX = w * 0.72;
    final rearWheelX = w * 0.28;

    final body = Path();
    body.moveTo(w * 0.12, wheelY);
    body.cubicTo(w * 0.08, h * 0.55, w * 0.16, h * 0.40, w * 0.32, h * 0.28);
    body.cubicTo(w * 0.42, h * 0.15, w * 0.58, h * 0.15, w * 0.70, h * 0.30);
    body.cubicTo(w * 0.82, h * 0.42, w * 0.94, h * 0.55, w * 0.90, wheelY);
    body.lineTo(frontWheelX + wheelRadius + 2, wheelY);
    body.arcToPoint(
      Offset(frontWheelX - wheelRadius - 2, wheelY),
      radius: Radius.circular(wheelRadius + 2),
      clockwise: false,
    );
    body.lineTo(rearWheelX + wheelRadius + 2, wheelY);
    body.arcToPoint(
      Offset(rearWheelX - wheelRadius - 2, wheelY),
      radius: Radius.circular(wheelRadius + 2),
      clockwise: false,
    );
    body.close();

    canvas.drawPath(body, fillPaint);
    canvas.drawPath(body, strokePaint);

    // Front window
    final frontWindow = Path();
    frontWindow.moveTo(w * 0.52, h * 0.24);
    frontWindow.lineTo(w * 0.65, h * 0.34);
    frontWindow.cubicTo(
        w * 0.68, h * 0.48, w * 0.64, h * 0.50, w * 0.52, h * 0.50);
    frontWindow.close();
    canvas.drawPath(frontWindow, blackFill);

    // Rear window
    final rearWindow = Path();
    rearWindow.moveTo(w * 0.48, h * 0.24);
    rearWindow.cubicTo(
        w * 0.36, h * 0.30, w * 0.30, h * 0.42, w * 0.32, h * 0.50);
    rearWindow.lineTo(w * 0.48, h * 0.50);
    rearWindow.close();
    canvas.drawPath(rearWindow, blackFill);

    // Door handle
    final handlePaint = Paint()
      ..color = const Color(0xFF0F172A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: Offset(w * 0.50, h * 0.57), width: 10, height: 4),
        const Radius.circular(2),
      ),
      handlePaint,
    );

    // Headlight detail
    canvas.drawArc(
      Rect.fromCenter(
          center: Offset(w * 0.83, h * 0.54), width: 10, height: 14),
      -1.5,
      3.0,
      false,
      strokePaint,
    );

    // Wheels
    for (final wx in [rearWheelX, frontWheelX]) {
      canvas.drawCircle(Offset(wx, wheelY), wheelRadius, blackFill);
      canvas.drawCircle(Offset(wx, wheelY), wheelRadius * 0.45, fillPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
