import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/constants/api_config.dart';
import '../core/network/dio_client.dart';
import '../models/contact_enquiry_model.dart';
import '../models/crm_lead_model.dart';
import '../models/insurance_lead_model.dart';

class LeadsViewModel extends ChangeNotifier {
  final DioClient _dioClient = DioClient();

  bool _isLoading = false;
  String? _errorMessage;
  List<CrmLeadModel> _leads = [];
  String _activeFilter = "All";
  int _summaryTotalLeads = 0;
  int _summaryNewLeads = 0;
  int _contactTotal = 0;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get activeFilter => _activeFilter;
  List<CrmLeadModel> get leads => List.unmodifiable(_leads);
  int get summaryTotalLeads =>
      _summaryTotalLeads > 0 ? _summaryTotalLeads : _leads.length;
  int get summaryNewLeads => _summaryNewLeads;
  int get contactTotal => _contactTotal;

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
      final allLeads = <CrmLeadModel>[];
      int currentPage = 1;
      int lastPage = 1;

      do {
        final response = await _dioClient.get(
          ApiConfig.crmLeads,
          queryParameters: {
            'page': currentPage,
            'per_page': 100,
          },
        );

        if (response.statusCode == 200 && response.data != null) {
          final body = response.data;
          if (body is Map) {
            final summary = body['summary'];
            if (summary is Map && currentPage == 1) {
              _summaryTotalLeads =
                  int.tryParse(summary['total_leads']?.toString() ?? '0') ?? 0;
              _summaryNewLeads =
                  int.tryParse(summary['new_leads']?.toString() ?? '0') ?? 0;
            }
            final pagination = body['pagination'];
            if (pagination is Map) {
              lastPage =
                  int.tryParse(pagination['last_page']?.toString() ?? '1') ?? 1;
            }
          }

          final rawList = body is Map
              ? (body['data'] ?? body['leads'] ?? const [])
              : (body is List ? body : const []);
          if (rawList is List) {
            for (final item in rawList) {
              if (item is Map) {
                allLeads.add(
                    CrmLeadModel.fromJson(Map<String, dynamic>.from(item)));
              }
            }
          }
        }
        currentPage++;
      } while (currentPage <= lastPage);

      _leads = allLeads;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<InsuranceLead>> fetchInsuranceLeadsPage({
    required int pageKey,
    required int pageSize,
    String searchQuery = "",
  }) async {
    final response = await _dioClient.get(
      ApiConfig.insuranceLeads,
      queryParameters: {
        'page': pageKey,
        'per_page': pageSize,
        if (searchQuery.trim().isNotEmpty) 'search': searchQuery.trim(),
      },
    );

    if (response.statusCode == 200 && response.data != null) {
      final body = response.data;
      final rawList = body is Map
          ? (body['data'] ?? body['leads'] ?? const [])
          : (body is List ? body : const []);

      if (rawList is List) {
        final parsed = rawList
            .whereType<Map>()
            .map((e) => InsuranceLead.fromJson(Map<String, dynamic>.from(e)))
            .toList();

        if (searchQuery.trim().isNotEmpty) {
          final q = searchQuery.trim().toLowerCase();
          return parsed.where((lead) {
            return lead.id.toLowerCase().contains(q) ||
                lead.ownerName.toLowerCase().contains(q) ||
                lead.regNumber.toLowerCase().contains(q) ||
                lead.phone.toLowerCase().contains(q) ||
                lead.email.toLowerCase().contains(q) ||
                lead.city.toLowerCase().contains(q) ||
                lead.status.toLowerCase().contains(q);
          }).toList();
        }
        return parsed;
      }
    }
    return [];
  }

  Future<List<ContactEnquiry>> fetchContactEnquiriesPage({
    required int pageKey,
    required int pageSize,
    String searchQuery = "",
  }) async {
    final response = await _dioClient.get(
      ApiConfig.contactLeads,
      queryParameters: {
        'page': pageKey,
        'per_page': pageSize,
        if (searchQuery.trim().isNotEmpty) 'search': searchQuery.trim(),
      },
    );

    if (response.statusCode == 200 && response.data != null) {
      final body = response.data;
      if (body is Map) {
        final pagination = body['pagination'];
        final summary = body['summary'];
        if (pagination is Map && pagination['total'] != null) {
          _contactTotal =
              int.tryParse(pagination['total'].toString()) ?? _contactTotal;
        } else if (summary is Map &&
            (summary['total_leads'] ?? summary['total']) != null) {
          _contactTotal = int.tryParse(
                  (summary['total_leads'] ?? summary['total']).toString()) ??
              _contactTotal;
        }
      }

      final rawList = body is Map
          ? (body['data'] ?? body['enquiries'] ?? body['leads'] ?? const [])
          : (body is List ? body : const []);

      if (rawList is List) {
        final parsed = rawList
            .whereType<Map>()
            .map((e) => ContactEnquiry.fromJson(Map<String, dynamic>.from(e)))
            .toList();

        if (searchQuery.trim().isNotEmpty) {
          final q = searchQuery.trim().toLowerCase();
          return parsed.where((item) {
            return item.name.toLowerCase().contains(q) ||
                item.phone.toLowerCase().contains(q) ||
                item.email.toLowerCase().contains(q) ||
                item.city.toLowerCase().contains(q) ||
                item.message.toLowerCase().contains(q);
          }).toList();
        }
        return parsed;
      }
    }
    return [];
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
