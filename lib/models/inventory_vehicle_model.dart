import '../core/constants/api_config.dart';

String _normalizeCarImageUrl(dynamic raw) {
  var path = raw?.toString().trim() ?? '';
  if (path.isEmpty || path.toLowerCase() == 'null') return '';
  if (path.startsWith('http://') ||
      path.startsWith('https://') ||
      path.startsWith('assets/')) {
    return path;
  }
  if (path.startsWith('/')) {
    path = path.substring(1);
  }
  return '${ApiConfig.siteUrl}/$path';
}

List<String> _resolveCarImages(Map<String, dynamic> json) {
  final result = <String>[];
  void addUrl(dynamic raw) {
    final url = _normalizeCarImageUrl(raw);
    if (url.isNotEmpty && !result.contains(url)) {
      result.add(url);
    }
  }

  for (final key in ['thumb_image', 'image_url', 'cover_image', 'thumbnail', 'image']) {
    addUrl(json[key]);
  }

  final gallery = json['images'] ?? json['gallery'] ?? json['galleries'];
  if (gallery is List) {
    for (final item in gallery) {
      if (item is String) {
        addUrl(item);
      } else if (item is Map) {
        addUrl(item['image_url'] ??
            item['image'] ??
            item['image_path'] ??
            item['url'] ??
            item['path'] ??
            item['image_name']);
      }
    }
  }
  return result;
}

String _resolveCarImageUrl(Map<String, dynamic> json) {
  final images = _resolveCarImages(json);
  return images.isNotEmpty ? images.first : '';
}

String _pickString(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final val = json[key];
    if (val != null && val is! Map && val is! List) {
      final s = val.toString().trim();
      if (s.isNotEmpty && s.toLowerCase() != 'null') return s;
    }
  }
  return '';
}

String _pickNestedString(
  Map<String, dynamic> json,
  List<String> parentKeys,
  List<String> childKeys,
) {
  for (final parentKey in parentKeys) {
    final parent = json[parentKey];
    if (parent is Map) {
      for (final childKey in childKeys) {
        final val = parent[childKey];
        if (val != null && val is! Map && val is! List) {
          final s = val.toString().trim();
          if (s.isNotEmpty && s.toLowerCase() != 'null') return s;
        }
      }
    }
  }
  return '';
}

String _resolveClientName(Map<String, dynamic> json) {
  final flat = _pickString(json, [
    'client_name',
    'client',
    'company_name',
    'company',
    'source',
    'listed_by',
  ]);
  if (flat.isNotEmpty) return flat;
  final nested = _pickNestedString(
    json,
    ['client', 'company'],
    ['client_name', 'company_name', 'name'],
  );
  if (nested.isNotEmpty) return nested;
  final type = _pickString(json, ['client_type', 'user_type', 'seller_type', 'role'])
      .toLowerCase();
  if (type == 'owner') return 'Owner';
  return 'Find My Car';
}

String _resolveAgentName(Map<String, dynamic> json) {
  final flat = _pickString(json, [
    'agent',
    'agent_name',
    'assigned_dealer_name',
    'administrator_name',
    'dealer_name',
  ]);
  if (flat.isNotEmpty) return flat;
  return _pickNestedString(
    json,
    ['agent', 'assigned_dealer', 'administrator', 'dealer'],
    ['agent_name', 'full_name', 'name', 'username'],
  );
}

String _resolveOwnerName(Map<String, dynamic> json) {
  final flat = _pickString(json, [
    'agent',
    'agent_name',
    'owner_name',
    'seller_name',
    'dealer_name',
    'user_name',
    'customer_name',
    'name',
  ]);
  if (flat.isNotEmpty) return flat;
  return _pickNestedString(
    json,
    ['owner', 'assigned_dealer', 'administrator', 'agent', 'user', 'dealer', 'seller'],
    ['owner_name', 'full_name', 'name', 'username'],
  );
}

String _resolveOwnerPhone(Map<String, dynamic> json) {
  final flat = _pickString(json, [
    'phone',
    'owner_phone',
    'contact_number',
    'mobile',
    'mobile_no',
    'phone_number',
    'whatsapp_number',
  ]);
  if (flat.isNotEmpty) return flat;
  return _pickNestedString(
    json,
    ['owner', 'assigned_dealer', 'administrator', 'agent', 'user', 'dealer', 'seller'],
    ['phone', 'mobile', 'contact_number', 'phone_number'],
  );
}

String _resolveLocation(Map<String, dynamic> json) {
  final flat = _pickString(json, ['location', 'city_name', 'rto_city', 'address']);
  if (flat.isNotEmpty) return flat;
  final city = _pickString(json, ['city']).isNotEmpty
      ? _pickString(json, ['city'])
      : _pickNestedString(json, ['owner', 'city', 'rto_city'], ['city', 'name', 'city_name']);
  final state = _pickString(json, ['state']).isNotEmpty
      ? _pickString(json, ['state'])
      : _pickNestedString(json, ['owner', 'state'], ['state', 'name', 'state_name']);
  return [city, state].where((e) => e.isNotEmpty).join(', ');
}

String _resolveStatus(Map<String, dynamic> json, {String activeLabel = 'Published'}) {
  final raw = json['status'] ?? json['is_active'];
  if (raw == null) return activeLabel;
  if (raw is bool) return raw ? activeLabel : 'Inactive';
  final s = raw.toString().trim().toLowerCase();
  if (s == '0' || s == 'false' || s == 'inactive' || s == 'draft') {
    return 'Inactive';
  }
  if (s == '1' || s == 'true' || s == 'active' || s == 'published') {
    return activeLabel;
  }
  return raw.toString();
}

String _resolveVisibility(Map<String, dynamic> json) {
  final raw = json['visibility'] ?? json['is_public'];
  if (raw == null) return 'Public';
  if (raw is bool) return raw ? 'Public' : 'Private';
  final s = raw.toString().trim().toLowerCase();
  if (s == '0' || s == 'false' || s == 'private') return 'Private';
  if (s == '1' || s == 'true' || s == 'public') return 'Public';
  return raw.toString();
}

class CarsStatsModel {
  final int totalCars;
  final int availableCars;
  final int soldCars;
  final int newCars;
  final int usedCars;

  const CarsStatsModel({
    this.totalCars = 0,
    this.availableCars = 0,
    this.soldCars = 0,
    this.newCars = 0,
    this.usedCars = 0,
  });

  factory CarsStatsModel.fromJson(dynamic json) {
    if (json == null || json is! Map) return const CarsStatsModel();
    final root = json['data'] is Map
        ? json['data'] as Map<String, dynamic>
        : (json['stats'] is Map
            ? json['stats'] as Map<String, dynamic>
            : Map<String, dynamic>.from(json));

    int parseInt(dynamic val) =>
        val is int ? val : int.tryParse(val?.toString() ?? '0') ?? 0;

    return CarsStatsModel(
      totalCars: parseInt(root['total_cars'] ?? root['total'] ?? root['all_cars']),
      availableCars:
          parseInt(root['available_cars'] ?? root['available'] ?? root['active_cars']),
      soldCars: parseInt(root['sold_cars'] ?? root['sold']),
      newCars: parseInt(root['new_cars'] ?? root['new']),
      usedCars: parseInt(root['used_cars'] ?? root['used']),
    );
  }
}

class InventoryVehicle {
  final String id;
  final String makeModel;
  final String subtitle;
  final String image;
  final List<String> images;
  final String condition; // "Used" or "New"
  final String year;
  final String availability; // "Available", "Sold", "Booked"
  final String company;
  final String agent;
  final String phone;
  final String location;
  final String date;
  final String status; // "Inactive", "Published"
  final String visibility; // "Public", "Private"
  bool isSelected;

  InventoryVehicle({
    required this.id,
    required this.makeModel,
    required this.subtitle,
    required this.image,
    this.images = const [],
    required this.condition,
    required this.year,
    required this.availability,
    required this.company,
    required this.agent,
    required this.phone,
    required this.location,
    required this.date,
    required this.status,
    required this.visibility,
    this.isSelected = false,
  });

  /// Factory constructor for parsing REST API responses
  factory InventoryVehicle.fromJson(Map<String, dynamic> json) {
    final brand = json['brand']?.toString() ??
        json['make']?.toString() ??
        json['manufacturer']?.toString() ??
        '';
    final model = json['model']?.toString() ?? '';
    final combinedMakeModel = [brand, model]
        .where((e) => e.trim().isNotEmpty)
        .join(' | ');

    final rawId = json['car_uid']?.toString() ??
        json['uid']?.toString() ??
        json['id']?.toString() ??
        '';
    final formattedId =
        rawId.isNotEmpty && !rawId.startsWith('#') ? '#$rawId' : rawId;

    final rawCondition = _pickString(
        json, ['condition', 'vehicle_type', 'car_type', 'type']);
    final formattedCondition = rawCondition.isEmpty
        ? 'Used'
        : rawCondition[0].toUpperCase() + rawCondition.substring(1).toLowerCase();

    final resolvedYear = _pickString(
        json, ['make_year', 'year', 'model_year', 'manufacturing_year']);

    return InventoryVehicle(
      id: formattedId,
      makeModel: json['make_model']?.toString() ??
          json['car_name']?.toString() ??
          json['title']?.toString() ??
          (combinedMakeModel.isNotEmpty ? combinedMakeModel : 'Vehicle'),
      subtitle: json['subtitle']?.toString() ??
          json['variant']?.toString() ??
          json['car_name']?.toString() ??
          '',
      image: _resolveCarImageUrl(json),
      images: _resolveCarImages(json),
      condition: formattedCondition,
      year: resolvedYear,
      availability: json['availability']?.toString() ??
          json['car_status']?.toString() ??
          'Available',
      company: _resolveClientName(json),
      agent: _resolveAgentName(json),
      phone: _resolveOwnerPhone(json),
      location: _resolveLocation(json),
      date: json['date']?.toString() ??
          json['created_at']?.toString() ??
          '',
      status: _resolveStatus(json, activeLabel: 'Published'),
      visibility: _resolveVisibility(json),
      isSelected: json['is_selected'] == true,
    );
  }

  /// Serialization for future API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'make_model': makeModel,
      'subtitle': subtitle,
      'image': image,
      'condition': condition,
      'year': year,
      'availability': availability,
      'company': company,
      'agent': agent,
      'phone': phone,
      'location': location,
      'date': date,
      'status': status,
      'visibility': visibility,
      'is_selected': isSelected,
    };
  }

  InventoryVehicle copyWith({
    String? id,
    String? makeModel,
    String? subtitle,
    String? image,
    List<String>? images,
    String? condition,
    String? year,
    String? availability,
    String? company,
    String? agent,
    String? phone,
    String? location,
    String? date,
    String? status,
    String? visibility,
    bool? isSelected,
  }) {
    return InventoryVehicle(
      id: id ?? this.id,
      makeModel: makeModel ?? this.makeModel,
      subtitle: subtitle ?? this.subtitle,
      image: image ?? this.image,
      images: images ?? this.images,
      condition: condition ?? this.condition,
      year: year ?? this.year,
      availability: availability ?? this.availability,
      company: company ?? this.company,
      agent: agent ?? this.agent,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      date: date ?? this.date,
      status: status ?? this.status,
      visibility: visibility ?? this.visibility,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

class OwnerListedCar {
  final String id;
  final String title;
  final String yearModel;
  final String image;
  final List<String> images;
  final String status; // "Active", "Inactive"
  final String ownerName;
  final String ownerPhone;
  final String price;
  final String kms;
  final String location;
  final String listedDate;

  OwnerListedCar({
    required this.id,
    required this.title,
    required this.yearModel,
    required this.image,
    this.images = const [],
    required this.status,
    required this.ownerName,
    required this.ownerPhone,
    required this.price,
    required this.kms,
    required this.location,
    required this.listedDate,
  });

  factory OwnerListedCar.fromJson(Map<String, dynamic> json) {
    final brand = json['brand']?.toString() ?? json['make']?.toString() ?? '';
    final model = json['model']?.toString() ?? '';
    final combinedTitle =
        [brand, model].where((e) => e.trim().isNotEmpty).join(' ');

    final rawYear = _pickString(
        json, ['year_model', 'make_year', 'model_year', 'year']);
    final formattedYear = rawYear.isNotEmpty && !rawYear.contains('Model')
        ? '$rawYear Model'
        : rawYear;

    final rawStatus = _resolveStatus(json, activeLabel: 'Active');

    final rawPrice = json['price'] ?? json['used_price'] ?? json['selling_price'];
    final formattedPrice = rawPrice != null && rawPrice.toString().isNotEmpty
        ? (rawPrice.toString().contains('₹') ? rawPrice.toString() : '₹$rawPrice')
        : '';

    final rawKms =
        json['driven_formatted'] ?? json['kms'] ?? json['km_driven'] ?? json['driven'] ?? json['mileage'];
    final formattedKms = rawKms != null && rawKms.toString().isNotEmpty
        ? (rawKms.toString().toLowerCase().contains('km')
            ? rawKms.toString()
            : '$rawKms kms')
        : '';

    return OwnerListedCar(
      id: json['id']?.toString() ?? json['car_uid']?.toString() ?? '',
      title: json['title']?.toString() ??
          json['car_name']?.toString() ??
          json['make_model']?.toString() ??
          (combinedTitle.isNotEmpty ? combinedTitle : 'Vehicle'),
      yearModel: formattedYear,
      image: _resolveCarImageUrl(json),
      images: _resolveCarImages(json),
      status: rawStatus,
      ownerName: _resolveOwnerName(json),
      ownerPhone: _resolveOwnerPhone(json),
      price: formattedPrice,
      kms: formattedKms,
      location: _resolveLocation(json),
      listedDate: json['listed_date']?.toString() ??
          json['created_at']?.toString() ??
          json['date']?.toString() ??
          '',
    );
  }
}
