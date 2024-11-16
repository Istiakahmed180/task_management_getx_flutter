import 'package:get/get.dart';
import 'package:task_management/common/controller/auth_controller.dart';
import 'package:task_management/config/routes/routes.dart';

class SplashController extends GetxController {
  final AuthController _authController = Get.put(AuthController());

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 3), () => _moveToNextScreen());
  }

  void _moveToNextScreen() async {
    await _authController.loadAccessToken();
    if (_authController.isLoggedIn) {
      Get.offNamed(Routes.home);
    } else {
      Get.offNamed(Routes.signIn);
    }
  }
}
