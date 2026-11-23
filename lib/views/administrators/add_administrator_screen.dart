import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/administrator_meta_model.dart';
import '../../models/administrator_model.dart';
import '../../models/crm_role_model.dart';
import '../../viewmodels/administrators_viewmodel.dart';

class AddAdministratorScreen extends StatefulWidget {
  const AddAdministratorScreen({super.key});

  @override
  State<AddAdministratorScreen> createState() => _AddAdministratorScreenState();
}

class _AddAdministratorScreenState extends State<AddAdministratorScreen> {
  int _currentStep = 0;
  final PageController _pageController = PageController();

  // 1. Account & Contact Controllers
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _altPhoneController = TextEditingController();
  final _dobController = TextEditingController();
  final _jobLocationController = TextEditingController();
  String _selectedGender = "Male";
  bool _obscurePassword = true;

  // Role, Hierarchy & Limit
  MetaRoleOption? _selectedRole;
  AdministratorItem? _selectedParent;
  final _maxLeadsController = TextEditingController();
  bool _isActive = true;
  String? _profilePhotoPath;

  // 2. Bank Details & Address
  final _ifscController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _branchController = TextEditingController();
  final _accountNumberController = TextEditingController();
  bool _ifscVerified = false;

  final _pincodeController = TextEditingController();
  MetaStateOption? _selectedState;
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();

  // 3. Documents (KYC)
  bool _aadharUploaded = false;
  bool _panUploaded = false;
  bool _passbookUploaded = false;
  final List<String> _extraDocuments = [];

  // 4. Outward Payout Matrix (Bank x Loan Category Rates)
  // Map<BankId, Map<CategoryCode, TextEditingController>>
  final Map<int, Map<String, TextEditingController>> _payoutControllers = {};

  // 5. Modular Access Matrix
  // Map<ModuleId, Map<PermissionKey, bool>>
  final Map<int, Map<String, bool>> _modulePermissions = {};
  final Set<int> _expandedModuleIds = {};
  int _selectedAccessSection = 0; // 0 = Business Modules, 1 = Lead Pipeline
  String _moduleSearchQuery = "";

  // Leads Status & Modular Access
  String _selectedLeadModule = "BT Topup Enquiries";
  final List<String> _leadModulesList = [
    "BT Topup Enquiries",
    "Used Car Loan",
    "New Car Loan",
    "Car Loan Refinance",
    "Personal Loan",
    "Business Loan",
    "Home Loan",
    "Loan Against Property"
  ];

  final List<String> _leadStatuses = [
    "New Lead",
    "Contact Established",
    "Follow Up",
    "Pick Up",
    "Doc Received",
    "Sent to Bank",
    "Login",
    "Rejected",
    "Approved",
    "Disbursal Stage",
    "Disbursed",
    "RTO Process(RTO Person)",
    "RTO Done",
    "Payment Requested",
    "Payment in Process",
    "Payment Done(Accounts)",
    "Accounts",
    "Vehicle Handover",
    "PDD Pending",
    "PDD Submitted",
    "Case Completed",
    "Case Cancelled",
    "Case Cancellation",
  ];

  final Map<String, Map<String, bool>> _leadStatusPermissions = {};

  @override
  void initState() {
    super.initState();

    // Listeners for real-time live preview
    _nameController.addListener(() => setState(() {}));
    _usernameController.addListener(() => setState(() {}));
    _emailController.addListener(() => setState(() {}));
    _phoneController.addListener(() => setState(() {}));
    _passwordController.addListener(() => setState(() {}));

    // Initialize Lead Status Permissions
    for (var s in _leadStatuses) {
      _leadStatusPermissions[s] = {
        'view': false,
        'add': false,
        'edit': false,
        'delete': false,
        'status': false,
        'availability': false,
        'assign': false,
      };
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<AdministratorsViewModel>();
      if (vm.metaOptions == null) {
        vm.fetchMetaOptions();
      }
      if (vm.administrators.isEmpty) {
        vm.fetchAdministrators();
      }
      if (vm.roles.isEmpty) {
        vm.fetchRoles();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _altPhoneController.dispose();
    _dobController.dispose();
    _jobLocationController.dispose();
    _maxLeadsController.dispose();
    _ifscController.dispose();
    _bankNameController.dispose();
    _branchController.dispose();
    _accountNumberController.dispose();
    _pincodeController.dispose();
    _cityController.dispose();
    _addressController.dispose();

    for (var bMap in _payoutControllers.values) {
      for (var c in bMap.values) {
        c.dispose();
      }
    }
    super.dispose();
  }

  // --- FinTech Smart Auto-Fill Handlers ---

  void _onIfscChanged(String val, List<MetaBankOption> banks) {
    final code = val.trim().toUpperCase();
    if (code.length >= 4) {
      String detectedBank = "";
      if (code.startsWith("HDFC")) {
        detectedBank = "HDFC Bank";
      } else if (code.startsWith("ICIC")) {
        detectedBank = "ICICI Bank";
      } else if (code.startsWith("SBIN")) {
        detectedBank = "SBI Bank";
      } else if (code.startsWith("UTIB")) {
        detectedBank = "Axis Bank";
      } else if (code.startsWith("KKBK")) {
        detectedBank = "Kotak Mahindra Bank";
      } else if (code.startsWith("AUBK")) {
        detectedBank = "AU Small Bank";
      } else if (code.startsWith("PUNB")) {
        detectedBank = "Punjab National Bank";
      }

      if (detectedBank.isNotEmpty) {
        setState(() {
          _bankNameController.text = detectedBank;
          _ifscVerified = code.length == 11;
          if (_branchController.text.isEmpty && code.length >= 7) {
            _branchController.text = "Branch #${code.substring(code.length - 4)}";
          }
        });
      }
    } else {
      if (_ifscVerified) {
        setState(() => _ifscVerified = false);
      }
    }
  }

  void _onPincodeChanged(String val, List<MetaStateOption> states) {
    if (val.trim().length == 6) {
      // Smart Auto-detection based on Indian Pincode zones
      final prefix = int.tryParse(val.substring(0, 2)) ?? 0;
      MetaStateOption? matchedState;

      if (prefix == 11) {
        matchedState = states.where((s) => s.stateName.toLowerCase().contains("delhi")).firstOrNull;
        if (_cityController.text.isEmpty) _cityController.text = "New Delhi";
      } else if (prefix >= 20 && prefix <= 28) {
        matchedState = states.where((s) => s.stateName.toLowerCase().contains("uttar pradesh")).firstOrNull;
        if (_cityController.text.isEmpty) _cityController.text = prefix == 24 ? "Saharanpur" : "Noida";
      } else if (prefix >= 24 && prefix <= 26) {
        matchedState = states.where((s) => s.stateName.toLowerCase().contains("uttaranchal") || s.stateName.toLowerCase().contains("uttarakhand")).firstOrNull;
        if (_cityController.text.isEmpty) _cityController.text = "Dehradun";
      } else if (prefix >= 30 && prefix <= 34) {
        matchedState = states.where((s) => s.stateName.toLowerCase().contains("rajasthan")).firstOrNull;
        if (_cityController.text.isEmpty) _cityController.text = "Jaipur";
      } else if (prefix >= 40 && prefix <= 44) {
        matchedState = states.where((s) => s.stateName.toLowerCase().contains("maharashtra")).firstOrNull;
        if (_cityController.text.isEmpty) _cityController.text = "Mumbai";
      }

      if (matchedState != null) {
        setState(() => _selectedState = matchedState);
        HapticFeedback.lightImpact();
      }
    }
  }

  void _generateRandomPassword() {
    const chars = "abcdefghjkmnpqrstuvwxyzABCDEFGHJKMNPQRSTUVWXYZ23456789@#\$";
    final rnd = Random();
    final pwd = List.generate(8, (_) => chars[rnd.nextInt(chars.length)]).join();
    setState(() {
      _passwordController.text = "Fmc@$pwd";
      _obscurePassword = false;
    });

    HapticFeedback.mediumImpact();
    Clipboard.setData(ClipboardData(text: _passwordController.text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.bolt, color: Colors.amber, size: 20),
            const SizedBox(width: 8),
            Text("Auto-generated & copied: ${_passwordController.text}", style: GoogleFonts.poppins()),
          ],
        ),
        backgroundColor: const Color(0xFF003366),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1996, 1, 1),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF003366),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1E293B),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dobController.text =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  // --- 1-Tap Outward Payout Presets ---
  void _applyStandardPayoutRates(List<MetaBankOption> banks, List<MetaCategoryOption> categories) {
    // Standard FMC Market rates
    final defaults = {
      'USED_CAR_LOAN': '1.50',
      'NEW_CAR_LOAN': '0.75',
      'BT_TOPUP_LOAN': '1.25',
      'CAR_LOAN_REFINANCE': '1.50',
      'PERSONAL_LOAN': '1.00',
    };

    setState(() {
      for (var bank in banks) {
        _payoutControllers.putIfAbsent(bank.id, () => {});
        final bMap = _payoutControllers[bank.id]!;

        for (var cat in categories) {
          bMap.putIfAbsent(cat.code, () => TextEditingController());
          bMap[cat.code]!.text = defaults[cat.code] ?? "1.00";
        }
      }
    });

    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Standard 1.5% FMC rates applied across all banks!", style: GoogleFonts.poppins()),
        backgroundColor: const Color(0xFF0284C7),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // --- 1-Tap Permission Templates ---
  void _applyPermissionTemplate(String template, List<MetaModuleOption> modules) {
    setState(() {
      for (var m in modules) {
        _modulePermissions.putIfAbsent(m.id, () => {});
        final perms = _modulePermissions[m.id]!;

        if (template == "Full Admin") {
          perms['view'] = true;
          perms['add'] = true;
          perms['edit'] = true;
          perms['delete'] = true;
          perms['status'] = true;
          perms['assign'] = true;
        } else if (template == "Sales Team") {
          final isSalesMod = m.name.toLowerCase().contains("car") ||
              m.name.toLowerCase().contains("loan") ||
              m.name.toLowerCase().contains("contact") ||
              m.name.toLowerCase().contains("enquir") ||
              m.name.toLowerCase().contains("insurance");
          perms['view'] = isSalesMod;
          perms['add'] = isSalesMod;
          perms['edit'] = isSalesMod;
          perms['delete'] = false;
          perms['status'] = isSalesMod;
          perms['assign'] = isSalesMod;
        } else if (template == "View Only") {
          perms['view'] = true;
          perms['add'] = false;
          perms['edit'] = false;
          perms['delete'] = false;
          perms['status'] = false;
          perms['assign'] = false;
        } else if (template == "Reset") {
          perms['view'] = false;
          perms['add'] = false;
          perms['edit'] = false;
          perms['delete'] = false;
          perms['status'] = false;
          perms['assign'] = false;
        }
      }

      for (var s in _leadStatuses) {
        _leadStatusPermissions.putIfAbsent(s, () => {});
        final sPerms = _leadStatusPermissions[s]!;
        if (template == "Full Admin") {
          sPerms['view'] = true;
          sPerms['add'] = true;
          sPerms['edit'] = true;
          sPerms['delete'] = true;
          sPerms['status'] = true;
          sPerms['assign'] = true;
        } else if (template == "Sales Team") {
          sPerms['view'] = true;
          sPerms['add'] = true;
          sPerms['edit'] = true;
          sPerms['delete'] = false;
          sPerms['status'] = true;
          sPerms['assign'] = true;
        } else if (template == "View Only") {
          sPerms['view'] = true;
          sPerms['add'] = false;
          sPerms['edit'] = false;
          sPerms['delete'] = false;
          sPerms['status'] = false;
          sPerms['assign'] = false;
        } else if (template == "Reset") {
          sPerms['view'] = false;
          sPerms['add'] = false;
          sPerms['edit'] = false;
          sPerms['delete'] = false;
          sPerms['status'] = false;
          sPerms['assign'] = false;
        }
      }
    });

    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Template '$template' applied across all modules & pipeline stages!", style: GoogleFonts.poppins()),
        backgroundColor: const Color(0xFF003366),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openUploadSourceModal(String docType) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Upload $docType",
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
              ),
              const SizedBox(height: 6),
              Text(
                "Choose a source to attach official verified document",
                style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF64748B)),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: const Color(0xFF003366).withOpacity(0.08), shape: BoxShape.circle),
                  child: const Icon(Icons.camera_alt_outlined, color: Color(0xFF003366)),
                ),
                title: Text("Take Photo with Camera", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(ctx);
                  _setDocUploaded(docType);
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: const Color(0xFF10B981).withOpacity(0.12), shape: BoxShape.circle),
                  child: const Icon(Icons.photo_library_outlined, color: Color(0xFF10B981)),
                ),
                title: Text("Choose from Phone Gallery / Files", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(ctx);
                  _setDocUploaded(docType);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _setDocUploaded(String docType) {
    setState(() {
      if (docType == "Aadhar Card") {
        _aadharUploaded = true;
      } else if (docType == "PAN Card") {
        _panUploaded = true;
      } else if (docType == "Bank Passbook") {
        _passbookUploaded = true;
      } else if (docType == "Profile Photo") {
        _profilePhotoPath = "assets/images/app_logo.png";
      }
    });
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$docType verified & attached!", style: GoogleFonts.poppins()),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  bool _validateStep1() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter Full Name to proceed", style: GoogleFonts.poppins()),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }

    if (_usernameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter Username to proceed", style: GoogleFonts.poppins()),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }

    if (_phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter Phone Number to proceed", style: GoogleFonts.poppins()),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }

    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please select a Role / Designation to proceed", style: GoogleFonts.poppins()),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }

    return true;
  }

  void _goToStep(int step) {
    if (step < 0 || step > 4) return;
    if (step > _currentStep && _currentStep == 0) {
      if (!_validateStep1()) return;
    }
    setState(() => _currentStep = step);
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeInOutCubic,
    );
  }

  void _submitAdministrator() async {
    if (!_validateStep1()) {
      _goToStep(0);
      return;
    }

    final vm = context.read<AdministratorsViewModel>();

    // Prepare Payout Rates payload
    final Map<String, dynamic> payoutRates = {};
    _payoutControllers.forEach((bankId, catMap) {
      catMap.forEach((catCode, ctrl) {
        if (ctrl.text.trim().isNotEmpty) {
          payoutRates["${bankId}_$catCode"] = ctrl.text.trim();
        }
      });
    });

    final payload = {
      'full_name': _nameController.text.trim(),
      'username': _usernameController.text.trim(),
      'email': _emailController.text.trim(),
      'password': _passwordController.text.trim(),
      'phone': _phoneController.text.trim(),
      if (_altPhoneController.text.trim().isNotEmpty)
        'alt_phone': _altPhoneController.text.trim(),
      if (_dobController.text.trim().isNotEmpty)
        'dob': _dobController.text.trim(),
      'gender': _selectedGender,
      if (_jobLocationController.text.trim().isNotEmpty)
        'job_location': _jobLocationController.text.trim(),
      'role_id': _selectedRole?.id,
      if (_selectedParent != null) 'parent_id': _selectedParent!.id,
      if (_maxLeadsController.text.trim().isNotEmpty)
        'lead_view_limit': int.tryParse(_maxLeadsController.text.trim()),
      'status': _isActive ? 1 : 0,

      // Bank Details
      if (_ifscController.text.trim().isNotEmpty) 'ifsc_code': _ifscController.text.trim(),
      if (_bankNameController.text.trim().isNotEmpty) 'bank_name': _bankNameController.text.trim(),
      if (_branchController.text.trim().isNotEmpty) 'branch_name': _branchController.text.trim(),
      if (_accountNumberController.text.trim().isNotEmpty) 'account_number': _accountNumberController.text.trim(),

      // Address Details
      if (_pincodeController.text.trim().isNotEmpty) 'pincode': _pincodeController.text.trim(),
      if (_selectedState != null) 'state_id': _selectedState!.id,
      if (_cityController.text.trim().isNotEmpty) 'city': _cityController.text.trim(),
      if (_addressController.text.trim().isNotEmpty) 'full_address': _addressController.text.trim(),

      // KYC
      'aadhar_uploaded': _aadharUploaded,
      'pan_uploaded': _panUploaded,
      'passbook_uploaded': _passbookUploaded,

      // Payout & Permissions
      'outward_payout_rates': payoutRates,
      'modular_access': _modulePermissions,
      'lead_status_modular_access': {
        _selectedLeadModule: _leadStatusPermissions,
      },
    };

    final success = await vm.createAdministrator(payload);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Administrator published successfully!", style: GoogleFonts.poppins()),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(vm.errorMessage ?? "Failed to publish administrator", style: GoogleFonts.poppins()),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // Step Completion Checkers
  bool get _isStep1Complete =>
      _nameController.text.trim().isNotEmpty &&
      _usernameController.text.trim().isNotEmpty &&
      _selectedRole != null &&
      _phoneController.text.trim().isNotEmpty;

  bool get _isStep2Complete =>
      _ifscController.text.trim().isNotEmpty ||
      _bankNameController.text.trim().isNotEmpty ||
      _cityController.text.trim().isNotEmpty;

  int get _uploadedDocsCount =>
      (_aadharUploaded ? 1 : 0) + (_panUploaded ? 1 : 0) + (_passbookUploaded ? 1 : 0);

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AdministratorsViewModel>();
    final meta = vm.metaOptions;
    final admins = vm.administrators;

    return PopScope(
      canPop: _currentStep == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_currentStep > 0) {
          _goToStep(_currentStep - 1);
        } else {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          title: Text(
            "Add Administrator",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              fontSize: 17,
              color: const Color(0xFF0F172A),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Color(0xFF0F172A)),
            onPressed: () {
              if (_currentStep > 0) {
                _goToStep(_currentStep - 1);
              } else {
                Navigator.pop(context);
              }
            },
          ),
          backgroundColor: Colors.white,
          elevation: 0.5,
          actions: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF003366).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                "Step ${_currentStep + 1} of 5",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                  color: const Color(0xFF003366),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // 🧭 Premium Interactive Multi-Step Stepper Header
            _buildStepIndicatorHeader(),

            // 👤 Compact Profile Header for Steps 2 to 5
            if (_currentStep > 0) _buildMiniProfileHeader(),

            // 📄 Step-by-Step Page View
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Column(
                    children: [
                      // Live Staff ID Card Preview on Step 1
                      _buildLiveStaffIdBadge(),
                      Expanded(child: _buildTab1AccountAndContact(meta, admins)),
                    ],
                  ),
                  _buildTab2BankAndAddress(meta),
                  _buildTab3Documents(),
                  _buildTab4OutwardPayout(meta),
                  _buildTab5ModularAccess(meta),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: _buildBottomStickyBar(vm),
      ),
    );
  }

  // ==========================================
  // 🧭 Stepper Indicator Header
  // ==========================================
  Widget _buildStepIndicatorHeader() {
    final stepTitles = [
      "Account & Role",
      "Bank & Address",
      "KYC Documents",
      "Outward Payout",
      "Modular Access",
    ];

    final stepShortTitles = [
      "Account",
      "Bank",
      "Docs",
      "Payout",
      "Access",
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Step ${_currentStep + 1}: ${stepTitles[_currentStep]}",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                ),
              ),
              Text(
                "${((_currentStep + 1) * 20)}% Completed",
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF10B981),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(5, (index) {
              final isCompleted = index < _currentStep ||
                  (index == 0 && _isStep1Complete && index != _currentStep) ||
                  (index == 1 && _isStep2Complete && index != _currentStep) ||
                  (index == 2 && _uploadedDocsCount > 0 && index != _currentStep);
              final isCurrent = index == _currentStep;

              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (index <= _currentStep || _validateStep1()) {
                            _goToStep(index);
                          }
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isCompleted
                                    ? const Color(0xFF10B981)
                                    : isCurrent
                                        ? const Color(0xFF003366)
                                        : const Color(0xFFF1F5F9),
                                border: Border.all(
                                  color: isCurrent
                                      ? const Color(0xFF003366)
                                      : isCompleted
                                          ? const Color(0xFF10B981)
                                          : const Color(0xFFCBD5E1),
                                  width: isCurrent ? 2 : 1,
                                ),
                                boxShadow: isCurrent
                                    ? [
                                        BoxShadow(
                                          color: const Color(0xFF003366).withValues(alpha: 0.25),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              alignment: Alignment.center,
                              child: isCompleted
                                  ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                                  : Text(
                                      "${index + 1}",
                                      style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: isCurrent
                                            ? Colors.white
                                            : const Color(0xFF64748B),
                                      ),
                                    ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              stepShortTitles[index],
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                                color: isCurrent
                                    ? const Color(0xFF003366)
                                    : isCompleted
                                        ? const Color(0xFF10B981)
                                        : const Color(0xFF94A3B8),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (index < 4)
                      Container(
                        width: 12,
                        height: 2,
                        margin: const EdgeInsets.only(bottom: 16),
                        color: isCompleted
                            ? const Color(0xFF10B981)
                            : const Color(0xFFE2E8F0),
                      ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 👤 Mini Profile Header for Steps 2 to 5
  // ==========================================
  Widget _buildMiniProfileHeader() {
    final name = _nameController.text.trim();
    final username = _usernameController.text.trim();
    final role = _selectedRole?.name ?? "Role Pending";

    if (name.isEmpty && username.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: const Color(0xFF003366),
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : "U",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name.isNotEmpty ? name : "Staff Member",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "${username.isNotEmpty ? '@$username • ' : ''}$role",
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: const Color(0xFF64748B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: _isActive
                  ? const Color(0xFF10B981).withValues(alpha: 0.1)
                  : const Color(0xFFEF4444).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _isActive ? "ACTIVE" : "INACTIVE",
              style: GoogleFonts.poppins(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: _isActive ? const Color(0xFF10B981) : const Color(0xFFEF4444),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 🔘 Bottom Sticky Action Bar
  // ==========================================
  Widget _buildBottomStickyBar(AdministratorsViewModel vm) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentStep > 0) ...[
              Expanded(
                flex: 1,
                child: OutlinedButton.icon(
                  onPressed: vm.isCreating ? null : () => _goToStep(_currentStep - 1),
                  icon: const Icon(Icons.arrow_back_rounded, size: 16, color: Color(0xFF003366)),
                  label: Text(
                    "Back",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: const Color(0xFF003366),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: vm.isCreating
                    ? null
                    : () {
                        if (_currentStep < 4) {
                          _goToStep(_currentStep + 1);
                        } else {
                          _submitAdministrator();
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003366),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  elevation: 0,
                ),
                child: vm.isCreating
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentStep == 4 ? "Publish Administrator 🚀" : "Continue to Step ${_currentStep + 2}",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                          if (_currentStep < 4) ...[
                            const SizedBox(width: 6),
                            const Icon(Icons.arrow_forward_rounded, size: 16, color: Colors.white),
                          ],
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 🪪 Live "Staff ID Badge" Real-Time Preview
  // ==========================================
  Widget _buildLiveStaffIdBadge() {
    final displayName = _nameController.text.trim().isNotEmpty ? _nameController.text.trim() : "Staff Member Name";
    final displayRole = _selectedRole?.name ?? "Designation Pending";
    final displayUser = _usernameController.text.trim().isNotEmpty ? "@${_usernameController.text.trim()}" : "@username";
    final initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : "A";

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF003366), Color(0xFF0A4F9E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF003366).withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white,
            backgroundImage: _profilePhotoPath != null ? AssetImage(_profilePhotoPath!) : null,
            child: _profilePhotoPath == null
                ? Text(
                    initial,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF003366),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        displayName,
                        style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _isActive ? const Color(0xFF10B981) : Colors.redAccent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _isActive ? "ACTIVE" : "INACTIVE",
                        style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Text(
                  "$displayUser • Find My Carz CRM",
                  style: GoogleFonts.poppins(fontSize: 11, color: Colors.white70),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    displayRole,
                    style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 🏢 Dynamic Potential Managers Finder
  // ==========================================
  List<AdministratorItem> _getPotentialManagers(AdministratorsViewModel vm) {
    if (_selectedRole == null) return [];

    // Find the role in vm.roles to check parent_id or parent_name
    CrmRoleItem? roleMatch;
    for (final r in vm.roles) {
      if (r.id == _selectedRole!.id || r.code.toLowerCase() == _selectedRole!.code.toLowerCase()) {
        roleMatch = r;
        break;
      }
    }

    final parentRoleId = roleMatch?.parentId ?? 0;
    final parentRoleName = roleMatch?.parentName?.toLowerCase().trim();
    final allAdmins = vm.administrators.where((a) => a.status == 1).toList();

    // 1. Direct match with configured parent role in CRM hierarchy
    if (parentRoleId > 0 || (parentRoleName != null && parentRoleName.isNotEmpty)) {
      final directMatches = allAdmins.where((a) {
        if (a.role == null) return false;
        if (parentRoleId > 0 && a.role!.id == parentRoleId) return true;
        if (parentRoleName != null && a.role!.name.toLowerCase().contains(parentRoleName)) return true;
        return false;
      }).toList();

      if (directMatches.isNotEmpty) {
        return directMatches;
      }
    }

    // 2. Hierarchical Senior Administrators (Super Admin, CEO, TL, ZSM, Area Sales Managers)
    final seniorManagers = allAdmins.where((a) {
      if (a.role == null) return false;
      final rName = a.role!.name.toLowerCase();
      final rCode = a.role!.code.toLowerCase();
      final isSenior = rName.contains('ceo') ||
          rName.contains('super admin') ||
          rName.contains('zonal') ||
          rName.contains('sales manager') ||
          rName.contains('tele sales') ||
          rName.contains('team leader') ||
          rName.contains('tl') ||
          rName.contains('area') ||
          rCode.contains('sm') ||
          rCode.contains('tl') ||
          rCode.contains('afd') ||
          a.id == 5 || // Mohammad Aman
          a.id == 69 || // Nitish Bhardwaj (CEO)
          a.id == 80; // Tayyab Ali

      // Exclude Dealers or lower-level tele caller staff
      final isDealer = rName.contains('dealer') || rCode == 'd';
      return isSenior && !isDealer;
    }).toList();

    return seniorManagers.isNotEmpty ? seniorManagers.take(3).toList() : allAdmins.take(3).toList();
  }

  // ==========================================
  // TAB 1: Account, Contact, Role & Limit
  // ==========================================
  Widget _buildTab1AccountAndContact(AdministratorMetaModel? meta, List<AdministratorItem> admins) {
    final roles = meta?.roles ?? [];
    final vm = context.watch<AdministratorsViewModel>();
    final potentialManagers = _getPotentialManagers(vm);
    final managersToShow = potentialManagers.isNotEmpty ? potentialManagers : admins;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Image Picker
          Center(
            child: Column(
              children: [
                InkWell(
                  onTap: () => _openUploadSourceModal("Profile Photo"),
                  borderRadius: BorderRadius.circular(45),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF003366), width: 1.5),
                    ),
                    child: _profilePhotoPath != null
                        ? ClipOval(
                            child: Image.asset(_profilePhotoPath!, fit: BoxFit.cover),
                          )
                        : const Icon(Icons.add_a_photo_outlined, size: 30, color: Color(0xFF003366)),
                  ),
                ),
                const SizedBox(height: 6),
                InkWell(
                  onTap: () => _openUploadSourceModal("Profile Photo"),
                  child: Text(
                    _profilePhotoPath != null ? "Change Photo" : "+ Upload Photo",
                    style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF0055AA)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Account & Contact Card
          _buildCardWrapper(
            title: "Account & Contact",
            subtitle: "Personal information & login credentials",
            children: [
              _buildFieldLabel("Full Name *"),
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration("Enter full name", Icons.person_outline),
              ),
              const SizedBox(height: 12),

              _buildFieldLabel("Username *"),
              TextFormField(
                controller: _usernameController,
                decoration: _inputDecoration("Enter username", Icons.alternate_email),
              ),
              const SizedBox(height: 12),

              _buildFieldLabel("Email Address *"),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration("Enter email", Icons.email_outlined),
              ),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildFieldLabel("Password *"),
                  InkWell(
                    onTap: _generateRandomPassword,
                    child: Row(
                      children: [
                        const Icon(Icons.bolt, size: 14, color: Color(0xFF003366)),
                        Text("Auto Generate", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF003366))),
                      ],
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: _inputDecoration(
                  "Enter password",
                  Icons.lock_outline,
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, size: 18),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),
              // Security Strength Indicator
              if (_passwordController.text.isNotEmpty) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: _passwordController.text.length > 8 ? const Color(0xFF10B981) : Colors.orange,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _passwordController.text.length > 8 ? "Strong Security" : "Medium",
                      style: GoogleFonts.poppins(fontSize: 10, color: const Color(0xFF64748B), fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 12),

              _buildFieldLabel("Phone *"),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: _inputDecoration("Enter phone", Icons.phone_outlined),
              ),
              const SizedBox(height: 12),

              _buildFieldLabel("Alternate Number"),
              TextFormField(
                controller: _altPhoneController,
                keyboardType: TextInputType.phone,
                decoration: _inputDecoration("Enter alt phone", Icons.phone_iphone),
              ),
              const SizedBox(height: 12),

              _buildFieldLabel("Date of Birth (dd/mm/yyyy)"),
              TextFormField(
                controller: _dobController,
                readOnly: true,
                onTap: _pickDate,
                decoration: _inputDecoration("dd/mm/yyyy", Icons.calendar_today_outlined),
              ),
              const SizedBox(height: 12),

              _buildFieldLabel("Gender *"),
              Row(
                children: ["Male", "Female", "Other"].map((g) {
                  final isSel = _selectedGender == g;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: InkWell(
                        onTap: () => setState(() => _selectedGender = g),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          decoration: BoxDecoration(
                            color: isSel ? const Color(0xFF003366) : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            g,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                              color: isSel ? Colors.white : const Color(0xFF475569),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),

              // Job Location
              _buildFieldLabel("Job Location"),
              TextFormField(
                controller: _jobLocationController,
                decoration: _inputDecoration("Select or type job location", Icons.location_city_outlined),
              ),
              const SizedBox(height: 12),

              // Parent Administrator (Reporting Manager)
              _buildFieldLabel("Parent Administrator (Reporting Manager)"),
              DropdownButtonFormField<AdministratorItem>(
                value: (_selectedParent != null && managersToShow.any((m) => m.id == _selectedParent!.id))
                    ? _selectedParent
                    : null,
                isExpanded: true,
                decoration: _inputDecoration("Select Parent", Icons.account_tree_outlined),
                items: [
                  const DropdownMenuItem<AdministratorItem>(
                    value: null,
                    child: Text("Select Parent", style: TextStyle(color: Colors.grey), overflow: TextOverflow.ellipsis),
                  ),
                  ...managersToShow.map((a) {
                    final isPotential = potentialManagers.any((p) => p.id == a.id);
                    return DropdownMenuItem<AdministratorItem>(
                      value: a,
                      child: Text(
                        "${a.fullName} (${a.role?.code ?? 'Staff'})${isPotential ? ' ⭐' : ''}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    );
                  }),
                ],
                onChanged: (val) => setState(() => _selectedParent = val),
              ),
              const SizedBox(height: 5),

              // Potential Managers Counter Status (exact match to website!)
              if (_selectedRole != null)
                Row(
                  children: [
                    Icon(
                      potentialManagers.isNotEmpty ? Icons.verified_user_outlined : Icons.info_outline,
                      size: 13,
                      color: potentialManagers.isNotEmpty ? const Color(0xFF10B981) : const Color(0xFF64748B),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "${potentialManagers.length} potential manager${potentialManagers.length == 1 ? '' : 's'} found for this role.",
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: potentialManagers.isNotEmpty ? const Color(0xFF10B981) : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                )
              else
                Text(
                  "Select a Role first to filter potential managers",
                  style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF94A3B8)),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Role / Type & Publishing Controls Card
          _buildCardWrapper(
            title: "Role / Type & Publishing",
            subtitle: "Designation, status and lead count limits",
            children: [
              _buildFieldLabel("Role / Type *"),
              InkWell(
                onTap: () => _openRolePickerSheet(roles),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.shield_outlined, size: 18, color: Color(0xFF003366)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _selectedRole != null
                              ? "${_selectedRole!.name} (${_selectedRole!.code})"
                              : "Search & Select Role...",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: _selectedRole != null ? FontWeight.bold : FontWeight.normal,
                            color: _selectedRole != null ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down, color: Color(0xFF64748B)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Max Leads Count
              _buildFieldLabel("Max Leads Count"),
              TextFormField(
                controller: _maxLeadsController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration("e.g. 50 (blank = unlimited)", Icons.visibility_outlined),
              ),
              const SizedBox(height: 4),
              Text(
                "Maximum leads this member can view in lead lists. Leave empty for unlimited.",
                style: GoogleFonts.poppins(fontSize: 10, color: const Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 14),

              // Publish Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Status: ${_isActive ? 'Active' : 'Inactive'}",
                          style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold)),
                      Text(_isActive ? "User can sign in & operate" : "Access is temporarily blocked",
                          style: GoogleFonts.poppins(fontSize: 11, color: _isActive ? const Color(0xFF10B981) : Colors.redAccent)),
                    ],
                  ),
                  Switch(
                    value: _isActive,
                    activeColor: const Color(0xFF10B981),
                    onChanged: (v) => setState(() => _isActive = v),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 2: Bank Details & Address Details
  // ==========================================
  Widget _buildTab2BankAndAddress(AdministratorMetaModel? meta) {
    final states = meta?.states ?? [];
    final banks = meta?.payoutBanks ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Bank Details
          _buildCardWrapper(
            title: "Bank Details",
            subtitle: "Commission and disbursement bank account info",
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildFieldLabel("IFSC Code"),
                  if (_ifscVerified)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: const Color(0xFFECFDF5), borderRadius: BorderRadius.circular(4)),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, size: 12, color: Color(0xFF10B981)),
                          const SizedBox(width: 4),
                          Text("Verified", style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF065F46))),
                        ],
                      ),
                    ),
                ],
              ),
              TextFormField(
                controller: _ifscController,
                textCapitalization: TextCapitalization.characters,
                onChanged: (v) => _onIfscChanged(v, banks),
                decoration: _inputDecoration("E.G. SBIN0001234", Icons.tag),
              ),
              const SizedBox(height: 12),

              _buildFieldLabel("Bank Name"),
              TextFormField(
                controller: _bankNameController,
                decoration: _inputDecoration("Bank Name", Icons.account_balance_outlined),
              ),
              const SizedBox(height: 12),

              _buildFieldLabel("Branch Name"),
              TextFormField(
                controller: _branchController,
                decoration: _inputDecoration("Branch Name", Icons.store_mall_directory_outlined),
              ),
              const SizedBox(height: 12),

              _buildFieldLabel("Account Number"),
              TextFormField(
                controller: _accountNumberController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration("Account Number", Icons.numbers),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Address Details
          _buildCardWrapper(
            title: "Address Details",
            subtitle: "State, city and street address",
            children: [
              _buildFieldLabel("Pincode"),
              TextFormField(
                controller: _pincodeController,
                keyboardType: TextInputType.number,
                onChanged: (v) => _onPincodeChanged(v, states),
                decoration: _inputDecoration("e.g. 110001", Icons.pin_drop_outlined),
              ),
              const SizedBox(height: 12),

              _buildFieldLabel("State"),
              DropdownButtonFormField<MetaStateOption>(
                value: _selectedState,
                isExpanded: true,
                decoration: _inputDecoration("Select State", Icons.map_outlined),
                items: states.map((s) {
                  return DropdownMenuItem<MetaStateOption>(
                    value: s,
                    child: Text(s.stateName, overflow: TextOverflow.ellipsis, maxLines: 1),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedState = val),
              ),
              const SizedBox(height: 12),

              _buildFieldLabel("City / District"),
              TextFormField(
                controller: _cityController,
                decoration: _inputDecoration("Select or type City", Icons.location_city_outlined),
              ),
              const SizedBox(height: 12),

              _buildFieldLabel("Full Address"),
              TextFormField(
                controller: _addressController,
                maxLines: 2,
                decoration: _inputDecoration("Enter full address", Icons.home_outlined),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 3: Documents (Required Documents & Custom)
  // ==========================================
  Widget _buildTab3Documents() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildCardWrapper(
            title: "Required Documents",
            subtitle: "Government ID proofs and KYC records",
            children: [
              _buildUploadBox("Aadhar Card", _aadharUploaded, () {
                _openUploadSourceModal("Aadhar Card");
              }),
              const SizedBox(height: 12),

              _buildUploadBox("PAN Card", _panUploaded, () {
                _openUploadSourceModal("PAN Card");
              }),
              const SizedBox(height: 12),

              _buildUploadBox("Bank Passbook", _passbookUploaded, () {
                _openUploadSourceModal("Bank Passbook");
              }),
            ],
          ),
          const SizedBox(height: 16),

          // Additional Documents
          _buildCardWrapper(
            title: "Additional Documents",
            subtitle: "Upload extra verification certificates",
            children: [
              ..._extraDocuments.map((doc) => ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.description_outlined, color: Color(0xFF003366)),
                    title: Text(doc, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                      onPressed: () => setState(() => _extraDocuments.remove(doc)),
                    ),
                  )),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () {
                  setState(() => _extraDocuments.add("Extra Document #${_extraDocuments.length + 1}"));
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF003366)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.add, size: 18),
                label: Text("+ Add More", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUploadBox(String label, bool isUploaded, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: isUploaded ? const Color(0xFFECFDF5) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isUploaded ? const Color(0xFF10B981) : const Color(0xFFCBD5E1),
            width: isUploaded ? 1.5 : 1.0,
          ),
        ),
        child: Column(
          children: [
            Icon(
              isUploaded ? Icons.verified : Icons.cloud_upload_outlined,
              size: 34,
              color: isUploaded ? const Color(0xFF10B981) : const Color(0xFF64748B),
            ),
            const SizedBox(height: 6),
            Text(
              isUploaded ? "$label Verified & Uploaded" : "Click to Upload $label",
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isUploaded ? const Color(0xFF065F46) : const Color(0xFF334155),
              ),
            ),
            Text(
              isUploaded ? "Tap to replace document" : "PDF, PNG or JPG up to 5MB",
              style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF94A3B8)),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // TAB 4: Outward Payout Matrix (Banks x Categories)
  // ==========================================
  Widget _buildTab4OutwardPayout(AdministratorMetaModel? meta) {
    final banks = meta?.payoutBanks ?? [];
    final categories = meta?.payoutCategories ?? [];

    if (banks.isEmpty || categories.isEmpty) {
      return Center(
        child: Text("Loading payout banks & categories...", style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey)),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ⚡ 1-Tap Quick Apply Standard Rates Bar (Feature #4)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFBFDBFE)),
            ),
            child: Row(
              children: [
                const Icon(Icons.flash_on, color: Color(0xFF2563EB), size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("1-Tap Standard FMC Rates", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF1E40AF))),
                      Text("Fills 1.5% Used Car, 0.75% New Car across all banks", style: GoogleFonts.poppins(fontSize: 10, color: const Color(0xFF3B82F6))),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _applyStandardPayoutRates(banks, categories),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  child: Text("Apply All", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Text(
            "Bank Outward Payout Rates",
            style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
          ),
          const SizedBox(height: 4),
          Text(
            "Configure bank commission percentages (%) for this administrator across all loan categories.",
            style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF64748B)),
          ),
          const SizedBox(height: 14),

          ...banks.map((bank) {
            _payoutControllers.putIfAbsent(bank.id, () => {});
            final bMap = _payoutControllers[bank.id]!;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: ExpansionTile(
                initiallyExpanded: bank == banks.first,
                leading: const Icon(Icons.account_balance, color: Color(0xFF003366), size: 20),
                title: Text(bank.name, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold)),
                subtitle: Text("Configure rates (%)", style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                children: [
                  const Divider(height: 1),
                  const SizedBox(height: 10),
                  ...categories.map((cat) {
                    bMap.putIfAbsent(cat.code, () => TextEditingController(text: "0.00"));
                    final ctrl = bMap[cat.code]!;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(cat.name, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500)),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: SizedBox(
                              height: 38,
                              child: TextField(
                                controller: ctrl,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  suffixText: "%",
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                  filled: true,
                                  fillColor: const Color(0xFFF8FAFC),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 5: Modular Access & Leads Status Matrix
  // ==========================================
  Widget _buildTab5ModularAccess(AdministratorMetaModel? meta) {
    final modules = meta?.modules ?? [];

    // Filter modules if search query is present
    final filteredModules = modules.where((m) {
      if (_moduleSearchQuery.trim().isEmpty) return true;
      return m.name.toLowerCase().contains(_moduleSearchQuery.trim().toLowerCase());
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🚀 1-Tap Permission Templates (FinTech Presets Bar)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF003366), Color(0xFF0F4C81)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF003366).withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.bolt, color: Colors.amber, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          "1-Tap Permission Presets",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "Fast Setup",
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildTemplateChip(
                      label: "👑 Full Admin",
                      onTap: () => _applyPermissionTemplate("Full Admin", modules),
                      bg: Colors.white,
                      textColor: const Color(0xFF003366),
                    ),
                    _buildTemplateChip(
                      label: "💼 Sales Team",
                      onTap: () => _applyPermissionTemplate("Sales Team", modules),
                      bg: const Color(0xFF10B981),
                      textColor: Colors.white,
                    ),
                    _buildTemplateChip(
                      label: "👁️ View Only",
                      onTap: () => _applyPermissionTemplate("View Only", modules),
                      bg: const Color(0xFF0284C7),
                      textColor: Colors.white,
                    ),
                    _buildTemplateChip(
                      label: "🔄 Reset All",
                      onTap: () => _applyPermissionTemplate("Reset", modules),
                      bg: Colors.redAccent.withValues(alpha: 0.2),
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 🔀 Segmented Sub-Tab Switcher: Business Modules vs Leads Status Pipeline
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _selectedAccessSection = 0),
                    borderRadius: BorderRadius.circular(10),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _selectedAccessSection == 0 ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: _selectedAccessSection == 0
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.dashboard_customize_outlined,
                            size: 15,
                            color: _selectedAccessSection == 0 ? const Color(0xFF003366) : const Color(0xFF64748B),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Modules (${modules.length})",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: _selectedAccessSection == 0 ? FontWeight.bold : FontWeight.w500,
                              color: _selectedAccessSection == 0 ? const Color(0xFF003366) : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _selectedAccessSection = 1),
                    borderRadius: BorderRadius.circular(10),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _selectedAccessSection == 1 ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: _selectedAccessSection == 1
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.timeline_rounded,
                            size: 15,
                            color: _selectedAccessSection == 1 ? const Color(0xFF003366) : const Color(0xFF64748B),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Lead Pipeline (23)",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: _selectedAccessSection == 1 ? FontWeight.bold : FontWeight.w500,
                              color: _selectedAccessSection == 1 ? const Color(0xFF003366) : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // View 1: Business Modules
          if (_selectedAccessSection == 0) ...[
            // Quick Search & Master Action Row
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (val) => setState(() => _moduleSearchQuery = val),
                    decoration: InputDecoration(
                      hintText: "Search module (e.g. Cars, Loans)...",
                      hintStyle: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF94A3B8)),
                      prefixIcon: const Icon(Icons.search, size: 18, color: Color(0xFF003366)),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                PopupMenuButton<String>(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  icon: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: const Icon(Icons.tune_rounded, size: 18, color: Color(0xFF003366)),
                  ),
                  onSelected: (val) {
                    if (val == "expand_all") {
                      setState(() => _expandedModuleIds.addAll(modules.map((m) => m.id)));
                    } else if (val == "collapse_all") {
                      setState(() => _expandedModuleIds.clear());
                    } else if (val == "grant_all") {
                      _applyPermissionTemplate("Full Admin", modules);
                    } else if (val == "revoke_all") {
                      _applyPermissionTemplate("Reset", modules);
                    }
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(value: "expand_all", child: Text("Expand All Cards")),
                    const PopupMenuItem(value: "collapse_all", child: Text("Collapse All Cards")),
                    const PopupMenuDivider(),
                    const PopupMenuItem(value: "grant_all", child: Text("Grant All Access")),
                    const PopupMenuItem(value: "revoke_all", child: Text("Revoke All Access")),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Modules Cards List
            if (filteredModules.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Column(
                    children: [
                      const Icon(Icons.search_off_rounded, size: 40, color: Colors.grey),
                      const SizedBox(height: 8),
                      Text("No matching modules found", style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                ),
              )
            else
              ...filteredModules.map((m) => _buildPremiumModuleCard(m)),
          ],

          // View 2: Lead Status Pipeline (23 Stages)
          if (_selectedAccessSection == 1) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFieldLabel("Select Lead Module to Configure:"),
                  DropdownButtonFormField<String>(
                    value: _selectedLeadModule,
                    isExpanded: true,
                    decoration: _inputDecoration("Select Module", Icons.apps),
                    items: _leadModulesList.map((m) => DropdownMenuItem(value: m, child: Text(m, overflow: TextOverflow.ellipsis))).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedLeadModule = val);
                    },
                  ),
                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check_circle, size: 14, color: Color(0xFF10B981)),
                            const SizedBox(width: 5),
                            Text(
                              _selectedLeadModule,
                              style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF047857)),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                for (var s in _leadStatuses) {
                                  _leadStatusPermissions[s]!['view'] = true;
                                  _leadStatusPermissions[s]!['add'] = true;
                                  _leadStatusPermissions[s]!['edit'] = true;
                                  _leadStatusPermissions[s]!['delete'] = true;
                                  _leadStatusPermissions[s]!['status'] = true;
                                  _leadStatusPermissions[s]!['assign'] = true;
                                }
                              });
                            },
                            child: Text("Grant All 23", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF003366))),
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              setState(() {
                                for (var s in _leadStatuses) {
                                  _leadStatusPermissions[s]!['view'] = false;
                                  _leadStatusPermissions[s]!['add'] = false;
                                  _leadStatusPermissions[s]!['edit'] = false;
                                  _leadStatusPermissions[s]!['delete'] = false;
                                  _leadStatusPermissions[s]!['status'] = false;
                                  _leadStatusPermissions[s]!['assign'] = false;
                                }
                              });
                            },
                            child: Text("Clear All", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // 23 Lead Statuses rendered in Sleek Tactile Pipeline Cards
            ..._leadStatuses.map((statusName) {
              final sPerms = _leadStatusPermissions[statusName]!;
              final grantedCount = sPerms.values.where((v) => v == true).length;
              final isAllGranted = grantedCount == 6;

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: grantedCount > 0 ? const Color(0xFF003366).withValues(alpha: 0.25) : const Color(0xFFE2E8F0),
                    width: grantedCount > 0 ? 1.3 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: grantedCount > 0 ? const Color(0xFF10B981) : const Color(0xFFCBD5E1),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              statusName,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                        // Quick Toggle for this status
                        InkWell(
                          onTap: () {
                            setState(() {
                              final turnOn = !isAllGranted;
                              sPerms['view'] = turnOn;
                              sPerms['add'] = turnOn;
                              sPerms['edit'] = turnOn;
                              sPerms['delete'] = turnOn;
                              sPerms['status'] = turnOn;
                              sPerms['assign'] = turnOn;
                            });
                          },
                          child: Text(
                            isAllGranted ? "Deselect All" : "Select All",
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: isAllGranted ? Colors.redAccent : const Color(0xFF003366),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _buildModernActionPill(
                          label: "View",
                          icon: Icons.visibility_outlined,
                          isActive: sPerms['view'] ?? false,
                          activeColor: const Color(0xFF003366),
                          onTap: () => setState(() => sPerms['view'] = !(sPerms['view'] ?? false)),
                        ),
                        // Only "New Lead" supports "Add" in CRM Leads Pipeline!
                        if (statusName == "New Lead")
                          _buildModernActionPill(
                            label: "Add",
                            icon: Icons.add_circle_outline_rounded,
                            isActive: sPerms['add'] ?? false,
                            activeColor: const Color(0xFF10B981),
                            onTap: () => setState(() => sPerms['add'] = !(sPerms['add'] ?? false)),
                          ),
                        _buildModernActionPill(
                          label: "Edit",
                          icon: Icons.edit_outlined,
                          isActive: sPerms['edit'] ?? false,
                          activeColor: const Color(0xFF0284C7),
                          onTap: () => setState(() => sPerms['edit'] = !(sPerms['edit'] ?? false)),
                        ),
                        _buildModernActionPill(
                          label: "Delete",
                          icon: Icons.delete_outline_rounded,
                          isActive: sPerms['delete'] ?? false,
                          activeColor: const Color(0xFFEF4444),
                          onTap: () => setState(() => sPerms['delete'] = !(sPerms['delete'] ?? false)),
                        ),
                        _buildModernActionPill(
                          label: "Status",
                          icon: Icons.toggle_on_outlined,
                          isActive: sPerms['status'] ?? false,
                          activeColor: const Color(0xFF8B5CF6),
                          onTap: () => setState(() => sPerms['status'] = !(sPerms['status'] ?? false)),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  // ==========================================
  // 💎 Premium Module Card with Master Toggle
  // ==========================================
  Widget _buildPremiumModuleCard(MetaModuleOption m) {
    _modulePermissions.putIfAbsent(m.id, () => {
      'view': m.hasView,
      'add': m.hasAdd,
      'edit': m.hasEdit,
      'delete': m.hasDelete,
      'status': m.hasStatus,
      'assign': m.hasAssign,
    });
    final perms = _modulePermissions[m.id]!;

    int totalPossible = 0;
    if (m.hasView) totalPossible++;
    if (m.hasAdd) totalPossible++;
    if (m.hasEdit) totalPossible++;
    if (m.hasDelete) totalPossible++;
    if (m.hasStatus) totalPossible++;
    if (m.hasAssign) totalPossible++;
    if (totalPossible == 0) totalPossible = 1;

    int grantedCount = 0;
    if (m.hasView && (perms['view'] == true)) grantedCount++;
    if (m.hasAdd && (perms['add'] == true)) grantedCount++;
    if (m.hasEdit && (perms['edit'] == true)) grantedCount++;
    if (m.hasDelete && (perms['delete'] == true)) grantedCount++;
    if (m.hasStatus && (perms['status'] == true)) grantedCount++;
    if (m.hasAssign && (perms['assign'] == true)) grantedCount++;

    final isAllGranted = grantedCount == totalPossible;
    final isNoneGranted = grantedCount == 0;
    final isViewOnly = grantedCount == 1 && perms['view'] == true;

    // Module icon & styling
    final iconData = _getModuleIcon(m.name);
    final themeColor = _getModuleColor(m.name);

    // Live Status Badge
    Color badgeColor;
    String badgeText;
    if (isAllGranted) {
      badgeColor = const Color(0xFF10B981);
      badgeText = "Full Access";
    } else if (isViewOnly) {
      badgeColor = const Color(0xFF0284C7);
      badgeText = "View Only";
    } else if (isNoneGranted) {
      badgeColor = const Color(0xFF94A3B8);
      badgeText = "No Access";
    } else {
      badgeColor = const Color(0xFFF59E0B);
      badgeText = "$grantedCount/$totalPossible Allowed";
    }

    final isExpanded = _expandedModuleIds.contains(m.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: !isNoneGranted ? themeColor.withValues(alpha: 0.35) : const Color(0xFFE2E8F0),
          width: !isNoneGranted ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: !isNoneGranted ? themeColor.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Row
          InkWell(
            onTap: () {
              setState(() {
                if (isExpanded) {
                  _expandedModuleIds.remove(m.id);
                } else {
                  _expandedModuleIds.add(m.id);
                }
              });
            },
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  // Category Icon
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: themeColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(iconData, color: themeColor, size: 20),
                  ),
                  const SizedBox(width: 12),

                  // Title & Badge
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          m.name,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: badgeColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            badgeText,
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: badgeColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 1-Tap Master Switch Toggle
                  Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      value: !isNoneGranted,
                      activeThumbColor: Colors.white,
                      activeTrackColor: themeColor,
                      inactiveThumbColor: Colors.grey.shade400,
                      inactiveTrackColor: Colors.grey.shade200,
                      onChanged: (val) {
                        setState(() {
                          if (m.hasView) perms['view'] = val;
                          if (m.hasAdd) perms['add'] = val;
                          if (m.hasEdit) perms['edit'] = val;
                          if (m.hasDelete) perms['delete'] = val;
                          if (m.hasStatus) perms['status'] = val;
                          if (m.hasAssign) perms['assign'] = val;
                        });
                        HapticFeedback.lightImpact();
                      },
                    ),
                  ),

                  // Expand Chevron
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    color: const Color(0xFF64748B),
                    size: 22,
                  ),
                ],
              ),
            ),
          ),

          // Expanded Content (Tactile Action Pills)
          if (isExpanded) ...[
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Actions & Permissions",
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (m.hasView) perms['view'] = true;
                                if (m.hasAdd) perms['add'] = true;
                                if (m.hasEdit) perms['edit'] = true;
                                if (m.hasDelete) perms['delete'] = true;
                                if (m.hasStatus) perms['status'] = true;
                                if (m.hasAssign) perms['assign'] = true;
                              });
                            },
                            child: Text("Grant All", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF003366))),
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              setState(() {
                                perms['view'] = m.hasView;
                                perms['add'] = false;
                                perms['edit'] = false;
                                perms['delete'] = false;
                                perms['status'] = false;
                                perms['assign'] = false;
                              });
                            },
                            child: Text("View Only", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF0284C7))),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Tactile Action Pills (Filtered by whether module supports that permission!)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (m.hasView)
                        _buildModernActionPill(
                          label: "View",
                          icon: Icons.visibility_outlined,
                          isActive: perms['view'] ?? false,
                          activeColor: const Color(0xFF003366),
                          onTap: () => setState(() => perms['view'] = !(perms['view'] ?? false)),
                        ),
                      if (m.hasAdd)
                        _buildModernActionPill(
                          label: "Add",
                          icon: Icons.add_circle_outline_rounded,
                          isActive: perms['add'] ?? false,
                          activeColor: const Color(0xFF10B981),
                          onTap: () => setState(() => perms['add'] = !(perms['add'] ?? false)),
                        ),
                      if (m.hasEdit)
                        _buildModernActionPill(
                          label: "Edit",
                          icon: Icons.edit_outlined,
                          isActive: perms['edit'] ?? false,
                          activeColor: const Color(0xFF0284C7),
                          onTap: () => setState(() => perms['edit'] = !(perms['edit'] ?? false)),
                        ),
                      if (m.hasDelete)
                        _buildModernActionPill(
                          label: "Delete",
                          icon: Icons.delete_outline_rounded,
                          isActive: perms['delete'] ?? false,
                          activeColor: const Color(0xFFEF4444),
                          onTap: () => setState(() => perms['delete'] = !(perms['delete'] ?? false)),
                        ),
                      if (m.hasStatus)
                        _buildModernActionPill(
                          label: "Status",
                          icon: Icons.toggle_on_outlined,
                          isActive: perms['status'] ?? false,
                          activeColor: const Color(0xFF8B5CF6),
                          onTap: () => setState(() => perms['status'] = !(perms['status'] ?? false)),
                        ),
                      if (m.hasAssign)
                        _buildModernActionPill(
                          label: "Assign",
                          icon: Icons.person_add_alt_1_outlined,
                          isActive: perms['assign'] ?? false,
                          activeColor: const Color(0xFFF59E0B),
                          onTap: () => setState(() => perms['assign'] = !(perms['assign'] ?? false)),
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
  }

  // ==========================================
  // 🔘 Tactile Action Pill
  // ==========================================
  Widget _buildModernActionPill({
    required String label,
    required IconData icon,
    required bool isActive,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isActive ? activeColor : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive ? activeColor : const Color(0xFFE2E8F0),
            width: 1.2,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.25),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? Icons.check_circle_rounded : icon,
              size: 14,
              color: isActive ? Colors.white : const Color(0xFF64748B),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? Colors.white : const Color(0xFF334155),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplateChip({
    required String label,
    required VoidCallback onTap,
    required Color bg,
    required Color textColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: textColor),
        ),
      ),
    );
  }

  IconData _getModuleIcon(String name) {
    final n = name.toLowerCase();
    if (n.contains('car') || n.contains('vehicle')) return Icons.directions_car_filled_outlined;
    if (n.contains('loan') || n.contains('refinance')) return Icons.account_balance_outlined;
    if (n.contains('contact') || n.contains('callback')) return Icons.support_agent_outlined;
    if (n.contains('user') || n.contains('admin')) return Icons.manage_accounts_outlined;
    if (n.contains('blog') || n.contains('content')) return Icons.article_outlined;
    if (n.contains('insurance')) return Icons.security_outlined;
    if (n.contains('property')) return Icons.home_work_outlined;
    if (n.contains('testimonial')) return Icons.rate_review_outlined;
    return Icons.widgets_outlined;
  }

  Color _getModuleColor(String name) {
    final n = name.toLowerCase();
    if (n.contains('loan') || n.contains('refinance')) return const Color(0xFF003366);
    if (n.contains('car') || n.contains('vehicle')) return const Color(0xFF0284C7);
    if (n.contains('insurance')) return const Color(0xFF10B981);
    if (n.contains('user') || n.contains('admin')) return const Color(0xFF8B5CF6);
    if (n.contains('contact') || n.contains('callback')) return const Color(0xFFF59E0B);
    return const Color(0xFF003366);
  }

  void _showControllerSelectDialog({
    required BuildContext context,
    required List<CrmRoleItem> allRoles,
    required int? currentParentId,
    required void Function(int? id, String name) onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.65,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 6),
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Row(
                  children: [
                    const Icon(Icons.account_tree_outlined, color: Color(0xFF003366), size: 20),
                    const SizedBox(width: 8),
                    Text(
                      "Select Controller / Parent Role",
                      style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A)),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  children: [
                    // Root "Controller"
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      leading: Icon(
                        currentParentId == null || currentParentId == 0
                            ? Icons.check_circle_rounded
                            : Icons.circle_outlined,
                        color: currentParentId == null || currentParentId == 0
                            ? const Color(0xFF003366)
                            : const Color(0xFFCBD5E1),
                        size: 20,
                      ),
                      title: Text(
                        "Controller",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: (currentParentId == null || currentParentId == 0) ? FontWeight.w700 : FontWeight.w500,
                          color: (currentParentId == null || currentParentId == 0) ? const Color(0xFF003366) : const Color(0xFF0F172A),
                        ),
                      ),
                      subtitle: Text("Top-level / Root controller", style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF64748B))),
                      onTap: () {
                        onSelected(null, "Controller");
                        Navigator.pop(bctx);
                      },
                    ),
                    const Divider(height: 1),
                    ...allRoles.map((role) {
                      final isSelected = currentParentId == role.id;
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        leading: Icon(
                          isSelected ? Icons.check_circle_rounded : Icons.circle_outlined,
                          color: isSelected ? const Color(0xFF003366) : const Color(0xFFCBD5E1),
                          size: 20,
                        ),
                        title: Text(
                          role.name,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected ? const Color(0xFF003366) : const Color(0xFF0F172A),
                          ),
                        ),
                        subtitle: role.code.isNotEmpty
                            ? Text(role.code, style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF64748B)))
                            : null,
                        onTap: () {
                          onSelected(role.id, role.name);
                          Navigator.pop(bctx);
                        },
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openRolePickerSheet(List<MetaRoleOption> roles) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        String query = "";
        bool isAddingRole = false;
        MetaRoleOption? editingRole;
        final roleNameCtrl = TextEditingController();
        int? selectedParentId;
        String selectedParentName = "Controller";
        bool allowedInLeads = false;
        bool isSubmitting = false;

        return StatefulBuilder(
          builder: (modalContext, setModalState) {
            final vm = modalContext.watch<AdministratorsViewModel>();
            final currentRoles = vm.metaOptions?.roles ?? roles;

            final filtered = currentRoles.where((r) {
              final q = query.toLowerCase();
              return r.name.toLowerCase().contains(q) || r.code.toLowerCase().contains(q);
            }).toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  // Handle
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 6),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
                  ),

                  // Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Select Designation / Role",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF003366).withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "${currentRoles.length} Roles",
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF003366),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Search Field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      onChanged: (v) => setModalState(() => query = v),
                      decoration: InputDecoration(
                        hintText: "Search roles...",
                        prefixIcon: const Icon(Icons.search, color: Color(0xFF003366)),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Role List with Edit & Delete Actions
                  Expanded(
                    child: filtered.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.search_off_rounded, size: 40, color: Colors.grey),
                                const SizedBox(height: 8),
                                Text(
                                  "No matching roles found",
                                  style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13),
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) => const Divider(height: 1),
                            itemBuilder: (_, idx) {
                              final r = filtered[idx];
                              final isSel = _selectedRole?.id == r.id;

                              return ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                leading: Icon(
                                  isSel ? Icons.radio_button_checked : Icons.radio_button_off,
                                  color: isSel ? const Color(0xFF003366) : const Color(0xFFCBD5E1),
                                  size: 20,
                                ),
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        r.name,
                                        style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                                          color: isSel ? const Color(0xFF003366) : const Color(0xFF0F172A),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: r.administratorsCount > 0
                                            ? const Color(0xFF10B981).withValues(alpha: 0.1)
                                            : Colors.grey.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        "${r.administratorsCount}",
                                        style: GoogleFonts.poppins(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: r.administratorsCount > 0
                                              ? const Color(0xFF10B981)
                                              : Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // ✏️ Edit Role (opens inline edit matching website)
                                    IconButton(
                                      icon: const Icon(Icons.edit_outlined, size: 18, color: Color(0xFF10B981)),
                                      tooltip: "Edit Role",
                                      onPressed: () {
                                        setModalState(() {
                                          editingRole = r;
                                          isAddingRole = false;
                                          roleNameCtrl.text = r.name;
                                          final crmRole = vm.roles.firstWhere(
                                            (cr) => cr.id == r.id,
                                            orElse: () => CrmRoleItem(id: r.id, name: r.name, code: r.code, parentId: 0),
                                          );
                                          selectedParentId = crmRole.parentId > 0 ? crmRole.parentId : null;
                                          selectedParentName = crmRole.parentName ?? (crmRole.parentId > 0 ? "Role #${crmRole.parentId}" : "Controller");
                                          allowedInLeads = crmRole.showInAssignLeads;
                                        });
                                      },
                                    ),
                                    // 🗑️ Delete Role
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, size: 18, color: Color(0xFFEF4444)),
                                      tooltip: "Delete Role",
                                      onPressed: () {
                                        _showDeleteRoleDialog(context, r, setModalState);
                                      },
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    _selectedRole = r;
                                    _selectedParent = null;
                                  });
                                  Navigator.pop(ctx);
                                },
                              );
                            },
                          ),
                  ),

                  // ➕ Web-Matching "+ Add New Role" & Inline Form Area
                  Container(
                    padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.of(modalContext).viewInsets.bottom + 16),
                    decoration: BoxDecoration(
                      color: (isAddingRole || editingRole != null) ? const Color(0xFFF8FAFC) : Colors.white,
                      border: const Border(top: BorderSide(color: Color(0xFFE2E8F0))),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 6,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: (isAddingRole || editingRole != null)
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header for mode
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      editingRole != null ? "Edit Role" : "Add Role",
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF0F172A),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setModalState(() {
                                          isAddingRole = false;
                                          editingRole = null;
                                          roleNameCtrl.clear();
                                        });
                                      },
                                      child: const Icon(Icons.close_rounded, size: 18, color: Color(0xFF94A3B8)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),

                                // 1. Controller / Parent Dropdown (Green Bordered matching Web)
                                InkWell(
                                  onTap: () {
                                    _showControllerSelectDialog(
                                      context: modalContext,
                                      allRoles: vm.roles,
                                      currentParentId: selectedParentId,
                                      onSelected: (id, name) {
                                        setModalState(() {
                                          selectedParentId = id;
                                          selectedParentName = name;
                                        });
                                      },
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: const Color(0xFF10B981), width: 1.5),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          selectedParentName,
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF0F172A),
                                          ),
                                        ),
                                        const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B)),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // 2. Role Name TextField
                                TextField(
                                  controller: roleNameCtrl,
                                  decoration: InputDecoration(
                                    hintText: "Role Name",
                                    hintStyle: GoogleFonts.poppins(color: const Color(0xFF94A3B8), fontSize: 13),
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF003366), width: 1.5)),
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // 3. Allowed in Leads Assignment: Yes / No Radio
                                Text(
                                  "Allowed in Leads Assignment:",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF475569),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () => setModalState(() => allowedInLeads = true),
                                      child: Row(
                                        children: [
                                          Icon(
                                            allowedInLeads ? Icons.radio_button_checked : Icons.radio_button_off,
                                            size: 18,
                                            color: allowedInLeads ? const Color(0xFF10B981) : const Color(0xFF94A3B8),
                                          ),
                                          const SizedBox(width: 6),
                                          Text("Yes", style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 24),
                                    InkWell(
                                      onTap: () => setModalState(() => allowedInLeads = false),
                                      child: Row(
                                        children: [
                                          Icon(
                                            !allowedInLeads ? Icons.radio_button_checked : Icons.radio_button_off,
                                            size: 18,
                                            color: !allowedInLeads ? const Color(0xFF10B981) : const Color(0xFF94A3B8),
                                          ),
                                          const SizedBox(width: 6),
                                          Text("No", style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),

                                // 4. Save & Cancel Buttons
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: isSubmitting
                                          ? null
                                          : () async {
                                              final name = roleNameCtrl.text.trim();
                                              if (name.isEmpty) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text("Please enter Role Name", style: GoogleFonts.poppins()),
                                                    backgroundColor: Colors.redAccent,
                                                  ),
                                                );
                                                return;
                                              }

                                              setModalState(() => isSubmitting = true);
                                              if (editingRole != null) {
                                                await vm.updateRole(
                                                  editingRole!.id,
                                                  name: name,
                                                  parentId: selectedParentId,
                                                  showInAssignLeads: allowedInLeads,
                                                );
                                                if (_selectedRole?.id == editingRole!.id) {
                                                  setState(() {
                                                    _selectedRole = MetaRoleOption(
                                                      id: editingRole!.id,
                                                      name: name,
                                                      code: editingRole!.code,
                                                      administratorsCount: editingRole!.administratorsCount,
                                                    );
                                                  });
                                                }
                                                setModalState(() {
                                                  isSubmitting = false;
                                                  editingRole = null;
                                                  isAddingRole = false;
                                                });
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text("Role updated successfully!", style: GoogleFonts.poppins()),
                                                    backgroundColor: const Color(0xFF10B981),
                                                  ),
                                                );
                                              } else {
                                                final newRole = await vm.createRole(
                                                  name: name,
                                                  parentId: selectedParentId,
                                                  showInAssignLeads: allowedInLeads,
                                                );
                                                setModalState(() => isSubmitting = false);
                                                if (newRole != null) {
                                                  setState(() {
                                                    _selectedRole = newRole;
                                                    _selectedParent = null;
                                                  });
                                                  Navigator.pop(ctx);
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      content: Text("Role '$name' created and selected!", style: GoogleFonts.poppins()),
                                                      backgroundColor: const Color(0xFF10B981),
                                                    ),
                                                  );
                                                }
                                              }
                                            },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF0284C7),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                        elevation: 0,
                                      ),
                                      child: isSubmitting
                                          ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                          : Text("Save", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 13)),
                                    ),
                                    const Spacer(),
                                    TextButton(
                                      onPressed: () {
                                        setModalState(() {
                                          isAddingRole = false;
                                          editingRole = null;
                                          roleNameCtrl.clear();
                                        });
                                      },
                                      child: Text(
                                        "Cancel",
                                        style: GoogleFonts.poppins(
                                          color: const Color(0xFF64748B),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : InkWell(
                              onTap: () {
                                setModalState(() {
                                  isAddingRole = true;
                                  editingRole = null;
                                  roleNameCtrl.clear();
                                  selectedParentId = null;
                                  selectedParentName = "Controller";
                                  allowedInLeads = false;
                                });
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                child: Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.add_rounded, color: Color(0xFF10B981), size: 20),
                                      const SizedBox(width: 6),
                                      Text(
                                        "+ Add New Role",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF10B981),
                                        ),
                                      ),
                                    ],
                                  ),
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

  // ==========================================
  // 🗑️ Delete Role Dialog
  // ==========================================
  void _showDeleteRoleDialog(
    BuildContext rootContext,
    MetaRoleOption role,
    void Function(void Function()) setModalState,
  ) {
    if (role.administratorsCount > 0) {
      showDialog(
        context: rootContext,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 24),
              const SizedBox(width: 8),
              Text("Cannot Delete Role", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
            ],
          ),
          content: Text(
            "Role '${role.name}' has ${role.administratorsCount} active staff member(s) assigned. You must re-assign them to another role before deleting.",
            style: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF475569)),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF003366)),
              child: Text("Understood", style: GoogleFonts.poppins(color: Colors.white)),
            ),
          ],
        ),
      );
      return;
    }

    showDialog(
      context: rootContext,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Delete Role?", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
        content: Text(
          "Are you sure you want to permanently delete '${role.name}' (${role.code})?",
          style: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF475569)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Cancel", style: GoogleFonts.poppins(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final vm = rootContext.read<AdministratorsViewModel>();
              await vm.deleteRole(role.id);
              if (_selectedRole?.id == role.id) {
                setState(() => _selectedRole = null);
              }
              setModalState(() {});
              ScaffoldMessenger.of(rootContext).showSnackBar(
                SnackBar(
                  content: Text("Role '${role.name}' deleted", style: GoogleFonts.poppins()),
                  backgroundColor: const Color(0xFFEF4444),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
            child: Text("Delete", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildCardWrapper({
    required String title,
    required String subtitle,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
          const SizedBox(height: 2),
          Text(subtitle, style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF64748B))),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF334155),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon, {Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF94A3B8)),
      prefixIcon: Icon(icon, color: const Color(0xFF003366), size: 18),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF003366), width: 1.5),
      ),
    );
  }
}
