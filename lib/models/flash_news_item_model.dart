class FlashNewsItem {
  final String id;
  String text;
  int order;
  String type;
  bool isActive;
  String linkTarget;
  String? url;

  FlashNewsItem({
    required this.id,
    required this.text,
    this.order = 0,
    this.type = "Text Only",
    this.isActive = true,
    this.linkTarget = "New Tab",
    this.url,
  });

  factory FlashNewsItem.fromJson(Map<String, dynamic> json) {
    final rawOrder = json['order'] ?? json['sort_order'] ?? json['priority'] ?? 0;
    final parsedOrder =
        rawOrder is int ? rawOrder : int.tryParse(rawOrder.toString()) ?? 0;
    final url = _pickNullable(json, ['url', 'link', 'redirect_url']);
    final rawType = _pick(json, ['type', 'display_type'], fallback: '');

    return FlashNewsItem(
      id: (json['id'] ?? json['flash_id'] ?? '').toString(),
      text: _pick(
        json,
        ['text', 'title', 'message', 'announcement', 'content', 'description'],
        fallback: '',
      ),
      order: parsedOrder,
      type: rawType.isNotEmpty
          ? rawType
          : (url != null ? 'With Link' : 'Text Only'),
      isActive: _resolveActive(json['status'] ?? json['is_active']),
      linkTarget: _pick(json, ['link_target', 'target'], fallback: 'New Tab'),
      url: url,
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
