class RegularExpression {
  static const String email = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const String phone = r'^01\d{9}$';
  static const String password = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$';
}
