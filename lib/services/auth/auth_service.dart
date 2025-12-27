import 'package:samruddha_kirana/api/api_client.dart';
import 'package:samruddha_kirana/api/api_response.dart';
import 'package:samruddha_kirana/constants/api_constants.dart';

class AuthService {
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
}
