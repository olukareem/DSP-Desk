import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      primaryColor: const Color(0xFF1C4A97),
      scaffoldBackgroundColor: Colors.white,
      inputDecorationTheme: inputDecorationTheme,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: const Color(0xFF1C4A97),
        secondary: const Color(0xFF212429),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.spectral(
          textStyle: const TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1C4A97),
          ),
        ),
        displayMedium: GoogleFonts.spectral(
          textStyle: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212429),
          ),
        ),
        bodyLarge: GoogleFonts.montserrat(
          textStyle: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.normal,
            color: Color(0xFF212429),
          ),
        ),
        bodyMedium: GoogleFonts.montserrat(
          textStyle: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.normal,
            color: Color(0xFF9C9B9B),
          ),
        ),
        labelLarge: GoogleFonts.montserrat(
          textStyle: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      iconTheme: const IconThemeData(
        color: Color(0xFF1C4A97),
        size: 24.0,
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: Color(0xFFFFFFFF),
      ),
      expansionTileTheme: const ExpansionTileThemeData(
        backgroundColor: Color(0xFFFFFFFF),
        collapsedIconColor: Color(0xFF1C4A97),
        textColor: Color(0xFF1C4A97),
        collapsedTextColor: Color(0xFF1C4A97),
        iconColor: Color(0xFF1C4A97),
      ),
    );
  }

  static Color get primaryColor => AppColors.primary;
  static Color get secondaryColor => AppColors.secondary;
  static Color get onPrimaryColor => AppColors.white;
  static Color get secondaryLightColor => AppColors.lightGrey;
  static Color get secondaryDarkColor => AppColors.darkGrey;

  static const Color primaryBlue = Color(0xFF1C4A97);
  static const Color secondaryLightBlue = Color(0xFFF1F1FF);
  static const Color inactiveTabTextColor = Color(0xFF667085);

  // Add text styles using Google Fonts
  static TextStyle get headline1 => GoogleFonts.spectral(
        textStyle: const TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );

  static TextStyle get tabLabelStyle => GoogleFonts.montserrat(
        textStyle: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
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

  static InputDecorationTheme get inputDecorationTheme {
    return InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 12.0,
        horizontal: 14.0,
      ),
      hintStyle: GoogleFonts.montserrat(
        textStyle: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
          height: 1.71,
          color: Color.fromRGBO(160, 163, 189, 1),
        ),
      ),
      border: _defaultInputBorder,
      enabledBorder: _defaultInputBorder,
      focusedBorder: _defaultInputBorder,
      errorBorder: _defaultInputBorder.copyWith(
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: _defaultInputBorder.copyWith(
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }

  static final OutlineInputBorder _defaultInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(4),
    borderSide: const BorderSide(
      color: Color.fromRGBO(208, 213, 221, 1),
      width: 1.0,
    ),
  );

  static TextStyle get inputTextStyle => GoogleFonts.montserrat(
        textStyle: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
          height: 1.71,
          color: Colors.black,
        ),
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
