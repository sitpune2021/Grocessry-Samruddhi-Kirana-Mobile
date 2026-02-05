// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:samruddha_kirana/api/api_response.dart';
import 'package:samruddha_kirana/models/banner/banner_model.dart';
import 'package:samruddha_kirana/services/product_services/banner_service.dart';

class BannerProvider extends ChangeNotifier {
  // ================= LOADING =================
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // ================= DATA =================
  List<AppBanner> _banners = [];
  List<AppBanner> get banners => _banners;

  // ================= ERROR =================
  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // ================= FETCH BANNERS =================
  Future<ApiResponse> fetchBanners() async {
    if (_isLoading) {
      return ApiResponse(success: false, message: 'Already loading');
    }

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    ApiResponse response;

    try {
      response = await BannerServices.fetchBanners();

      if (response.success && response.data != null) {
        final model = BannerModel.fromJson(response.data);
        _banners = model.data;
      } else {
        _banners = [];
        _errorMessage = response.message;
      }

      return response;
    } catch (e, s) {
      debugPrint('FETCH BANNER ERROR: $e');
      debugPrintStack(stackTrace: s);

      _banners = [];
      _errorMessage = e.toString();
      response = ApiResponse(success: false, message: _errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return response;
  }

  // ================= CLEAR =================
  void clearBanners() {
    _banners = [];
    _errorMessage = '';
    notifyListeners();
  }
}
