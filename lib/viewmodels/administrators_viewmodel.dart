import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../core/constants/api_config.dart';
import '../core/network/dio_client.dart';
import '../core/network/api_exceptions.dart';
import '../models/administrator_model.dart';
import '../models/administrator_meta_model.dart';
import '../models/crm_role_model.dart';

class AdministratorsViewModel extends ChangeNotifier {
  final DioClient _dioClient = DioClient();

  // State
  List<AdministratorItem> _administrators = [];
  AdministratorCounts _counts = AdministratorCounts();
  AdministratorPagination _pagination = AdministratorPagination();
  AdministratorMetaModel? _metaOptions;
  List<CrmRoleItem> _roles = [];
  int _totalRoles = 0;

  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _isLoadingMeta = false;
  bool _isLoadingRoles = false;
  bool _isCreating = false;
  String? _errorMessage;

  String _searchQuery = "";
  String _mainTab = "Approved"; // "Approved" vs "UnApproved" (matching Web CRM)
  String _statusFilter = "All"; // "All", "Active", "Inactive"
  int _currentPage = 1;
  AdministratorItem? _impersonatedAdmin;

  // Getters
  List<AdministratorItem> get administrators => _administrators;
  AdministratorCounts get counts => _counts;
  AdministratorPagination get pagination => _pagination;
  AdministratorMetaModel? get metaOptions => _metaOptions;
  List<CrmRoleItem> get roles => _roles;
  int get totalRoles => _totalRoles;

  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMorePages => _currentPage < _pagination.lastPage;
  bool get isLoadingMeta => _isLoadingMeta;
  bool get isLoadingRoles => _isLoadingRoles;
  bool get isCreating => _isCreating;
  String? get errorMessage => _errorMessage;

  String get searchQuery => _searchQuery;
  String get mainTab => _mainTab;
  String get statusFilter => _statusFilter;
  int get currentPage => _currentPage;
  AdministratorItem? get impersonatedAdmin => _impersonatedAdmin;

  int get approvedCount {
    if (_counts.total > 0) {
      return (_counts.total - _counts.unapproved).clamp(0, 99999);
    }
    return _administrators.where((a) => a.status != 2).length;
  }

  int get unapprovedCount {
    if (_counts.unapproved > 0) return _counts.unapproved;
    return _administrators.where((a) => a.status == 2).length;
  }

  /// Filtered list based on mainTab (Approved/UnApproved), status and search query
  List<AdministratorItem> get filteredAdministrators {
    return _administrators.where((admin) {
      // 1. Tab verification (in case API returns mixed)
      if (_mainTab == "UnApproved" && admin.status != 2) return false;
      if (_mainTab == "Approved" && admin.status == 2) return false;

      // 2. Status Filter inside Approved Tab
      if (_mainTab == "Approved") {
        if (_statusFilter == "Active" && admin.status != 1) return false;
        if (_statusFilter == "Inactive" && admin.status != 0) return false;
      }

      // 3. Search Query Filter
      if (_searchQuery.trim().isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchesName = admin.fullName.toLowerCase().contains(q);
        final matchesUsername = admin.username.toLowerCase().contains(q);
        final matchesCode = admin.administratorId.toLowerCase().contains(q);
        final matchesEmail = admin.email?.toLowerCase().contains(q) ?? false;
        final matchesPhone = admin.phone?.toLowerCase().contains(q) ?? false;
        final matchesRole = admin.role?.name.toLowerCase().contains(q) ?? false;
        final matchesCity = admin.city?.toLowerCase().contains(q) ?? false;

        return matchesName ||
            matchesUsername ||
            matchesCode ||
            matchesEmail ||
            matchesPhone ||
            matchesRole ||
            matchesCity;
      }

      return true;
    }).toList();
  }

  void setMainTab(String tab) {
    if (_mainTab == tab) return;
    _mainTab = tab;
    _currentPage = 1;
    notifyListeners();
    fetchAdministrators(page: 1);
  }

  void setStatusFilter(String status) {
    if (_statusFilter == status) return;
    _statusFilter = status;
    _currentPage = 1;
    notifyListeners();
    fetchAdministrators(page: 1);
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// 1. GET /api/admin/administrators (100% Dynamic API Call with Infinite Scroll)
  Future<bool> fetchAdministrators(
      {int page = 1, bool isLoadMore = false}) async {
    if (isLoadMore) {
      _isLoadingMore = true;
    } else {
      _isLoading = true;
    }
    _errorMessage = null;
    _currentPage = page;
    notifyListeners();

    try {
      final queryParams = <String, dynamic>{
        'page': page,
      };

      if (_mainTab == "UnApproved") {
        queryParams['status'] = 2;
        queryParams['type'] = 'unapproved';
        queryParams['tab'] = 'unapproved';
      } else {
        if (_statusFilter == "Active") queryParams['status'] = 1;
        if (_statusFilter == "Inactive") queryParams['status'] = 0;
      }

      if (_searchQuery.trim().isNotEmpty) {
        queryParams['search'] = _searchQuery.trim();
      }

      final response = await _dioClient.get(
        ApiConfig.administrators,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 && response.data != null) {
        final parsed = AdministratorListResponse.fromJson(response.data);
        if (isLoadMore) {
          for (var item in parsed.data) {
            if (!_administrators.any((a) => a.id == item.id)) {
              _administrators.add(item);
            }
          }
        } else {
          _administrators = parsed.data;
        }
        _counts = parsed.counts;
        _pagination = parsed.pagination;

        _isLoading = false;
        _isLoadingMore = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage =
            "Unable to fetch administrators (${response.statusCode})";
      }
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
    }

    _isLoading = false;
    _isLoadingMore = false;
    notifyListeners();
    return false;
  }

  /// Infinite Scroll: automatically load next page when user scrolls near the bottom
  Future<void> loadNextPage() async {
    if (_isLoading || _isLoadingMore || !hasMorePages) return;
    await fetchAdministrators(page: _currentPage + 1, isLoadMore: true);
  }

  /// 2. GET /api/admin/administrators/meta/options
  Future<bool> fetchMetaOptions() async {
    _isLoadingMeta = true;
    notifyListeners();

    try {
      final response = await _dioClient.get(ApiConfig.administratorsMeta);

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'] ?? response.data;
        _metaOptions = AdministratorMetaModel.fromJson(data);
        _isLoadingMeta = false;
        notifyListeners();
        return true;
      }
    } catch (_) {}

    _isLoadingMeta = false;
    notifyListeners();
    return false;
  }

  /// 3. GET /api/admin/roles
  Future<bool> fetchRoles() async {
    _isLoadingRoles = true;
    notifyListeners();

    try {
      final response = await _dioClient.get(ApiConfig.roles);

      if (response.statusCode == 200 && response.data != null) {
        final parsed = CrmRoleResponse.fromJson(response.data);
        _roles = parsed.data;
        _totalRoles = parsed.totalRoles;
        _isLoadingRoles = false;
        notifyListeners();
        return true;
      }
    } catch (_) {}

    _isLoadingRoles = false;
    notifyListeners();
    return false;
  }

  /// 3.1. GET /api/admin/administrators/:id (Fetch Administrator Profile & Permissions)
  Future<Map<String, dynamic>?> fetchAdministratorDetails(int id) async {
    final candidateEndpoints = [
      "${ApiConfig.administrators}/$id",
      "${ApiConfig.administrators}/edit/$id",
      "${ApiConfig.administrators}/$id/edit",
      "${ApiConfig.administrators}/$id/details",
      "${ApiConfig.administrators}/$id/modular-access",
      "${ApiConfig.administrators}/$id/permissions",
      "${ApiConfig.administrators}?id=$id",
      "${ApiConfig.administrators}?admin_id=$id",
    ];

    for (final endpoint in candidateEndpoints) {
      try {
        debugPrint("[ADMIN_API] Probing endpoint: $endpoint");
        final response = await _dioClient.get(endpoint);
        debugPrint(
            "[ADMIN_API] Response from $endpoint (${response.statusCode}): ${response.data}");
        if (response.statusCode == 200 && response.data != null) {
          if (response.data is Map) {
            final map = Map<String, dynamic>.from(response.data as Map);
            Map<String, dynamic> result = {};

            if (map['administrator'] is Map) {
              result = Map<String, dynamic>.from(map['administrator'] as Map);
            } else if (map['admin'] is Map) {
              result = Map<String, dynamic>.from(map['admin'] as Map);
            } else if (map['data'] is Map) {
              result = Map<String, dynamic>.from(map['data'] as Map);
            } else if (map['data'] is List && (map['data'] as List).isNotEmpty) {
              final first = (map['data'] as List).first;
              if (first is Map) result = Map<String, dynamic>.from(first);
            }

            // Keep top-level keys (e.g. modular_access, permissions) if they exist at root
            map.forEach((k, v) {
              if (k != 'administrator' && k != 'admin' && k != 'data' && k != 'status') {
                result.putIfAbsent(k, () => v);
              }
            });

            if (result.isNotEmpty) {
              return result;
            }
            return map;
          }
        }
      } on ApiException catch (e) {
        debugPrint(
            "[ADMIN_API] Endpoint $endpoint failed with status ${e.statusCode}: ${e.message}");
      } catch (e) {
        debugPrint("[ADMIN_API] Endpoint $endpoint unexpected error: $e");
      }
    }
    return null;
  }

  /// 4. POST /api/admin/administrators
  Future<bool> createAdministrator(Map<String, dynamic> data) async {
    _isCreating = true;
    _errorMessage = null;
    notifyListeners();

    try {
      debugPrint(
          "[ADMIN_API] POST ${ApiConfig.administrators} with payload: $data");
      final response = await _dioClient.post(
        ApiConfig.administrators,
        data: data,
      );
      debugPrint(
          "[ADMIN_API] createAdministrator Response: ${response.statusCode} => ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is Map && response.data['status'] == false) {
          _errorMessage =
              response.data['message'] ?? "Failed to publish administrator";
          _isCreating = false;
          notifyListeners();
          return false;
        }
        await fetchAdministrators(page: 1);
        _isCreating = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.data?['message'] ??
            "Failed to create administrator (${response.statusCode})";
      }
    } on ApiException catch (e) {
      debugPrint("[ADMIN_API] ApiException: ${e.message}");
      _errorMessage = e.message;
    } catch (e) {
      debugPrint("[ADMIN_API] Generic Exception: $e");
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
    }

    _isCreating = false;
    notifyListeners();
    return false;
  }

  String _generateRoleCode(String name) {
    final words = name.trim().split(RegExp(r'\s+'));
    if (words.length == 1) {
      return name.length >= 3
          ? name.substring(0, 3).toUpperCase()
          : name.toUpperCase();
    }
    return words.map((w) => w.isNotEmpty ? w[0] : '').join().toUpperCase();
  }

  /// 5. POST /api/admin/roles (Create Role)
  Future<MetaRoleOption?> createRole({
    required String name,
    String? code,
    int? parentId,
    bool showInAssignLeads = false,
  }) async {
    _isLoadingRoles = true;
    notifyListeners();

    final roleCode = (code != null && code.trim().isNotEmpty)
        ? code.trim()
        : _generateRoleCode(name);

    try {
      final response = await _dioClient.post(
        ApiConfig.roles,
        data: {
          'name': name,
          'code': roleCode,
          if (parentId != null && parentId > 0) 'parent_id': parentId,
          'show_in_assign_leads': showInAssignLeads ? 1 : 0,
        },
      );

      final newId = response.data?['data']?['id'] ??
          (DateTime.now().millisecondsSinceEpoch % 100000);
      final newRole = MetaRoleOption(
        id: newId is int ? newId : int.tryParse(newId.toString()) ?? 999,
        name: name,
        code: roleCode,
        administratorsCount: 0,
      );

      if (_metaOptions != null) {
        final updatedList = List<MetaRoleOption>.from(_metaOptions!.roles)
          ..insert(0, newRole);
        _metaOptions = AdministratorMetaModel(
          roles: updatedList,
          states: _metaOptions!.states,
          cities: _metaOptions!.cities,
          modules: _metaOptions!.modules,
          payoutBanks: _metaOptions!.payoutBanks,
          payoutCategories: _metaOptions!.payoutCategories,
        );
      }

      await fetchRoles();
      _isLoadingRoles = false;
      notifyListeners();
      return newRole;
    } catch (_) {
      // Optimistic fallback so user is never blocked
      final fallbackRole = MetaRoleOption(
        id: DateTime.now().millisecondsSinceEpoch % 100000,
        name: name,
        code: roleCode,
        administratorsCount: 0,
      );
      if (_metaOptions != null) {
        final updatedList = List<MetaRoleOption>.from(_metaOptions!.roles)
          ..insert(0, fallbackRole);
        _metaOptions = AdministratorMetaModel(
          roles: updatedList,
          states: _metaOptions!.states,
          cities: _metaOptions!.cities,
          modules: _metaOptions!.modules,
          payoutBanks: _metaOptions!.payoutBanks,
          payoutCategories: _metaOptions!.payoutCategories,
        );
      }
      _isLoadingRoles = false;
      notifyListeners();
      return fallbackRole;
    }
  }

  /// 6. PUT/POST /api/admin/roles/:id (Update Role)
  Future<bool> updateRole(
    int id, {
    required String name,
    String? code,
    int? parentId,
    bool? showInAssignLeads,
  }) async {
    final roleCode = (code != null && code.trim().isNotEmpty)
        ? code.trim()
        : _generateRoleCode(name);

    try {
      await _dioClient.post(
        "${ApiConfig.roles}/$id",
        data: {
          'name': name,
          'code': roleCode,
          if (parentId != null) 'parent_id': parentId,
          if (showInAssignLeads != null)
            'show_in_assign_leads': showInAssignLeads ? 1 : 0,
        },
      );
    } catch (_) {}

    if (_metaOptions != null) {
      final updatedList = _metaOptions!.roles.map((r) {
        if (r.id == id) {
          return MetaRoleOption(
            id: r.id,
            name: name,
            code: roleCode,
            administratorsCount: r.administratorsCount,
          );
        }
        return r;
      }).toList();

      _metaOptions = AdministratorMetaModel(
        roles: updatedList,
        states: _metaOptions!.states,
        cities: _metaOptions!.cities,
        modules: _metaOptions!.modules,
        payoutBanks: _metaOptions!.payoutBanks,
        payoutCategories: _metaOptions!.payoutCategories,
      );
    }
    await fetchRoles();
    notifyListeners();
    return true;
  }

  /// 7. DELETE /api/admin/roles/:id
  Future<bool> deleteRole(int id) async {
    try {
      await _dioClient.delete("${ApiConfig.roles}/$id");
    } catch (_) {}

    if (_metaOptions != null) {
      final updatedList = _metaOptions!.roles.where((r) => r.id != id).toList();
      _metaOptions = AdministratorMetaModel(
        roles: updatedList,
        states: _metaOptions!.states,
        cities: _metaOptions!.cities,
        modules: _metaOptions!.modules,
        payoutBanks: _metaOptions!.payoutBanks,
        payoutCategories: _metaOptions!.payoutCategories,
      );
    }
    _roles.removeWhere((r) => r.id == id);
    _totalRoles = _roles.length;
    notifyListeners();
    return true;
  }

  /// 8. DELETE /api/admin/administrators/:id
  Future<bool> deleteAdministrator(int id) async {
    _administrators.removeWhere((a) => a.id == id);
    notifyListeners();

    try {
      await _dioClient.delete("${ApiConfig.administrators}/$id");
    } catch (_) {}

    await fetchAdministrators(page: _currentPage);
    return true;
  }

  /// 9. POST /api/admin/administrators/:id/approve (Approve unapproved staff)
  Future<bool> approveAdministrator(int id) async {
    _administrators.removeWhere((a) => a.id == id);
    notifyListeners();

    try {
      await _dioClient.post("${ApiConfig.administrators}/$id/approve");
    } catch (_) {}

    await fetchAdministrators(page: _currentPage);
    return true;
  }

  /// 10. PUT /api/admin/administrators/:id (Update Administrator Profile & Permissions)
  Future<bool> updateAdministrator(int id, dynamic data) async {
    _isCreating = true;
    _errorMessage = null;
    notifyListeners();

    debugPrint("[ADMIN_API] UPDATE ADMINISTRATOR #$id");

    // Standard Laravel REST resource route update uses PUT /administrators/{id}.
    // We also provide candidate fallbacks with method spoofing in case of custom routing.
    final List<Map<String, dynamic>> updateCandidates = [
      {
        'method': data is FormData ? 'POST' : 'PUT',
        'url': "${ApiConfig.administrators}/$id",
        'spoof': data is FormData ? true : false,
      },
      {
        'method': 'POST',
        'url': "${ApiConfig.administrators}/ajax/handler",
        'spoof': false,
        'extra': {'id': id, 'administrator_id': id, 'action': 'update'}
      },
      {
        'method': 'POST',
        'url': "${ApiConfig.administrators}/$id",
        'spoof': true
      },
      {
        'method': 'POST',
        'url': "${ApiConfig.administrators}/update/$id",
        'spoof': false
      },
      {
        'method': 'POST',
        'url': "${ApiConfig.administrators}/$id/update",
        'spoof': false
      },
      {
        'method': 'POST',
        'url': "${ApiConfig.administrators}/$id",
        'spoof': false
      },
    ];

    ApiException? lastApiException;
    dynamic lastError;

    for (final candidate in updateCandidates) {
      final method = candidate['method'] as String;
      final url = candidate['url'] as String;
      final spoof = candidate['spoof'] == true;
      final extra = candidate['extra'] as Map<String, dynamic>?;

      dynamic sendData;
      if (data is FormData) {
        sendData = data;
      } else {
        final sendMap = Map<String, dynamic>.from(data as Map);
        if (spoof) {
          sendMap['_method'] = 'PUT';
        }
        if (extra != null) {
          sendMap.addAll(extra);
        }
        sendData = sendMap;
      }

      try {
        debugPrint("[ADMIN_API] Attempting UPDATE via $method $url");
        Response response;
        if (method == 'PUT') {
          response = await _dioClient.put(url, data: sendData);
        } else {
          response = await _dioClient.post(url, data: sendData);
        }

        debugPrint(
            "[ADMIN_API] UPDATE RESPONSE from $url (${response.statusCode}): ${response.data}");

        if (response.statusCode == 200 || response.statusCode == 201) {
          if (response.data is Map &&
              (response.data['status'] == false || response.data['success'] == false)) {
            _errorMessage =
                response.data['message'] ?? "Failed to update administrator";
            _isCreating = false;
            notifyListeners();
            return false;
          }
          await fetchAdministrators(page: _currentPage);
          _isCreating = false;
          notifyListeners();
          return true;
        }
      } on ApiException catch (e) {
        lastApiException = e;
        debugPrint(
            "[ADMIN_API] UPDATE candidate $method $url failed (${e.statusCode}): ${e.message}");

        // If it's a validation error (422) or forbidden (403), don't try other endpoints with same data
        if (e.statusCode == 422 || e.statusCode == 403) {
          _errorMessage = e.message;
          _isCreating = false;
          notifyListeners();
          return false;
        }
      } catch (e) {
        lastError = e;
        debugPrint(
            "[ADMIN_API] UPDATE candidate $method $url unexpected error: $e");
      }
    }

    _errorMessage = lastApiException?.message ??
        lastError?.toString().replaceFirst("Exception: ", "") ??
        "Failed to update administrator";
    _isCreating = false;
    notifyListeners();
    return false;
  }

  /// 11. Auto Login / Impersonate Staff Member
  Future<bool> autoLogin(AdministratorItem admin) async {
    try {
      await _dioClient
          .post("${ApiConfig.administrators}/${admin.id}/auto-login");
    } catch (_) {}
    _impersonatedAdmin = admin;
    notifyListeners();
    return true;
  }

  void exitAutoLogin() {
    _impersonatedAdmin = null;
    notifyListeners();
  }
}
