import 'package:flutter/material.dart';
import 'package:samruddha_kirana/api/api_response.dart';
import 'package:samruddha_kirana/models/cart/cart_view_model.dart';
import 'package:samruddha_kirana/models/cart/checkout_order_model.dart';
import 'package:samruddha_kirana/models/products/product_model.dart';
import 'package:samruddha_kirana/services/product_services/cart_service.dart';

enum CartActionResult { success, outOfStock, maxReached, apiError }

class CartProvider extends ChangeNotifier {
  // ================= CART STATE =================
  List<Item> _items = [];

  List<Item> get items => _items;

  String _subtotal = "0";
  String _taxTotal = "0";
  String _discount = "0";
  String _total = "0";

  String get subtotal => _subtotal;
  String get taxTotal => _taxTotal;
  String get discount => _discount;
  String get total => _total;

  int get totalItems => _items.fold(0, (sum, item) => sum + item.qty);

  // ================= VIEW CART =================
  Future<void> viewCart() async {
    ApiResponse response = await CartService.viewCart();
    if (!response.success || response.data == null) return;

    final model = ViewCartModel.fromJson(response.data);

    _items = model.data?.items ?? [];

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

  // ================= CHECKOUT =================
  Future<CheckoutOrderModel?> checkout({required String addressId}) async {
    ApiResponse response = await CartService.cartCheckOut(addressid: addressId);

    if (!response.success || response.data == null) return null;

    final model = CheckoutOrderModel.fromJson(response.data);

    // clear cart
    _items.clear();
    _subtotal = "0";
    _taxTotal = "0";
    _discount = "0";
    _total = "0";
    notifyListeners();

    return model;
  }

  // ================= CLEAR FROM BACKEND =================
  Future<void> clearAllFromCart() async {
    final response = await CartService.clearAllProductInCart();

    if (!response.success) return;

    // sync local state
    _items.clear();
    _subtotal = "0";
    _taxTotal = "0";
    _discount = "0";
    _total = "0";
    notifyListeners();
  }

  // // ================= CLEAR =================
  // void clearCart() {
  //   _items.clear();
  //   _subtotal = "0";
  //   _taxTotal = "0";
  //   _discount = "0";
  //   _total = "0";
  //   notifyListeners();
  // }
}
