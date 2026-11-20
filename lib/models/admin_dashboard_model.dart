class AdminDashboardModel {
  final int totalCars;
  final int availableCars;
  final int soldCars;
  final int ownerListedCars;
  final int myInventory;
  final int totalBrands;

  final LoanCategoryStats usedCarLoans;
  final LoanCategoryStats newCarLoans;
  final LoanCategoryStats btTopupLoans;
  final LoanCategoryStats refinanceLoans;
  final LoanCategoryStats personalLoans;
  final LoanCategoryStats businessLoans;
  final LoanCategoryStats homeLoans;
  final LoanCategoryStats lapLoans;

  AdminDashboardModel({
    this.totalCars = 901,
    this.availableCars = 602,
    this.soldCars = 299,
    this.ownerListedCars = 168,
    this.myInventory = 901,
    this.totalBrands = 43,
    LoanCategoryStats? usedCarLoans,
    LoanCategoryStats? newCarLoans,
    LoanCategoryStats? btTopupLoans,
    LoanCategoryStats? refinanceLoans,
    LoanCategoryStats? personalLoans,
    LoanCategoryStats? businessLoans,
    LoanCategoryStats? homeLoans,
    LoanCategoryStats? lapLoans,
  })  : usedCarLoans = usedCarLoans ??
            LoanCategoryStats(
                files: 43, inBankLogin: 1, approved: 1, disbursed: 8, totalLeads: 43),
        newCarLoans = newCarLoans ??
            LoanCategoryStats(
                files: 2, inBankLogin: 0, approved: 0, disbursed: 0, totalLeads: 2),
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
                files: 1, inBankLogin: 0, approved: 0, disbursed: 1, totalLeads: 1);

  factory AdminDashboardModel.fromJson(Map<String, dynamic> json) {
    final carsData = json['car_management'] ?? json['cars'] ?? {};
    final loansData = json['loans'] ?? json['loan_types'] ?? {};

    return AdminDashboardModel(
      totalCars: _parseInt(carsData['total_cars'] ?? json['total_cars'], 901),
      availableCars:
          _parseInt(carsData['available_cars'] ?? json['available_cars'], 602),
      soldCars: _parseInt(carsData['sold_cars'] ?? json['sold_cars'], 299),
      ownerListedCars: _parseInt(
          carsData['owner_listed_cars'] ?? json['owner_listed_cars'], 168),
      myInventory:
          _parseInt(carsData['my_inventory'] ?? json['my_inventory'], 901),
      totalBrands: _parseInt(carsData['brands'] ?? json['brands'], 43),
      usedCarLoans: LoanCategoryStats.fromJson(loansData['used_car_loan']),
      newCarLoans: LoanCategoryStats.fromJson(loansData['new_car_loan']),
      btTopupLoans: LoanCategoryStats.fromJson(loansData['bt_topup_loan']),
      refinanceLoans: LoanCategoryStats.fromJson(loansData['refinance_loan']),
      personalLoans: LoanCategoryStats.fromJson(loansData['personal_loan']),
      businessLoans: LoanCategoryStats.fromJson(loansData['business_loan']),
      homeLoans: LoanCategoryStats.fromJson(loansData['home_loan']),
      lapLoans: LoanCategoryStats.fromJson(
          loansData['lap_loan'] ?? loansData['loan_against_property']),
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

  LoanCategoryStats({
    int files = 0,
    this.inBankLogin = 0,
    this.approved = 0,
    this.disbursed = 0,
    int? totalLeads,
  })  : totalFiles = files,
        totalLeads = totalLeads ?? files;

  factory LoanCategoryStats.fromJson(dynamic json) {
    if (json == null || json is! Map<String, dynamic>) {
      return LoanCategoryStats();
    }
    final f = int.tryParse(json['total_files']?.toString() ??
            json['files']?.toString() ??
            '0') ??
        0;
    return LoanCategoryStats(
      files: f,
      inBankLogin: int.tryParse(json['in_bank_login']?.toString() ?? '0') ?? 0,
      approved: int.tryParse(json['approved']?.toString() ?? '0') ?? 0,
      disbursed: int.tryParse(json['disbursed']?.toString() ?? '0') ?? 0,
      totalLeads: int.tryParse(json['total_leads']?.toString() ?? '$f') ?? f,
    );
  }
}
