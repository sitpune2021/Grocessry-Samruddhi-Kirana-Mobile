import 'package:samruddha_kirana/api/api_client.dart';
import 'package:samruddha_kirana/api/api_response.dart';
import 'package:samruddha_kirana/constants/api_constants.dart';

class AuthService {
  // new user registration
  static Future<ApiResponse> signup({
    required String firstName,
    required String lastName,
    required String mobile,
    String? email,
    required String password,
    required String confirmPassword,
  }) async {
    return await ApiClient.post(ApiConstants.signup, {
      "first_name": firstName,
      "last_name": lastName,
      "mobile": mobile,
      "email": email ?? "",
      "password": password,
      "password_confirmation": confirmPassword,
    });
  }

  // login with password
  static Future<ApiResponse> loginWithPassword({
    required String mobile,
    required String password,
  }) async {
    return await ApiClient.post(ApiConstants.loginWithPassword, {
      "mobile": mobile,
      "password": password,
    });
  }

  // login with OTP
  static Future<ApiResponse> loginWithOtp({required String mobile}) async {
    return await ApiClient.post(ApiConstants.loginWithOtp, {"mobile": mobile});
  }

  // verify login OTP
  static Future<ApiResponse> verifyLoginOtp({
    required String mobile,
    required String otp,
  }) async {
    return await ApiClient.post(ApiConstants.loginVerifyOtp, {
      "mobile": mobile,
      "otp": otp,
    });
  }

  // send forgot password OTP
  static Future<ApiResponse> sendForgotPasswordOtp({
    required String mobile,
  }) async {
    return await ApiClient.post(ApiConstants.sendForgotPasswordOtp, {
      "mobile": mobile,
    });
  }

  // verify forgot password OTP
  static Future<ApiResponse> verifyForgotPasswordOtp({
    required String mobile,
    required String otp,
  }) async {
    return await ApiClient.post(ApiConstants.verifyForgotPasswordOtp, {
      "mobile": mobile,
      "otp": otp,
    });
  }

  // reset password
  static Future<ApiResponse> setNewPassword({
    required String mobile,
    required String newPassword,
    required String confirmPassword,
  }) async {
    return await ApiClient.post(ApiConstants.resetPassword, {
      "mobile": mobile,
      "password": newPassword,
      "password_confirmation": confirmPassword,
    });
  }

  // logout
  static Future<ApiResponse> logout() async {
    return await ApiClient.post(
      ApiConstants.logout,
      {},
      authRequired: true, // 🔐 token based
    );
  }

  // delete account
  static Future<ApiResponse> deleteAccount() async {
    return await ApiClient.delete(
      ApiConstants.deleteAccount,
      authRequired: true, // 🔐 token based
    );
  }

  // get user profile
  static Future<ApiResponse> getUserDataProfile() async {
    return await ApiClient.get(
      ApiConstants.getProfile,
      authRequired: true, // 🔐 token based
    );
  }

  // update user profile
  static Future<ApiResponse> updateUserDataProfile({
    String? firstName,
    String? lastName,
    String? email,
  }) async {
    return await ApiClient.post(
      ApiConstants.updateProfile,
      {
        if (firstName != null) "first_name": firstName,
        if (lastName != null) "last_name": lastName,
        if (email != null) "email": email,
      },
      authRequired: true, // 🔐 token based
    );
  }
}
