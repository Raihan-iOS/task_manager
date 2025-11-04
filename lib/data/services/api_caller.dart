import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:task_manager/app.dart';
import 'package:task_manager/ui/screens/auth/Sign_in_screen.dart';
import '../../ui/screens/Controller/auth_controller.dart';

class ApiCaller {
  static int timeoutDuration = 30;

  // ✅ Dynamic headers getter
  static Map<String, String> get defaultHeaders {
    final headers = {
      "Content-Type": "application/json",
    };

    // Add token if available
    if (AuthController.accessToken != null && AuthController.accessToken!.isNotEmpty) {
      headers["token"] = AuthController.accessToken!;
      debugPrint('✅ Token added to headers');
    } else {
      debugPrint('⚠️ No token available');
    }

    return headers;
  }

  //! GET Request
  static Future<ApiResponse> getRequest({required String url}) async {
    try {
      debugPrint('📤 GET: $url');
      debugPrint('📋 Headers: $defaultHeaders');

      Response response = await get(
        Uri.parse(url),
        headers: defaultHeaders,
      ).timeout(Duration(seconds: timeoutDuration));

      return _handleResponse(url, response);
    } catch (e) {
      return _handleException(url, e);
    }
  }

  //! POST Request
  static Future<ApiResponse> postRequest({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    try {
      debugPrint('📤 POST: $url');
      debugPrint('📋 Headers: $defaultHeaders');
      debugPrint('📦 Body: $body');

      Response response = await post(
        Uri.parse(url),
        headers: defaultHeaders,
        body: jsonEncode(body),
      ).timeout(Duration(seconds: timeoutDuration));

      return _handleResponse(url, response);
    } catch (e) {
      return _handleException(url, e);
    }
  }

  //! PUT Request
  static Future<ApiResponse> putRequest({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    try {
      debugPrint('📤 PUT: $url');
      debugPrint('📋 Headers: $defaultHeaders');
      debugPrint('📦 Body: $body');

      Response response = await put(
        Uri.parse(url),
        headers: defaultHeaders,
        body: jsonEncode(body),
      ).timeout(Duration(seconds: timeoutDuration));

      return _handleResponse(url, response);
    } catch (e) {
      return _handleException(url, e);
    }
  }

  //! DELETE Request
  static Future<ApiResponse> deleteRequest({required String url}) async {
    try {
      debugPrint('📤 DELETE: $url');
      debugPrint('📋 Headers: $defaultHeaders');

      Response response = await delete(
        Uri.parse(url),
        headers: defaultHeaders,
      ).timeout(Duration(seconds: timeoutDuration));

      return _handleResponse(url, response);
    } catch (e) {
      return _handleException(url, e);
    }
  }

  //! Response handler
  static ApiResponse _handleResponse(String url, Response response) {
    final statusCode = response.statusCode;
    final decodedData = _safeDecode(response.body);

    debugPrint('📥 Status: $statusCode');
    debugPrint('📥 Response: $decodedData');

    if (statusCode == 200 || statusCode == 201 || statusCode == 204) {
      return ApiResponse(
        isSuccess: true,
        responseData: decodedData,
        statusCode: statusCode,
      );
    } else if (statusCode == 401) {
      debugPrint('⚠️ 401 Unauthorized - Logging out');
      _moveToLoginScreen();
      return ApiResponse(
        isSuccess: false,
        responseData: decodedData,
        statusCode: statusCode,
        errorMessage: 'Session expired. Please log in again.',
      );
    } else {
      return ApiResponse(
        isSuccess: false,
        responseData: decodedData,
        statusCode: statusCode,
        errorMessage: decodedData is Map
            ? decodedData['data'] ?? 'An error occurred'
            : 'An error occurred',
      );
    }
  }

  //! Exception handler
  static ApiResponse _handleException(String url, Object e) {
    String errorMessage = 'An error occurred';

    if (e.toString().contains('SocketException')) {
      errorMessage = 'No Internet Connection';
    } else if (e.toString().contains('TimeoutException')) {
      errorMessage = 'Request Timed Out';
    } else {
      errorMessage = e.toString();
    }

    debugPrint('❌ Exception: $errorMessage');

    return ApiResponse(
      isSuccess: false,
      responseData: null,
      statusCode: 0,
      errorMessage: errorMessage,
    );
  }

  static dynamic _safeDecode(String data) {
    try {
      return jsonDecode(data);
    } catch (_) {
      return data;
    }
  }

  static Future<void> _moveToLoginScreen() async {
    await AuthController.clearUserData();
    Navigator.pushNamedAndRemoveUntil(
      TaskMangerApp.navigatorKey.currentContext!,
      SignInScreen.routeName,
          (predicate) => false,
    );
  }
}

class ApiResponse {
  final bool isSuccess;
  final int statusCode;
  final dynamic responseData;
  final String? errorMessage;

  ApiResponse({
    required this.isSuccess,
    required this.responseData,
    required this.statusCode,
    this.errorMessage = 'An error occurred',
  });
}