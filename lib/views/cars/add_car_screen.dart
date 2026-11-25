import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/admin_profile_avatar.dart';


part 'add_car_manufacturer_model_part.dart';
part 'add_car_body_color_part.dart';
part 'add_car_sections_rules_part.dart';
part 'add_car_features_media_seo_part.dart';

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
  String _location = "VAAHAN BAZA â€“ NITIN KHATRI";
  String _homepageVisibility = "Show";
  String _scheduleOption = "Immediately";
  final List<String> _publishingOptions = [
    "Published",
    "Draft",
    "Inactive",
    "Pending",
  ];
  bool _isEditingLocation = false;
  String _selectedLocationWithId = "VAAHAN BAZA â€“ NITIN KHATRI [#187]";
  final List<String> _locationOptions = [
    "VAAHAN BAZA â€“ NITIN KHATRI [#187]",
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
  String _selectedRtoRule = "Gujarat: Max â‚¹500,000 (12.00%)";
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
  String _selectedTcsRule = "Above â‚¹500,000 @ 12.00%";
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
    {"name": "Budget Friendly (< â‚¹5 Lakhs)", "hasPriceTabs": true},
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
                    label: "Asking price (â‚¹) *",
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

}
