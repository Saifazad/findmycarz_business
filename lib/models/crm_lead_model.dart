class CrmLeadModel {
  final String id;
  final String? leadCode;
  final String name;
  final String phone;
  final String? email;
  final String? panNumber;
  final String? city;
  final String type; // e.g. "Used Car Loan", "New Car Loan"
  final String rawLoanType; // e.g. "USED_CAR_LOAN"
  final String? carName;
  final String? regNo;
  final String? carBrand;
  final double? amount;
  final double? monthlyIncome;
  final double? disbursedAmount;
  final String? disbursedDate;
  final String status; // e.g. "In Bank Login", "Disbursed", "New"
  final String rawStatus; // e.g. "SENT_TO_BANK", "DISBURSED"
  final String? assignedTo;
  final String? sourcingManager;
  final String? remarks;
  final String createdAt;

  CrmLeadModel({
    required this.id,
    this.leadCode,
    required this.name,
    required this.phone,
    this.email,
    this.panNumber,
    this.city,
    required this.type,
    this.rawLoanType = '',
    this.carName,
    this.regNo,
    this.carBrand,
    this.amount,
    this.monthlyIncome,
    this.disbursedAmount,
    this.disbursedDate,
    required this.status,
    this.rawStatus = '',
    this.assignedTo,
    this.sourcingManager,
    this.remarks,
    required this.createdAt,
  });

  factory CrmLeadModel.fromJson(Map<String, dynamic> json) {
    // 1. Extract Customer Info
    final customer = json['customer'] is Map ? json['customer'] as Map<String, dynamic> : null;
    final name = customer?['full_name'] ?? json['name'] ?? json['customer_name'] ?? 'Customer';
    final phone = customer?['phone_number'] ?? json['phone'] ?? json['mobile'] ?? '';
    final email = customer?['email'] ?? json['email'];
    final pan = customer?['pan_number'] ?? json['pan_number'];

    // 2. Extract Financials
    final financials = json['financials'] is Map ? json['financials'] as Map<String, dynamic> : null;
    final amountVal = financials?['required_loan_amount'] ??
        financials?['disbursed_amount'] ??
        json['amount'] ??
        json['loan_amount'];
    final amount = double.tryParse(amountVal?.toString() ?? '0');
    final monthlyIncome = double.tryParse(financials?['monthly_income']?.toString() ?? '0');
    final disbursedAmount = double.tryParse(financials?['disbursed_amount']?.toString() ?? '0');
    final disbursedDate = financials?['disbursed_date']?.toString();

    // 3. Extract Car Info
    final car = json['car'] is Map ? json['car'] as Map<String, dynamic> : null;
    final carName = car?['car_name'] ?? json['car_name'] ?? json['model_name'];
    final regNo = car?['registration_number'] ?? json['reg_no'] ?? json['registration_number'];
    final carBrand = car?['brand']?.toString();

    // 4. Extract Staff / Agents
    String? assignedTo;
    if (json['assigned_to'] is Map) {
      assignedTo = json['assigned_to']['full_name'] ?? json['assigned_to']['username'];
    } else if (json['assigned_to'] != null) {
      assignedTo = json['assigned_to'].toString();
    } else {
      assignedTo = json['partner_name'];
    }

    String? sourcingManager;
    if (json['sourcing_manager'] is Map) {
      sourcingManager = json['sourcing_manager']['full_name'];
    } else if (json['sourcing_manager'] != null) {
      sourcingManager = json['sourcing_manager'].toString();
    }

    // 5. Followup / Remarks
    final followup = json['latest_followup'] is Map ? json['latest_followup'] as Map<String, dynamic> : null;
    final remarks = followup?['remarks'] ?? json['remarks'] ?? json['note'];

    // 6. Types & Statuses
    final rawLoanType = (json['loan_type'] ?? json['type'] ?? 'USED_CAR_LOAN').toString();
    final rawStatus = (json['lead_status'] ?? json['status'] ?? 'NEW').toString();

    return CrmLeadModel(
      id: json['id']?.toString() ?? '',
      leadCode: json['lead_id']?.toString(),
      name: name.toString(),
      phone: phone.toString(),
      email: email?.toString(),
      panNumber: pan?.toString(),
      city: json['city'] ?? json['state'],
      type: _beautifyLoanType(rawLoanType),
      rawLoanType: rawLoanType,
      carName: carName?.toString(),
      regNo: regNo?.toString(),
      carBrand: carBrand,
      amount: amount,
      monthlyIncome: monthlyIncome,
      disbursedAmount: disbursedAmount,
      disbursedDate: disbursedDate,
      status: _beautifyStatus(rawStatus),
      rawStatus: rawStatus,
      assignedTo: assignedTo,
      sourcingManager: sourcingManager,
      remarks: remarks?.toString(),
      createdAt: json['created_at']?.toString() ?? 'Recent',
    );
  }

  static String _beautifyLoanType(String type) {
    switch (type.toUpperCase()) {
      case 'USED_CAR_LOAN':
        return 'Used Car Loan';
      case 'NEW_CAR_LOAN':
        return 'New Car Loan';
      case 'BT_TOPUP_LOAN':
        return 'BT & Top-Up Loan';
      case 'CAR_LOAN_REFINANCE':
        return 'Car Loan Refinance';
      case 'PERSONAL_LOAN':
        return 'Personal Loan';
      case 'BUSINESS_LOAN':
        return 'Business Loan';
      case 'HOME_LOAN':
        return 'Home Loan';
      case 'LOAN_AGAINST_PROPERTIES':
        return 'Loan Against Property';
      default:
        return type.replaceAll('_', ' ');
    }
  }

  static String _beautifyStatus(String status) {
    switch (status.toUpperCase()) {
      case 'UNDER_PROCESS':
        return 'In Bank Login';
      case 'SENT_TO_BANK':
        return 'Sent to Bank';
      case 'APPROVED':
        return 'Approved';
      case 'DISBURSED':
        return 'Disbursed';
      case 'NEW_LEAD':
      case 'NEW':
        return 'New';
      case 'RTO_PROCESS':
        return 'RTO Process';
      case 'RTO_DONE':
        return 'RTO Done';
      case 'PAYMENT_CONFIRMATION':
        return 'Payment Requested';
      case 'PAYMENT_IN_PROCESS':
        return 'Payment In Process';
      case 'PAYMENT_DONE':
        return 'Payment Done';
      case 'CANCEL':
      case 'CANCELLED':
        return 'Cancelled';
      case 'REJECTED':
        return 'Rejected';
      default:
        return status.replaceAll('_', ' ');
    }
  }

  CrmLeadModel copyWith({
    String? status,
    String? remarks,
  }) {
    return CrmLeadModel(
      id: id,
      leadCode: leadCode,
      name: name,
      phone: phone,
      email: email,
      panNumber: panNumber,
      city: city,
      type: type,
      rawLoanType: rawLoanType,
      carName: carName,
      regNo: regNo,
      carBrand: carBrand,
      amount: amount,
      monthlyIncome: monthlyIncome,
      disbursedAmount: disbursedAmount,
      disbursedDate: disbursedDate,
      status: status ?? this.status,
      rawStatus: rawStatus,
      assignedTo: assignedTo,
      sourcingManager: sourcingManager,
      remarks: remarks ?? this.remarks,
      createdAt: createdAt,
    );
  }
}
