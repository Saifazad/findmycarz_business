class AdminProfileModel {
  final int? id;
  final String? username;
  final String? fullName;
  final String? email;
  final String? phone;
  final String? altPhone;
  final String? gender;
  final String? dob;
  final String? image;
  final AdminRoleInfo? role;
  final String? state;
  final String? city;
  final int? status;
  final bool isSuperAdmin;
  final List<ModuleAccess> modulesAccess;

  AdminProfileModel({
    this.id,
    this.username,
    this.fullName,
    this.email,
    this.phone,
    this.altPhone,
    this.gender,
    this.dob,
    this.image,
    this.role,
    this.state,
    this.city,
    this.status,
    this.isSuperAdmin = false,
    this.modulesAccess = const [],
  });

  factory AdminProfileModel.fromJson(Map<String, dynamic> json) {
    var rawModules = json['modules_access'];
    List<ModuleAccess> parsedModules = [];
    if (rawModules is List) {
      parsedModules = rawModules
          .whereType<Map<String, dynamic>>()
          .map((m) => ModuleAccess.fromJson(m))
          .toList();
    }

    return AdminProfileModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      username: json['username']?.toString(),
      fullName: json['full_name']?.toString(),
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      altPhone: json['alt_phone']?.toString(),
      gender: json['gender']?.toString(),
      dob: json['dob']?.toString(),
      image: json['image']?.toString(),
      role: json['role'] is Map<String, dynamic>
          ? AdminRoleInfo.fromJson(json['role'])
          : null,
      state: json['state']?.toString(),
      city: json['city']?.toString(),
      status: json['status'] is int ? json['status'] : int.tryParse(json['status']?.toString() ?? ''),
      isSuperAdmin: json['is_super_admin'] == true || json['is_super_admin'] == 1,
      modulesAccess: parsedModules,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'alt_phone': altPhone,
      'gender': gender,
      'dob': dob,
      'image': image,
      'role': role?.toJson(),
      'state': state,
      'city': city,
      'status': status,
      'is_super_admin': isSuperAdmin,
      'modules_access': modulesAccess.map((m) => m.toJson()).toList(),
    };
  }

  AdminProfileModel copyWith({
    int? id,
    String? username,
    String? fullName,
    String? email,
    String? phone,
    String? altPhone,
    String? gender,
    String? dob,
    String? image,
    AdminRoleInfo? role,
    String? state,
    String? city,
    int? status,
    bool? isSuperAdmin,
    List<ModuleAccess>? modulesAccess,
  }) {
    return AdminProfileModel(
      id: id ?? this.id,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      altPhone: altPhone ?? this.altPhone,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      image: image ?? this.image,
      role: role ?? this.role,
      state: state ?? this.state,
      city: city ?? this.city,
      status: status ?? this.status,
      isSuperAdmin: isSuperAdmin ?? this.isSuperAdmin,
      modulesAccess: modulesAccess ?? this.modulesAccess,
    );
  }
}

class AdminRoleInfo {
  final int? id;
  final String? name;
  final String? code;

  AdminRoleInfo({this.id, this.name, this.code});

  factory AdminRoleInfo.fromJson(Map<String, dynamic> json) {
    return AdminRoleInfo(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      name: json['name']?.toString(),
      code: json['code']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'code': code};
}

class ModuleAccess {
  final int? moduleId;
  final bool canView;
  final bool canAdd;
  final bool canEdit;
  final bool canDelete;

  ModuleAccess({
    this.moduleId,
    this.canView = false,
    this.canAdd = false,
    this.canEdit = false,
    this.canDelete = false,
  });

  factory ModuleAccess.fromJson(Map<String, dynamic> json) {
    return ModuleAccess(
      moduleId: json['module_id'] is int
          ? json['module_id']
          : int.tryParse(json['module_id']?.toString() ?? ''),
      canView: json['can_view'] == true || json['can_view'] == 1,
      canAdd: json['can_add'] == true || json['can_add'] == 1,
      canEdit: json['can_edit'] == true || json['can_edit'] == 1,
      canDelete: json['can_delete'] == true || json['can_delete'] == 1,
    );
  }

  Map<String, dynamic> toJson() => {
        'module_id': moduleId,
        'can_view': canView,
        'can_add': canAdd,
        'can_edit': canEdit,
        'can_delete': canDelete,
      };
}
