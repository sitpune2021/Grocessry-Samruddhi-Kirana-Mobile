// // import 'package:flutter/material.dart';

// // class OnboardingPage extends StatelessWidget {
// //   final String title;
// //   final String description;
// //   final String image;

// //   const OnboardingPage({
// //     super.key,
// //     required this.title,
// //     required this.description,
// //     required this.image,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.all(24),
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           Image.asset(image, height: 220),
// //           const SizedBox(height: 30),
// //           Text(
// //             title,
// //             textAlign: TextAlign.center,
// //             style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
// //           ),
// //           const SizedBox(height: 12),
// //           Text(
// //             description,
// //             textAlign: TextAlign.center,
// //             style: const TextStyle(fontSize: 16, color: Colors.grey),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';

// class OnboardingPage extends StatelessWidget {
//   final String title;
//   final String description;
//   final String lottie;

//   const OnboardingPage({
//     super.key,
//     required this.title,
//     required this.description,
//     required this.lottie,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(24),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Lottie.asset(lottie, height: 260, repeat: true),
//           const SizedBox(height: 30),
//           Text(
//             title,
//             textAlign: TextAlign.center,
//             style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             description,
//             textAlign: TextAlign.center,
//             style: const TextStyle(fontSize: 16, color: Colors.grey),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OnboardingPage extends StatefulWidget {
  final String title;
  final String description;
  final String lottie;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.lottie,
  });

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slide;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // 🔽 Text comes from top to center (UP → DOWN)
    _slide = Tween<Offset>(
      begin: const Offset(0, -0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
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

          /// TITLE (animated)
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

          /// DESCRIPTION (animated)
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
