import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:task_management/common/auth_controller.dart';
import 'package:task_management/common/widgets/exit_confirmation_alert_dialog.dart';
import 'package:task_management/config/routes/routes.dart';

import 'network_response.dart';

class NetworkService {
  // Common request timeout duration
  static const Duration timeoutDuration = Duration(seconds: 15);
  static final AuthenticationController _authController =
      AuthenticationController();

  // Get Token from SharedPreferences
  static Future<String?> _getToken() async {
    return await _authController.getAccessToken();
  }

  // Request Headers
  static Map<String, String> _requestHeaders(String? token) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null) {
      headers['token'] = token;
    }
    return headers;
  }

  // Get API Network Service
  static Future<NetworkResponse> getRequest({
    required BuildContext context,
    required String url,
  }) async {
    final String? token = await _getToken();
    try {
      Uri uri = Uri.parse(url);
      final response = await get(uri, headers: _requestHeaders(token))
          .timeout(timeoutDuration);
      return _handleResponse(context, url, response, token);
    } catch (e) {
      return _handleError(e);
    }
  }

  // Post API Network Service
  static Future<NetworkResponse> postRequest({
    required BuildContext context,
    required String url,
    required Map<String, dynamic> requestBody,
  }) async {
    final String? token = await _getToken();
    try {
      Uri uri = Uri.parse(url);
      debugPrint("Request Body: ${jsonEncode(requestBody)}");
      final response = await post(
        uri,
        headers: _requestHeaders(token),
        body: jsonEncode(requestBody),
      ).timeout(timeoutDuration);
      return _handleResponse(context, url, response, token);
    } catch (e) {
      return _handleError(e);
    }
  }

  // Common function to handle API responses
  static Future<NetworkResponse> _handleResponse(
    BuildContext context,
    String url,
    Response response,
    String? token,
  ) async {
    printResponse(url, response, token);

    if (response.statusCode == 401) {
      await _showExitConfirmationAlertDialog(context);
      return NetworkResponse(
        isSuccess: false,
        statusCode: 401,
        errorMessage: "Unauthorized access - Please log in again.",
      );
    } else {
      final jsonResponse = jsonDecode(response.body);
      final status = jsonResponse["status"];
      if (status == "success") {
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          requestResponse: jsonResponse,
        );
      } else {
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: jsonResponse["data"],
        );
      }
    }
  }

  // Common function to handle errors
  static NetworkResponse _handleError(dynamic error) {
    return NetworkResponse(
      isSuccess: false,
      statusCode: -1,
      errorMessage: error is TimeoutException
          ? "Request timed out after ${timeoutDuration.inSeconds} seconds. Please check your connection and try again."
          : "An error occurred: ${error.toString()}",
    );
  }

  // Logging the API responses for debugging
  static void printResponse(String url, Response response, String? token) {
    debugPrint(
        "URL : $url\nResponse Code : ${response.statusCode}\nToken : $token\nResponse Body : ${response.body}");
  }

  static Future<void> _showExitConfirmationAlertDialog(
      BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => ExitConfirmationAlertDialog(
        title: "Unauthorized",
        content: "Unauthorized access - Please log in again.",
        confirmText: "Yes",
        actionYes: () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.signIn,
            (route) => false,
          );
          _authController.clearSharedPreferenceData();
        },
      ),
    );
  }
}
