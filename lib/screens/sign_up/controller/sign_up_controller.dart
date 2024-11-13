import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:task_management/config/routes/routes.dart';
import 'package:task_management/constants/api_path.dart';
import 'package:task_management/constants/app_colors.dart';
import 'package:task_management/network/network_service.dart';

class SignUpController extends GetxController {
  final emailController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();

  final isSignUpEnabled = false.obs;
  final isProgress = false.obs;

  Future<void> signUp(context, GlobalKey<FormState> formKey) async {
    if (formKey.currentState!.validate()) {
      isProgress.value = true;

      final requestBody = {
        "email": emailController.text.trim(),
        "firstName": firstNameController.text.trim(),
        "lastName": lastNameController.text.trim(),
        "mobile": phoneNumberController.text.trim(),
        "password": passwordController.text,
      };

      final response = await NetworkService.postRequest(
        context: context,
        url: ApiPath.registration,
        requestBody: requestBody,
      );
      isProgress.value = false;

      if (response.isSuccess) {
        Get.offNamed(Routes.signIn);
        clearTextFields();
        Fluttertoast.showToast(
          msg: "Registration Complete",
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

  void clearTextFields() {
    emailController.clear();
    firstNameController.clear();
    lastNameController.clear();
    phoneNumberController.clear();
    passwordController.clear();
  }
}
