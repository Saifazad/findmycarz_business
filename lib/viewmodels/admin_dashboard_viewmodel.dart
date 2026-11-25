import 'package:flutter/material.dart';
import '../core/constants/api_config.dart';
import '../core/network/dio_client.dart';
import '../models/admin_dashboard_model.dart';

class AdminDashboardViewModel extends ChangeNotifier {
  final DioClient _dioClient = DioClient();

  bool _isLoading = false;
  String? _errorMessage;
  AdminDashboardModel _data = AdminDashboardModel();

  // Active Filters
  String? _selectedLeadStatus;
  String? _fromDate;
  String? _toDate;
  int? _selectedSmId;
  int? _selectedAgentId;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  AdminDashboardModel get data => _data;
  String? get selectedLeadStatus => _selectedLeadStatus;

  Future<void> fetchDashboardStats({
    String? leadStatus,
    String? fromDate,
    String? toDate,
    int? smId,
    int? agentId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    if (leadStatus != null) _selectedLeadStatus = leadStatus;
    if (fromDate != null) _fromDate = fromDate;
    if (toDate != null) _toDate = toDate;
    if (smId != null) _selectedSmId = smId;
    if (agentId != null) _selectedAgentId = agentId;
    notifyListeners();

    try {
      final queryParams = <String, dynamic>{};
      if (_selectedLeadStatus != null && _selectedLeadStatus!.isNotEmpty) {
        queryParams['lead_status'] = _selectedLeadStatus;
      }
      if (_fromDate != null) queryParams['from_date'] = _fromDate;
      if (_toDate != null) queryParams['to_date'] = _toDate;
      if (_selectedSmId != null) queryParams['sm_id'] = _selectedSmId;
      if (_selectedAgentId != null) queryParams['agent_id'] = _selectedAgentId;

      final response = await _dioClient.get(
        ApiConfig.dashboard,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      if (response.statusCode == 200 && response.data != null) {
        _data = AdminDashboardModel.fromJson(response.data);
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
      _data = AdminDashboardModel();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setLeadStatusFilter(String? status) {
    _selectedLeadStatus = status == "All" ? null : status;
    fetchDashboardStats();
  }
}
