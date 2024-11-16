import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:task_management/config/routes/routes.dart';
import 'package:task_management/constants/api_path.dart';
import 'package:task_management/constants/app_colors.dart';
import 'package:task_management/network/network_service.dart';
import 'package:task_management/screens/forgot_password/controller/email_address_controller.dart';

class PinVerificationController extends GetxController {
  final EmailAddressController emailAddressController =
      Get.put(EmailAddressController());
  final TextEditingController otpController = TextEditingController();

  var isProgress = false.obs;
  var isPinVerified = false.obs;

  void validatePin() {
    isPinVerified.value = otpController.text.length == 6;
  }

  Future<void> otpVerify(BuildContext context) async {
    isProgress.value = true;
    final otp = otpController.text.trim();

    final response = await NetworkService.getRequest(
      context: context,
      url: ApiPath.pinCodeVerify(
          emailAddressController.emailController.text, otp),
    );

    isProgress.value = false;

    if (response.isSuccess) {
      Get.toNamed(Routes.resetPassword);
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
