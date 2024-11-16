// BindingController
import 'package:get/get.dart';
import 'package:task_management/common/controller/auth_controller.dart';
import 'package:task_management/common/controller/common_app_bar_controller.dart';
import 'package:task_management/screens/forgot_password/controller/email_address_controller.dart';
import 'package:task_management/screens/forgot_password/controller/pin_verification_controller.dart';
import 'package:task_management/screens/forgot_password/controller/set_password_controller.dart';
import 'package:task_management/screens/sign_in/controller/sign_in_controller.dart';
import 'package:task_management/screens/sign_up/controller/sign_up_controller.dart';
import 'package:task_management/screens/splash/controller/splash_controller.dart';

class BindingController extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
    Get.put(SplashController());
    Get.put(SignInController());
    Get.put(SignUpController());
    Get.put(EmailAddressController());
    Get.put(PinVerificationController());
    Get.put(SetPasswordController());
    Get.put(CommonAppBarController());
  }
}
