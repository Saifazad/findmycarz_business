import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/crm_role_model.dart';
import '../../viewmodels/administrators_viewmodel.dart';
import '../widgets/crm_drawer.dart';
import '../widgets/custom_back_button.dart';

class CrmRoleHierarchyScreen extends StatefulWidget {
  const CrmRoleHierarchyScreen({super.key});

  @override
  State<CrmRoleHierarchyScreen> createState() => _CrmRoleHierarchyScreenState();
}

class _CrmRoleHierarchyScreenState extends State<CrmRoleHierarchyScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _filter = "All"; // "All", "Assignable", "Active Users"

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdministratorsViewModel>().fetchRoles();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AdministratorsViewModel>();
    final allRoles = vm.roles;

    // Filter roles
    final filteredRoles = allRoles.where((r) {
      if (_filter == "Assignable" && !r.showInAssignLeads) return false;
      if (_filter == "Active Users" && r.activeUsersCount <= 0) return false;

      final q = _searchController.text.trim().toLowerCase();
      if (q.isNotEmpty) {
        final matchesName = r.name.toLowerCase().contains(q);
        final matchesCode = r.code.toLowerCase().contains(q);
        final matchesParent = r.parentName?.toLowerCase().contains(q) ?? false;
        return matchesName || matchesCode || matchesParent;
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          "CRM Role Hierarchy",
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
            tooltip: "Refresh Roles",
            icon: const Icon(Icons.refresh, color: Color(0xFF003366)),
            onPressed: () => vm.fetchRoles(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: const CrmDrawer(),
      body: RefreshIndicator(
        color: const Color(0xFF003366),
        onRefresh: () => vm.fetchRoles(),
        child: Column(
          children: [
            // Top Summary Card
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  // Search
                  TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: "Search role name, code or reporting parent...",
                      hintStyle: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF94A3B8)),
                      prefixIcon: const Icon(Icons.search, size: 20, color: Color(0xFF003366)),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
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
                  const SizedBox(height: 10),

                  // Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterPill("All Roles (${allRoles.length})", "All"),
                        const SizedBox(width: 8),
                        _buildFilterPill(
                          "Active Staff Only",
                          "Active Users",
                        ),
                        const SizedBox(width: 8),
                        _buildFilterPill(
                          "Lead Assignable",
                          "Assignable",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Body List
            Expanded(
              child: vm.isLoadingRoles
                  ? const Center(
                      child: CircularProgressIndicator(color: Color(0xFF003366)),
                    )
                  : filteredRoles.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.account_tree_outlined, size: 48, color: Colors.grey.shade400),
                              const SizedBox(height: 12),
                              Text(
                                "No CRM roles found",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredRoles.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final role = filteredRoles[index];
                            return _buildRoleCard(role);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPill(String label, String value) {
    final isSelected = _filter == value;
    return InkWell(
      onTap: () => setState(() => _filter = value),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF003366) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(CrmRoleItem role) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  role.name,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ),
              if (role.code.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF003366).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    role.code,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF003366),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),

          // Reporting Parent
          Row(
            children: [
              const Icon(Icons.subdirectory_arrow_right, size: 16, color: Color(0xFF64748B)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  role.parentName != null ? "Reports to: ${role.parentName}" : "Top Level / Root Role",
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: role.parentName != null ? const Color(0xFF64748B) : const Color(0xFF059669),
                    fontWeight: role.parentName == null ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          const Divider(height: 1),
          const SizedBox(height: 8),

          // Bottom Stats & Flags
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.people_outline, size: 15, color: Color(0xFF003366)),
                  const SizedBox(width: 4),
                  Text(
                    "${role.activeUsersCount} Active Staff",
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: role.activeUsersCount > 0 ? const Color(0xFF003366) : const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  if (role.showInAssignLeads)
                    Container(
                      margin: const EdgeInsets.only(left: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "Lead Assignable",
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF059669),
                        ),
                      ),
                    ),
                  if (role.isPermanent)
                    Container(
                      margin: const EdgeInsets.only(left: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "System Core",
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber.shade900,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
