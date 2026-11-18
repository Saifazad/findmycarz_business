import 'package:flutter/material.dart';
import '../core/constants/api_config.dart';
import '../core/network/dio_client.dart';
import '../models/payout_model.dart';

class PayoutViewModel extends ChangeNotifier {
  final DioClient _dioClient = DioClient();

  bool _isLoading = false;
  String? _errorMessage;
  PayoutSummaryModel _summary = PayoutSummaryModel();

  String _searchQuery = "";
  String _selectedLoanType = "All Loan Types";
  String _selectedBank = "All Banks";

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  PayoutSummaryModel get summary => _summary;
  String get searchQuery => _searchQuery;
  String get selectedLoanType => _selectedLoanType;
  String get selectedBank => _selectedBank;

  final List<String> loanTypes = [
    "All Loan Types",
    "Used Car Loan",
    "New Car Loan",
    "BT & Top-Up Loan",
    "Car Loan Refinance"
  ];

  final List<String> banks = [
    "All Banks",
    "HDFC Bank",
    "ICICI Bank",
    "SBI",
    "Axis Bank",
    "Kotak Mahindra",
    "IDFC First"
  ];

  Future<void> fetchPayouts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _dioClient.get(
        ApiConfig.outwardPayouts,
        queryParameters: {
          'search': _searchQuery,
          'loan_type': _selectedLoanType == "All Loan Types" ? "" : _selectedLoanType,
          'bank': _selectedBank == "All Banks" ? "" : _selectedBank,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        _summary = PayoutSummaryModel.fromJson(response.data);
      }
    } catch (e) {
      // Fallback matching Screenshot 2
      _summary = PayoutSummaryModel(
        disbursedLeads: 0,
        disbursedVolume: 0.0,
        totalOutwardPayout: 0.0,
        avgPayoutRate: 0.0,
        items: [],
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedLoanType(String type) {
    _selectedLoanType = type;
    notifyListeners();
  }

  void setSelectedBank(String bank) {
    _selectedBank = bank;
    notifyListeners();
  }

  void resetFilters() {
    _searchQuery = "";
    _selectedLoanType = "All Loan Types";
    _selectedBank = "All Banks";
    fetchPayouts();
  }
}

