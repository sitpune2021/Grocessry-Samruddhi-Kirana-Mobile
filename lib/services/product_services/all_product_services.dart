import 'package:samruddha_kirana/api/api_client.dart';
import 'package:samruddha_kirana/api/api_response.dart';
import 'package:samruddha_kirana/constants/api_constants.dart';

class AllProductServices {
  // get Categorise
  static Future<ApiResponse> fetchCategories() async {
    return await ApiClient.get(
      ApiConstants.categories,
      authRequired: true, // 🔐 token based
    );
  }

  // get Sub Categorise
  static Future<ApiResponse> fetchSubCategories(int categoryId) async {
    return await ApiClient.get(
      ApiConstants.subCategoriesById(categoryId),
      authRequired: true, // 🔐 token based
    );
  }

  // get Products by Sub Category ID
  static Future<ApiResponse> fetchProductsBySubCategoryId(
    int subCategoryId,
  ) async {
    return await ApiClient.get(
      ApiConstants.productsBySubCategoryId(subCategoryId),
      authRequired: true, // 🔐 token based
    );
  }

  // get Product Details by Product ID
  static Future<ApiResponse> fetchProductDetailsById(int productId) async {
    return await ApiClient.get(
      ApiConstants.productDetailsById(productId),
      authRequired: true, // 🔐 token based
    );
  }
}
