import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/api_config.dart';
import '../core/network/dio_client.dart';
import '../core/network/api_exceptions.dart';

enum UserRole { superAdmin, partner, dealer, sourcingManager, unknown }

class AuthViewModel extends ChangeNotifier {
  final DioClient _dioClient = DioClient();

  bool _isLoading = false;
  bool _isLoggedIn = false;
  String? _token;
  String? _userName;
  String? _userEmail;
  String? _userPhone;
  String? _adminCode;
  String? _avatarUrl;
  UserRole _role = UserRole.unknown;
  String? _roleName;
  String? _errorMessage;
  Map<String, dynamic> _capabilities = {};

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  String? get token => _token;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get userPhone => _userPhone;
  String? get adminCode => _adminCode;
  String? get avatarUrl => _avatarUrl;
  String? get profileImageUrl => _avatarUrl;
  UserRole get role => _role;
  String? get roleName => _roleName;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic> get capabilities => _capabilities;

  bool get isSuperAdmin => _role == UserRole.superAdmin;
  bool get isPartner => _role == UserRole.partner || _role == UserRole.dealer;

  static const String _kToken = "business_auth_token";
  static const String _kRole = "business_user_role";
  static const String _kRoleName = "business_user_role_name";
  static const String _kName = "business_user_name";
  static const String _kEmail = "business_user_email";
  static const String _kPhone = "business_user_phone";
  static const String _kCode = "business_admin_code";

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_kToken);
    final savedRole = prefs.getString(_kRole);
    _roleName = prefs.getString(_kRoleName);
    _userName = prefs.getString(_kName);
    _userEmail = prefs.getString(_kEmail);
    _userPhone = prefs.getString(_kPhone);
    _adminCode = prefs.getString(_kCode);

    if (_token != null && _token!.isNotEmpty) {
      _isLoggedIn = true;
      _role = _parseRole(savedRole);
      // Fetch fresh profile in background
      fetchMe();
    }
    notifyListeners();
  }

  Future<bool> login({
    required String emailOrPhone,
    required String password,
    String? selectedRole,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _dioClient.post(
        ApiConfig.authLogin,
        data: {
          'login': emailOrPhone,
          'password': password,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        if (data['status'] == true || data['token'] != null) {
          _token = data['token'] ?? data['access_token'];
          final admin = data['administrator'] ?? data['user'] ?? {};
          _userName = admin['full_name'] ?? admin['username'] ?? 'Find My Car Admin';
          _userEmail = admin['email'] ?? emailOrPhone;
          _roleName = admin['role_name'] ?? 'Super Admin';
          _role = _parseRole(_roleName);

          await _saveSession();
          _isLoggedIn = true;

          // Fetch full profile info
          await fetchMe();

          _isLoading = false;
          notifyListeners();
          return true;
        } else {
          _errorMessage = data['message'] ?? "Invalid login credentials.";
        }
      } else {
        _errorMessage = "Server error (${response.statusCode}). Please try again.";
      }
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> fetchMe() async {
    try {
      final response = await _dioClient.get(ApiConfig.authMe);
      if (response.statusCode == 200 && response.data != null) {
        final admin = response.data['administrator'] ?? {};
        _userName = admin['full_name'] ?? _userName;
        _userPhone = admin['phone'];
        _adminCode = admin['administrator_id'];
        _avatarUrl = admin['image_url'];
        if (admin['capabilities'] is Map) {
          _capabilities = Map<String, dynamic>.from(admin['capabilities']);
        }
        await _saveSession();
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> updateLocalProfile({String? name, String? phone, String? avatarUrl}) async {
    if (name != null) _userName = name;
    if (phone != null) _userPhone = phone;
    if (avatarUrl != null) _avatarUrl = avatarUrl;
    await _saveSession();
    notifyListeners();
  }

  Future<void> logout() async {
    try {
      await _dioClient.post(ApiConfig.authLogout);
    } catch (_) {}

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kToken);
    await prefs.remove(_kRole);
    await prefs.remove(_kRoleName);
    await prefs.remove(_kName);
    await prefs.remove(_kEmail);
    await prefs.remove(_kPhone);
    await prefs.remove(_kCode);

    _isLoggedIn = false;
    _token = null;
    _userName = null;
    _userEmail = null;
    _userPhone = null;
    _adminCode = null;
    _role = UserRole.unknown;
    notifyListeners();
  }

  Future<void> _saveSession() async {
    final prefs = await SharedPreferences.getInstance();
    if (_token != null) await prefs.setString(_kToken, _token!);
    await prefs.setString(_kRole, _role.name);
    if (_roleName != null) await prefs.setString(_kRoleName, _roleName!);
    if (_userName != null) await prefs.setString(_kName, _userName!);
    if (_userEmail != null) await prefs.setString(_kEmail, _userEmail!);
    if (_userPhone != null) await prefs.setString(_kPhone, _userPhone!);
    if (_adminCode != null) await prefs.setString(_kCode, _adminCode!);
  }

  UserRole _parseRole(String? roleStr) {
    if (roleStr == null) return UserRole.superAdmin;
    final r = roleStr.toLowerCase();
    if (r.contains('super') || r.contains('admin') || r == 'sa') {
      return UserRole.superAdmin;
    } else if (r.contains('partner') || r.contains('dealer') || r == 'd') {
      return UserRole.partner;
    } else if (r.contains('sm') || r.contains('sourcing')) {
      return UserRole.sourcingManager;
    }
    return UserRole.superAdmin;
  }
}
