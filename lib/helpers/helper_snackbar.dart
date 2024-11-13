import 'package:flutter/material.dart';
import 'package:task_management/constants/app_colors.dart';

class HelperSnackbar {
  static void showSnackBar({
    required BuildContext context,
    required String message,
    Color backgroundColor = AppColors.colorGreen,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }
}
