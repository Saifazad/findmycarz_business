class CarLoanContentItem {
  final String id;
  String title;
  String category;
  String publishedDate;
  bool isActive;
  String description;
  String visibility;

  CarLoanContentItem({
    required this.id,
    required this.title,
    required this.category,
    required this.publishedDate,
    required this.isActive,
    this.description = "",
    this.visibility = "public",
  });

  factory CarLoanContentItem.fromJson(Map<String, dynamic> json) {
    final catRaw = json['category'];
    String category = '';
    if (catRaw is Map) {
      category = (catRaw['name'] ?? catRaw['title'] ?? '').toString();
    } else if (catRaw != null) {
      category = catRaw.toString();
    }
    if (category.trim().isEmpty || category.trim().toLowerCase() == 'null') {
      category = _pick(
        json,
        ['category_name', 'loan_type_label', 'loan_type', 'type'],
        fallback: 'Car Loan',
      );
    }

    return CarLoanContentItem(
      id: (json['id'] ?? json['loan_id'] ?? '').toString(),
      title: _pick(
        json,
        ['title', 'name', 'heading', 'loan_title'],
        fallback: 'Car Loan',
      ),
      category: category,
      publishedDate: _formatDate(
        (json['publish_date'] ??
                json['published_at'] ??
                json['created_at'] ??
                json['date'] ??
                '')
            .toString(),
      ),
      isActive: _resolveActive(json['status'] ?? json['is_active']),
      description: _pick(
        json,
        ['description', 'short_description', 'content', 'body'],
        fallback: '',
      ),
      visibility: _pick(json, ['visibility'], fallback: 'public'),
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

  static bool _resolveActive(dynamic raw) {
    if (raw == null) return true;
    if (raw is bool) return raw;
    final s = raw.toString().trim().toLowerCase();
    if (s == '0' || s == 'false' || s == 'inactive' || s == 'draft') {
      return false;
    }
    return true;
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
