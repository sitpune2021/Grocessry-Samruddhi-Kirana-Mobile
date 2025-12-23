import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class Loader extends StatelessWidget {
  final double size;
  final double strokeWidth;

  const Loader({super.key, this.size = 40, this.strokeWidth = 3});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          valueColor: const AlwaysStoppedAnimation(AppColors.primary),
        ),
      ),
    );
  }
}
