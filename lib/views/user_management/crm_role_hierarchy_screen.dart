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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF003366),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          "Add Role",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 13),
        ),
        onPressed: () => _openAddRoleDialog(context),
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
                    color: const Color(0xFF003366).withValues(alpha: 0.08),
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
              if (!role.isPermanent) ...[
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 18, color: Color(0xFF10B981)),
                  tooltip: "Edit Role",
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => _openEditRoleDialog(context, role),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 18, color: Color(0xFFEF4444)),
                  tooltip: "Delete Role",
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => _openDeleteRoleDialog(context, role),
                ),
              ],
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

  void _showControllerSelectDialog({
    required BuildContext context,
    required List<CrmRoleItem> allRoles,
    required int? currentParentId,
    required void Function(int? id, String name) onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.65,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 6),
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Row(
                  children: [
                    const Icon(Icons.account_tree_outlined, color: Color(0xFF003366), size: 20),
                    const SizedBox(width: 8),
                    Text(
                      "Select Controller / Parent Role",
                      style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A)),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  children: [
                    // Root "Controller"
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      leading: Icon(
                        currentParentId == null || currentParentId == 0
                            ? Icons.check_circle_rounded
                            : Icons.circle_outlined,
                        color: currentParentId == null || currentParentId == 0
                            ? const Color(0xFF003366)
                            : const Color(0xFFCBD5E1),
                        size: 20,
                      ),
                      title: Text(
                        "Controller",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: (currentParentId == null || currentParentId == 0) ? FontWeight.w700 : FontWeight.w500,
                          color: (currentParentId == null || currentParentId == 0) ? const Color(0xFF003366) : const Color(0xFF0F172A),
                        ),
                      ),
                      subtitle: Text("Top-level / Root controller", style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF64748B))),
                      onTap: () {
                        onSelected(null, "Controller");
                        Navigator.pop(bctx);
                      },
                    ),
                    const Divider(height: 1),
                    ...allRoles.map((r) {
                      final isSelected = currentParentId == r.id;
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        leading: Icon(
                          isSelected ? Icons.check_circle_rounded : Icons.circle_outlined,
                          color: isSelected ? const Color(0xFF003366) : const Color(0xFFCBD5E1),
                          size: 20,
                        ),
                        title: Text(
                          r.name,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected ? const Color(0xFF003366) : const Color(0xFF0F172A),
                          ),
                        ),
                        subtitle: r.code.isNotEmpty
                            ? Text(r.code, style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF64748B)))
                            : null,
                        onTap: () {
                          onSelected(r.id, r.name);
                          Navigator.pop(bctx);
                        },
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openAddRoleDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    int? selectedParentId;
    String selectedParentName = "Controller";
    bool allowedInLeads = false;
    bool isSaving = false;

    showDialog(
      context: context,
      builder: (dlgContext) {
        final vm = context.read<AdministratorsViewModel>();
        return StatefulBuilder(
          builder: (context, setDlgState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.add_circle_outline, color: Color(0xFF10B981), size: 20),
                  ),
                  const SizedBox(width: 10),
                  Text("Add New Role", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Controller / Parent Role Dropdown (Green Bordered matching Web)
                    InkWell(
                      onTap: () {
                        _showControllerSelectDialog(
                          context: dlgContext,
                          allRoles: vm.roles,
                          currentParentId: selectedParentId,
                          onSelected: (id, name) {
                            setDlgState(() {
                              selectedParentId = id;
                              selectedParentName = name;
                            });
                          },
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF10B981), width: 1.5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedParentName,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                            const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 2. Role Name
                    TextField(
                      controller: nameCtrl,
                      decoration: InputDecoration(
                        hintText: "Role Name",
                        hintStyle: GoogleFonts.poppins(color: const Color(0xFF94A3B8), fontSize: 13),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF003366), width: 1.5)),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // 3. Allowed in Leads Assignment
                    Text(
                      "Allowed in Leads Assignment:",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        InkWell(
                          onTap: () => setDlgState(() => allowedInLeads = true),
                          child: Row(
                            children: [
                              Icon(
                                allowedInLeads ? Icons.radio_button_checked : Icons.radio_button_off,
                                size: 18,
                                color: allowedInLeads ? const Color(0xFF10B981) : const Color(0xFF94A3B8),
                              ),
                              const SizedBox(width: 6),
                              Text("Yes", style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        InkWell(
                          onTap: () => setDlgState(() => allowedInLeads = false),
                          child: Row(
                            children: [
                              Icon(
                                !allowedInLeads ? Icons.radio_button_checked : Icons.radio_button_off,
                                size: 18,
                                color: !allowedInLeads ? const Color(0xFF10B981) : const Color(0xFF94A3B8),
                              ),
                              const SizedBox(width: 6),
                              Text("No", style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: isSaving
                      ? null
                      : () async {
                          final name = nameCtrl.text.trim();
                          if (name.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Please fill Role Name", style: GoogleFonts.poppins()),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                            return;
                          }

                          setDlgState(() => isSaving = true);
                          final role = await vm.createRole(
                            name: name,
                            parentId: selectedParentId,
                            showInAssignLeads: allowedInLeads,
                          );
                          setDlgState(() => isSaving = false);

                          if (role != null) {
                            Navigator.pop(dlgContext);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Role '$name' created!", style: GoogleFonts.poppins()),
                                backgroundColor: const Color(0xFF10B981),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0284C7),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: isSaving
                      ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text("Save", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                TextButton(
                  onPressed: isSaving ? null : () => Navigator.pop(dlgContext),
                  child: Text("Cancel", style: GoogleFonts.poppins(color: const Color(0xFF64748B))),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _openEditRoleDialog(BuildContext context, CrmRoleItem role) {
    final vm = context.read<AdministratorsViewModel>();
    final nameCtrl = TextEditingController(text: role.name);
    int? selectedParentId = role.parentId > 0 ? role.parentId : null;
    String selectedParentName = role.parentName ?? (role.parentId > 0 ? "Role #${role.parentId}" : "Controller");
    bool allowedInLeads = role.showInAssignLeads;
    bool isSaving = false;

    showDialog(
      context: context,
      builder: (dlgContext) {
        return StatefulBuilder(
          builder: (context, setDlgState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text("Edit Role", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Controller / Parent Dropdown
                    InkWell(
                      onTap: () {
                        _showControllerSelectDialog(
                          context: dlgContext,
                          allRoles: vm.roles,
                          currentParentId: selectedParentId,
                          onSelected: (id, name) {
                            setDlgState(() {
                              selectedParentId = id;
                              selectedParentName = name;
                            });
                          },
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF10B981), width: 1.5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedParentName,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                            const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 2. Role Name
                    TextField(
                      controller: nameCtrl,
                      decoration: InputDecoration(
                        hintText: "Role Name",
                        hintStyle: GoogleFonts.poppins(color: const Color(0xFF94A3B8), fontSize: 13),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF003366), width: 1.5)),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // 3. Allowed in Leads Assignment
                    Text(
                      "Allowed in Leads Assignment:",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        InkWell(
                          onTap: () => setDlgState(() => allowedInLeads = true),
                          child: Row(
                            children: [
                              Icon(
                                allowedInLeads ? Icons.radio_button_checked : Icons.radio_button_off,
                                size: 18,
                                color: allowedInLeads ? const Color(0xFF10B981) : const Color(0xFF94A3B8),
                              ),
                              const SizedBox(width: 6),
                              Text("Yes", style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        InkWell(
                          onTap: () => setDlgState(() => allowedInLeads = false),
                          child: Row(
                            children: [
                              Icon(
                                !allowedInLeads ? Icons.radio_button_checked : Icons.radio_button_off,
                                size: 18,
                                color: !allowedInLeads ? const Color(0xFF10B981) : const Color(0xFF94A3B8),
                              ),
                              const SizedBox(width: 6),
                              Text("No", style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: isSaving
                      ? null
                      : () async {
                          final name = nameCtrl.text.trim();
                          if (name.isEmpty) return;

                          setDlgState(() => isSaving = true);
                          await vm.updateRole(
                            role.id,
                            name: name,
                            parentId: selectedParentId,
                            showInAssignLeads: allowedInLeads,
                          );
                          setDlgState(() => isSaving = false);

                          Navigator.pop(dlgContext);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Role updated successfully!", style: GoogleFonts.poppins()),
                              backgroundColor: const Color(0xFF10B981),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0284C7),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: isSaving
                      ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text("Save", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(dlgContext),
                  child: Text("Cancel", style: GoogleFonts.poppins(color: const Color(0xFF64748B))),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _openDeleteRoleDialog(BuildContext context, CrmRoleItem role) {
    if (role.activeUsersCount > 0) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 24),
              const SizedBox(width: 8),
              Text("Cannot Delete Role", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
            ],
          ),
          content: Text(
            "Role '${role.name}' has ${role.activeUsersCount} active staff assigned. Re-assign them to another role first.",
            style: GoogleFonts.poppins(fontSize: 13),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF003366)),
              child: Text("Understood", style: GoogleFonts.poppins(color: Colors.white)),
            ),
          ],
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Delete Role?", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
        content: Text(
          "Are you sure you want to delete role '${role.name}' (${role.code})?",
          style: GoogleFonts.poppins(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Cancel", style: GoogleFonts.poppins(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final vm = context.read<AdministratorsViewModel>();
              await vm.deleteRole(role.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Role '${role.name}' deleted", style: GoogleFonts.poppins()),
                  backgroundColor: const Color(0xFFEF4444),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
            child: Text("Delete", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
