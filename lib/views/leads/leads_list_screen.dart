import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
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

class LeadsListScreen extends StatefulWidget {
  final String? initialType;
  const LeadsListScreen({super.key, this.initialType});

  @override
  State<LeadsListScreen> createState() => _LeadsListScreenState();
}

class _LeadsListScreenState extends State<LeadsListScreen> {
  bool _isDarkMode = false;
  String _activeCategory = "All";
  bool _isSyncing = false;
  bool _isFiltersExpanded = false;

  void _handleLiveSync() async {
    if (_isSyncing) return;
    setState(() {
      _isSyncing = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Leads live sync completed"),
        backgroundColor: AppColors.heroNavyStart,
        duration: Duration(milliseconds: 900),
      ),
    );
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {
        _isSyncing = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialType != null && widget.initialType!.isNotEmpty) {
      final initial = widget.initialType!.toLowerCase();
      for (final cat in _categories) {
        if (cat.label.toLowerCase().contains(initial) ||
            initial.contains(cat.label.toLowerCase())) {
          _activeCategory = cat.label;
          break;
        }
      }
    }
  }

  final List<LoanCategoryFilter> _categories = const [
    LoanCategoryFilter(label: "All", count: 68),
    LoanCategoryFilter(label: "Used Car - Sale Purchase", count: 43),
    LoanCategoryFilter(label: "New Car Loan", count: 2),
    LoanCategoryFilter(label: "Bt Topup Loan", count: 14),
    LoanCategoryFilter(label: "Car Loan Refinance", count: 4),
    LoanCategoryFilter(label: "Business Loan", count: 1),
    LoanCategoryFilter(label: "Home Loan", count: 1),
    LoanCategoryFilter(label: "Loan Against Property", count: 1),
    LoanCategoryFilter(label: "Personal Loan", count: 2),
  ];

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
                      : (_isDarkMode
                          ? Colors.white70
                          : AppColors.neutralMuted),
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
    return Scaffold(
      backgroundColor:
          _isDarkMode ? const Color(0xFF0F172A) : AppColors.background,
      drawer: const CrmDrawer(),
      appBar: AppBar(
        backgroundColor: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
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
          IconButton(
            tooltip:
                _isDarkMode ? "Switch to Light Mode" : "Switch to Dark Mode",
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fixed Top Section (Live Sync, Create Lead, and Filters)
          Container(
            color:
                _isDarkMode ? const Color(0xFF0F172A) : AppColors.background,
            padding:
                const EdgeInsets.only(left: 14, right: 14, top: 14, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header: "Live Sync" (Left) & "+ Create Lead" (Right)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton.icon(
                        onPressed: _handleLiveSync,
                        icon: _isSyncing
                            ? SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: _isDarkMode
                                      ? const Color(0xFF60A5FA)
                                      : AppColors.heroNavyStart,
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
                            fontSize: 12,
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
                              horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _showCreateLeadModal,
                        icon: const Icon(Icons.add,
                            size: 16, color: Colors.white),
                        label: Text(
                          "Create Lead",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.heroNavyStart,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // 2. Filters Section (Expandable on tap)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _isFiltersExpanded = !_isFiltersExpanded;
                            });
                          },
                          borderRadius: BorderRadius.circular(6),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 2),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.filter_alt_outlined,
                                  size: 16,
                                  color: _isDarkMode
                                      ? Colors.grey.shade400
                                      : const Color(0xFF64748B),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "Filters:",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: _isDarkMode
                                        ? Colors.grey.shade400
                                        : const Color(0xFF64748B),
                                  ),
                                ),
                                const SizedBox(width: 2),
                                Icon(
                                  _isFiltersExpanded
                                      ? Icons.keyboard_arrow_up_rounded
                                      : Icons.keyboard_arrow_down_rounded,
                                  size: 18,
                                  color: _isDarkMode
                                      ? Colors.grey.shade400
                                      : const Color(0xFF64748B),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (!_isFiltersExpanded) ...[
                          const SizedBox(width: 6),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: _categories.map((cat) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: _buildCategoryChip(cat),
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
                        children: _categories.map((cat) {
                          return _buildCategoryChip(cat);
                        }).toList(),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 14),

                // 3. INCOMING LEADS Section Title
                Text(
                  "INCOMING LEADS (7)",
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
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.heroNavyStart, AppColors.heroNavyEnd],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.heroNavyStart.withValues(alpha: 0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "TOTAL NEW LEADS",
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withValues(alpha: 0.9),
                              letterSpacing: 0.5,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "+7 New",
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "7",
                        style: GoogleFonts.poppins(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Today",
                            style: GoogleFonts.poppins(
                              fontSize: 11.5,
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
                          ),
                          Text(
                            "0",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                  left: 14, right: 14, top: 4, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                          count: 1,
                          pillText: "+1 New",
                          todayCount: 0,
                          newCount: 1,
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
                          count: 3,
                          pillText: "+3 New",
                          todayCount: 0,
                          newCount: 3,
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
                          count: 3,
                          pillText: "+3 New",
                          todayCount: 0,
                          newCount: 3,
                          newColor: AppColors.paletteBlue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 4. PROCESSING PIPELINE (61) Section
                  Text(
                    "PROCESSING PIPELINE (61)",
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
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: (_stages.length / 2).ceil(),
                    itemBuilder: (ctx, rowIndex) {
                      final leftIndex = rowIndex * 2;
                      final rightIndex = leftIndex + 1;

                      final leftStage = _stages[leftIndex];
                      final rightStage = rightIndex < _stages.length
                          ? _stages[rightIndex]
                          : null;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Expanded(child: _buildStageCard(leftStage)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: rightStage != null
                                  ? _buildStageCard(rightStage)
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
        ],
      ),
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
          color:
              _isDarkMode ? const Color(0xFF334155) : AppColors.cardBorder,
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
            color:
                _isDarkMode ? const Color(0xFF334155) : AppColors.cardBorder,
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
