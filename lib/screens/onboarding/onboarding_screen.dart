import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:samruddha_kirana/config/routes.dart';
import 'package:samruddha_kirana/core/service/app_startup_service.dart';

import 'onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<OnboardingPage> _pages = const [
    OnboardingPage(
      title: 'Fresh Groceries',
      description: 'Get fresh groceries delivered to your doorstep.',
      lottie: 'assets/lottie/Grocery Lottie JSON animation.json',
    ),

    OnboardingPage(
      title: 'Fast Delivery',
      description: 'Quick and reliable delivery anytime.',
      lottie: 'assets/lottie/Grocery shopping bag pickup and delivery.json',
    ),
    OnboardingPage(
      title: 'Secure Payments',
      description: 'Safe and trusted payment options.',
      lottie: 'assets/lottie/Grocery Lottie JSON animation.json',
    ),
    OnboardingPage(
      title: 'Quality Products',
      description: 'Only the best products for your family.',
      lottie: 'assets/lottie/Grocery shopping bag pickup and delivery.json',
    ),
  ];

  Future<void> _onContinue() async {
    if (_currentIndex == _pages.length - 1) {
      // Last screen → finish onboarding
      await AppStartupService.setOnboardingSeen();
      if (!mounted) return;
      context.go(Routes.login);
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _currentIndex == _pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            /// TOP RIGHT SKIP
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () async {
                  
                  await AppStartupService.setOnboardingSeen();
                  context.go(Routes.login);
                },
                child: const Text('SKIP'),
              ),
            ),

            /// PAGE VIEW
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                children: _pages,
              ),
            ),

            /// DOT INDICATOR
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.all(4),
                  width: _currentIndex == index ? 14 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentIndex == index ? Colors.blue : Colors.grey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// SINGLE BUTTON (CENTER)
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onContinue,
                  child: Text(isLast ? 'GET STARTED' : 'CONTINUE'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
