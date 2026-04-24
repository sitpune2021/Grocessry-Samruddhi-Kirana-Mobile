import 'package:samruddha_kirana/api/api_response.dart';
import 'package:samruddha_kirana/constants/api_constants.dart';
import 'package:samruddha_kirana/api/api_client.dart';
import 'package:samruddha_kirana/storage/storage_helper.dart';

class CouponService {
  // ================= View Coupon & offer =================
  static Future<ApiResponse> fetchAllCoupons() async {
    // ✅ Fetch pincode & warehouseId from local storage
    final warehouseId = await StorageHelper.getWarehouseId();
    final pincode = await StorageHelper.getPincode();

    // ✅ Build extra headers only if values exist
    final extraHeaders = <String, String>{
      if (warehouseId != null) 'warehouse-id': warehouseId.toString(),
      if (pincode != null) 'pincode': pincode,
    };
    return await ApiClient.get(
      ApiConstants.allAvailableCoupons,
      authRequired: true, // 🔐 token based
      extraHeaders: extraHeaders.isNotEmpty ? extraHeaders : null,
    );
  }

  // ================= Apply Coupon & offer =================
  static Future<ApiResponse> applyCoupon({required int id}) async {
    return await ApiClient.post(
      ApiConstants.applyCoupon,
      {"id": id},
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
