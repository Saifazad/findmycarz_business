import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/administrator_model.dart';
import '../../viewmodels/administrators_viewmodel.dart';
import '../widgets/crm_drawer.dart';
import '../widgets/custom_back_button.dart';
import 'add_administrator_screen.dart';

class AdministratorsScreen extends StatefulWidget {
  const AdministratorsScreen({super.key});

  @override
  State<AdministratorsScreen> createState() => _AdministratorsScreenState();
}

class _AdministratorsScreenState extends State<AdministratorsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<AdministratorsViewModel>();
      vm.fetchAdministrators();
      vm.fetchMetaOptions();
    });
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if (currentScroll >= maxScroll - 200) {
        context.read<AdministratorsViewModel>().loadNextPage();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
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

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AdministratorsViewModel>();
    final admins = vm.filteredAdministrators;

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
            // 0. Active Impersonation Ribbon (if Auto Login is active)
            if (vm.impersonatedAdmin != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: const Color(0xFF0284C7),
                child: Row(
                  children: [
                    const Icon(Icons.vpn_key_rounded, size: 16, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Logged in as @${vm.impersonatedAdmin!.username} (${vm.impersonatedAdmin!.role?.name ?? 'Staff'})",
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        vm.exitAutoLogin();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Exited auto-login mode. Returned to Super Admin view.", style: GoogleFonts.poppins()),
                            backgroundColor: const Color(0xFF003366),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "Exit Session",
                          style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF0284C7)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // 1. Web CRM Mirror: Segmented "Approved" vs "UnApproved" Tabs
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          vm.setMainTab("Approved");
                          vm.setStatusFilter("All");
                          if (_scrollController.hasClients) {
                            _scrollController.jumpTo(0);
                          }
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: vm.mainTab == "Approved" ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: vm.mainTab == "Approved"
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.06),
                                      blurRadius: 4,
                                      offset: const Offset(0, 1),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Approved",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: vm.mainTab == "Approved" ? FontWeight.w700 : FontWeight.w500,
                                    color: vm.mainTab == "Approved" ? const Color(0xFF003366) : const Color(0xFF64748B),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: vm.mainTab == "Approved"
                                        ? const Color(0xFF003366).withOpacity(0.1)
                                        : Colors.grey.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    "${vm.approvedCount}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: vm.mainTab == "Approved" ? const Color(0xFF003366) : const Color(0xFF64748B),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          vm.setMainTab("UnApproved");
                          if (_scrollController.hasClients) {
                            _scrollController.jumpTo(0);
                          }
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: vm.mainTab == "UnApproved" ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: vm.mainTab == "UnApproved"
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.06),
                                      blurRadius: 4,
                                      offset: const Offset(0, 1),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "UnApproved",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: vm.mainTab == "UnApproved" ? FontWeight.w700 : FontWeight.w500,
                                    color: vm.mainTab == "UnApproved" ? Colors.redAccent : const Color(0xFF64748B),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: vm.mainTab == "UnApproved"
                                        ? Colors.redAccent.withOpacity(0.15)
                                        : Colors.grey.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    "${vm.unapprovedCount}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: vm.mainTab == "UnApproved" ? Colors.redAccent : const Color(0xFF64748B),
                                    ),
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
              ),
            ),

            // 2. Pending Notice (only for UnApproved Tab)
            if (vm.mainTab == "UnApproved")
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFCA5A5)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.pending_actions_rounded, size: 16, color: Color(0xFFDC2626)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "${vm.unapprovedCount} staff member(s) pending approval. Tap 'Approve' to activate CRM access.",
                          style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF991B1B), fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // 3. Search Field
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
              child: TextField(
                controller: _searchController,
                onChanged: (val) => vm.setSearchQuery(val),
                onSubmitted: (_) => vm.fetchAdministrators(page: 1),
                decoration: InputDecoration(
                  hintText: "Search staff by name, email, role or ID...",
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
                          controller: _scrollController,
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                          itemCount: admins.length + (vm.isLoadingMore ? 1 : 0),
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            if (index == admins.length) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                child: Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Color(0xFF003366),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        "Loading more staff...",
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFF64748B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            final admin = admins[index];
                            return _buildAdminCard(admin);
                          },
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
        onPressed: () async {
          final res = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddAdministratorScreen(),
            ),
          );
          if (res == true && context.mounted) {
            context.read<AdministratorsViewModel>().fetchAdministrators();
          }
        },
      ),
    );
  }

  Widget _buildAdminCard(AdministratorItem admin) {
    final initial = admin.fullName.isNotEmpty ? admin.fullName[0].toUpperCase() : "A";
    final isUnapproved = admin.status == 2;
    final isActive = admin.status == 1;

    final Color badgeBg = isActive
        ? const Color(0xFF10B981).withValues(alpha: 0.12)
        : isUnapproved
            ? const Color(0xFFF59E0B).withValues(alpha: 0.15)
            : Colors.redAccent.withValues(alpha: 0.12);
    final Color badgeText = isActive
        ? const Color(0xFF059669)
        : isUnapproved
            ? const Color(0xFFD97706)
            : Colors.redAccent;
    final String badgeLabel = isUnapproved
        ? "UnApproved"
        : isActive
            ? "Active"
            : "Inactive";

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isUnapproved
              ? const Color(0xFFF59E0B).withValues(alpha: 0.4)
              : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
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
                backgroundColor: isUnapproved
                    ? const Color(0xFFD97706)
                    : const Color(0xFF003366),
                backgroundImage: admin.imageUrl != null &&
                        admin.imageUrl!.startsWith('http') &&
                        !admin.imageUrl!.contains('dummy-profile')
                    ? NetworkImage(admin.imageUrl!)
                    : null,
                onBackgroundImageError: admin.imageUrl != null &&
                        admin.imageUrl!.startsWith('http') &&
                        !admin.imageUrl!.contains('dummy-profile')
                    ? (_, __) {}
                    : null,
                child: Text(
                  initial,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
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
                            color: badgeBg,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            badgeLabel,
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: badgeText,
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
                    color: const Color(0xFF003366).withValues(alpha: 0.08),
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

          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 10),

          // Action Strip (Web CRM: Edit, Delete, Auto Login / Approve)
          Row(
            children: [
              // ✏️ Edit Action Button
              InkWell(
                onTap: () async {
                  final res = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddAdministratorScreen(initialAdmin: admin),
                    ),
                  );
                  if (res == true && context.mounted) {
                    context.read<AdministratorsViewModel>().fetchAdministrators();
                  }
                },
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.edit_outlined, size: 14, color: Color(0xFF475569)),
                      const SizedBox(width: 4),
                      Text(
                        "Edit",
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF334155),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // 🗑️ Delete Action Button
              InkWell(
                onTap: () => _showDeleteConfirmation(context, admin),
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.delete_outline_rounded, size: 14, color: Colors.red.shade600),
                      const SizedBox(width: 4),
                      Text(
                        "Delete",
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.red.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Web Parity: Auto Login or Staff Approval
              if (isUnapproved) ...[
                // Staff is Unapproved -> Approve Button + Web Cyan/Blue Login Button
                ElevatedButton.icon(
                  onPressed: () => _showApproveConfirmation(context, admin),
                  icon: const Icon(Icons.check_circle_outline_rounded, size: 13, color: Colors.white),
                  label: Text(
                    "Approve",
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                ),
                const SizedBox(width: 6),
                ElevatedButton.icon(
                  onPressed: () => _showAutoLoginConfirmation(context, admin),
                  icon: const Icon(Icons.login_rounded, size: 13, color: Colors.white),
                  label: Text(
                    "Login",
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0284C7),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                ),
              ] else ...[
                // Staff is Approved -> Web Cyan/Blue Login Button
                ElevatedButton.icon(
                  onPressed: () => _showAutoLoginConfirmation(context, admin),
                  icon: const Icon(Icons.login_rounded, size: 14, color: Colors.white),
                  label: Text(
                    "Login",
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0284C7),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, AdministratorItem admin) {
    final messenger = ScaffoldMessenger.of(context);
    final vm = context.read<AdministratorsViewModel>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.delete_forever_rounded, color: Colors.red.shade700, size: 22),
            ),
            const SizedBox(width: 12),
            Text(
              "Delete Staff",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        content: Text(
          "Are you sure you want to remove ${admin.fullName} (${admin.administratorId}) from administrators? This action cannot be undone.",
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: const Color(0xFF475569),
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              "Cancel",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF64748B),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await vm.deleteAdministrator(admin.id);
              messenger.showSnackBar(
                SnackBar(
                  content: Text(
                    success
                        ? "${admin.fullName} removed successfully"
                        : "Failed to delete administrator",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  backgroundColor: success ? const Color(0xFF10B981) : Colors.redAccent,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              "Delete",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showApproveConfirmation(BuildContext context, AdministratorItem admin) {
    final messenger = ScaffoldMessenger.of(context);
    final vm = context.read<AdministratorsViewModel>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.verified_user_rounded, color: Color(0xFF059669), size: 22),
            ),
            const SizedBox(width: 12),
            Text(
              "Approve Staff",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        content: Text(
          "Do you want to approve ${admin.fullName} (${admin.administratorId})? They will be granted Active Administrator status.",
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: const Color(0xFF475569),
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              "Cancel",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF64748B),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await vm.approveAdministrator(admin.id);
              messenger.showSnackBar(
                SnackBar(
                  content: Text(
                    success
                        ? "${admin.fullName} has been approved successfully! 🎉"
                        : "Failed to approve staff member",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  backgroundColor: success ? const Color(0xFF10B981) : Colors.redAccent,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              "Approve Now",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAutoLoginConfirmation(BuildContext context, AdministratorItem admin) {
    final messenger = ScaffoldMessenger.of(context);
    final vm = context.read<AdministratorsViewModel>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF0284C7).withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.key_rounded, color: Color(0xFF0284C7), size: 22),
            ),
            const SizedBox(width: 12),
            Text(
              "Auto Login",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        content: Text(
          "Switch session and log in as ${admin.fullName} (@${admin.username})?\n\nYou can exit this session anytime from the banner at top of the screen.",
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: const Color(0xFF475569),
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              "Cancel",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF64748B),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await vm.autoLogin(admin);
              messenger.showSnackBar(
                SnackBar(
                  content: Text(
                    "Switched session to ${admin.fullName} (@${admin.username}) 🔑",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  backgroundColor: const Color(0xFF0284C7),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0284C7),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              "Login as Staff",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
