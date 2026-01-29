import 'package:samruddha_kirana/api/api_response.dart';
import 'package:samruddha_kirana/constants/api_constants.dart';
import 'package:samruddha_kirana/api/api_client.dart';

class CartService {
  // ================= ADD Cart =================
  static Future<ApiResponse> addProductInCart({
    required String productid,
    required String stock,
  }) async {
    return await ApiClient.post(
      ApiConstants.productAddCart,
      {
        "product_id": productid,
        "quantity": stock, // always "1",
      },
      authRequired: true, // 🔐 token based
    );
  }

  // ================= ADD Cart Product Increment =================
  static Future<ApiResponse> cartProductIncrment({
    required String productid,
  }) async {
    return await ApiClient.post(
      ApiConstants.productAddincrement,
      {"product_id": productid},
      authRequired: true, // 🔐 token based
    );
  }

  // ================= ADD Cart Product Decrement =================
  static Future<ApiResponse> cartProductDecrement({
    required String productid,
  }) async {
    return await ApiClient.post(
      ApiConstants.productAddDecrement,
      {"product_id": productid},
      authRequired: true, // 🔐 token based
    );
  }

  // ================= View Cart =================
  static Future<ApiResponse> viewCart() async {
    return await ApiClient.get(
      ApiConstants.viewCart,
      authRequired: true, // 🔐 token based
    );
  }

  // ================= Cart Single Product Remove =================
  static Future<ApiResponse> cartSingleProductRemove({
    required String productid,
  }) async {
    return await ApiClient.delete(
      ApiConstants.removeProductInCart,
      body: {"product_id": productid},
      authRequired: true, // 🔐 token based
    );
  }

  // ================= Clear Cart All Product =================
  static Future<ApiResponse> clearAllProductInCart() async {
    return await ApiClient.delete(
      ApiConstants.clearCart,
      authRequired: true, // 🔐 token based
    );
  }

  // =================== Checkout Cart ========================checkOut
  static Future<ApiResponse> cartCheckOut({required String addressid}) async {
    return await ApiClient.post(
      ApiConstants.checkOut,
      {"address_id": addressid},
      authRequired: true, // 🔐 token based
    );
  }

  // =================== Checkout Timer ========================
  static Future<ApiResponse> cartCheckOutTimer() async {
    return await ApiClient.get(
      ApiConstants.checkOutTimer,
      authRequired: true, // 🔐 token based
    );
  }
}
