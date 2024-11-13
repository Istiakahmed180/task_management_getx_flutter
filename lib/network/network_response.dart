class NetworkResponse {
  final bool isSuccess;
  final int statusCode;
  final dynamic requestResponse;
  final String errorMessage;

  NetworkResponse(
      {required this.isSuccess,
      required this.statusCode,
      this.requestResponse,
      this.errorMessage = "Something went wrong!"});
}