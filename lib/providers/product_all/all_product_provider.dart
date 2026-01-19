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

  bool _isProductDetailsLoading = false;
  bool get isProductDetailsLoading => _isProductDetailsLoading;

  // ================= SELECTED TAB =================
  int _selectedTab = 0;
  int get selectedTab => _selectedTab;

  // ================= DATA =================
  List<Category> _categories = [];
  List<Category> get categories => _categories;

  List<SubCategories> _subCategories = [];
  List<SubCategories> get subCategories => _subCategories;

  Subcategory? _subcategory;
  Subcategory? get subcategory => _subcategory;

  List<Product> _allProducts = [];
  List<Product> _products = [];
  List<Product> get products => _products;

  ProductDetailsModel? _productDetails;
  ProductDetailsModel? get productDetails => _productDetails;

  // ================= STATE MAPS =================
  final Map<int, bool> _favorites = {};
  Map<int, bool> get favorites => _favorites;

  final Map<int, int> _quantities = {};
  Map<int, int> get quantities => _quantities;

  int get totalCartCount => _quantities.values.fold(0, (sum, qty) => sum + qty);

  // ================= ERROR =================
  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // ================= FETCH CATEGORIES =================
  Future<ApiResponse> fetchCategories() async {
    _isCategoryLoading = true;
    notifyListeners();

    final response = await AllProductServices.fetchCategories();

    if (response.success && response.data != null) {
      final model = CategorieModel.fromJson({
        "status": true,
        "message": response.message,
        "data": response.data['data'],
      });
      _categories = model.data;
    } else {
      _categories = [];
    }

    _isCategoryLoading = false;
    notifyListeners();
    return response;
  }

  // ================= CATEGORY SELECT =================
  void onCategorySelected(int index) {
    _selectedTab = index;

    if (index == 0) {
      clearSubCategories();
      notifyListeners();
      return;
    }

    final categoryId = _categories[index - 1].id;
    fetchSubCategories(categoryId);
  }

  // ================= FETCH SUB CATEGORIES =================
  Future<ApiResponse> fetchSubCategories(int categoryId) async {
    _isSubCategoryLoading = true;
    notifyListeners();

    final response = await AllProductServices.fetchSubCategories(categoryId);

    if (response.success && response.data != null) {
      final model = SubCategorieModel.fromJson({
        "status": true,
        "message": response.message,
        "category_id": categoryId,
        "data": response.data['data'],
      });
      _subCategories = model.data;
    } else {
      _subCategories = [];
    }

    _isSubCategoryLoading = false;
    notifyListeners();
    return response;
  }

  // ================= FETCH PRODUCTS =================
  Future<ApiResponse> fetchProducts(int subCategoryId) async {
    _isProductLoading = true;
    notifyListeners();

    final response = await AllProductServices.fetchProductsBySubCategoryId(
      subCategoryId,
    );

    if (response.success && response.data != null) {
      final model = ProductModel.fromJson(response.data);
      _subcategory = model.subcategory;
      _allProducts = model.data;
      _products = List.from(_allProducts);
    } else {
      _products = [];
    }

    _isProductLoading = false;
    notifyListeners();
    return response;
  }

  // ================= PRODUCT DETAILS (RESTORED) =================
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

  // ================= SEARCH =================
  void searchProducts(String query) {
    if (query.isEmpty) {
      _products = List.from(_allProducts);
    } else {
      _products = _allProducts
          .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  // ================= FAVORITE =================
  void toggleFavorite(int productId) {
    _favorites[productId] = !(_favorites[productId] ?? false);
    notifyListeners();
  }

  // ================= CART =================
  void addToCart(int productId) {
    _quantities[productId] = (_quantities[productId] ?? 0) + 1;
    notifyListeners();
  }

  void removeFromCart(int productId) {
    if ((_quantities[productId] ?? 0) > 0) {
      _quantities[productId] = _quantities[productId]! - 1;
      notifyListeners();
    }
  }

  // ================= CLEAR =================
  void clearSubCategories() {
    _subCategories = [];
  }

  void clearProducts() {
    _products = [];
    _allProducts = [];
    _subcategory = null;
    _favorites.clear();
    _quantities.clear();
    notifyListeners();
  }
}
