import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/common/widgets/app_background.dart';
import 'package:task_management/config/routes/routes.dart';
import 'package:task_management/constants/app_colors.dart';
import 'package:task_management/constants/app_strings.dart';
import 'package:task_management/screens/sign_up/controller/sign_up_controller.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final SignUpController signUpController = Get.find<SignUpController>();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    signUpController.emailController.addListener(_validateForm);
    signUpController.firstNameController.addListener(_validateForm);
    signUpController.lastNameController.addListener(_validateForm);
    signUpController.phoneNumberController.addListener(_validateForm);
    signUpController.passwordController.addListener(_validateForm);
  }

  void _validateForm() {
    signUpController.isSignUpEnabled.value =
        formKey.currentState?.validate() ?? false;
  }

  @override
  void dispose() {
    super.dispose();
    signUpController.emailController.dispose();
    signUpController.firstNameController.dispose();
    signUpController.lastNameController.dispose();
    signUpController.phoneNumberController.dispose();
    signUpController.passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return AppBackground(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),
                  Text(
                    "Join With Us",
                    style: textTheme.displaySmall,
                  ),
                  const SizedBox(height: 24),
                  _buildSignUpForm(context, signUpController, formKey),
                  const SizedBox(height: 40),
                  Center(
                    child: _buildSignInSection(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInSection() {
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
              ..onTap = () => Get.offNamed(Routes.signIn),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpForm(context, SignUpController signUpController, formKey) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: signUpController.emailController,
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
            controller: signUpController.firstNameController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(hintText: "First Name"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter first name";
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: signUpController.lastNameController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(hintText: "Last Name"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter last name";
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: signUpController.phoneNumberController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(hintText: "Mobile"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter mobile number";
              } else if (!RegExp(RegularExpression.phone).hasMatch(value)) {
                return "Invalid phone number format";
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: signUpController.passwordController,
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
              onPressed: signUpController.isSignUpEnabled.value
                  ? () => signUpController.signUp(context, formKey)
                  : null,
              child: signUpController.isProgress.value
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
