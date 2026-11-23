class ApiConfig {
  static const String siteUrl = "https://awsdemo.co.in/findmycarz";
  static const String baseUrl = "$siteUrl/api/admin";

  // Auth Endpoints
  static const String authLogin = "/auth/login";
  static const String authMe = "/auth/me";
  static const String authLogout = "/auth/logout";

  // Profile & Security Endpoints
  static const String profile = "/profile";
  static const String profileUpdate = "/profile/update";
  static const String changePassword = "/profile/change-password";

  // Dashboard & Leads Endpoints
  static const String dashboard = "/dashboard";
  static const String administrators = "/administrators";
  static const String administratorsMeta = "/administrators/meta/options";
  static const String roles = "/roles";
  static const String crmLeads = "/leads";
  static const String updateLeadStatus = "/leads/update-status";

  // Legacy / Master Fallbacks
  static const String cars = "/cars";
  static const String outwardPayouts = "/payout/outward-list";
  static const String masterBrands = "/master/brands";
  static const String masterModels = "/master/models";
  static const String masterCities = "/master/cities";

  // Timeouts
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;
}
