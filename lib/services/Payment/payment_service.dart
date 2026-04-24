import 'package:samruddha_kirana/api/api_response.dart';
import 'package:samruddha_kirana/constants/api_constants.dart';
import 'package:samruddha_kirana/api/api_client.dart';

class PaymentService {
  // ================= Create Razorpay Order =================
  static Future<ApiResponse> createPayment({required String orderId}) async {
    return await ApiClient.post(ApiConstants.createRazorpayPaymenr, {
      "order_id": int.parse(orderId),
    }, authRequired: true);
  }

  // ================= Verify Payment =================
  static Future<ApiResponse> verifyPayment({
    // required String orderId,
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  }) async {
    return await ApiClient.post(ApiConstants.verifyRazorpayPayment, {
      "razorpay_order_id": razorpayOrderId,
      "razorpay_payment_id": razorpayPaymentId,
      "razorpay_signature": razorpaySignature,
    }, authRequired: true);
  }

  // ================= Report Payment Failure =================
  static Future<ApiResponse> reportFailure({
    required String razorpayOrderId,
    required String error,
  }) async {
    return await ApiClient.post(ApiConstants.failureRazorpayPayment, {
      "razorpay_order_id": razorpayOrderId,
      "error": error,
    }, authRequired: true);
  }
}
