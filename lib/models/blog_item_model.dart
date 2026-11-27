import '../core/constants/api_config.dart';

class BlogItem {
  final String id;
  String title;
  String author;
  String date;
  bool isActive;
  String? imagePath;
  String? description;

  BlogItem({
    required this.id,
    required this.title,
    required this.author,
    required this.date,
    required this.isActive,
    this.imagePath,
    this.description,
  });

  factory BlogItem.fromJson(Map<String, dynamic> json) {
    final authorRaw = json['author'];
    String author = '';
    if (authorRaw is Map) {
      author = (authorRaw['full_name'] ?? authorRaw['name'] ?? '').toString();
    } else if (authorRaw != null) {
      author = authorRaw.toString();
    }
    if (author.trim().isEmpty || author.trim().toLowerCase() == 'null') {
      author = _pick(json, ['author_name', 'created_by', 'user_name'],
          fallback: 'Admin');
    }

    return BlogItem(
      id: (json['id'] ?? json['blog_id'] ?? '').toString(),
      title: _pick(json, ['title', 'heading', 'name'], fallback: 'Untitled'),
      author: author,
      date: _formatDate(
          (json['created_at'] ?? json['published_at'] ?? json['date'] ?? '')
              .toString()),
      isActive: _resolveActive(json['status'] ?? json['is_active']),
      imagePath: _normalizeImage(json['image_url'] ??
          json['cover_image'] ??
          json['thumb_image'] ??
          json['thumbnail'] ??
          json['image'] ??
          json['banner']),
      description: _pickNullable(
          json, ['description', 'short_description', 'content', 'body']),
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

  static String? _pickNullable(Map<String, dynamic> json, List<String> keys) {
    for (final k in keys) {
      final s = json[k]?.toString().trim() ?? '';
      if (s.isNotEmpty && s.toLowerCase() != 'null') return s;
    }
    return null;
  }

  static String? _normalizeImage(dynamic raw) {
    var path = raw?.toString().trim() ?? '';
    if (path.isEmpty || path.toLowerCase() == 'null') return null;
    if (path.startsWith('http://') ||
        path.startsWith('https://') ||
        path.startsWith('assets/')) {
      return path;
    }
    if (path.startsWith('/')) path = path.substring(1);
    return '${ApiConfig.siteUrl}/$path';
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
