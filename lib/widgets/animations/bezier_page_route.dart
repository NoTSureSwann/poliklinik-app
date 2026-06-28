import 'package:flutter/material.dart';

/// Implements Custom Cubic Bezier Curve logic for ultra-smooth UI transitions
class BezierPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  BezierPageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Cubic Bezier curve mimicking a dynamic spring/ease-in-out effect
            const curve = Cubic(0.25, 0.1, 0.25, 1.0);
            
            var tween = Tween(begin: const Offset(0.0, 0.05), end: Offset.zero)
                .chain(CurveTween(curve: curve));
            
            var fadeTween = Tween(begin: 0.0, end: 1.0)
                .chain(CurveTween(curve: curve));

            return FadeTransition(
              opacity: animation.drive(fadeTween),
              child: SlideTransition(
                position: animation.drive(tween),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 600),
          reverseTransitionDuration: const Duration(milliseconds: 600),
        );
}
