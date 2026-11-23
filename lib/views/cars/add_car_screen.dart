import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/admin_profile_avatar.dart';

class AddCarScreen extends StatefulWidget {
  final String carUid;
  final dynamic existingVehicle;
  final bool isEditMode;

  const AddCarScreen({
    super.key,
    this.carUid = "#CARUID979",
    this.existingVehicle,
    this.isEditMode = false,
  });

  @override
  State<AddCarScreen> createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  final _formKey = GlobalKey<FormState>();

  // 4-Step Wizard Stepper State
  int _currentStep = 0;

  // Accordion Expand/Collapse States
  bool _primaryDetailsExpanded = true;
  bool _seoMetadataExpanded = false;
  bool _dragAndSortEnabled = true;

  // Publishing State (Image 1 & 2)
  bool _publishingExpanded = false;
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

  // Home Sections & Tax Rules State (Image: media_1795250345980_1bcf08c7.png)
  List<String> _selectedHomeSections = [];
  bool _homeSectionsExpanded = false;
  bool _isAddingHomeSection = false;
  final _newHomeSectionNameCtrl = TextEditingController();
  bool _newHomeSectionPriceTabs = false;
  String _selectedRtoRule = ": Max ₹500,000 (12.00%)";
  bool _rtoRulesExpanded = false;
  bool _isAddingRtoRule = false;
  String _newRtoState = "State";
  final _newRtoMaxPriceCtrl = TextEditingController();
  final _newRtoPercentageCtrl = TextEditingController();
  String _selectedTcsRule = "Above ₹500,000 @ 12.00%";
  bool _tcsRulesExpanded = false;
  bool _isAddingTcsRule = false;
  final _newTcsAbovePriceCtrl = TextEditingController();
  final _newTcsPercentageCtrl = TextEditingController();

  final List<Map<String, dynamic>> _homeSectionsList = [
    {"name": "Certified Car", "priceTabs": false},
    {"name": "Electric Car", "priceTabs": false},
    {"name": "Explore Hatchbacks by Price", "priceTabs": true},
    {"name": "Explore Sedans by Price", "priceTabs": true},
    {"name": "Explore SUVs by Price", "priceTabs": true},
    {"name": "Inspected Cars", "priceTabs": false},
  ];

  final List<Map<String, dynamic>> _rtoRulesList = [
    {
      "state": "",
      "maxPrice": "500,000",
      "percentage": "12.00",
    },
  ];

  final List<Map<String, dynamic>> _tcsRulesList = [
    {
      "abovePrice": "500,000",
      "percentage": "12.00",
    },
  ];

  // Make, Model & Features State
  bool _manufacturerExpanded = false;
  final _manufacturerSearchCtrl = TextEditingController();
  bool _isAddingManufacturer = false;
  final _newManufacturerNameCtrl = TextEditingController();
  String? _newManufacturerImageMock;
  bool _modelExpanded = false;
  final _modelSearchCtrl = TextEditingController();
  bool _isAddingModel = false;
  final _newModelNameCtrl = TextEditingController();
  bool _bodyTypeExpanded = false;
  final _bodyTypeSearchCtrl = TextEditingController();
  bool _isAddingBodyType = false;
  final _newBodyTypeNameCtrl = TextEditingController();
  bool _exteriorColorExpanded = false;
  final _exteriorColorSearchCtrl = TextEditingController();
  bool _isAddingExteriorColor = false;
  final _newExteriorColorNameCtrl = TextEditingController();
  bool _featuresExpanded = false;
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
      "Xcent",
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
    if (widget.isEditMode || widget.existingVehicle != null) {
      _prefillExistingData();
    }
  }

  void _prefillExistingData() {
    final v = widget.existingVehicle;
    if (v == null && !widget.isEditMode) return;

    // 1. Vehicle Type
    try {
      final condition = (v?.condition ?? "").toString().toLowerCase();
      if (condition.contains("new")) {
        _vehicleType = "New car";
      } else {
        _vehicleType = "Used car";
      }
    } catch (_) {}

    // 2. Status
    try {
      final avail = (v?.availability ?? v?.status ?? "").toString();
      if (_statusOptions.contains(avail)) {
        _status = avail;
      }
    } catch (_) {}

    // 3. Make & Model
    String makeModelStr = "";
    try {
      makeModelStr = (v?.makeModel ?? v?.title ?? "").toString();
    } catch (_) {}

    if (makeModelStr.isNotEmpty) {
      _carNameCtrl.text = makeModelStr;

      // Auto-detect manufacturer
      final upper = makeModelStr.toUpperCase();
      if (upper.contains("TOYOTA")) {
        _selectedManufacturer = "Toyota";
      } else if (upper.contains("HYUNDAI")) {
        _selectedManufacturer = "Hyundai";
      } else if (upper.contains("MARUTI")) {
        _selectedManufacturer = "Maruti Suzuki";
      } else if (upper.contains("BMW")) {
        _selectedManufacturer = "BMW";
      } else if (upper.contains("AUDI")) {
        _selectedManufacturer = "AUDI";
      } else if (upper.contains("TATA")) {
        _selectedManufacturer = "Tata Motors";
      } else if (upper.contains("MAHINDRA")) {
        _selectedManufacturer = "Mahindra";
      } else if (upper.contains("HONDA")) {
        _selectedManufacturer = "Honda";
      } else if (upper.contains("KIA")) {
        _selectedManufacturer = "Kia";
      }

      // Auto-detect model
      if (_modelsByManufacturer.containsKey(_selectedManufacturer)) {
        final models = _modelsByManufacturer[_selectedManufacturer]!;
        for (final m in models) {
          if (upper.contains(m.toUpperCase())) {
            _selectedModel = m;
            break;
          }
        }
      }

      // Body Type
      if (upper.contains("FORTUNER") ||
          upper.contains("BREZZA") ||
          upper.contains("THAR") ||
          upper.contains("SCORPIO") ||
          upper.contains("HARRIER")) {
        _selectedBodyType = "5 DOOR STEEL SHELL";
      } else if (upper.contains("XCENT") ||
          upper.contains("CITY") ||
          upper.contains("VERNA") ||
          upper.contains("DZIRE") ||
          upper.contains("AURA")) {
        _selectedBodyType = "CAR (SEDAN)";
      }
    }

    // 4. Year
    try {
      final y = (v?.year ?? v?.yearModel ?? "").toString();
      if (y.isNotEmpty) {
        _makeYearCtrl.text = y;
      }
    } catch (_) {}

    // 5. Location & RTO
    try {
      final loc = (v?.location ?? "").toString();
      if (loc.isNotEmpty) {
        _location = loc;
        final locUpper = loc.toUpperCase();
        if (locUpper.contains("DEHRADUN") ||
            locUpper.contains("UTTARANCHAL") ||
            locUpper.contains("UTTARAKHAND")) {
          _rtoCode = "UK-07 (Dehradun)";
        } else if (locUpper.contains("BIKANER") ||
            locUpper.contains("JAIPUR") ||
            locUpper.contains("RAJASTHAN")) {
          _rtoCode = "RJ-14 (Jaipur)";
        } else if (locUpper.contains("DELHI")) {
          _rtoCode = "DL-01 (Delhi North)";
        } else if (locUpper.contains("NOIDA")) {
          _rtoCode = "UP-16 (Noida)";
        } else if (locUpper.contains("GURGAON")) {
          _rtoCode = "HR-26 (Gurgaon)";
        }
      }
    } catch (_) {}

    // 6. Owner / Agent Name
    try {
      final owner =
          (v?.agent ?? v?.ownerName ?? v?.company ?? "").toString();
      if (owner.isNotEmpty) {
        _ownerNameCtrl.text = owner;
      }
    } catch (_) {}

    // 7. RC Number
    final uidClean =
        widget.carUid.replaceAll("#", "").replaceAll("-", "").trim();
    if (_rtoCode.startsWith("UK-07")) {
      _rcNumberCtrl.text =
          "UK07AB${uidClean.length >= 4 ? uidClean.substring(uidClean.length - 4) : uidClean}";
    } else if (_rtoCode.startsWith("RJ-14")) {
      _rcNumberCtrl.text =
          "RJ14CA${uidClean.length >= 4 ? uidClean.substring(uidClean.length - 4) : uidClean}";
    } else {
      _rcNumberCtrl.text =
          "DL01AQ${uidClean.length >= 4 ? uidClean.substring(uidClean.length - 4) : uidClean}";
    }

    // 8. Seating capacity, Engine CC, Price, KMs
    final mmUpper = makeModelStr.toUpperCase();
    if (mmUpper.contains("FORTUNER") || mmUpper.contains("INNOVA")) {
      _seatingCapacity = "7 Seater";
      _engineCcCtrl.text = "2755";
      _grossWeightCtrl.text = "2610";
      _unladenWeightCtrl.text = "2180";
      _askingPriceCtrl.text = "15,50,000";
      _kmDrivenCtrl.text = "68,000";
      _mileageCtrl.text = "14.2 km/l";
      _fuelType = "Diesel";
      _transmission = "Automatic";
    } else if (mmUpper.contains("BREZZA")) {
      _seatingCapacity = "5 Seater";
      _engineCcCtrl.text = "1462";
      _grossWeightCtrl.text = "1680";
      _unladenWeightCtrl.text = "1180";
      _askingPriceCtrl.text = "8,25,000";
      _kmDrivenCtrl.text = "42,000";
      _mileageCtrl.text = "17.0 km/l";
      _fuelType = "Petrol";
      _transmission = "Manual";
    } else if (mmUpper.contains("XCENT")) {
      _seatingCapacity = "5 Seater";
      _engineCcCtrl.text = "1197";
      _grossWeightCtrl.text = "1420";
      _unladenWeightCtrl.text = "980";
      _askingPriceCtrl.text = "3,85,000";
      _kmDrivenCtrl.text = "55,000";
      _mileageCtrl.text = "19.1 km/l";
      _fuelType = "Diesel";
      _transmission = "Manual";
    } else {
      _seatingCapacity = "5 Seater";
      _engineCcCtrl.text = "1498";
      _grossWeightCtrl.text = "1650";
      _unladenWeightCtrl.text = "1150";
      _askingPriceCtrl.text = "6,50,000";
      _kmDrivenCtrl.text = "48,000";
      _mileageCtrl.text = "16.5 km/l";
      _fuelType = "Petrol";
      _transmission = "Manual";
    }

    // Price override if available
    try {
      final p = (v?.price ?? "").toString();
      if (p.isNotEmpty) {
        _askingPriceCtrl.text = p;
      }
      final k = (v?.kms ?? "").toString();
      if (k.isNotEmpty) {
        _kmDrivenCtrl.text = k;
      }
    } catch (_) {}

    // Technical details
    _cylindersCtrl.text = "4";
    _insuranceCompanyCtrl.text = "HDFC ERGO General Insurance";
    _policyNumberCtrl.text = "POL2026887712";
    _engineNumberCtrl.text = "1GD-FTV458921";
    _chassisNumberCtrl.text = "MBJ11FE22K00124";
    _financerCtrl.text = "HDFC Bank Ltd";
    _discountCtrl.text = "25,000";
    _fitnessValidUptoCtrl.text = "28 Nov 2028";
    _registrationDateCtrl.text = "17 Nov 2020";
    _insuranceExpiryCtrl.text = "15 Oct 2027";
    _puccValidUptoCtrl.text = "12 Mar 2027";
    _rcStatus = "Active";
    _ownership = "1st Owner";

    // Description
    try {
      final sub = (v?.subtitle ?? makeModelStr).toString();
      _descriptionCtrl.text =
          "$sub in excellent condition. Well-maintained, certified single-owner vehicle with complete service history.";
    } catch (_) {}

    // SEO
    _metaTitleCtrl.text = "$makeModelStr | Find My Carz";
    _metaKeywordsCtrl.text =
        "used car, $makeModelStr, certified car, $_location";
    _metaDescriptionCtrl.text =
        "Buy certified $makeModelStr in $_location at best price with warranty and easy financing.";

    // Publishing
    try {
      final st = (v?.status ?? "").toString().toLowerCase();
      if (st == "inactive" || st == "draft") {
        _publishingStatus = "Draft";
      } else {
        _publishingStatus = "Published";
      }
      final vis = (v?.visibility ?? "").toString().toLowerCase();
      if (vis == "private" || vis == "hide") {
        _homepageVisibility = "Hide";
      } else {
        _homepageVisibility = "Show";
      }
    } catch (_) {}

    // Features & Colors
    _selectedExteriorColor = "White";
    _selectedFeatures = [
      "Alloy Wheels",
      "Bluetooth",
      "Floor Mats",
      "Electric side mirror",
    ];

    // Images
    try {
      final img = (v?.image ?? "").toString();
      if (img.isNotEmpty) {
        _uploadedImages.add(img);
      } else {
        _uploadedImages.add("assets/images/car1.webp");
      }
    } catch (_) {
      _uploadedImages.add("assets/images/car1.webp");
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
    _featuresSearchCtrl.dispose();
    _newFeatureNameCtrl.dispose();
    _newHomeSectionNameCtrl.dispose();
    _newRtoMaxPriceCtrl.dispose();
    _newRtoPercentageCtrl.dispose();
    _newTcsAbovePriceCtrl.dispose();
    _newTcsPercentageCtrl.dispose();
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
        content: Text(widget.isEditMode
            ? "Vehicle ${widget.carUid} updated successfully!"
            : "Vehicle ${widget.carUid} added successfully!"),
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
                text: widget.isEditMode ? "Edit car " : "Add new car ",
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
        child: Column(
          children: [
            // Pinned/Fixed Stepper Header (stays fixed when scrolling)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: _buildStepperIndicator(),
            ),

            // Scrollable Active Step Content & Navigation
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Active Step Content
                    if (_currentStep == 0)
                      _buildPrimaryDetailsCard()
                    else if (_currentStep == 1) ...[
                      _buildManufacturerCard(),
                      const SizedBox(height: 14),
                      _buildModelCard(),
                    ] else if (_currentStep == 2) ...[
                      _buildBodyTypeCard(),
                      const SizedBox(height: 14),
                      _buildExteriorColorCard(),
                    ] else if (_currentStep == 3) ...[
                      _buildFeaturesCard(),
                      const SizedBox(height: 14),
                      _buildHomeSectionsCard(),
                      const SizedBox(height: 14),
                      _buildRtoRulesCard(),
                      const SizedBox(height: 14),
                      _buildTcsRulesCard(),
                      const SizedBox(height: 14),
                      _buildPublishingCard(),
                    ] else if (_currentStep == 4)
                      _buildImageGalleryCard()
                    else
                      _buildSeoMetadataCard(),

                    const SizedBox(height: 24),

                    // Bottom Step Navigation & Actions
                    _buildStepNavigationButtons(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Modern 6-Step Wizard Stepper Header
  Widget _buildStepperIndicator() {
    final stepTitles = [
      "Primary Details",
      "Make & Model",
      "Body & Color",
      "Features & Rules",
      "Image Gallery",
      "SEO & Metadata",
    ];

    return Container(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step Counter Badge & Title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF003366),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "Step ${_currentStep + 1} of 6",
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                stepTitles[_currentStep],
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Linear Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (_currentStep + 1) / 6,
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF003366)),
              minHeight: 5,
            ),
          ),
        ],
      ),
    );
  }

  // Bottom Step Navigation Buttons
  Widget _buildStepNavigationButtons() {
    return Row(
      children: [
        // 1. Back Button (always present: goes to previous step, or exits screen on Step 1)
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              if (_currentStep > 0) {
                setState(() {
                  _currentStep--;
                });
              } else {
                Navigator.pop(context);
              }
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF475569),
              side: const BorderSide(color: Color(0xFFCBD5E1)),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: const Icon(Icons.arrow_back, size: 16),
            label: Text(
              "Back",
              style: GoogleFonts.poppins(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // 2. Next / Save Vehicle Button
        Expanded(
          child: _currentStep < 5
              ? ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _currentStep++;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003366),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.arrow_forward, size: 16),
                  label: Text(
                    "Next",
                    style: GoogleFonts.poppins(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : ElevatedButton.icon(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF008844),
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
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ),
      ],
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
              color: isHidden
                  ? const Color(0xFFCBD5E1)
                  : (isSelected
                      ? const Color(0xFF2563EB)
                      : const Color(0xFFCBD5E1)),
            ),
            const SizedBox(width: 12),

            // Brand Logo container
            Opacity(
              opacity: isHidden ? 0.45 : 1.0,
              child: _buildBrandLogoWidget(mfg),
            ),
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
                  decoration: isHidden
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  decorationColor: const Color(0xFF94A3B8),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Action 1: Eye (Toggle Hide)
            InkWell(
              onTap: () {
                setState(() {
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
                      : Icons.remove_red_eye_outlined,
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
              onTap: () =>
                  _editManufacturerDialog(mfg, onUpdated: onStateChange),
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: isHidden
                      ? const Color(0xFFCBD5E1)
                      : const Color(0xFF94A3B8),
                ),
              ),
            ),
            const SizedBox(width: 4),

            // Action 3: Delete
            InkWell(
              onTap: () =>
                  _deleteManufacturerDialog(mfg, onDeleted: onStateChange),
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Icon(
                  Icons.delete_outline_rounded,
                  size: 19,
                  color: isHidden
                      ? const Color(0xFFCBD5E1)
                      : const Color(0xFF94A3B8),
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
    final isHidden = _hiddenModels.contains(mod);

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
              color: isHidden
                  ? const Color(0xFFCBD5E1)
                  : (isSelected
                      ? const Color(0xFF2563EB)
                      : const Color(0xFFCBD5E1)),
            ),
            const SizedBox(width: 12),

            // Model name
            Expanded(
              child: Text(
                mod,
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isHidden
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF0F172A),
                  decoration: isHidden
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  decorationColor: const Color(0xFF94A3B8),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Action 1: Eye (Toggle Hide)
            InkWell(
              onTap: () {
                setState(() {
                  if (_hiddenModels.contains(mod)) {
                    _hiddenModels.remove(mod);
                  } else {
                    _hiddenModels.add(mod);
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
                      : Icons.remove_red_eye_outlined,
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
    final isHidden = _hiddenBodyTypes.contains(bt);

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
              color: isHidden
                  ? const Color(0xFFCBD5E1)
                  : (isSelected
                      ? const Color(0xFF2563EB)
                      : const Color(0xFFCBD5E1)),
            ),
            const SizedBox(width: 12),

            // Car icon badge
            Opacity(
              opacity: isHidden ? 0.45 : 1.0,
              child: Container(
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
                  decoration: isHidden
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  decorationColor: const Color(0xFF94A3B8),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Action 1: Eye (Toggle Hide)
            InkWell(
              onTap: () {
                setState(() {
                  if (_hiddenBodyTypes.contains(bt)) {
                    _hiddenBodyTypes.remove(bt);
                  } else {
                    _hiddenBodyTypes.add(bt);
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
                      : Icons.remove_red_eye_outlined,
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
              onTap: () => _editBodyTypeDialog(bt, onUpdated: onStateChange),
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: isHidden
                      ? const Color(0xFFCBD5E1)
                      : const Color(0xFF94A3B8),
                ),
              ),
            ),
            const SizedBox(width: 4),

            // Action 3: Delete
            InkWell(
              onTap: () => _deleteBodyTypeDialog(bt, onDeleted: onStateChange),
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Icon(
                  Icons.delete_outline_rounded,
                  size: 19,
                  color: isHidden
                      ? const Color(0xFFCBD5E1)
                      : const Color(0xFF94A3B8),
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
              color: isHidden
                  ? const Color(0xFFCBD5E1)
                  : (isSelected
                      ? const Color(0xFF2563EB)
                      : const Color(0xFFCBD5E1)),
            ),
            const SizedBox(width: 12),

            // Color circle
            Opacity(
              opacity: isHidden ? 0.45 : 1.0,
              child: Container(
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
                  decoration: isHidden
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  decorationColor: const Color(0xFF94A3B8),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Action 1: Eye (Toggle Hide)
            InkWell(
              onTap: () {
                setState(() {
                  if (_hiddenExteriorColors.contains(name)) {
                    _hiddenExteriorColors.remove(name);
                  } else {
                    _hiddenExteriorColors.add(name);
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
                      : Icons.remove_red_eye_outlined,
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
              onTap: () =>
                  _editExteriorColorDialog(name, onUpdated: onStateChange),
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: isHidden
                      ? const Color(0xFFCBD5E1)
                      : const Color(0xFF94A3B8),
                ),
              ),
            ),
            const SizedBox(width: 4),

            // Action 3: Delete
            InkWell(
              onTap: () =>
                  _deleteExteriorColorDialog(name, onDeleted: onStateChange),
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Icon(
                  Icons.delete_outline_rounded,
                  size: 19,
                  color: isHidden
                      ? const Color(0xFFCBD5E1)
                      : const Color(0xFF94A3B8),
                ),
              ),
            ),
          ],
        ),
      ),
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

  // -------------------------------------------------------------
  // Features Methods (Matching Image: media_1795247375638_4da3646e.png)
  // -------------------------------------------------------------
  Widget _buildFeaturesCard() {
    final search = _featuresSearchCtrl.text.trim().toLowerCase();
    final filtered = _featuresList.where((f) {
      return f.toLowerCase().contains(search);
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
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "${_selectedFeatures.length} selected",
                        style: GoogleFonts.poppins(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF059669),
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

            // List of Features with Checkbox
            Container(
              constraints: const BoxConstraints(maxHeight: 280),
              child: filtered.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: Text(
                          "No feature found",
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
                        final isChecked = _selectedFeatures.contains(feature);
                        return _buildFeatureRowItem(feature, isChecked);
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
                      : const BorderRadius.vertical(bottom: Radius.circular(10)),
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

            // Inline Add Feature Form (Matching Image: media_1795247375638_4da3646e.png)
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
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              onSubmitted: (_) => _saveNewFeature(),
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
                              fontWeight: FontWeight.bold,
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

  Widget _buildFeatureRowItem(
    String feature,
    bool isChecked, {
    VoidCallback? onTapOverride,
    VoidCallback? onStateChange,
  }) {
    final isHidden = _hiddenFeatures.contains(feature);

    return InkWell(
      onTap: onTapOverride ??
          () {
            setState(() {
              if (_selectedFeatures.contains(feature)) {
                _selectedFeatures.remove(feature);
              } else {
                _selectedFeatures.add(feature);
              }
            });
            onStateChange?.call();
          },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            // Checkbox (Square with rounded corners)
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: isHidden
                    ? Colors.transparent
                    : (isChecked ? const Color(0xFF2563EB) : Colors.transparent),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isHidden
                      ? const Color(0xFFE2E8F0)
                      : (isChecked
                          ? const Color(0xFF2563EB)
                          : const Color(0xFFCBD5E1)),
                  width: 1.3,
                ),
              ),
              child: (!isHidden && isChecked)
                  ? const Icon(
                      Icons.check,
                      size: 13,
                      color: Colors.white,
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
                  decoration: isHidden
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  decorationColor: const Color(0xFF94A3B8),
                ),
              ),
            ),

            // Action Icons (👁️ View, ✏️ Edit, 🗑️ Delete)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      if (_hiddenFeatures.contains(feature)) {
                        _hiddenFeatures.remove(feature);
                      } else {
                        _hiddenFeatures.add(feature);
                      }
                    });
                    onStateChange?.call();
                  },
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      isHidden
                          ? Icons.visibility_off_outlined
                          : Icons.remove_red_eye_outlined,
                      size: 18,
                      color: isHidden
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF14B8A6),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                InkWell(
                  onTap: () => _editFeatureDialogCard(
                    feature,
                    onUpdated: () {
                      setState(() {});
                      onStateChange?.call();
                    },
                  ),
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.edit_outlined,
                      size: 18,
                      color: isHidden
                          ? const Color(0xFFCBD5E1)
                          : const Color(0xFF94A3B8),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                InkWell(
                  onTap: () => _deleteFeatureDialogCard(
                    feature,
                    onDeleted: () {
                      setState(() {});
                      onStateChange?.call();
                    },
                  ),
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.delete_outline_rounded,
                      size: 18,
                      color: isHidden
                          ? const Color(0xFFCBD5E1)
                          : const Color(0xFF94A3B8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Feature '$val' added successfully!"),
          backgroundColor: const Color(0xFF059669),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _editFeatureDialogCard(String feature, {VoidCallback? onUpdated}) {
    final editCtrl = TextEditingController(text: feature);
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
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.edit_outlined,
                    color: Color(0xFF64748B), size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                "Edit Feature",
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
                "Feature Name *",
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
                final newName = editCtrl.text.trim();
                if (newName.isNotEmpty && newName != feature) {
                  setState(() {
                    final idx = _featuresList.indexOf(feature);
                    if (idx != -1) {
                      _featuresList[idx] = newName;
                    }
                    if (_selectedFeatures.contains(feature)) {
                      _selectedFeatures.remove(feature);
                      _selectedFeatures.add(newName);
                    }
                  });
                  onUpdated?.call();
                }
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF14B8A6),
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

  void _deleteFeatureDialogCard(String feature, {VoidCallback? onDeleted}) {
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
            "Are you sure you want to remove \"$feature\" from features list?",
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

  // -------------------------------------------------------------
  // Home Sections Methods (Matching Image: media_1795250345980_1bcf08c7.png)
  // -------------------------------------------------------------
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
                    color: Color(0xFFF87171),
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
                  if (!_homeSectionsExpanded && _selectedHomeSections.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "${_selectedHomeSections.length} selected",
                        style: GoogleFonts.poppins(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF059669),
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

            // List of Home Sections
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: _homeSectionsList.length,
              separatorBuilder: (_, __) => const Divider(
                height: 1,
                thickness: 1,
                color: Color(0xFFF1F5F9),
              ),
              itemBuilder: (ctx, i) {
                final item = _homeSectionsList[i];
                final isChecked =
                    _selectedHomeSections.contains(item["name"] as String);
                return _buildHomeSectionRowItem(item, isChecked);
              },
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
                      : const BorderRadius.vertical(bottom: Radius.circular(10)),
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

            // Inline Add Home Panel Form (Matching Image: media_1795250345980_1bcf08c7.png)
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

                    // Name Input
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
                              controller: _newHomeSectionNameCtrl,
                              autofocus: true,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
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
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              onSubmitted: (_) => _saveNewHomeSection(),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Price Filter Tabs Switch Box
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.sell_outlined,
                            size: 18,
                            color: Color(0xFF10B981),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Price Filter Tabs",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1E293B),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Show / Hide budget tabs on homepage",
                                  style: GoogleFonts.poppins(
                                    fontSize: 11.5,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _newHomeSectionPriceTabs,
                            onChanged: (val) {
                              setState(() {
                                _newHomeSectionPriceTabs = val;
                              });
                            },
                            activeThumbColor: const Color(0xFF14B8A6),
                            activeTrackColor: const Color(0xFFCCFBF1),
                            inactiveThumbColor: const Color(0xFF94A3B8),
                            inactiveTrackColor: const Color(0xFFE2E8F0),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Bottom Save / Cancel Buttons
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
                              _isAddingHomeSection = false;
                              _newHomeSectionNameCtrl.clear();
                              _newHomeSectionPriceTabs = false;
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

  Widget _buildHomeSectionRowItem(
    Map<String, dynamic> item,
    bool isChecked, {
    VoidCallback? onTapOverride,
    VoidCallback? onStateChange,
  }) {
    final name = item["name"] as String;
    final priceTabs = (item["priceTabs"] as bool?) ?? false;

    return InkWell(
      onTap: onTapOverride ??
          () {
            setState(() {
              if (_selectedHomeSections.contains(name)) {
                _selectedHomeSections.remove(name);
              } else {
                _selectedHomeSections.add(name);
              }
            });
            onStateChange?.call();
          },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Checkbox (Square with rounded corners)
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: isChecked ? const Color(0xFF2563EB) : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isChecked
                      ? const Color(0xFF2563EB)
                      : const Color(0xFFCBD5E1),
                  width: 1.3,
                ),
              ),
              child: isChecked
                  ? const Icon(
                      Icons.check,
                      size: 13,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 10),

            // Section Name & Price Tabs Badge (Wrapped naturally so data is never cut off)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 6,
                  runSpacing: 3,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    if (priceTabs)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: const Color(0xFFA7F3D0),
                            width: 0.8,
                          ),
                        ),
                        child: Text(
                          "Price Tabs",
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF059669),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Action Icons (👁️ View/Toggle, ✏️ Edit, 🗑️ Delete)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      item["priceTabs"] = !priceTabs;
                    });
                    onStateChange?.call();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          item["priceTabs"] == true
                              ? "Price tabs enabled for '$name'"
                              : "Price tabs disabled for '$name'",
                        ),
                        backgroundColor: const Color(0xFF059669),
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.all(3.5),
                    child: Icon(
                      priceTabs
                          ? Icons.remove_red_eye_outlined
                          : Icons.visibility_off_outlined,
                      size: 17,
                      color: priceTabs
                          ? const Color(0xFF14B8A6)
                          : const Color(0xFF94A3B8),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                InkWell(
                  onTap: () => _editHomeSectionDialogCard(
                    item,
                    onUpdated: () {
                      setState(() {});
                      onStateChange?.call();
                    },
                  ),
                  borderRadius: BorderRadius.circular(4),
                  child: const Padding(
                    padding: EdgeInsets.all(3.5),
                    child: Icon(
                      Icons.edit_outlined,
                      size: 17,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                InkWell(
                  onTap: () => _deleteHomeSectionDialogCard(
                    item,
                    onDeleted: () {
                      setState(() {});
                      onStateChange?.call();
                    },
                  ),
                  borderRadius: BorderRadius.circular(4),
                  child: const Padding(
                    padding: EdgeInsets.all(3.5),
                    child: Icon(
                      Icons.delete_outline_rounded,
                      size: 17,
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
  }

  void _saveNewHomeSection() {
    final val = _newHomeSectionNameCtrl.text.trim();
    if (val.isNotEmpty) {
      setState(() {
        final existingIndex =
            _homeSectionsList.indexWhere((e) => e["name"] == val);
        if (existingIndex == -1) {
          _homeSectionsList.insert(0, {
            "name": val,
            "priceTabs": _newHomeSectionPriceTabs,
          });
        } else {
          _homeSectionsList[existingIndex]["priceTabs"] =
              _newHomeSectionPriceTabs;
        }
        if (!_selectedHomeSections.contains(val)) {
          _selectedHomeSections.add(val);
        }
        _isAddingHomeSection = false;
        _newHomeSectionNameCtrl.clear();
        _newHomeSectionPriceTabs = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Home Section '$val' added successfully!"),
          backgroundColor: const Color(0xFF059669),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _editHomeSectionDialogCard(Map<String, dynamic> item,
      {VoidCallback? onUpdated}) {
    final oldName = item["name"] as String;
    final editCtrl = TextEditingController(text: oldName);
    bool editPriceTabs = (item["priceTabs"] as bool?) ?? false;

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
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.edit_outlined,
                        color: Color(0xFF64748B), size: 20),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Edit Home Section",
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
                    "Section Name",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF475569),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: editCtrl,
                    style: GoogleFonts.poppins(fontSize: 13.5),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
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
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Price Filter Tabs",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1E293B),
                            ),
                          ),
                          Text(
                            "Show budget tabs",
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                      Switch(
                        value: editPriceTabs,
                        onChanged: (val) {
                          setDialogState(() {
                            editPriceTabs = val;
                          });
                        },
                        activeThumbColor: const Color(0xFF14B8A6),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF64748B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final newName = editCtrl.text.trim();
                    if (newName.isNotEmpty) {
                      setState(() {
                        item["name"] = newName;
                        item["priceTabs"] = editPriceTabs;
                        if (_selectedHomeSections.contains(oldName)) {
                          _selectedHomeSections.remove(oldName);
                          _selectedHomeSections.add(newName);
                        }
                      });
                      onUpdated?.call();
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Updated to '$newName'"),
                          backgroundColor: const Color(0xFF059669),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003366),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
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
      },
    );
  }

  void _deleteHomeSectionDialogCard(Map<String, dynamic> item,
      {VoidCallback? onDeleted}) {
    final name = item["name"] as String;
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: Text(
            "Delete Home Section",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0F172A),
            ),
          ),
          content: Text(
            "Are you sure you want to remove '$name' from Home Sections?",
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
                style: GoogleFonts.poppins(
                  color: const Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _homeSectionsList.remove(item);
                  _selectedHomeSections.remove(name);
                });
                onDeleted?.call();
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Deleted '$name'"),
                    backgroundColor: const Color(0xFFEF4444),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
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

  // -------------------------------------------------------------
  // RTO Rules Methods (Matching Image: media_1795250427655_43ea47ea.png)
  // -------------------------------------------------------------
  String _formatRtoRule(Map<String, dynamic> item) {
    final state = (item["state"] as String? ?? "").trim();
    final maxPrice = item["maxPrice"] as String? ?? "";
    final percentage = item["percentage"] as String? ?? "";
    final prefix = (state.isEmpty || state == "State") ? "" : state;
    return "$prefix: Max ₹$maxPrice ($percentage%)";
  }

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
                    color: Color(0xFFEF4444),
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
                  if (!_rtoRulesExpanded && _selectedRtoRule.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _selectedRtoRule,
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

            // List of RTO Rules (No search bar, exactly as in image)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: _rtoRulesList.length,
              separatorBuilder: (_, __) => const Divider(
                height: 1,
                thickness: 1,
                color: Color(0xFFF1F5F9),
              ),
              itemBuilder: (ctx, i) {
                final item = _rtoRulesList[i];
                return _buildRtoRuleRowItem(item);
              },
            ),

            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),

            // Footer Button: + Add Entry
            InkWell(
              onTap: () {
                setState(() {
                  _isAddingRtoRule = !_isAddingRtoRule;
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
                      : const BorderRadius.vertical(bottom: Radius.circular(10)),
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

            // Inline Add RTO Rule Form (Matching Image: media_1795250427655_43ea47ea.png)
            if (_isAddingRtoRule) ...[
              const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
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

                    // State Dropdown Selector
                    InkWell(
                      onTap: _showStatePickerModal,
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
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
                                Icons.map_outlined,
                                size: 18,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _newRtoState,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: _newRtoState == "State"
                                      ? const Color(0xFF0F172A)
                                      : const Color(0xFF0F172A),
                                  fontWeight: _newRtoState == "State"
                                      ? FontWeight.w500
                                      : FontWeight.w600,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.arrow_drop_down,
                              color: Color(0xFF64748B),
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Max Price Limit Label & Input
                    Text(
                      "Max Price Limit",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(height: 6),
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
                            child: Text(
                              "₹",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _newRtoMaxPriceCtrl,
                              keyboardType: TextInputType.number,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: const Color(0xFF0F172A),
                              ),
                              decoration: InputDecoration(
                                hintText: "Max Price",
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 12,
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

                    const SizedBox(height: 12),

                    // Percentage Label & Input
                    Text(
                      "Percentage",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(height: 6),
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
                            child: Text(
                              "%",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _newRtoPercentageCtrl,
                              keyboardType: const TextInputType.numberWithOptions(
                                  decimal: true),
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: const Color(0xFF0F172A),
                              ),
                              decoration: InputDecoration(
                                hintText: "Percentage",
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: const Color(0xFF94A3B8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              onSubmitted: (_) => _saveNewRtoRule(),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Bottom Buttons: Save & Cancel
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
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isAddingRtoRule = false;
                              _newRtoState = "State";
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

  Widget _buildRtoRuleRowItem(Map<String, dynamic> item) {
    final ruleText = _formatRtoRule(item);
    final isSelected = _selectedRtoRule == ruleText;
    final isHidden = (item["isHidden"] as bool?) ?? false;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedRtoRule = ruleText;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isHidden ? const Color(0xFFF8FAFC) : Colors.transparent,
          border: isHidden
              ? const Border(
                  left: BorderSide(color: Color(0xFF2563EB), width: 3.5),
                )
              : null,
        ),
        padding: EdgeInsets.fromLTRB(
          isHidden ? 10.5 : 14,
          12,
          14,
          12,
        ),
        child: Row(
          children: [
            // Rule Text (e.g. ": Max ₹500,000 (12.00%)")
            Expanded(
              child: Text(
                ruleText,
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isHidden
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF0F172A),
                  decoration:
                      isHidden ? TextDecoration.lineThrough : TextDecoration.none,
                  decorationColor: const Color(0xFF94A3B8),
                ),
              ),
            ),

            // Action Icons (👁️ Toggle Hide, ✏️ Edit, 🗑️ Delete)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      item["isHidden"] = !isHidden;
                    });
                  },
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      isHidden
                          ? Icons.visibility_off_outlined
                          : Icons.remove_red_eye_outlined,
                      size: 18,
                      color: isHidden
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF14B8A6),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                InkWell(
                  onTap: () => _editRtoRuleDialogCard(item),
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.edit_outlined,
                      size: 18,
                      color: isHidden
                          ? const Color(0xFFCBD5E1)
                          : const Color(0xFF94A3B8),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                InkWell(
                  onTap: () => _deleteRtoRuleDialogCard(item),
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.delete_outline_rounded,
                      size: 18,
                      color: isHidden
                          ? const Color(0xFFCBD5E1)
                          : const Color(0xFF94A3B8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showStatePickerModal() {
    final states = [
      "State",
      "Delhi",
      "Maharashtra",
      "Haryana",
      "Uttar Pradesh",
      "Karnataka",
      "Gujarat",
      "Rajasthan",
      "Tamil Nadu",
      "Telangana",
      "West Bengal",
      "Punjab",
      "Kerala",
      "Madhya Pradesh",
      "Bihar",
      "Odisha",
      "Andhra Pradesh",
      "Assam",
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.45,
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Select State",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
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
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.separated(
                  itemCount: states.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (ctx, i) {
                    final s = states[i];
                    final isSel = _newRtoState == s;
                    return ListTile(
                      title: Text(
                        s,
                        style: GoogleFonts.poppins(
                          fontSize: 13.5,
                          fontWeight:
                              isSel ? FontWeight.w600 : FontWeight.normal,
                          color: isSel
                              ? const Color(0xFF2563EB)
                              : const Color(0xFF0F172A),
                        ),
                      ),
                      trailing: isSel
                          ? const Icon(Icons.check,
                              color: Color(0xFF2563EB), size: 18)
                          : null,
                      onTap: () {
                        setState(() {
                          _newRtoState = s;
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

  void _saveNewRtoRule() {
    final maxPrice = _newRtoMaxPriceCtrl.text.trim();
    final percentage = _newRtoPercentageCtrl.text.trim();

    if (maxPrice.isNotEmpty || percentage.isNotEmpty) {
      final state = _newRtoState == "State" ? "" : _newRtoState;
      final newRule = {
        "state": state,
        "maxPrice": maxPrice.isEmpty ? "0" : maxPrice,
        "percentage": percentage.isEmpty ? "0.00" : percentage,
      };
      setState(() {
        _rtoRulesList.insert(0, newRule);
        _selectedRtoRule = _formatRtoRule(newRule);
        _isAddingRtoRule = false;
        _newRtoState = "State";
        _newRtoMaxPriceCtrl.clear();
        _newRtoPercentageCtrl.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("RTO Rule added successfully!"),
          backgroundColor: Color(0xFF059669),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _editRtoRuleDialogCard(Map<String, dynamic> item) {
    String editState = item["state"] as String? ?? "";
    if (editState.isEmpty) editState = "State";
    final priceCtrl =
        TextEditingController(text: item["maxPrice"] as String? ?? "");
    final percentCtrl =
        TextEditingController(text: item["percentage"] as String? ?? "");

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
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.edit_outlined,
                        color: Color(0xFF64748B), size: 20),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Edit RTO Rule",
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
                    "State",
                    style: GoogleFonts.poppins(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF475569),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 42,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: [
                          "State",
                          "Delhi",
                          "Maharashtra",
                          "Haryana",
                          "Uttar Pradesh",
                          "Karnataka",
                          "Gujarat",
                          "Rajasthan",
                          "Tamil Nadu",
                        ].contains(editState)
                            ? editState
                            : "State",
                        isExpanded: true,
                        items: [
                          "State",
                          "Delhi",
                          "Maharashtra",
                          "Haryana",
                          "Uttar Pradesh",
                          "Karnataka",
                          "Gujarat",
                          "Rajasthan",
                          "Tamil Nadu",
                        ].map((s) {
                          return DropdownMenuItem(
                            value: s,
                            child: Text(s,
                                style: GoogleFonts.poppins(fontSize: 13)),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setDialogState(() {
                              editState = val;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Max Price Limit",
                    style: GoogleFonts.poppins(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF475569),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: priceCtrl,
                    keyboardType: TextInputType.number,
                    style: GoogleFonts.poppins(fontSize: 13),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Percentage",
                    style: GoogleFonts.poppins(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF475569),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: percentCtrl,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    style: GoogleFonts.poppins(fontSize: 13),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF64748B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final newPrice = priceCtrl.text.trim();
                    final newPercent = percentCtrl.text.trim();
                    setState(() {
                      item["state"] = editState == "State" ? "" : editState;
                      if (newPrice.isNotEmpty) {
                        item["maxPrice"] = newPrice;
                      }
                      if (newPercent.isNotEmpty) {
                        item["percentage"] = newPercent;
                      }
                      _selectedRtoRule = _formatRtoRule(item);
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("RTO Rule updated!"),
                        backgroundColor: Color(0xFF059669),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003366),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
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
      },
    );
  }

  void _deleteRtoRuleDialogCard(Map<String, dynamic> item) {
    final ruleText = _formatRtoRule(item);
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: Text(
            "Delete RTO Rule",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0F172A),
            ),
          ),
          content: Text(
            "Are you sure you want to remove rule \"$ruleText\"?",
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
                style: GoogleFonts.poppins(
                  color: const Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _rtoRulesList.remove(item);
                  if (_selectedRtoRule == ruleText) {
                    _selectedRtoRule = _rtoRulesList.isNotEmpty
                        ? _formatRtoRule(_rtoRulesList.first)
                        : "";
                  }
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("RTO Rule deleted"),
                    backgroundColor: Color(0xFFEF4444),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
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

  // -------------------------------------------------------------
  // TCS Rules Methods (Matching Image: media_1795251494893_a7a37d5e.png)
  // -------------------------------------------------------------
  String _formatTcsRule(Map<String, dynamic> item) {
    final abovePrice = item["abovePrice"] as String? ?? "";
    final percentage = item["percentage"] as String? ?? "";
    return "Above ₹$abovePrice @ $percentage%";
  }

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
                    Icons.percent_rounded,
                    color: Color(0xFF06B6D4),
                    size: 18,
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
                  if (!_tcsRulesExpanded && _selectedTcsRule.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _selectedTcsRule,
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

            // List of TCS Rules (No search bar, exactly as in image)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: _tcsRulesList.length,
              separatorBuilder: (_, __) => const Divider(
                height: 1,
                thickness: 1,
                color: Color(0xFFF1F5F9),
              ),
              itemBuilder: (ctx, i) {
                final item = _tcsRulesList[i];
                return _buildTcsRuleRowItem(item);
              },
            ),

            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),

            // Footer Button: + Add Entry
            InkWell(
              onTap: () {
                setState(() {
                  _isAddingTcsRule = !_isAddingTcsRule;
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
                      : const BorderRadius.vertical(bottom: Radius.circular(10)),
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

            // Inline Add TCS Rule Form (Matching Image: media_1795251494893_a7a37d5e.png)
            if (_isAddingTcsRule) ...[
              const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title: Add TCS Rule Above Price
                    Row(
                      children: [
                        Text(
                          "Add TCS Rule ",
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
                            child: Text(
                              "₹",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _newTcsAbovePriceCtrl,
                              keyboardType: TextInputType.number,
                              autofocus: true,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: const Color(0xFF0F172A),
                              ),
                              decoration: InputDecoration(
                                hintText: "Above Price",
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 12,
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

                    const SizedBox(height: 12),

                    // Percentage Label & Input
                    Text(
                      "Percentage",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(height: 6),
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
                            child: Text(
                              "%",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _newTcsPercentageCtrl,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: const Color(0xFF0F172A),
                              ),
                              decoration: InputDecoration(
                                hintText: "Percentage",
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: const Color(0xFF94A3B8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              onSubmitted: (_) => _saveNewTcsRule(),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Bottom Buttons: Save & Cancel
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
                              fontWeight: FontWeight.bold,
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

  Widget _buildTcsRuleRowItem(Map<String, dynamic> item) {
    final ruleText = _formatTcsRule(item);
    final isSelected = _selectedTcsRule == ruleText;
    final isHidden = (item["isHidden"] as bool?) ?? false;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedTcsRule = ruleText;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isHidden ? const Color(0xFFF8FAFC) : Colors.transparent,
          border: isHidden
              ? const Border(
                  left: BorderSide(color: Color(0xFF2563EB), width: 3.5),
                )
              : null,
        ),
        padding: EdgeInsets.fromLTRB(
          isHidden ? 10.5 : 14,
          12,
          14,
          12,
        ),
        child: Row(
          children: [
            // Rule Text (e.g. "Above ₹500,000 @ 12.00%")
            Expanded(
              child: Text(
                ruleText,
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isHidden
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF0F172A),
                  decoration:
                      isHidden ? TextDecoration.lineThrough : TextDecoration.none,
                  decorationColor: const Color(0xFF94A3B8),
                ),
              ),
            ),

            // Action Icons (👁️ Toggle Hide, ✏️ Edit, 🗑️ Delete)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      item["isHidden"] = !isHidden;
                    });
                  },
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      isHidden
                          ? Icons.visibility_off_outlined
                          : Icons.remove_red_eye_outlined,
                      size: 18,
                      color: isHidden
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF14B8A6),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                InkWell(
                  onTap: () => _editTcsRuleDialogCard(item),
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.edit_outlined,
                      size: 18,
                      color: isHidden
                          ? const Color(0xFFCBD5E1)
                          : const Color(0xFF94A3B8),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                InkWell(
                  onTap: () => _deleteTcsRuleDialogCard(item),
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.delete_outline_rounded,
                      size: 18,
                      color: isHidden
                          ? const Color(0xFFCBD5E1)
                          : const Color(0xFF94A3B8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _saveNewTcsRule() {
    final abovePrice = _newTcsAbovePriceCtrl.text.trim();
    final percentage = _newTcsPercentageCtrl.text.trim();

    if (abovePrice.isNotEmpty || percentage.isNotEmpty) {
      final newRule = {
        "abovePrice": abovePrice.isEmpty ? "0" : abovePrice,
        "percentage": percentage.isEmpty ? "0.00" : percentage,
      };
      setState(() {
        _tcsRulesList.insert(0, newRule);
        _selectedTcsRule = _formatTcsRule(newRule);
        _isAddingTcsRule = false;
        _newTcsAbovePriceCtrl.clear();
        _newTcsPercentageCtrl.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("TCS Rule added successfully!"),
          backgroundColor: Color(0xFF059669),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _editTcsRuleDialogCard(Map<String, dynamic> item) {
    final priceCtrl =
        TextEditingController(text: item["abovePrice"] as String? ?? "");
    final percentCtrl =
        TextEditingController(text: item["percentage"] as String? ?? "");

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
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.edit_outlined,
                    color: Color(0xFF64748B), size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                "Edit TCS Rule",
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
                "Above Price",
                style: GoogleFonts.poppins(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: priceCtrl,
                keyboardType: TextInputType.number,
                style: GoogleFonts.poppins(fontSize: 13),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Percentage",
                style: GoogleFonts.poppins(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: percentCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                style: GoogleFonts.poppins(fontSize: 13),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                "Cancel",
                style: GoogleFonts.poppins(
                  color: const Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final newPrice = priceCtrl.text.trim();
                final newPercent = percentCtrl.text.trim();
                setState(() {
                  if (newPrice.isNotEmpty) {
                    item["abovePrice"] = newPrice;
                  }
                  if (newPercent.isNotEmpty) {
                    item["percentage"] = newPercent;
                  }
                  _selectedTcsRule = _formatTcsRule(item);
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("TCS Rule updated!"),
                    backgroundColor: Color(0xFF059669),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003366),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
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

  void _deleteTcsRuleDialogCard(Map<String, dynamic> item) {
    final ruleText = _formatTcsRule(item);
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: Text(
            "Delete TCS Rule",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0F172A),
            ),
          ),
          content: Text(
            "Are you sure you want to remove rule \"$ruleText\"?",
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
                style: GoogleFonts.poppins(
                  color: const Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _tcsRulesList.remove(item);
                  if (_selectedTcsRule == ruleText) {
                    _selectedTcsRule = _tcsRulesList.isNotEmpty
                        ? _formatTcsRule(_tcsRulesList.first)
                        : "";
                  }
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("TCS Rule deleted"),
                    backgroundColor: Color(0xFFEF4444),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
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
                        final item = _homeSectionsList[i];
                        final section = item["name"] as String;
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
                    final ruleText = _formatRtoRule(item);
                    final isSelected = _selectedRtoRule == ruleText;
                    return ListTile(
                      title: Text(
                        ruleText,
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
                          _selectedRtoRule = ruleText;
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
                    final ruleText = _formatTcsRule(item);
                    final isSelected = _selectedTcsRule == ruleText;
                    return ListTile(
                      title: Text(
                        ruleText,
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
                          _selectedTcsRule = ruleText;
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
                        final isHidden = _hiddenFeatures.contains(feature);
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
                                    side: BorderSide(
                                      color: isHidden
                                          ? const Color(0xFFCBD5E1)
                                          : const Color(0xFF94A3B8),
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
                                      color: isHidden
                                          ? const Color(0xFF94A3B8)
                                          : const Color(0xFF0F172A),
                                      decoration: isHidden
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                      decorationColor: const Color(0xFF94A3B8),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),

                                // Action Buttons: Eye, Edit, Delete
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // 1. Eye (Toggle Hide)
                                    InkWell(
                                      onTap: () {
                                        setModalState(() {
                                          if (_hiddenFeatures.contains(feature)) {
                                            _hiddenFeatures.remove(feature);
                                          } else {
                                            _hiddenFeatures.add(feature);
                                          }
                                        });
                                        setState(() {});
                                      },
                                      borderRadius: BorderRadius.circular(6),
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: isHidden
                                              ? const Color(0xFFF1F5F9)
                                              : const Color(0xFFEFF6FF),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Icon(
                                          isHidden
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_outlined,
                                          size: 16,
                                          color: isHidden
                                              ? const Color(0xFF94A3B8)
                                              : const Color(0xFF2563EB),
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
