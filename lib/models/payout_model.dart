class PayoutSummaryModel {
  final int disbursedLeads;
  final double disbursedVolume;
  final double totalOutwardPayout;
  final double avgPayoutRate;
  final List<PayoutItemModel> items;

  PayoutSummaryModel({
    this.disbursedLeads = 0,
    this.disbursedVolume = 0.0,
    this.totalOutwardPayout = 0.0,
    this.avgPayoutRate = 0.0,
    this.items = const [],
  });

  factory PayoutSummaryModel.fromJson(Map<String, dynamic> json) {
    final list = json['items'] ?? json['data'] ?? [];
    List<PayoutItemModel> parsedItems = [];
    if (list is List) {
      parsedItems = list.map((e) => PayoutItemModel.fromJson(e)).toList();
    }

    return PayoutSummaryModel(
      disbursedLeads: _parseInt(json['disbursed_leads']),
      disbursedVolume: _parseDouble(json['disbursed_volume']),
      totalOutwardPayout: _parseDouble(json['total_outward_payout']),
      avgPayoutRate: _parseDouble(json['avg_payout_rate']),
      items: parsedItems,
    );
  }

  static int _parseInt(dynamic val) {
    if (val == null) return 0;
    if (val is int) return val;
    return int.tryParse(val.toString()) ?? 0;
  }

  static double _parseDouble(dynamic val) {
    if (val == null) return 0.0;
    if (val is num) return val.toDouble();
    return double.tryParse(val.toString()) ?? 0.0;
  }
}

class PayoutItemModel {
  final String id;
  final String customerName;
  final String customerPhone;
  final String dealerName;
  final String leadId;
  final String loanType;
  final String bankName;
  final double payoutAmount;
  final String status;
  final String date;

  PayoutItemModel({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.dealerName,
    required this.leadId,
    required this.loanType,
    required this.bankName,
    required this.payoutAmount,
    required this.status,
    required this.date,
  });

  factory PayoutItemModel.fromJson(Map<String, dynamic> json) {
    return PayoutItemModel(
      id: json['id']?.toString() ?? '',
      customerName: json['customer_name'] ?? json['name'] ?? 'N/A',
      customerPhone: json['customer_phone'] ?? json['phone'] ?? '',
      dealerName: json['dealer_name'] ?? json['partner_name'] ?? 'Direct',
      leadId: json['lead_id']?.toString() ?? json['id']?.toString() ?? '',
      loanType: json['loan_type'] ?? 'Used Car Loan',
      bankName: json['bank'] ?? json['bank_name'] ?? 'N/A',
      payoutAmount: double.tryParse(json['payout']?.toString() ?? '0') ?? 0.0,
      status: json['status'] ?? 'Pending',
      date: json['date'] ?? json['created_at'] ?? '',
    );
  }
}

