import 'package:flutter/material.dart';
import 'package:samruddha_kirana/config/router.dart';

void main() {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Samruddha Kirana',
      routerConfig: AppRouter.router,
    );
  }
}
