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
    this.totalCars = 900,
    this.availableCars = 601,
    this.soldCars = 299,
    this.ownerListedCars = 168,
    this.myInventory = 900,
    this.totalBrands = 43,
    this.totalLeads = 69,
    this.totalLogins = 5,
    this.totalDisbursed = 10,
    this.insuranceLeads = 11,
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
            LoanCategoryStats(
                files: 43, inBankLogin: 1, approved: 1, disbursed: 7, totalLeads: 43),
        newCarLoans = newCarLoans ??
            LoanCategoryStats(
                files: 3, inBankLogin: 0, approved: 0, disbursed: 0, totalLeads: 3),
        btTopupLoans = btTopupLoans ??
            LoanCategoryStats(
                files: 14, inBankLogin: 4, approved: 0, disbursed: 0, totalLeads: 14),
        refinanceLoans = refinanceLoans ??
            LoanCategoryStats(
                files: 4, inBankLogin: 0, approved: 0, disbursed: 2, totalLeads: 4),
        personalLoans = personalLoans ??
            LoanCategoryStats(
                files: 2, inBankLogin: 0, approved: 0, disbursed: 0, totalLeads: 2),
        businessLoans = businessLoans ??
            LoanCategoryStats(
                files: 1, inBankLogin: 0, approved: 0, disbursed: 0, totalLeads: 1),
        homeLoans = homeLoans ??
            LoanCategoryStats(
                files: 1, inBankLogin: 0, approved: 0, disbursed: 0, totalLeads: 1),
        lapLoans = lapLoans ??
            LoanCategoryStats(
                files: 1, inBankLogin: 0, approved: 0, disbursed: 1, totalLeads: 1),
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
      totalCars: _parseInt(stats['total_cars'], 900),
      availableCars: _parseInt(stats['available_cars'], 601),
      soldCars: _parseInt(stats['sold_cars'], 299),
      ownerListedCars: _parseInt(stats['owner_cars'] ?? stats['owner_listed_cars'], 168),
      myInventory: _parseInt(stats['total_cars'], 900),
      totalBrands: _parseInt(stats['total_brands'] ?? stats['brands'], 43),
      totalLeads: _parseInt(stats['total_leads'], 69),
      totalLogins: _parseInt(stats['total_login'], 5),
      totalDisbursed: _parseInt(stats['total_disbursed'], 10),
      insuranceLeads: _parseInt(stats['insurance_leads'], 11),
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
