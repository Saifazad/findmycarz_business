class RegisteredUser {
  final String id;
  String name;
  String email;
  String phone;
  String city;
  String registrationDate;
  String status;

  RegisteredUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.city,
    required this.registrationDate,
    this.status = "Active",
  });

  factory RegisteredUser.fromJson(Map<String, dynamic> json) {
    final cityRaw = json['city'] is Map
        ? (json['city']['name'] ?? json['city']['city_name'])
        : (json['city'] ?? json['city_name'] ?? json['location']);

    final firstName = _pick(json, ['full_name', 'name', 'username'], fallback: '');
    final lastName = _clean(json['l_name'], fallback: '');
    final combinedName = [
      firstName,
      if (lastName.isNotEmpty &&
          lastName.toLowerCase() != firstName.toLowerCase())
        lastName,
    ].where((e) => e.isNotEmpty).join(' ');

    return RegisteredUser(
      id: (json['user_id'] ?? json['uid'] ?? json['id'] ?? '').toString(),
      name: combinedName.isNotEmpty ? combinedName : 'User',
      email: _pick(json, ['email'], fallback: '--'),
      phone: _pick(json, ['phone', 'phone_number', 'mobile'], fallback: '--'),
      city: _clean(cityRaw, fallback: '--'),
      registrationDate: _formatDate(
        (json['created_at'] ??
                json['registration_date'] ??
                json['joined_at'] ??
                '')
            .toString(),
      ),
      status: _resolveStatus(json['status'] ?? json['is_active']),
    );
  }

  static String _pick(
    Map<String, dynamic> json,
    List<String> keys, {
    required String fallback,
  }) {
    for (final k in keys) {
      final v = _clean(json[k], fallback: '');
      if (v.isNotEmpty) return v;
    }
    return fallback;
  }

  static String _clean(dynamic val, {required String fallback}) {
    final s = val?.toString().trim() ?? '';
    if (s.isEmpty || s.toLowerCase() == 'null') return fallback;
    return s;
  }

  static String _resolveStatus(dynamic raw) {
    if (raw == null) return 'Active';
    if (raw is bool) return raw ? 'Active' : 'Inactive';
    final s = raw.toString().trim().toLowerCase();
    if (s == '0' || s == 'false' || s == 'inactive' || s == 'blocked') {
      return 'Inactive';
    }
    if (s == '1' || s == 'true' || s == 'active') {
      return 'Active';
    }
    return raw.toString();
  }

  static String _formatDate(String raw) {
    if (raw.trim().isEmpty || raw.trim().toLowerCase() == 'null') return '--';
    final dt = DateTime.tryParse(raw.trim());
    if (dt == null) return raw;
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final local = dt.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    return '$day ${months[local.month - 1]}, ${local.year}';
  }
}
