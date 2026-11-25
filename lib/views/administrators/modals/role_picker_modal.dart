import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../models/administrator_meta_model.dart';
import '../../../models/crm_role_model.dart';
import '../../../viewmodels/administrators_viewmodel.dart';

class RolePickerModal {
  static void showControllerSelectDialog({
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
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Row(
                  children: [
                    const Icon(Icons.account_tree_outlined,
                        color: Color(0xFF003366), size: 20),
                    const SizedBox(width: 8),
                    Text(
                      "Select Controller / Parent Role",
                      style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A)),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  children: [
                    // Root "Controller"
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
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
                          fontWeight:
                              (currentParentId == null || currentParentId == 0)
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                          color:
                              (currentParentId == null || currentParentId == 0)
                                  ? const Color(0xFF003366)
                                  : const Color(0xFF0F172A),
                        ),
                      ),
                      subtitle: Text("Top-level / Root controller",
                          style: GoogleFonts.poppins(
                              fontSize: 11, color: const Color(0xFF64748B))),
                      onTap: () {
                        onSelected(null, "Controller");
                        Navigator.pop(bctx);
                      },
                    ),
                    const Divider(height: 1),
                    ...allRoles.map((role) {
                      final isSelected = currentParentId == role.id;
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 2),
                        leading: Icon(
                          isSelected
                              ? Icons.check_circle_rounded
                              : Icons.circle_outlined,
                          color: isSelected
                              ? const Color(0xFF003366)
                              : const Color(0xFFCBD5E1),
                          size: 20,
                        ),
                        title: Text(
                          role.name,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected
                                ? const Color(0xFF003366)
                                : const Color(0xFF0F172A),
                          ),
                        ),
                        subtitle: role.code.isNotEmpty
                            ? Text(role.code,
                                style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: const Color(0xFF64748B)))
                            : null,
                        onTap: () {
                          onSelected(role.id, role.name);
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

  static void show({
    required BuildContext context,
    required List<MetaRoleOption> roles,
    required MetaRoleOption? selectedRole,
    required void Function(MetaRoleOption role) onRoleSelected,
    required void Function(int roleId)? onRoleDeleted,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        String query = "";
        bool isAddingRole = false;
        MetaRoleOption? editingRole;
        final roleNameCtrl = TextEditingController();
        int? selectedParentId;
        String selectedParentName = "Controller";
        bool allowedInLeads = false;
        bool isSubmitting = false;

        return StatefulBuilder(
          builder: (modalContext, setModalState) {
            final vm = modalContext.watch<AdministratorsViewModel>();
            final currentRoles = vm.metaOptions?.roles ?? roles;

            final filtered = currentRoles.where((r) {
              final q = query.toLowerCase();
              return r.name.toLowerCase().contains(q) ||
                  r.code.toLowerCase().contains(q);
            }).toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  // Handle
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 6),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2)),
                  ),

                  // Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Select Designation / Role",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF003366).withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "${currentRoles.length} Roles",
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF003366),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Search Field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      onChanged: (v) => setModalState(() => query = v),
                      decoration: InputDecoration(
                        hintText: "Search roles...",
                        prefixIcon:
                            const Icon(Icons.search, color: Color(0xFF003366)),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Color(0xFFE2E8F0))),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Role List with Edit & Delete Actions
                  Expanded(
                    child: filtered.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.search_off_rounded,
                                    size: 40, color: Colors.grey),
                                const SizedBox(height: 8),
                                Text(
                                  "No matching roles found",
                                  style: GoogleFonts.poppins(
                                      color: Colors.grey, fontSize: 13),
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 1),
                            itemBuilder: (_, idx) {
                              final r = filtered[idx];
                              final isSel = selectedRole?.id == r.id;

                              return ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                leading: Icon(
                                  isSel
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_off,
                                  color: isSel
                                      ? const Color(0xFF003366)
                                      : const Color(0xFFCBD5E1),
                                  size: 20,
                                ),
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        r.name,
                                        style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          fontWeight: isSel
                                              ? FontWeight.w700
                                              : FontWeight.w500,
                                          color: isSel
                                              ? const Color(0xFF003366)
                                              : const Color(0xFF0F172A),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 7, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: r.administratorsCount > 0
                                            ? const Color(0xFF10B981)
                                                .withValues(alpha: 0.1)
                                            : Colors.grey
                                                .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        "${r.administratorsCount}",
                                        style: GoogleFonts.poppins(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: r.administratorsCount > 0
                                              ? const Color(0xFF10B981)
                                              : Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // ✏️ Edit Role
                                    IconButton(
                                      icon: const Icon(Icons.edit_outlined,
                                          size: 18, color: Color(0xFF10B981)),
                                      tooltip: "Edit Role",
                                      onPressed: () {
                                        setModalState(() {
                                          editingRole = r;
                                          isAddingRole = false;
                                          roleNameCtrl.text = r.name;
                                          final crmRole = vm.roles.firstWhere(
                                            (cr) => cr.id == r.id,
                                            orElse: () => CrmRoleItem(
                                                id: r.id,
                                                name: r.name,
                                                code: r.code,
                                                parentId: 0),
                                          );
                                          selectedParentId =
                                              crmRole.parentId > 0
                                                  ? crmRole.parentId
                                                  : null;
                                          selectedParentName = crmRole
                                                  .parentName ??
                                              (crmRole.parentId > 0
                                                  ? "Role #${crmRole.parentId}"
                                                  : "Controller");
                                          allowedInLeads =
                                              crmRole.showInAssignLeads;
                                        });
                                      },
                                    ),
                                    // 🗑️ Delete Role
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline,
                                          size: 18, color: Color(0xFFEF4444)),
                                      tooltip: "Delete Role",
                                      onPressed: () {
                                        showDeleteRoleDialog(
                                          context,
                                          r,
                                          setModalState,
                                          onRoleDeleted: onRoleDeleted,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  onRoleSelected(r);
                                  Navigator.pop(ctx);
                                },
                              );
                            },
                          ),
                  ),

                  // ➕ Web-Matching "+ Add New Role" & Inline Form Area
                  Container(
                    padding: EdgeInsets.fromLTRB(16, 12, 16,
                        MediaQuery.of(modalContext).viewInsets.bottom + 16),
                    decoration: BoxDecoration(
                      color: (isAddingRole || editingRole != null)
                          ? const Color(0xFFF8FAFC)
                          : Colors.white,
                      border: const Border(
                          top: BorderSide(color: Color(0xFFE2E8F0))),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 6,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: (isAddingRole || editingRole != null)
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      editingRole != null
                                          ? "Edit Role"
                                          : "Add Role",
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF0F172A),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setModalState(() {
                                          isAddingRole = false;
                                          editingRole = null;
                                          roleNameCtrl.clear();
                                        });
                                      },
                                      child: const Icon(Icons.close_rounded,
                                          size: 18, color: Color(0xFF94A3B8)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),

                                // 1. Controller / Parent Dropdown
                                InkWell(
                                  onTap: () {
                                    showControllerSelectDialog(
                                      context: modalContext,
                                      allRoles: vm.roles,
                                      currentParentId: selectedParentId,
                                      onSelected: (id, name) {
                                        setModalState(() {
                                          selectedParentId = id;
                                          selectedParentName = name;
                                        });
                                      },
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: const Color(0xFF10B981),
                                          width: 1.5),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          selectedParentName,
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF0F172A),
                                          ),
                                        ),
                                        const Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: Color(0xFF64748B)),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // 2. Role Name TextField
                                TextField(
                                  controller: roleNameCtrl,
                                  decoration: InputDecoration(
                                    hintText: "Role Name",
                                    hintStyle: GoogleFonts.poppins(
                                        color: const Color(0xFF94A3B8),
                                        fontSize: 13),
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 12),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFCBD5E1))),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFCBD5E1))),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                            color: Color(0xFF003366),
                                            width: 1.5)),
                                  ),
                                ),
                                const SizedBox(height: 12),

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
                                      onTap: () => setModalState(
                                          () => allowedInLeads = true),
                                      child: Row(
                                        children: [
                                          Icon(
                                            allowedInLeads
                                                ? Icons.radio_button_checked
                                                : Icons.radio_button_off,
                                            size: 18,
                                            color: allowedInLeads
                                                ? const Color(0xFF10B981)
                                                : const Color(0xFF94A3B8),
                                          ),
                                          const SizedBox(width: 6),
                                          Text("Yes",
                                              style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 24),
                                    InkWell(
                                      onTap: () => setModalState(
                                          () => allowedInLeads = false),
                                      child: Row(
                                        children: [
                                          Icon(
                                            !allowedInLeads
                                                ? Icons.radio_button_checked
                                                : Icons.radio_button_off,
                                            size: 18,
                                            color: !allowedInLeads
                                                ? const Color(0xFF10B981)
                                                : const Color(0xFF94A3B8),
                                          ),
                                          const SizedBox(width: 6),
                                          Text("No",
                                              style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),

                                // 4. Save & Cancel Buttons
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: isSubmitting
                                          ? null
                                          : () async {
                                              final name =
                                                  roleNameCtrl.text.trim();
                                              if (name.isEmpty) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        "Please enter Role Name",
                                                        style: GoogleFonts
                                                            .poppins()),
                                                    backgroundColor:
                                                        Colors.redAccent,
                                                  ),
                                                );
                                                return;
                                              }

                                              setModalState(
                                                  () => isSubmitting = true);
                                              if (editingRole != null) {
                                                await vm.updateRole(
                                                  editingRole!.id,
                                                  name: name,
                                                  parentId: selectedParentId,
                                                  showInAssignLeads:
                                                      allowedInLeads,
                                                );
                                                final updatedOption =
                                                    MetaRoleOption(
                                                  id: editingRole!.id,
                                                  name: name,
                                                  code: editingRole!.code,
                                                  administratorsCount:
                                                      editingRole!
                                                          .administratorsCount,
                                                );
                                                onRoleSelected(updatedOption);
                                                setModalState(() {
                                                  isSubmitting = false;
                                                  editingRole = null;
                                                  isAddingRole = false;
                                                });
                                                if (context.mounted) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                          "Role updated successfully!",
                                                          style: GoogleFonts
                                                              .poppins()),
                                                      backgroundColor:
                                                          const Color(
                                                              0xFF10B981),
                                                    ),
                                                  );
                                                }
                                              } else {
                                                final newRole =
                                                    await vm.createRole(
                                                  name: name,
                                                  parentId: selectedParentId,
                                                  showInAssignLeads:
                                                      allowedInLeads,
                                                );
                                                setModalState(
                                                    () => isSubmitting = false);
                                                if (newRole != null) {
                                                  onRoleSelected(newRole);
                                                  Navigator.pop(ctx);
                                                  if (context.mounted) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                            "Role '$name' created and selected!",
                                                            style: GoogleFonts
                                                                .poppins()),
                                                        backgroundColor:
                                                            const Color(
                                                                0xFF10B981),
                                                      ),
                                                    );
                                                  }
                                                }
                                              }
                                            },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF0284C7),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 24, vertical: 10),
                                        elevation: 0,
                                      ),
                                      child: isSubmitting
                                          ? const SizedBox(
                                              height: 16,
                                              width: 16,
                                              child:
                                                  CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: Colors.white))
                                          : Text("Save",
                                              style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                  fontSize: 13)),
                                    ),
                                    const Spacer(),
                                    TextButton(
                                      onPressed: () {
                                        setModalState(() {
                                          isAddingRole = false;
                                          editingRole = null;
                                          roleNameCtrl.clear();
                                        });
                                      },
                                      child: Text(
                                        "Cancel",
                                        style: GoogleFonts.poppins(
                                          color: const Color(0xFF64748B),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : InkWell(
                              onTap: () {
                                setModalState(() {
                                  isAddingRole = true;
                                  editingRole = null;
                                  roleNameCtrl.clear();
                                  selectedParentId = null;
                                  selectedParentName = "Controller";
                                  allowedInLeads = false;
                                });
                              },
                              child: Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.add_rounded,
                                          color: Color(0xFF10B981), size: 20),
                                      const SizedBox(width: 6),
                                      Text(
                                        "+ Add New Role",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF10B981),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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

  static void showDeleteRoleDialog(
    BuildContext rootContext,
    MetaRoleOption role,
    void Function(void Function()) setModalState, {
    void Function(int roleId)? onRoleDeleted,
  }) {
    if (role.administratorsCount > 0) {
      showDialog(
        context: rootContext,
        builder: (ctx) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              const Icon(Icons.warning_amber_rounded,
                  color: Colors.orange, size: 24),
              const SizedBox(width: 8),
              Text("Cannot Delete Role",
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.w700)),
            ],
          ),
          content: Text(
            "Role '${role.name}' has ${role.administratorsCount} active staff member(s) assigned. You must re-assign them to another role before deleting.",
            style: GoogleFonts.poppins(
                fontSize: 13, color: const Color(0xFF475569)),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003366)),
              child: Text("Understood",
                  style: GoogleFonts.poppins(color: Colors.white)),
            ),
          ],
        ),
      );
      return;
    }

    showDialog(
      context: rootContext,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Delete Role?",
            style:
                GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
        content: Text(
          "Are you sure you want to permanently delete '${role.name}' (${role.code})?",
          style:
              GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF475569)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child:
                Text("Cancel", style: GoogleFonts.poppins(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final vm = rootContext.read<AdministratorsViewModel>();
              await vm.deleteRole(role.id);
              if (onRoleDeleted != null) {
                onRoleDeleted(role.id);
              }
              setModalState(() {});
              if (rootContext.mounted) {
                ScaffoldMessenger.of(rootContext).showSnackBar(
                  SnackBar(
                    content: Text("Role '${role.name}' deleted",
                        style: GoogleFonts.poppins()),
                    backgroundColor: const Color(0xFFEF4444),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444)),
            child: Text("Delete",
                style: GoogleFonts.poppins(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
