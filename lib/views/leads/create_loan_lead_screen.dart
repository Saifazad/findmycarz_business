import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../models/crm_lead_model.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/admin_profile_avatar.dart';

class CreateLoanLeadScreen extends StatefulWidget {
  const CreateLoanLeadScreen({super.key});

  @override
  State<CreateLoanLeadScreen> createState() => _CreateLoanLeadScreenState();
}

class _CreateLoanLeadScreenState extends State<CreateLoanLeadScreen> {
  final ScrollController _scrollController = ScrollController();
  int _currentStep = 0;

  // Step Form Keys
  final _step1Key = GlobalKey<FormState>();
  final _step2Key = GlobalKey<FormState>();
  final _step3Key = GlobalKey<FormState>();
  final _step4Key = GlobalKey<FormState>();

  // ================= STEP 1: APPLICANT & EMPLOYMENT =================
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _panCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _monthlyIncomeCtrl = TextEditingController();

  String _employmentType = "Select an option";
  final List<String> _employmentTypes = [
    "Select an option",
    "Salaried",
    "Self-Employed",
    "Business Owner",
    "Professional",
    "Retired",
    "Other",
  ];
  final _incomeSourceCtrl = TextEditingController();
  final _existingEmiCtrl = TextEditingController();

  // ================= STEP 2: LOAN & BANK =================
  final _loanAmountCtrl = TextEditingController();
  final _tenureCtrl = TextEditingController();
  final _expectedInterestCtrl = TextEditingController();
  final _vehicleInterestedCtrl = TextEditingController();

  final _ifscCodeCtrl = TextEditingController();
  final _bankNameCtrl = TextEditingController();
  final _branchCtrl = TextEditingController();
  final _accountNumberCtrl = TextEditingController();

  // ================= STEP 3: ADDRESS & DOCUMENTS =================
  final _pincodeCtrl = TextEditingController();
  String _selectedState = "Select an option";
  final List<String> _indianStates = [
    "Select an option",
    "Delhi",
    "Uttar Pradesh",
    "Uttarakhand",
    "Maharashtra",
    "Gujarat",
    "Karnataka",
    "Haryana",
    "Punjab",
    "Rajasthan",
    "Tamil Nadu",
    "Telangana",
    "West Bengal",
    "Bihar",
    "Madhya Pradesh",
    "Kerala",
  ];
  String _selectedCity = "Select an option";
  final List<String> _cities = [
    "Select an option",
    "New Delhi",
    "Dehradun",
    "Noida",
    "Ghaziabad",
    "Gurgaon",
    "Mumbai",
    "Ahmedabad",
    "Bangalore",
    "Jaipur",
    "Lucknow",
    "Other",
  ];
  final _cityCtrl = TextEditingController();
  final _fullAddressCtrl = TextEditingController();

  final List<Map<String, dynamic>> _documents = [
    {"title": "Aadhaar Card", "isUploaded": false, "fileName": ""},
    {"title": "PAN Card", "isUploaded": false, "fileName": ""},
    {"title": "Bank Statement", "isUploaded": false, "fileName": ""},
    {"title": "Bank Passbook", "isUploaded": false, "fileName": ""},
    {"title": "Passport Photo", "isUploaded": false, "fileName": ""},
  ];

  final List<Map<String, dynamic>> _extraDocuments = [];

  void _addExtraDocument() {
    setState(() {
      _extraDocuments.add({
        "controller": TextEditingController(),
        "isUploaded": false,
        "fileName": "",
      });
    });
  }

  // ================= STEP 4: LEAD CONTROLS =================
  String _loanType = "Used Car Loan";
  final List<String> _loanTypes = [
    "Used Car Loan",
    "New Car Loan",
    "Loan Against Car",
    "Refinance",
    "Personal Loan",
    "Commercial Vehicle Loan",
  ];

  String _leadSource = "Manual";
  final List<String> _leadSources = [
    "Manual",
    "Website",
    "Referral",
    "Walk-in",
    "Social Media",
    "Partner Dealer",
    "Call Center",
  ];

  String _agent = "Select agent";
  final List<String> _agents = [
    "Select agent",
    "Agent Rahul",
    "Agent Priya",
    "Agent Amit",
    "Agent Vikram",
    "Naved Akhtar",
    "Fauziya RTO",
  ];

  String _assignAdmin = "Unassigned";
  final List<String> _admins = [
    "Unassigned",
    "Super Admin",
    "Vaahan Baza – Nitin Khatri",
    "Auto Care Mohammad Sajid",
    "Find My Car Head Office",
  ];

  // Step Titles and Subtitles matching Image 1 & Images 2-4
  final List<String> _stepTitles = [
    "Applicant & Employment",
    "Loan & Bank",
    "Address & Documents",
    "Lead Controls",
  ];

  final List<String> _stepSubtitles = [
    "Who is applying",
    "Amount and account",
    "Where and proof",
    "Assign and create",
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _panCtrl.dispose();
    _emailCtrl.dispose();
    _monthlyIncomeCtrl.dispose();
    _incomeSourceCtrl.dispose();
    _existingEmiCtrl.dispose();
    _loanAmountCtrl.dispose();
    _tenureCtrl.dispose();
    _expectedInterestCtrl.dispose();
    _vehicleInterestedCtrl.dispose();
    _ifscCodeCtrl.dispose();
    _bankNameCtrl.dispose();
    _branchCtrl.dispose();
    _accountNumberCtrl.dispose();
    _pincodeCtrl.dispose();
    _cityCtrl.dispose();
    _fullAddressCtrl.dispose();
    for (final doc in _extraDocuments) {
      (doc["controller"] as TextEditingController?)?.dispose();
    }
    super.dispose();
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
      _scrollToTop();
    } else {
      _submitForm();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _scrollToTop();
    } else {
      Navigator.pop(context);
    }
  }

  void _submitForm() {
    if (!(_step4Key.currentState?.validate() ?? false)) return;

    final customerName = _nameCtrl.text.trim().isNotEmpty
        ? _nameCtrl.text.trim()
        : "Customer";
    final phone = _phoneCtrl.text.trim();
    final loanAmountVal =
        double.tryParse(_loanAmountCtrl.text.replaceAll(',', '').trim()) ?? 500000;
    final panVal = _panCtrl.text.trim().toUpperCase();
    final cityVal = _cityCtrl.text.trim();
    final vehicleVal = _vehicleInterestedCtrl.text.trim();
    final monthlyIncomeVal =
        double.tryParse(_monthlyIncomeCtrl.text.replaceAll(',', '').trim());

    final newLead = CrmLeadModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      leadCode: (1000 + DateTime.now().millisecond).toString(),
      name: customerName,
      phone: phone,
      email: _emailCtrl.text.trim().isNotEmpty ? _emailCtrl.text.trim() : null,
      panNumber: panVal.isNotEmpty ? panVal : null,
      city: cityVal.isNotEmpty ? cityVal : null,
      type: _loanType,
      rawLoanType: _loanType.toUpperCase().replaceAll(' ', '_'),
      carName: vehicleVal.isNotEmpty ? vehicleVal : null,
      amount: loanAmountVal,
      monthlyIncome: monthlyIncomeVal,
      status: "New",
      rawStatus: "NEW",
      assignedTo: _agent != "Select agent"
          ? _agent
          : (_assignAdmin != "Unassigned" ? _assignAdmin : null),
      createdAt: DateFormat("dd MMM yyyy").format(DateTime.now()),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                "Loan lead for $customerName created successfully!",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        duration: const Duration(seconds: 3),
      ),
    );

    Navigator.pop(context, newLead);
  }



  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: _currentStep == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_currentStep > 0) {
          _previousStep();
        }
      },
      child: Scaffold(
        backgroundColor:
            isDark ? const Color(0xFF0F172A) : AppColors.background,
        appBar: AppBar(
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          elevation: 0.5,
          leading: CustomBackButton(
            isDarkMode: isDark,
            onPressed: () {
              if (_currentStep > 0) {
                _previousStep();
              } else {
                Navigator.pop(context);
              }
            },
          ),
          title: Text(
            "Create Loan Lead",
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          actions: const [
            AdminProfileAvatar(),
            SizedBox(width: 14),
          ],
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF131B2E) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF334155)
                        : AppColors.cardBorder,
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
                      blurRadius: 18,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ================= 1. HEADER BANNER (NAVY GRADIENT) =================
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 18),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.navyStart, AppColors.navyEnd],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(18),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _stepTitles[_currentStep],
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _stepSubtitles[_currentStep],
                            style: GoogleFonts.poppins(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ================= 2. STEPPER ROW =================
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(4, (index) {
                          final isCurrent = index == _currentStep;
                          final isPassed = index < _currentStep;

                          return InkWell(
                            onTap: () {
                              setState(() => _currentStep = index);
                              _scrollToTop();
                            },
                            borderRadius: BorderRadius.circular(24),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isPassed
                                          ? AppColors.success
                                          : (isCurrent
                                              ? AppColors.navyStart
                                              : (isDark
                                                  ? const Color(0xFF1E293B)
                                                  : AppColors.iconSurface)),
                                      border: Border.all(
                                        color: isPassed
                                            ? AppColors.success
                                            : (isCurrent
                                                ? AppColors.navyStart
                                                : (isDark
                                                    ? const Color(0xFF334155)
                                                    : AppColors.stepInactiveBorder)),
                                        width: isCurrent ? 2 : 1,
                                      ),
                                      boxShadow: isCurrent
                                          ? [
                                              BoxShadow(
                                                color: AppColors.navyStart
                                                    .withValues(alpha: 0.25),
                                                blurRadius: 6,
                                                offset: const Offset(0, 2),
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: Center(
                                      child: isPassed
                                          ? const Icon(
                                              Icons.check_rounded,
                                              size: 15,
                                              color: Colors.white,
                                            )
                                          : Text(
                                              "${index + 1}",
                                              style: GoogleFonts.poppins(
                                                fontSize: 11.5,
                                                fontWeight: FontWeight.bold,
                                                color: (isCurrent || isPassed)
                                                    ? Colors.white
                                                    : (isDark
                                                        ? const Color(0xFF94A3B8)
                                                        : AppColors.stepInactiveText),
                                              ),
                                            ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Step ${index + 1}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      fontWeight: isCurrent
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                      color: isPassed
                                          ? AppColors.success
                                          : (isCurrent
                                              ? (isDark
                                                  ? Colors.white
                                                  : AppColors.navyStart)
                                              : (isDark
                                                  ? const Color(0xFF94A3B8)
                                                  : AppColors.stepInactiveText)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                    Divider(
                      height: 1,
                      thickness: 1,
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFF1F5F9),
                    ),

                    // ================= 3. SCROLLABLE FORM BODY =================
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(18),
                        child: _buildCurrentStepContent(isDark),
                      ),
                    ),

                    // ================= 4. BOTTOM ACTION BUTTONS (FIXED AT BOTTOM) =================
                    Container(
                      padding: const EdgeInsets.fromLTRB(18, 10, 18, 16),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF131B2E) : Colors.white,
                        border: Border(
                          top: BorderSide(
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFF1F5F9),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          // Back Button
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _previousStep,
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: isDark
                                      ? const Color(0xFF60A5FA)
                                      : AppColors.navyStart,
                                  width: 1.5,
                                ),
                                foregroundColor: isDark
                                    ? const Color(0xFF60A5FA)
                                    : AppColors.navyStart,
                                backgroundColor: isDark
                                    ? const Color(0xFF1E293B)
                                    : Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 13),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(9),
                                ),
                              ),
                              child: Text(
                                "Back",
                                style: GoogleFonts.poppins(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? const Color(0xFF60A5FA)
                                      : AppColors.navyStart,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),

                          // Next / Create Lead Button
                          Expanded(
                            child: ElevatedButton(
                              onPressed:
                                  _currentStep < 3 ? _nextStep : _submitForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.navyStart,
                                foregroundColor: Colors.white,
                                disabledBackgroundColor: isDark
                                    ? const Color(0xFF334155)
                                    : AppColors.iconSurface,
                                disabledForegroundColor: isDark
                                    ? const Color(0xFF94A3B8)
                                    : AppColors.neutralMuted,
                                elevation: 0,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 13),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(9),
                                ),
                              ),
                              child: Text(
                                _currentStep < 3 ? "Next" : "Create lead",
                                style: GoogleFonts.poppins(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ================= STEP SWITCHER =================
  Widget _buildCurrentStepContent(bool isDark) {
    switch (_currentStep) {
      case 0:
        return _buildStep1Content(isDark);
      case 1:
        return _buildStep2Content(isDark);
      case 2:
        return _buildStep3Content(isDark);
      case 3:
        return _buildStep4Content(isDark);
      default:
        return const SizedBox.shrink();
    }
  }

  // ================= STEP 1: APPLICANT & EMPLOYMENT (IMAGE 1) =================
  Widget _buildStep1Content(bool isDark) {
    return Form(
      key: _step1Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section 1: Applicant details
          _buildSectionHeader("Applicant details"),
          const SizedBox(height: 12),
          _buildTextField(
            label: "Full name",
            isRequired: true,
            controller: _nameCtrl,
            hintText: "Dr. John Doe",
            validator: (val) =>
                val == null || val.trim().isEmpty ? "Full name is required" : null,
            isDark: isDark,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: "Phone number",
            isRequired: true,
            controller: _phoneCtrl,
            hintText: "9876543210",
            keyboardType: TextInputType.phone,
            validator: (val) {
              if (val == null || val.trim().isEmpty) return "Phone number is required";
              final clean = val.replaceAll(RegExp(r'[^0-9]'), '');
              if (clean.length < 10) return "Enter a valid 10-digit number";
              return null;
            },
            isDark: isDark,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: "PAN number",
            isRequired: true,
            controller: _panCtrl,
            hintText: "ABCDE1234F",
            textCapitalization: TextCapitalization.characters,
            validator: (val) {
              if (val == null || val.trim().isEmpty) return "PAN number is required";
              if (val.trim().length != 10) return "PAN must be 10 characters";
              return null;
            },
            isDark: isDark,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: "Email address",
            isRequired: false,
            controller: _emailCtrl,
            hintText: "name@example.com",
            keyboardType: TextInputType.emailAddress,
            isDark: isDark,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: "Monthly Income (₹)",
            isRequired: true,
            controller: _monthlyIncomeCtrl,
            hintText: "50000",
            keyboardType: TextInputType.number,
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return "Monthly income is required";
              }
              if (double.tryParse(val.replaceAll(',', '').trim()) == null) {
                return "Enter a valid number";
              }
              return null;
            },
            isDark: isDark,
          ),

          const SizedBox(height: 20),

          // Section 2: Employment and income
          _buildSectionHeader("Employment and income"),
          const SizedBox(height: 12),
          _buildDropdownField(
            label: "Employment type",
            isRequired: true,
            value: _employmentType,
            items: _employmentTypes,
            onChanged: (val) {
              if (val != null) setState(() => _employmentType = val);
            },
            isDark: isDark,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: "Income source",
            isRequired: false,
            controller: _incomeSourceCtrl,
            hintText: "Company or business name",
            isDark: isDark,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: "Existing EMI (₹)",
            isRequired: false,
            controller: _existingEmiCtrl,
            hintText: "0",
            keyboardType: TextInputType.number,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  // ================= STEP 2: LOAN & BANK =================
  Widget _buildStep2Content(bool isDark) {
    return Form(
      key: _step2Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader("Loan requirements"),
          const SizedBox(height: 12),
          _buildTextField(
            label: "Required amount (₹)",
            isRequired: true,
            controller: _loanAmountCtrl,
            hintText: "500000",
            keyboardType: TextInputType.number,
            validator: (val) {
              if (val == null || val.trim().isEmpty) return "Loan amount is required";
              if (double.tryParse(val.replaceAll(',', '').trim()) == null) {
                return "Enter a valid amount";
              }
              return null;
            },
            isDark: isDark,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: "Tenure (months)",
            isRequired: true,
            controller: _tenureCtrl,
            hintText: "36",
            keyboardType: TextInputType.number,
            validator: (val) {
              if (val == null || val.trim().isEmpty) return "Tenure is required";
              final num = int.tryParse(val.trim());
              if (num == null || num <= 0) return "Enter valid number of months";
              return null;
            },
            isDark: isDark,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: "Expected Interest (%)",
            isRequired: false,
            controller: _expectedInterestCtrl,
            hintText: "10.5",
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            isDark: isDark,
          ),

          const SizedBox(height: 20),

          _buildSectionHeader("Applicant bank"),
          const SizedBox(height: 12),
          _buildTextField(
            label: "IFSC code",
            isRequired: true,
            controller: _ifscCodeCtrl,
            hintText: "SBIN0001234",
            textCapitalization: TextCapitalization.characters,
            validator: (val) {
              if (val == null || val.trim().isEmpty) return "IFSC code is required";
              if (val.trim().length != 11) return "IFSC must be 11 characters";
              return null;
            },
            isDark: isDark,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: "Bank name",
            isRequired: true,
            controller: _bankNameCtrl,
            hintText: "Bank name",
            validator: (val) =>
                val == null || val.trim().isEmpty ? "Bank name is required" : null,
            isDark: isDark,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: "Branch",
            isRequired: false,
            controller: _branchCtrl,
            hintText: "Branch",
            isDark: isDark,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: "Account number",
            isRequired: true,
            controller: _accountNumberCtrl,
            hintText: "Account number",
            keyboardType: TextInputType.number,
            validator: (val) =>
                val == null || val.trim().isEmpty ? "Account number is required" : null,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  // ================= STEP 3: ADDRESS & DOCUMENTS =================
  Widget _buildStep3Content(bool isDark) {
    return Form(
      key: _step3Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader("Address"),
          const SizedBox(height: 12),
          _buildTextField(
            label: "Pincode",
            isRequired: true,
            controller: _pincodeCtrl,
            hintText: "110001",
            keyboardType: TextInputType.number,
            validator: (val) {
              if (val == null || val.trim().isEmpty) return "Pincode is required";
              if (val.trim().length != 6) return "Enter valid 6-digit pincode";
              return null;
            },
            isDark: isDark,
          ),
          const SizedBox(height: 12),
          _buildDropdownField(
            label: "State",
            isRequired: true,
            value: _selectedState,
            items: _indianStates,
            onChanged: (val) {
              if (val != null) setState(() => _selectedState = val);
            },
            isDark: isDark,
          ),
          const SizedBox(height: 12),
          _buildDropdownField(
            label: "City",
            isRequired: true,
            value: _selectedCity,
            items: _cities,
            onChanged: (val) {
              if (val != null) setState(() => _selectedCity = val);
            },
            isDark: isDark,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: "Full address",
            isRequired: true,
            controller: _fullAddressCtrl,
            hintText: "House no, street, area",
            maxLines: 2,
            validator: (val) =>
                val == null || val.trim().isEmpty ? "Full address is required" : null,
            isDark: isDark,
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionHeader("Documents"),
              InkWell(
                onTap: _addExtraDocument,
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Text(
                    "+ Add extra doc",
                    style: GoogleFonts.poppins(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? const Color(0xFF60A5FA)
                          : AppColors.navyStart,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          LayoutBuilder(
            builder: (ctx, constraints) {
              final itemWidth = (constraints.maxWidth - 12) / 2;
              return Wrap(
                spacing: 12,
                runSpacing: 14,
                children: [
                  // 1. Default Documents
                  ..._documents.map((doc) {
                    final isUploaded = doc["isUploaded"] as bool;
                    final title = doc["title"] as String;
                    final fileName = doc["fileName"] as String;

                    return SizedBox(
                      width: itemWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                doc["isUploaded"] = !isUploaded;
                                doc["fileName"] = !isUploaded
                                    ? "${title.toLowerCase().replaceAll(' ', '_')}.pdf"
                                    : "";
                              });
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: double.infinity,
                              height: 78,
                              decoration: BoxDecoration(
                                color: isUploaded
                                    ? AppColors.success.withValues(alpha: 0.1)
                                    : (isDark
                                        ? const Color(0xFF0B1120)
                                        : AppColors.formFieldBg),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isUploaded
                                      ? AppColors.success
                                      : (isDark
                                          ? const Color(0xFF334155)
                                          : AppColors.cardBorder),
                                  width: 1.2,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    isUploaded
                                        ? Icons.check_circle_rounded
                                        : Icons.cloud_upload_rounded,
                                    size: 24,
                                    color: isUploaded
                                        ? AppColors.success
                                        : (isDark
                                            ? const Color(0xFF60A5FA)
                                            : AppColors.navyStart),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    isUploaded ? "Uploaded" : "Click to upload",
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: isUploaded
                                          ? AppColors.success
                                          : (isDark
                                              ? const Color(0xFF94A3B8)
                                              : AppColors.neutralMuted),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            title,
                            style: GoogleFonts.poppins(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (isUploaded && fileName.isNotEmpty)
                            Text(
                              fileName,
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                color: const Color(0xFF22C55E),
                                fontStyle: FontStyle.italic,
                              ),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                        ],
                      ),
                    );
                  }),

                  // 2. Extra Documents matching Image 1
                  ..._extraDocuments.asMap().entries.map((entry) {
                    final index = entry.key;
                    final doc = entry.value;
                    final isUploaded = doc["isUploaded"] as bool;
                    final ctrl = doc["controller"] as TextEditingController;

                    return SizedBox(
                      width: itemWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                doc["isUploaded"] = !isUploaded;
                                doc["fileName"] = !isUploaded ? "document.pdf" : "";
                              });
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: double.infinity,
                              height: 78,
                              decoration: BoxDecoration(
                                color: isUploaded
                                    ? AppColors.success.withValues(alpha: 0.1)
                                    : (isDark
                                        ? const Color(0xFF0B1120)
                                        : AppColors.formFieldBg),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isUploaded
                                      ? AppColors.success
                                      : (isDark
                                          ? const Color(0xFF334155)
                                          : AppColors.cardBorder),
                                  width: 1.2,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          isUploaded
                                              ? Icons.check_circle_rounded
                                              : Icons.cloud_upload_outlined,
                                          size: 26,
                                          color: isUploaded
                                              ? AppColors.success
                                              : (isDark
                                                  ? const Color(0xFF60A5FA)
                                                  : AppColors.navyStart),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          isUploaded ? "UPLOADED" : "UPLOAD",
                                          style: GoogleFonts.poppins(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.bold,
                                            color: isUploaded
                                                ? AppColors.success
                                                : (isDark
                                                    ? const Color(0xFF94A3B8)
                                                    : AppColors.neutralMuted),
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          ctrl.dispose();
                                          _extraDocuments.removeAt(index);
                                        });
                                      },
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: const BoxDecoration(
                                          color: AppColors.paletteRed,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          size: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            height: 36,
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF0B1120) : Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: isDark
                                    ? const Color(0xFF334155)
                                    : AppColors.formFieldBorder,
                              ),
                            ),
                            child: TextField(
                              controller: ctrl,
                              style: GoogleFonts.poppins(
                                fontSize: 11.5,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintText: "Document Name",
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: isDark
                                      ? const Color(0xFF64748B)
                                      : AppColors.formPlaceholder,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 9,
                                ),
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // ================= STEP 4: LEAD CONTROLS =================
  Widget _buildStep4Content(bool isDark) {
    return Form(
      key: _step4Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader("Lead controls"),
          const SizedBox(height: 12),
          _buildDropdownField(
            label: "Loan type",
            isRequired: true,
            value: _loanType,
            items: _loanTypes,
            onChanged: (val) {
              if (val != null) setState(() => _loanType = val);
            },
            isDark: isDark,
          ),
          const SizedBox(height: 12),
          _buildDropdownField(
            label: "Lead source",
            isRequired: false,
            value: _leadSource,
            items: _leadSources,
            onChanged: (val) {
              if (val != null) setState(() => _leadSource = val);
            },
            isDark: isDark,
          ),
          const SizedBox(height: 12),
          _buildDropdownField(
            label: "Agent",
            isRequired: false,
            value: _agent,
            items: _agents,
            onChanged: (val) {
              if (val != null) setState(() => _agent = val);
            },
            isDark: isDark,
          ),
          const SizedBox(height: 12),
          _buildDropdownField(
            label: "Assign administrator",
            isRequired: false,
            value: _assignAdmin,
            items: _admins,
            onChanged: (val) {
              if (val != null) setState(() => _assignAdmin = val);
            },
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  // Section Header matching Add Blog Navy Color
  Widget _buildSectionHeader(String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 13.5,
        fontWeight: FontWeight.bold,
        color: isDark ? const Color(0xFF60A5FA) : AppColors.navyStart,
      ),
    );
  }

  // Text Form Field
  Widget _buildTextField({
    required String label,
    required bool isRequired,
    required TextEditingController controller,
    required String hintText,
    required bool isDark,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization textCapitalization = TextCapitalization.none,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: label,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? const Color(0xFFE2E8F0)
                      : AppColors.formLabel,
                ),
              ),
              if (isRequired)
                const TextSpan(
                  text: " *",
                  style: TextStyle(
                    color: AppColors.paletteRed,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          maxLines: maxLines,
          validator: validator,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.poppins(
              fontSize: 12.5,
              color: isDark ? const Color(0xFF64748B) : AppColors.formPlaceholder,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            filled: true,
            fillColor:
                isDark ? const Color(0xFF0B1120) : AppColors.formFieldBg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark
                    ? const Color(0xFF334155)
                    : AppColors.formFieldBorder,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark
                    ? const Color(0xFF334155)
                    : AppColors.formFieldBorder,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark ? const Color(0xFF60A5FA) : AppColors.navyStart,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.paletteRed,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.paletteRed,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Dropdown Field
  Widget _buildDropdownField({
    required String label,
    required bool isRequired,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: label,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? const Color(0xFFE2E8F0)
                      : AppColors.formLabel,
                ),
              ),
              if (isRequired)
                const TextSpan(
                  text: " *",
                  style: TextStyle(
                    color: AppColors.paletteRed,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0B1120) : AppColors.formFieldBg,
            border: Border.all(
              color: isDark
                  ? const Color(0xFF334155)
                  : AppColors.formFieldBorder,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: items.contains(value) ? value : items.first,
              isExpanded: true,
              dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
              icon: Icon(
                Icons.arrow_drop_down,
                color:
                    isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
              items: items.map((opt) {
                return DropdownMenuItem(
                  value: opt,
                  child: Text(
                    opt,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
