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
}
