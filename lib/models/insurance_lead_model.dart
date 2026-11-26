import 'package:flutter/material.dart';

class InsuranceLead {
  final String id;
  final String dbId;
  final String ownerName;
  final String regNumber;
  final String phone;
  final String email;
  final String city;
  final String previousClaim;
  final String currentInsurance;
  final String previousInsuranceCompany;
  final String description;
  final String date;
  final String status;
  final Color statusColor;
  bool isSelected;

  InsuranceLead({
    required this.id,
    this.dbId = '',
    required this.ownerName,
    required this.regNumber,
    required this.phone,
    required this.email,
    this.city = '--',
    this.previousClaim = '--',
    this.currentInsurance = '--',
    this.previousInsuranceCompany = '--',
    this.description = '--',
    required this.date,
    required this.status,
    required this.statusColor,
    this.isSelected = false,
  });

  factory InsuranceLead.fromJson(Map<String, dynamic> json) {
    final status = (json['status'] ?? 'Pending').toString().trim();
    final emailRaw = json['email']?.toString().trim() ?? '';
    final email =
        emailRaw.isEmpty || emailRaw.toLowerCase() == 'null' ? '--' : emailRaw;

    return InsuranceLead(
      id: (json['lead_id'] ?? json['id'] ?? '').toString(),
      dbId: (json['id'] ?? '').toString(),
      ownerName: (json['owner_name'] ?? 'Customer').toString(),
      regNumber: (json['reg_number'] ?? '--').toString(),
      phone: (json['phone'] ?? '').toString(),
      email: email,
      city: _cleanOrDash(json['city']),
      previousClaim: _cleanOrDash(json['previous_claim']),
      currentInsurance: _cleanOrDash(json['current_insurance']),
      previousInsuranceCompany:
          _cleanOrDash(json['previous_insurance_company']),
      description: _cleanOrDash(json['description']),
      date: _formatDate(json['created_at']?.toString() ?? ''),
      status: status.isEmpty ? 'Pending' : status,
      statusColor: _resolveStatusColor(status),
    );
  }

  static String _cleanOrDash(dynamic val) {
    final s = val?.toString().trim() ?? '';
    return s.isEmpty || s.toLowerCase() == 'null' ? '--' : s;
  }

  static String _formatDate(String raw) {
    if (raw.trim().isEmpty) return '--';
    final dt = DateTime.tryParse(raw.trim());
    if (dt == null) return raw;
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final local = dt.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    return '$day ${months[local.month - 1]}, ${local.year}';
  }

  static Color _resolveStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'follow up':
      case 'follow_up':
        return const Color(0xFFC2410C);
      case 'quoted':
        return const Color(0xFF0F766E);
      case 'approved':
      case 'completed':
      case 'issued':
        return const Color(0xFF059669);
      case 'cancelled':
      case 'rejected':
        return const Color(0xFFDC2626);
      case 'pending':
      default:
        return const Color(0xFFB45309);
    }
  }
}
