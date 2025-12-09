import 'package:flutter/material.dart';
import '../../../core/theme_tokens.dart';

class AssistantFloatingWidget extends StatefulWidget {
  final VoidCallback onTap;

  const AssistantFloatingWidget({super.key, required this.onTap});

  @override
  State<AssistantFloatingWidget> createState() => _AssistantFloatingWidgetState();
}

class _AssistantFloatingWidgetState extends State<AssistantFloatingWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _controller.repeat(reverse: true);
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16,
      right: 16,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, -5 * _controller.value),
              child: child,
            );
          },
          child: Tooltip(
            message: 'Shopping assistant',
            child: Semantics(
              label: 'Open shopping assistant',
              button: true,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ThemeTokens.secondary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: ThemeTokens.secondary.withValues(alpha: 0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                // Mock Lottie for now since we don't have asset
                child: const Icon(Icons.assistant, color: Colors.white, size: 32),
                // child: Lottie.asset('assets/assistant.json', width: 60, height: 60),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
