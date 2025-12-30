import 'package:flutter/material.dart';
import 'package:samruddha_kirana/api/api_response.dart';
import 'package:samruddha_kirana/models/categories/categories_model.dart';
import 'package:samruddha_kirana/models/products/product_details_model.dart';
import 'package:samruddha_kirana/models/products/product_model.dart';
import 'package:samruddha_kirana/models/sub_categories/sub_categories_model.dart';
import 'package:samruddha_kirana/services/product_services/all_product_services.dart';

class AllProductProvider extends ChangeNotifier {
  // ================= LOADING =================
  bool _isCategoryLoading = false;
  bool get isCategoryLoading => _isCategoryLoading;

  bool _isSubCategoryLoading = false;
  bool get isSubCategoryLoading => _isSubCategoryLoading;

  bool _isProductLoading = false;
  bool get isProductLoading => _isProductLoading;

  // ================= SELECTED TAB =================
  int _selectedTab = 0; // 0 = All
  int get selectedTab => _selectedTab;

  // ================= CATEGORIES =================
  List<Category> _categories = [];
  List<Category> get categories => _categories;

  // ================= SUB CATEGORIES =================
  int _selectedCategoryId = 0;
  int get selectedCategoryId => _selectedCategoryId;

  List<SubCategories> _subCategories = [];
  List<SubCategories> get subCategories => _subCategories;

  // ================= PRODUCTS =================
  Subcategory? _subcategory;
  Subcategory? get subcategory => _subcategory;

  List<Product> _products = [];
  List<Product> get products => _products;

  // ================= FAVORITES (ADDED) =================
  final Map<int, bool> _favorites = {};
  Map<int, bool> get favorites => _favorites;

  // ================= CART QUANTITY (ADDED) =================
  final Map<int, int> _quantities = {};
  Map<int, int> get quantities => _quantities;

  int get totalCartCount => _quantities.values.fold(0, (sum, qty) => sum + qty);

  // ================= PRODUCT DETAILS =================
  ProductDetailsModel? _productDetails;
  ProductDetailsModel? get productDetails => _productDetails;

  bool _isProductDetailsLoading = false;
  bool get isProductDetailsLoading => _isProductDetailsLoading;

  // ================= ERROR =================
  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // ========================= FETCH CATEGORIES ========================= //
  Future<ApiResponse> fetchCategories() async {
    if (_isCategoryLoading) {
      return ApiResponse(success: false, message: 'Please wait');
    }

    _isCategoryLoading = true;
    _errorMessage = '';
    notifyListeners();

    ApiResponse response;

    try {
      response = await AllProductServices.fetchCategories();

      if (response.success && response.data != null) {
        final model = CategorieModel.fromJson({
          "status": true,
          "message": response.message,
          "data": response.data['data'], // ✅ Extract the data array
        });

        _categories = model.data;
      } else {
        _categories = [];
        _errorMessage = response.message;
      }
    } catch (e) {
      _categories = [];
      _errorMessage = e.toString();
      response = ApiResponse(success: false, message: _errorMessage);
    } finally {
      _isCategoryLoading = false;
      notifyListeners();
    }

    return response;
  }

  // ============== CATEGORY TAB CLICK =================
  void onCategorySelected(int index) {
    _selectedTab = index;

    // ALL
    if (index == 0) {
      clearSubCategories();
      notifyListeners();
      return;
    }

    final categoryId = _categories[index - 1].id;
    fetchSubCategories(categoryId);
  }

  // ============== FETCH SUB CATEGORIES ==============
  Future<ApiResponse> fetchSubCategories(int categoryId) async {
    if (_isSubCategoryLoading) {
      return ApiResponse(success: false, message: 'Please wait');
    }

    _isSubCategoryLoading = true;
    _errorMessage = '';
    _selectedCategoryId = categoryId;
    notifyListeners();

    ApiResponse response;

    try {
      response = await AllProductServices.fetchSubCategories(categoryId);

      if (response.success && response.data != null) {
        final model = SubCategorieModel.fromJson({
          "status": true,
          "message": response.message,
          "category_id": categoryId,
          "data": response.data['data'], // ✅ Extract the data array
        });

        _subCategories = model.data;
      } else {
        _subCategories = [];
        _errorMessage = response.message;
      }
    } catch (e) {
      _subCategories = [];
      _errorMessage = e.toString();
      response = ApiResponse(success: false, message: _errorMessage);
    } finally {
      _isSubCategoryLoading = false;
      notifyListeners();
    }

    return response;
  }

  // ================= FETCH PRODUCTS =================
  Future<ApiResponse> fetchProducts(int subCategoryId) async {
    if (_isProductLoading) {
      return ApiResponse(success: false, message: 'Please wait');
    }

    _isProductLoading = true;
    _errorMessage = '';
    // _products = [];
    notifyListeners();

    ApiResponse response;

    try {
      response = await AllProductServices.fetchProductsBySubCategoryId(
        subCategoryId,
      );

      if (response.success && response.data != null) {
        final model = ProductModel.fromJson(response.data);

        _subcategory = model.subcategory;
        _products = model.data;
      } else {
        _products = [];
        _errorMessage = response.message;
      }
    } catch (e) {
      _products = [];
      _errorMessage = e.toString();

      response = ApiResponse(success: false, message: _errorMessage);
    } finally {
      _isProductLoading = false;
      notifyListeners();
    }

    return response;
  }

  // ================== Product Details ===================
  Future<ApiResponse> fetchProductDetails(int productId) async {
    if (_isProductDetailsLoading) {
      return ApiResponse(success: false, message: 'Please wait');
    }

    _isProductDetailsLoading = true;
    _errorMessage = '';
    notifyListeners();

    ApiResponse response;

    try {
      response = await AllProductServices.fetchProductDetailsById(productId);

      if (response.success && response.data != null) {
        _productDetails = ProductDetailsModel.fromJson({
          "status": true,
          "message": response.message,
          "data": response.data['data'],
        });
      } else {
        _productDetails = null;
        _errorMessage = response.message;
      }
    } catch (e) {
      _productDetails = null;
      _errorMessage = e.toString();
      response = ApiResponse(success: false, message: _errorMessage);
    } finally {
      _isProductDetailsLoading = false;
      notifyListeners();
    }
    return response;
  }

  // ================= FAVORITE HANDLERS (ADDED) =================
  void toggleFavorite(int index) {
    _favorites[index] = !(_favorites[index] ?? false);
    notifyListeners();
  }

  // ================= CART HANDLERS (ADDED) =================
  void addToCart(int index) {
    _quantities[index] = (_quantities[index] ?? 0) + 1;
    notifyListeners();
  }

  void removeFromCart(int index) {
    if ((_quantities[index] ?? 0) > 0) {
      _quantities[index] = _quantities[index]! - 1;
      notifyListeners();
    }
  }

  // =================================================
  // ================= CLEAR SUB DATA =================
  // =================================================
  void clearSubCategories() {
    _subCategories = [];
    _selectedCategoryId = 0;
    // notifyListeners();
  }

  void clearProducts() {
    _products = [];
    _subcategory = null;
  }
}
