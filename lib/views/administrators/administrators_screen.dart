import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/administrator_model.dart';
import '../../models/administrator_meta_model.dart';
import '../../viewmodels/administrators_viewmodel.dart';
import '../widgets/crm_drawer.dart';
import '../widgets/custom_back_button.dart';
import '../user_management/crm_role_hierarchy_screen.dart';
import 'add_administrator_screen.dart';

class AdministratorsScreen extends StatefulWidget {
  const AdministratorsScreen({super.key});

  @override
  State<AdministratorsScreen> createState() => _AdministratorsScreenState();
}

class _AdministratorsScreenState extends State<AdministratorsScreen> {
  final bool _isDarkMode = false;
  String _searchQuery = "";
  String _activeStatusTab = "Approved"; // "Approved" or "UnApproved"
  int _entriesPerPage = 10;
  int _currentPage = 1;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<AdministratorsViewModel>();
      vm.fetchAdministrators();
      vm.fetchMetaOptions();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _callPhone(String? phone) async {
    if (phone == null || phone.trim().isEmpty) return;
    final uri = Uri.parse("tel:${phone.replaceAll(' ', '')}");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  String _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return "N/A";
    try {
      final parsed = DateTime.tryParse(raw);
      if (parsed != null) {
        return DateFormat("dd MMM yyyy").format(parsed.toLocal());
      }
    } catch (_) {}
    if (raw.contains('T')) return raw.split('T').first;
    return raw;
  }

  void _openMetaOptionsSheet(BuildContext context, AdministratorMetaModel? meta) {
    if (meta == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Loading form options...", style: GoogleFonts.poppins()),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          builder: (_, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Administrator Meta Suite",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(16),
                      children: [
                        _buildMetaSectionHeader("System Roles (${meta.roles.length})", Icons.badge_outlined),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: meta.roles.map((r) {
                            return Chip(
                              label: Text("${r.name} (${r.administratorsCount})",
                                  style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w500)),
                              backgroundColor: const Color(0xFF003366).withOpacity(0.06),
                              side: BorderSide(color: const Color(0xFF003366).withOpacity(0.15)),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 18),

                        _buildMetaSectionHeader("System Modules (${meta.modules.length})", Icons.apps_outlined),
                        ...meta.modules.map((m) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle_outline, size: 16, color: Color(0xFF10B981)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(m.name,
                                      style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600)),
                                ),
                                Wrap(
                                  spacing: 4,
                                  children: [
                                    if (m.hasView) _tag("View", Colors.blue),
                                    if (m.hasAdd) _tag("Add", Colors.green),
                                    if (m.hasEdit) _tag("Edit", Colors.orange),
                                    if (m.hasDelete) _tag("Delete", Colors.red),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                        const SizedBox(height: 18),

                        _buildMetaSectionHeader("States Available (${meta.states.length})", Icons.map_outlined),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: meta.states.map((s) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(s.stateName, style: GoogleFonts.poppins(fontSize: 11)),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 18),

                        _buildMetaSectionHeader("Partner Payout Banks (${meta.payoutBanks.length})", Icons.account_balance_outlined),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: meta.payoutBanks.map((b) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFECFDF5),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: const Color(0xFFA7F3D0)),
                              ),
                              child: Text(b.name, style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF065F46))),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 18),

                        _buildMetaSectionHeader("Loan Categories (${meta.payoutCategories.length})", Icons.category_outlined),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: meta.payoutCategories.map((c) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: const Color(0xFFBFDBFE)),
                              ),
                              child: Text(c.name, style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF1E40AF))),
                            );
                          }).toList(),
                        ),
                      ],
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

  Widget _buildMetaSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF003366)),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text, style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.bold, color: color)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AdministratorsViewModel>();
    final admins = vm.filteredAdministrators;
    final counts = vm.counts;
    final pagination = vm.pagination;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          "Administrators & Roles",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: const Color(0xFF0F172A),
          ),
        ),
        leading: const CustomBackButton(),
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_none_rounded,
              color: _isDarkMode ? Colors.white : const Color(0xFF334155),
            ),
            onPressed: () {},
          ),
          IconButton(
            tooltip: "Refresh Directory",
            icon: const Icon(Icons.refresh, color: Color(0xFF003366)),
            onPressed: () => vm.fetchAdministrators(page: vm.currentPage),
          ),
          const SizedBox(width: 6),
        ],
      ),
      drawer: const CrmDrawer(),
      body: RefreshIndicator(
        color: const Color(0xFF003366),
        onRefresh: () async {
          await vm.fetchAdministrators(page: vm.currentPage);
          await vm.fetchMetaOptions();
        },
        child: Column(
          children: [
            // 1. KPI Counts Ribbon
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildKpiChip("All Staff", counts.total, "All", vm.statusFilter, Colors.blueGrey, () {
                      vm.setStatusFilter("All");
                    }),
                    const SizedBox(width: 8),
                    _buildKpiChip("Active", counts.active, "Active", vm.statusFilter, const Color(0xFF10B981), () {
                      vm.setStatusFilter("Active");
                    }),
                    const SizedBox(width: 8),
                    _buildKpiChip("Inactive", counts.inactive, "Inactive", vm.statusFilter, Colors.orange, () {
                      vm.setStatusFilter("Inactive");
                    }),
                    const SizedBox(width: 8),
                    _buildKpiChip("Unapproved", counts.unapproved, "Unapproved", vm.statusFilter, Colors.redAccent, () {
                      vm.setStatusFilter("Unapproved");
                    }),
                  ],
                ),
              ),
            ),

            // 2. Search Field
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: TextField(
                controller: _searchController,
                onChanged: (val) => vm.setSearchQuery(val),
                decoration: InputDecoration(
                  hintText: "Search staff by name, phone, role or ID...",
                  hintStyle: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF94A3B8)),
                  prefixIcon: const Icon(Icons.search, size: 20, color: Color(0xFF003366)),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            vm.setSearchQuery("");
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                ),
              ),
            ),
            const Divider(height: 1),

            // 3. Body List
            Expanded(
              child: vm.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Color(0xFF003366)),
                    )
                  : admins.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.person_off_outlined, size: 48, color: Colors.grey.shade400),
                              const SizedBox(height: 12),
                              Text(
                                "No administrators found",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Try adjusting your search or filters.",
                                style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF94A3B8)),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: admins.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final admin = admins[index];
                            return _buildAdminCard(admin);
                          },
                        ),
            ),

            // 4. Pagination Ribbon
            if (pagination.lastPage > 1)
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: pagination.currentPage > 1
                          ? () => vm.fetchAdministrators(page: pagination.currentPage - 1)
                          : null,
                      icon: const Icon(Icons.chevron_left, size: 18),
                      label: Text("Previous", style: GoogleFonts.poppins(fontSize: 12)),
                    ),
                    Text(
                      "Page ${pagination.currentPage} of ${pagination.lastPage} (${counts.total})",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF334155),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: pagination.currentPage < pagination.lastPage
                          ? () => vm.fetchAdministrators(page: pagination.currentPage + 1)
                          : null,
                      label: Text("Next", style: GoogleFonts.poppins(fontSize: 12)),
                      icon: const Icon(Icons.chevron_right, size: 18),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF003366),
        icon: const Icon(Icons.person_add_alt_1_rounded, color: Colors.white),
        label: Text(
          "Add Administrator",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: Colors.white,
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddAdministratorScreen(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildKpiChip(
    String label,
    int count,
    String tabValue,
    String currentFilter,
    Color color,
    VoidCallback onTap,
  ) {
    final isSelected = currentFilter == tabValue;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : color.withOpacity(0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? Colors.white : color,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withOpacity(0.25) : color.withOpacity(0.18),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "$count",
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminCard(AdministratorItem admin) {
    final initial = admin.fullName.isNotEmpty ? admin.fullName[0].toUpperCase() : "A";
    final isOnline = admin.status == 1;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: const Color(0xFF003366),
                backgroundImage: admin.imageUrl != null &&
                        admin.imageUrl!.startsWith('http') &&
                        !admin.imageUrl!.contains('dummy-profile')
                    ? NetworkImage(admin.imageUrl!)
                    : null,
                child: admin.imageUrl == null ||
                        !admin.imageUrl!.startsWith('http') ||
                        admin.imageUrl!.contains('dummy-profile')
                    ? Text(
                        initial,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            admin.fullName,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0F172A),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: isOnline
                                ? const Color(0xFF10B981).withOpacity(0.12)
                                : Colors.redAccent.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            admin.statusText,
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: isOnline ? const Color(0xFF059669) : Colors.redAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "${admin.administratorId} • @${admin.username}",
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 10),

          // Role & Hierarchy
          Row(
            children: [
              const Icon(Icons.badge_outlined, size: 16, color: Color(0xFF003366)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  admin.role?.name ?? "Staff Associate",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E293B),
                  ),
                ),
              ),
              if (admin.role?.code != null && admin.role!.code.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF003366).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    admin.role!.code,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF003366),
                    ),
                  ),
                ),
            ],
          ),

          if (admin.parent != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.account_tree_outlined, size: 16, color: Color(0xFF64748B)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Reports to: ${admin.parent!.fullName}",
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 6),

          // Contact Details
          Row(
            children: [
              if (admin.phone != null && admin.phone!.isNotEmpty) ...[
                InkWell(
                  onTap: () => _callPhone(admin.phone),
                  borderRadius: BorderRadius.circular(4),
                  child: Row(
                    children: [
                      const Icon(Icons.phone_outlined, size: 15, color: Color(0xFF10B981)),
                      const SizedBox(width: 4),
                      Text(
                        admin.phone!,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF059669),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
              ],
              if (admin.city != null && admin.city!.isNotEmpty) ...[
                const Icon(Icons.location_on_outlined, size: 15, color: Color(0xFF64748B)),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    "${admin.city}${admin.state != null ? ', ${admin.state}' : ''}",
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: const Color(0xFF64748B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),

          if (admin.email != null && admin.email!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.email_outlined, size: 15, color: Color(0xFF64748B)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    admin.email!,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: const Color(0xFF475569),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  _formatDate(admin.createdAt),
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
