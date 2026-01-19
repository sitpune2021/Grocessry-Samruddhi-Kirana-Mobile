// import 'package:flutter/material.dart';
// import 'package:samruddha_kirana/api/api_response.dart';
// import 'package:samruddha_kirana/models/products/product_model.dart';
// import 'package:samruddha_kirana/services/product_services/cart_service.dart';

// /// CART ACTION RESULT
// enum CartActionResult { success, outOfStock, maxReached, apiError }

// class CartProvider extends ChangeNotifier {
//   // ================= CART STATE =================
//   final Map<int, int> _cartQuantities = {};
//   final Map<int, Product> _productCache = {};

//   Map<int, int> get cartQuantities => _cartQuantities;

//   int get totalItems => _cartQuantities.values.fold(0, (sum, qty) => sum + qty);

//   double get totalPrice {
//     double total = 0;
//     _cartQuantities.forEach((id, qty) {
//       final product = _productCache[id];
//       if (product != null) {
//         total += qty * double.parse(product.retailerPrice);
//       }
//     });
//     return total;
//   }

//   // ================= ADD TO CART =================
//   Future<CartActionResult> addToCart({
//     required int productId,
//     required int stock,
//     required int maxQuantity,
//   }) async {
//     final currentQty = _cartQuantities[productId] ?? 0;

//     // ❌ Out of stock
//     if (stock == 0 || currentQty >= stock) {
//       return CartActionResult.outOfStock;
//     }

//     // ❌ Max quantity reached
//     if (currentQty >= maxQuantity) {
//       return CartActionResult.maxReached;
//     }

//     // 🔗 CALL API (increment by 1)
//     final ApiResponse response = await CartService.addProductInCart(
//       productid: productId.toString(),
//       stock: "1",
//     );

//     if (!response.success) {
//       return CartActionResult.apiError;
//     }

//     // ✅ Update local cart after API success
//     _cartQuantities[productId] = currentQty + 1;
//     notifyListeners();

//     return CartActionResult.success;
//   }

//   // ================= REMOVE FROM CART =================
//   void removeFromCart(int productId) {
//     final currentQty = _cartQuantities[productId] ?? 0;

//     if (currentQty <= 1) {
//       _cartQuantities.remove(productId);
//     } else {
//       _cartQuantities[productId] = currentQty - 1;
//     }

//     notifyListeners();
//   }

//   // ================= CLEAR CART =================
//   void clearCart() {
//     _cartQuantities.clear();
//     notifyListeners();
//   }
// }

import 'package:flutter/material.dart';
import 'package:samruddha_kirana/api/api_response.dart';
import 'package:samruddha_kirana/models/products/product_model.dart';
import 'package:samruddha_kirana/services/product_services/cart_service.dart';

/// CART ACTION RESULT
enum CartActionResult { success, outOfStock, maxReached, apiError }

class CartProvider extends ChangeNotifier {
  // ================= CART STATE =================
  final Map<int, int> _cartQuantities = {};
  final Map<int, Product> _productCache = {};

  Map<int, int> get cartQuantities => _cartQuantities;

  int get totalItems =>
      _cartQuantities.values.fold(0, (sum, qty) => sum + qty);

  double get totalPrice {
    double total = 0;
    _cartQuantities.forEach((id, qty) {
      final product = _productCache[id];
      if (product != null) {
        total += qty * double.parse(product.retailerPrice);
      }
    });
    return total;
  }

  // ================= ADD TO CART =================
  Future<CartActionResult> addToCart({
    required Product product,
  }) async {
    final int productId = product.id;
    final int stock = product.stock;
    final int maxQuantity = product.maxQuantity;

    final currentQty = _cartQuantities[productId] ?? 0;

    // ❌ Out of stock
    if (stock == 0 || currentQty >= stock) {
      return CartActionResult.outOfStock;
    }

    // ❌ Max quantity reached
    if (currentQty >= maxQuantity) {
      return CartActionResult.maxReached;
    }

    // 🔗 CALL API (increment by 1)
    final ApiResponse response = await CartService.addProductInCart(
      productid: productId.toString(),
      stock: "1",
    );

    if (!response.success) {
      return CartActionResult.apiError;
    }

    // ✅ CACHE PRODUCT (IMPORTANT)
    _productCache[productId] = product;

    // ✅ UPDATE QUANTITY
    _cartQuantities[productId] = currentQty + 1;

    notifyListeners();
    return CartActionResult.success;
  }

  // ================= REMOVE FROM CART =================
  void removeFromCart(int productId) {
    final currentQty = _cartQuantities[productId] ?? 0;

    if (currentQty <= 1) {
      _cartQuantities.remove(productId);
      _productCache.remove(productId);
    } else {
      _cartQuantities[productId] = currentQty - 1;
    }

    notifyListeners();
  }

  // ================= CLEAR CART =================
  void clearCart() {
    _cartQuantities.clear();
    _productCache.clear();
    notifyListeners();
  }
}
