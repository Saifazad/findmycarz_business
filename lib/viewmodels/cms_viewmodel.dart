import 'package:flutter/material.dart';
import '../core/constants/api_config.dart';
import '../core/network/dio_client.dart';
import '../models/blog_item_model.dart';
import '../models/car_loan_content_model.dart';
import '../models/flash_news_item_model.dart';
import '../models/testimonial_item_model.dart';

class CmsViewModel extends ChangeNotifier {
  final DioClient _dioClient = DioClient();

  bool _isTestimonialsLoading = false;
  String? _testimonialsError;
  List<TestimonialItem> _testimonials = [];

  bool _isFlashNewsLoading = false;
  String? _flashNewsError;
  List<FlashNewsItem> _flashNews = [];

  bool get isTestimonialsLoading => _isTestimonialsLoading;
  String? get testimonialsError => _testimonialsError;
  List<TestimonialItem> get testimonials => List.unmodifiable(_testimonials);

  bool get isFlashNewsLoading => _isFlashNewsLoading;
  String? get flashNewsError => _flashNewsError;
  List<FlashNewsItem> get flashNews => List.unmodifiable(_flashNews);

  /// Paginated fetch from GET /cms/blogs
  Future<List<BlogItem>> fetchBlogsPage({
    required int pageKey,
    required int pageSize,
    String searchQuery = "",
  }) async {
    final response = await _dioClient.get(
      ApiConfig.cmsBlogs,
      queryParameters: {
        'page': pageKey,
        'per_page': pageSize,
        if (searchQuery.trim().isNotEmpty) 'search': searchQuery.trim(),
      },
    );

    if (response.statusCode == 200 && response.data != null) {
      final body = response.data;
      dynamic rawList;
      if (body is List) {
        rawList = body;
      } else if (body is Map) {
        final blogsNode = body['blogs'];
        final dataNode = body['data'];
        if (blogsNode is Map && blogsNode['data'] is List) {
          rawList = blogsNode['data'];
        } else if (dataNode is Map && dataNode['data'] is List) {
          rawList = dataNode['data'];
        } else if (dataNode is List) {
          rawList = dataNode;
        } else if (blogsNode is List) {
          rawList = blogsNode;
        }
      }

      if (rawList is List) {
        final parsed = rawList
            .whereType<Map>()
            .map((e) => BlogItem.fromJson(Map<String, dynamic>.from(e)))
            .toList();

        if (searchQuery.trim().isNotEmpty) {
          final q = searchQuery.trim().toLowerCase();
          return parsed.where((b) {
            return b.title.toLowerCase().contains(q) ||
                b.author.toLowerCase().contains(q) ||
                b.date.toLowerCase().contains(q);
          }).toList();
        }
        return parsed;
      }
    }
    return [];
  }

  /// Fetch testimonials from GET /cms/testimonials
  Future<void> fetchTestimonials() async {
    _isTestimonialsLoading = true;
    _testimonialsError = null;
    notifyListeners();

    try {
      final allItems = <TestimonialItem>[];
      int currentPage = 1;
      int lastPage = 1;

      do {
        final response = await _dioClient.get(
          ApiConfig.cmsTestimonials,
          queryParameters: {
            'page': currentPage,
            'per_page': 100,
          },
        );

        if (response.statusCode == 200 && response.data != null) {
          final body = response.data;
          dynamic rawList;
          if (body is List) {
            rawList = body;
          } else if (body is Map) {
            final tNode = body['testimonials'];
            final dNode = body['data'];
            if (tNode is Map && tNode['data'] is List) {
              rawList = tNode['data'];
              lastPage =
                  int.tryParse(tNode['last_page']?.toString() ?? '1') ?? 1;
            } else if (dNode is Map && dNode['data'] is List) {
              rawList = dNode['data'];
              lastPage =
                  int.tryParse(dNode['last_page']?.toString() ?? '1') ?? 1;
            } else if (dNode is List) {
              rawList = dNode;
            } else if (tNode is List) {
              rawList = tNode;
            }
            final pagination = body['pagination'];
            if (pagination is Map) {
              lastPage =
                  int.tryParse(pagination['last_page']?.toString() ?? '1') ?? 1;
            }
          }

          if (rawList is List) {
            for (final item in rawList) {
              if (item is Map) {
                allItems.add(TestimonialItem.fromJson(
                    Map<String, dynamic>.from(item)));
              }
            }
          }
        }
        currentPage++;
      } while (currentPage <= lastPage);

      _testimonials = allItems;
    } catch (e) {
      _testimonialsError = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isTestimonialsLoading = false;
      notifyListeners();
    }
  }

  void addTestimonialLocal(TestimonialItem item) {
    _testimonials.insert(0, item);
    notifyListeners();
  }

  void removeTestimonialLocal(String id) {
    _testimonials.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  /// Fetch flash news from GET /cms/flash-news
  Future<void> fetchFlashNews() async {
    _isFlashNewsLoading = true;
    _flashNewsError = null;
    notifyListeners();

    try {
      final allItems = <FlashNewsItem>[];
      int currentPage = 1;
      int lastPage = 1;

      do {
        final response = await _dioClient.get(
          ApiConfig.cmsFlashNews,
          queryParameters: {
            'page': currentPage,
            'per_page': 100,
          },
        );

        if (response.statusCode == 200 && response.data != null) {
          final body = response.data;
          dynamic rawList;
          if (body is List) {
            rawList = body;
          } else if (body is Map) {
            final fNode =
                body['flash_news'] ?? body['flashNews'] ?? body['announcements'];
            final dNode = body['data'];
            if (fNode is Map && fNode['data'] is List) {
              rawList = fNode['data'];
              lastPage =
                  int.tryParse(fNode['last_page']?.toString() ?? '1') ?? 1;
            } else if (dNode is Map && dNode['data'] is List) {
              rawList = dNode['data'];
              lastPage =
                  int.tryParse(dNode['last_page']?.toString() ?? '1') ?? 1;
            } else if (dNode is List) {
              rawList = dNode;
            } else if (fNode is List) {
              rawList = fNode;
            }
            final pagination = body['pagination'];
            if (pagination is Map) {
              lastPage =
                  int.tryParse(pagination['last_page']?.toString() ?? '1') ?? 1;
            }
          }

          if (rawList is List) {
            for (final item in rawList) {
              if (item is Map) {
                allItems.add(
                    FlashNewsItem.fromJson(Map<String, dynamic>.from(item)));
              }
            }
          }
        }
        currentPage++;
      } while (currentPage <= lastPage);

      _flashNews = allItems;
    } catch (e) {
      _flashNewsError = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isFlashNewsLoading = false;
      notifyListeners();
    }
  }

  void addFlashNewsLocal(FlashNewsItem item) {
    _flashNews.add(item);
    notifyListeners();
  }

  void removeFlashNewsLocal(String id) {
    _flashNews.removeWhere((f) => f.id == id);
    notifyListeners();
  }

  /// Paginated fetch from GET /cms/car-loans
  Future<List<CarLoanContentItem>> fetchCarLoansPage({
    required int pageKey,
    required int pageSize,
    String searchQuery = "",
  }) async {
    final response = await _dioClient.get(
      ApiConfig.cmsCarLoans,
      queryParameters: {
        'page': pageKey,
        'per_page': pageSize,
        if (searchQuery.trim().isNotEmpty) 'search': searchQuery.trim(),
      },
    );

    if (response.statusCode == 200 && response.data != null) {
      final body = response.data;
      dynamic rawList;
      if (body is List) {
        rawList = body;
      } else if (body is Map) {
        final lNode =
            body['car_loans'] ?? body['carLoans'] ?? body['loans'];
        final dNode = body['data'];
        if (lNode is Map && lNode['data'] is List) {
          rawList = lNode['data'];
        } else if (dNode is Map && dNode['data'] is List) {
          rawList = dNode['data'];
        } else if (dNode is List) {
          rawList = dNode;
        } else if (lNode is List) {
          rawList = lNode;
        }
      }

      if (rawList is List) {
        final parsed = rawList
            .whereType<Map>()
            .map((e) =>
                CarLoanContentItem.fromJson(Map<String, dynamic>.from(e)))
            .toList();

        if (searchQuery.trim().isNotEmpty) {
          final q = searchQuery.trim().toLowerCase();
          return parsed.where((item) {
            return item.title.toLowerCase().contains(q) ||
                item.category.toLowerCase().contains(q) ||
                item.description.toLowerCase().contains(q);
          }).toList();
        }
        return parsed;
      }
    }
    return [];
  }
}
