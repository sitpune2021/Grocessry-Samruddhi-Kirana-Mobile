class ApiConstants {
  //----------------------------------------------------------------------------
  static const baseUrl = 'http://192.168.1.66:8000/api'; //local url
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

  static const getProfile = '/user/profile';
  static const updateProfile = '/customer/update-profile';

  static const logout = '/logout';
  static const deleteAccount = '/user/account';

  static const dashboard = '/dashboard';

  static const addAddress = '/customer/addresses';
  static String updateAddress(int id) => '/customer/addresses/$id';
  static String deleteAddress(int id) => '/customer/addresses/$id';
  static const getAllAddress = '/customer/addresses';
  static const defultAddress = '/user/address/set-default';

  static const categories = '/categories';
  static String subCategoriesById(int id) => '/categories/$id/subcategories';
  static String productsBySubCategoryId(int id) =>
      '/subcategories/$id/products';
  static String productDetailsById(int id) => '/products/$id';

  static String similarProducts(int id) => '/products/$id/similar';

  static const brands = '/brands';
  static String productsByBrandId(int id) => '/brands/$id/products';

  static const productAddCart = '/cart/add';
  static const productAddincrement = '/cart/increment';
  static const productAddDecrement = '/cart/decrement';
  static const viewCart = '/cart';
  static const clearCart = '/cart/clear';
  static const removeProductInCart = '/cart/remove';

  static const checkOut = '/cart/checkout';
  static const checkOutTimer = '/customer/order-time-check';

  static const allAvailableCoupons = '/offers';
  static const applyCoupon = '/apply-offer';
  static const removeAppliedCoupon = '/remove-offer';

  static const newOrderList = '/orders/new-order';
  static const pastOrderList = '/orders/history';
}
