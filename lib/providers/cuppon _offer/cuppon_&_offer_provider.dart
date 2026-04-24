// // ignore_for_file: file_names

// import 'package:flutter/material.dart';
// import 'package:samruddha_kirana/api/api_response.dart';
// import 'package:samruddha_kirana/models/coupon/offers_model.dart';
// import 'package:samruddha_kirana/services/coupon/coupon_offer_service.dart';

// class CouponProvider extends ChangeNotifier {
//   // ================= LOADING =================
//   bool _isLoading = false;
//   bool get isLoading => _isLoading;

//   // ================= DATA =================
//   List<Datum> _offers = [];
//   List<Datum> get offers => _offers;

//   // ================= ERROR =================
//   String _errorMessage = '';
//   String get errorMessage => _errorMessage;

//   // ================= APPLIED COUPON =================
//   Datum? _appliedCoupon;
//   Datum? get appliedCoupon => _appliedCoupon;

//   double _discountAmount = 0;
//   double get discountAmount => _discountAmount;

//   // ================= FETCH COUPONS =================
//   Future<ApiResponse> fetchAllCoupons() async {
//     if (_isLoading) {
//       return ApiResponse(success: false, message: 'Already loading');
//     }

//     _isLoading = true;
//     _errorMessage = '';
//     notifyListeners();

//     ApiResponse response;

//     try {
//       response = await CouponService.fetchAllCoupons();

//       if (response.success && response.data != null) {
//         final model = OfferModel.fromJson(response.data);
//         _offers = model.data;
//       } else {
//         _offers = [];
//         _errorMessage = response.message;
//       }
//       return response;
//     } catch (e, s) {
//       debugPrint('FETCH COUPON ERROR: $e');
//       debugPrintStack(stackTrace: s);
//       _offers = [];
//       _errorMessage = e.toString();
//       response = ApiResponse(success: false, message: _errorMessage);
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }

//     return response;
//   }

//   // ================= APPLY COUPON =================
//   Future<ApiResponse> applyCoupon({required Datum coupon}) async {
//     // /// 🚫 BLOCK SAME COUPON
//     // if (_appliedCoupon?.code == coupon.code) {
//     //   return ApiResponse(success: false, message: "Coupon already applied");
//     // }

//      /// 🔒 HARD BLOCK — provider is single source of truth for applied state
//     if (_appliedCoupon != null) {
//       final msg = _appliedCoupon?.code == coupon.code
//           ? "This coupon is already applied"
//           : "Remove current coupon before applying another";

//       debugPrint('>>> BLOCK: $_msg | appliedCoupon=${_appliedCoupon?.code}');
//       return ApiResponse(success: false, message: msg);
//     }

//     if (_isLoading) {
//       return ApiResponse(success: false, message: 'Already loading');
//     }

//     _isLoading = true;
//     _errorMessage = '';
//     notifyListeners();

//     try {
//       final response = await CouponService.applyCoupon(id: coupon.id);

//       if (response.success && response.data != null) {
//         _appliedCoupon = coupon;
//         _discountAmount =
//             double.tryParse(response.data['discount'].toString()) ?? 0;
//       } else {
//         _errorMessage = response.message;
//       }

//       return response;
//     } catch (e) {
//       _errorMessage = e.toString();
//       return ApiResponse(success: false, message: _errorMessage);
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   // ================= REMOVE COUPON =================
//   Future<ApiResponse> removeCoupon() async {
//     if (_isLoading) {
//       return ApiResponse(success: false, message: 'Already loading');
//     }

//     _isLoading = true;
//     notifyListeners();

//     try {
//       final response = await CouponService.removeAppliedCoupon();

//       if (response.success) {
//         _appliedCoupon = null;
//         _discountAmount = 0;
//       } else {
//         _errorMessage = response.message;
//       }

//       return response;
//     } catch (e) {
//       _errorMessage = e.toString();
//       return ApiResponse(success: false, message: _errorMessage);
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   // ================= CLEAR ALL =================
//   void clearCoupons() {
//     // _coupons = [];
//     _offers = [];
//     _appliedCoupon = null;
//     _discountAmount = 0;
//     _errorMessage = '';
//     notifyListeners();
//   }
// }
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:samruddha_kirana/api/api_response.dart';
import 'package:samruddha_kirana/models/coupon/offers_model.dart';
import 'package:samruddha_kirana/services/coupon/coupon_offer_service.dart';

class CouponProvider extends ChangeNotifier {
  // ================= LOADING =================
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // ================= DATA =================
  List<Datum> _offers = [];
  List<Datum> get offers => _offers;

  // ================= ERROR =================
  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // ================= APPLIED COUPON =================
  Datum? _appliedCoupon;
  Datum? get appliedCoupon => _appliedCoupon;

  double _discountAmount = 0;
  double get discountAmount => _discountAmount;

  // ================= FETCH COUPONS =================
  Future<ApiResponse> fetchAllCoupons() async {
    if (_isLoading) {
      return ApiResponse(success: false, message: 'Already loading');
    }

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    ApiResponse response;

    try {
      response = await CouponService.fetchAllCoupons();

      if (response.success && response.data != null) {
        final model = OfferModel.fromJson(response.data);
        _offers = model.data;
      } else {
        _offers = [];
        _errorMessage = response.message;
      }
      return response;
    } catch (e, s) {
      debugPrint('FETCH COUPON ERROR: $e');
      debugPrintStack(stackTrace: s);
      _offers = [];
      _errorMessage = e.toString();
      response = ApiResponse(success: false, message: _errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return response;
  }

  // ================= APPLY COUPON =================
  Future<ApiResponse> applyCoupon({required Datum coupon}) async {
    /// 🔒 HARD BLOCK — provider is single source of truth for applied state
    if (_appliedCoupon != null) {
      final msg = _appliedCoupon?.code == coupon.code
          ? "This coupon is already applied"
          : "Remove current coupon before applying another";

      debugPrint('>>> BLOCK: $msg | appliedCoupon=${_appliedCoupon?.code}');
      return ApiResponse(success: false, message: msg);
    }

    if (_isLoading) {
      return ApiResponse(success: false, message: 'Already loading');
    }

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await CouponService.applyCoupon(id: coupon.id);

      if (response.success && response.data != null) {
        _appliedCoupon = coupon; // ✅ set applied coupon on success
        _discountAmount =
            double.tryParse(response.data['discount'].toString()) ?? 0;
        debugPrint('>>> APPLIED: ${_appliedCoupon?.code}');
      } else {
        _errorMessage = response.message;
      }

      return response;
    } catch (e) {
      _errorMessage = e.toString();
      return ApiResponse(success: false, message: _errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ================= REMOVE COUPON =================
  Future<ApiResponse> removeCoupon() async {
    if (_isLoading) {
      return ApiResponse(success: false, message: 'Already loading');
    }

    _isLoading = true;
    notifyListeners();

    try {
      final response = await CouponService.removeAppliedCoupon();

      if (response.success) {
        _appliedCoupon = null;
        _discountAmount = 0;
        debugPrint('>>> COUPON REMOVED');
      } else {
        _errorMessage = response.message;
      }

      return response;
    } catch (e) {
      _errorMessage = e.toString();
      return ApiResponse(success: false, message: _errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ================= CLEAR ALL =================
  // ⚠️ Only call this on LOGOUT — never on screen dispose or cart refresh
  void clearCoupons() {
    _offers = [];
    _appliedCoupon = null;
    _discountAmount = 0;
    _errorMessage = '';
    notifyListeners();
    debugPrint('>>> clearCoupons() called — appliedCoupon wiped');
  }
}
