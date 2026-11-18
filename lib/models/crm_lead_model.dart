class CrmLeadModel {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String? city;
  final String type; // 'Used Car Loan', 'New Car Loan', 'BT & Top-Up', 'Refinance', 'Sell Car'
  final String? carName;
  final String? regNo;
  final double? amount;
  final String status; // 'New', 'In Bank Login', 'Approved', 'Disbursed', 'Rejected'
  final String? assignedTo;
  final String? remarks;
  final String createdAt;

  CrmLeadModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.city,
    required this.type,
    this.carName,
    this.regNo,
    this.amount,
    required this.status,
    this.assignedTo,
    this.remarks,
    required this.createdAt,
  });

  factory CrmLeadModel.fromJson(Map<String, dynamic> json) {
    return CrmLeadModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? json['customer_name'] ?? 'Customer',
      phone: json['phone'] ?? json['mobile'] ?? '',
      email: json['email'],
      city: json['city'] ?? json['state'],
      type: json['type'] ?? json['lead_type'] ?? 'Used Car Loan',
      carName: json['car_name'] ?? json['model_name'],
      regNo: json['reg_no'] ?? json['registration_number'],
      amount: double.tryParse(json['amount']?.toString() ?? json['loan_amount']?.toString() ?? '0'),
      status: json['status'] ?? 'New',
      assignedTo: json['assigned_to'] ?? json['partner_name'],
      remarks: json['remarks'] ?? json['note'],
      createdAt: json['created_at'] ?? 'Today',
    );
  }

  CrmLeadModel copyWith({
    String? status,
    String? remarks,
  }) {
    return CrmLeadModel(
      id: id,
      name: name,
      phone: phone,
      email: email,
      city: city,
      type: type,
      carName: carName,
      regNo: regNo,
      amount: amount,
      status: status ?? this.status,
      assignedTo: assignedTo,
      remarks: remarks ?? this.remarks,
      createdAt: createdAt,
    );
  }
}

