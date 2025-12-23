import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:samruddha_kirana/api/api_response.dart';
import 'package:samruddha_kirana/constants/api_constants.dart';

class ApiClient {
  static const timeout = Duration(seconds: 30);

  // ---------------- GET Method ----------------
  static Future<ApiResponse<dynamic>> get(String endpoint) async {
    try {
      final response = await http
          .get(Uri.parse(ApiConstants.baseUrl + endpoint))
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }

  // ---------------- POST Method ----------------
  static Future<ApiResponse<dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse(ApiConstants.baseUrl + endpoint),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }

  // ---------------- PUT Method ----------------
  static Future<ApiResponse<dynamic>> put(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await http
          .put(
            Uri.parse(ApiConstants.baseUrl + endpoint),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }

  // ---------------- IMAGE UPLOAD ----------------
  static Future<ApiResponse<dynamic>> uploadImage(
    String endpoint,
    File image,
    String fieldName,
  ) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConstants.baseUrl + endpoint),
      );

      request.files.add(
        await http.MultipartFile.fromPath(fieldName, image.path),
      );

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      return _handleResponse(response);
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }

  // ---------------- STATUS HANDLER ----------------
  static ApiResponse<dynamic> _handleResponse(http.Response response) {
    final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

    switch (response.statusCode) {
      case 200:
      case 201:
      case 202:
        return ApiResponse(
          success: true,
          message: body?['message'] ?? 'Success',
          data: body?['data'],
        );

      case 300:
        return ApiResponse(success: false, message: 'Multiple choices');

      case 400:
        return ApiResponse(
          success: false,
          message: body?['message'] ?? 'Bad request',
        );

      case 401:
        return ApiResponse(success: false, message: 'Unauthorized');

      case 500:
      default:
        return ApiResponse(
          success: false,
          message: 'Server error (${response.statusCode})',
        );
    }
  }
}
