import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:samruddha_kirana/api/api_client.dart';
import 'package:samruddha_kirana/api/api_response.dart';
import 'package:samruddha_kirana/api/session/token_storage.dart';
import 'package:samruddha_kirana/constants/api_constants.dart';

/// Refund Item Model
/// =======================
class RefundItem {
  final int productId;
  final int quantity;
  final int reasonId;
  final List<File> images;

  RefundItem({
    required this.productId,
    required this.quantity,
    required this.reasonId,
    required this.images,
  });
}

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

  //get order refund reason
  static Future<ApiResponse> fetchRefundReasons() async {
    return await ApiClient.get(ApiConstants.refundReasons, authRequired: true);
  }

  //get order refund product list
  static Future<ApiResponse> fetchRefundProducts(int orderId) async {
    return await ApiClient.get(
      ApiConstants.orderProductListById(orderId),
      authRequired: true,
    );
  }

  // submit refund request
  static Future<ApiResponse<dynamic>> submitRefundRequest({
    required int orderId,
    required List<RefundItem> items,
  }) async {
    try {
      final url = Uri.parse(
        ApiConstants.baseUrl + ApiConstants.submitRefundRequest,
      );

      final request = http.MultipartRequest('POST', url);

      /// 🔐 Auth header (same token logic as ApiClient)
      if (TokenStorage.token != null) {
        request.headers['Authorization'] = 'Bearer ${TokenStorage.token}';
      }
      request.headers['Accept'] = 'application/json';

      /// Order ID
      request.fields['order_id'] = orderId.toString();

      /// Items (multiple products)
      for (int i = 0; i < items.length; i++) {
        final item = items[i];

        request.fields['items[$i][product_id]'] = item.productId.toString();
        request.fields['items[$i][quantity]'] = item.quantity.toString();
        request.fields['items[$i][reason_id]'] = item.reasonId.toString();

        /// Images per product
        for (final image in item.images) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'items[$i][images][]',
              image.path,
            ),
          );
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      return ApiResponse(
        success: body?['success'] == true || body?['status'] == true,
        message: body?['message'] ?? 'Refund Initiated Successfully',
        data: body,
        code: response.statusCode,
      );
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }
}
