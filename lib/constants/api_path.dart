class ApiPath {
  // Base URL API Path
  static const String _baseUrl = "http://35.73.30.144:2005/api/v1";

  // Authentication API Path
  static const String registration = "$_baseUrl/Registration";
  static const String login = "$_baseUrl/Login";
  static String emailAddressVerify(email) =>
      "$_baseUrl/RecoverVerifyEmail/$email";
  static String pinCodeVerify(email, otp) =>
      "$_baseUrl/RecoverVerifyOtp/$email/$otp";
  static const String setPassword = "$_baseUrl/RecoverResetPassword";
  static const String profileDetails = "$_baseUrl/ProfileDetails";
  static const String profileUpdate = "$_baseUrl/ProfileUpdate";

  // Task API Path
  static const String createNewTask = "$_baseUrl/createTask";
  static const String taskCount = "$_baseUrl/taskStatusCount";
  static const String newTaskList = "$_baseUrl/listTaskByStatus/New";
  static const String completeTaskList = "$_baseUrl/listTaskByStatus/Completed";
  static const String canceledTaskList = "$_baseUrl/listTaskByStatus/Canceled";
  static const String progressTaskList = "$_baseUrl/listTaskByStatus/Progress";
  static String deleteTask(taskId) => "$_baseUrl/deleteTask/$taskId";
  static String updateTask(taskId, status) =>
      "$_baseUrl/updateTaskStatus/$taskId/$status";
}
