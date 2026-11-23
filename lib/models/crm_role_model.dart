class CrmRoleResponse {
  final bool status;
  final int totalRoles;
  final List<CrmRoleItem> data;

  CrmRoleResponse({
    required this.status,
    required this.totalRoles,
    required this.data,
  });

  factory CrmRoleResponse.fromJson(Map<String, dynamic> json) {
    var rawList = json['data'];
    List<CrmRoleItem> roles = [];
    if (rawList is List) {
      roles = rawList
          .whereType<Map<String, dynamic>>()
          .map((r) => CrmRoleItem.fromJson(r))
          .toList();
    }

    return CrmRoleResponse(
      status: json['status'] == true,
      totalRoles: json['total_roles'] is int
          ? json['total_roles']
          : int.tryParse(json['total_roles']?.toString() ?? '0') ?? roles.length,
      data: roles,
    );
  }
}

class CrmRoleItem {
  final int id;
  final String name;
  final String code;
  final int parentId;
  final String? parentName;
  final bool showInAssignLeads;
  final int status;
  final String statusText;
  final int sortOrder;
  final bool isPermanent;
  final int activeUsersCount;

  CrmRoleItem({
    required this.id,
    required this.name,
    required this.code,
    required this.parentId,
    this.parentName,
    this.showInAssignLeads = false,
    this.status = 1,
    this.statusText = "Active",
    this.sortOrder = 0,
    this.isPermanent = false,
    this.activeUsersCount = 0,
  });

  factory CrmRoleItem.fromJson(Map<String, dynamic> json) {
    return CrmRoleItem(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? "Role",
      code: json['code']?.toString() ?? "",
      parentId: json['parent_id'] is int
          ? json['parent_id']
          : int.tryParse(json['parent_id']?.toString() ?? '0') ?? 0,
      parentName: json['parent_name']?.toString(),
      showInAssignLeads: json['show_in_assign_leads'] == true || json['show_in_assign_leads'] == 1,
      status: json['status'] is int ? json['status'] : int.tryParse(json['status']?.toString() ?? '1') ?? 1,
      statusText: json['status_text']?.toString() ?? "Active",
      sortOrder: json['sort_order'] is int
          ? json['sort_order']
          : int.tryParse(json['sort_order']?.toString() ?? '0') ?? 0,
      isPermanent: json['is_permanent'] == true || json['is_permanent'] == 1,
      activeUsersCount: json['active_users_count'] is int
          ? json['active_users_count']
          : int.tryParse(json['active_users_count']?.toString() ?? '0') ?? 0,
    );
  }
}
