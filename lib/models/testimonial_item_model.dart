import '../core/constants/api_config.dart';

class TestimonialItem {
  final String id;
  String name;
  int rating;
  bool isActive;
  String feedback;
  String? designation;
  String? photoPath;

  TestimonialItem({
    required this.id,
    required this.name,
    required this.rating,
    required this.isActive,
    this.feedback = "",
    this.designation,
    this.photoPath,
  });

  factory TestimonialItem.fromJson(Map<String, dynamic> json) {
    final rawRating = json['rating'] ?? json['stars'] ?? json['star'] ?? 5;
    final parsedRating =
        (rawRating is int ? rawRating : int.tryParse(rawRating.toString()) ?? 5)
            .clamp(1, 5);

    var resolvedName = _pick(
      json,
      [
        'name',
        'customer_name',
        'full_name',
        'user_name',
        'username',
        'client_name',
        'reviewer_name',
        'person_name',
        'author',
        'writer',
        'title',
        'heading',
        'customer',
      ],
      fallback: '',
    );
    if (resolvedName.isEmpty) {
      for (final parentKey in ['customer', 'user', 'client', 'author']) {
        final parent = json[parentKey];
        if (parent is Map) {
          resolvedName = _pick(
            Map<String, dynamic>.from(parent),
            ['full_name', 'name', 'customer_name', 'username'],
            fallback: '',
          );
          if (resolvedName.isNotEmpty) break;
        }
      }
    }

    return TestimonialItem(
      id: (json['id'] ?? json['testimonial_id'] ?? '').toString(),
      name: resolvedName.isNotEmpty ? resolvedName : 'Customer',
      rating: parsedRating,
      isActive: _resolveActive(json['status'] ?? json['is_active']),
      feedback: _pick(
        json,
        ['feedback', 'message', 'review', 'comment', 'description'],
        fallback: '',
      ),
      designation: _pickNullable(json, ['designation', 'role', 'company', 'city']),
      photoPath: _normalizePhoto(json['photo'] ??
          json['image_url'] ??
          json['image'] ??
          json['avatar'] ??
          json['profile_image']),
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

  static String? _normalizePhoto(dynamic raw) {
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
}
