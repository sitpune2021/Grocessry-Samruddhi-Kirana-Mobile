import 'package:samruddha_kirana/api/api_client.dart';
import 'package:samruddha_kirana/api/api_response.dart';
import 'package:samruddha_kirana/constants/api_constants.dart';

class BannerServices {
  // get Categorise
  static Future<ApiResponse> fetchBanners() async {
    return await ApiClient.get(
      ApiConstants.banners,
      authRequired: true, // 🔐 token based
    );
  }
}
