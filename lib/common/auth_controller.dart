import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationController {
  final String _accessTokenKey = "access_token";
  final String _emailKey = "user_email";
  final String _firstNameKey = "user_first_name";
  final String _lastNameKey = "user_last_name";
  final String _mobileKey = "user_mobile";
  final String _photoKey = "user_photo";

  static String? accessToken;
  static Map<String, String>? userInfo;

  Future<void> saveAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, token);
    accessToken = token;
  }

  Future<void> saveUserInfo(String email, String firstName, String lastName,
      String mobile, String photo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
    await prefs.setString(_firstNameKey, firstName);
    await prefs.setString(_lastNameKey, lastName);
    await prefs.setString(_mobileKey, mobile);
    await prefs.setString(_photoKey, photo);
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString(_accessTokenKey);
    return accessToken;
  }

  Future<Map<String, String>> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString(_emailKey) ?? "";
    String firstName = prefs.getString(_firstNameKey) ?? "";
    String lastName = prefs.getString(_lastNameKey) ?? "";
    String mobile = prefs.getString(_mobileKey) ?? "";
    String photo = prefs.getString(_photoKey) ?? "";

    Map<String, String> userInformation = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
      "photo": photo,
    };

    return userInfo = userInformation;
  }

  bool get isLoggedIn => accessToken != null;

  Future<void> clearSharedPreferenceData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    accessToken = null;
  }
}
