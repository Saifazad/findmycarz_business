import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/administrator_meta_model.dart';

class Step5ModularAccessTab extends StatefulWidget {
  final List<MetaModuleOption> modules;
  final Map<int, Map<String, bool>> modulePermissions;
  final Set<int> expandedModuleIds;
  final List<String> leadModulesList;
  final String selectedLeadModule;
  final void Function(String module) onSelectLeadModule;
  final List<String> leadStatuses;
  final Map<String, Map<String, bool>> leadStatusPermissions;
  final void Function(String template) onApplyPermissionTemplate;
  final VoidCallback onPermissionsChanged;

  const Step5ModularAccessTab({
    super.key,
    required this.modules,
    required this.modulePermissions,
    required this.expandedModuleIds,
    required this.leadModulesList,
    required this.selectedLeadModule,
    required this.onSelectLeadModule,
    required this.leadStatuses,
    required this.leadStatusPermissions,
    required this.onApplyPermissionTemplate,
    required this.onPermissionsChanged,
  });

  @override
  State<Step5ModularAccessTab> createState() => _Step5ModularAccessTabState();
}

class _Step5ModularAccessTabState extends State<Step5ModularAccessTab> {
  int _selectedAccessSection = 0; // 0 = Business Modules, 1 = Lead Status Pipeline
  String _moduleSearchQuery = "";
  String _pipelineSearchQuery = "";
  final Set<String> _expandedStatusNames = {};

  IconData _getModuleIcon(String name) {
    final n = name.toLowerCase();
    if (n.contains('car') || n.contains('vehicle')) {
      return Icons.directions_car_filled_outlined;
    }
    if (n.contains('loan') || n.contains('refinance')) {
      return Icons.account_balance_outlined;
    }
    if (n.contains('contact') || n.contains('callback')) {
      return Icons.support_agent_outlined;
    }
    if (n.contains('user') || n.contains('admin')) {
      return Icons.manage_accounts_outlined;
    }
    if (n.contains('blog') || n.contains('content')) {
      return Icons.article_outlined;
    }
    if (n.contains('insurance')) return Icons.security_outlined;
    if (n.contains('property')) return Icons.home_work_outlined;
    if (n.contains('testimonial')) return Icons.rate_review_outlined;
    return Icons.widgets_outlined;
  }

  Color _getModuleColor(String name) {
    final n = name.toLowerCase();
    if (n.contains('loan') || n.contains('refinance')) {
      return const Color(0xFF003366);
    }
    if (n.contains('car') || n.contains('vehicle')) {
      return const Color(0xFF0284C7);
    }
    if (n.contains('insurance')) return const Color(0xFF10B981);
    if (n.contains('user') || n.contains('admin')) {
      return const Color(0xFF8B5CF6);
    }
    if (n.contains('contact') || n.contains('callback')) {
      return const Color(0xFFF59E0B);
    }
    return const Color(0xFF003366);
  }

  IconData _getStatusIcon(String status) {
    final s = status.toLowerCase();
    if (s.contains('new')) return Icons.fiber_new_rounded;
    if (s.contains('contact')) return Icons.support_agent_rounded;
    if (s.contains('follow')) return Icons.phone_callback_rounded;
    if (s.contains('pick')) return Icons.hail_rounded;
    if (s.contains('pending') && s.contains('doc')) {
      return Icons.pending_actions_rounded;
    }
    if (s.contains('received') && s.contains('doc')) return Icons.task_rounded;
    if (s.contains('sent to bank') || s.contains('bank')) {
      return Icons.account_balance_rounded;
    }
    if (s.contains('login')) return Icons.login_rounded;
    if (s.contains('reject')) return Icons.cancel_outlined;
    if (s.contains('approved') || s.contains('approval')) {
      return Icons.verified_rounded;
    }
    if (s.contains('disbursal stage')) return Icons.payments_outlined;
    if (s.contains('disbursed')) return Icons.check_circle_rounded;
    if (s.contains('rto done')) return Icons.assignment_turned_in_rounded;
    if (s.contains('rto')) return Icons.commute_rounded;
    if (s.contains('requested')) return Icons.request_quote_outlined;
    if (s.contains('payment in process') || s.contains('process')) {
      return Icons.autorenew_rounded;
    }
    if (s.contains('payment done')) return Icons.price_check_rounded;
    if (s.contains('accounts')) return Icons.account_balance_wallet_rounded;
    if (s.contains('handover') || s.contains('vehicle')) return Icons.key_rounded;
    if (s.contains('pdd submitted')) return Icons.mark_email_read_rounded;
    if (s.contains('pdd')) return Icons.hourglass_top_rounded;
    if (s.contains('completed')) return Icons.workspace_premium_rounded;
    if (s.contains('cancell')) return Icons.highlight_off_rounded;
    return Icons.filter_alt_outlined;
  }

  Color _getStatusColor(String status) {
    final s = status.toLowerCase();
    if (s.contains('reject') || s.contains('cancell')) {
      return const Color(0xFFEF4444);
    }
    if (s.contains('approved') ||
        s.contains('disbursed') ||
        s.contains('completed') ||
        s.contains('done')) {
      return const Color(0xFF10B981);
    }
    if (s.contains('bank') || s.contains('login') || s.contains('payment')) {
      return const Color(0xFF0284C7);
    }
    if (s.contains('rto') || s.contains('handover')) {
      return const Color(0xFF8B5CF6);
    }
    if (s.contains('pending') || s.contains('follow') || s.contains('pick')) {
      return const Color(0xFFF59E0B);
    }
    return const Color(0xFF003366);
  }

  Widget _buildPremiumStatusCard(String statusName) {
    widget.leadStatusPermissions.putIfAbsent(
        statusName,
        () => {
              'view': false,
              'add': false,
              'edit': false,
              'delete': false,
              'status': false,
              'availability': false,
              'assign': false,
            });
    final sPerms = widget.leadStatusPermissions[statusName]!;

    final bool canAdd = statusName == "New Lead";
    final int totalPossible = canAdd ? 5 : 4;

    int grantedCount = 0;
    if (sPerms['view'] == true) grantedCount++;
    if (canAdd && sPerms['add'] == true) grantedCount++;
    if (sPerms['edit'] == true) grantedCount++;
    if (sPerms['delete'] == true) grantedCount++;
    if (sPerms['status'] == true) grantedCount++;

    final isAllGranted = grantedCount == totalPossible;
    final isNoneGranted = grantedCount == 0;
    final isViewOnly = grantedCount == 1 && sPerms['view'] == true;

    final iconData = _getStatusIcon(statusName);
    final themeColor = _getStatusColor(statusName);

    Color badgeColor;
    String badgeText;
    if (isAllGranted) {
      badgeColor = const Color(0xFF10B981);
      badgeText = "Full Access";
    } else if (isViewOnly) {
      badgeColor = const Color(0xFF0284C7);
      badgeText = "View Only";
    } else if (isNoneGranted) {
      badgeColor = const Color(0xFF94A3B8);
      badgeText = "No Access";
    } else {
      badgeColor = const Color(0xFFF59E0B);
      badgeText = "$grantedCount/$totalPossible Allowed";
    }

    final isExpanded = _expandedStatusNames.contains(statusName);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: !isNoneGranted
              ? themeColor.withValues(alpha: 0.35)
              : const Color(0xFFE2E8F0),
          width: !isNoneGranted ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: !isNoneGranted
                ? themeColor.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                if (isExpanded) {
                  _expandedStatusNames.remove(statusName);
                } else {
                  _expandedStatusNames.add(statusName);
                }
              });
            },
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: themeColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(iconData, color: themeColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          statusName,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: badgeColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            badgeText,
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: badgeColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      value: !isNoneGranted,
                      activeThumbColor: Colors.white,
                      activeTrackColor: themeColor,
                      inactiveThumbColor: Colors.grey.shade400,
                      inactiveTrackColor: Colors.grey.shade200,
                      onChanged: (val) {
                        setState(() {
                          sPerms['view'] = val;
                          if (canAdd) sPerms['add'] = val;
                          sPerms['edit'] = val;
                          sPerms['delete'] = val;
                          sPerms['status'] = val;
                          sPerms['assign'] = false;
                          sPerms['availability'] = false;
                        });
                        HapticFeedback.lightImpact();
                        widget.onPermissionsChanged();
                      },
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: const Color(0xFF64748B),
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Actions & Permissions",
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                sPerms['view'] = true;
                                if (canAdd) sPerms['add'] = true;
                                sPerms['edit'] = true;
                                sPerms['delete'] = true;
                                sPerms['status'] = true;
                                sPerms['assign'] = false;
                                sPerms['availability'] = false;
                              });
                              widget.onPermissionsChanged();
                            },
                            child: Text(
                              "Grant All",
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF003366),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              setState(() {
                                sPerms['view'] = true;
                                sPerms['add'] = false;
                                sPerms['edit'] = false;
                                sPerms['delete'] = false;
                                sPerms['status'] = false;
                                sPerms['assign'] = false;
                                sPerms['availability'] = false;
                              });
                              widget.onPermissionsChanged();
                            },
                            child: Text(
                              "View Only",
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF0284C7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildModernActionPill(
                        label: "View",
                        icon: Icons.visibility_outlined,
                        isActive: sPerms['view'] ?? false,
                        activeColor: const Color(0xFF003366),
                        onTap: () => setState(
                            () => sPerms['view'] = !(sPerms['view'] ?? false)),
                      ),
                      if (canAdd)
                        _buildModernActionPill(
                          label: "Add",
                          icon: Icons.add_circle_outline_rounded,
                          isActive: sPerms['add'] ?? false,
                          activeColor: const Color(0xFF10B981),
                          onTap: () => setState(
                              () => sPerms['add'] = !(sPerms['add'] ?? false)),
                        ),
                      _buildModernActionPill(
                        label: "Edit",
                        icon: Icons.edit_outlined,
                        isActive: sPerms['edit'] ?? false,
                        activeColor: const Color(0xFF0284C7),
                        onTap: () => setState(
                            () => sPerms['edit'] = !(sPerms['edit'] ?? false)),
                      ),
                      _buildModernActionPill(
                        label: "Delete",
                        icon: Icons.delete_outline_rounded,
                        isActive: sPerms['delete'] ?? false,
                        activeColor: const Color(0xFFEF4444),
                        onTap: () => setState(() =>
                            sPerms['delete'] = !(sPerms['delete'] ?? false)),
                      ),
                      _buildModernActionPill(
                        label: "Status",
                        icon: Icons.toggle_on_outlined,
                        isActive: sPerms['status'] ?? false,
                        activeColor: const Color(0xFF8B5CF6),
                        onTap: () => setState(() =>
                            sPerms['status'] = !(sPerms['status'] ?? false)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTemplateChip({
    required String label,
    required VoidCallback onTap,
    required Color bg,
    required Color textColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildModernActionPill({
    required String label,
    required IconData icon,
    required bool isActive,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
        widget.onPermissionsChanged();
      },
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isActive ? activeColor : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive ? activeColor : const Color(0xFFE2E8F0),
            width: 1.2,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.25),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isActive ? Colors.white : const Color(0xFF64748B),
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? Colors.white : const Color(0xFF334155),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumModuleCard(MetaModuleOption m) {
    widget.modulePermissions.putIfAbsent(
        m.id,
        () => {
              'view': false,
              'add': false,
              'edit': false,
              'delete': false,
              'status': false,
              'availability': false,
              'assign': false,
            });
    final perms = widget.modulePermissions[m.id]!;

    int totalPossible = 0;
    if (m.hasView) totalPossible++;
    if (m.hasAdd) totalPossible++;
    if (m.hasEdit) totalPossible++;
    if (m.hasDelete) totalPossible++;
    if (m.hasStatus) totalPossible++;
    if (m.hasCarStatus) totalPossible++;
    if (m.hasAssign) totalPossible++;
    if (totalPossible == 0) totalPossible = 1;

    int grantedCount = 0;
    if (m.hasView && (perms['view'] == true)) grantedCount++;
    if (m.hasAdd && (perms['add'] == true)) grantedCount++;
    if (m.hasEdit && (perms['edit'] == true)) grantedCount++;
    if (m.hasDelete && (perms['delete'] == true)) grantedCount++;
    if (m.hasStatus && (perms['status'] == true)) grantedCount++;
    if (m.hasCarStatus &&
        (perms['availability'] == true || perms['car_status'] == true)) {
      grantedCount++;
    }
    if (m.hasAssign && (perms['assign'] == true)) grantedCount++;

    final isAllGranted = grantedCount == totalPossible;
    final isNoneGranted = grantedCount == 0;
    final isViewOnly = grantedCount == 1 && perms['view'] == true;

    final iconData = _getModuleIcon(m.name);
    final themeColor = _getModuleColor(m.name);

    Color badgeColor;
    String badgeText;
    if (isAllGranted) {
      badgeColor = const Color(0xFF10B981);
      badgeText = "Full Access";
    } else if (isViewOnly) {
      badgeColor = const Color(0xFF0284C7);
      badgeText = "View Only";
    } else if (isNoneGranted) {
      badgeColor = const Color(0xFF94A3B8);
      badgeText = "No Access";
    } else {
      badgeColor = const Color(0xFFF59E0B);
      badgeText = "$grantedCount/$totalPossible Allowed";
    }

    final isExpanded = widget.expandedModuleIds.contains(m.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: !isNoneGranted
              ? themeColor.withValues(alpha: 0.35)
              : const Color(0xFFE2E8F0),
          width: !isNoneGranted ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: !isNoneGranted
                ? themeColor.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                if (isExpanded) {
                  widget.expandedModuleIds.remove(m.id);
                } else {
                  widget.expandedModuleIds.add(m.id);
                }
              });
            },
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: themeColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(iconData, color: themeColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          m.name,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: badgeColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            badgeText,
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: badgeColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      value: !isNoneGranted,
                      activeThumbColor: Colors.white,
                      activeTrackColor: themeColor,
                      inactiveThumbColor: Colors.grey.shade400,
                      inactiveTrackColor: Colors.grey.shade200,
                      onChanged: (val) {
                        setState(() {
                          if (m.hasView) perms['view'] = val;
                          if (m.hasAdd) perms['add'] = val;
                          if (m.hasEdit) perms['edit'] = val;
                          if (m.hasDelete) perms['delete'] = val;
                          if (m.hasStatus) perms['status'] = val;
                          if (m.hasAssign) perms['assign'] = val;
                          if (m.hasCarStatus) {
                            perms['availability'] = val;
                            perms['car_status'] = val;
                          }
                        });
                        HapticFeedback.lightImpact();
                        widget.onPermissionsChanged();
                      },
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: const Color(0xFF64748B),
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Actions & Permissions",
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (m.hasView) perms['view'] = true;
                                if (m.hasAdd) perms['add'] = true;
                                if (m.hasEdit) perms['edit'] = true;
                                if (m.hasDelete) perms['delete'] = true;
                                if (m.hasStatus) perms['status'] = true;
                                if (m.hasAssign) perms['assign'] = true;
                                if (m.hasCarStatus) {
                                  perms['availability'] = true;
                                  perms['car_status'] = true;
                                }
                              });
                              widget.onPermissionsChanged();
                            },
                            child: Text(
                              "Grant All",
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF003366),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              setState(() {
                                perms['view'] = m.hasView;
                                perms['add'] = false;
                                perms['edit'] = false;
                                perms['delete'] = false;
                                perms['status'] = false;
                                perms['assign'] = false;
                              });
                              widget.onPermissionsChanged();
                            },
                            child: Text(
                              "View Only",
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF0284C7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (m.hasView)
                        _buildModernActionPill(
                          label: "View",
                          icon: Icons.visibility_outlined,
                          isActive: perms['view'] ?? false,
                          activeColor: const Color(0xFF003366),
                          onTap: () => setState(
                              () => perms['view'] = !(perms['view'] ?? false)),
                        ),
                      if (m.hasAdd)
                        _buildModernActionPill(
                          label: "Add",
                          icon: Icons.add_circle_outline_rounded,
                          isActive: perms['add'] ?? false,
                          activeColor: const Color(0xFF10B981),
                          onTap: () => setState(
                              () => perms['add'] = !(perms['add'] ?? false)),
                        ),
                      if (m.hasEdit)
                        _buildModernActionPill(
                          label: "Edit",
                          icon: Icons.edit_outlined,
                          isActive: perms['edit'] ?? false,
                          activeColor: const Color(0xFF0284C7),
                          onTap: () => setState(
                              () => perms['edit'] = !(perms['edit'] ?? false)),
                        ),
                      if (m.hasDelete)
                        _buildModernActionPill(
                          label: "Delete",
                          icon: Icons.delete_outline_rounded,
                          isActive: perms['delete'] ?? false,
                          activeColor: const Color(0xFFEF4444),
                          onTap: () => setState(() =>
                              perms['delete'] = !(perms['delete'] ?? false)),
                        ),
                      if (m.hasStatus)
                        _buildModernActionPill(
                          label: "Status",
                          icon: Icons.toggle_on_outlined,
                          isActive: perms['status'] ?? false,
                          activeColor: const Color(0xFF8B5CF6),
                          onTap: () => setState(() =>
                              perms['status'] = !(perms['status'] ?? false)),
                        ),
                      if (m.hasCarStatus)
                        _buildModernActionPill(
                          label: "Availability",
                          icon: Icons.event_available_outlined,
                          isActive: perms['availability'] ??
                              perms['car_status'] ??
                              false,
                          activeColor: const Color(0xFF10B981),
                          onTap: () => setState(() {
                            final current = perms['availability'] ??
                                perms['car_status'] ??
                                false;
                            perms['availability'] = !current;
                            perms['car_status'] = !current;
                          }),
                        ),
                      if (m.hasAssign)
                        _buildModernActionPill(
                          label: "Assign",
                          icon: Icons.person_add_alt_1_outlined,
                          isActive: perms['assign'] ?? false,
                          activeColor: const Color(0xFFF59E0B),
                          onTap: () => setState(() =>
                              perms['assign'] = !(perms['assign'] ?? false)),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredModules = widget.modules.where((m) {
      if (_moduleSearchQuery.trim().isEmpty) return true;
      return m.name
          .toLowerCase()
          .contains(_moduleSearchQuery.trim().toLowerCase());
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🚀 1-Tap Permission Templates
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF003366), Color(0xFF0F4C81)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF003366).withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.bolt, color: Colors.amber, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          "1-Tap Permission Presets",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "Fast Setup",
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildTemplateChip(
                      label: "👑 Full Admin",
                      onTap: () =>
                          widget.onApplyPermissionTemplate("Full Admin"),
                      bg: Colors.white,
                      textColor: const Color(0xFF003366),
                    ),
                    _buildTemplateChip(
                      label: "💼 Sales Team",
                      onTap: () =>
                          widget.onApplyPermissionTemplate("Sales Team"),
                      bg: const Color(0xFF10B981),
                      textColor: Colors.white,
                    ),
                    _buildTemplateChip(
                      label: "👁️ View Only",
                      onTap: () =>
                          widget.onApplyPermissionTemplate("View Only"),
                      bg: const Color(0xFF0284C7),
                      textColor: Colors.white,
                    ),
                    _buildTemplateChip(
                      label: "🔄 Reset All",
                      onTap: () => widget.onApplyPermissionTemplate("Reset"),
                      bg: Colors.redAccent.withValues(alpha: 0.2),
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 🔀 Segmented Sub-Tab Switcher
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _selectedAccessSection = 0),
                    borderRadius: BorderRadius.circular(10),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _selectedAccessSection == 0
                            ? Colors.white
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: _selectedAccessSection == 0
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.dashboard_customize_outlined,
                            size: 15,
                            color: _selectedAccessSection == 0
                                ? const Color(0xFF003366)
                                : const Color(0xFF64748B),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Modules (${widget.modules.length})",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: _selectedAccessSection == 0
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: _selectedAccessSection == 0
                                  ? const Color(0xFF003366)
                                  : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _selectedAccessSection = 1),
                    borderRadius: BorderRadius.circular(10),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _selectedAccessSection == 1
                            ? Colors.white
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: _selectedAccessSection == 1
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.timeline_rounded,
                            size: 15,
                            color: _selectedAccessSection == 1
                                ? const Color(0xFF003366)
                                : const Color(0xFF64748B),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Lead Pipeline (${widget.leadStatuses.length})",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: _selectedAccessSection == 1
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: _selectedAccessSection == 1
                                  ? const Color(0xFF003366)
                                  : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // View 1: Business Modules
          if (_selectedAccessSection == 0) ...[
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (val) =>
                        setState(() => _moduleSearchQuery = val),
                    decoration: InputDecoration(
                      hintText: "Search module (e.g. Cars, Loans)...",
                      hintStyle: GoogleFonts.poppins(
                          fontSize: 12, color: const Color(0xFF94A3B8)),
                      prefixIcon: const Icon(Icons.search,
                          size: 18, color: Color(0xFF003366)),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                PopupMenuButton<String>(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  icon: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: const Icon(Icons.tune_rounded,
                        size: 18, color: Color(0xFF003366)),
                  ),
                  onSelected: (val) {
                    if (val == "expand_all") {
                      setState(() => widget.expandedModuleIds
                          .addAll(widget.modules.map((m) => m.id)));
                    } else if (val == "collapse_all") {
                      setState(() => widget.expandedModuleIds.clear());
                    } else if (val == "grant_all") {
                      widget.onApplyPermissionTemplate("Full Admin");
                    } else if (val == "revoke_all") {
                      widget.onApplyPermissionTemplate("Reset");
                    }
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                        value: "expand_all", child: Text("Expand All Cards")),
                    const PopupMenuItem(
                        value: "collapse_all",
                        child: Text("Collapse All Cards")),
                    const PopupMenuDivider(),
                    const PopupMenuItem(
                        value: "grant_all", child: Text("Grant All Access")),
                    const PopupMenuItem(
                        value: "revoke_all", child: Text("Revoke All Access")),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),

            if (filteredModules.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Column(
                    children: [
                      const Icon(Icons.search_off_rounded,
                          size: 40, color: Colors.grey),
                      const SizedBox(height: 8),
                      Text("No matching modules found",
                          style: GoogleFonts.poppins(
                              color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                ),
              )
            else
              ...filteredModules.map((m) => _buildPremiumModuleCard(m)),
          ],

          // View 2: Lead Status Pipeline
          if (_selectedAccessSection == 1) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
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
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF003366).withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.playlist_add_check_rounded,
                            size: 18, color: Color(0xFF003366)),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Leads Status & Modular Access",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Select a lead module from the dropdown below to configure permissions per status.",
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Text(
                        "Module: ",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: widget.selectedLeadModule,
                          isExpanded: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
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
                          ),
                          items: widget.leadModulesList
                              .map((m) => DropdownMenuItem(
                                  value: m,
                                  child: Text(m,
                                      style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600),
                                      overflow: TextOverflow.ellipsis)))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              widget.onSelectLeadModule(val);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Transform.scale(
                            scale: 0.8,
                            child: Switch(
                              value: widget.leadStatuses.isNotEmpty &&
                                  widget.leadStatuses.every((s) {
                                    final p = widget.leadStatusPermissions[s];
                                    if (p == null) return false;
                                    final v = p['view'] == true;
                                    final e = p['edit'] == true;
                                    final d = p['delete'] == true;
                                    final st = p['status'] == true;
                                    final a = (s == "New Lead")
                                        ? (p['add'] == true)
                                        : true;
                                    return v && e && d && st && a;
                                  }),
                              activeThumbColor: Colors.white,
                              activeTrackColor: const Color(0xFF10B981),
                              inactiveThumbColor: Colors.grey.shade400,
                              inactiveTrackColor: Colors.grey.shade200,
                              onChanged: (val) {
                                setState(() {
                                  for (var s in widget.leadStatuses) {
                                    widget.leadStatusPermissions.putIfAbsent(
                                        s,
                                        () => {
                                              'view': false,
                                              'add': false,
                                              'edit': false,
                                              'delete': false,
                                              'status': false,
                                              'availability': false,
                                              'assign': false,
                                            });
                                    final p = widget.leadStatusPermissions[s]!;
                                    p['view'] = val;
                                    p['add'] = (s == "New Lead") ? val : false;
                                    p['edit'] = val;
                                    p['delete'] = val;
                                    p['status'] = val;
                                    p['availability'] = false;
                                    p['assign'] = false;
                                  }
                                });
                                HapticFeedback.lightImpact();
                                widget.onPermissionsChanged();
                              },
                            ),
                          ),
                          Text(
                            "Select All\n(This Module)",
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF334155),
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: const Color(0xFF10B981).withValues(alpha: 0.25)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.layers_rounded,
                                  size: 13, color: Colors.white),
                              const SizedBox(width: 5),
                              Text(
                                widget.selectedLeadModule,
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Configure status-level permissions for ${widget.selectedLeadModule}",
                            style: GoogleFonts.poppins(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF047857),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Search bar & tune popup for lead statuses
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (val) =>
                        setState(() => _pipelineSearchQuery = val),
                    decoration: InputDecoration(
                      hintText: "Search status (e.g. New Lead, Approved)...",
                      hintStyle: GoogleFonts.poppins(
                          fontSize: 12, color: const Color(0xFF94A3B8)),
                      prefixIcon: const Icon(Icons.search,
                          size: 18, color: Color(0xFF003366)),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                PopupMenuButton<String>(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  icon: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: const Icon(Icons.tune_rounded,
                        size: 18, color: Color(0xFF003366)),
                  ),
                  onSelected: (val) {
                    if (val == "expand_all") {
                      setState(() => _expandedStatusNames
                          .addAll(widget.leadStatuses));
                    } else if (val == "collapse_all") {
                      setState(() => _expandedStatusNames.clear());
                    } else if (val == "grant_all") {
                      setState(() {
                        for (var s in widget.leadStatuses) {
                          widget.leadStatusPermissions.putIfAbsent(
                              s,
                              () => {
                                    'view': false,
                                    'add': false,
                                    'edit': false,
                                    'delete': false,
                                    'status': false,
                                    'availability': false,
                                    'assign': false,
                                  });
                          final p = widget.leadStatusPermissions[s]!;
                          p['view'] = true;
                          p['add'] = (s == "New Lead");
                          p['edit'] = true;
                          p['delete'] = true;
                          p['status'] = true;
                          p['availability'] = false;
                          p['assign'] = false;
                        }
                      });
                      widget.onPermissionsChanged();
                    } else if (val == "revoke_all") {
                      setState(() {
                        for (var s in widget.leadStatuses) {
                          widget.leadStatusPermissions.putIfAbsent(
                              s,
                              () => {
                                    'view': false,
                                    'add': false,
                                    'edit': false,
                                    'delete': false,
                                    'status': false,
                                    'availability': false,
                                    'assign': false,
                                  });
                          final p = widget.leadStatusPermissions[s]!;
                          p['view'] = false;
                          p['add'] = false;
                          p['edit'] = false;
                          p['delete'] = false;
                          p['status'] = false;
                          p['availability'] = false;
                          p['assign'] = false;
                        }
                      });
                      widget.onPermissionsChanged();
                    }
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                        value: "expand_all", child: Text("Expand All Cards")),
                    const PopupMenuItem(
                        value: "collapse_all",
                        child: Text("Collapse All Cards")),
                    const PopupMenuDivider(),
                    PopupMenuItem(
                        value: "grant_all",
                        child: Text("Grant All ${widget.leadStatuses.length} Statuses")),
                    const PopupMenuItem(
                        value: "revoke_all", child: Text("Revoke All")),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Status cards list
            Builder(builder: (context) {
              final filteredStatuses = widget.leadStatuses.where((s) {
                if (_pipelineSearchQuery.trim().isEmpty) return true;
                return s
                    .toLowerCase()
                    .contains(_pipelineSearchQuery.trim().toLowerCase());
              }).toList();

              if (filteredStatuses.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Column(
                      children: [
                        const Icon(Icons.search_off_rounded,
                            size: 40, color: Colors.grey),
                        const SizedBox(height: 8),
                        Text("No matching status found",
                            style: GoogleFonts.poppins(
                                color: Colors.grey, fontSize: 13)),
                      ],
                    ),
                  ),
                );
              }

              return Column(
                children: filteredStatuses
                    .map((statusName) => _buildPremiumStatusCard(statusName))
                    .toList(),
              );
            }),
          ],
        ],
      ),
    );
  }
}
