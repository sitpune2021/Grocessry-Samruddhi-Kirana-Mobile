import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:samruddha_kirana/config/router.dart';
import 'package:samruddha_kirana/providers/address/address_provider.dart';
import 'package:samruddha_kirana/providers/address/location_provider.dart';
import 'package:samruddha_kirana/providers/app_version/app_provider.dart';
import 'package:samruddha_kirana/providers/auth/auth_provider.dart';
import 'package:samruddha_kirana/providers/cuppon%20_offer/cuppon_&_offer_provider.dart';
import 'package:samruddha_kirana/providers/orders/banner_provider.dart';
import 'package:samruddha_kirana/providers/orders/order_provider.dart';
import 'package:samruddha_kirana/providers/payment/payment_provider.dart';
import 'package:samruddha_kirana/providers/product_all/all_product_provider.dart';
import 'package:samruddha_kirana/providers/product_all/cart_provider.dart';
import 'package:samruddha_kirana/providers/product_brand_provider/product_brand_provider.dart';
import 'package:samruddha_kirana/services/internet_service.dart';

/// ✅ GLOBAL SCAFFOLD MESSENGER KEY
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Start internet listener globally
  InternetService.initListener();

  debugPrint('🎬 App Starting...');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppInfoProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BannerProvider()),
        ChangeNotifierProvider(create: (_) => AllProductProvider()),
        ChangeNotifierProvider(create: (_) => ProductBrandProvider()),
        ChangeNotifierProvider(create: (_) => AddressProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()..viewCart()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => CouponProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
      ],

      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Samruddha Kirana',

      /// 🔑 ATTACHED HERE
      scaffoldMessengerKey: scaffoldMessengerKey,

      routerConfig: AppRouter.router,

      // ✅ CORRECT for responsive_framework
      builder: (context, child) {
        return ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: const [
            Breakpoint(start: 0, end: 599, name: MOBILE),
            Breakpoint(start: 600, end: 899, name: TABLET),
            Breakpoint(start: 900, end: double.infinity, name: DESKTOP),
          ],
        );
      },
    );
  }
}
