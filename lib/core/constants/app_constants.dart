import '../../models/car_model.dart';

class AppConstants {
  // Session Keys
  static const String keyAuthToken = "auth_token";
  static const String keyUserData = "user_data";

  // Branding & Support
  static const String appName = "FindMyCarz";
  static const String appVersion = "1.0.0";
  static const String supportEmail = "support@findmycarz.com";
  static const String supportPhoneNumber = "918084215228";
  static const String supportPhoneFormatted = "+91 80842 15228";

  // Financial fallbacks
  static const double defaultInterestRate = 9.5;
  static const int defaultLoanTenureMonths = 60;
  static const double minInterestRate = 12.5;

  static const List<String> carBodyClip = [
    "All",
    "SUV",
    "Sedan",
    "Hatchback",
    "Luxury"
  ];

  static const List<String> carTypes = ["Used Car", "New Car"];

  static const List<String> price = [
    "All Prices",
    "Under 5L",
    "5-10L",
    "10-20L",
    "Above 20L"
  ];

  static const List<String> popularCities = [
    "Delhi",
    "Noida",
    "Gurgaon",
    "Mumbai",
    "Pune",
    "Bangalore",
    "Ghaziabad",
    "Faridabad",
    "Chennai",
    "Hyderabad",
    "Kolkata"
  ];

  static final List<Car> allCars = [];

  static String formatPriceLakh(double val) {
    if (val == 0.0) return "₹0";
    if (val == 0.5) return "₹0.5 Lakh";
    if (val >= 100.0) {
      double cr = val / 100.0;
      if (cr == cr.toInt()) {
        return "₹${cr.toInt()} Cr";
      } else {
        return "₹${cr.toStringAsFixed(1)} Cr";
      }
    } else {
      if (val == val.toInt()) {
        return "₹${val.toInt()} Lakh";
      } else {
        return "₹${val.toStringAsFixed(1)} Lakh";
      }
    }
  }

  static String formatPriceLakhShort(double val) {
    if (val == 0.0) return "0";
    if (val == 0.5) return "0.5L";
    if (val >= 100.0) {
      double cr = val / 100.0;
      if (cr == cr.toInt()) {
        return "${cr.toInt()}Cr";
      } else {
        return "${cr.toStringAsFixed(1)}Cr";
      }
    } else {
      if (val == val.toInt()) {
        return "${val.toInt()}L";
      } else {
        return "${val.toStringAsFixed(1)}L";
      }
    }
  }
}
