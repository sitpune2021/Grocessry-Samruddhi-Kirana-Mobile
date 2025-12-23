import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PageTransitions {
  static CustomTransitionPage<T> slide<T>({
    required Widget child,
    required GoRouterState state,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Forward: left → right
        final forwardTween = Tween(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeInOut));

        // Back: right → left
        final backTween = Tween(
          begin: Offset.zero,
          end: const Offset(1, 0),
        ).chain(CurveTween(curve: Curves.easeInOut));

        return SlideTransition(
          position: animation.status == AnimationStatus.reverse
              ? animation.drive(backTween)
              : animation.drive(forwardTween),
          child: child,
        );
      },
    );
  }
}
