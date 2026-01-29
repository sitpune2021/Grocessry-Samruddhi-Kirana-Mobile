import 'package:samruddha_kirana/api/api_response.dart';
import 'package:samruddha_kirana/constants/api_constants.dart';
import 'package:samruddha_kirana/api/api_client.dart';

class CouponService {
  // ================= View Coupon & offer =================
  static Future<ApiResponse> fetchAllCoupons() async {
    return await ApiClient.get(
      ApiConstants.allAvailableCoupons,
      authRequired: true, // 🔐 token based
    );
  }

  // ================= Apply Coupon & offer =================
  static Future<ApiResponse> applyCoupon({
    required int id,
    required double orderAmount,
  }) async {
    return await ApiClient.post(
      ApiConstants.applyCoupon,
      {"id": id, "order_amount": orderAmount},
      authRequired: true, // 🔐 token based
    );
  }

  // ================= Remove Applied Coupon & offer =================
  static Future<ApiResponse> removeAppliedCoupon() async {
    return await ApiClient.post(
      ApiConstants.removeAppliedCoupon,
      {},
      authRequired: true, // 🔐 token based
    );
  }
}
