class ApiConstants {
  //----------------------------------------------------------------------------
  static const baseUrl = 'http://192.168.1.15:8000/api'; //local url
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

  static const categories = '/categories';
  static String subCategoriesById(int id) => '/categories/$id/subcategories';
  static String productsBySubCategoryId(int id) =>
      '/subcategories/$id/products';
  static String productDetailsById(int id) => '/products/$id';

  static const brands = '/brands';
  static String productsByBrandId(int id) => '/brands/$id/products';
}
