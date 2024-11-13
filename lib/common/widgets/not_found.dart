import 'package:flutter/material.dart';
import 'package:task_management/constants/app_colors.dart';

class NotFound extends StatelessWidget {
  const NotFound({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.colorLightGray),
      ),
    );
  }
}
