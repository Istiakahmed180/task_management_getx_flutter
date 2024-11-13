import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final String _accessTokenKey = "access_token";
  final String _emailKey = "user_email";
  final String _firstNameKey = "user_first_name";
  final String _lastNameKey = "user_last_name";
  final String _mobileKey = "user_mobile";
  final String _photoKey = "user_photo";

  final accessToken = RxnString();
  final userInfo = <String, String>{}.obs;

  Future<void> saveAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, token);
    accessToken.value = token;
  }

  Future<void> saveUserInfo(String email, String firstName, String lastName,
      String mobile, String photo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
    await prefs.setString(_firstNameKey, firstName);
    await prefs.setString(_lastNameKey, lastName);
    await prefs.setString(_mobileKey, mobile);
    await prefs.setString(_photoKey, photo);
    userInfo.value = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
      "photo": photo,
    };
  }

  Future<void> loadAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken.value = prefs.getString(_accessTokenKey);
  }

  Future<void> loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    userInfo.value = {
      "email": prefs.getString(_emailKey) ?? "",
      "firstName": prefs.getString(_firstNameKey) ?? "",
      "lastName": prefs.getString(_lastNameKey) ?? "",
      "mobile": prefs.getString(_mobileKey) ?? "",
      "photo": prefs.getString(_photoKey) ?? "",
    };
  }

  bool get isLoggedIn => accessToken.value != null;

  Future<void> clearSharedPreferenceData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    accessToken.value = null;
    userInfo.clear();
  }

  @override
  void onInit() {
    super.onInit();
    loadAccessToken();
    loadUserInfo();
  }
}
