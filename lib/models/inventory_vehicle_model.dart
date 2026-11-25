class InventoryVehicle {
  final String id;
  final String makeModel;
  final String subtitle;
  final String image;
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

  /// Factory constructor for parsing future REST API responses
  factory InventoryVehicle.fromJson(Map<String, dynamic> json) {
    return InventoryVehicle(
      id: json['id']?.toString() ?? json['car_uid']?.toString() ?? '',
      makeModel: json['make_model']?.toString() ?? json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? json['variant']?.toString() ?? '',
      image: json['image']?.toString() ?? 'assets/images/car.webp',
      condition: json['condition']?.toString() ?? 'Used',
      year: json['year']?.toString() ?? '',
      availability: json['availability']?.toString() ?? 'Available',
      company: json['company']?.toString() ?? 'Find My Car',
      agent: json['agent']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      status: json['status']?.toString() ?? 'Published',
      visibility: json['visibility']?.toString() ?? 'Public',
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
