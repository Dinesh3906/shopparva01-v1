import 'package:flutter/material.dart';
import 'theme_tokens.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: ThemeTokens.primary,
        secondary: ThemeTokens.secondary,
        background: ThemeTokens.backgroundLight,
        surface: ThemeTokens.surfaceLight,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: ThemeTokens.backgroundLight,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: TextTheme(
        headlineLarge: ThemeTokens.headlineLarge,
        headlineMedium: ThemeTokens.headlineMedium,
        titleLarge: ThemeTokens.titleLarge,
        bodyMedium: ThemeTokens.bodyMedium,
        bodySmall: ThemeTokens.bodySmall,
        labelLarge: ThemeTokens.labelLarge,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: ThemeTokens.surfaceLight,
        elevation: 0,
        titleTextStyle: ThemeTokens.titleLarge.copyWith(color: ThemeTokens.neutral900),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      cardTheme: CardThemeData(
        color: ThemeTokens.surfaceLight,
        elevation: ThemeTokens.elevationMedium,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeTokens.r16),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ThemeTokens.r8),
          ),
          textStyle: ThemeTokens.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeTokens.r8),
        ),
        filled: true,
        fillColor: ThemeTokens.surfaceLight,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: ThemeTokens.primary,
        secondary: ThemeTokens.secondary,
        background: ThemeTokens.backgroundDark,
        surface: ThemeTokens.surfaceDark,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: ThemeTokens.backgroundDark,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: TextTheme(
        headlineLarge: ThemeTokens.headlineLarge.copyWith(color: Colors.white),
        headlineMedium: ThemeTokens.headlineMedium.copyWith(color: Colors.white),
        titleLarge: ThemeTokens.titleLarge.copyWith(color: Colors.white),
        bodyMedium: ThemeTokens.bodyMedium.copyWith(color: Colors.white70),
        bodySmall: ThemeTokens.bodySmall.copyWith(color: Colors.white70),
        labelLarge: ThemeTokens.labelLarge.copyWith(color: Colors.white),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: ThemeTokens.surfaceDark,
        elevation: 0,
        titleTextStyle: ThemeTokens.titleLarge.copyWith(color: Colors.white),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      cardTheme: CardThemeData(
        color: ThemeTokens.surfaceDark,
        elevation: ThemeTokens.elevationMedium,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeTokens.r16),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ThemeTokens.r8),
          ),
          textStyle: ThemeTokens.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
           borderRadius: BorderRadius.circular(ThemeTokens.r8),
        ),
        filled: true,
        fillColor: ThemeTokens.surfaceDark,
      ),
    );
  }

  // High-contrast variants used when accessibility toggle is enabled.
  static ThemeData get highContrastLightTheme {
    final base = lightTheme;
    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: ThemeTokens.primaryHighContrast,
        secondary: ThemeTokens.secondaryHighContrast,
        onPrimary: Colors.black,
        onSecondary: Colors.white,
      ),
      textTheme: base.textTheme.apply(
        fontSizeFactor: 1.05,
        bodyColor: ThemeTokens.neutral900,
        displayColor: ThemeTokens.neutral900,
      ),
    );
  }

  static ThemeData get highContrastDarkTheme {
    final base = darkTheme;
    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: ThemeTokens.primaryHighContrast,
        secondary: ThemeTokens.secondaryHighContrast,
      ),
      textTheme: base.textTheme.apply(
        fontSizeFactor: 1.05,
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
    );
  }
}
