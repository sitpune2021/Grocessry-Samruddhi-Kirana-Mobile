
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OnboardingPage extends StatefulWidget {
  final String title;
  final String description;
  final String lottie;
  final bool isActive;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.lottie,
    required this.isActive,
  });

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slide;
  late Animation<double> _fade;

  // @override
  // void initState() {
  //   super.initState();

  //   _controller = AnimationController(
  //     vsync: this,
  //     duration: const Duration(milliseconds: 600),
  //   );

  //   // TEXT: UP → DOWN
  //   _slide = Tween<Offset>(
  //     begin: const Offset(0, -0.6),
  //     end: Offset.zero,
  //   ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

  //   // INVISIBLE → VISIBLE
  //   _fade = Tween<double>(
  //     begin: 0,
  //     end: 1,
  //   ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
  // }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, -0.6),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    // ✅ AUTO PLAY animation when page first opens
    if (widget.isActive) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.forward();
      });
    }
  }

  @override
  void didUpdateWidget(covariant OnboardingPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Restart animation when page becomes active
    if (widget.isActive && !oldWidget.isActive) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(widget.lottie, height: 260, repeat: true),

          const SizedBox(height: 30),

          /// TITLE
          FadeTransition(
            opacity: _fade,
            child: SlideTransition(
              position: _slide,
              child: Text(
                widget.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// DESCRIPTION
          FadeTransition(
            opacity: _fade,
            child: SlideTransition(
              position: _slide,
              child: Text(
                widget.description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
