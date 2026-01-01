import 'package:flutter/material.dart';

class ArTryOnScreen extends StatelessWidget {
  const ArTryOnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1114), // Match exact background dark 
      body: Center(
        child: InteractiveViewer(
          minScale: 1.0,
          maxScale: 3.0,
          child: Image.asset(
            'assets/ar_dashboard.jpg',
            fit: BoxFit.contain,
            width: double.infinity,
            alignment: Alignment.center,
          ),
        ),
      ),
    );
  }
}
