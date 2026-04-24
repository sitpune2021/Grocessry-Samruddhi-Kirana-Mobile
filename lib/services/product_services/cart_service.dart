import 'package:flutter/material.dart';
import 'package:samruddha_kirana/api/api_response.dart';
import 'package:samruddha_kirana/constants/api_constants.dart';
import 'package:samruddha_kirana/api/api_client.dart';
import 'package:samruddha_kirana/storage/storage_helper.dart';

class CartService {
  // ================= ADD Cart =================
  static Future<ApiResponse> addProductInCart({
    required String productid,
    required String stock,
  }) async {
    // ✅ Fetch pincode & warehouseId from local storage
    final warehouseId = await StorageHelper.getWarehouseId();
    final pincode = await StorageHelper.getPincode();

    // ✅ Debug prints
    debugPrint("Warehouse ID: $warehouseId");
    debugPrint("Pincode: $pincode");

    // ✅ Build extra headers only if values exist
    final extraHeaders = <String, String>{
      if (warehouseId != null) 'warehouse-id': warehouseId.toString(),
      if (pincode != null) 'pincode': pincode,
    };

    // ✅ Print full headers also
    debugPrint("Extra Headers: $extraHeaders");

    return await ApiClient.post(
      ApiConstants.productAddCart,
      {
        "product_id": productid,
        "quantity": stock, // always "1",
      },
      authRequired: true, // 🔐 token based
      extraHeaders: extraHeaders.isNotEmpty ? extraHeaders : null,
    );
  }

  // ================= ADD Cart Product Increment =================
  static Future<ApiResponse> cartProductIncrment({
    required String productid,
  }) async {
    // ✅ Fetch pincode & warehouseId from local storage
    final warehouseId = await StorageHelper.getWarehouseId();
    final pincode = await StorageHelper.getPincode();

    // ✅ Debug prints
    debugPrint("Warehouse ID: $warehouseId");
    debugPrint("Pincode: $pincode");

    // ✅ Build extra headers only if values exist
    final extraHeaders = <String, String>{
      if (warehouseId != null) 'warehouse-id': warehouseId.toString(),
      if (pincode != null) 'pincode': pincode,
    };

    // ✅ Print full headers also
    debugPrint("Extra Headers: $extraHeaders");
    return await ApiClient.post(
      ApiConstants.productAddincrement,
      {"product_id": productid},
      authRequired: true, // 🔐 token based
      extraHeaders: extraHeaders.isNotEmpty ? extraHeaders : null,
    );
  }

  // ================= ADD Cart Product Decrement =================
  static Future<ApiResponse> cartProductDecrement({
    required String productid,
  }) async {
    // ✅ Fetch pincode & warehouseId from local storage
    final warehouseId = await StorageHelper.getWarehouseId();
    final pincode = await StorageHelper.getPincode();

    // ✅ Debug prints
    debugPrint("Warehouse ID: $warehouseId");
    debugPrint("Pincode: $pincode");

    // ✅ Build extra headers only if values exist
    final extraHeaders = <String, String>{
      if (warehouseId != null) 'warehouse-id': warehouseId.toString(),
      if (pincode != null) 'pincode': pincode,
    };

    // ✅ Print full headers also
    debugPrint("Extra Headers: $extraHeaders");
    return await ApiClient.post(
      ApiConstants.productAddDecrement,
      {"product_id": productid},
      authRequired: true, // 🔐 token based
      extraHeaders: extraHeaders.isNotEmpty ? extraHeaders : null,
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
    // ✅ Fetch pincode & warehouseId from local storage
    final warehouseId = await StorageHelper.getWarehouseId();
    final pincode = await StorageHelper.getPincode();

    // ✅ Debug prints
    debugPrint("Warehouse ID: $warehouseId");
    debugPrint("Pincode: $pincode");

    // ✅ Build extra headers only if values exist
    final extraHeaders = <String, String>{
      if (warehouseId != null) 'warehouse-id': warehouseId.toString(),
      if (pincode != null) 'pincode': pincode,
    };

    // ✅ Print full headers also
    debugPrint("Extra Headers: $extraHeaders");
    return await ApiClient.delete(
      ApiConstants.clearCart,
      authRequired: true, // 🔐 token based
      extraHeaders: extraHeaders.isNotEmpty ? extraHeaders : null,
    );
  }

  // =================== Checkout Cart ========================checkOut
  static Future<ApiResponse> cartCheckOut({
    required String addressid,
    required String paymentOptionCode,
  }) async {
    // ✅ Fetch pincode & warehouseId from local storage
    final warehouseId = await StorageHelper.getWarehouseId();
    final pincode = await StorageHelper.getPincode();

    // ✅ Build extra headers only if values exist
    final extraHeaders = <String, String>{
      if (warehouseId != null) 'warehouse-id': warehouseId.toString(),
      if (pincode != null) 'pincode': pincode,
    };
    return await ApiClient.post(
      ApiConstants.checkOut,
      {"address_id": addressid, "payment_method": paymentOptionCode},
      authRequired: true, // 🔐 token based
      extraHeaders: extraHeaders.isNotEmpty ? extraHeaders : null,
    );
  }

  // ================= Confirm Order =================
  static Future<ApiResponse> confirmOrder({required String orderId}) async {
    // ✅ Fetch pincode & warehouseId from local storage
    final warehouseId = await StorageHelper.getWarehouseId();
    final pincode = await StorageHelper.getPincode();

    // ✅ Build extra headers only if values exist
    final extraHeaders = <String, String>{
      if (warehouseId != null) 'warehouse-id': warehouseId.toString(),
      if (pincode != null) 'pincode': pincode,
    };
    return await ApiClient.post(
      ApiConstants.confirmOrder,
      {"order_id": orderId},
      authRequired: true, // 🔐 token based
      extraHeaders: extraHeaders.isNotEmpty ? extraHeaders : null,
    );
  }

  // ================= Payment Options =================
  static Future<ApiResponse> getPaymentOptions() async {
    return await ApiClient.get(ApiConstants.paymentOption, authRequired: true);
  }

  // =================== Checkout Timer ========================
  static Future<ApiResponse> cartCheckOutTimer() async {
    return await ApiClient.get(
      ApiConstants.checkOutTimer,
      authRequired: true, // 🔐 token based
    );
  }
}
