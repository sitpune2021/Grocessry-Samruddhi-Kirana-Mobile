// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:samruddha_kirana/api/api_response.dart';
import 'package:samruddha_kirana/models/coupon/offer_model.dart';
import 'package:samruddha_kirana/services/coupon/coupon_offer_service.dart';

class CouponProvider extends ChangeNotifier {
  // ================= LOADING =================
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // ================= DATA =================
  List<Coupon> _coupons = [];
  List<Coupon> get coupons => _coupons;

  // ================= ERROR =================
  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // ================= APPLIED COUPON =================
  Coupon? _appliedCoupon;
  Coupon? get appliedCoupon => _appliedCoupon;

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
        final model = CouponModel.fromJson(response.data);
        _coupons = model.coupons;
      } else {
        _coupons = [];
        _errorMessage = response.message;
      }

      return response;
    } catch (e, s) {
      debugPrint('FETCH COUPON ERROR: $e');
      debugPrintStack(stackTrace: s);

      _coupons = [];
      _errorMessage = e.toString();
      response = ApiResponse(success: false, message: _errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return response;
  }

  // ================= APPLY COUPON =================
  Future<ApiResponse> applyCoupon({
    required Coupon coupon,
    required double orderAmount,
  }) async {
    if (_isLoading) {
      return ApiResponse(success: false, message: 'Already loading');
    }

    // 🔥 CENTRAL VALIDATION
    if (orderAmount < coupon.minOrderAmount) {
      return ApiResponse(
        success: false,
        message: "Minimum order ₹${coupon.minOrderAmount.toInt()} required",
      );
    }

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await CouponService.applyCoupon(
        id: coupon.id,
        orderAmount: orderAmount,
      );

      if (response.success && response.data != null) {
        _appliedCoupon = coupon;
        _discountAmount =
            double.tryParse(response.data['discount'].toString()) ?? 0;
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
  void clearCoupons() {
    _coupons = [];
    _appliedCoupon = null;
    _discountAmount = 0;
    _errorMessage = '';
    notifyListeners();
  }
}
