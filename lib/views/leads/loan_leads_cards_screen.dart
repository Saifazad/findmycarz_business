import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../models/crm_lead_model.dart';
import '../../viewmodels/leads_viewmodel.dart';
import '../widgets/admin_profile_avatar.dart';
import '../widgets/crm_drawer.dart';
import '../widgets/custom_back_button.dart';
import 'create_loan_lead_screen.dart';
import 'edit_loan_lead_screen.dart';
import 'leads_list_screen.dart';

class LoanLeadsCardsScreen extends StatefulWidget {
  final String initialType;
  final bool loggedInOnly;

  const LoanLeadsCardsScreen({
    super.key,
    this.initialType = "All",
    this.loggedInOnly = false,
  });

  @override
  State<LoanLeadsCardsScreen> createState() => _LoanLeadsCardsScreenState();
}

class _LoanLeadsCardsScreenState extends State<LoanLeadsCardsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  late bool _loggedInOnly;
  late String _categoryFilter;
  String _rtoFilter = "all"; // "all", "running", "unassigned"
  bool _sortNewestFirst = true;

  @override
  void initState() {
    super.initState();
    _loggedInOnly = widget.loggedInOnly;
    _categoryFilter = widget.initialType;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final vm = context.read<LeadsViewModel>();
        if (vm.leads.isEmpty) {
          vm.fetchLeads();
        }
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _matchesCategory(CrmLeadModel lead) {
    final t = _categoryFilter.trim().toLowerCase();
    if (t.isEmpty || t == "all") return true;
    final raw = lead.rawLoanType.toLowerCase();
    final label = lead.type.toLowerCase();
    if (t.contains("used car")) {
      return raw == "used_car_loan" || label.contains("used car");
    }
    if (t.contains("new car")) {
      return raw == "new_car_loan" || label.contains("new car");
    }
    if (t.contains("bt") || t.contains("top")) {
      return raw == "bt_topup_loan" || label.contains("bt");
    }
    if (t.contains("refinance")) {
      return raw == "car_loan_refinance" || label.contains("refinance");
    }
    if (t.contains("personal")) {
      return raw == "personal_loan" || label.contains("personal");
    }
    if (t.contains("business")) {
      return raw == "business_loan" || label.contains("business");
    }
    if (t.contains("home")) {
      return raw == "home_loan" || label.contains("home");
    }
    if (t.contains("property") || t.contains("lap")) {
      return raw.contains("property") ||
          raw.contains("properties") ||
          label.contains("property");
    }
    return label.contains(t) || raw.contains(t);
  }

  bool _isLoggedInLead(CrmLeadModel lead) {
    final rs = lead.rawStatus.toUpperCase();
    final s = lead.status.toLowerCase();
    return rs == 'UNDER_PROCESS' ||
        rs == 'SENT_TO_BANK' ||
        rs == 'LOGIN' ||
        s.contains('login') ||
        s.contains('sent to bank') ||
        s.contains('under process');
  }

  bool _isRunningRto(CrmLeadModel lead) {
    final rs = lead.rawStatus.toUpperCase();
    final s = lead.status.toLowerCase();
    if (rs == 'RTO_PROCESS' || s.contains('rto process')) return true;
    return rs.contains('RTO') &&
        !rs.contains('DONE') &&
        !rs.contains('COMPLETE') &&
        !rs.contains('CANCEL') &&
        !rs.contains('REJECT');
  }

  bool _isUnassigned(CrmLeadModel lead) {
    return lead.assignedTo == null || lead.assignedTo!.trim().isEmpty;
  }

  List<CrmLeadModel> _filterLeads(List<CrmLeadModel> all) {
    var list = all.where(_matchesCategory).toList();
    if (_loggedInOnly) {
      list = list.where(_isLoggedInLead).toList();
    }
    if (_rtoFilter == "running") {
      list = list.where(_isRunningRto).toList();
    } else if (_rtoFilter == "unassigned") {
      list = list.where((l) => _isRunningRto(l) && _isUnassigned(l)).toList();
    }
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.trim().toLowerCase();
      list = list.where((l) {
        return (l.leadCode ?? l.id).toLowerCase().contains(q) ||
            l.name.toLowerCase().contains(q) ||
            l.phone.toLowerCase().contains(q) ||
            (l.email ?? '').toLowerCase().contains(q) ||
            (l.carName ?? '').toLowerCase().contains(q) ||
            l.status.toLowerCase().contains(q);
      }).toList();
    }
    if (!_sortNewestFirst) {
      list = list.reversed.toList();
    }
    return list;
  }

  String _formatCurrency(double? value, {bool decimals = false}) {
    final amount = value ?? 0;
    final intVal = amount.round();
    final str = intVal.toString();
    final formatted = _formatIndianNumber(str);
    return decimals ? "₹$formatted.00" : "₹$formatted";
  }

  String _formatIndianNumber(String digits) {
    if (digits.length <= 3) return digits;
    final last3 = digits.substring(digits.length - 3);
    var rest = digits.substring(0, digits.length - 3);
    final parts = <String>[];
    while (rest.length > 2) {
      parts.insert(0, rest.substring(rest.length - 2));
      rest = rest.substring(0, rest.length - 2);
    }
    if (rest.isNotEmpty) parts.insert(0, rest);
    return "${parts.join(',')},$last3";
  }

  Color _statusColor(String status) {
    final s = status.toLowerCase();
    if (s.contains('disburs') || s.contains('approv') || s.contains('complet')) {
      return const Color(0xFF059669);
    }
    if (s.contains('reject') || s.contains('cancel')) {
      return const Color(0xFFDC2626);
    }
    if (s.contains('login') || s.contains('bank') || s.contains('rto')) {
      return const Color(0xFFD97706);
    }
    return AppColors.primary;
  }

  void _showRemarksDialog(CrmLeadModel lead) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text(
          "Lead Notes (#${lead.leadCode ?? lead.id})",
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0F172A),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lead.name,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              (lead.remarks != null && lead.remarks!.trim().isNotEmpty)
                  ? lead.remarks!
                  : "No remarks added yet.",
              style: GoogleFonts.poppins(
                fontSize: 12.5,
                color: const Color(0xFF475569),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LeadsViewModel>(
      builder: (context, vm, _) {
        final categoryLeads = vm.leads.where(_matchesCategory).toList();
        final filtered = _filterLeads(vm.leads);
        final runningLeads = categoryLeads.where(_isRunningRto).toList();
        final runningCount = runningLeads.length;
        final unassignedCount = runningLeads.where(_isUnassigned).length;

        final activeFilterCount = (_loggedInOnly ? 1 : 0) +
            (_categoryFilter.trim().toLowerCase() != "all" ? 1 : 0) +
            (_rtoFilter != "all" ? 1 : 0);

        return Scaffold(
          backgroundColor: AppColors.background,
          drawer: const CrmDrawer(),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.5,
            leading: const CustomBackButton(isDarkMode: false),
            title: Text(
              "Leads",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0F172A),
              ),
            ),
            actions: const [
              AdminProfileAvatar(),
              SizedBox(width: 14),
            ],
          ),
          body: Column(
            children: [
              // Top Controls
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Search Bar + Filter Button
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (val) =>
                                setState(() => _searchQuery = val),
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: const Color(0xFF0F172A),
                            ),
                            decoration: InputDecoration(
                              hintText: "Search leads...",
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 13,
                                color: const Color(0xFF94A3B8),
                              ),
                              prefixIcon: const Icon(
                                Icons.search,
                                size: 20,
                                color: Color(0xFF64748B),
                              ),
                              suffixIcon: _searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.cancel_outlined,
                                          size: 18, color: Color(0xFF94A3B8)),
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(() => _searchQuery = "");
                                      },
                                    )
                                  : null,
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
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: _showFilterSheet,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 44,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: activeFilterCount > 0
                                  ? const Color(0xFFEFF6FF)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: activeFilterCount > 0
                                    ? AppColors.primary
                                    : const Color(0xFFE2E8F0),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.tune_rounded,
                                  size: 16,
                                  color: activeFilterCount > 0
                                      ? AppColors.primary
                                      : const Color(0xFF334155),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  activeFilterCount > 0
                                      ? "Filter ($activeFilterCount)"
                                      : "Filter",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: activeFilterCount > 0
                                        ? AppColors.primary
                                        : const Color(0xFF0F172A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // 2. Action Buttons Row: + Create Lead | Export | Pipeline
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const CreateLoanLeadScreen(),
                                  ),
                                );
                              },
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
                                backgroundColor: AppColors.primary,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "Exporting ${filtered.length} leads..."),
                                    backgroundColor: AppColors.primary,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.download_outlined,
                                  size: 16, color: AppColors.primary),
                              label: Text(
                                "Export",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white,
                                side:
                                    const BorderSide(color: AppColors.primary),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LeadsListScreen(
                                    initialType: _categoryFilter),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.account_tree_outlined,
                              size: 18,
                              color: Color(0xFF334155),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // 3. Active Filter Chips + Clear all
                    if (activeFilterCount > 0 || _searchQuery.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: [
                                if (_loggedInOnly)
                                  _buildActiveFilterChip(
                                    label: "Stage: Login",
                                    onRemove: () =>
                                        setState(() => _loggedInOnly = false),
                                  ),
                                if (_categoryFilter.trim().toLowerCase() !=
                                    "all")
                                  _buildActiveFilterChip(
                                    label: _categoryFilter,
                                    onRemove: () =>
                                        setState(() => _categoryFilter = "All"),
                                  ),
                                if (_rtoFilter != "all")
                                  _buildActiveFilterChip(
                                    label: _rtoFilter == "running"
                                        ? "RTO: Running"
                                        : "RTO: Unassigned",
                                    onRemove: () =>
                                        setState(() => _rtoFilter = "all"),
                                  ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = "";
                                _loggedInOnly = false;
                                _categoryFilter = "All";
                                _rtoFilter = "all";
                              });
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              "Clear all",
                              style: GoogleFonts.poppins(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 10),

                    // 4. RTO Agents • Running Cases Bar
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.sync_alt_rounded,
                                  size: 14, color: Color(0xFF059669)),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  "RTO Agents • Running Cases",
                                  style: GoogleFonts.poppins(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF0F172A),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          "Downloading CSV for ${filtered.length} leads..."),
                                      backgroundColor: AppColors.primary,
                                    ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(6),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                        color: const Color(0xFFE2E8F0)),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.download_outlined,
                                          size: 12, color: Color(0xFF475569)),
                                      const SizedBox(width: 4),
                                      Text(
                                        "CSV",
                                        style: GoogleFonts.poppins(
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF475569),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () => setState(() {
                                    _rtoFilter = _rtoFilter == "running"
                                        ? "all"
                                        : "running";
                                  }),
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 7),
                                    decoration: BoxDecoration(
                                      color: _rtoFilter == "running"
                                          ? const Color(0xFFD1FAE5)
                                          : const Color(0xFFECFDF5),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: _rtoFilter == "running"
                                            ? const Color(0xFF059669)
                                            : const Color(0xFFA7F3D0),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "All Running",
                                          style: GoogleFonts.poppins(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF047857),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 1),
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF059669),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Text(
                                            "$runningCount",
                                            style: GoogleFonts.poppins(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: InkWell(
                                  onTap: () => setState(() {
                                    _rtoFilter = _rtoFilter == "unassigned"
                                        ? "all"
                                        : "unassigned";
                                  }),
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 7),
                                    decoration: BoxDecoration(
                                      color: _rtoFilter == "unassigned"
                                          ? const Color(0xFFFEE2E2)
                                          : const Color(0xFFFEF2F2),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: _rtoFilter == "unassigned"
                                            ? const Color(0xFFDC2626)
                                            : const Color(0xFFFECACA),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                                Icons.warning_amber_rounded,
                                                size: 13,
                                                color: Color(0xFFDC2626)),
                                            const SizedBox(width: 4),
                                            Text(
                                              "Unassigned",
                                              style: GoogleFonts.poppins(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFFB91C1C),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 1),
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFDC2626),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Text(
                                            "$unassignedCount",
                                            style: GoogleFonts.poppins(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // 5. FILTERED RESULTS Header + Sort Toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "FILTERED RESULTS",
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.4,
                                color: const Color(0xFF475569),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 1),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE2E8F0),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "${filtered.length}",
                                style: GoogleFonts.poppins(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () => setState(
                              () => _sortNewestFirst = !_sortNewestFirst),
                          borderRadius: BorderRadius.circular(6),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 2),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.swap_vert_rounded,
                                    size: 13, color: Color(0xFF64748B)),
                                const SizedBox(width: 3),
                                Text(
                                  _sortNewestFirst
                                      ? "Sort: Updated"
                                      : "Sort: Oldest",
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Body List (Loading / Error / Empty / Cards)
              Expanded(
                child: vm.isLoading && vm.leads.isEmpty
                    ? const Center(
                        child:
                            CircularProgressIndicator(color: AppColors.primary),
                      )
                    : vm.errorMessage != null && vm.leads.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.error_outline,
                                      size: 42, color: Color(0xFFDC2626)),
                                  const SizedBox(height: 10),
                                  Text(
                                    vm.errorMessage!,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: const Color(0xFF334155),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  ElevatedButton.icon(
                                    onPressed: vm.fetchLeads,
                                    icon: const Icon(Icons.refresh, size: 16),
                                    label: const Text("Retry"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : filtered.isEmpty
                            ? Center(
                                child: Text(
                                  "No Loan Leads Found",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                              )
                            : RefreshIndicator(
                                color: AppColors.primary,
                                onRefresh: vm.fetchLeads,
                                child: ListView.builder(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding:
                                      const EdgeInsets.fromLTRB(14, 0, 14, 16),
                                  itemCount: filtered.length,
                                  itemBuilder: (ctx, index) =>
                                      _buildLeadCard(vm, filtered[index]),
                                ),
                              ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLeadCard(LeadsViewModel vm, CrmLeadModel lead) {
    final statusCol = _statusColor(lead.status);
    final code = (lead.leadCode != null && lead.leadCode!.isNotEmpty)
        ? "#${lead.leadCode}"
        : "#${lead.id}";
    final customerName =
        lead.name.trim().isNotEmpty ? lead.name.trim() : 'Customer';
    final emailText = (lead.email != null &&
            lead.email!.trim().isNotEmpty &&
            lead.email!.toLowerCase() != 'null')
        ? lead.email!.trim()
        : '--';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 3.5,
              decoration: BoxDecoration(
                color: statusCol,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(14),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row 1: #Code • Name + Status Pill + Date
                    Row(
                      children: [
                        Expanded(
                          child: RichText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: code,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                                TextSpan(
                                  text: "  •  ",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: const Color(0xFF94A3B8),
                                  ),
                                ),
                                TextSpan(
                                  text: customerName,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF0F172A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: statusCol.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: statusCol,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                lead.status,
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: statusCol,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 85),
                          child: Text(
                            lead.createdAt,
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: const Color(0xFF64748B),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Inner Info Box: REQUESTED LOAN (Left) + PRIMARY MOBILE (Right)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "REQUESTED LOAN",
                                  style: GoogleFonts.poppins(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.4,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _formatCurrency(lead.amount),
                                  style: GoogleFonts.poppins(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF0F172A),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  lead.type,
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: const Color(0xFF64748B),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "PRIMARY MOBILE",
                                  style: GoogleFonts.poppins(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.4,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.verified_outlined,
                                      size: 13,
                                      color: Color(0xFF059669),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        lead.phone.isNotEmpty
                                            ? lead.phone
                                            : '--',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF0F172A),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  emailText,
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: const Color(0xFF64748B),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Action Buttons Row: Call, Note, WhatsApp, Edit, Delete
                    Row(
                      children: [
                        Expanded(
                          child: _buildActionBtn(
                            icon: Icons.call_outlined,
                            bg: AppColors.primary,
                            fg: Colors.white,
                            onTap: () => vm.makePhoneCall(lead.phone),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildActionBtn(
                            icon: Icons.history,
                            bg: const Color(0xFFF1F5F9),
                            fg: const Color(0xFF334155),
                            onTap: () => _showRemarksDialog(lead),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildActionBtn(
                            icon: Icons.chat_outlined,
                            bg: const Color(0xFF059669),
                            fg: Colors.white,
                            onTap: () => vm.openWhatsApp(lead.phone, lead.name),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildActionBtn(
                          icon: Icons.edit_outlined,
                          bg: const Color(0xFFFFFBEB),
                          fg: const Color(0xFFD97706),
                          width: 40,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditLoanLeadScreen(lead: lead),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildActionBtn(
                          icon: Icons.delete_outline,
                          bg: const Color(0xFFFEF2F2),
                          fg: const Color(0xFFDC2626),
                          width: 40,
                          onTap: () {
                            showDialog<void>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                backgroundColor: Colors.white,
                                title: const Text("Delete Lead"),
                                content: Text(
                                    "Are you sure you want to delete lead $code?"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: const Text("Cancel"),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFDC2626),
                                      foregroundColor: Colors.white,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(ctx);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text("Lead $code deleted"),
                                          backgroundColor:
                                              const Color(0xFFDC2626),
                                        ),
                                      );
                                    },
                                    child: const Text("Delete"),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveFilterChip({
    required String label,
    required VoidCallback onRemove,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF334155),
            ),
          ),
          const SizedBox(width: 5),
          InkWell(
            onTap: onRemove,
            child: const Icon(
              Icons.close,
              size: 13,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Filter Leads",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _loggedInOnly = false;
                            _categoryFilter = "All";
                            _rtoFilter = "all";
                          });
                          Navigator.pop(ctx);
                        },
                        child: Text(
                          "Reset",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    activeThumbColor: AppColors.primary,
                    title: Text(
                      "Logged In Stage Only",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    value: _loggedInOnly,
                    onChanged: (val) {
                      setSheetState(() {});
                      setState(() => _loggedInOnly = val);
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "RTO Running Cases",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF475569),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text("All"),
                        selected: _rtoFilter == "all",
                        selectedColor: const Color(0xFFEFF6FF),
                        onSelected: (_) {
                          setSheetState(() {});
                          setState(() => _rtoFilter = "all");
                        },
                      ),
                      ChoiceChip(
                        label: const Text("All Running"),
                        selected: _rtoFilter == "running",
                        selectedColor: const Color(0xFFECFDF5),
                        onSelected: (_) {
                          setSheetState(() {});
                          setState(() => _rtoFilter = "running");
                        },
                      ),
                      ChoiceChip(
                        label: const Text("Unassigned"),
                        selected: _rtoFilter == "unassigned",
                        selectedColor: const Color(0xFFFEF2F2),
                        onSelected: (_) {
                          setSheetState(() {});
                          setState(() => _rtoFilter = "unassigned");
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Apply Filters",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
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

  Widget _buildActionBtn({
    required IconData icon,
    required Color bg,
    required Color fg,
    required VoidCallback onTap,
    double? width,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: width,
        height: 36,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 17, color: fg),
      ),
    );
  }
}
