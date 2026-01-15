import 'package:flutter/material.dart';

class AnimatedLocationIcon extends StatefulWidget {
  const AnimatedLocationIcon({super.key});

  @override
  State<AnimatedLocationIcon> createState() => _AnimatedLocationIconState();
}

class _AnimatedLocationIconState extends State<AnimatedLocationIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween(
        begin: 1.0,
        end: 1.25,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut)),
      child: const Icon(Icons.my_location, color: Colors.green, size: 20),
    );
  }
}
