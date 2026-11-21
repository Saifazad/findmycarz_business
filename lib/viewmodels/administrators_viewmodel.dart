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
  bool _isLoadingMeta = false;
  bool _isLoadingRoles = false;
  String? _errorMessage;

  String _searchQuery = "";
  String _statusFilter = "All"; // "All", "Active", "Inactive", "Unapproved"
  int _currentPage = 1;

  // Getters
  List<AdministratorItem> get administrators => _administrators;
  AdministratorCounts get counts => _counts;
  AdministratorPagination get pagination => _pagination;
  AdministratorMetaModel? get metaOptions => _metaOptions;
  List<CrmRoleItem> get roles => _roles;
  int get totalRoles => _totalRoles;

  bool get isLoading => _isLoading;
  bool get isLoadingMeta => _isLoadingMeta;
  bool get isLoadingRoles => _isLoadingRoles;
  String? get errorMessage => _errorMessage;

  String get searchQuery => _searchQuery;
  String get statusFilter => _statusFilter;
  int get currentPage => _currentPage;

  /// Filtered list based on status and search query
  List<AdministratorItem> get filteredAdministrators {
    return _administrators.where((admin) {
      // 1. Status Filter
      if (_statusFilter == "Active" && admin.status != 1) return false;
      if (_statusFilter == "Inactive" && admin.status != 0) return false;
      if (_statusFilter == "Unapproved" && admin.status != 2) return false;

      // 2. Search Query Filter
      if (_searchQuery.trim().isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchesName = admin.fullName.toLowerCase().contains(q);
        final matchesUsername = admin.username.toLowerCase().contains(q);
        final matchesCode = admin.administratorId.toLowerCase().contains(q);
        final matchesEmail = admin.email?.toLowerCase().contains(q) ?? false;
        final matchesPhone = admin.phone?.toLowerCase().contains(q) ?? false;
        final matchesRole = admin.role?.name.toLowerCase().contains(q) ?? false;
        final matchesCity = admin.city?.toLowerCase().contains(q) ?? false;

        return matchesName || matchesUsername || matchesCode || matchesEmail || matchesPhone || matchesRole || matchesCity;
      }

      return true;
    }).toList();
  }

  void setStatusFilter(String status) {
    _statusFilter = status;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// 1. GET /api/admin/administrators
  Future<bool> fetchAdministrators({int page = 1}) async {
    _isLoading = true;
    _errorMessage = null;
    _currentPage = page;
    notifyListeners();

    try {
      final response = await _dioClient.get(
        ApiConfig.administrators,
        queryParameters: {'page': page},
      );

      if (response.statusCode == 200 && response.data != null) {
        final parsed = AdministratorListResponse.fromJson(response.data);
        _administrators = parsed.data;
        _counts = parsed.counts;
        _pagination = parsed.pagination;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = "Unable to fetch administrators (${response.statusCode})";
      }
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
    }

    _isLoading = false;
    notifyListeners();
    return false;
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
}
