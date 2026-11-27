import 'package:flutter/material.dart';
import '../core/constants/api_config.dart';
import '../core/network/dio_client.dart';
import '../models/inventory_vehicle_model.dart';

/// ViewModel managing Inventory KPI stats, pagination, and data state.
class InventoryViewModel extends ChangeNotifier {
  final DioClient _dioClient = DioClient();

  CarsStatsModel _stats = const CarsStatsModel();
  bool _isStatsLoading = false;
  String? _statsError;

  final List<InventoryVehicle> _vehicles = [];
  final List<OwnerListedCar> _ownerListedCars = [];
  int _ownerListedTotal = 0;

  CarsStatsModel get stats => _stats;
  bool get isStatsLoading => _isStatsLoading;
  String? get statsError => _statsError;
  List<InventoryVehicle> get vehicles => List.unmodifiable(_vehicles);
  List<OwnerListedCar> get ownerListedCars =>
      List.unmodifiable(_ownerListedCars);
  int get ownerListedTotal => _ownerListedTotal;

  /// Fetch KPI stats from GET /cars/stats
  Future<void> fetchStats() async {
    _isStatsLoading = true;
    _statsError = null;
    notifyListeners();

    try {
      final response = await _dioClient.get(ApiConfig.carsStats);
      if (response.statusCode == 200 && response.data != null) {
        _stats = CarsStatsModel.fromJson(response.data);
      } else {
        _statsError = "Failed to load stats (${response.statusCode})";
      }
    } catch (e) {
      _statsError = e.toString().replaceFirst("Exception: ", "");
    } finally {
      _isStatsLoading = false;
      notifyListeners();
    }
  }

  /// Paginated fetch from GET /cars or GET /cars/my-inventory
  Future<List<InventoryVehicle>> fetchVehiclesPage({
    required int pageKey,
    required int pageSize,
    String activeTab = "All Cars",
    String searchQuery = "",
    String endpoint = ApiConfig.cars,
  }) async {
    final response = await _dioClient.get(
      endpoint,
      queryParameters: {
        'page': pageKey,
        'per_page': pageSize,
        if (activeTab != "All Cars")
          'condition': activeTab.replaceAll(" Cars", ""),
        if (searchQuery.trim().isNotEmpty) 'search': searchQuery.trim(),
      },
    );

    if (response.statusCode == 200 && response.data != null) {
      final rawList = _extractList(response.data);

      final parsed = rawList
          .whereType<Map>()
          .map((json) => InventoryVehicle.fromJson(
              Map<String, dynamic>.from(json)))
          .toList();

      final items = parsed.where((v) {
        if (activeTab == "New Cars") {
          return v.condition.toLowerCase() == "new";
        }
        if (activeTab == "Used Cars") {
          return v.condition.toLowerCase() == "used";
        }
        return true;
      }).toList();

      if (pageKey == 1) {
        _vehicles.clear();
      }
      _vehicles.addAll(items);
      notifyListeners();
      return items;
    }

    throw Exception("Failed to load cars (${response.statusCode})");
  }

  /// Paginated fetch from GET /cars/owner-listed
  Future<List<OwnerListedCar>> fetchOwnerListedCarsPage({
    required int pageKey,
    required int pageSize,
    String searchQuery = "",
  }) async {
    final response = await _dioClient.get(
      ApiConfig.carsOwnerListed,
      queryParameters: {
        'page': pageKey,
        'per_page': pageSize,
        if (searchQuery.trim().isNotEmpty) 'search': searchQuery.trim(),
      },
    );

    if (response.statusCode == 200 && response.data != null) {
      final body = response.data;
      final rawList = _extractList(body);

      final items = rawList
          .whereType<Map>()
          .map((json) =>
              OwnerListedCar.fromJson(Map<String, dynamic>.from(json)))
          .toList();

      if (pageKey == 1) {
        _ownerListedCars.clear();
      }
      _ownerListedCars.addAll(items);

      int? total;
      if (body is Map) {
        final rawTotal = body['total'] ??
            (body['pagination'] is Map ? body['pagination']['total'] : null) ??
            (body['meta'] is Map ? body['meta']['total'] : null) ??
            (body['summary'] is Map ? body['summary']['total_cars'] : null) ??
            (body['data'] is Map ? body['data']['total'] : null);
        if (rawTotal != null) {
          total = int.tryParse(rawTotal.toString());
        }
      }
      _ownerListedTotal = total ?? _ownerListedCars.length;
      notifyListeners();
      return items;
    }

    throw Exception("Failed to load owner listed cars (${response.statusCode})");
  }

  List<dynamic> _extractList(dynamic body) {
    if (body is List) return body;
    if (body is Map) {
      final inner = body['data'];
      if (inner is List) return inner;
      if (inner is Map && inner['data'] is List) {
        return inner['data'] as List;
      }
      if (body['cars'] is List) return body['cars'] as List;
    }
    return [];
  }

  /// Add a newly created vehicle to the inventory store
  void addVehicle(InventoryVehicle vehicle) {
    _vehicles.insert(0, vehicle);
    notifyListeners();
  }

  /// Delete a vehicle from the inventory store
  void deleteVehicle(String id) {
    _vehicles.removeWhere((v) => v.id == id);
    notifyListeners();
  }

  /// Delete an owner-listed car from the local list
  void deleteOwnerListedCar(String id) {
    _ownerListedCars.removeWhere((v) => v.id == id);
    if (_ownerListedTotal > 0) _ownerListedTotal--;
    notifyListeners();
  }

  /// Toggle selection state
  void toggleVehicleSelection(InventoryVehicle vehicle, bool isSelected) {
    vehicle.isSelected = isSelected;
    notifyListeners();
  }

  /// Clear all selections
  void clearSelection() {
    for (final v in _vehicles) {
      v.isSelected = false;
    }
    notifyListeners();
  }

  /// Count of selected vehicles
  int get selectedCount => _vehicles.where((v) => v.isSelected).length;
}
