// import 'package:flutter/material.dart';
// import '../constants/app_colors.dart';

// class Loader extends StatelessWidget {
//   final double size;
//   final double strokeWidth;

//   const Loader({super.key, this.size = 40, this.strokeWidth = 3});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: SizedBox(
//         height: size,
//         width: size,
//         child: CircularProgressIndicator(
//           strokeWidth: strokeWidth,
//           valueColor: const AlwaysStoppedAnimation(AppColors.progressIndicator),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class Loader extends StatefulWidget {
  final double size;
  final double strokeWidth;

  const Loader({super.key, this.size = 40, this.strokeWidth = 3});

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: widget.size,
        width: widget.size,
        child: RotationTransition(
          turns: _controller,
          child: CircularProgressIndicator(
            strokeWidth: widget.strokeWidth,
            color: AppColors.progressIndicator,
          ),
        ),
      ),
    );
  }
}
