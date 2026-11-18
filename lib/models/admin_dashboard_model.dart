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
  })  : usedCarLoans = usedCarLoans ?? LoanCategoryStats(files: 43, inBankLogin: 2),
        newCarLoans = newCarLoans ?? LoanCategoryStats(files: 1, inBankLogin: 0),
        btTopupLoans = btTopupLoans ?? LoanCategoryStats(files: 14, inBankLogin: 4),
        refinanceLoans = refinanceLoans ?? LoanCategoryStats(files: 3, inBankLogin: 0);

  factory AdminDashboardModel.fromJson(Map<String, dynamic> json) {
    final carsData = json['car_management'] ?? json['cars'] ?? {};
    final loansData = json['loans'] ?? json['loan_types'] ?? {};

    return AdminDashboardModel(
      totalCars: _parseInt(carsData['total_cars'] ?? json['total_cars'], 901),
      availableCars: _parseInt(carsData['available_cars'] ?? json['available_cars'], 602),
      soldCars: _parseInt(carsData['sold_cars'] ?? json['sold_cars'], 299),
      ownerListedCars: _parseInt(carsData['owner_listed_cars'] ?? json['owner_listed_cars'], 168),
      myInventory: _parseInt(carsData['my_inventory'] ?? json['my_inventory'], 901),
      totalBrands: _parseInt(carsData['brands'] ?? json['brands'], 43),
      usedCarLoans: LoanCategoryStats.fromJson(loansData['used_car_loan']),
      newCarLoans: LoanCategoryStats.fromJson(loansData['new_car_loan']),
      btTopupLoans: LoanCategoryStats.fromJson(loansData['bt_topup_loan']),
      refinanceLoans: LoanCategoryStats.fromJson(loansData['refinance_loan']),
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

  LoanCategoryStats({
    int files = 0,
    int inBankLogin = 0,
    this.approved = 0,
    this.disbursed = 0,
  })  : totalFiles = files,
        this.inBankLogin = inBankLogin;

  factory LoanCategoryStats.fromJson(dynamic json) {
    if (json == null || json is! Map<String, dynamic>) {
      return LoanCategoryStats();
    }
    return LoanCategoryStats(
      files: int.tryParse(json['total_files']?.toString() ?? json['files']?.toString() ?? '0') ?? 0,
      inBankLogin: int.tryParse(json['in_bank_login']?.toString() ?? '0') ?? 0,
      approved: int.tryParse(json['approved']?.toString() ?? '0') ?? 0,
      disbursed: int.tryParse(json['disbursed']?.toString() ?? '0') ?? 0,
    );
  }
}

