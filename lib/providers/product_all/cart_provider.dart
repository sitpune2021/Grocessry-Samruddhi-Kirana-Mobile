import 'package:flutter/material.dart';
import 'package:samruddha_kirana/api/api_response.dart';
import 'package:samruddha_kirana/models/cart/cart_view_model.dart';
import 'package:samruddha_kirana/models/cart/checkout_order_model.dart';
import 'package:samruddha_kirana/models/cart/checkout_timer_model.dart';
import 'package:samruddha_kirana/models/payment/payment_option_model.dart';
import 'package:samruddha_kirana/models/products/product_model.dart';
import 'package:samruddha_kirana/services/product_services/cart_service.dart';

enum CartActionResult { success, outOfStock, maxReached, apiError }

class CartProvider extends ChangeNotifier {
  // ================= CART STATE =================
  List<Item> _items = [];
  List<Item> get items => _items;

  // ✅ NEW: COUPONS STATE
  List<Coupon> _coupons = [];
  List<Coupon> get coupons => _coupons;

  // ✅ APPLIED COUPON (NEW 🔥)
  String? _couponCode;
  String? get couponCode => _couponCode;

  int? _couponId;
  int? get couponId => _couponId;

  String _subtotal = "0";
  String _taxTotal = "0";
  String _discount = "0";
  String _total = "0";

  String get subtotal => _subtotal;
  String get taxTotal => _taxTotal;
  String get discount => _discount;
  String get total => _total;

  int get totalItems => _items.fold(0, (sum, item) => sum + item.qty);

  // ================= PAYMENT STATE =================
  List<PaymentOption> _paymentOptions = [];
  List<PaymentOption> get paymentOptions => _paymentOptions;

  bool _isPaymentLoading = false;
  bool get isPaymentLoading => _isPaymentLoading;

  // ================= TIMER STATE =================
  bool _orderAllowed = true;
  String _orderMessage = "";

  bool get orderAllowed => _orderAllowed;
  String get orderMessage => _orderMessage;

  // ================= order confirm =================
  bool _isConfirmingOrder = false;
  bool get isConfirmingOrder => _isConfirmingOrder;

  String _confirmOrderMessage = "";
  String get confirmOrderMessage => _confirmOrderMessage;

  // In CartProvider
  final Set<String> _confirmedOrderIds = {};

  // ================= VIEW CART =================
  Future<void> viewCart() async {
    ApiResponse response = await CartService.viewCart();
    if (!response.success || response.data == null) return;

    final model = ViewCartModel.fromJson(response.data);

    // ✅ ITEMS
    _items = model.data?.items ?? [];

    // ✅ COUPONS (NEW)
    _coupons = model.data?.availableCoupons ?? [];

    // ✅ APPLIED COUPON 🔥
    _couponCode = model.data?.couponCode;
    _couponId = model.data?.couponId;

    // ✅ TOTALS
    _subtotal = model.data?.subtotal ?? "0";
    _taxTotal = model.data?.taxTotal ?? "0";
    _discount = model.data?.discount ?? "0";
    _total = model.data?.total ?? "0";

    notifyListeners();
  }

  // ================= ADD FROM LISTING =================
  Future<CartActionResult> addToCart({required Product product}) async {
    final existing = _items.where((i) => i.product.id == product.id);

    final currentQty = existing.isEmpty ? 0 : existing.first.qty;

    if (product.stock == 0 || currentQty >= product.stock) {
      return CartActionResult.outOfStock;
    }

    if (currentQty >= product.maxQuantity) {
      return CartActionResult.maxReached;
    }

    ApiResponse response;

    if (currentQty == 0) {
      response = await CartService.addProductInCart(
        productid: product.id.toString(),
        stock: "1",
      );
    } else {
      response = await CartService.cartProductIncrment(
        productid: product.id.toString(),
      );
    }

    if (!response.success) return CartActionResult.apiError;

    // 🔥 Always resync from backend
    await viewCart();
    return CartActionResult.success;
  }

  // ================= INCREMENT FROM CART =================
  Future<CartActionResult> incrementFromCart(int productId) async {
    ApiResponse response = await CartService.cartProductIncrment(
      productid: productId.toString(),
    );

    if (!response.success) return CartActionResult.apiError;

    await viewCart();
    return CartActionResult.success;
  }

  // ================= DECREMENT =================
  Future<void> removeFromCart(int productId) async {
    final response = await CartService.cartProductDecrement(
      productid: productId.toString(),
    );

    if (!response.success) return;

    await viewCart();
  }

  // ================= REMOVE SINGLE PRODUCT =================
  Future<void> removeSingleProduct(int productId) async {
    final response = await CartService.cartSingleProductRemove(
      productid: productId.toString(),
    );

    if (!response.success) return;

    await viewCart();
  }

  // ================= PAYMENT OPTIONS =================
  Future<void> fetchPaymentOptions() async {
    _isPaymentLoading = true;
    notifyListeners();

    ApiResponse response = await CartService.getPaymentOptions();

    if (response.success && response.data != null) {
      final model = PaymentOptionModel.fromJson(response.data);

      // only enabled options
      _paymentOptions = model.data.where((option) => option.isEnabled).toList();
    } else {
      _paymentOptions = [];
    }

    _isPaymentLoading = false;
    notifyListeners();
  }

  // ================= CHECKOUT TIMER =================
  Future<void> checkCheckoutTimer() async {
    ApiResponse response = await CartService.cartCheckOutTimer();

    if (!response.success || response.data == null) {
      _orderAllowed = false;
      _orderMessage = "Unable to verify order timing";
      notifyListeners();
      return;
    }

    final model = CheckoutTimerModel.fromJson(response.data);

    _orderAllowed = model.orderAllowed;
    _orderMessage = model.message;

    notifyListeners();
  }

  // ================= CHECKOUT =================
  Future<CheckoutOrderModel?> checkout({
    required String addressId,
    required String paymentOptionCode,
  }) async {
    ApiResponse response = await CartService.cartCheckOut(
      addressid: addressId,
      paymentOptionCode: paymentOptionCode,
    );

    if (!response.success || response.data == null) return null;

    final model = CheckoutOrderModel.fromJson(response.data);

    return model;
  }

  // ================= CONFIRM ORDER =================
  Future<bool> confirmOrder(String orderId) async {
  debugPrint('🔥 confirmOrder called with orderId: $orderId');

  if (_confirmedOrderIds.contains(orderId)) {
    debugPrint('⚠️ Already confirmed — skipping');
    return true;
  }

  _isConfirmingOrder = true;
  _confirmOrderMessage = "";
  notifyListeners();

  ApiResponse response;

  try {
    response = await CartService.confirmOrder(orderId: orderId);
  } catch (e) {
    _isConfirmingOrder = false;
    _confirmOrderMessage = "Network error: $e";
    notifyListeners();
    return false;
  }

  _isConfirmingOrder = false;

  if (!response.success) {
    _confirmOrderMessage =
        response.message.isNotEmpty ? response.message : "Confirm failed";
    notifyListeners();
    return false;
  }

  // ✅ Mark confirmed
  _confirmedOrderIds.add(orderId);

  // ✅ Clear cart immediately
  _clearCartState();
  notifyListeners();

  // ✅ SAFE background refresh (NO CRASH)
  CartService.viewCart().then((res) {
    try {
      if (res.success && res.data != null) {
        // ✅ If API returns full body OR only data — both safe
        final json = res.data is Map && res.data['data'] != null
            ? res.data
            : {'data': res.data};

        final model = ViewCartModel.fromJson(json);

        _items = model.data?.items ?? [];
        _coupons = model.data?.availableCoupons ?? [];
        _couponCode = model.data?.couponCode;
        _couponId = model.data?.couponId;
        _subtotal = model.data?.subtotal ?? "0";
        _taxTotal = model.data?.taxTotal ?? "0";
        _discount = model.data?.discount ?? "0";
        _total = model.data?.total ?? "0";

        notifyListeners();
      } else {
        debugPrint('⚠️ viewCart returned no usable data');
      }
    } catch (e) {
      debugPrint('❌ Cart parsing error: $e');
    }
  });

  _confirmOrderMessage = "Order confirmed successfully";
  notifyListeners();

  return true;
}

  // Future<bool> confirmOrder(String orderId) async {
  //   debugPrint('🔥 confirmOrder called with orderId: $orderId');
  //   debugPrint('🔥 Stack trace: ${StackTrace.current}');

  //   debugPrint('━━━━━━━━━━━━━━ CONFIRM ORDER ━━━━━━━━━━━━━');
  //   debugPrint('📌 orderId       : $orderId');
  //   debugPrint('📌 alreadyDone   : ${_confirmedOrderIds.contains(orderId)}');

  //   // ✅ GUARD: never confirm the same order twice
  //   if (_confirmedOrderIds.contains(orderId)) {
  //     debugPrint('⚠️  Skipping — already confirmed locally');
  //     debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  //     debugPrint("⚠️ Skipping duplicate confirmOrder for $orderId");
  //     return true; // treat as success — it was already confirmed
  //   }

  //   _isConfirmingOrder = true;
  //   _confirmOrderMessage = "";
  //   notifyListeners();

  //   debugPrint('🌐 Calling POST /confirm-order...');

  //   ApiResponse response;

  //   try {
  //     response = await CartService.confirmOrder(orderId: orderId);
  //   } catch (e) {
  //     debugPrint('❌ Network error: $e');
  //     debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  //     // ✅ FIX: catch network/parsing errors
  //     _isConfirmingOrder = false;
  //     _confirmOrderMessage = "Network error: ${e.toString()}";
  //     notifyListeners();
  //     return false;
  //   }

  //   _isConfirmingOrder = false;

  //   debugPrint('📡 Response success : ${response.success}');
  //   debugPrint('📡 Response message : ${response.message}');
  //   debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

  //   if (!response.success) {
  //     // ✅ treat "already confirmed" as success — idempotent
  //     if (response.message.contains("already confirmed")) {
  //       debugPrint('✅ Already confirmed by backend — treating as success');
  //       _confirmedOrderIds.add(orderId);
  //       _clearCartState();
  //       _confirmOrderMessage = "Order confirmed successfully";
  //       notifyListeners();
  //       return true;
  //     }

  //     // ✅ FIX: safely handle null message from ApiResponse
  //     _confirmOrderMessage = response.message.isNotEmpty
  //         ? response.message
  //         : "Order confirmation failed. Please contact support.";
  //     notifyListeners();
  //     return false;
  //   }

  //   debugPrint('✅ Order confirmed successfully');
  //   _confirmedOrderIds.add(orderId); // ✅ mark as confirmed

  //   // ✅ FIX: Clear cart locally FIRST before viewCart()

  //   _clearCartState();

  //   // ✅ Refresh cart in background — do NOT await
  //   // CartService.viewCart().then((res) {
  //   //   if (res.success && res.data != null) {
  //   //     final model = ViewCartModel.fromJson(res.data);
  //   //     _items = model.data?.items ?? [];
  //   //     _coupons = model.data?.availableCoupons ?? [];
  //   //     _couponCode = model.data?.couponCode;
  //   //     _couponId = model.data?.couponId;
  //   //     _subtotal = model.data?.subtotal ?? "0";
  //   //     _taxTotal = model.data?.taxTotal ?? "0";
  //   //     _discount = model.data?.discount ?? "0";
  //   //     _total = model.data?.total ?? "0";
  //   //     notifyListeners();
  //   //   }
  //   // }
  //   CartService.viewCart().then((res) {
  //     try {
  //       if (res.success && res.data != null && res.data['data'] != null) {
  //         final model = ViewCartModel.fromJson(res.data);

  //         _items = model.data?.items ?? [];
  //         _coupons = model.data?.availableCoupons ?? [];
  //         _couponCode = model.data?.couponCode;
  //         _couponId = model.data?.couponId;
  //         _subtotal = model.data?.subtotal ?? "0";
  //         _taxTotal = model.data?.taxTotal ?? "0";
  //         _discount = model.data?.discount ?? "0";
  //         _total = model.data?.total ?? "0";

  //         notifyListeners();
  //       } else {
  //         debugPrint('⚠️ Cart response has no data field — skipping parse');
  //       }
  //     } catch (e) {
  //       debugPrint('❌ Cart parsing error: $e');
  //     }
  //   });

  //   _confirmOrderMessage = "Order confirmed successfully";
  //   notifyListeners();

  //   return true;
  // }

  // // ================= CONFIRM ORDER =================
  // Future<bool> confirmOrder(String orderId) async {
  //   _isConfirmingOrder = true;
  //   _confirmOrderMessage = "";
  //   notifyListeners();

  //   final response = await CartService.confirmOrder(orderId: orderId);
  //   _isConfirmingOrder = false;

  //   if (!response.success) {
  //     _confirmOrderMessage = response.message;
  //     notifyListeners();
  //     return false;
  //   }

  //   // ✅ Refresh cart after confirm
  //   await viewCart();

  //   // ✅ SAFETY: if backend didn't clear, force clear
  //   if (_items.isNotEmpty) {
  //     _items.clear();
  //     _coupons.clear();
  //     _couponCode = null;
  //     _couponId = null;
  //     _subtotal = "0";
  //     _taxTotal = "0";
  //     _discount = "0";
  //     _total = "0";
  //   }

  //   _confirmOrderMessage = "Order confirmed successfully";
  //   notifyListeners();

  //   return true;
  // }

  // ================= CLEAR CART STATE (internal helper) =================
  void _clearCartState() {
    _items.clear();
    _coupons.clear();
    _couponCode = null;
    _couponId = null;
    _subtotal = "0";
    _taxTotal = "0";
    _discount = "0";
    _total = "0";
  }

  // ================= CLEAR FROM BACKEND =================
  Future<void> clearAllFromCart() async {
    final response = await CartService.clearAllProductInCart();

    if (!response.success) return;

    _clearCartState();
    notifyListeners();
  }

  // ================= CLEAR CART LOCALLY (no API call) =================
  void clearCartLocally() {
    _clearCartState();
    notifyListeners();
  }
}
