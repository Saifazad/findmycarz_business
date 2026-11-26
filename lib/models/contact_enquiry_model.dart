class ContactEnquiry {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String city;
  final String date;
  final String message;
  bool isSelected;

  ContactEnquiry({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.city,
    required this.date,
    required this.message,
    this.isSelected = false,
  });

  factory ContactEnquiry.fromJson(Map<String, dynamic> json) {
    return ContactEnquiry(
      id: (json['id'] ?? json['enquiry_id'] ?? json['lead_id'] ?? '').toString(),
      name: _pick(json, ['name', 'full_name', 'customer_name', 'owner_name'],
          fallback: 'Customer'),
      phone: _pick(json, ['phone', 'phone_number', 'mobile'], fallback: '--'),
      email: _pick(json, ['email'], fallback: '--'),
      city: _pick(json, ['city', 'location'], fallback: '--'),
      date: _formatDate(
          (json['created_at'] ?? json['date'] ?? '').toString()),
      message: _pick(
        json,
        ['message', 'description', 'enquiry', 'subject', 'remarks'],
        fallback: '--',
      ),
    );
  }

  static String _pick(
    Map<String, dynamic> json,
    List<String> keys, {
    required String fallback,
  }) {
    for (final k in keys) {
      final s = json[k]?.toString().trim() ?? '';
      if (s.isNotEmpty && s.toLowerCase() != 'null') return s;
    }
    return fallback;
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
    final hh = local.hour.toString().padLeft(2, '0');
    final mm = local.minute.toString().padLeft(2, '0');
    return '$day ${months[local.month - 1]}, ${local.year} $hh:$mm';
  }
}
