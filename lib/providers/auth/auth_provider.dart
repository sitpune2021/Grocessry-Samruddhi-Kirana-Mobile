import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:samruddha_kirana/api/api_response.dart';
import 'package:samruddha_kirana/api/session/token_storage.dart';
import 'package:samruddha_kirana/config/routes.dart';
import 'package:samruddha_kirana/models/auth/user_model.dart';
import 'package:samruddha_kirana/models/user/get_user_profile_data_model.dart';
import 'package:samruddha_kirana/services/auth/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isInitialized = false;
  bool _otpSent = false;

  UserModel? _user;

  int _otpTimer = 0;
  Timer? _timer;

  String? _forgotPasswordMobile;

  GetUserProfileDataModel? _profile;

  GetUserProfileDataModel? get profile => _profile;

  bool _isProfileLoading = false;
  bool _isUpdateLoading = false;

  // ================= GETTERS =================
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;

  bool get otpSent => _otpSent;

  UserModel? get user => _user;

  int get otpTimer => _otpTimer;

  String get forgotPasswordMobile => _forgotPasswordMobile ?? '';

  bool get isLoggedIn => TokenStorage.isLoggedIn;

  bool get isProfileLoading => _isProfileLoading;
  bool get isUpdateLoading => _isUpdateLoading;

  // ✅ Add constructor to initialize TokenStorage
  AuthProvider() {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    await TokenStorage.init();

    final userJson = await TokenStorage.getUserAsync();
    if (userJson != null) {
      _user = UserModel.fromJson(jsonDecode(userJson));
    }

    _isInitialized = true;
    notifyListeners();
  }

  // ========================= Register METHODS ========================= //
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

      debugPrint('User Role: ${_user!.user.role}');

      // ✅ SAVE TOKEN FROM UserModel
      final token = _user!.token;

      if (token.isNotEmpty) {
        debugPrint('💾 Saving token from AuthProvider...');
        await TokenStorage.setToken(token);
        debugPrint('✅ Token saved successfully in AuthProvider');
      } else {
        debugPrint('❌ Token is EMPTY in UserModel');
      }
    } else {
      debugPrint('❌ Login failed: ${response.message}');
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

      debugPrint('User Role: ${_user!.user.role}');

      // ✅ SAVE TOKEN FROM UserModel
      final token = _user!.token;

      if (token.isNotEmpty) {
        debugPrint('💾 Saving token from AuthProvider...');
        await TokenStorage.setToken(token);
        debugPrint('✅ Token saved successfully in AuthProvider');
      } else {
        debugPrint('❌ Token is EMPTY in UserModel');
      }
    } else {
      debugPrint('❌ Login failed: ${response.message}');
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
      debugPrint('User Role: ${_user!.user.role}');

      // ✅ SAVE TOKEN FROM UserModel
      final token = _user!.token;

      if (token.isNotEmpty) {
        debugPrint('💾 Saving token from AuthProvider...');
        await TokenStorage.setToken(token);
        debugPrint('✅ Token saved successfully in AuthProvider');
      } else {
        debugPrint('❌ Token is EMPTY in UserModel');
      }
    } else {
      debugPrint('❌ Login failed: ${response.message}');
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

  // ========================= get profile user data ========================= //
  Future<ApiResponse> getUserProfileData() async {
    if (_isProfileLoading) {
      return ApiResponse(success: false, message: 'Please wait');
    }

    _isProfileLoading = true;
    notifyListeners();

    final response = await AuthService.getUserDataProfile();

    if (response.success && response.data != null) {
      _profile = GetUserProfileDataModel.fromJson(response.data);
      debugPrint('✅ User Profile Data fetched successfully');
    } else {
      debugPrint('❌ Failed to fetch user profile data: ${response.message}');
    }

    _isProfileLoading = false;
    notifyListeners();
    return response;
  }

  // ================= UPDATE PROFILE =================
  Future<ApiResponse> updateUserProfile({
    String? firstName,
    String? lastName,
    String? email,
  }) async {
    if (_isLoading) {
      return ApiResponse(success: false, message: 'Please wait');
    }

    _isProfileLoading = true;
    notifyListeners();

    final response = await AuthService.updateUserDataProfile(
      firstName: firstName,
      lastName: lastName,
      email: email,
    );

    if (response.success && response.data != null) {
      // 🔥 This line was missing in your code
      final updatedUserJson = response.data["user"];
      // ✅ Update local immutable state
      // Update local profile safely
      _profile = _profile?.copyWith(
        data: _profile!.data.copyWith(
          firstName: updatedUserJson["first_name"],
          lastName: updatedUserJson["last_name"],
          email: updatedUserJson["email"],
          profilePhoto: updatedUserJson["profile_photo"],
        ),
      );

      debugPrint('✅ Profile updated successfully');
    } else {
      debugPrint('❌ Update profile failed: ${response.message}');
    }

    _isUpdateLoading = false;
    notifyListeners();
    return response;
  }

  // ================= LOGOUT =================
  Future<void> logout(BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();

      // 🔥 Call logout API
      await AuthService.logout();
    } catch (e) {
      debugPrint('Logout API failed: $e');
    } finally {
      // 🔐 Clear ALL local/session data
      await _clearLocalData();

      _user = null; // 🔥 MISSING LINE (IMPORTANT)
      _otpSent = false; // optional but correct

      _isLoading = false;
      notifyListeners();
      if (context.mounted) {
        context.go(Routes.login);
      }
    }
  }

  // ================= DELETE ACCOUNT =================
  Future<ApiResponse> deleteAccount(BuildContext context) async {
    if (_isLoading) {
      return ApiResponse(success: false, message: 'Please wait');
    }

    _isLoading = true;
    notifyListeners();

    ApiResponse response;

    try {
      // 🔥 Call delete account API
      response = await AuthService.deleteAccount();

      if (response.success) {
        // 🔐 Clear ALL local/session data
        await _clearLocalData();

        _user = null;
        _otpSent = false;

        if (context.mounted) {
          context.go(Routes.login);
        }
      }
    } catch (e) {
      debugPrint('Delete Account API failed: $e');
      response = ApiResponse(success: false, message: e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return response;
  }

  // ================= CLEAR DATA =================
  Future<void> _clearLocalData() async {
    await TokenStorage.clear();
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

    if (_forgotPasswordMobile == null) {
      return ApiResponse(
        success: false,
        message: 'Invalid session. Please restart process.',
      );
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

    if (_forgotPasswordMobile == null) {
      return ApiResponse(
        success: false,
        message: 'Invalid session. Please restart process.',
      );
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
