import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:task_management/config/routes/routes.dart';
import 'package:task_management/constants/api_path.dart';
import 'package:task_management/constants/app_colors.dart';
import 'package:task_management/network/network_service.dart';

class EmailAddressController extends GetxController {
  final emailController = TextEditingController();

  final isEmailVerification = false.obs;
  final isProgress = false.obs;

  Future<void> emailVerification(context, GlobalKey<FormState> formKey) async {
    if (formKey.currentState!.validate()) {
      isProgress.value = true;
      final email = emailController.text.trim();

      final response = await NetworkService.getRequest(
        context: context,
        url: ApiPath.emailAddressVerify(email),
      );

      isProgress.value = false;

      if (response.isSuccess) {
        Get.toNamed(Routes.pinVerification);
        Fluttertoast.showToast(
          msg: response.requestResponse["data"],
          backgroundColor: AppColors.colorGreen,
        );
      } else {
        Fluttertoast.showToast(
          msg: response.errorMessage,
          backgroundColor: AppColors.colorRed,
        );
      }
    }
  }
}
