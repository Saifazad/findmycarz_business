class AdministratorMetaModel {
  final List<MetaRoleOption> roles;
  final List<MetaStateOption> states;
  final List<MetaCityOption> cities;
  final List<MetaModuleOption> modules;
  final List<MetaBankOption> payoutBanks;
  final List<MetaCategoryOption> payoutCategories;

  AdministratorMetaModel({
    this.roles = const [],
    this.states = const [],
    this.cities = const [],
    this.modules = const [],
    this.payoutBanks = const [],
    this.payoutCategories = const [],
  });

  factory AdministratorMetaModel.fromJson(Map<String, dynamic> json) {
    var rawRoles = json['roles'];
    var rawStates = json['states'];
    var rawCities = json['cities'];
    var rawModules = json['modules'];
    var rawBanks = json['payout_banks'];
    var rawCats = json['payout_categories'];

    return AdministratorMetaModel(
      roles: rawRoles is List
          ? rawRoles
              .whereType<Map<String, dynamic>>()
              .map((r) => MetaRoleOption.fromJson(r))
              .toList()
          : [],
      states: rawStates is List
          ? rawStates
              .whereType<Map<String, dynamic>>()
              .map((s) => MetaStateOption.fromJson(s))
              .toList()
          : [],
      cities: rawCities is List
          ? rawCities
              .whereType<Map<String, dynamic>>()
              .map((c) => MetaCityOption.fromJson(c))
              .toList()
          : [],
      modules: rawModules is List
          ? MetaModuleOption.filterToWebCrmModules(rawModules
              .whereType<Map<String, dynamic>>()
              .map((m) => MetaModuleOption.fromJson(m))
              .toList())
          : MetaModuleOption.filterToWebCrmModules([]),
      payoutBanks: rawBanks is List
          ? rawBanks
              .whereType<Map<String, dynamic>>()
              .map((b) => MetaBankOption.fromJson(b))
              .toList()
          : [],
      payoutCategories: rawCats is List
          ? rawCats
              .whereType<Map<String, dynamic>>()
              .map((c) => MetaCategoryOption.fromJson(c))
              .toList()
          : [],
    );
  }
}

class MetaRoleOption {
  final int id;
  final String name;
  final String code;
  final int administratorsCount;

  MetaRoleOption({
    required this.id,
    required this.name,
    required this.code,
    this.administratorsCount = 0,
  });

  factory MetaRoleOption.fromJson(Map<String, dynamic> json) {
    return MetaRoleOption(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? "",
      code: json['code']?.toString() ?? "",
      administratorsCount: json['administrators_count'] is int
          ? json['administrators_count']
          : int.tryParse(json['administrators_count']?.toString() ?? '0') ?? 0,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MetaRoleOption &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class MetaStateOption {
  final int id;
  final String stateName;

  MetaStateOption({required this.id, required this.stateName});

  factory MetaStateOption.fromJson(Map<String, dynamic> json) {
    return MetaStateOption(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      stateName: json['state_name']?.toString() ?? "",
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MetaStateOption &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class MetaCityOption {
  final int id;
  final String cityName;

  MetaCityOption({required this.id, required this.cityName});

  factory MetaCityOption.fromJson(Map<String, dynamic> json) {
    return MetaCityOption(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      cityName: json['city_name']?.toString() ?? json['name']?.toString() ?? "",
    );
  }
}

class MetaModuleOption {
  final int id;
  final String name;
  final bool hasView;
  final bool hasAdd;
  final bool hasEdit;
  final bool hasDelete;
  final bool hasStatus;
  final bool hasAssign;
  final bool hasCarStatus;

  MetaModuleOption({
    required this.id,
    required this.name,
    this.hasView = true,
    this.hasAdd = false,
    this.hasEdit = false,
    this.hasDelete = false,
    this.hasStatus = false,
    this.hasAssign = false,
    this.hasCarStatus = false,
  });

  static bool _parseBool(dynamic val, {required bool defaultValue}) {
    if (val == null) return defaultValue;
    if (val == 1 || val == '1' || val == true || val == 'true') return true;
    if (val == 0 || val == '0' || val == false || val == 'false') return false;
    return defaultValue;
  }

  factory MetaModuleOption.fromJson(Map<String, dynamic> json) {
    final rawName = json['name']?.toString() ?? "";
    final norm = rawName
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    // Web CRM Capability Matrix:
    // 1. Contact -> View, Delete ONLY (Add, Edit, Status, Availability, Assign are '-')
    // 2. Insurance -> View, Delete ONLY (Add, Edit, Status, Availability, Assign are '-')
    // 3. Users -> Add, Edit, Delete, Status ONLY (View, Availability, Assign are '-')
    // 4. Owner Listed Cars -> View, Edit, Delete, Status, Availability, Assign (Add is '-')
    // 5. Cars -> View, Add, Edit, Delete, Status, Availability, Assign (All 7 active)
    // 6. Default standard modules (Blogs, Loans, Enquiries, Admin, Testimonials, etc.):
    //    View, Add, Edit, Delete, Status (Availability and Assign are '-')

    bool defView = true;
    bool defAdd = true;
    bool defEdit = true;
    bool defDelete = true;
    bool defStatus = true;
    bool defAssign = false;
    bool defAvailability = false;

    if (norm == 'contact' || norm.startsWith('contact')) {
      defView = true;
      defAdd = false;
      defEdit = false;
      defDelete = true;
      defStatus = false;
      defAssign = false;
      defAvailability = false;
    } else if (norm == 'insurance' || norm.startsWith('insurance')) {
      defView = true;
      defAdd = false;
      defEdit = false;
      defDelete = true;
      defStatus = false;
      defAssign = false;
      defAvailability = false;
    } else if (norm == 'user' || norm == 'users') {
      defView = false;
      defAdd = true;
      defEdit = true;
      defDelete = true;
      defStatus = true;
      defAssign = false;
      defAvailability = false;
    } else if (norm == 'owner listed cars' ||
        norm == 'owner listed car' ||
        norm.contains('owner listed')) {
      defView = true;
      defAdd = false;
      defEdit = true;
      defDelete = true;
      defStatus = true;
      defAssign = true;
      defAvailability = true;
    } else if (norm == 'cars' || norm == 'car' || norm == 'car inventory') {
      defView = true;
      defAdd = true;
      defEdit = true;
      defDelete = true;
      defStatus = true;
      defAssign = true;
      defAvailability = true;
    }

    // Enforce Web CRM rules strictly
    final bool finalView = (norm == 'user' || norm == 'users')
        ? false
        : _parseBool(json['has_view'], defaultValue: defView);

    final bool finalAdd = (norm == 'contact' ||
            norm.startsWith('contact') ||
            norm == 'insurance' ||
            norm.startsWith('insurance') ||
            norm.contains('owner listed'))
        ? false
        : _parseBool(json['has_add'], defaultValue: defAdd);

    final bool finalEdit = (norm == 'contact' ||
            norm.startsWith('contact') ||
            norm == 'insurance' ||
            norm.startsWith('insurance'))
        ? false
        : _parseBool(json['has_edit'], defaultValue: defEdit);

    final bool finalDelete =
        _parseBool(json['has_delete'], defaultValue: defDelete);

    final bool finalStatus = (norm == 'contact' ||
            norm.startsWith('contact') ||
            norm == 'insurance' ||
            norm.startsWith('insurance'))
        ? false
        : _parseBool(json['has_status'], defaultValue: defStatus);

    // Availability and Assign ONLY exist on car modules in Web CRM
    final bool isCarModule = norm == 'cars' ||
        norm == 'car' ||
        norm == 'car inventory' ||
        norm.contains('owner listed');

    final assignRaw = json['has_assigned_to'] ?? json['has_assign'];
    final bool finalAssign = isCarModule
        ? _parseBool(assignRaw, defaultValue: defAssign)
        : false;

    final availRaw = json['has_car_status'] ?? json['has_availability'];
    final bool finalAvailability = isCarModule
        ? _parseBool(availRaw, defaultValue: defAvailability)
        : false;

    return MetaModuleOption(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: rawName,
      hasView: finalView,
      hasAdd: finalAdd,
      hasEdit: finalEdit,
      hasDelete: finalDelete,
      hasStatus: finalStatus,
      hasAssign: finalAssign,
      hasCarStatus: finalAvailability,
    );
  }

  /// Filters and orders modules to the exact 10 modules present in Web CRM Modular Access table
  static List<MetaModuleOption> filterToWebCrmModules(List<MetaModuleOption> rawList) {
    final List<MetaModuleOption> result = [];

    final specs = [
      {
        'name': 'Administrator',
        'matcher': (String n) => n == 'administrator' || n == 'admin'
      },
      {
        'name': 'Blogs',
        'matcher': (String n) => n == 'blogs' || n == 'blog'
      },
      {
        'name': 'Car Loans',
        'matcher': (String n) =>
            n == 'car loans' || n == 'car loan' || n.contains('car loan')
      },
      {
        'name': 'Cars',
        'matcher': (String n) =>
            (n == 'cars' || n == 'car' || n == 'car inventory') &&
            !n.contains('owner') &&
            !n.contains('loan')
      },
      {
        'name': 'Contact',
        'matcher': (String n) =>
            n == 'contact' || n == 'contacts' || n.contains('contact')
      },
      {
        'name': 'Insurance',
        'matcher': (String n) =>
            n == 'insurance' || n == 'insurances' || n.contains('insurance')
      },
      {
        'name': 'Loan Against Property Enquiries',
        'matcher': (String n) =>
            n.contains('property') || n.contains('lap')
      },
      {
        'name': 'Owner Listed Cars',
        'matcher': (String n) =>
            n.contains('owner listed') ||
            (n.contains('owner') && n.contains('car'))
      },
      {
        'name': 'Testimonials',
        'matcher': (String n) =>
            n.contains('testimonial') || n.contains('review')
      },
      {
        'name': 'Users',
        'matcher': (String n) =>
            n == 'users' || n == 'user' || n == 'customers' || n == 'customer'
      },
    ];

    for (int i = 0; i < specs.length; i++) {
      final spec = specs[i];
      final targetName = spec['name'] as String;
      final matcher = spec['matcher'] as bool Function(String);

      MetaModuleOption? found;
      for (final m in rawList) {
        final norm = m.name
            .toLowerCase()
            .replaceAll(RegExp(r'[^a-z0-9]'), ' ')
            .replaceAll(RegExp(r'\s+'), ' ')
            .trim();
        if (matcher(norm)) {
          found = m;
          break;
        }
      }

      if (found != null) {
        result.add(MetaModuleOption(
          id: found.id,
          name: targetName,
          hasView: found.hasView,
          hasAdd: found.hasAdd,
          hasEdit: found.hasEdit,
          hasDelete: found.hasDelete,
          hasStatus: found.hasStatus,
          hasAssign: found.hasAssign,
          hasCarStatus: found.hasCarStatus,
        ));
      } else {
        result.add(MetaModuleOption.fromJson({
          'id': i + 1,
          'name': targetName,
        }));
      }
    }

    return result;
  }
}

class MetaBankOption {
  final int id;
  final String name;

  MetaBankOption({required this.id, required this.name});

  factory MetaBankOption.fromJson(Map<String, dynamic> json) {
    return MetaBankOption(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? "",
    );
  }
}

class MetaCategoryOption {
  final int id;
  final String name;
  final String code;

  MetaCategoryOption(
      {required this.id, required this.name, required this.code});

  factory MetaCategoryOption.fromJson(Map<String, dynamic> json) {
    return MetaCategoryOption(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? "",
      code: json['code']?.toString() ?? "",
    );
  }
}
