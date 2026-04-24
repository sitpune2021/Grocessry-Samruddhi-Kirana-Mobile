import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:samruddha_kirana/api/api_response.dart';
import 'package:samruddha_kirana/models/cart/checkout_order_model.dart';
import 'package:samruddha_kirana/models/payment/payment_create_model.dart';
import 'package:samruddha_kirana/models/payment/payment_verify_model.dart';
import 'package:samruddha_kirana/services/Payment/payment_service.dart';

enum PaymentStatus { idle, loading, success, failed }

class PaymentProvider extends ChangeNotifier {
  // ================= RAZORPAY INSTANCE =================
  late Razorpay _razorpay;

  // ================= STATE =================
  PaymentStatus _status = PaymentStatus.idle;
  String _errorMessage = '';
  String _successMessage = '';

  PaymentStatus get status => _status;
  String get errorMessage => _errorMessage;
  String get successMessage => _successMessage;

  bool get isLoading => _status == PaymentStatus.loading;

  // ================= INTERNAL REFS =================
  // Store between API calls (create → verify)
  String? _appOrderId;
  String? _razorpayOrderId;

  // ✅ Guard against Razorpay double-fire
  bool _paymentHandled = false;

  // ✅ Survives Android widget recreation
  CheckoutOrderModel? _pendingOrder;
  CheckoutOrderModel? get pendingOrder => _pendingOrder;

  // void Function(String appOrderId)? onPaymentSuccess;
  // VoidCallback? onPaymentFailed;

  // ================= CALLBACKS =================
  // Called ONLY after verify 200 success + confirmOrder success
  void Function(CheckoutOrderModel order)? onPaymentSuccess;
  // Called on any failure (verify fail, confirmOrder fail, razorpay error)
  void Function(String errorMessage)? onPaymentFailed;

  // ✅ Injected from CartProvider — called internally after verify succeeds
  // Returns true if confirmOrder API returns success
  Future<bool> Function(String orderId)? confirmOrderFn;

  // ================= INIT =================
  PaymentProvider() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  // ================= START PAYMENT =================
  // Call this after your checkout API returns CheckoutOrderModel
  Future<void> startPayment(CheckoutOrderModel checkoutOrder) async {
    _pendingOrder = checkoutOrder; // ✅ store in provider, not widget
    _paymentHandled = false;
    _setLoading();

    // Store app order id for verify call later
    _appOrderId = checkoutOrder.data.orderId.toString();

    // API 2: create razorpay order
    ApiResponse response = await PaymentService.createPayment(
      orderId: _appOrderId!,
    );

    if (!response.success || response.data == null) {
      _pendingOrder = null; // ✅ clear pending order on failure
      _setFailed('Failed to initiate payment. Please try again.');
      onPaymentFailed?.call(_errorMessage);
      return;
    }

    final model = PaymentCreateModel.fromJson(response.data);

    if (!model.success) {
      _pendingOrder = null;

      _setFailed(model.message);
      onPaymentFailed?.call(_errorMessage);
      return;
    }

    _razorpayOrderId = model.razorpayOrderId;

    // Open Razorpay checkout sheet
    try {
      _razorpay.open({
        'key': model.key,
        'amount': model.amount, // already in paise from backend
        'order_id': model.razorpayOrderId,
        'name': 'Samruddha Kirana',
        'description': 'Order #${checkoutOrder.data.orderNumber}',
        'prefill': {
          'contact': '', // optionally pass from user profile provider
          'email': '',
        },
        'theme': {'color': '#3399CC'},
      });
    } catch (e) {
      _pendingOrder = null;

      _setFailed('Could not open payment gateway: $e');
      onPaymentFailed?.call(_errorMessage);
    }
  }

  // ================= RAZORPAY SUCCESS CALLBACK =================
  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // ✅ CRITICAL: block Razorpay double-fire
    if (_paymentHandled) {
      debugPrint('⚠️ Razorpay success fired again — ignoring duplicate');
      return;
    }
    _paymentHandled = true;
    _setLoading();

    debugPrint('✅ Payment success — verifying...');

    // API 3: verify with backend
    // ── STEP 1: Verify payment with backend ──
    ApiResponse verifyResponse = await PaymentService.verifyPayment(
      razorpayOrderId: response.orderId ?? _razorpayOrderId!,
      razorpayPaymentId: response.paymentId!,
      razorpaySignature: response.signature!,
    );

    if (!verifyResponse.success || verifyResponse.data == null) {
      _paymentHandled = false; // ✅ allow retry on verify failure
      _pendingOrder = null;
      _setFailed('Payment received but verification failed. Contact support.');
      onPaymentFailed?.call(_errorMessage);
      return;
    }

    final verifyModel = PaymentVerifyModel.fromJson(verifyResponse.data);

    // ── STEP 2: Only proceed if verify returned success ──
    if (!verifyModel.success) {
      _paymentHandled = false;
      _pendingOrder = null;
      _setFailed(verifyModel.message);
      onPaymentFailed?.call(_errorMessage);
      return;
    }

    debugPrint('✅ Verify success (200 + success:true) — calling confirmOrder');

    // ── STEP 3: Confirm order — ONLY reached when verify is 200 success ──
    final orderId = _appOrderId ?? '';
    bool confirmed = false;

    if (confirmOrderFn != null && orderId.isNotEmpty) {
      confirmed = await confirmOrderFn!(orderId);
    } else {
      debugPrint('⚠️ confirmOrderFn not set — skipping confirmOrder');
    }

    debugPrint('📦 confirmOrder result: $confirmed');

    if (!confirmed) {
      // confirmOrder API failed — treat as payment failure so user sees error
      _paymentHandled = false;
      _pendingOrder = null;
      _setFailed('Order confirmation failed after payment. Contact support.');
      onPaymentFailed?.call(_errorMessage);
      return;
    }

    // ── STEP 4: Everything succeeded — notify UI ──
    final order = _pendingOrder;
    _successMessage = verifyModel.message;
    _status = PaymentStatus.success;
    notifyListeners();

    if (order != null) {
      onPaymentSuccess?.call(order);
    }
  }

  // ================= RAZORPAY ERROR CALLBACK =================
  void _handlePaymentError(PaymentFailureResponse response) async {
    if (_paymentHandled) return; // ✅ guard here too
    _paymentHandled = true;
    final errMsg = response.message ?? 'Payment cancelled or failed';

    // API 4: report failure to backend
    if (_razorpayOrderId != null) {
      await PaymentService.reportFailure(
        razorpayOrderId: _razorpayOrderId!,
        error: errMsg,
      );
    }
    _pendingOrder = null;
    _setFailed(errMsg);
    // ✅ confirmOrder is NEVER called in the error path
    onPaymentFailed?.call(_errorMessage);
  }

  // ================= EXTERNAL WALLET =================
  void _handleExternalWallet(ExternalWalletResponse response) {
    // optional: handle wallet flows if needed
  }

  // ================= RESET (call before new payment) =================
  void resetPayment() {
    _status = PaymentStatus.idle;
    _errorMessage = '';
    _successMessage = '';
    _appOrderId = null;
    _paymentHandled = false;
    _pendingOrder = null; // ✅ cleared here after navigation
    _razorpayOrderId = null;
    notifyListeners();
  }

  // ================= HELPERS =================
  void _setLoading() {
    _status = PaymentStatus.loading;
    _errorMessage = '';
    notifyListeners();
  }

  void _setFailed(String message) {
    _status = PaymentStatus.failed;
    _errorMessage = message;
    notifyListeners();
  }

  // ================= DISPOSE =================
  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }
}
