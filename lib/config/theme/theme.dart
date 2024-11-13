import 'package:flutter/material.dart';
import 'package:task_management/constants/app_colors.dart';

class AppTheme {
  static ThemeData getTheme(BuildContext context) {
    return ThemeData(
      colorSchemeSeed: AppColors.colorGreen,
      fontFamily: "poppins",
      textTheme: TextTheme(
          displaySmall: _displaySmallTextStyle(),
          titleSmall: _titleSmallTextStyle()),
      inputDecorationTheme: _inputDecorationTheme(),
      elevatedButtonTheme: _elevatedButtonThemeData(),
      appBarTheme: _appBarTheme(),
      navigationBarTheme: _navigationBarThemeData(),
    );
  }

  static NavigationBarThemeData _navigationBarThemeData() {
    return NavigationBarThemeData(
      indicatorColor: AppColors.colorGreen,
      labelTextStyle:
          WidgetStateProperty.resolveWith<TextStyle>((Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
              color: AppColors.colorGreen, fontWeight: FontWeight.bold);
        }
        return const TextStyle(color: AppColors.colorLightGray);
      }),
      iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
          (Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: Colors.white);
        }
        return const IconThemeData(color: AppColors.colorLightGray);
      }),
    );
  }

  static AppBarTheme _appBarTheme() => const AppBarTheme(toolbarHeight: 80);

  static ElevatedButtonThemeData _elevatedButtonThemeData() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.colorGreen,
        foregroundColor: AppColors.colorWhite,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        fixedSize: const Size.fromWidth(double.maxFinite),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  static InputDecorationTheme _inputDecorationTheme() {
    return InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        fillColor: Colors.white,
        filled: true,
        hintStyle: const TextStyle(color: Colors.grey),
        border: _outlineInputBorder(),
        enabledBorder: _outlineInputBorder(),
        errorBorder: _outlineInputBorder(),
        focusedBorder: _outlineInputBorder());
  }

  static OutlineInputBorder _outlineInputBorder() {
    return OutlineInputBorder(
        borderSide: BorderSide(
            color: AppColors.colorLightGray.withOpacity(0.4), width: 0.5),
        borderRadius: BorderRadius.circular(8));
  }

  static TextStyle _displaySmallTextStyle() {
    return const TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle _titleSmallTextStyle() {
    return const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.colorLightGray);
  }
}
