import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/common/widgets/app_background.dart';
import 'package:task_management/config/routes/routes.dart';
import 'package:task_management/constants/app_colors.dart';
import 'package:task_management/constants/app_strings.dart';
import 'package:task_management/screens/sign_in/controller/sign_in_controller.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final SignInController signInController = Get.put(SignInController());
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    signInController.emailController.addListener(_validateForm);
    signInController.passwordController.addListener(_validateForm);
  }

  void _validateForm() {
    signInController.isSignIn.value = formKey.currentState?.validate() ?? false;
  }

  @override
  void dispose() {
    super.dispose();
    signInController.emailController.dispose();
    signInController.passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return WillPopScope(
      onWillPop: () =>
          signInController.showExitConfirmationAlertDialog(context),
      child: AppBackground(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 150),
                Text(
                  "Get Started With",
                  style: textTheme.displaySmall,
                ),
                const SizedBox(height: 24),
                _buildSignInForm(context, signInController, formKey),
                const SizedBox(height: 40),
                Center(
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: () => Get.toNamed(Routes.emailAddress),
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      _buildSignUpSection(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  RichText _buildSignUpSection(context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 14,
          letterSpacing: 0.5,
        ),
        text: "Don't have an account? ",
        children: [
          TextSpan(
            text: 'Sign Up',
            style: const TextStyle(color: AppColors.colorGreen),
            recognizer: TapGestureRecognizer()
              ..onTap = () => Get.toNamed(Routes.signUp),
          ),
        ],
      ),
    );
  }

  Form _buildSignInForm(context, SignInController signInController, formKey) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: signInController.emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: "Email"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter email address";
              } else if (!RegExp(RegularExpression.email).hasMatch(value)) {
                return "Invalid email format";
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: signInController.passwordController,
            obscureText: true,
            decoration: const InputDecoration(hintText: "Password"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter password";
              } else if (!RegExp(RegularExpression.password).hasMatch(value)) {
                return "At least 8 characters and both letters and numbers";
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          Obx(
            () => ElevatedButton(
              onPressed: signInController.isSignIn.value
                  ? () => signInController.signIn(context, formKey)
                  : null,
              child: signInController.isProgress.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: AppColors.colorWhite,
                      ),
                    )
                  : const Icon(
                      Icons.arrow_circle_right_outlined,
                      size: 30,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
