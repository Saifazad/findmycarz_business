class ApiConfig {
  static const String siteUrl = "https://findmycarz.com";
  // Replace this with your actual Laravel/backend URL in production
  static const String baseUrl = "$siteUrl/api";

  // Endpoints
  static const String cars = "/cars";
  static const String homeSections = "/cars/home-sections";
  static const String loanCheck = "/leads/submit";
  static const String submitNewCarLoan = "/leads/save";
  static const String submitInsurance = "/leads/submit";
  static const String submitCallback = "/leads/submit";
  static const String submitBtTopup = "/loans/bt-topup";
  static const String login = "/user/login";
  static const String register = "/user/register";
  static const String logout = "/user/logout";
  static const String sendOtp = "/user/forgot-password/send-otp";
  static const String resetPassword = "/user/forgot-password/reset";
  static const String updateProfile = "/user/update-profile";
  static const String updateAvatar = "/user/update-avatar";
  static const String myListings = "/user/listings";
  static const String userMe = "/user/me";
  static const String changePassword = "/user/change-password";
  static const String sellCar = "/cars/sell";
  static const String verifyRc = "/vehicle/verify-rc";
  static const String testimonials = "/testimonials";

  // CRM & Business Endpoints
  static const String crmLogin = "/admin/login";
  static const String adminDashboard = "/admin/dashboard";
  static const String partnerDashboard = "/partner/dashboard";
  static const String outwardPayouts = "/administrators/payout/outward-list";
  static const String crmLeads = "/admin/leads";
  static const String updateLeadStatus = "/admin/leads/update-status";

  // Master Endpoints
  static const String masterBrands = "/master/brands";
  static const String masterModels = "/master/models";
  static const String masterBodyTypes = "/master/body-types";
  static const String masterStates = "/master/states";
  static const String masterRtoCodes = "/master/rto-codes";
  static const String masterOwnerships = "/master/ownerships";
  static const String masterSeats = "/master/seats";
  static const String masterColors = "/master/colors";
  static const String masterKmsRanges = "/master/kms-driven-ranges";
  static const String masterTransmissions = "/master/transmissions";
  static const String masterFuelTypes = "/master/fuel-types";
  static const String masterCities = "/master/cities";
  static const String masterMakeYears = "/master/make-years";
  static const String masterActiveCities = "/master/active-cities";

  // Connect and receive timeouts in milliseconds
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;

  // Default query parameters for used cars API call
  static const String defaultType = "used";
  static const String defaultVehicleType = "used";
  static const String defaultSort = "newest";
  static const int defaultMinPrice = 0;
  static const int defaultMaxPrice = 1000000000;
  static const int defaultMinKm = 0;
  static const int defaultMaxKm = 900000;
  static const int defaultPage = 1;

  // External APIs
  static const String pincodeLookup = "https://api.postalpincode.in/pincode";
}
