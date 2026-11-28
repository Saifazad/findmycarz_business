import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../models/crm_lead_model.dart';
import '../../viewmodels/leads_viewmodel.dart';
import '../../viewmodels/theme_viewmodel.dart';
import '../widgets/admin_profile_avatar.dart';
import '../widgets/custom_back_button.dart';

class EditLoanLeadScreen extends StatefulWidget {
  final CrmLeadModel lead;

  const EditLoanLeadScreen({super.key, required this.lead});

  @override
  State<EditLoanLeadScreen> createState() => _EditLoanLeadScreenState();
}

class _EditLoanLeadScreenState extends State<EditLoanLeadScreen> {
  int _currentStep = 0;
  bool _isSaving = false;

  final _step1Key = GlobalKey<FormState>();
  final _step2Key = GlobalKey<FormState>();
  final _step3Key = GlobalKey<FormState>();
  final _step4Key = GlobalKey<FormState>();

  // Step 1: Applicant Details
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _panCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _monthlyIncomeCtrl;

  // Step 2: Employment Details
  String _employmentType = "Select an option";
  final List<String> _employmentTypes = const [
    "Select an option",
    "Salaried",
    "Self-Employed",
  ];
  final TextEditingController _incomeSourceCtrl = TextEditingController();
  final TextEditingController _existingEmiCtrl = TextEditingController();

  // Step 3: Vehicle & Bank
  late final TextEditingController _loanAmountCtrl;
  late final TextEditingController _vehicleCtrl;
  late final TextEditingController _rcCtrl;
  final TextEditingController _valuationCtrl = TextEditingController();
  final TextEditingController _tenureCtrl = TextEditingController();
  final TextEditingController _interestCtrl = TextEditingController();
  final TextEditingController _bankNameCtrl = TextEditingController();
  final TextEditingController _ifscCtrl = TextEditingController();
  final TextEditingController _branchCtrl = TextEditingController();
  final TextEditingController _accountNoCtrl = TextEditingController();
  String _selectedInventoryCar = "Select an option";
  bool _notInInventory = false;

  // Step 3 & 4: Address, Documents & Lead Controls
  late final TextEditingController _cityCtrl;
  final TextEditingController _pincodeCtrl = TextEditingController();
  final TextEditingController _fullAddressCtrl = TextEditingController();
  String _selectedState = "Select an option";
  final List<String> _indianStates = const [
    "Select an option",
    "Andhra Pradesh",
    "Bihar",
    "Delhi",
    "Gujarat",
    "Haryana",
    "Karnataka",
    "Kerala",
    "Madhya Pradesh",
    "Maharashtra",
    "Punjab",
    "Rajasthan",
    "Tamil Nadu",
    "Telangana",
    "Uttar Pradesh",
    "West Bengal",
  ];
  late final TextEditingController _remarksCtrl;
  late String _selectedStatus;
  late String _selectedLoanType;
  late String _selectedLeadSource;
  String _selectedAgentType = "Dealer";
  String _selectedAgent = "Select Agent";
  String _selectedAdmin = "Unassigned";
  final List<Map<String, dynamic>> _docItems = [
    {"title": "AADHAAR CARD", "uploaded": false},
    {"title": "PAN CARD", "uploaded": false},
    {"title": "BANK PASSBOOK", "uploaded": false},
    {"title": "BANK STATEMENT", "uploaded": false},
    {"title": "PASSPORT SIZE PHOTO", "uploaded": false},
    {"title": "OLD RC (SELLER)", "uploaded": false},
    {"title": "INSURANCE POLICY", "uploaded": false},
  ];
  final List<Map<String, dynamic>> _extraDocs = [];
  final List<String> _loanTypes = const [
    "Used Car Loan",
    "Used Car - Sale Purchase",
    "New Car Loan",
    "BT & Top-Up Loan",
    "Car Loan Refinance",
    "Personal Loan",
    "Business Loan",
    "Home Loan",
    "Loan Against Property",
  ];
  final List<String> _agentTypes = const [
    "Broker",
    "Dealer",
    "Authorized Dealer",
    "Direct",
    "DMA",
    "ADMA",
  ];

  final List<String> _statusOptions = const [
    "New",
    "In Bank Login",
    "Sent to Bank",
    "Login",
    "Approved",
    "Disbursed",
    "RTO Process",
    "RTO Done",
    "Cancelled",
    "Rejected",
  ];

  @override
  void initState() {
    super.initState();
    final l = widget.lead;
    _nameCtrl = TextEditingController(text: l.name);
    _phoneCtrl = TextEditingController();
    _panCtrl = TextEditingController(text: l.panNumber ?? '');
    _emailCtrl = TextEditingController();
    _monthlyIncomeCtrl = TextEditingController(
      text: "₹ ${(l.monthlyIncome ?? 0).toStringAsFixed(2)}",
    );
    _loanAmountCtrl = TextEditingController(
      text: (l.amount ?? 0) > 0 ? l.amount!.round().toString() : '',
    );
    _vehicleCtrl = TextEditingController(text: l.carName ?? '');
    _rcCtrl = TextEditingController(text: l.regNo ?? '');
    if (l.carName != null && l.carName!.trim().isNotEmpty) {
      _selectedInventoryCar = l.carName!.trim();
    }
    _cityCtrl = TextEditingController(text: l.city ?? '');
    _remarksCtrl = TextEditingController(text: l.remarks ?? '');
    _selectedStatus =
        _statusOptions.contains(l.status) ? l.status : "In Bank Login";
    _selectedLoanType = _loanTypes.contains(l.type) ? l.type : "Used Car Loan";
    _selectedLeadSource = l.leadSource.trim().isNotEmpty
        ? (l.leadSource[0].toUpperCase() + l.leadSource.substring(1))
        : "Manual";
    if (l.assignedTo != null && l.assignedTo!.trim().isNotEmpty) {
      _selectedAdmin = l.assignedTo!.trim();
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _panCtrl.dispose();
    _emailCtrl.dispose();
    _monthlyIncomeCtrl.dispose();
    _incomeSourceCtrl.dispose();
    _existingEmiCtrl.dispose();
    _loanAmountCtrl.dispose();
    _vehicleCtrl.dispose();
    _rcCtrl.dispose();
    _valuationCtrl.dispose();
    _tenureCtrl.dispose();
    _interestCtrl.dispose();
    _bankNameCtrl.dispose();
    _ifscCtrl.dispose();
    _branchCtrl.dispose();
    _accountNoCtrl.dispose();
    _cityCtrl.dispose();
    _pincodeCtrl.dispose();
    _fullAddressCtrl.dispose();
    _remarksCtrl.dispose();
    for (final doc in _extraDocs) {
      (doc['controller'] as TextEditingController).dispose();
    }
    super.dispose();
  }

  String get _stepHeaderTitle {
    switch (_currentStep) {
      case 0:
        return "APPLICANT DETAILS";
      case 1:
        return "EMPLOYMENT DETAILS";
      case 2:
        return "VEHICLE & BANK";
      default:
        return "ADDRESS & DOCUMENTS";
    }
  }

  Future<void> _handleNextOrSave() async {
    final keys = [_step1Key, _step2Key, _step3Key, _step4Key];
    final currentForm = keys[_currentStep].currentState;
    if (currentForm != null && !currentForm.validate()) {
      return;
    }

    if (_currentStep < 3) {
      setState(() => _currentStep++);
      return;
    }

    setState(() => _isSaving = true);
    final vm = context.read<LeadsViewModel>();
    final ok = await vm.updateLeadStatus(
      widget.lead.id,
      _selectedStatus,
      _remarksCtrl.text.trim(),
    );
    if (!mounted) return;
    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? "Lead updated successfully"
              : "Could not update lead",
        ),
        backgroundColor: ok ? const Color(0xFF059669) : const Color(0xFFDC2626),
      ),
    );
    if (ok) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lead = widget.lead;
    final code = (lead.leadCode != null && lead.leadCode!.isNotEmpty)
        ? "#${lead.leadCode}"
        : "#${lead.id}";
    final dealerText =
        (lead.assignedTo != null && lead.assignedTo!.trim().isNotEmpty)
            ? lead.assignedTo!.trim()
            : "N/A";
    final progressPct = ((_currentStep + 1) * 25);

    final isDark = context.watch<ThemeViewModel>().isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : AppColors.background,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        elevation: 0.5,
        leading: CustomBackButton(isDarkMode: isDark),
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child: Text(
                    "Edit Lead: $code",
                    style: GoogleFonts.poppins(
                      fontSize: 15.5,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "Dealer: $dealerText",
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF475569),
                    ),
                  ),
                ),
              ],
            ),
            Text(
              "MANAGE APPLICANT DETAILS & DOCUMENTS",
              style: GoogleFonts.poppins(
                fontSize: 9.5,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),
        actions: const [
          AdminProfileAvatar(),
          SizedBox(width: 14),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () => context.read<LeadsViewModel>().fetchLeads(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Stepper Progress Card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "Step ${_currentStep + 1} of 4 • $progressPct%",
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              child: Text(
                                _stepHeaderTitle,
                                style: GoogleFonts.poppins(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF334155),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            _buildStepCircle(0, "Applicant De..."),
                            _buildStepCircle(1, "Employment ..."),
                            _buildStepCircle(2, "Vehicle & Bank"),
                            _buildStepCircle(3, "Address & D..."),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 2. Pipeline Milestones Card (Step 1 only)
                  if (_currentStep == 0) ...[
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.timeline_rounded,
                                      size: 16, color: AppColors.primary),
                                  const SizedBox(width: 6),
                                  Text(
                                    "Pipeline Milestones",
                                    style: GoogleFonts.poppins(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF0F172A),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "Live Updates",
                                style: GoogleFonts.poppins(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildMilestoneRow(
                            title: "New Lead",
                            subtitle: "Initiated & Captured",
                            trailing: lead.createdAt,
                            isDone: true,
                            isActive: false,
                            showLine: true,
                          ),
                          _buildMilestoneRow(
                            title: "Sent to Bank",
                            subtitle: "Underwriting Dispatched",
                            trailing:
                                lead.rawStatus.toUpperCase() != 'NEW_LEAD' &&
                                        lead.rawStatus.toUpperCase() != 'NEW'
                                    ? lead.createdAt
                                    : "Pending",
                            isDone: lead.rawStatus.toUpperCase() != 'NEW_LEAD' &&
                                lead.rawStatus.toUpperCase() != 'NEW',
                            isActive: false,
                            showLine: true,
                          ),
                          _buildMilestoneRow(
                            title: lead.status,
                            subtitle: "Current Application Stage",
                            trailing: lead.createdAt,
                            isDone: false,
                            isActive: true,
                            showLine: false,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // 3. Step Form Card
                  if (_currentStep == 1 ||
                      _currentStep == 2 ||
                      _currentStep == 3)
                    _buildCurrentStepForm()
                  else
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: _buildCurrentStepForm(),
                    ),
                ],
              ),
            ),
          ),
          ),

          // Bottom Action Bar: Cancel / Previous & Next Step / Save
          Container(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: OutlinedButton(
                      onPressed: () {
                        if (_currentStep > 0) {
                          setState(() => _currentStep--);
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Color(0xFFE2E8F0)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        _currentStep > 0 ? "Back" : "Cancel",
                        style: GoogleFonts.poppins(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _handleNextOrSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _currentStep < 3
                                      ? "Next Step"
                                      : "Save Lead",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Icon(
                                  _currentStep < 3
                                      ? Icons.arrow_forward_rounded
                                      : Icons.check_rounded,
                                  size: 17,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCircle(int index, String label) {
    final isActive = _currentStep == index;
    final isDone = _currentStep > index;

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _currentStep = index),
        borderRadius: BorderRadius.circular(8),
        child: Column(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primary
                    : isDone
                        ? const Color(0xFF059669)
                        : const Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: isDone
                  ? const Icon(Icons.check, size: 15, color: Colors.white)
                  : Text(
                      "${index + 1}",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isActive
                            ? Colors.white
                            : const Color(0xFF64748B),
                      ),
                    ),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive ? AppColors.primary : const Color(0xFF64748B),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMilestoneRow({
    required String title,
    required String subtitle,
    required String trailing,
    required bool isDone,
    required bool isActive,
    required bool showLine,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: isDone
                    ? const Color(0xFF059669)
                    : isActive
                        ? const Color(0xFFEFF6FF)
                        : const Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: isDone
                  ? const Icon(Icons.check, size: 13, color: Colors.white)
                  : Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.primary
                            : const Color(0xFF94A3B8),
                        shape: BoxShape.circle,
                      ),
                    ),
            ),
            if (showLine)
              Container(
                width: 1.5,
                height: 24,
                color: const Color(0xFFE2E8F0),
              ),
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: isActive
                              ? AppColors.primary
                              : const Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        subtitle,
                        style: GoogleFonts.poppins(
                          fontSize: 10.5,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  trailing,
                  style: GoogleFonts.poppins(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF475569),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentStepForm() {
    switch (_currentStep) {
      case 0:
        return Form(
          key: _step1Key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(
                  Icons.badge_outlined, "APPLICANT DETAILS"),
              const SizedBox(height: 14),
              _buildFieldLabel("FULL NAME", required: true),
              _buildInputField(
                controller: _nameCtrl,
                hint: "Enter full name",
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? "Required" : null,
              ),
              const SizedBox(height: 12),
              _buildFieldLabel("PHONE NUMBER", required: true),
              _buildInputField(
                controller: _phoneCtrl,
                hint: "Number",
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                suffixIcon: Icons.warning_amber_rounded,
                suffixColor: const Color(0xFFD97706),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? "Required" : null,
              ),
              const SizedBox(height: 12),
              _buildFieldLabel("PAN NUMBER", required: true),
              _buildInputField(
                controller: _panCtrl,
                hint: "Enter PAN number",
              ),
              const SizedBox(height: 12),
              _buildFieldLabel("EMAIL ADDRESS"),
              _buildInputField(
                controller: _emailCtrl,
                hint: "Email",
                prefixIcon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              _buildFieldLabel("MONTHLY INCOME"),
              _buildInputField(
                controller: _monthlyIncomeCtrl,
                hint: "₹ 0.00",
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        );
      case 1:
        final parsedReqAmount =
            double.tryParse(_loanAmountCtrl.text.trim()) ?? 0;
        final carOptions = <String>{
          "Select an option",
          if (widget.lead.carName != null &&
              widget.lead.carName!.trim().isNotEmpty)
            widget.lead.carName!.trim(),
        }.toList();
        return Form(
          key: _step2Key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card 1: EMPLOYMENT & INCOME
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle(
                        Icons.work_outline_rounded, "EMPLOYMENT & INCOME"),
                    const SizedBox(height: 14),
                    _buildFieldLabel("Employment Type"),
                    InkWell(
                      onTap: () => _showSearchablePickerSheet(
                        title: "Select Employment Type",
                        searchHint: "Search...",
                        options: _employmentTypes
                            .where((e) => e != "Select an option")
                            .toList(),
                        selectedValue: _employmentType,
                        onSelected: (val) =>
                            setState(() => _employmentType = val),
                      ),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 13),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                _employmentType,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: _employmentType == "Select an option"
                                      ? const Color(0xFF64748B)
                                      : const Color(0xFF0F172A),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 20,
                              color: Color(0xFF475569),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildFieldLabel("Income Source"),
                    _buildInputField(
                      controller: _incomeSourceCtrl,
                      hint: "Company / Business Name",
                    ),
                    const SizedBox(height: 12),
                    _buildFieldLabel("Existing EMI"),
                    _buildInputField(
                      controller: _existingEmiCtrl,
                      hint: "₹ 0.00",
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Card 2: LOAN REQUIREMENTS
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle(
                        Icons.payments_outlined, "LOAN REQUIREMENTS"),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildFieldLabel("Required Amount"),
                        if (parsedReqAmount > 0)
                          Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              _formatIndianCurrency(parsedReqAmount),
                              style: GoogleFonts.poppins(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                      ],
                    ),
                    TextFormField(
                      controller: _loanAmountCtrl,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(() {}),
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: const Color(0xFF0F172A),
                      ),
                      decoration: _inputDecoration("₹ 0.00"),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel("Tenure (Months)"),
                              _buildInputField(
                                controller: _tenureCtrl,
                                hint: "Months",
                                keyboardType: TextInputType.number,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel("Expected Interest %"),
                              _buildInputField(
                                controller: _interestCtrl,
                                hint: "0.0",
                                keyboardType: TextInputType.number,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Card 3: VEHICLE DETAILS
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
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
                              width: 4,
                              height: 14,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "VEHICLE DETAILS",
                              style: GoogleFonts.poppins(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.4,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () =>
                              setState(() => _notInInventory = !_notInInventory),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.add_circle_outline,
                                  size: 14, color: AppColors.primary),
                              const SizedBox(width: 4),
                              Text(
                                _notInInventory
                                    ? "Select from inventory"
                                    : "+ Not in inventory?",
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    if (_notInInventory) ...[
                      _buildFieldLabel("Vehicle Name / Model"),
                      _buildInputField(
                        controller: _vehicleCtrl,
                        hint: "Enter vehicle name",
                      ),
                    ] else ...[
                      _buildFieldLabel("Select Inventory Car"),
                      InkWell(
                        onTap: () => _showSearchablePickerSheet(
                          title: "Select Inventory Car",
                          searchHint: "Search...",
                          options: carOptions,
                          selectedValue:
                              carOptions.contains(_selectedInventoryCar)
                                  ? _selectedInventoryCar
                                  : "Select an option",
                          onSelected: (val) =>
                              setState(() => _selectedInventoryCar = val),
                        ),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 13),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  carOptions.contains(_selectedInventoryCar)
                                      ? _selectedInventoryCar
                                      : "Select an option",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: _selectedInventoryCar ==
                                            "Select an option"
                                        ? const Color(0xFF64748B)
                                        : const Color(0xFF0F172A),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 20,
                                color: Color(0xFF475569),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    _buildFieldLabel("Registration Number (RC)"),
                    _buildInputField(
                      controller: _rcCtrl,
                      hint: "MH01AB1234",
                    ),
                    const SizedBox(height: 12),
                    _buildFieldLabel("Valuation"),
                    _buildInputField(
                      controller: _valuationCtrl,
                      hint: "₹ 0",
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      case 2:
        return Form(
          key: _step3Key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card 1: APPLICANT BANK
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 14,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "APPLICANT BANK",
                          style: GoogleFonts.poppins(
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.4,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _buildFieldLabel("IFSC Code"),
                    _buildInputField(
                      controller: _ifscCtrl,
                      hint: "Enter IFSC Code",
                    ),
                    const SizedBox(height: 12),
                    _buildFieldLabel("Bank Name"),
                    _buildInputField(
                      controller: _bankNameCtrl,
                      hint: "Bank Name",
                    ),
                    const SizedBox(height: 12),
                    _buildFieldLabel("Branch"),
                    _buildInputField(
                      controller: _branchCtrl,
                      hint: "Branch",
                    ),
                    const SizedBox(height: 12),
                    _buildFieldLabel("Account No."),
                    _buildInputField(
                      controller: _accountNoCtrl,
                      hint: "Enter Account No",
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Card 2: ADDRESS
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 14,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "ADDRESS",
                          style: GoogleFonts.poppins(
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.4,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _buildFieldLabel("Pincode"),
                    _buildInputField(
                      controller: _pincodeCtrl,
                      hint: "Ex: 400001",
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    _buildFieldLabel("State"),
                    InkWell(
                      onTap: () => _showSearchablePickerSheet(
                        title: "Select State",
                        searchHint: "Search state...",
                        options: _indianStates,
                        selectedValue: _selectedState,
                        onSelected: (val) =>
                            setState(() => _selectedState = val),
                      ),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 13),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                _selectedState,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: _selectedState == "Select an option"
                                      ? const Color(0xFF64748B)
                                      : const Color(0xFF0F172A),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 20,
                              color: Color(0xFF475569),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildFieldLabel("City"),
                    _buildInputField(
                      controller: _cityCtrl,
                      hint: "Enter city",
                    ),
                    const SizedBox(height: 12),
                    _buildFieldLabel("Full Address"),
                    _buildInputField(
                      controller: _fullAddressCtrl,
                      hint: "House No, Street, Area",
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      default:
        final pairedDocs = _docItems.length >= 6
            ? _docItems.sublist(0, _docItems.length - 1)
            : _docItems;
        final lastDoc = _docItems.length >= 7 ? _docItems.last : null;
        final agentOptions = <String>{
          "Select Agent",
          if (widget.lead.assignedTo != null &&
              widget.lead.assignedTo!.trim().isNotEmpty)
            widget.lead.assignedTo!.trim(),
        }.toList();
        final adminOptions = <String>{
          "Unassigned",
          if (widget.lead.assignedTo != null &&
              widget.lead.assignedTo!.trim().isNotEmpty)
            widget.lead.assignedTo!.trim(),
        }.toList();

        return Form(
          key: _step4Key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card 1: DOCUMENTS
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.description_outlined,
                                size: 17, color: Color(0xFF059669)),
                            const SizedBox(width: 7),
                            Text(
                              "DOCUMENTS",
                              style: GoogleFonts.poppins(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.4,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _extraDocs.add({
                                "controller": TextEditingController(),
                                "uploaded": false,
                              });
                            });
                          },
                          child: Text(
                            "+ Add Extra Doc",
                            style: GoogleFonts.poppins(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: pairedDocs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1.15,
                      ),
                      itemBuilder: (ctx, i) => _buildDocUploadTile(pairedDocs[i]),
                    ),
                    if (lastDoc != null) ...[
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        height: 110,
                        child: _buildDocUploadTile(lastDoc),
                      ),
                    ],
                    if (_extraDocs.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _extraDocs.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.92,
                        ),
                        itemBuilder: (ctx, i) => _buildExtraDocTile(i),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Card 2: LEAD CONTROLS
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.settings_outlined,
                            size: 17, color: Color(0xFF059669)),
                        const SizedBox(width: 7),
                        Text(
                          "LEAD CONTROLS",
                          style: GoogleFonts.poppins(
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.4,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _buildFieldLabel("CURRENT STATUS"),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.outlined_flag_rounded,
                              size: 16, color: Color(0xFF64748B)),
                          const SizedBox(width: 8),
                          Text(
                            _selectedStatus.toUpperCase(),
                            style: GoogleFonts.poppins(
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF059669),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildFieldLabel("LOAN TYPE", required: true),
                    InkWell(
                      onTap: () => _showSearchablePickerSheet(
                        title: "Select Loan Type",
                        searchHint: "Search loan type...",
                        options: _loanTypes,
                        selectedValue: _selectedLoanType,
                        onSelected: (val) =>
                            setState(() => _selectedLoanType = val),
                      ),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 13),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.layers_outlined,
                                size: 17, color: Color(0xFF64748B)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _selectedLoanType,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: const Color(0xFF0F172A),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 20,
                              color: Color(0xFF475569),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildFieldLabel("LEAD SOURCE"),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.campaign_outlined,
                              size: 16, color: Color(0xFF64748B)),
                          const SizedBox(width: 8),
                          Text(
                            _selectedLeadSource,
                            style: GoogleFonts.poppins(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildFieldLabel("AGENT"),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: _agentTypes.map((t) {
                        final isSel = _selectedAgentType == t;
                        return InkWell(
                          onTap: () => setState(() => _selectedAgentType = t),
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: isSel
                                  ? const Color(0xFFECFDF5)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSel
                                    ? const Color(0xFF059669)
                                    : const Color(0xFFA7F3D0),
                              ),
                            ),
                            child: Text(
                              t,
                              style: GoogleFonts.poppins(
                                fontSize: 10.5,
                                fontWeight: isSel
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: const Color(0xFF059669),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () => _showSearchablePickerSheet(
                        title: "Select Agent",
                        searchHint: "Search agent...",
                        options: agentOptions,
                        selectedValue: agentOptions.contains(_selectedAgent)
                            ? _selectedAgent
                            : "Select Agent",
                        onSelected: (val) =>
                            setState(() => _selectedAgent = val),
                      ),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 13),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.storefront_outlined,
                                size: 17, color: Color(0xFF64748B)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                agentOptions.contains(_selectedAgent)
                                    ? _selectedAgent
                                    : "Select Agent",
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: const Color(0xFF0F172A),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 20,
                              color: Color(0xFF475569),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildFieldLabel("ASSIGN ADMINISTRATOR"),
                    InkWell(
                      onTap: () => _showSearchablePickerSheet(
                        title: "Assign Administrator",
                        searchHint: "Search administrator...",
                        options: adminOptions,
                        selectedValue: adminOptions.contains(_selectedAdmin)
                            ? _selectedAdmin
                            : "Unassigned",
                        onSelected: (val) =>
                            setState(() => _selectedAdmin = val),
                      ),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 13),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.person_outline,
                                size: 17, color: Color(0xFF64748B)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                adminOptions.contains(_selectedAdmin)
                                    ? _selectedAdmin
                                    : "Unassigned",
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: const Color(0xFF0F172A),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 20,
                              color: Color(0xFF475569),
                            ),
                          ],
                        ),
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

  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 17, color: AppColors.primary),
        const SizedBox(width: 7),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 13.5,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.4,
            color: const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }

  Widget _buildFieldLabel(String label, {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: label,
              style: GoogleFonts.poppins(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
                color: const Color(0xFF475569),
              ),
            ),
            if (required)
              TextSpan(
                text: " *",
                style: GoogleFonts.poppins(
                  fontSize: 10.5,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFDC2626),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    IconData? prefixIcon,
    IconData? suffixIcon,
    Color? suffixColor,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: GoogleFonts.poppins(
        fontSize: 13,
        color: const Color(0xFF0F172A),
      ),
      decoration: _inputDecoration(
        hint,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        suffixColor: suffixColor,
      ),
    );
  }

  InputDecoration _inputDecoration(
    String hint, {
    IconData? prefixIcon,
    IconData? suffixIcon,
    Color? suffixColor,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(
        fontSize: 13,
        color: const Color(0xFF94A3B8),
      ),
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, size: 17, color: const Color(0xFF64748B))
          : null,
      suffixIcon: suffixIcon != null
          ? Icon(suffixIcon,
              size: 17, color: suffixColor ?? const Color(0xFF64748B))
          : null,
      filled: true,
      fillColor: const Color(0xFFF1F5F9),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }

  String _formatIndianCurrency(double value) {
    final digits = value.round().toString();
    if (digits.length <= 3) return "₹ $digits";
    final last3 = digits.substring(digits.length - 3);
    var rest = digits.substring(0, digits.length - 3);
    final parts = <String>[];
    while (rest.length > 2) {
      parts.insert(0, rest.substring(rest.length - 2));
      rest = rest.substring(0, rest.length - 2);
    }
    if (rest.isNotEmpty) parts.insert(0, rest);
    return "₹ ${parts.join(',')},$last3";
  }

  Widget _buildDocUploadTile(Map<String, dynamic> doc) {
    final isUploaded = doc['uploaded'] == true;
    return InkWell(
      onTap: () {
        setState(() => doc['uploaded'] = !isUploaded);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isUploaded ? const Color(0xFFECFDF5) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isUploaded ? const Color(0xFF059669) : const Color(0xFF93C5FD),
            width: 1.2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isUploaded
                    ? const Color(0xFFD1FAE5)
                    : const Color(0xFFDBEAFE),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isUploaded
                    ? Icons.check_circle_outline
                    : Icons.cloud_upload_outlined,
                size: 18,
                color: isUploaded ? const Color(0xFF059669) : AppColors.primary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              isUploaded ? "Uploaded" : "Click to upload",
              style: GoogleFonts.poppins(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                color: isUploaded ? const Color(0xFF059669) : AppColors.primary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              doc['title'].toString(),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExtraDocTile(int index) {
    final doc = _extraDocs[index];
    final isUploaded = doc['uploaded'] == true;
    final ctrl = doc['controller'] as TextEditingController;

    return Column(
      children: [
        Expanded(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              InkWell(
                onTap: () => setState(() => doc['uploaded'] = !isUploaded),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isUploaded
                        ? const Color(0xFFECFDF5)
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isUploaded
                          ? const Color(0xFF059669)
                          : const Color(0xFFCBD5E1),
                      width: 1.2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isUploaded
                            ? Icons.check_circle_outline
                            : Icons.cloud_upload_outlined,
                        size: 26,
                        color: isUploaded
                            ? const Color(0xFF059669)
                            : const Color(0xFF94A3B8),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        isUploaded ? "UPLOADED" : "UPLOAD",
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.4,
                          color: isUploaded
                              ? const Color(0xFF059669)
                              : const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 6,
                right: 6,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      final removed = _extraDocs.removeAt(index);
                      (removed['controller'] as TextEditingController)
                          .dispose();
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.close,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 11.5,
            color: const Color(0xFF0F172A),
          ),
          decoration: InputDecoration(
            hintText: "Document Name",
            hintStyle: GoogleFonts.poppins(
              fontSize: 11.5,
              color: const Color(0xFF94A3B8),
            ),
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
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
              borderSide: const BorderSide(color: AppColors.primary, width: 1.2),
            ),
          ),
        ),
      ],
    );
  }

  void _showSearchablePickerSheet({
    required String title,
    required String searchHint,
    required List<String> options,
    required String selectedValue,
    required ValueChanged<String> onSelected,
  }) {
    String query = "";
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            final filtered = options
                .where((s) => s.toLowerCase().contains(query.toLowerCase()))
                .toList();
            return DraggableScrollableSheet(
              initialChildSize: 0.65,
              minChildSize: 0.45,
              maxChildSize: 0.85,
              expand: false,
              builder: (_, scrollCtrl) {
                return Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 14,
                    bottom: MediaQuery.of(ctx).viewInsets.bottom + 14,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(ctx),
                            icon: const Icon(Icons.close,
                                size: 20, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        onChanged: (val) => setSheetState(() => query = val),
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: const Color(0xFF0F172A),
                        ),
                        decoration: InputDecoration(
                          hintText: searchHint,
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 13,
                            color: const Color(0xFF94A3B8),
                          ),
                          prefixIcon: const Icon(Icons.search,
                              size: 19, color: Color(0xFF64748B)),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: AppColors.primary, width: 1.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.separated(
                          controller: scrollCtrl,
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) => const Divider(
                              height: 1, color: Color(0xFFF1F5F9)),
                          itemBuilder: (_, index) {
                            final item = filtered[index];
                            final isSelected = item == selectedValue;
                            return ListTile(
                              dense: true,
                              title: Text(
                                item,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? AppColors.primary
                                      : const Color(0xFF0F172A),
                                ),
                              ),
                              trailing: isSelected
                                  ? const Icon(Icons.check_rounded,
                                      size: 18, color: AppColors.primary)
                                  : null,
                              onTap: () {
                                onSelected(item);
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
      },
    );
  }
}
