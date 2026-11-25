import 'package:flutter/material.dart';
import '../models/inventory_vehicle_model.dart';
// Note: Uncomment when connecting future REST API:
// import '../core/constants/api_config.dart';
// import '../core/network/dio_client.dart';

/// ViewModel managing Inventory pagination and data state.
/// Decouples pagination logic from UI, allowing seamless future REST API integration.
class InventoryViewModel extends ChangeNotifier {
  // Uncomment when connecting future REST API:
  // final DioClient _dioClient = DioClient();

  // -------------------------------------------------------------
  // Existing local/static data store (KISS/YAGNI compliant)
  // -------------------------------------------------------------
  final List<InventoryVehicle> _vehicles = [
    InventoryVehicle(
      id: "#CARUID0978",
      makeModel: "TOYOTA KIRLOSKAR MOTOR PVT LTD | FORTUNER",
      subtitle: "TOYOTA KIRLOSKAR MOTOR PVT LTD FORTUNER",
      image: "assets/images/car1.webp",
      condition: "Used",
      year: "2013",
      availability: "Available",
      company: "Find My Car",
      agent: "Auto Care Mohammad Sajid",
      phone: "9897323603",
      location: "Dehradun, Uttaranchal",
      date: "17 Nov 2026",
      status: "Inactive",
      visibility: "Public",
    ),
    InventoryVehicle(
      id: "#CARUID0977",
      makeModel: "HYUNDAI | XCENT",
      subtitle: "2015 HYUNDAI MOTOR XCENT CRDI S",
      image: "assets/images/car.webp",
      condition: "Used",
      year: "2015",
      availability: "Available",
      company: "Owner",
      agent: "VAAHAN BAZA – NITIN KHATRI",
      phone: "9314651357",
      location: "Bikaner, Rajasthan",
      date: "16 Nov 2026",
      status: "Published",
      visibility: "Public",
    ),
    InventoryVehicle(
      id: "#CARUID0976",
      makeModel: "MARUTI SUZUKI | BREZZA",
      subtitle: "2020 MARUTI SUZUKI VITARA BREZZA ZXI",
      image: "assets/images/car1.webp",
      condition: "Used",
      year: "2020",
      availability: "Available",
      company: "Find My Car",
      agent: "MANOJ NEGI",
      phone: "9876543210",
      location: "Dehradun, Uttarakhand",
      date: "14 Nov 2026",
      status: "Published",
      visibility: "Public",
    ),
    InventoryVehicle(
      id: "#CARUID0975",
      makeModel: "MAHINDRA | THAR ROXX",
      subtitle: "2024 MAHINDRA THAR ROXX AX7L 4WD",
      image: "assets/images/car.webp",
      condition: "New",
      year: "2024",
      availability: "Available",
      company: "Dealership",
      agent: "KARAN",
      phone: "9811234567",
      location: "Haridwar, Uttarakhand",
      date: "12 Nov 2026",
      status: "Published",
      visibility: "Public",
    ),
  ];

  List<InventoryVehicle> get vehicles => List.unmodifiable(_vehicles);

  /// Paginated fetch method called by Infinite Scroll Pagination.
  /// Decouples data source from UI.
  /// When REST API is ready, simply uncomment the network call below.
  Future<List<InventoryVehicle>> fetchVehiclesPage({
    required int pageKey,
    required int pageSize,
    String activeTab = "All Cars",
    String searchQuery = "",
  }) async {
    // -------------------------------------------------------------------------
    // FUTURE REST API PAGINATION IMPLEMENTATION:
    // -------------------------------------------------------------------------
    // try {
    //   final response = await _dioClient.get(
    //     ApiConfig.cars,
    //     queryParameters: {
    //       'page': pageKey,
    //       'per_page': pageSize,
    //       if (activeTab != "All Cars") 'condition': activeTab.replaceAll(" Cars", ""),
    //       if (searchQuery.isNotEmpty) 'search': searchQuery,
    //     },
    //   );
    //   if (response.statusCode == 200 && response.data != null) {
    //     final items = (response.data['data'] as List? ?? [])
    //         .map((json) => InventoryVehicle.fromJson(json as Map<String, dynamic>))
    //         .toList();
    //     return items;
    //   }
    //   return [];
    // } catch (e) {
    //   rethrow;
    // }
    // -------------------------------------------------------------------------

    // LOCAL/STATIC PAGINATION (Current State, zero API/dummy data):
    await Future.delayed(const Duration(milliseconds: 100)); // Natural smooth async transition

    final filtered = _vehicles.where((v) {
      if (activeTab == "New Cars" && v.condition.toLowerCase() != "new") {
        return false;
      }
      if (activeTab == "Used Cars" && v.condition.toLowerCase() != "used") {
        return false;
      }

      if (searchQuery.isNotEmpty) {
        final q = searchQuery.toLowerCase();
        final match = v.id.toLowerCase().contains(q) ||
            v.makeModel.toLowerCase().contains(q) ||
            v.subtitle.toLowerCase().contains(q) ||
            v.phone.contains(q) ||
            v.location.toLowerCase().contains(q) ||
            v.agent.toLowerCase().contains(q) ||
            v.company.toLowerCase().contains(q);
        if (!match) return false;
      }

      return true;
    }).toList();

    final startIndex = (pageKey - 1) * pageSize;
    if (startIndex >= filtered.length) {
      return [];
    }

    final endIndex = (startIndex + pageSize) > filtered.length
        ? filtered.length
        : (startIndex + pageSize);

    return filtered.sublist(startIndex, endIndex);
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
