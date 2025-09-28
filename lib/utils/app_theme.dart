// Заглушка для app_theme.dart

import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFF1E88E5);
  static const Color secondaryColor = Color(0xFF26A69A);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color textColor = Color(0xFF212121);
  static const Color secondaryTextColor = Color(0xFF757575);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color dividerColor = Color(0xFFBDBDBD);
  static const Color successColor = Color(0xFF4CAF50);
  
  // Text styles
  static const TextStyle headlineStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textColor,
  );
  
  static const TextStyle titleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: textColor,
  );
  
  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: textColor,
  );
  
  static const TextStyle bodyStyle = TextStyle(
    fontSize: 14,
    color: textColor,
  );
  
  static const TextStyle captionStyle = TextStyle(
    fontSize: 12,
    color: secondaryTextColor,
  );
  
  // Padding
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  
  // Border radius
  static const double borderRadiusSmall = 4.0;
  static const double borderRadiusMedium = 8.0;
  static const double borderRadiusLarge = 16.0;
  
  // Elevation
  static const double elevationSmall = 1.0;
  static const double elevationMedium = 4.0;
  static const double elevationLarge = 8.0;
  
  // Get theme data
  static ThemeData getTheme() {
    return ThemeData(
      primaryColor: primaryColor,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onError: Colors.white,
        background: backgroundColor,
        surface: cardColor,
        onBackground: textColor,
        onSurface: textColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        elevation: elevationSmall,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        elevation: elevationSmall,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
        ),
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: paddingMedium,
          horizontal: paddingLarge,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: headlineStyle,
        displayMedium: titleStyle,
        displaySmall: subtitleStyle,
        bodyLarge: bodyStyle,
        bodyMedium: bodyStyle,
        labelMedium: captionStyle,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(paddingMedium),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: elevationSmall,
          padding: const EdgeInsets.symmetric(
            vertical: paddingMedium,
            horizontal: paddingLarge,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusMedium),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            vertical: paddingMedium,
            horizontal: paddingLarge,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusMedium),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            vertical: paddingMedium,
            horizontal: paddingLarge,
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: dividerColor,
        thickness: 1.0,
        space: paddingMedium,
      ),
    );
  }
} 