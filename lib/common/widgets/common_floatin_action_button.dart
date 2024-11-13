import 'package:flutter/material.dart';
import 'package:task_management/constants/app_colors.dart';

class CommonFloatingActionButton extends StatelessWidget {
  final Function goToTaskCreateScreen;

  const CommonFloatingActionButton({
    super.key,
    required this.goToTaskCreateScreen,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      onPressed: () => goToTaskCreateScreen(),
      backgroundColor: AppColors.colorGreen,
      child: const Icon(
        Icons.add,
        color: AppColors.colorWhite,
      ),
    );
  }
}
