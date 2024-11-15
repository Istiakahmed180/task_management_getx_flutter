import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/common/auth_controller.dart';
import 'package:task_management/common/widgets/exit_confirmation_alert_dialog.dart';
import 'package:task_management/config/routes/routes.dart';
import 'package:task_management/constants/app_colors.dart';
import 'package:task_management/screens/sign_in/controller/sign_in_controller.dart';

class CommonAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CommonAppBar({super.key});

  @override
  State<CommonAppBar> createState() => _CommonAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 20);
}

class _CommonAppBarState extends State<CommonAppBar> {
  final AuthenticationController _authController = AuthenticationController();
  Map<String, String> userInformation = {};
  static const String firstName = "firstName";
  static const String lastName = "lastName";

  @override
  void initState() {
    super.initState();
    _authController.getUserInfo().then((user) {
      setState(() {
        userInformation = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.colorGreen,
      title: ListTile(
        onTap: () => Navigator.pushNamed(context, Routes.updateProfile),
        title: Text(
          "${userInformation[firstName]?.isNotEmpty == true ? userInformation[firstName] : ""} ${userInformation[lastName]?.isNotEmpty == true ? userInformation[lastName] : ""}",
          style: textTheme.titleLarge
              ?.copyWith(color: AppColors.colorWhite, fontSize: 20),
        ),
        subtitle: Text(
          userInformation["email"] ?? "user@example.com",
          style: textTheme.titleSmall?.copyWith(
            color: AppColors.colorWhite,
            fontSize: 12,
          ),
        ),
        leading: InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: () => Navigator.pushNamed(context, Routes.updateProfile),
          child: CircleAvatar(
            radius: 25,
            backgroundColor: AppColors.colorGreen,
            backgroundImage: userInformation["photo"] != null
                ? MemoryImage(base64Decode(userInformation["photo"]!))
                : null,
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            _showExitConfirmationAlertDialog(context);
          },
          icon: const Icon(Icons.logout_outlined),
        ),
      ],
    );
  }

  Future<bool> _showExitConfirmationAlertDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => ExitConfirmationAlertDialog(
        title: "Logout Application?",
        content: "Are you sure you want to logout of the application?",
        actionYes: () {
          _authController.clearSharedPreferenceData();
          Get.delete<SignInController>();
          Get.put(SignInController());
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.signIn,
            (route) => false,
          );
        },
      ),
    ).then((value) => value ?? false);
  }
}
