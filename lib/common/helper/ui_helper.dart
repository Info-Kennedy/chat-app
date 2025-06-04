import 'package:flutter/material.dart';
import 'package:chatapp/common/common.dart';
import 'package:logger/logger.dart';

class UiHelper {
  final log = Logger();

  UiHelper();

  ThemeData themeData(String themeMode) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF005CF4),
        primary: const Color(0xFF005CF4),
        brightness: themeMode == Constants.themeConfig.LIGHT ? Brightness.light : Brightness.dark,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
          textStyle: WidgetStateProperty.all(TextStyle(inherit: false, fontWeight: FontWeight.w500, fontFamily: Constants.FONT_POPPINS)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
          textStyle: WidgetStateProperty.all(TextStyle(inherit: false, fontWeight: FontWeight.w500, fontFamily: Constants.FONT_POPPINS)),
        ),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(inherit: true, fontFamily: Constants.FONT_POPPINS),
        bodyMedium: TextStyle(inherit: true, fontFamily: Constants.FONT_POPPINS),
        bodySmall: TextStyle(inherit: true, fontFamily: Constants.FONT_POPPINS),
        labelLarge: TextStyle(inherit: true, fontFamily: Constants.FONT_POPPINS),
        labelMedium: TextStyle(inherit: true, fontFamily: Constants.FONT_POPPINS),
        labelSmall: TextStyle(inherit: true, fontFamily: Constants.FONT_POPPINS),
        titleLarge: TextStyle(inherit: true, fontFamily: Constants.FONT_POPPINS),
        titleMedium: TextStyle(inherit: true, fontFamily: Constants.FONT_POPPINS),
        titleSmall: TextStyle(inherit: true, fontFamily: Constants.FONT_POPPINS),
        headlineLarge: TextStyle(inherit: true, fontFamily: Constants.FONT_POPPINS),
        headlineMedium: TextStyle(inherit: true, fontFamily: Constants.FONT_POPPINS),
        headlineSmall: TextStyle(inherit: true, fontFamily: Constants.FONT_POPPINS),
        displayLarge: TextStyle(inherit: true, fontFamily: Constants.FONT_POPPINS),
        displayMedium: TextStyle(inherit: true, fontFamily: Constants.FONT_POPPINS),
        displaySmall: TextStyle(inherit: true, fontFamily: Constants.FONT_POPPINS),
      ),
    );
  }
}
