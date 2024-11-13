import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_management/constants/app_colors.dart';

class ExitConfirmationAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final String cancelText;
  final String confirmText;
  final void Function()? actionYes;

  const ExitConfirmationAlertDialog({
    super.key,
    this.title = 'Exit Application?',
    this.content = 'Are you sure you want to exit the application?',
    this.cancelText = 'No',
    this.confirmText = 'Yes',
    this.actionYes,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 0.5,
      backgroundColor: AppColors.colorWhite,
      contentPadding: const EdgeInsets.all(16),
      titlePadding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            cancelText,
            style: const TextStyle(color: AppColors.colorGreen),
          ),
        ),
        TextButton(
          onPressed: () {
            if (actionYes != null) {
              actionYes!();
            } else {
              SystemNavigator.pop();
            }
          },
          child: Text(
            confirmText,
            style: const TextStyle(color: AppColors.colorGreen),
          ),
        ),
      ],
    );
  }
}
