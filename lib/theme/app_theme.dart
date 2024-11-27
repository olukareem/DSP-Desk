import 'package:flutter/material.dart';

class AppTheme {
  static LinearGradient get primaryGradient {
    return LinearGradient(
      colors: [AppColors.gradientStart, AppColors.gradientEnd],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: Color(0xFF1C4A97),
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: Color(0xFF1C4A97),
        secondary: Color(0xFF212429),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Spectral',
          fontSize: 28.0,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1C4A97),
        ),
        displayMedium: TextStyle(
          fontFamily: 'Spectral',
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: Color(0xFF212429),
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 16.0,
          fontWeight: FontWeight.normal,
          color: Color(0xFF212429),
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 14.0,
          fontWeight: FontWeight.normal,
          color: Color(0xFF9C9B9B),
        ),
        labelLarge: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      iconTheme: IconThemeData(
        color: Color(0xFF1C4A97),
        size: 24.0,
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: Color(0xFFFFFFFF),
      ),
      expansionTileTheme: ExpansionTileThemeData(
        backgroundColor: Color(0xFFFFFFFF),
        collapsedIconColor: Color(0xFF1C4A97),
        textColor: Color(0xFF1C4A97),
        collapsedTextColor: Color(0xFF1C4A97),
        iconColor: Color(0xFF1C4A97),
      ),
    );
  }

  // Add missing getters
  static Color get primaryColor => AppColors.primary;
  static Color get secondaryColor => AppColors.secondary;
  static Color get onPrimaryColor => AppColors.white;
  static Color get secondaryLightColor => AppColors.lightGrey;
  static Color get secondaryDarkColor => AppColors.darkGrey;

  static const Color primaryBlue = Color(0xFF1C4A97);
  static const Color secondaryLightBlue = Color(0xFFF1F1FF);
  static const Color inactiveTabTextColor = Color(0xFF667085);

  // Add text styles
  static TextStyle get headline1 => const TextStyle(
        fontFamily: 'Spectral',
        fontSize: 28.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      );

  static TextStyle get tabLabelStyle => const TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      );

  static const TextStyle tabActiveTextStyle = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static const TextStyle tabInactiveTextStyle = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: inactiveTabTextColor,
  );
}

class AppColors {
  static const Color primary = Color(0xFF1C4A97);
  static const Color secondary = Color(0xFF212429);
  static const Color gradientStart = Color(0xFF05756E);
  static const Color gradientEnd = Color(0xFF2EBF91);
  static const Color lightGrey = Color(0xFFE9E9EA);
  static const Color white = Color(0xFFFFFFFF);
  static const Color darkGrey = Color(0xFF9C9B9B);
}
