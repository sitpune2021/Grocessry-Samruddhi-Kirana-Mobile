import 'dart:async';

import 'package:flutter/material.dart';
import 'package:samruddha_kirana/api/api_response.dart';
import 'package:samruddha_kirana/models/auth/user_model.dart';
import 'package:samruddha_kirana/services/auth/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;

  bool _otpSent = false;

  UserModel? _user;

  int _otpTimer = 0;
  Timer? _timer;

  String? _forgotPasswordMobile; // ✅ SINGLE SOURCE OF TRUTH

  bool get isLoading => _isLoading;

  bool get otpSent => _otpSent;

  UserModel? get user => _user;

  int get otpTimer => _otpTimer;

  String get forgotPasswordMobile => _forgotPasswordMobile ?? '';

  // ========================= Register METHODS ========================= //
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

  // ========================= Login METHODS ========================= //
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

  // ========================= Forgot PASSWORD METHODS ========================= //
  // forget password OTP
  Future<ApiResponse> sendForgotPasswordOtp({required String mobile}) async {
    if (_isLoading) {
      return ApiResponse(success: false, message: 'Please wait');
    }

    _isLoading = true;
    notifyListeners();

    final response = await AuthService.sendForgotPasswordOtp(mobile: mobile);

    if (response.success) {
      _forgotPasswordMobile = mobile; // 🔐 STORE ONCE
      _otpSent = true; // ✅ KEY LINE (OTP FIELD SHOWS)
      _startOtpTimer(); // ✅ START TIMER HERE
    }

    _isLoading = false;
    notifyListeners();
    return response;
  }

  // verify forget password OTP
  Future<ApiResponse> verifyForgotPasswordOtp({
    // required String mobile,
    required String otp,
  }) async {
    if (_isLoading) {
      return ApiResponse(success: false, message: 'Please wait');
    }

    _isLoading = true;
    notifyListeners();

    final response = await AuthService.verifyForgotPasswordOtp(
      mobile: _forgotPasswordMobile!, // ✅ SAME MOBILE
      otp: otp,
    );

    _isLoading = false;
    notifyListeners();
    return response;
  }

  // ================= TIMER ================= //
  void _startOtpTimer() {
    _otpTimer = 60;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_otpTimer == 0) {
        t.cancel();
      } else {
        _otpTimer--;
        notifyListeners();
      }
    });
  }

  // ================= RESET STATE ================= //
  void resetForgotPasswordState() {
    _otpSent = false;
    _otpTimer = 0;
    _forgotPasswordMobile = null; // 🔐 CLEAR
    _timer?.cancel();
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // set new password after forgot password
  Future<ApiResponse> setNewPassword({
    // required String mobile,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (_isLoading) {
      return ApiResponse(success: false, message: 'Please wait');
    }

    _isLoading = true;
    notifyListeners();

    final response = await AuthService.setNewPassword(
      mobile: _forgotPasswordMobile!, // ✅ SAME MOBILE
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );

    _isLoading = false;
    notifyListeners();
    return response;
  }
}
