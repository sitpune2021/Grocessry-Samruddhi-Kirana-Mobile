import 'package:flutter/material.dart';

// class AnimatedCartItem extends StatefulWidget {
//   final Widget child;
//   final int index;

//   const AnimatedCartItem({super.key, required this.child, required this.index});

//   @override
//   State<AnimatedCartItem> createState() => AnimatedCartItemState();
// }

// class AnimatedCartItemState extends State<AnimatedCartItem> {
//   bool _visible = false;

//   @override
//   void initState() {
//     super.initState();

//     // stagger delay
//     Future.delayed(Duration(milliseconds: 200 * widget.index), () {
//       if (mounted) {
//         setState(() {
//           _visible = true;
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedSlide(
//       duration: const Duration(milliseconds: 400),
//       curve: Curves.easeOut,
//       offset: _visible ? Offset.zero : const Offset(0, 0.2),
//       child: AnimatedOpacity(
//         duration: const Duration(milliseconds: 400),
//         opacity: _visible ? 1 : 0,
//         child: widget.child,
//       ),
//     );
//   }
// }
class AnimatedCartItem extends StatefulWidget {
  final Widget child;

  const AnimatedCartItem({super.key, required this.child});

  @override
  State<AnimatedCartItem> createState() => _AnimatedCartItemState();
}

class _AnimatedCartItemState extends State<AnimatedCartItem> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    // runs only once in widget lifetime
    Future.microtask(() {
      if (mounted) {
        setState(() => _visible = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      offset: _visible ? Offset.zero : const Offset(0, 0.2),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: _visible ? 1 : 0,
        child: widget.child,
      ),
    );
  }
}
