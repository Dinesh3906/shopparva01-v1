import 'dart:ui';
import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.borderRadius,
    this.blur = 10.0,
    this.opacity = 0.1,
    this.borderOpacity = 0.1,
    this.gradient,
    this.padding,
    this.margin,
    this.onTap,
  });

  final Widget child;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final double blur;
  final double opacity;
  final double borderOpacity;
  final Gradient? gradient;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final br = borderRadius ?? BorderRadius.circular(16);

    Widget container = Container(
      width: width,
      height: height,
      margin: margin,
      child: ClipRRect(
        borderRadius: br,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(opacity),
              borderRadius: br,
              border: Border.all(
                color: Colors.white.withOpacity(borderOpacity),
                width: 1,
              ),
              gradient: gradient ?? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(opacity + 0.05),
                  Colors.white.withOpacity(opacity),
                ],
              ),
            ),
            child: child,
          ),
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: container,
      );
    }

    return container;
  }
}
