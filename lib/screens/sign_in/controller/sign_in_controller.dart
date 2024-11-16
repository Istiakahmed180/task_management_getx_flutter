import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:task_management/common/controller/auth_controller.dart';
import 'package:task_management/common/widgets/exit_confirmation_alert_dialog.dart';
import 'package:task_management/config/routes/routes.dart';
import 'package:task_management/constants/api_path.dart';
import 'package:task_management/constants/app_colors.dart';
import 'package:task_management/network/network_response.dart';
import 'package:task_management/network/network_service.dart';

class SignInController extends GetxController {
  final AuthController authController = Get.put(AuthController());

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isSignIn = false.obs;
  final isProgress = false.obs;

  Future<void> signIn(
      BuildContext context, GlobalKey<FormState> formKey) async {
    if (formKey.currentState!.validate()) {
      isProgress.value = true;

      final email = emailController.text.trim();
      final password = passwordController.text;

      final Map<String, String> requestBody = {
        "email": email,
        "password": password,
      };

      final NetworkResponse response = await NetworkService.postRequest(
        context: context,
        url: ApiPath.login,
        requestBody: requestBody,
      );

      isProgress.value = false;

      if (response.isSuccess) {
        await authController.saveAccessToken(response.requestResponse["token"]);
        await authController.saveUserInfo(
          response.requestResponse["data"]["email"],
          response.requestResponse["data"]["firstName"],
          response.requestResponse["data"]["lastName"],
          response.requestResponse["data"]["mobile"],
          response.requestResponse["data"]["photo"],
        );

        Get.offNamed(Routes.home);
        clearTextFields();
        Fluttertoast.showToast(
          msg: "Login Complete",
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

  Future<bool> showExitConfirmationAlertDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => const ExitConfirmationAlertDialog(),
    ).then((value) => value ?? false);
  }

  void clearTextFields() {
    emailController.clear();
    passwordController.clear();
  }
}
