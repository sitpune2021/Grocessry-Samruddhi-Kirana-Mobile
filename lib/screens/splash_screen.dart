import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../config/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateBasedOnLoginStatus();
  }

  Future<void> _navigateBasedOnLoginStatus() async {
    await Future.delayed(const Duration(seconds: 3));

    bool isLoggedIn = await _checkLoginStatus();

    if (!mounted) return;

    if (isLoggedIn) {
      // ✅ GoRouter navigation
      context.go(Routes.dashboard);
    } else {
      context.go(Routes.login);
    }
  }

  Future<bool> _checkLoginStatus() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash_screen_bg.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(child: Image.asset("assets/images/rabbi_roots_logo.png")),
      ),
    );
  }
}
