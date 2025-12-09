import 'package:flutter/material.dart';

import '../../core/theme_tokens.dart';

class FloatingAssistantButton extends StatelessWidget {
  const FloatingAssistantButton({
    super.key,
    required this.controller,
    required this.onPressed,
  });

  final AnimationController controller;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final animation = Tween<double>(begin: 0.0, end: -4.0)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(controller);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, animation.value),
          child: child,
        );
      },
      child: Semantics(
        button: true,
        label: 'AI Shopping Assistant',
        child: FloatingActionButton(
          onPressed: onPressed,
          backgroundColor: ThemeTokens.accent,
          elevation: 8,
          shape: const CircleBorder(),
          child: const Icon(Icons.smart_toy_rounded, color: Colors.black),
        ),
      ),
    );
  }
}
