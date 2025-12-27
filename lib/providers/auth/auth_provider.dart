import 'package:flutter/material.dart';
import 'package:samruddha_kirana/api/api_response.dart';
import 'package:samruddha_kirana/models/auth/user_model.dart';
import 'package:samruddha_kirana/services/auth/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;

  bool _otpSent = false;

  UserModel? _user;

  bool get isLoading => _isLoading;

  bool get otpSent => _otpSent;

  UserModel? get user => _user;

  // new user registration
  Future<ApiResponse> signup({
    required String firstName,
    required String lastName,
    required String mobile,
    String? email,
    required String password,
    required String confirmPassword,
  }) async {
    _isLoading = true;
    notifyListeners();

    final response = await AuthService.signup(
      firstName: firstName,
      lastName: lastName,
      mobile: mobile,
      email: email ?? "",
      password: password,
      confirmPassword: confirmPassword,
    );

    if (response.success && response.data != null) {
      _user = UserModel.fromJson(response.data);
    }

    _isLoading = false;
    notifyListeners();
    return response;
  }

  // login with password
  Future<ApiResponse> loginWithPassword({
    required String mobile,
    required String password,
  }) async {
    if (_isLoading) {
      return ApiResponse(success: false, message: 'Please wait');
    }

    _isLoading = true;
    notifyListeners();

    final response = await AuthService.loginWithPassword(
      mobile: mobile,
      password: password,
    );

    if (response.success && response.data != null) {
      _user = UserModel.fromJson(response.data);
    }

    _isLoading = false;
    notifyListeners();
    return response;
  }

  // login with OTP
  Future<ApiResponse> loginWithOtp({required String mobile}) async {
    if (_isLoading) {
      return ApiResponse(success: false, message: 'Please wait');
    }

    _isLoading = true;
    notifyListeners();

    final response = await AuthService.loginWithOtp(mobile: mobile);
    if (response.success) {
      _otpSent = true; // ✅ KEY LINE (OTP FIELD SHOWS)
    }

    _isLoading = false;
    notifyListeners();
    return response;
  }

  // verify login OTP
  Future<ApiResponse> verifyLoginOtp({
    required String mobile,
    required String otp,
  }) async {
    if (_isLoading) {
      return ApiResponse(success: false, message: 'Please wait');
    }

    _isLoading = true;
    notifyListeners();

    final response = await AuthService.verifyLoginOtp(mobile: mobile, otp: otp);

    if (response.success && response.data != null) {
      _user = UserModel.fromJson(response.data);
    }

    _isLoading = false;
    notifyListeners();
    return response;
  }

  // RESET OTP STATE METHOD
  void resetOtp() {
    _otpSent = false;
    notifyListeners();
  }
}
