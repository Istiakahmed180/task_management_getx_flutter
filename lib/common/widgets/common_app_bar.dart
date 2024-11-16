import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/common/controller/common_app_bar_controller.dart';
import 'package:task_management/constants/app_colors.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  CommonAppBar({super.key});

  final CommonAppBarController controller = Get.find<CommonAppBarController>();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 20);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.colorGreen,
      title: Obx(
        () => ListTile(
          onTap: controller.navigateToUpdateProfile,
          title: Text(
            controller.fullName,
            style: textTheme.titleLarge?.copyWith(
              color: AppColors.colorWhite,
              fontSize: 20,
            ),
          ),
          subtitle: Text(
            controller.email,
            style: textTheme.titleSmall?.copyWith(
              color: AppColors.colorWhite,
              fontSize: 12,
            ),
          ),
          leading: InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: controller.navigateToUpdateProfile,
            child: CircleAvatar(
              radius: 25,
              backgroundColor: AppColors.colorGreen,
              backgroundImage: controller.photo != null
                  ? MemoryImage(base64Decode(controller.photo!))
                  : null,
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => controller.showLogoutConfirmation(),
          icon: const Icon(Icons.logout_outlined),
        ),
      ],
    );
  }
}
