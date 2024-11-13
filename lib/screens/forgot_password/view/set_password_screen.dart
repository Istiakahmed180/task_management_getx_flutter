import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/common/widgets/app_background.dart';
import 'package:task_management/config/routes/routes.dart';
import 'package:task_management/constants/app_colors.dart';
import 'package:task_management/constants/app_strings.dart';
import 'package:task_management/screens/forgot_password/controller/set_password_controller.dart';

class SetPasswordScreen extends StatelessWidget {
  const SetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SetPasswordController setPasswordController =
        Get.find<SetPasswordController>();
    final formKey = GlobalKey<FormState>();
    TextTheme textTheme = Theme.of(context).textTheme;

    return AppBackground(
      child: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 150),
                Text("Set Password", style: textTheme.displaySmall),
                const SizedBox(height: 20),
                Text(
                  "Minimum length password 8 characters with letters and numbers",
                  style: textTheme.titleSmall,
                ),
                const SizedBox(height: 24),
                _buildPasswordAndConfirmPasswordForm(
                    setPasswordController, formKey, context),
                const SizedBox(height: 40),
                Center(child: _buildSignInSection()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Form _buildPasswordAndConfirmPasswordForm(
      SetPasswordController setPasswordController,
      GlobalKey<FormState> formKey,
      context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: setPasswordController.passwordController,
            obscureText: true,
            decoration: const InputDecoration(hintText: "Password"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter a password";
              } else if (!RegExp(RegularExpression.password).hasMatch(value)) {
                return "At least 8 characters and both letters and numbers";
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: setPasswordController.confirmPasswordController,
            obscureText: true,
            decoration: const InputDecoration(hintText: "Confirm Password"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please confirm your password";
              } else if (value !=
                  setPasswordController.passwordController.text) {
                return "Passwords do not match";
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          Obx(
            () => ElevatedButton(
              onPressed: () =>
                  setPasswordController.setPassword(context, formKey),
              child: setPasswordController.isProgress.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: AppColors.colorWhite,
                      ),
                    )
                  : const Text("Confirm"),
            ),
          ),
        ],
      ),
    );
  }

  RichText _buildSignInSection() {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 14,
          letterSpacing: 0.5,
        ),
        text: "Have an account? ",
        children: [
          TextSpan(
            text: 'Sign In',
            style: const TextStyle(color: AppColors.colorGreen),
            recognizer: TapGestureRecognizer()
              ..onTap = () => Get.offAllNamed(Routes.signIn),
          ),
        ],
      ),
    );
  }
}
