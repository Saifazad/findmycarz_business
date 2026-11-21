import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../core/constants/api_config.dart';
import '../core/network/dio_client.dart';
import '../core/network/api_exceptions.dart';
import '../models/admin_profile_model.dart';

class ProfileViewModel extends ChangeNotifier {
  final DioClient _dioClient = DioClient();

  bool _isLoading = false;
  bool _isUpdating = false;
  bool _isChangingPassword = false;

  String? _errorMessage;
  String? _successMessage;
  AdminProfileModel? _profile;

  // Getters
  bool get isLoading => _isLoading;
  bool get isUpdating => _isUpdating;
  bool get isChangingPassword => _isChangingPassword;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  AdminProfileModel? get profile => _profile;

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  /// 1. GET /api/admin/profile - Fetch complete admin profile & module permissions
  Future<bool> fetchProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _dioClient.get(ApiConfig.profile);

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        if (data['success'] == true && data['profile'] != null) {
          _profile = AdminProfileModel.fromJson(data['profile']);
          _isLoading = false;
          notifyListeners();
          return true;
        } else {
          _errorMessage = data['message'] ?? "Unable to fetch profile details.";
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

  /// 2. POST /api/admin/profile/update - Update profile info with multipart/form-data
  Future<bool> updateProfile({
    required String fullName,
    required String phone,
    String? altPhone,
    String? gender,
    String? dob,
    String? imagePath,
  }) async {
    _isUpdating = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final Map<String, dynamic> formMap = {
        'full_name': fullName.trim(),
        'phone': phone.trim(),
        if (altPhone != null && altPhone.trim().isNotEmpty)
          'alt_phone': altPhone.trim(),
        if (gender != null && gender.trim().isNotEmpty)
          'gender': gender.trim(),
        if (dob != null && dob.trim().isNotEmpty)
          'dob': dob.trim(),
      };

      if (imagePath != null && imagePath.isNotEmpty) {
        final file = File(imagePath);
        if (await file.exists()) {
          final fileName = imagePath.split('/').last;
          formMap['profile_image'] = await MultipartFile.fromFile(
            imagePath,
            filename: fileName,
          );
        }
      }

      final formData = FormData.fromMap(formMap);

      final response = await _dioClient.post(
        ApiConfig.profileUpdate,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        if (data['success'] == true) {
          _successMessage = data['message'] ?? "Profile updated successfully";

          // If updated profile object is returned in response, sync state
          if (data['profile'] != null && data['profile'] is Map<String, dynamic>) {
            final updated = data['profile'];
            _profile = (_profile ?? AdminProfileModel()).copyWith(
              fullName: updated['full_name']?.toString() ?? fullName,
              phone: updated['phone']?.toString() ?? phone,
              altPhone: updated['alt_phone']?.toString() ?? altPhone,
              gender: updated['gender']?.toString() ?? gender,
              dob: updated['dob']?.toString() ?? dob,
              image: updated['image']?.toString() ?? _profile?.image,
            );
          } else {
            // Optimistic update
            _profile = (_profile ?? AdminProfileModel()).copyWith(
              fullName: fullName,
              phone: phone,
              altPhone: altPhone,
              gender: gender,
              dob: dob,
            );
          }

          _isUpdating = false;
          notifyListeners();
          return true;
        } else {
          _errorMessage = data['message'] ?? "Failed to update profile.";
        }
      } else {
        _errorMessage = "Server error (${response.statusCode}). Please try again.";
      }
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
    }

    _isUpdating = false;
    notifyListeners();
    return false;
  }

  /// 3. POST /api/admin/profile/change-password - Change current password
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    _isChangingPassword = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final payload = {
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': newPasswordConfirmation,
      };

      final response = await _dioClient.post(
        ApiConfig.changePassword,
        data: payload,
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        if (data['success'] == true) {
          _successMessage = data['message'] ?? "Password changed successfully";
          _isChangingPassword = false;
          notifyListeners();
          return true;
        } else {
          _errorMessage = data['message'] ?? "Failed to change password.";
        }
      } else {
        _errorMessage = "Server error (${response.statusCode}). Please try again.";
      }
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
    }

    _isChangingPassword = false;
    notifyListeners();
    return false;
  }
}
