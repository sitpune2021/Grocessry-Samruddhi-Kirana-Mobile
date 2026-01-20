import 'package:samruddha_kirana/api/api_client.dart';
import 'package:samruddha_kirana/api/api_response.dart';
import 'package:samruddha_kirana/constants/api_constants.dart';

class OrderService {
  // get new order
  static Future<ApiResponse> fetchNewOrders() async {
    return await ApiClient.get(
      ApiConstants.newOrderList,
      authRequired: true, // 🔐 token based
    );
  }

  // get past order
  static Future<ApiResponse> fetchPastOrders({int page = 1}) async {
    return await ApiClient.get(
      '${ApiConstants.pastOrderList}?page=$page',
      authRequired: true,
    );
  }
}
