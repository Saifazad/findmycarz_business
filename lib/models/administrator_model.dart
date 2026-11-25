class AdministratorListResponse {
  final bool status;
  final AdministratorCounts counts;
  final AdministratorPagination pagination;
  final List<AdministratorItem> data;

  AdministratorListResponse({
    required this.status,
    required this.counts,
    required this.pagination,
    required this.data,
  });

  factory AdministratorListResponse.fromJson(Map<String, dynamic> json) {
    var rawList = json['data'];
    List<AdministratorItem> items = [];
    if (rawList is List) {
      items = rawList
          .whereType<Map<String, dynamic>>()
          .map((i) => AdministratorItem.fromJson(i))
          .toList();
    }

    return AdministratorListResponse(
      status: json['status'] == true,
      counts: AdministratorCounts.fromJson(json['counts'] ?? {}),
      pagination: AdministratorPagination.fromJson(json['pagination'] ?? {}),
      data: items,
    );
  }
}

class AdministratorCounts {
  final int total;
  final int active;
  final int inactive;
  final int unapproved;

  AdministratorCounts({
    this.total = 0,
    this.active = 0,
    this.inactive = 0,
    this.unapproved = 0,
  });

  factory AdministratorCounts.fromJson(Map<String, dynamic> json) {
    return AdministratorCounts(
      total: _parseInt(json['total']),
      active: _parseInt(json['active']),
      inactive: _parseInt(json['inactive']),
      unapproved: _parseInt(json['unapproved']),
    );
  }

  static int _parseInt(dynamic val) {
    if (val is int) return val;
    return int.tryParse(val?.toString() ?? '0') ?? 0;
  }
}

class AdministratorPagination {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  AdministratorPagination({
    this.currentPage = 1,
    this.lastPage = 1,
    this.perPage = 20,
    this.total = 0,
  });

  factory AdministratorPagination.fromJson(Map<String, dynamic> json) {
    return AdministratorPagination(
      currentPage: _parseInt(json['current_page'], 1),
      lastPage: _parseInt(json['last_page'], 1),
      perPage: _parseInt(json['per_page'], 20),
      total: _parseInt(json['total'], 0),
    );
  }

  static int _parseInt(dynamic val, int fallback) {
    if (val is int) return val;
    return int.tryParse(val?.toString() ?? '') ?? fallback;
  }
}

class AdministratorItem {
  final int id;
  final String administratorId;
  final String fullName;
  final String username;
  final String? email;
  final String? phone;
  final String? altPhone;
  final String? gender;
  final String? imageUrl;
  final int status;
  final String statusText;
  final AdminRoleBrief? role;
  final AdminParentBrief? parent;
  final String? city;
  final String? state;
  final String? createdAt;
  final dynamic rawModularAccess;

  AdministratorItem({
    required this.id,
    required this.administratorId,
    required this.fullName,
    required this.username,
    this.email,
    this.phone,
    this.altPhone,
    this.gender,
    this.imageUrl,
    this.status = 1,
    this.statusText = "Active",
    this.role,
    this.parent,
    this.city,
    this.state,
    this.createdAt,
    this.rawModularAccess,
  });

  factory AdministratorItem.fromJson(Map<String, dynamic> json) {
    return AdministratorItem(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      administratorId: json['administrator_id']?.toString() ?? "AFMC${json['id'] ?? ''}",
      fullName: json['full_name']?.toString() ?? json['name']?.toString() ?? "Staff Member",
      username: json['username']?.toString() ?? "",
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      altPhone: json['alt_phone']?.toString(),
      gender: json['gender']?.toString(),
      imageUrl: json['image_url']?.toString() ?? json['image']?.toString(),
      status: json['status'] is int ? json['status'] : int.tryParse(json['status']?.toString() ?? '1') ?? 1,
      statusText: json['status_text']?.toString() ?? (json['status'] == 1 ? "Active" : "Inactive"),
      role: json['role'] is Map<String, dynamic>
          ? AdminRoleBrief.fromJson(json['role'])
          : null,
      parent: json['parent'] is Map<String, dynamic>
          ? AdminParentBrief.fromJson(json['parent'])
          : null,
      city: json['city']?.toString(),
      state: json['state']?.toString(),
      createdAt: json['created_at']?.toString(),
      rawModularAccess: json['modular_access'] ?? json['modules'] ?? json['permissions'] ?? json['access'],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdministratorItem &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class AdminRoleBrief {
  final int id;
  final String name;
  final String code;

  AdminRoleBrief({required this.id, required this.name, required this.code});

  factory AdminRoleBrief.fromJson(Map<String, dynamic> json) {
    return AdminRoleBrief(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? "Role",
      code: json['code']?.toString() ?? "",
    );
  }
}

class AdminParentBrief {
  final int id;
  final String fullName;
  final String? username;

  AdminParentBrief({required this.id, required this.fullName, this.username});

  factory AdminParentBrief.fromJson(Map<String, dynamic> json) {
    return AdminParentBrief(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      fullName: json['full_name']?.toString() ?? "Manager",
      username: json['username']?.toString(),
    );
  }
}
