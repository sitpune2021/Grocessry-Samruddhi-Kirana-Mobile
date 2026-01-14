import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:samruddha_kirana/config/router.dart';
import 'package:samruddha_kirana/providers/address/address_provider.dart';
import 'package:samruddha_kirana/providers/auth/auth_provider.dart';
import 'package:samruddha_kirana/providers/product_all/all_product_provider.dart';
import 'package:samruddha_kirana/providers/product_brand_provider/product_brand_provider.dart';
import 'package:samruddha_kirana/services/internet_service.dart';

void main() {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Start internet listener globally
  InternetService.initListener();

  debugPrint('🎬 App Starting...');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AllProductProvider()),
        ChangeNotifierProvider(create: (_) => ProductBrandProvider()),
        ChangeNotifierProvider(create: (_) => AddressProvider()),
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
