import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/crm_drawer.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/admin_profile_avatar.dart';

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
        backgroundColor: Color(0xFF22C55E),
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
      iconColor: const Color(0xFF6366F1),
      iconBg: const Color(0xFFEEF2FF),
    ),
    PipelineStage(
      title: "Follow Up",
      count: 0,
      todayCount: 0,
      icon: Icons.phone_callback_outlined,
      iconColor: const Color(0xFFF59E0B),
      iconBg: const Color(0xFFFEF3C7),
    ),
    PipelineStage(
      title: "Pick Up",
      count: 1,
      todayCount: 0,
      icon: Icons.directions_car_outlined,
      iconColor: const Color(0xFFEAB308),
      iconBg: const Color(0xFFFEF9C3),
    ),
    PipelineStage(
      title: "Doc Pending",
      count: 3,
      todayCount: 0,
      icon: Icons.description_outlined,
      iconColor: const Color(0xFFEF4444),
      iconBg: const Color(0xFFFEE2E2),
    ),
    PipelineStage(
      title: "Doc Received",
      count: 0,
      todayCount: 0,
      icon: Icons.task_outlined,
      iconColor: const Color(0xFF8B5CF6),
      iconBg: const Color(0xFFF5F3FF),
    ),
    PipelineStage(
      title: "Sent to Bank",
      count: 2,
      todayCount: 0,
      newBadge: "+2 New",
      icon: Icons.account_balance_outlined,
      iconColor: const Color(0xFF0EA5E9),
      iconBg: const Color(0xFFE0F2FE),
    ),
    PipelineStage(
      title: "Login",
      count: 3,
      todayCount: 0,
      newBadge: "+1 New",
      icon: Icons.login_outlined,
      iconColor: const Color(0xFF3B82F6),
      iconBg: const Color(0xFFEFF6FF),
    ),
    PipelineStage(
      title: "Rejected",
      count: 3,
      todayCount: 0,
      icon: Icons.cancel_outlined,
      iconColor: const Color(0xFFEF4444),
      iconBg: const Color(0xFFFEE2E2),
    ),
    PipelineStage(
      title: "Approved",
      count: 1,
      todayCount: 0,
      icon: Icons.check_circle_outline,
      iconColor: const Color(0xFF10B981),
      iconBg: const Color(0xFFD1FAE5),
    ),
    PipelineStage(
      title: "Disbursed",
      count: 11,
      todayCount: 0,
      newBadge: "+2 New",
      icon: Icons.verified_outlined,
      iconColor: const Color(0xFF059669),
      iconBg: const Color(0xFFD1FAE5),
    ),
    PipelineStage(
      title: "RTO Process (RTO Person)",
      count: 2,
      todayCount: 0,
      newBadge: "+2 New",
      icon: Icons.commute_outlined,
      iconColor: const Color(0xFF2563EB),
      iconBg: const Color(0xFFDBEAFE),
    ),
    PipelineStage(
      title: "RTO Done",
      count: 11,
      todayCount: 0,
      icon: Icons.assignment_turned_in_outlined,
      iconColor: const Color(0xFF10B981),
      iconBg: const Color(0xFFD1FAE5),
    ),
    PipelineStage(
      title: "Payment Requested",
      count: 1,
      todayCount: 0,
      icon: Icons.payments_outlined,
      iconColor: const Color(0xFFD97706),
      iconBg: const Color(0xFFFEF3C7),
    ),
    PipelineStage(
      title: "Payment In Process",
      count: 1,
      todayCount: 0,
      icon: Icons.hourglass_top_outlined,
      iconColor: const Color(0xFF0284C7),
      iconBg: const Color(0xFFE0F2FE),
    ),
    PipelineStage(
      title: "Payment Done (Accounts)",
      count: 0,
      todayCount: 0,
      icon: Icons.price_check_outlined,
      iconColor: const Color(0xFF10B981),
      iconBg: const Color(0xFFD1FAE5),
    ),
    PipelineStage(
      title: "Vehicle Handover",
      count: 1,
      todayCount: 0,
      icon: Icons.key_outlined,
      iconColor: const Color(0xFF7C3AED),
      iconBg: const Color(0xFFEDE9FE),
    ),
    PipelineStage(
      title: "PDD Pending",
      count: 1,
      todayCount: 0,
      icon: Icons.pending_actions_outlined,
      iconColor: const Color(0xFFF97316),
      iconBg: const Color(0xFFFFEDD5),
    ),
    PipelineStage(
      title: "PDD Submitted",
      count: 2,
      todayCount: 0,
      icon: Icons.cloud_done_outlined,
      iconColor: const Color(0xFF0284C7),
      iconBg: const Color(0xFFE0F2FE),
    ),
    PipelineStage(
      title: "Case Completed",
      count: 1,
      todayCount: 0,
      icon: Icons.done_all_outlined,
      iconColor: const Color(0xFF16A34A),
      iconBg: const Color(0xFFDCFCE7),
    ),
    PipelineStage(
      title: "Case Cancellation",
      count: 3,
      todayCount: 0,
      icon: Icons.remove_circle_outline,
      iconColor: const Color(0xFF64748B),
      iconBg: const Color(0xFFF1F5F9),
    ),
    PipelineStage(
      title: "Case Cancelled",
      count: 11,
      todayCount: 0,
      newBadge: "+7 New",
      icon: Icons.block_outlined,
      iconColor: const Color(0xFFDC2626),
      iconBg: const Color(0xFFFEE2E2),
    ),
  ];

  void _showCreateLeadModal() {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    final vehicleCtrl = TextEditingController();
    String loanType = "Used Car Loan";
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(modalCtx).viewInsets.bottom + 20,
              ),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Create Loan Lead",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _isDarkMode
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            color:
                                _isDarkMode ? Colors.white70 : Colors.black54,
                            onPressed: () => Navigator.pop(ctx),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _buildFormField(
                        label: "Customer Name",
                        controller: nameCtrl,
                        hint: "e.g. Rahul Sharma",
                        validator: (val) => val == null || val.trim().isEmpty
                            ? "Required"
                            : null,
                      ),
                      const SizedBox(height: 12),
                      _buildFormField(
                        label: "Phone Number",
                        controller: phoneCtrl,
                        hint: "e.g. 9876543210",
                        validator: (val) => val == null || val.trim().isEmpty
                            ? "Required"
                            : null,
                      ),
                      const SizedBox(height: 12),
                      _buildFormField(
                        label: "Loan Amount (₹)",
                        controller: amountCtrl,
                        hint: "e.g. 500000",
                        validator: (val) => val == null || val.trim().isEmpty
                            ? "Required"
                            : null,
                      ),
                      const SizedBox(height: 12),
                      _buildFormField(
                        label: "Vehicle Interested",
                        controller: vehicleCtrl,
                        hint: "e.g. Hyundai Creta 2022",
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Loan Category",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _isDarkMode
                              ? Colors.white70
                              : const Color(0xFF334155),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _isDarkMode
                                ? const Color(0xFF475569)
                                : const Color(0xFFCBD5E1),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: loanType,
                            isExpanded: true,
                            dropdownColor: _isDarkMode
                                ? const Color(0xFF1E293B)
                                : Colors.white,
                            items: [
                              "Used Car Loan",
                              "New Car Loan",
                              "Loan Against Car",
                              "Refinance",
                              "Personal Loan"
                            ].map((c) {
                              return DropdownMenuItem(
                                value: c,
                                child: Text(
                                  c,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: _isDarkMode
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setModalState(() => loanType = val);
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        height: 46,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00A3FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            if (formKey.currentState?.validate() ?? false) {
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text("Loan lead created successfully!"),
                                  backgroundColor: Color(0xFF10B981),
                                ),
                              );
                            }
                          },
                          child: Text(
                            "Submit Lead",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    String? hint,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: _isDarkMode ? Colors.white70 : const Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: validator,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: _isDarkMode ? Colors.white : Colors.black87,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              fontSize: 13,
              color: _isDarkMode ? Colors.white38 : Colors.grey.shade400,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: _isDarkMode
                    ? const Color(0xFF475569)
                    : const Color(0xFFCBD5E1),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: _isDarkMode
                    ? const Color(0xFF475569)
                    : const Color(0xFFCBD5E1),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onStageTap(PipelineStage stage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Viewing ${stage.title} (${stage.count} leads)"),
        backgroundColor: const Color(0xFF00A3FF),
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
              ? const Color(0xFF1E293B)
              : (_isDarkMode
                  ? const Color(0xFF1E293B)
                  : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive
                ? const Color(0xFF1E293B)
                : (_isDarkMode
                    ? const Color(0xFF334155)
                    : const Color(0xFFE2E8F0)),
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
                        : const Color(0xFF334155)),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 6, vertical: 1.5),
              decoration: BoxDecoration(
                color: isActive
                    ? Colors.white.withValues(alpha: 0.2)
                    : (_isDarkMode
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0)),
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
                          : const Color(0xFF475569)),
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
          _isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFF22C55E),
                            ),
                          )
                        : const Icon(Icons.sync, size: 16, color: Color(0xFF22C55E)),
                    label: Text(
                      "Live Sync",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF22C55E),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: _isDarkMode
                          ? const Color(0xFF1E293B)
                          : Colors.white,
                      side: const BorderSide(color: Color(0xFF22C55E), width: 1.2),
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
                    icon: const Icon(Icons.add, size: 16, color: Colors.white),
                    label: Text(
                      "Create Lead",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00A3FF),
                      elevation: 0,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
            const SizedBox(height: 16),

            // 3. INCOMING LEADS Section
            Text(
              "INCOMING LEADS (7)",
              style: GoogleFonts.poppins(
                fontSize: 11.5,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0D9488),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10),

            // Total New Leads Big Purple Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4F46E5).withValues(alpha: 0.3),
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
            const SizedBox(height: 10),

            // 3 Incoming Sub-Cards Row: WEB ENQUIRY, CALLBACK, MANUAL
            Row(
              children: [
                Expanded(
                  child: _buildIncomingSubCard(
                    title: "WEB ENQUIRY",
                    titleColor: const Color(0xFF10B981),
                    count: 1,
                    pillText: "+1 New",
                    todayCount: 0,
                    newCount: 1,
                    newColor: const Color(0xFF10B981),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildIncomingSubCard(
                    title: "CALLBACK",
                    titleColor: const Color(0xFFD97706),
                    count: 3,
                    pillText: "+3 New",
                    todayCount: 0,
                    newCount: 3,
                    newColor: const Color(0xFFD97706),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildIncomingSubCard(
                    title: "MANUAL",
                    titleColor: const Color(0xFF00A3FF),
                    count: 3,
                    pillText: "+3 New",
                    todayCount: 0,
                    newCount: 3,
                    newColor: const Color(0xFF00A3FF),
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
                color: _isDarkMode ? Colors.white70 : const Color(0xFF334155),
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
                final rightStage =
                    rightIndex < _stages.length ? _stages[rightIndex] : null;

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
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color:
              _isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: _isDarkMode ? 0.2 : 0.02),
            blurRadius: 4,
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
                  color: _isDarkMode ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                decoration: BoxDecoration(
                  color: _isDarkMode
                      ? const Color(0xFF334155)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  pillText,
                  style: GoogleFonts.poppins(
                    fontSize: 8.5,
                    fontWeight: FontWeight.w600,
                    color:
                        _isDarkMode ? Colors.white70 : const Color(0xFF64748B),
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
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color:
                _isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: _isDarkMode ? 0.2 : 0.02),
              blurRadius: 4,
              offset: const Offset(0, 1),
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
                    color: _isDarkMode
                        ? stage.iconColor.withValues(alpha: 0.2)
                        : stage.iconBg,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  alignment: Alignment.center,
                  child: Icon(stage.icon, size: 13, color: stage.iconColor),
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
                    color: _isDarkMode ? Colors.white : const Color(0xFF0F172A),
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
                      color: const Color(0xFFDC2626), // Red pill
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      stage.newBadge!,
                      style: GoogleFonts.poppins(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
