class ApiConstants {
  //----------------------------------------------------------------------------
  static const baseUrl = 'http://192.168.1.21:8000/api'; //local url
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  // static const baseUrl = 'https://api.yourapp.in'; // Test url
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  // static const baseUrl = 'https://api.yourapp.com'; //  production url
  //----------------------------------------------------------------------------

  static const signup = '/register';

  static const loginWithPassword = '/login/password';
  static const loginWithOtp = '/login/otp';
  static const loginVerifyOtp = '/verify-otp/login_otp';

  static const sendForgotPasswordOtp = '/forgot-password';
  static const verifyForgotPasswordOtp = '/verify-otp/forgot_password_otp';
  static const resetPassword = '/reset-password';

  static const logout = '/logout';

  static const dashboard = '/dashboard';

  static const addAddress = '/customer/addresses';
  static String updateAddress(int id) => '/customer/addresses/$id';
  static String deleteAddress(int id) => '/customer/addresses/$id';
  static const getAllAddress = '/customer/addresses';

  static const categories = '/categories';
  static String subCategoriesById(int id) => '/categories/$id/subcategories';
  static String productsBySubCategoryId(int id) =>
      '/subcategories/$id/products';
  static String productDetailsById(int id) => '/products/$id';
  static String similarProducts(int id) => '/products/$id/similar';

  static const brands = '/brands';
  static String productsByBrandId(int id) => '/brands/$id/products';

  static const productAddCart = '/cart/add';
  static const viewCart = '/cart';
  static const clearCart = '/cart/clear';
  static const removeProductInCart = '/cart/single/product/remove';

  static const allAvailableCoupons = '/';
  static const applyCoupon = '/';
  static const removeAppliedCoupon = '/';
}
