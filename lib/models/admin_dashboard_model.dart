import 'crm_lead_model.dart';

class AdminDashboardModel {
  final int totalCars;
  final int availableCars;
  final int soldCars;
  final int ownerListedCars;
  final int myInventory;
  final int totalBrands;
  final int totalLeads;
  final int totalLogins;
  final int totalDisbursed;
  final int insuranceLeads;

  final LoanCategoryStats usedCarLoans;
  final LoanCategoryStats newCarLoans;
  final LoanCategoryStats btTopupLoans;
  final LoanCategoryStats refinanceLoans;
  final LoanCategoryStats personalLoans;
  final LoanCategoryStats businessLoans;
  final LoanCategoryStats homeLoans;
  final LoanCategoryStats lapLoans;

  final List<CrmLeadModel> recentLeads;
  final List<RecentCarItem> recentCars;

  AdminDashboardModel({
    this.totalCars = 0,
    this.availableCars = 0,
    this.soldCars = 0,
    this.ownerListedCars = 0,
    this.myInventory = 0,
    this.totalBrands = 0,
    this.totalLeads = 0,
    this.totalLogins = 0,
    this.totalDisbursed = 0,
    this.insuranceLeads = 0,
    LoanCategoryStats? usedCarLoans,
    LoanCategoryStats? newCarLoans,
    LoanCategoryStats? btTopupLoans,
    LoanCategoryStats? refinanceLoans,
    LoanCategoryStats? personalLoans,
    LoanCategoryStats? businessLoans,
    LoanCategoryStats? homeLoans,
    LoanCategoryStats? lapLoans,
    List<CrmLeadModel>? recentLeads,
    List<RecentCarItem>? recentCars,
  })  : usedCarLoans = usedCarLoans ??
            LoanCategoryStats(name: "Used Car Loan", colorHex: "#2563eb"),
        newCarLoans = newCarLoans ??
            LoanCategoryStats(name: "New Car Loan", colorHex: "#059669"),
        btTopupLoans = btTopupLoans ??
            LoanCategoryStats(name: "BT & Top-Up Loan", colorHex: "#7c3aed"),
        refinanceLoans = refinanceLoans ??
            LoanCategoryStats(name: "Car Loan Refinance", colorHex: "#d97706"),
        personalLoans = personalLoans ??
            LoanCategoryStats(name: "Personal Loan", colorHex: "#6366f1"),
        businessLoans = businessLoans ??
            LoanCategoryStats(name: "Business Loan", colorHex: "#ec4899"),
        homeLoans = homeLoans ??
            LoanCategoryStats(name: "Home Loan", colorHex: "#14b8a6"),
        lapLoans = lapLoans ??
            LoanCategoryStats(name: "Loan Against Property", colorHex: "#f59e0b"),
        recentLeads = recentLeads ?? const [],
        recentCars = recentCars ?? const [];

  factory AdminDashboardModel.fromJson(Map<String, dynamic> json) {
    final rootData = json['data'] is Map ? json['data'] as Map<String, dynamic> : json;
    final stats = rootData['stats'] is Map ? rootData['stats'] as Map<String, dynamic> : rootData;
    final loansData = rootData['loan_types_breakdown'] ?? rootData['loan_types'] ?? rootData['loans'] ?? {};

    // Parse leads if present
    List<CrmLeadModel> parsedLeads = [];
    if (rootData['leads'] is List) {
      parsedLeads = (rootData['leads'] as List)
          .map((e) => CrmLeadModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    // Parse recent cars if present
    List<RecentCarItem> parsedCars = [];
    if (rootData['recent_cars'] is List) {
      parsedCars = (rootData['recent_cars'] as List)
          .map((e) => RecentCarItem.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return AdminDashboardModel(
      totalCars: _parseInt(stats['total_cars'], 0),
      availableCars: _parseInt(stats['available_cars'], 0),
      soldCars: _parseInt(stats['sold_cars'], 0),
      ownerListedCars: _parseInt(stats['owner_cars'] ?? stats['owner_listed_cars'], 0),
      myInventory: _parseInt(stats['my_inventory'] ?? stats['total_cars'], 0),
      totalBrands: _parseInt(stats['total_brands'] ?? stats['brands'], 0),
      totalLeads: _parseInt(stats['total_leads'], 0),
      totalLogins: _parseInt(stats['total_login'] ?? stats['total_logins'], 0),
      totalDisbursed: _parseInt(stats['total_disbursed'], 0),
      insuranceLeads: _parseInt(stats['insurance_leads'], 0),
      usedCarLoans: LoanCategoryStats.fromJson(loansData['USED_CAR_LOAN'] ?? loansData['used_car_loan']),
      newCarLoans: LoanCategoryStats.fromJson(loansData['NEW_CAR_LOAN'] ?? loansData['new_car_loan']),
      btTopupLoans: LoanCategoryStats.fromJson(loansData['BT_TOPUP_LOAN'] ?? loansData['bt_topup_loan']),
      refinanceLoans: LoanCategoryStats.fromJson(loansData['CAR_LOAN_REFINANCE'] ?? loansData['refinance_loan']),
      personalLoans: LoanCategoryStats.fromJson(loansData['PERSONAL_LOAN'] ?? loansData['personal_loan']),
      businessLoans: LoanCategoryStats.fromJson(loansData['BUSINESS_LOAN'] ?? loansData['business_loan']),
      homeLoans: LoanCategoryStats.fromJson(loansData['HOME_LOAN'] ?? loansData['home_loan']),
      lapLoans: LoanCategoryStats.fromJson(loansData['LOAN_AGAINST_PROPERTIES'] ?? loansData['lap_loan']),
      recentLeads: parsedLeads,
      recentCars: parsedCars,
    );
  }

  static int _parseInt(dynamic val, int defaultVal) {
    if (val == null) return defaultVal;
    if (val is int) return val;
    return int.tryParse(val.toString()) ?? defaultVal;
  }
}

class LoanCategoryStats {
  final int totalFiles;
  final int inBankLogin;
  final int approved;
  final int disbursed;
  final int totalLeads;
  final String? name;
  final String? colorHex;

  LoanCategoryStats({
    int files = 0,
    this.inBankLogin = 0,
    this.approved = 0,
    this.disbursed = 0,
    int? totalLeads,
    this.name,
    this.colorHex,
  })  : totalFiles = files,
        totalLeads = totalLeads ?? files;

  factory LoanCategoryStats.fromJson(dynamic json) {
    if (json == null || json is! Map) {
      return LoanCategoryStats();
    }

    final total = json['total'] ?? json['files'] ?? json['total_leads'] ?? 0;
    final inLogin = json['login_count'] ?? json['in_bank_login'] ?? json['login'] ?? 0;
    final app = json['approved_count'] ?? json['approved'] ?? 0;
    final disb = json['disbursed_count'] ?? json['disbursed'] ?? 0;

    return LoanCategoryStats(
      files: int.tryParse(total.toString()) ?? 0,
      inBankLogin: int.tryParse(inLogin.toString()) ?? 0,
      approved: int.tryParse(app.toString()) ?? 0,
      disbursed: int.tryParse(disb.toString()) ?? 0,
      totalLeads: int.tryParse(total.toString()) ?? 0,
      name: json['name']?.toString(),
      colorHex: json['color']?.toString(),
    );
  }
}

class RecentCarItem {
  final int id;
  final String carName;
  final String? registrationNumber;
  final String? brand;
  final double? price;
  final String carStatus;

  RecentCarItem({
    required this.id,
    required this.carName,
    this.registrationNumber,
    this.brand,
    this.price,
    this.carStatus = 'Available',
  });

  factory RecentCarItem.fromJson(Map<String, dynamic> json) {
    return RecentCarItem(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      carName: json['car_name']?.toString() ?? 'Car',
      registrationNumber: json['registration_number']?.toString(),
      brand: json['brand']?.toString(),
      price: double.tryParse(json['used_price']?.toString() ?? '0'),
      carStatus: json['car_status']?.toString() ?? 'Available',
    );
  }
}
