import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/constants/api_config.dart';
import '../core/network/dio_client.dart';
import '../models/crm_lead_model.dart';

class LeadsViewModel extends ChangeNotifier {
  final DioClient _dioClient = DioClient();

  bool _isLoading = false;
  String? _errorMessage;
  List<CrmLeadModel> _leads = [];
  String _activeFilter = "All";

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get activeFilter => _activeFilter;

  List<CrmLeadModel> get filteredLeads {
    if (_activeFilter == "All") return _leads;
    return _leads.where((l) {
      final f = _activeFilter.toLowerCase();
      final s = l.status.toLowerCase();
      final rs = l.rawStatus.toLowerCase();
      return s == f || rs == f || s.contains(f) || rs.contains(f);
    }).toList();
  }

  Future<void> fetchLeads() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // First try /dashboard which includes the comprehensive leads array
      final response = await _dioClient.get(ApiConfig.dashboard);
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'] ?? response.data;
        final list = data['leads'] ?? data['data'] ?? [];
        if (list is List && list.isNotEmpty) {
          _leads = list.map((e) => CrmLeadModel.fromJson(e as Map<String, dynamic>)).toList();
          _isLoading = false;
          notifyListeners();
          return;
        }
      }
    } catch (_) {}

    try {
      // Secondary fallback to /leads if separate endpoint
      final response = await _dioClient.get(ApiConfig.crmLeads);
      if (response.statusCode == 200 && response.data != null) {
        final list = response.data['data'] ?? response.data['leads'] ?? [];
        if (list is List) {
          _leads = list.map((e) => CrmLeadModel.fromJson(e as Map<String, dynamic>)).toList();
          _isLoading = false;
          notifyListeners();
          return;
        }
      }
    } catch (_) {}

    _isLoading = false;
    notifyListeners();
  }

  void setFilter(String filter) {
    _activeFilter = filter;
    notifyListeners();
  }

  Future<bool> updateLeadStatus(String leadId, String newStatus, String remarks) async {
    try {
      await _dioClient.post(
        ApiConfig.updateLeadStatus,
        data: {
          'lead_id': leadId,
          'status': newStatus,
          'remarks': remarks,
        },
      );
    } catch (_) {}

    final index = _leads.indexWhere((l) => l.id == leadId);
    if (index != -1) {
      _leads[index] = _leads[index].copyWith(status: newStatus, remarks: remarks);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('tel:$cleanPhone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> openWhatsApp(String phoneNumber, String customerName) async {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    final text = Uri.encodeComponent(
        "Hello $customerName, I'm contacting you from Find My Carz regarding your loan application.");
    final uri = Uri.parse("https://wa.me/$cleanPhone?text=$text");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
