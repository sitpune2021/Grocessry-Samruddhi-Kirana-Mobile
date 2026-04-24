import 'package:samruddha_kirana/api/api_client.dart';
import 'package:samruddha_kirana/api/api_response.dart';
import 'package:samruddha_kirana/constants/api_constants.dart';
import 'package:samruddha_kirana/storage/storage_helper.dart';

class AllProductServices {
  // search Products
  static Future<ApiResponse> searchProducts({
    required String query,
    int page = 1,
  }) async {
    // ✅ Fetch pincode & warehouseId from local storage
    final warehouseId = await StorageHelper.getWarehouseId();
    final pincode = await StorageHelper.getPincode();

    // ✅ Build extra headers only if values exist
    final extraHeaders = <String, String>{
      if (warehouseId != null) 'warehouse-id': warehouseId.toString(),
      if (pincode != null) 'pincode': pincode,
    };
    return await ApiClient.get(
      "${ApiConstants.searchProducts(query)}&page=$page",
      authRequired: true, // 🔐 token based
      extraHeaders: extraHeaders.isNotEmpty ? extraHeaders : null,
    );
  }

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
    // ✅ Fetch pincode & warehouseId from local storage
    final warehouseId = await StorageHelper.getWarehouseId();
    final pincode = await StorageHelper.getPincode();

    // ✅ Build extra headers only if values exist
    final extraHeaders = <String, String>{
      if (warehouseId != null) 'warehouse-id': warehouseId.toString(),
      if (pincode != null) 'pincode': pincode,
    };
    return await ApiClient.get(
      ApiConstants.productsBySubCategoryId(subCategoryId),
      authRequired: true, // 🔐 token based
      extraHeaders: extraHeaders.isNotEmpty ? extraHeaders : null,
    );
  }

  // get Product Details by Product ID
  static Future<ApiResponse> fetchProductDetailsById(int productId) async {
    // ✅ Fetch pincode & warehouseId from local storage
    final warehouseId = await StorageHelper.getWarehouseId();
    final pincode = await StorageHelper.getPincode();

    // ✅ Build extra headers only if values exist
    final extraHeaders = <String, String>{
      if (warehouseId != null) 'warehouse-id': warehouseId.toString(),
      if (pincode != null) 'pincode': pincode,
    };
    return await ApiClient.get(
      ApiConstants.productDetailsById(productId),
      authRequired: true, // 🔐 token based
      extraHeaders: extraHeaders.isNotEmpty ? extraHeaders : null,
    );
  }
}
