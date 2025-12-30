import 'package:samruddha_kirana/api/api_client.dart';
import 'package:samruddha_kirana/api/api_response.dart';
import 'package:samruddha_kirana/constants/api_constants.dart';

class ProductBrandService {
  // fetch Brand
  static Future<ApiResponse> fetchProductsByBrandId() async {
    return await ApiClient.get(
      ApiConstants.brands,
      authRequired: true, // 🔐 token based
    );
  }

  // fetch product id brand details
  static Future<ApiResponse> fetchBrandDetailsById(int brandId) async {
    return await ApiClient.get(
      ApiConstants.productsByBrandId(brandId),
      authRequired: true, // 🔐 token based
    );
  }
}
