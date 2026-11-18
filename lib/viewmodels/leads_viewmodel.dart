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
    return _leads.where((l) => l.status.toLowerCase() == _activeFilter.toLowerCase()).toList();
  }

  Future<void> fetchLeads() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _dioClient.get(ApiConfig.crmLeads);
      if (response.statusCode == 200 && response.data != null) {
        final list = response.data['data'] ?? response.data['leads'] ?? [];
        if (list is List) {
          _leads = list.map((e) => CrmLeadModel.fromJson(e)).toList();
        }
      }
    } catch (e) {
      // Demo leads if backend not live
      if (_leads.isEmpty) {
        _leads = [
          CrmLeadModel(
            id: "LD-1049",
            name: "Rahul Verma",
            phone: "+91 98765 43210",
            email: "rahul.v@example.com",
            city: "Mumbai",
            type: "Used Car Loan",
            carName: "Hyundai Creta SX 2021",
            amount: 750000,
            status: "In Bank Login",
            assignedTo: "Amit Sharma (Partner)",
            remarks: "Documents verified, sent to HDFC Bank",
            createdAt: "Today, 11:30 AM",
          ),
          CrmLeadModel(
            id: "LD-1048",
            name: "Suresh Patil",
            phone: "+91 91234 56789",
            city: "Pune",
            type: "BT & Top-Up Loan",
            carName: "Honda City V 2019",
            amount: 450000,
            status: "New",
            assignedTo: "Direct Website",
            remarks: "Requested callback regarding lower ROI",
            createdAt: "Yesterday",
          ),
          CrmLeadModel(
            id: "LD-1047",
            name: "Pooja Mehta",
            phone: "+91 99887 76655",
            city: "Thane",
            type: "New Car Loan",
            carName: "Tata Nexon EV",
            amount: 1200000,
            status: "Approved",
            assignedTo: "Sneha (Sales Exec)",
            remarks: "Sanction letter issued by ICICI Bank",
            createdAt: "15 Nov 2026",
          ),
        ];
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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
    final cleanPhone = phoneNumber.replaceAll(' ', '').replaceAll('-', '');
    final uri = Uri.parse('tel:$cleanPhone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> openWhatsApp(String phoneNumber, String customerName) async {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    final text = Uri.encodeComponent("Hello $customerName, I'm contacting you from Find My Carz regarding your loan inquiry.");
    final uri = Uri.parse("https://wa.me/$cleanPhone?text=$text");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

