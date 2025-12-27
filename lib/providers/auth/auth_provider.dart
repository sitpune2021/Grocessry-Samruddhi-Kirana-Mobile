import 'package:flutter/material.dart';
import 'package:samruddha_kirana/api/api_response.dart';
import 'package:samruddha_kirana/models/auth/user_model.dart';
import 'package:samruddha_kirana/services/auth/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  UserModel? _user;

  bool get isLoading => _isLoading;
  UserModel? get user => _user;

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
}
