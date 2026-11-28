import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../models/insurance_lead_model.dart';
import '../../viewmodels/leads_viewmodel.dart';
import '../widgets/crm_drawer.dart';
import '../widgets/crm_detail_dialog.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/admin_profile_avatar.dart';

class InsuranceLeadsScreen extends StatefulWidget {
  const InsuranceLeadsScreen({super.key});

  @override
  State<InsuranceLeadsScreen> createState() => _InsuranceLeadsScreenState();
}

class _InsuranceLeadsScreenState extends State<InsuranceLeadsScreen> {
  bool _isDarkMode = false;
  final int _entriesPerPage = 20;
  String _searchQuery = "";
  bool _selectAll = false;

  final TextEditingController _searchController = TextEditingController();
  final List<InsuranceLead> _leads = [];
  final Set<String> _expandedMessageLeadIds = {};

  late final PagingController<int, InsuranceLead> _pagingController =
      PagingController(
    getNextPageKey: (state) {
      if (state.keys == null || state.keys!.isEmpty) return 1;
      final lastPage = state.pages?.last;
      if (lastPage == null || lastPage.length < _entriesPerPage) return null;
      return (state.keys!.last) + 1;
    },
    fetchPage: (pageKey) async {
      final vm = context.read<LeadsViewModel>();
      final items = await vm.fetchInsuranceLeadsPage(
        pageKey: pageKey,
        pageSize: _entriesPerPage,
        searchQuery: _searchQuery,
      );
      if (mounted) {
        setState(() {
          if (pageKey == 1) {
            _leads.clear();
            _selectAll = false;
          }
          _leads.addAll(items);
        });
      }
      return items;
    },
  );

  @override
  void dispose() {
    _pagingController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  int get _selectedCount => _leads.where((l) => l.isSelected).length;

  void _deleteSelected() {
    final count = _selectedCount;
    if (count == 0) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        title: Text(
          "Delete Selected Leads",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: _isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        content: Text(
          "Are you sure you want to delete $count selected lead(s)?",
          style: GoogleFonts.poppins(
            color: _isDarkMode ? Colors.white70 : Colors.black54,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626)),
            onPressed: () {
              setState(() {
                _leads.removeWhere((l) => l.isSelected);
                _selectAll = false;
              });
              _pagingController.refresh();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("$count lead(s) deleted successfully!"),
                  backgroundColor: const Color(0xFFDC2626),
                ),
              );
            },
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _deleteLead(InsuranceLead lead) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        title: Text(
          "Delete Lead",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: _isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        content: Text(
          "Are you sure you want to delete lead ${lead.id}?",
          style: GoogleFonts.poppins(
            color: _isDarkMode ? Colors.white70 : Colors.black54,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626)),
            onPressed: () {
              setState(() {
                _leads.removeWhere((l) => l.id == lead.id);
                if (_leads.isEmpty) {
                  _selectAll = false;
                } else {
                  _selectAll = _leads.every((l) => l.isSelected);
                }
              });
              _pagingController.refresh();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Lead ${lead.id} deleted successfully!"),
                  backgroundColor: const Color(0xFFDC2626),
                ),
              );
            },
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _viewLeadDetails(InsuranceLead lead) {
    showCrmDetailDialog(
      context: context,
      isDarkMode: _isDarkMode,
      headerIcon: Icons.shield_outlined,
      title: "Insurance Lead Details",
      badgeText: lead.id,
      summaryIcon: Icons.directions_car_filled_outlined,
      summaryTitle: lead.ownerName,
      summarySubtitle: "Reg: ${lead.regNumber} • ${lead.city}",
      rows: [
        CrmDetailRow(
          icon: Icons.calendar_today_outlined,
          label: "Submitted Date",
          value: lead.date,
        ),
        CrmDetailRow(
          icon: Icons.phone_outlined,
          label: "Phone",
          value: lead.phone,
        ),
        CrmDetailRow(
          icon: Icons.mail_outline_rounded,
          label: "Email",
          value: lead.email,
        ),
        CrmDetailRow(
          icon: Icons.location_on_outlined,
          label: "City",
          value: lead.city,
        ),
        CrmDetailRow(
          icon: Icons.verified_user_outlined,
          label: "Insurance Info",
          value:
              "Current: ${lead.currentInsurance} • Prev Claim: ${lead.previousClaim} (${lead.previousInsuranceCompany})",
        ),
        CrmDetailRow(
          icon: Icons.notes_outlined,
          label: "Description",
          value: lead.description,
        ),
        CrmDetailRow(
          icon: Icons.info_outline_rounded,
          label: "Status",
          value: lead.status,
          customValue: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: lead.statusColor.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              lead.status,
              style: GoogleFonts.poppins(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: lead.statusColor,
              ),
            ),
          ),
        ),
      ],
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
        titleSpacing: 0,
        title: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            "Insurance Leads",
            style: GoogleFonts.poppins(
              fontSize: 16.5,
              fontWeight: FontWeight.bold,
              color: _isDarkMode ? Colors.white : const Color(0xFF0F172A),
            ),
            maxLines: 1,
          ),
        ),
        actions: [
          const AdminProfileAvatar(),
          const SizedBox(width: 14),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 2. Action Row: [ ] Select all  +  [ 🗑 Delete Selected (0) ]
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Select all Checkbox
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 22,
                          height: 22,
                          child: Checkbox(
                            value: _selectAll,
                            activeColor: const Color(0xFF00A3FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            side: BorderSide(
                              color: _isDarkMode
                                  ? const Color(0xFF64748B)
                                  : const Color(0xFF94A3B8),
                              width: 1.5,
                            ),
                            onChanged: (val) {
                              setState(() {
                                _selectAll = val ?? false;
                                for (var lead in _leads) {
                                  lead.isSelected = _selectAll;
                                }
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Select all",
                          style: GoogleFonts.poppins(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: _isDarkMode
                                ? Colors.grey.shade300
                                : const Color(0xFF475569),
                          ),
                        ),
                      ],
                    ),

                    // Delete Selected (N) Button
                    InkWell(
                      onTap: _selectedCount > 0 ? _deleteSelected : null,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: _isDarkMode
                              ? const Color(0xFF1E293B)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _selectedCount > 0
                                ? const Color(0xFFDC2626)
                                : (_isDarkMode
                                    ? const Color(0xFF334155)
                                    : const Color(0xFFCBD5E1)),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.delete_outline,
                              size: 15,
                              color: _selectedCount > 0
                                  ? const Color(0xFFDC2626)
                                  : (_isDarkMode
                                      ? Colors.grey.shade400
                                      : const Color(0xFF64748B)),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "Delete Selected ($_selectedCount)",
                              style: GoogleFonts.poppins(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w500,
                                color: _selectedCount > 0
                                    ? const Color(0xFFDC2626)
                                    : (_isDarkMode
                                        ? Colors.grey.shade400
                                        : const Color(0xFF64748B)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // 3. Search Row: [ 🔍 Search insurance leads ]
                TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                    _pagingController.refresh();
                  },
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: _isDarkMode ? Colors.white : Colors.black87,
                  ),
                  decoration: InputDecoration(
                    hintText: "Search insurance leads",
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 13,
                      color: const Color(0xFF94A3B8),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 20,
                      color: _isDarkMode
                          ? Colors.grey.shade400
                          : const Color(0xFF003366),
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = "";
                              });
                              _pagingController.refresh();
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: _isDarkMode
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF8FAFC),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: _isDarkMode
                            ? const Color(0xFF334155)
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: _isDarkMode
                            ? const Color(0xFF334155)
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: _isDarkMode
                            ? const Color(0xFF00A3FF)
                            : const Color(0xFF003366),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 4. Insurance Leads Cards List (Exact Match to Screenshot)
          Expanded(
            child: PagingListener<int, InsuranceLead>(
              controller: _pagingController,
              builder: (context, state, fetchNextPage) => RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () => Future.sync(() => _pagingController.refresh()),
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                      sliver: PagedSliverList<int, InsuranceLead>(
                        state: state,
                        fetchNextPage: fetchNextPage,
                        builderDelegate:
                            PagedChildBuilderDelegate<InsuranceLead>(
                          itemBuilder: (ctx, lead, index) =>
                              _buildLeadCard(lead, index),
                          noItemsFoundIndicatorBuilder: (ctx) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.assignment_late_outlined,
                                    size: 44,
                                    color: _isDarkMode
                                        ? Colors.grey.shade600
                                        : Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "No Insurance Leads Found",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: _isDarkMode
                                          ? Colors.grey.shade400
                                          : Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          firstPageProgressIndicatorBuilder: (ctx) =>
                              const Padding(
                            padding: EdgeInsets.symmetric(vertical: 30),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          firstPageErrorIndicatorBuilder: (ctx) =>
                              _buildErrorIndicator(state.error),
                          newPageErrorIndicatorBuilder: (ctx) =>
                              _buildErrorIndicator(state.error),
                          newPageProgressIndicatorBuilder: (ctx) =>
                              const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
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
    );
  }

  Widget _buildErrorIndicator(Object? error) {
    final msg = error?.toString().replaceFirst("Exception: ", "") ??
        "Failed to load insurance leads";
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline,
                size: 40, color: Color(0xFFDC2626)),
            const SizedBox(height: 10),
            Text(
              msg,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: _isDarkMode ? Colors.white70 : const Color(0xFF334155),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _pagingController.refresh,
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
    );
  }

  Widget _buildLeadCard(InsuranceLead lead, int index) {
    final softCardBg =
        _isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final softBorder =
        _isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final regBg =
        _isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFEEF2FF);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: softBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: _isDarkMode ? 0.2 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Checkbox + #S.N. (Left) + Status Pill (Right)
          Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: regBg,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Checkbox(
                  value: lead.isSelected,
                  activeColor: const Color(0xFF0A2463),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  side: BorderSide(
                    color: _isDarkMode
                        ? const Color(0xFF64748B)
                        : const Color(0xFFD5DDF0),
                    width: 1.2,
                  ),
                  onChanged: (val) {
                    setState(() {
                      lead.isSelected = val ?? false;
                      _selectAll = _leads.every((l) => l.isSelected);
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),

              // #S.N. Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: regBg,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  "#${index + 1}",
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color:
                        _isDarkMode ? Colors.white70 : const Color(0xFF1E3A8A),
                  ),
                ),
              ),
              const Spacer(),

              // Status Pill with Dot
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: lead.statusColor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: lead.statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      lead.status.toUpperCase(),
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: lead.statusColor,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Row 2: CUSTOMER INQUIRY Box (with View message toggle)
          Builder(
            builder: (context) {
              final key = lead.dbId.isNotEmpty ? lead.dbId : lead.id;
              final isExpanded = _expandedMessageLeadIds.contains(key);
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: softCardBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.chat_outlined,
                          size: 13.5,
                          color: Color(0xFF0F766E),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "CUSTOMER INQUIRY",
                          style: GoogleFonts.poppins(
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0F766E),
                            letterSpacing: 0.4,
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (isExpanded) {
                                _expandedMessageLeadIds.remove(key);
                              } else {
                                _expandedMessageLeadIds.add(key);
                              }
                            });
                          },
                          borderRadius: BorderRadius.circular(7),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: _isDarkMode
                                  ? const Color(0xFF1E293B)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(color: softBorder),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isExpanded
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  size: 13.5,
                                  color: _isDarkMode
                                      ? Colors.white
                                      : const Color(0xFF0F172A),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  isExpanded ? "Hide message" : "View message",
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: _isDarkMode
                                        ? Colors.white
                                        : const Color(0xFF0F172A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (isExpanded) ...[
                      const SizedBox(height: 8),
                      Text(
                        lead.ownerName,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: _isDarkMode
                              ? Colors.white
                              : const Color(0xFF0F172A),
                        ),
                      ),
                      if (lead.id.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: _isDarkMode
                                ? const Color(0xFF1E293B)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: softBorder),
                          ),
                          child: Text(
                            lead.id,
                            style: GoogleFonts.poppins(
                              fontSize: 11.5,
                              color: _isDarkMode
                                  ? Colors.grey.shade300
                                  : const Color(0xFF475569),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 8),

          // Row 3: Reg Number Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: regBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A2463),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.directions_car_filled_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "Reg: ",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: _isDarkMode
                        ? Colors.grey.shade400
                        : const Color(0xFF64748B),
                  ),
                ),
                Expanded(
                  child: Text(
                    lead.regNumber,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color:
                          _isDarkMode ? Colors.white : const Color(0xFF0F172A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Row 4: Phone Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: softCardBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.phone_outlined,
                  size: 16,
                  color: _isDarkMode
                      ? Colors.grey.shade400
                      : const Color(0xFF475569),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    lead.phone.isNotEmpty ? lead.phone : '--',
                    style: GoogleFonts.poppins(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color:
                          _isDarkMode ? Colors.white : const Color(0xFF0F172A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Row 5: Email Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: softCardBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.mail_outline,
                  size: 16,
                  color: _isDarkMode
                      ? Colors.grey.shade400
                      : const Color(0xFF475569),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    lead.email,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: _isDarkMode
                          ? Colors.grey.shade300
                          : const Color(0xFF334155),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Row 6: Submitted Date (Left) + Eye & Delete Buttons (Right)
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 15,
                color: _isDarkMode
                    ? Colors.grey.shade400
                    : const Color(0xFF64748B),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  "Submitted on ${lead.date}",
                  style: GoogleFonts.poppins(
                    fontSize: 11.5,
                    color: _isDarkMode
                        ? Colors.grey.shade400
                        : const Color(0xFF475569),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              InkWell(
                onTap: () => _viewLeadDetails(lead),
                borderRadius: BorderRadius.circular(7),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: regBg,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.visibility_outlined,
                    size: 16,
                    color: _isDarkMode
                        ? Colors.white70
                        : const Color(0xFF1E3A8A),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              InkWell(
                onTap: () => _deleteLead(lead),
                borderRadius: BorderRadius.circular(7),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: _isDarkMode
                        ? const Color(0xFF451A1A)
                        : const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  alignment: Alignment.center,
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
    );
  }
}
