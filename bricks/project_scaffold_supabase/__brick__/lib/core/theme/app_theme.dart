import 'package:flutter/material.dart';
import 'theme_colors.dart';
import 'theme_text_styles.dart';

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: ThemeColors.primary,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      
      // AppBar Theme
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      
      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: ThemeTextStyles.buttonText,
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: ThemeTextStyles.buttonText,
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: ThemeTextStyles.buttonText,
        ),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      
      // Text Theme
      textTheme: TextTheme(
        displayLarge: ThemeTextStyles.displayLarge,
        displayMedium: ThemeTextStyles.displayMedium,
        displaySmall: ThemeTextStyles.displaySmall,
        headlineLarge: ThemeTextStyles.headlineLarge,
        headlineMedium: ThemeTextStyles.headlineMedium,
        headlineSmall: ThemeTextStyles.headlineSmall,
        titleLarge: ThemeTextStyles.titleLarge,
        titleMedium: ThemeTextStyles.titleMedium,
        titleSmall: ThemeTextStyles.titleSmall,
        bodyLarge: ThemeTextStyles.bodyLarge,
        bodyMedium: ThemeTextStyles.bodyMedium,
        bodySmall: ThemeTextStyles.bodySmall,
        labelLarge: ThemeTextStyles.labelLarge,
        labelMedium: ThemeTextStyles.labelMedium,
        labelSmall: ThemeTextStyles.labelSmall,
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: ThemeColors.primary,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
      
      // AppBar Theme
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      
      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: ThemeTextStyles.buttonText,
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: ThemeTextStyles.buttonText,
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: ThemeTextStyles.buttonText,
        ),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      
      // Text Theme
      textTheme: TextTheme(
        displayLarge: ThemeTextStyles.displayLarge,
        displayMedium: ThemeTextStyles.displayMedium,
        displaySmall: ThemeTextStyles.displaySmall,
        headlineLarge: ThemeTextStyles.headlineLarge,
        headlineMedium: ThemeTextStyles.headlineMedium,
        headlineSmall: ThemeTextStyles.headlineSmall,
        titleLarge: ThemeTextStyles.titleLarge,
        titleMedium: ThemeTextStyles.titleMedium,
        titleSmall: ThemeTextStyles.titleSmall,
        bodyLarge: ThemeTextStyles.bodyLarge,
        bodyMedium: ThemeTextStyles.bodyMedium,
        bodySmall: ThemeTextStyles.bodySmall,
        labelLarge: ThemeTextStyles.labelLarge,
        labelMedium: ThemeTextStyles.labelMedium,
        labelSmall: ThemeTextStyles.labelSmall,
      ),
    );
  }
}