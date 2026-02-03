import 'package:flutter/material.dart';
import 'package:samruddha_kirana/api/api_response.dart';
import 'package:samruddha_kirana/models/brands/brands_list_model.dart';
import 'package:samruddha_kirana/models/brands/product_by_brand_model.dart';
import 'package:samruddha_kirana/services/brand/product_brand_service.dart';

class ProductBrandProvider extends ChangeNotifier {
  // ================= LOADING =================
  bool _isBrandLoading = false;
  bool get isBrandLoading => _isBrandLoading;

  bool _isBrandProductLoading = false;
  bool get isBrandProductLoading => _isBrandProductLoading;

  // ================= BRANDS =================
  List<Brand> _brands = [];
  List<Brand> get brands => _brands;

  // ================= BRAND PRODUCTS =================
  Brands? _selectedBrand;
  Brands? get selectedBrand => _selectedBrand;

  List<Product> _brandProducts = [];
  List<Product> get brandProducts => _brandProducts;

  // ================= ERROR =================
  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // ========================= FETCH BRANDS ========================= //
  Future<ApiResponse> fetchBrands() async {
    if (_isBrandLoading) {
      return ApiResponse(success: false, message: 'Please wait');
    }

    _isBrandLoading = true;
    _errorMessage = '';
    notifyListeners();

    ApiResponse response;

    try {
      response = await ProductBrandService.fetchProductsByBrandId();

      if (response.success && response.data != null) {
        final model = BrandListModel.fromJson({
          "status": true,
          "message": response.message,
          "data": response.data['data'], // ✅ Extract data array
        });

        _brands = model.data;
      } else {
        _brands = [];
        _errorMessage = response.message;
      }
    } catch (e) {
      _brands = [];
      _errorMessage = e.toString();
      response = ApiResponse(success: false, message: _errorMessage);
    } finally {
      _isBrandLoading = false;
      notifyListeners();
    }

    return response;
  }

  // ========================= FETCH PRODUCTS BY BRAND (NEW) ========================= //
  Future<ApiResponse> fetchProductsByBrand(int brandId) async {
    if (_isBrandProductLoading) {
      return ApiResponse(success: false, message: 'Please wait');
    }

    _isBrandProductLoading = true;
    _errorMessage = '';
    notifyListeners();

    ApiResponse response;

    try {
      response = await ProductBrandService.fetchBrandDetailsById(brandId);

      if (response.success && response.data != null) {
        final model = ProductByBrandModel.fromJson({
          "status": true,
          "message": response.message,
          "brand": response.data['brand'],
          "data": response.data['data'],
        });

        _selectedBrand = model.brand;
        _brandProducts = model.data;
      } else {
        _brandProducts = [];
        _selectedBrand = null;
        _errorMessage = response.message;
      }
    } catch (e) {
      _brandProducts = [];
      _selectedBrand = null;
      _errorMessage = e.toString();
      response = ApiResponse(success: false, message: _errorMessage);
    } finally {
      _isBrandProductLoading = false;
      notifyListeners();
    }

    return response;
  }

  // ================= CLEAR BRAND PRODUCTS =================
  void clearBrandProducts() {
    _selectedBrand = null;
    _brandProducts = [];
    _errorMessage = '';
    notifyListeners();
  }
}
