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
          ? rawRoles.whereType<Map<String, dynamic>>().map((r) => MetaRoleOption.fromJson(r)).toList()
          : [],
      states: rawStates is List
          ? rawStates.whereType<Map<String, dynamic>>().map((s) => MetaStateOption.fromJson(s)).toList()
          : [],
      cities: rawCities is List
          ? rawCities.whereType<Map<String, dynamic>>().map((c) => MetaCityOption.fromJson(c)).toList()
          : [],
      modules: rawModules is List
          ? rawModules.whereType<Map<String, dynamic>>().map((m) => MetaModuleOption.fromJson(m)).toList()
          : [],
      payoutBanks: rawBanks is List
          ? rawBanks.whereType<Map<String, dynamic>>().map((b) => MetaBankOption.fromJson(b)).toList()
          : [],
      payoutCategories: rawCats is List
          ? rawCats.whereType<Map<String, dynamic>>().map((c) => MetaCategoryOption.fromJson(c)).toList()
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
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? "",
      code: json['code']?.toString() ?? "",
      administratorsCount: json['administrators_count'] is int
          ? json['administrators_count']
          : int.tryParse(json['administrators_count']?.toString() ?? '0') ?? 0,
    );
  }
}

class MetaStateOption {
  final int id;
  final String stateName;

  MetaStateOption({required this.id, required this.stateName});

  factory MetaStateOption.fromJson(Map<String, dynamic> json) {
    return MetaStateOption(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      stateName: json['state_name']?.toString() ?? "",
    );
  }
}

class MetaCityOption {
  final int id;
  final String cityName;

  MetaCityOption({required this.id, required this.cityName});

  factory MetaCityOption.fromJson(Map<String, dynamic> json) {
    return MetaCityOption(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
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

  MetaModuleOption({
    required this.id,
    required this.name,
    this.hasView = false,
    this.hasAdd = false,
    this.hasEdit = false,
    this.hasDelete = false,
  });

  factory MetaModuleOption.fromJson(Map<String, dynamic> json) {
    return MetaModuleOption(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? "",
      hasView: json['has_view'] == 1 || json['has_view'] == true,
      hasAdd: json['has_add'] == 1 || json['has_add'] == true,
      hasEdit: json['has_edit'] == 1 || json['has_edit'] == true,
      hasDelete: json['has_delete'] == 1 || json['has_delete'] == true,
    );
  }
}

class MetaBankOption {
  final int id;
  final String name;

  MetaBankOption({required this.id, required this.name});

  factory MetaBankOption.fromJson(Map<String, dynamic> json) {
    return MetaBankOption(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? "",
    );
  }
}

class MetaCategoryOption {
  final int id;
  final String name;
  final String code;

  MetaCategoryOption({required this.id, required this.name, required this.code});

  factory MetaCategoryOption.fromJson(Map<String, dynamic> json) {
    return MetaCategoryOption(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? "",
      code: json['code']?.toString() ?? "",
    );
  }
}
