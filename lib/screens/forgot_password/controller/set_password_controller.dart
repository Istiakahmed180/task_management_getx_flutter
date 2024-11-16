import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:task_management/config/routes/routes.dart';
import 'package:task_management/constants/api_path.dart';
import 'package:task_management/constants/app_colors.dart';
import 'package:task_management/network/network_response.dart';
import 'package:task_management/network/network_service.dart';
import 'package:task_management/screens/forgot_password/controller/email_address_controller.dart';
import 'package:task_management/screens/forgot_password/controller/pin_verification_controller.dart';

class SetPasswordController extends GetxController {
  final EmailAddressController emailAddressController =
      Get.put(EmailAddressController());
  final PinVerificationController pinVerificationController =
      Get.put(PinVerificationController());
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final isProgress = false.obs;

  @override
  void onClose() {
    super.onClose();
    emailAddressController.dispose();
    pinVerificationController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  Future<void> setPassword(context, GlobalKey<FormState> formKey) async {
    if (formKey.currentState!.validate()) {
      isProgress.value = true;

      final Map<String, String> requestBody = {
        "email": emailAddressController.emailController.text.trim(),
        "OTP": pinVerificationController.otpController.text,
        "password": passwordController.text
      };

      final NetworkResponse response = await NetworkService.postRequest(
        context: context,
        url: ApiPath.setPassword,
        requestBody: requestBody,
      );

      isProgress.value = false;
      if (response.isSuccess) {
        Get.offAllNamed(Routes.signIn);
        Fluttertoast.showToast(
          msg: response.requestResponse["data"],
          backgroundColor: AppColors.colorGreen,
        );

        emailAddressController.emailController.clear();
        pinVerificationController.otpController.clear();
        passwordController.clear();
        confirmPasswordController.clear();
      } else {
        Fluttertoast.showToast(
          msg: response.errorMessage,
          backgroundColor: AppColors.colorRed,
        );
      }
    }
  }
}
