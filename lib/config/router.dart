import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:samruddha_kirana/models/address/get_all_address_model.dart';
import 'package:samruddha_kirana/models/cart/checkout_order_model.dart';
import 'package:samruddha_kirana/models/orders/new_order_list_model.dart';
import 'package:samruddha_kirana/screens/address/add_address_screen.dart';
import 'package:samruddha_kirana/screens/address/address_list_screen.dart';
import 'package:samruddha_kirana/screens/auth/password_manage/forgot_password.dart';
import 'package:samruddha_kirana/screens/auth/password_manage/set_password.dart';
import 'package:samruddha_kirana/screens/auth/sign_up_screen.dart';
import 'package:samruddha_kirana/screens/brand/brand_list_details_screen.dart';
import 'package:samruddha_kirana/screens/cart/coupones/offers_promo_screen.dart';
import 'package:samruddha_kirana/screens/cart/new_cart_screen.dart';
import 'package:samruddha_kirana/screens/cart/order_confirmation_screen.dart';
import 'package:samruddha_kirana/screens/home/dashboard.dart';
import 'package:samruddha_kirana/screens/auth/sign_in_screen.dart';
import 'package:samruddha_kirana/screens/onboarding/onboarding_screen.dart';
import 'package:samruddha_kirana/screens/orders/order_details_screen.dart';
import 'package:samruddha_kirana/screens/orders/orders_screen.dart';
import 'package:samruddha_kirana/screens/product/product_details_screen.dart';
import 'package:samruddha_kirana/screens/product/product_list_screen.dart';
import 'package:samruddha_kirana/screens/profile/update_profile/update_profile_screen.dart';
import 'package:samruddha_kirana/screens/splash/splash_screen.dart';
import 'package:samruddha_kirana/widgets/no_internet_view.dart';

import 'routes.dart';
import 'page_transition.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: Routes.splash,
    routes: [
      GoRoute(
        path: Routes.splash,
        pageBuilder: (context, state) =>
            PageTransitions.slide(state: state, child: const SplashScreen()),
      ),
      GoRoute(
        path: Routes.noInternet,
        pageBuilder: (context, state) =>
            PageTransitions.slide(state: state, child: const NoInternetView()),
      ),
      GoRoute(
        path: Routes.onboarding,
        pageBuilder: (context, state) => PageTransitions.slide(
          state: state,
          child: const OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: Routes.login,
        pageBuilder: (context, state) =>
            PageTransitions.slide(state: state, child: const SignInScreen()),
      ),
      GoRoute(
        path: Routes.signup,
        pageBuilder: (context, state) =>
            PageTransitions.slide(state: state, child: const SignUpScreen()),
      ),
      GoRoute(
        path: Routes.forgotPassword,
        pageBuilder: (context, state) => PageTransitions.slide(
          state: state,
          child: const ForgotPasswordScreen(),
        ),
      ),
      GoRoute(
        path: Routes.setPassword,
        pageBuilder: (context, state) => PageTransitions.slide(
          state: state,
          child: const SetPasswordScreen(),
        ),
      ),
      GoRoute(
        path: Routes.dashboard,
        pageBuilder: (context, state) =>
            PageTransitions.slide(state: state, child: const DashboardScreen()),
      ),
      GoRoute(
        path: Routes.updateProfile,
        pageBuilder: (context, state) => PageTransitions.slide(
          state: state,
          child: const UpdateProfileScreen(),
        ),
      ),
      GoRoute(
        path: Routes.getAddress,
        pageBuilder: (context, state) => PageTransitions.slide(
          state: state,
          child: const ManageAddressesScreen(),
        ),
      ),
      GoRoute(
        path: Routes.addAddress,
        pageBuilder: (context, state) => PageTransitions.slide(
          state: state,
          child: AddAddressScreen(address: state.extra as GetAddress?),
        ),
      ),
      // GoRoute(
      //   path: Routes.product,
      //   pageBuilder: (context, state) => PageTransitions.slide(
      //     state: state,
      //     child: const ProductsListScreen(),
      //   ),
      // ),
      GoRoute(
        path: Routes.product,
        pageBuilder: (context, state) {
          final subCategoryId = state.extra as int;

          return PageTransitions.slide(
            state: state,
            child: ProductsListScreen(
              key: ValueKey(subCategoryId), // ⭐ VERY IMPORTANT
            ),
          );
        },
      ),

      GoRoute(
        path: Routes.productDetails,
        pageBuilder: (context, state) {
          final productId = state.extra as int;

          return PageTransitions.slide(
            state: state,
            child: ProductDetailsScreen(productId: productId),
          );
        },
      ),
      GoRoute(
        path: Routes.brandListDetails,
        pageBuilder: (context, state) => PageTransitions.slide(
          state: state,
          child: const BrandProductsListScreen(),
        ),
      ),
      GoRoute(
        path: Routes.newcart,
        pageBuilder: (context, state) =>
            PageTransitions.slide(state: state, child: const NewCartScreen()),
      ),
      GoRoute(
        path: Routes.order,
        pageBuilder: (context, state) =>
            PageTransitions.slide(state: state, child: const OrdersScreen()),
      ),
      GoRoute(
        path: Routes.orderDetails,
        pageBuilder: (context, state) {
          final order = state.extra as OrdersData?;
          return PageTransitions.slide(
            state: state,
            child: OrderDetailsScreen(order: order),
          );
        },
      ),

      GoRoute(
        path: Routes.couponOffer,
        pageBuilder: (context, state) {
          final double subtotal = state.extra as double;

          return PageTransitions.slide(
            state: state,
            child: OffersPromoScreen(subtotal: subtotal),
          );
        },
      ),

      // OrderConfirmationScreen
      GoRoute(
        path: Routes.checkoutOrder,
        pageBuilder: (context, state) {
          final order = state.extra as CheckoutOrderModel;
          return PageTransitions.slide(
            state: state,
            child: OrderConfirmationScreen(order: order),
          );
        },
      ),
    ],
  );
}
