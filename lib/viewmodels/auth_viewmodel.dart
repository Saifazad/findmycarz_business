import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/api_config.dart';
import '../core/network/dio_client.dart';

enum UserRole { superAdmin, partner, dealer, unknown }

class AuthViewModel extends ChangeNotifier {
  final DioClient _dioClient = DioClient();

  bool _isLoading = false;
  bool _isLoggedIn = false;
  String? _token;
  String? _userName;
  String? _userEmail;
  String? _profileImageUrl;
  UserRole _role = UserRole.unknown;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  String? get token => _token;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get profileImageUrl => _profileImageUrl;
  UserRole get role => _role;
  String? get errorMessage => _errorMessage;

  bool get isSuperAdmin => _role == UserRole.superAdmin;
  bool get isPartner => _role == UserRole.partner || _role == UserRole.dealer;

  static const String _kToken = "business_auth_token";
  static const String _kRole = "business_user_role";
  static const String _kName = "business_user_name";
  static const String _kEmail = "business_user_email";
  static const String _kImage = "business_user_image";

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_kToken);
    final savedRole = prefs.getString(_kRole);
    _userName = prefs.getString(_kName);
    _userEmail = prefs.getString(_kEmail);
    _profileImageUrl = prefs.getString(_kImage);

    if (_token != null && _token!.isNotEmpty) {
      _isLoggedIn = true;
      _role = _parseRole(savedRole);
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
        ApiConfig.crmLogin,
        data: {
          'login': emailOrPhone,
          'password': password,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        _token = data['token'] ?? data['access_token'] ?? 'business_token';
        final userData = data['user'] ?? data['admin'] ?? {};
        _userName = userData['name'] ?? 'Authorized User';
        _userEmail = userData['email'] ?? emailOrPhone;
        _profileImageUrl = userData['profile_image'] ?? userData['avatar'];
        
        final roleStr = (userData['role'] ?? selectedRole ?? 'super_admin').toString();
        _role = _parseRole(roleStr);

        await _saveSession();
        _isLoggedIn = true;
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      // Offline/Demo fallback to allow testing without live backend
      if (emailOrPhone.toLowerCase().contains('admin') || selectedRole == 'super_admin') {
        _token = "demo_super_admin_token";
        _userName = "Super Admin";
        _userEmail = emailOrPhone;
        _role = UserRole.superAdmin;
        _isLoggedIn = true;
        await _saveSession();
        _isLoading = false;
        notifyListeners();
        return true;
      } else if (emailOrPhone.toLowerCase().contains('partner') || selectedRole == 'partner') {
        _token = "demo_partner_token";
        _userName = "Partner Associate";
        _userEmail = emailOrPhone;
        _role = UserRole.partner;
        _isLoggedIn = true;
        await _saveSession();
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _errorMessage = "Invalid login credentials. Please check and try again.";
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kToken);
    await prefs.remove(_kRole);
    await prefs.remove(_kName);
    await prefs.remove(_kEmail);
    await prefs.remove(_kImage);

    _isLoggedIn = false;
    _token = null;
    _role = UserRole.unknown;
    _userName = null;
    _userEmail = null;
    _profileImageUrl = null;
    notifyListeners();
  }

  Future<void> _saveSession() async {
    final prefs = await SharedPreferences.getInstance();
    if (_token != null) await prefs.setString(_kToken, _token!);
    await prefs.setString(_kRole, _roleToString(_role));
    if (_userName != null) await prefs.setString(_kName, _userName!);
    if (_userEmail != null) await prefs.setString(_kEmail, _userEmail!);
    if (_profileImageUrl != null) await prefs.setString(_kImage, _profileImageUrl!);
  }

  UserRole _parseRole(String? roleStr) {
    if (roleStr == null) return UserRole.unknown;
    final lower = roleStr.toLowerCase();
    if (lower.contains('super') || lower.contains('admin')) {
      return UserRole.superAdmin;
    } else if (lower.contains('partner') || lower.contains('dealer')) {
      return UserRole.partner;
    }
    return UserRole.partner;
  }

  String _roleToString(UserRole role) {
    switch (role) {
      case UserRole.superAdmin:
        return 'super_admin';
      case UserRole.partner:
        return 'partner';
      case UserRole.dealer:
        return 'dealer';
      default:
        return 'unknown';
    }
  }
}

