import 'package:flutter/material.dart';
import 'package:json_to_dart_model/config/app_color.dart';

class AppTheme {
  static ThemeData themeData = ThemeData(
    colorSchemeSeed: AppColor.primaryColor,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primaryColor,
        foregroundColor: Colors.white,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColor.primaryColor,
      foregroundColor: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColor.primaryColor,
      foregroundColor: const Color.fromRGBO(0, 0, 0, 1),
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
  );
}
