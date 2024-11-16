import 'package:get/get.dart';
import 'package:task_management/common/auth_controller.dart';
import 'package:task_management/common/widgets/exit_confirmation_alert_dialog.dart';
import 'package:task_management/config/routes/routes.dart';
import 'package:task_management/screens/sign_in/controller/sign_in_controller.dart';

class CommonAppBarController extends GetxController {
  final AuthenticationController _authController = AuthenticationController();
  final RxMap<String, String> userInformation = <String, String>{}.obs;

  static const String firstName = "firstName";
  static const String lastName = "lastName";

  @override
  void onInit() {
    super.onInit();
    getUserInformation();
  }

  Future<void> getUserInformation() async {
    final user = await _authController.getUserInfo();
    userInformation.value = user;
  }

  void navigateToUpdateProfile() {
    Get.toNamed(Routes.updateProfile);
  }

  Future<bool> showLogoutConfirmation() async {
    final result = await Get.dialog(
      ExitConfirmationAlertDialog(
        title: "Logout Application?",
        content: "Are you sure you want to logout of the application?",
        actionYes: () {
          logout();
        },
      ),
    );
    return result ?? false;
  }

  void logout() {
    _authController.clearSharedPreferenceData();
    Get.delete<SignInController>();
    Get.put(SignInController());
    Get.offAllNamed(Routes.signIn);
  }

  String get fullName {
    final first = userInformation[firstName]?.isNotEmpty == true
        ? userInformation[firstName]
        : "";
    final last = userInformation[lastName]?.isNotEmpty == true
        ? userInformation[lastName]
        : "";
    return "$first $last";
  }

  String get email => userInformation["email"] ?? "user@example.com";

  String? get photo => userInformation["photo"];
}
