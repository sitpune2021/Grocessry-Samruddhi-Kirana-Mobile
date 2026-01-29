import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:samruddha_kirana/config/routes.dart';
import 'package:samruddha_kirana/core/service/app_startup_service.dart';
import 'package:samruddha_kirana/widgets/loader.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Logo
  late Animation<double> _logoScale;

  // App name
  late Animation<Offset> _titleSlide;
  late Animation<double> _titleFade;

  // Feature row
  late Animation<Offset> _featuresSlide;
  late Animation<double> _featuresFade;

  bool _showCenterLoader = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    // Logo hover
    _logoScale = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.25, curve: Curves.easeOut),
      ),
    );

    // App name
    _titleSlide = _slide(0.30, 0.45);
    _titleFade = _fade(0.30, 0.45);

    // Feature row (same animation type, later)
    _featuresSlide = _slide(0.60, 0.80);
    _featuresFade = _fade(0.60, 0.80);

    // Listen when animation completes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _onAnimationCompleted();
      }
    });

    _controller.forward();
  }

  Animation<Offset> _slide(double start, double end) {
    return Tween<Offset>(begin: const Offset(0, 0.6), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(start, end, curve: Curves.easeOut),
      ),
    );
  }

  Animation<double> _fade(double start, double end) {
    return Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(start, end, curve: Curves.easeIn),
      ),
    );
  }

  Future<void> _onAnimationCompleted() async {
    // Show centered loader
    if (mounted) {
      setState(() {
        _showCenterLoader = true;
      });
    }

    // Keep loader for few seconds
    await Future.delayed(const Duration(seconds: 2));

    final state = await AppStartupService.getStartState();
    if (!mounted) return;

    switch (state) {
      case AppStartState.onboarding:
        context.go(Routes.onboarding);
        break;
      case AppStartState.auth:
        context.go(Routes.login);
        break;
      case AppStartState.home:
        context.go(Routes.dashboard);
        break;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          /// BACKGROUND + CONTENT
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/splash_screen_bg.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// LOGO
                ScaleTransition(
                  scale: _logoScale,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image.asset(
                      'assets/images/app_logi.png',
                      height: isTablet ? 160 : 120,
                      width: isTablet ? 160 : 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                /// APP NAME
                FadeTransition(
                  opacity: _titleFade,
                  child: SlideTransition(
                    position: _titleSlide,
                    child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                      ).createShader(bounds),
                      child: const Text(
                        'Samruddha Kirana',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 60),

                /// FEATURES ROW
                FadeTransition(
                  opacity: _featuresFade,
                  child: SlideTransition(
                    position: _featuresSlide,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        _FeatureItem(
                          icon: Icons.local_shipping,
                          text: 'Fast\nDelivery',
                        ),
                        _FeatureItem(
                          icon: Icons.security,
                          text: 'Secure\nPayments',
                        ),
                        _FeatureItem(
                          icon: Icons.verified,
                          text: 'Quality\nProducts',
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 80),

                /// LOADER BELOW FEATURES
                if (_showCenterLoader) const Loader(size: 30, strokeWidth: 3),
              ],
            ),
          ),

        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.blue, size: 22),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.blue,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
