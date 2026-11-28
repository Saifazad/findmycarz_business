import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/crm_lead_model.dart';
import '../../viewmodels/leads_viewmodel.dart';
import 'create_loan_lead_screen.dart';
import 'edit_loan_lead_screen.dart';

class LoginLeadsScreen extends StatefulWidget {
  final String loanType;
  final bool loggedInOnly;

  const LoginLeadsScreen({
    super.key,
    this.loanType = "Used Car Loan",
    this.loggedInOnly = true,
  });

  @override
  State<LoginLeadsScreen> createState() => _LoginLeadsScreenState();
}

class _LoginLeadsScreenState extends State<LoginLeadsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _selectedIds = {};
  String _searchQuery = "";
  String _activeChip = "all"; // "all", "running", "unassigned"

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<LeadsViewModel>().fetchLeads();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _matchesCategory(CrmLeadModel lead) {
    final t = widget.loanType.trim().toLowerCase();
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
    final categoryList = all.where(_matchesCategory).toList();
    List<CrmLeadModel> list;
    if (_activeChip == "running") {
      list = categoryList.where(_isRunningRto).toList();
    } else if (_activeChip == "unassigned") {
      list = categoryList
          .where((l) => _isRunningRto(l) && _isUnassigned(l))
          .toList();
    } else {
      list = widget.loggedInOnly
          ? categoryList.where(_isLoggedInLead).toList()
          : categoryList;
    }
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.trim().toLowerCase();
      list = list.where((l) {
        return (l.leadCode ?? l.id).toLowerCase().contains(q) ||
            l.name.toLowerCase().contains(q) ||
            l.phone.toLowerCase().contains(q) ||
            (l.email ?? '').toLowerCase().contains(q) ||
            l.type.toLowerCase().contains(q) ||
            l.status.toLowerCase().contains(q);
      }).toList();
    }
    return list;
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

  String _formatCurrency(double? value, {bool decimals = false}) {
    final amount = value ?? 0;
    final intVal = amount.round();
    final formatted = _formatIndianNumber(intVal.toString());
    return decimals ? "₹$formatted.00" : "₹$formatted";
  }

  void _showActionMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins(fontSize: 12.5)),
        backgroundColor: const Color(0xFF0284C7),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showRemarksDialog(CrmLeadModel lead) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text(
          "Lead Notes (${lead.leadCode ?? '#${lead.id}'})",
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
        final leads = _filterLeads(vm.leads);

        final totalCount = categoryLeads.length;
        final newCount = categoryLeads.where((l) {
          final rs = l.rawStatus.toUpperCase();
          return rs == 'NEW_LEAD' || rs == 'NEW';
        }).length;
        final pipelineCount = categoryLeads.where((l) {
          final rs = l.rawStatus.toUpperCase();
          return rs != 'NEW_LEAD' && rs != 'NEW' && rs != 'DISBURSED';
        }).length;

        final runningLeads = categoryLeads.where(_isRunningRto).toList();
        final runningCount = runningLeads.length;
        final unassignedCount = runningLeads.where(_isUnassigned).length;

        return Scaffold(
          backgroundColor: const Color(0xFFF4F6FA),
          body: SafeArea(
            child: Column(
              children: [
                // ================= TOP HEADER =================
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(12, 10, 14, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            borderRadius: BorderRadius.circular(8),
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: 18,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            widget.loggedInOnly
                                ? "Login Leads"
                                : "${widget.loanType} Leads",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Pills Row: Showing | Export RTO Cases | Hub
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 34,
                              alignment: Alignment.center,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  "${leads.length} Showing",
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF15803D),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 4,
                            child: InkWell(
                              onTap: () => _showActionMessage(
                                  "Exporting ${leads.length} RTO cases..."),
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                height: 34,
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0FDF4),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: const Color(0xFFBBF7D0)),
                                ),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.description_outlined,
                                        size: 13,
                                        color: Color(0xFF15803D),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        "Export RTO Cases",
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF15803D),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: InkWell(
                              onTap: () => Navigator.pop(context),
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                height: 34,
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: const Color(0xFFE2E8F0)),
                                ),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.grid_view_rounded,
                                        size: 13,
                                        color: Color(0xFF475569),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        "Hub",
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF475569),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Summary Strip: Total | New | In Pipeline
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAFAFA),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildStatText("Total: ", "$totalCount",
                                const Color(0xFF0F172A)),
                            Container(
                              width: 1,
                              height: 14,
                              color: const Color(0xFFE2E8F0),
                            ),
                            _buildStatText("New: ", "$newCount",
                                const Color(0xFF059669)),
                            Container(
                              width: 1,
                              height: 14,
                              color: const Color(0xFFE2E8F0),
                            ),
                            _buildStatText("In Pipeline: ", "$pipelineCount",
                                const Color(0xFFD97706)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ================= SEARCH + FILTER CHIPS =================
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border:
                                    Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              child: TextField(
                                controller: _searchController,
                                onChanged: (v) =>
                                    setState(() => _searchQuery = v),
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: const Color(0xFF0F172A),
                                ),
                                decoration: InputDecoration(
                                  hintText:
                                      "Search leads by name, phone or ID...",
                                  hintStyle: GoogleFonts.poppins(
                                    fontSize: 11.5,
                                    color: const Color(0xFF94A3B8),
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () => _showActionMessage(
                                "Exporting ${leads.length} leads to CSV..."),
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              height: 40,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border:
                                    Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.download_outlined,
                                    size: 14,
                                    color: Color(0xFF475569),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "CSV",
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
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
                      const SizedBox(height: 10),

                      // Running Cases | Unassigned
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => setState(() {
                                _activeChip = _activeChip == "running"
                                    ? "all"
                                    : "running";
                              }),
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                height: 36,
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: _activeChip == "running"
                                      ? const Color(0xFF10B981)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: const Color(0xFF10B981),
                                  ),
                                ),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.check_circle_outline,
                                        size: 14,
                                        color: _activeChip == "running"
                                            ? Colors.white
                                            : const Color(0xFF10B981),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        "Running Cases: $runningCount",
                                        style: GoogleFonts.poppins(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w600,
                                          color: _activeChip == "running"
                                              ? Colors.white
                                              : const Color(0xFF10B981),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: InkWell(
                              onTap: () => setState(() {
                                _activeChip = _activeChip == "unassigned"
                                    ? "all"
                                    : "unassigned";
                              }),
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                height: 36,
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: _activeChip == "unassigned"
                                      ? const Color(0xFFDC2626)
                                      : const Color(0xFFFEF2F2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: const Color(0xFFFECACA)),
                                ),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.warning_amber_rounded,
                                        size: 14,
                                        color: _activeChip == "unassigned"
                                            ? Colors.white
                                            : const Color(0xFFDC2626),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        "Unassigned: $unassignedCount",
                                        style: GoogleFonts.poppins(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w600,
                                          color: _activeChip == "unassigned"
                                              ? Colors.white
                                              : const Color(0xFFDC2626),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ================= LEAD CARDS LIST =================
                Expanded(
                  child: vm.isLoading && vm.leads.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : vm.errorMessage != null && vm.leads.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    vm.errorMessage!,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: const Color(0xFFDC2626),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () => vm.fetchLeads(),
                                    child: const Text("Retry"),
                                  ),
                                ],
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: () => vm.fetchLeads(),
                              child: leads.isEmpty
                                  ? ListView(
                                      children: [
                                        const SizedBox(height: 80),
                                        Center(
                                          child: Text(
                                            "No login leads found",
                                            style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              color: const Color(0xFF64748B),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : ListView.builder(
                                      padding: const EdgeInsets.fromLTRB(
                                          14, 4, 14, 90),
                                      itemCount: leads.length,
                                      itemBuilder: (context, i) =>
                                          _buildLeadCard(
                                              leads[i], i + 1, vm),
                                    ),
                            ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CreateLoanLeadScreen(),
                ),
              );
            },
            backgroundColor: const Color(0xFF0284C7),
            elevation: 3,
            icon: const Icon(Icons.add, color: Colors.white, size: 18),
            label: Text(
              "Create Lead",
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  Color _statusColor(String status) {
    final s = status.toLowerCase();
    if (s.contains('disburs') ||
        s.contains('approv') ||
        s.contains('payment done')) {
      return const Color(0xFF059669);
    }
    if (s.contains('reject') || s.contains('cancel')) {
      return const Color(0xFFDC2626);
    }
    return const Color(0xFFF59E0B);
  }

  Widget _buildStatText(String label, String value, Color valueColor) {
    return Text.rich(
      TextSpan(
        text: label,
        style: GoogleFonts.poppins(
          fontSize: 11.5,
          color: const Color(0xFF64748B),
        ),
        children: [
          TextSpan(
            text: value,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeadCard(CrmLeadModel lead, int index, LeadsViewModel vm) {
    final isSelected = _selectedIds.contains(lead.id);
    final code = (lead.leadCode != null && lead.leadCode!.trim().isNotEmpty)
        ? (lead.leadCode!.startsWith('#') ? lead.leadCode! : '#${lead.leadCode}')
        : '#${lead.id}';
    final assigned =
        (lead.assignedTo != null && lead.assignedTo!.trim().isNotEmpty)
            ? lead.assignedTo!.trim()
            : "Unassigned";
    final isUnassigned = assigned == "Unassigned";
    final sourceLabel = lead.leadSource.trim().isNotEmpty
        ? "${lead.leadSource[0].toUpperCase()}${lead.leadSource.substring(1)}"
        : "N/A";
    final emailText = (lead.email != null && lead.email!.trim().isNotEmpty)
        ? lead.email!.trim()
        : "N/A";
    final dealerText = (lead.sourcingManager != null &&
            lead.sourcingManager!.trim().isNotEmpty)
        ? lead.sourcingManager!.trim()
        : "N/A";
    final tag1 = (lead.carName != null && lead.carName!.trim().isNotEmpty)
        ? lead.carName!.trim()
        : "N/A";
    final tag2 = (lead.regNo != null && lead.regNo!.trim().isNotEmpty)
        ? lead.regNo!.trim()
        : "N/A";
    final remarksText =
        (lead.remarks != null && lead.remarks!.trim().isNotEmpty)
            ? lead.remarks!.trim()
            : "N/A";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Top Row: Checkbox + #1 + #000059 + Status badge
          Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: Checkbox(
                  value: isSelected,
                  onChanged: (v) {
                    setState(() {
                      if (v == true) {
                        _selectedIds.add(lead.id);
                      } else {
                        _selectedIds.remove(lead.id);
                      }
                    });
                  },
                  side: const BorderSide(color: Color(0xFFCBD5E1), width: 1.3),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "#$index",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                code,
                style: GoogleFonts.poppins(
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF059669),
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor(lead.status),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  lead.status,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // 2. Tags Row
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              if (lead.name.trim().isNotEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFA7F3D0)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        lead.name,
                        style: GoogleFonts.poppins(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF059669),
                        ),
                      ),
                    ],
                  ),
                ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFBFDBFE)),
                ),
                child: Text(
                  lead.type,
                  style: GoogleFonts.poppins(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2563EB),
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: isUnassigned
                      ? const Color(0xFFFEF2F2)
                      : const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isUnassigned
                        ? const Color(0xFFFECACA)
                        : const Color(0xFFBBF7D0),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 12,
                      color: isUnassigned
                          ? const Color(0xFFDC2626)
                          : const Color(0xFF059669),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      assigned,
                      style: GoogleFonts.poppins(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: isUnassigned
                            ? const Color(0xFFDC2626)
                            : const Color(0xFF059669),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 12),

          // 3. Phone Row + Source
          Row(
            children: [
              Text(
                "PHONE",
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                lead.phone.isNotEmpty ? lead.phone : "N/A",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  color: Color(0xFFFEE2E2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  size: 11,
                  color: Color(0xFFEF4444),
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Text(
                  sourceLabel,
                  style: GoogleFonts.poppins(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF475569),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // 4. Email Row
          Row(
            children: [
              const Icon(Icons.mail_outline,
                  size: 14, color: Color(0xFF94A3B8)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  emailText,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFF475569),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // 5. Dealer Row + Tags
          Row(
            children: [
              const Icon(Icons.business_outlined,
                  size: 14, color: Color(0xFF94A3B8)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Dealer: $dealerText",
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF475569),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              _buildSmallChip(tag1),
              const SizedBox(width: 5),
              _buildSmallChip(tag2),
            ],
          ),
          const SizedBox(height: 12),

          // 6. Income & Req Loan Boxes
          Row(
            children: [
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Income",
                        style: GoogleFonts.poppins(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 1),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _formatCurrency(lead.monthlyIncome),
                          style: GoogleFonts.poppins(
                            fontSize: 14.5,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Req Loan",
                        style: GoogleFonts.poppins(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 1),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _formatCurrency(lead.amount),
                          style: GoogleFonts.poppins(
                            fontSize: 14.5,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF059669),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // 7. Disbursement Amount Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFA7F3D0)),
            ),
            child: Column(
              children: [
                Text(
                  "DISBURSEMENT AMOUNT",
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    color: const Color(0xFF059669),
                  ),
                ),
                const SizedBox(height: 1),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    _formatCurrency(lead.disbursedAmount, decimals: true),
                    style: GoogleFonts.poppins(
                      fontSize: 15.5,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF059669),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // 8. Call Logs & Updated Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFF1F5F9)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "CALL LOGS",
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Last: $remarksText | Next: N/A",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF475569),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "UPDATED",
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      lead.createdAt,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF334155),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 9. Quick Actions Row
          Row(
            children: [
              Text(
                "QUICK ACTIONS",
                style: GoogleFonts.poppins(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF64748B),
                ),
              ),
              const Spacer(),
              _buildActionCircle(
                icon: Icons.call_outlined,
                bgColor: const Color(0xFFF0F9FF),
                borderColor: const Color(0xFFBAE6FD),
                iconColor: const Color(0xFF0284C7),
                onTap: () => vm.makePhoneCall(lead.phone),
              ),
              const SizedBox(width: 8),
              _buildActionCircle(
                icon: Icons.menu_book_outlined,
                bgColor: const Color(0xFF0284C7),
                borderColor: const Color(0xFF0284C7),
                iconColor: Colors.white,
                onTap: () => _showRemarksDialog(lead),
              ),
              const SizedBox(width: 8),
              _buildActionCircle(
                icon: Icons.access_time,
                bgColor: const Color(0xFFF5F3FF),
                borderColor: const Color(0xFFDDD6FE),
                iconColor: const Color(0xFF7C3AED),
                onTap: () => _showRemarksDialog(lead),
              ),
              const SizedBox(width: 8),
              _buildActionCircle(
                icon: Icons.edit_outlined,
                bgColor: const Color(0xFFFEFCE8),
                borderColor: const Color(0xFFFDE68A),
                iconColor: const Color(0xFFD97706),
                onTap: () async {
                  final updated = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditLoanLeadScreen(lead: lead),
                    ),
                  );
                  if (updated == true && mounted) {
                    vm.fetchLeads();
                  }
                },
              ),
              const SizedBox(width: 8),
              _buildActionCircle(
                icon: Icons.delete_outline,
                bgColor: const Color(0xFFFEF2F2),
                borderColor: const Color(0xFFFECACA),
                iconColor: const Color(0xFFEF4444),
                onTap: () => _showActionMessage("Lead $code delete requested"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmallChip(String text) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 70),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF64748B),
        ),
      ),
    );
  }

  Widget _buildActionCircle({
    required IconData icon,
    required Color bgColor,
    required Color borderColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          border: Border.all(color: borderColor),
        ),
        child: Icon(icon, size: 15, color: iconColor),
      ),
    );
  }
}
