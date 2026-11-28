import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../models/crm_lead_model.dart';
import '../../viewmodels/leads_viewmodel.dart';
import '../../viewmodels/theme_viewmodel.dart';
import '../widgets/crm_drawer.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/admin_profile_avatar.dart';
import 'create_loan_lead_screen.dart';

class LoanCategoryFilter {
  final String label;
  final int count;

  const LoanCategoryFilter({required this.label, required this.count});
}

class PipelineStage {
  final String title;
  final int count;
  final int todayCount;
  final String? newBadge;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;

  PipelineStage({
    required this.title,
    required this.count,
    this.todayCount = 0,
    this.newBadge,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
  });
}

class _CategoryDashboardData {
  final int incomingTotal;
  final int incomingNew;
  final int webEnquiry;
  final int webEnquiryNew;
  final int callback;
  final int callbackNew;
  final int manual;
  final int manualNew;
  final int pipelineTotal;
  final Map<String, int> stageCounts;

  const _CategoryDashboardData({
    required this.incomingTotal,
    required this.incomingNew,
    required this.webEnquiry,
    required this.webEnquiryNew,
    required this.callback,
    required this.callbackNew,
    required this.manual,
    required this.manualNew,
    required this.pipelineTotal,
    this.stageCounts = const {},
  });
}

class LeadsListScreen extends StatefulWidget {
  final String? initialType;
  const LeadsListScreen({super.key, this.initialType});

  @override
  State<LeadsListScreen> createState() => _LeadsListScreenState();
}

class _LeadsListScreenState extends State<LeadsListScreen> {
  bool get _isDarkMode => context.watch<ThemeViewModel>().isDarkMode;
  String _activeCategory = "All";
  bool _isSyncing = false;
  bool _isFiltersExpanded = false;

  Future<void> _handleLiveSync() async {
    if (_isSyncing) return;
    setState(() {
      _isSyncing = true;
    });
    final vm = context.read<LeadsViewModel>();
    await vm.fetchLeads();
    if (!mounted) return;
    setState(() {
      _isSyncing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          vm.errorMessage == null
              ? "Leads live sync completed"
              : vm.errorMessage!,
        ),
        backgroundColor: vm.errorMessage == null
            ? AppColors.heroNavyStart
            : AppColors.paletteRed,
        duration: const Duration(milliseconds: 1200),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialType != null && widget.initialType!.isNotEmpty) {
      final initial = widget.initialType!.toLowerCase();
      for (final label in _categoryLabels) {
        if (label.toLowerCase().contains(initial) ||
            initial.contains(label.toLowerCase())) {
          _activeCategory = label;
          break;
        }
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<LeadsViewModel>().fetchLeads();
      }
    });
  }

  static const List<String> _categoryLabels = [
    "All",
    "Used Car - Sale Purchase",
    "New Car Loan",
    "Bt Topup Loan",
    "Car Loan Refinance",
    "Business Loan",
    "Home Loan",
    "Loan Against Property",
    "Personal Loan",
  ];

  static String _categoryForLead(CrmLeadModel lead) {
    switch (lead.rawLoanType.toUpperCase()) {
      case 'USED_CAR_LOAN':
        return "Used Car - Sale Purchase";
      case 'NEW_CAR_LOAN':
        return "New Car Loan";
      case 'BT_TOPUP_LOAN':
        return "Bt Topup Loan";
      case 'CAR_LOAN_REFINANCE':
        return "Car Loan Refinance";
      case 'BUSINESS_LOAN':
        return "Business Loan";
      case 'HOME_LOAN':
        return "Home Loan";
      case 'LOAN_AGAINST_PROPERTIES':
      case 'LOAN_AGAINST_PROPERTY':
        return "Loan Against Property";
      case 'PERSONAL_LOAN':
        return "Personal Loan";
      default:
        return lead.type;
    }
  }

  static bool _isIncomingLead(CrmLeadModel lead) {
    final rs = lead.rawStatus.toUpperCase();
    final s = lead.status.toLowerCase();
    return rs == 'NEW_LEAD' || rs == 'NEW' || s == 'new lead' || s == 'new';
  }

  String _stageTitleForLead(CrmLeadModel lead) {
    final rs = lead.rawStatus.toUpperCase();
    switch (rs) {
      case 'CONTACT_EST':
      case 'CONTACT_ESTABLISHED':
        return "Contact Est.";
      case 'FOLLOW_UP':
        return "Follow Up";
      case 'PICK_UP':
      case 'PICKUP':
        return "Pick Up";
      case 'DOC_PENDING':
        return "Doc Pending";
      case 'DOC_RECEIVED':
        return "Doc Received";
      case 'SENT_TO_BANK':
        return "Sent to Bank";
      case 'UNDER_PROCESS':
      case 'LOGIN':
        return "Login";
      case 'REJECTED':
        return "Rejected";
      case 'APPROVED':
        return "Approved";
      case 'DISBURSED':
        return "Disbursed";
      case 'RTO_PROCESS':
        return "RTO Process (RTO Person)";
      case 'RTO_DONE':
        return "RTO Done";
      case 'PAYMENT_REQUESTED':
        return "Payment Requested";
      case 'PAYMENT_IN_PROCESS':
        return "Payment In Process";
      case 'PAYMENT_DONE':
        return "Payment Done (Accounts)";
      case 'VEHICLE_HANDOVER':
        return "Vehicle Handover";
      case 'PDD_PENDING':
        return "PDD Pending";
      case 'PDD_SUBMITTED':
        return "PDD Submitted";
      case 'CASE_COMPLETED':
      case 'COMPLETED':
        return "Case Completed";
      case 'CASE_CANCELLATION':
        return "Case Cancellation";
      case 'CANCEL':
      case 'CASE_CANCELLED':
      case 'CANCELLED':
        return "Case Cancelled";
    }

    final label = lead.status.trim().toLowerCase();
    for (final stage in _stages) {
      final st = stage.title.toLowerCase().replaceAll(' ', '');
      if (st == label.replaceAll(' ', '')) {
        return stage.title;
      }
    }
    return lead.status;
  }

  _CategoryDashboardData _computeDashboardData(List<CrmLeadModel> leads) {
    final filtered = _activeCategory == "All"
        ? leads
        : leads.where((l) => _categoryForLead(l) == _activeCategory).toList();

    int webEnquiry = 0;
    int callback = 0;
    int manual = 0;
    int incomingTotal = 0;
    int pipelineTotal = 0;
    final stageCounts = <String, int>{};

    for (final lead in filtered) {
      if (_isIncomingLead(lead)) {
        incomingTotal++;
        final src = lead.leadSource;
        if (src == 'callback') {
          callback++;
        } else if (src == 'manual') {
          manual++;
        } else {
          webEnquiry++;
        }
      } else {
        pipelineTotal++;
        final stage = _stageTitleForLead(lead);
        stageCounts[stage] = (stageCounts[stage] ?? 0) + 1;
      }
    }

    return _CategoryDashboardData(
      incomingTotal: incomingTotal,
      incomingNew: incomingTotal,
      webEnquiry: webEnquiry,
      webEnquiryNew: webEnquiry,
      callback: callback,
      callbackNew: callback,
      manual: manual,
      manualNew: manual,
      pipelineTotal: pipelineTotal,
      stageCounts: stageCounts,
    );
  }

  final List<PipelineStage> _stages = [
    PipelineStage(
      title: "Contact Est.",
      count: 0,
      todayCount: 0,
      icon: Icons.person_outline,
      iconColor: AppColors.paletteBlue,
      iconBg: AppColors.paletteBlue,
    ),
    PipelineStage(
      title: "Follow Up",
      count: 0,
      todayCount: 0,
      icon: Icons.phone_callback_outlined,
      iconColor: AppColors.paletteGreen,
      iconBg: AppColors.paletteGreen,
    ),
    PipelineStage(
      title: "Pick Up",
      count: 1,
      todayCount: 0,
      icon: Icons.directions_car_outlined,
      iconColor: AppColors.paletteOrange,
      iconBg: AppColors.paletteOrange,
    ),
    PipelineStage(
      title: "Doc Pending",
      count: 3,
      todayCount: 0,
      icon: Icons.description_outlined,
      iconColor: AppColors.paletteCyan,
      iconBg: AppColors.paletteCyan,
    ),
    PipelineStage(
      title: "Doc Received",
      count: 0,
      todayCount: 0,
      icon: Icons.task_outlined,
      iconColor: AppColors.palettePurple,
      iconBg: AppColors.palettePurple,
    ),
    PipelineStage(
      title: "Sent to Bank",
      count: 2,
      todayCount: 0,
      newBadge: "+2 New",
      icon: Icons.account_balance_outlined,
      iconColor: AppColors.paletteBlue,
      iconBg: AppColors.paletteBlue,
    ),
    PipelineStage(
      title: "Login",
      count: 3,
      todayCount: 0,
      newBadge: "+1 New",
      icon: Icons.login_outlined,
      iconColor: AppColors.paletteCyan,
      iconBg: AppColors.paletteCyan,
    ),
    PipelineStage(
      title: "Rejected",
      count: 3,
      todayCount: 0,
      icon: Icons.cancel_outlined,
      iconColor: AppColors.paletteRed,
      iconBg: AppColors.paletteRed,
    ),
    PipelineStage(
      title: "Approved",
      count: 1,
      todayCount: 0,
      icon: Icons.check_circle_outline,
      iconColor: AppColors.paletteGreen,
      iconBg: AppColors.paletteGreen,
    ),
    PipelineStage(
      title: "Disbursed",
      count: 11,
      todayCount: 0,
      newBadge: "+2 New",
      icon: Icons.verified_outlined,
      iconColor: AppColors.paletteGreen,
      iconBg: AppColors.paletteGreen,
    ),
    PipelineStage(
      title: "RTO Process (RTO Person)",
      count: 2,
      todayCount: 0,
      newBadge: "+2 New",
      icon: Icons.commute_outlined,
      iconColor: AppColors.paletteBlue,
      iconBg: AppColors.paletteBlue,
    ),
    PipelineStage(
      title: "RTO Done",
      count: 11,
      todayCount: 0,
      icon: Icons.assignment_turned_in_outlined,
      iconColor: AppColors.paletteGreen,
      iconBg: AppColors.paletteGreen,
    ),
    PipelineStage(
      title: "Payment Requested",
      count: 1,
      todayCount: 0,
      icon: Icons.payments_outlined,
      iconColor: AppColors.paletteOrange,
      iconBg: AppColors.paletteOrange,
    ),
    PipelineStage(
      title: "Payment In Process",
      count: 1,
      todayCount: 0,
      icon: Icons.hourglass_top_outlined,
      iconColor: AppColors.paletteCyan,
      iconBg: AppColors.paletteCyan,
    ),
    PipelineStage(
      title: "Payment Done (Accounts)",
      count: 0,
      todayCount: 0,
      icon: Icons.price_check_outlined,
      iconColor: AppColors.paletteGreen,
      iconBg: AppColors.paletteGreen,
    ),
    PipelineStage(
      title: "Vehicle Handover",
      count: 1,
      todayCount: 0,
      icon: Icons.key_outlined,
      iconColor: AppColors.palettePurple,
      iconBg: AppColors.palettePurple,
    ),
    PipelineStage(
      title: "PDD Pending",
      count: 1,
      todayCount: 0,
      icon: Icons.pending_actions_outlined,
      iconColor: AppColors.paletteOrange,
      iconBg: AppColors.paletteOrange,
    ),
    PipelineStage(
      title: "PDD Submitted",
      count: 2,
      todayCount: 0,
      icon: Icons.cloud_done_outlined,
      iconColor: AppColors.paletteCyan,
      iconBg: AppColors.paletteCyan,
    ),
    PipelineStage(
      title: "Case Completed",
      count: 1,
      todayCount: 0,
      icon: Icons.done_all_outlined,
      iconColor: AppColors.paletteGreen,
      iconBg: AppColors.paletteGreen,
    ),
    PipelineStage(
      title: "Case Cancellation",
      count: 3,
      todayCount: 0,
      icon: Icons.remove_circle_outline,
      iconColor: AppColors.neutralMuted,
      iconBg: AppColors.neutralMuted,
    ),
    PipelineStage(
      title: "Case Cancelled",
      count: 11,
      todayCount: 0,
      newBadge: "+7 New",
      icon: Icons.block_outlined,
      iconColor: AppColors.paletteRed,
      iconBg: AppColors.paletteRed,
    ),
  ];

  void _showCreateLeadModal() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CreateLoanLeadScreen(),
      ),
    );
  }

  void _onStageTap(PipelineStage stage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Viewing ${stage.title} (${stage.count} leads)"),
        backgroundColor: AppColors.heroNavyStart,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Widget _buildCategoryChip(LoanCategoryFilter cat) {
    final isActive = _activeCategory == cat.label;
    return InkWell(
      onTap: () => setState(() => _activeCategory = cat.label),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.heroNavyStart
              : (_isDarkMode
                  ? const Color(0xFF1E293B)
                  : AppColors.neutralBadgeBg),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive
                ? AppColors.heroNavyStart
                : (_isDarkMode
                    ? const Color(0xFF334155)
                    : AppColors.cardBorder),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              cat.label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive
                    ? Colors.white
                    : (_isDarkMode
                        ? Colors.grey.shade300
                        : AppColors.neutralText),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
              decoration: BoxDecoration(
                color: isActive
                    ? Colors.white.withValues(alpha: 0.2)
                    : (_isDarkMode
                        ? const Color(0xFF334155)
                        : AppColors.cardBorder),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "${cat.count}",
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isActive
                      ? Colors.white
                      : (_isDarkMode ? Colors.white70 : AppColors.neutralMuted),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LeadsViewModel>(
      builder: (context, vm, _) {
        final categories = _categoryLabels.map((label) {
          final count = label == "All"
              ? vm.leads.length
              : vm.leads.where((l) => _categoryForLead(l) == label).length;
          return LoanCategoryFilter(label: label, count: count);
        }).toList();

        final activeData = _computeDashboardData(vm.leads);
        final activeStages = _stages.map((stage) {
          return PipelineStage(
            title: stage.title,
            count: activeData.stageCounts[stage.title] ?? 0,
            todayCount: 0,
            icon: stage.icon,
            iconColor: stage.iconColor,
            iconBg: stage.iconBg,
          );
        }).toList();

        return Scaffold(
          backgroundColor:
              _isDarkMode ? const Color(0xFF0F172A) : AppColors.background,
          drawer: const CrmDrawer(),
          appBar: AppBar(
            backgroundColor:
                _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
            elevation: 0.5,
            leading: CustomBackButton(isDarkMode: _isDarkMode),
            title: Text(
              "Loan Leads",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _isDarkMode ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            actions: [
              const AdminProfileAvatar(),
              const SizedBox(width: 14),
            ],
          ),
          body: vm.isLoading && vm.leads.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                )
              : vm.errorMessage != null && vm.leads.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 44,
                              color: AppColors.paletteRed,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              vm.errorMessage!,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: _isDarkMode
                                    ? Colors.white70
                                    : const Color(0xFF334155),
                              ),
                            ),
                            const SizedBox(height: 14),
                            ElevatedButton.icon(
                              onPressed: vm.fetchLeads,
                              icon: const Icon(Icons.refresh, size: 16),
                              label: const Text("Retry"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.heroNavyStart,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : vm.leads.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.people_outline,
                                  size: 44,
                                  color: _isDarkMode
                                      ? Colors.grey.shade600
                                      : Colors.grey.shade400,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "No Loan Leads Found",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: _isDarkMode
                                        ? Colors.grey.shade400
                                        : Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton.icon(
                                  onPressed: vm.fetchLeads,
                                  icon: const Icon(Icons.refresh, size: 16),
                                  label: const Text("Refresh"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.heroNavyStart,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Fixed Top Section (Live Sync, Create Lead, and Filters)
                            Container(
                              color: _isDarkMode
                                  ? const Color(0xFF0F172A)
                                  : AppColors.background,
                              padding: const EdgeInsets.only(
                                  left: 14, right: 14, top: 14, bottom: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 1. Header: "Live Sync" (Left) & "+ Create Lead" (Right)
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: _handleLiveSync,
                                          icon: _isSyncing
                                              ? SizedBox(
                                                  width: 14,
                                                  height: 14,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    color: _isDarkMode
                                                        ? const Color(
                                                            0xFF60A5FA)
                                                        : AppColors
                                                            .heroNavyStart,
                                                  ),
                                                )
                                              : Icon(
                                                  Icons.sync,
                                                  size: 16,
                                                  color: _isDarkMode
                                                      ? const Color(0xFF60A5FA)
                                                      : AppColors.heroNavyStart,
                                                ),
                                          label: Text(
                                            "Live Sync",
                                            style: GoogleFonts.poppins(
                                              fontSize: 12.5,
                                              fontWeight: FontWeight.w600,
                                              color: _isDarkMode
                                                  ? const Color(0xFF60A5FA)
                                                  : AppColors.heroNavyStart,
                                            ),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor: _isDarkMode
                                                ? const Color(0xFF1E293B)
                                                : Colors.white,
                                            side: BorderSide(
                                              color: _isDarkMode
                                                  ? const Color(0xFF60A5FA)
                                                  : AppColors.heroNavyStart,
                                              width: 1.2,
                                            ),
                                            elevation: 0,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 10),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          onPressed: _showCreateLeadModal,
                                          icon: const Icon(Icons.add,
                                              size: 16, color: Colors.white),
                                          label: Text(
                                            "Create Lead",
                                            style: GoogleFonts.poppins(
                                              fontSize: 12.5,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColors.heroNavyStart,
                                            elevation: 0,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 10),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  // 2. Filters Section (Expandable on tap)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                _isFiltersExpanded =
                                                    !_isFiltersExpanded;
                                              });
                                            },
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4,
                                                      horizontal: 2),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.filter_alt_outlined,
                                                    size: 16,
                                                    color: _isDarkMode
                                                        ? Colors.grey.shade400
                                                        : const Color(
                                                            0xFF64748B),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    "Filters:",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: _isDarkMode
                                                          ? Colors.grey.shade400
                                                          : const Color(
                                                              0xFF64748B),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 2),
                                                  Icon(
                                                    _isFiltersExpanded
                                                        ? Icons
                                                            .keyboard_arrow_up_rounded
                                                        : Icons
                                                            .keyboard_arrow_down_rounded,
                                                    size: 18,
                                                    color: _isDarkMode
                                                        ? Colors.grey.shade400
                                                        : const Color(
                                                            0xFF64748B),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          if (!_isFiltersExpanded) ...[
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  children:
                                                      categories.map((cat) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 8),
                                                      child: _buildCategoryChip(
                                                          cat),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      if (_isFiltersExpanded) ...[
                                        const SizedBox(height: 10),
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: categories.map((cat) {
                                            return _buildCategoryChip(cat);
                                          }).toList(),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 14),

                                  // 3. INCOMING LEADS Section Title
                                  Text(
                                    "INCOMING LEADS (${activeData.incomingTotal})",
                                    style: GoogleFonts.poppins(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.bold,
                                      color: _isDarkMode
                                          ? Colors.white70
                                          : AppColors.sectionHeading,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  // Total New Leads Big Navy Banner
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 11),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          AppColors.heroNavyStart,
                                          AppColors.heroNavyEnd
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.heroNavyStart
                                              .withValues(alpha: 0.25),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "TOTAL NEW LEADS",
                                              style: GoogleFonts.poppins(
                                                fontSize: 10.5,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white
                                                    .withValues(alpha: 0.9),
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 7,
                                                      vertical: 1.5),
                                              decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withValues(alpha: 0.2),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                activeData.incomingNew > 0
                                                    ? "+${activeData.incomingNew} New"
                                                    : "0 New",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 9.5,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "${activeData.incomingTotal}",
                                          style: GoogleFonts.poppins(
                                            fontSize: 26,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            height: 1.1,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Divider(
                                          height: 1,
                                          thickness: 1,
                                          color: Colors.white
                                              .withValues(alpha: 0.2),
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Today",
                                              style: GoogleFonts.poppins(
                                                fontSize: 11,
                                                color: Colors.white
                                                    .withValues(alpha: 0.85),
                                              ),
                                            ),
                                            Text(
                                              "0",
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Scrollable Content Below
                            Expanded(
                              child: RefreshIndicator(
                                color: AppColors.primary,
                                onRefresh: vm.fetchLeads,
                                child: SingleChildScrollView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding: const EdgeInsets.only(
                                      left: 14, right: 14, top: 4, bottom: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // 3 Incoming Sub-Cards Row: WEB ENQUIRY, CALLBACK, MANUAL
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _buildIncomingSubCard(
                                              title: "WEB ENQUIRY",
                                              titleColor: _isDarkMode
                                                  ? Colors.grey.shade300
                                                  : AppColors.sectionHeading,
                                              count: activeData.webEnquiry,
                                              pillText: activeData
                                                          .webEnquiryNew >
                                                      0
                                                  ? "+${activeData.webEnquiryNew} New"
                                                  : "0 New",
                                              todayCount: 0,
                                              newCount:
                                                  activeData.webEnquiryNew,
                                              newColor: AppColors.paletteGreen,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: _buildIncomingSubCard(
                                              title: "CALLBACK",
                                              titleColor: _isDarkMode
                                                  ? Colors.grey.shade300
                                                  : AppColors.sectionHeading,
                                              count: activeData.callback,
                                              pillText: activeData.callbackNew >
                                                      0
                                                  ? "+${activeData.callbackNew} New"
                                                  : "0 New",
                                              todayCount: 0,
                                              newCount: activeData.callbackNew,
                                              newColor: AppColors.paletteOrange,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: _buildIncomingSubCard(
                                              title: "MANUAL",
                                              titleColor: _isDarkMode
                                                  ? Colors.grey.shade300
                                                  : AppColors.sectionHeading,
                                              count: activeData.manual,
                                              pillText: activeData.manualNew > 0
                                                  ? "+${activeData.manualNew} New"
                                                  : "0 New",
                                              todayCount: 0,
                                              newCount: activeData.manualNew,
                                              newColor: AppColors.paletteBlue,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),

                                      // 4. PROCESSING PIPELINE Section
                                      Text(
                                        "PROCESSING PIPELINE (${activeData.pipelineTotal})",
                                        style: GoogleFonts.poppins(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.bold,
                                          color: _isDarkMode
                                              ? Colors.white70
                                              : AppColors.sectionHeading,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      const SizedBox(height: 10),

                                      // 2-Column Grid of Pipeline Stages
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount:
                                            (activeStages.length / 2).ceil(),
                                        itemBuilder: (ctx, rowIndex) {
                                          final leftIndex = rowIndex * 2;
                                          final rightIndex = leftIndex + 1;

                                          final leftStage =
                                              activeStages[leftIndex];
                                          final rightStage =
                                              rightIndex < activeStages.length
                                                  ? activeStages[rightIndex]
                                                  : null;

                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    child: _buildStageCard(
                                                        leftStage)),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: rightStage != null
                                                      ? _buildStageCard(
                                                          rightStage)
                                                      : const SizedBox(),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
        );
      },
    );
  }

  // Incoming Leads 3 Small Cards Widget
  Widget _buildIncomingSubCard({
    required String title,
    required Color titleColor,
    required int count,
    required String pillText,
    required int todayCount,
    required int newCount,
    required Color newColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isDarkMode ? const Color(0xFF334155) : AppColors.cardBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: _isDarkMode ? 0.2 : 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 9.5,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$count",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: newColor,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                decoration: BoxDecoration(
                  color: newColor.withValues(alpha: _isDarkMode ? 0.2 : 0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  pillText,
                  style: GoogleFonts.poppins(
                    fontSize: 8.5,
                    fontWeight: FontWeight.w600,
                    color: newColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Divider(
            height: 1,
            thickness: 1,
            color:
                _isDarkMode ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Today: $todayCount",
                style: GoogleFonts.poppins(
                  fontSize: 9,
                  color: _isDarkMode
                      ? Colors.grey.shade400
                      : const Color(0xFF64748B),
                ),
              ),
              Text(
                "New: $newCount",
                style: GoogleFonts.poppins(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: newColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Processing Pipeline Stage Card (2-Column Grid Item)
  Widget _buildStageCard(PipelineStage stage) {
    return InkWell(
      onTap: () => _onStageTap(stage),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isDarkMode ? const Color(0xFF334155) : AppColors.cardBorder,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: _isDarkMode ? 0.2 : 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Icon Box + Stage Name + Count
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: stage.iconColor
                        .withValues(alpha: _isDarkMode ? 0.2 : 0.12),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    stage.icon,
                    size: 13,
                    color: stage.iconColor,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    stage.title,
                    style: GoogleFonts.poppins(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      color:
                          _isDarkMode ? Colors.white : const Color(0xFF0F172A),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  "${stage.count}",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: stage.iconColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Divider(
              height: 1,
              thickness: 1,
              color: _isDarkMode
                  ? const Color(0xFF334155)
                  : const Color(0xFFF1F5F9),
            ),
            const SizedBox(height: 4),
            // Bottom Row: Today: 0  +  Optional Red Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Today: ${stage.todayCount}",
                  style: GoogleFonts.poppins(
                    fontSize: 9,
                    color: _isDarkMode
                        ? Colors.grey.shade400
                        : const Color(0xFF64748B),
                  ),
                ),
                if (stage.newBadge != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                    decoration: BoxDecoration(
                      color: stage.iconColor
                          .withValues(alpha: _isDarkMode ? 0.2 : 0.12),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      stage.newBadge!,
                      style: GoogleFonts.poppins(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: stage.iconColor,
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
}
