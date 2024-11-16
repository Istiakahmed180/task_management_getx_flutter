import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/common/widgets/app_background.dart';
import 'package:task_management/config/routes/routes.dart';
import 'package:task_management/constants/app_colors.dart';
import 'package:task_management/constants/app_strings.dart';
import 'package:task_management/screens/forgot_password/controller/email_address_controller.dart';

class EmailAddressScreen extends StatefulWidget {
  const EmailAddressScreen({super.key});

  @override
  State<EmailAddressScreen> createState() => _EmailAddressScreenState();
}

class _EmailAddressScreenState extends State<EmailAddressScreen> {
  final EmailAddressController emailAddressController =
      Get.put(EmailAddressController());
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emailAddressController.emailController.addListener(_validateForm);
  }

  void _validateForm() {
    emailAddressController.isEmailVerification.value =
        formKey.currentState?.validate() ?? false;
  }

  @override
  Widget build(BuildContext context) {
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
                Text(
                  "Your Email Address",
                  style: textTheme.displaySmall,
                ),
                const SizedBox(height: 20),
                Text(
                  "A 6 digit verification pin will be sent to your email address",
                  style: textTheme.titleSmall,
                ),
                const SizedBox(height: 24),
                _buildEmailAddressForm(
                    context, emailAddressController, formKey),
                const SizedBox(height: 40),
                Center(
                  child: _buildSignInSection(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Form _buildEmailAddressForm(context, EmailAddressController controller,
      GlobalKey<FormState> formKey) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: controller.emailController,
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
          Obx(() => ElevatedButton(
                onPressed: controller.isEmailVerification.value
                    ? () => controller.emailVerification(context, formKey)
                    : null,
                child: controller.isProgress.value
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
              )),
        ],
      ),
    );
  }

  RichText _buildSignInSection(BuildContext context) {
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
              ..onTap =
                  () => Get.offNamedUntil(Routes.signIn, (route) => false),
          ),
        ],
      ),
    );
  }
}
