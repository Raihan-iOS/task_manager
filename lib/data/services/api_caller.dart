import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:task_manager/app.dart';
import 'package:task_manager/ui/screens/auth/Sign_in_screen.dart';

import '../../ui/screens/Controller/auth_controller.dart';

// class ApiCaller {
//   static Logger logger = Logger();

//   /// Default headers (you can extend with auth tokens, etc.)
//   static Map<String, String> defaultHeaders = {
//     "Content-Type": "application/json",
//   };

//   //! ========== GET Request ==========
//   static Future<ApiResponse<T>> getRequest<T>({
//     required String url,
//     Map<String, String>? headers,
//   }) async {
//     try {
//       Uri uri = Uri.parse(url);
//       _logRequest(url: url);

//       Response response = await get(
//         uri,
//         headers: {...defaultHeaders, ...?headers},
//       ).timeout(const Duration(seconds: 15));

//       return _handleResponse<T>(url, response);
//     } on Exception catch (e) {
//       return _handleException<T>(url, e);
//     }
//   }

//   //! ========== POST Request ==========
//   static Future<ApiResponse<T>> postRequest<T>({
//     required String url,
//     required Map<String, dynamic> body,
//     Map<String, String>? headers,
//   }) async {
//     try {
//       Uri uri = Uri.parse(url);
//       _logRequest(url: url, body: body);

//       Response response = await post(
//         uri,
//         headers: {...defaultHeaders, ...?headers},
//         body: jsonEncode(body),
//       ).timeout(const Duration(seconds: 15));

//       return _handleResponse<T>(url, response);
//     } on Exception catch (e) {
//       return _handleException<T>(url, e);
//     }
//   }

//   //! ========== PUT Request ==========
//   static Future<ApiResponse<T>> putRequest<T>({
//     required String url,
//     required Map<String, dynamic> body,
//     Map<String, String>? headers,
//   }) async {
//     try {
//       Uri uri = Uri.parse(url);
//       _logRequest(url: url, body: body);

//       Response response = await put(
//         uri,
//         headers: {...defaultHeaders, ...?headers},
//         body: jsonEncode(body),
//       ).timeout(const Duration(seconds: 15));

//       return _handleResponse<T>(url, response);
//     } on Exception catch (e) {
//       return _handleException<T>(url, e);
//     }
//   }

//   //! ========== DELETE Request ==========
//   static Future<ApiResponse<T>> deleteRequest<T>({
//     required String url,
//     Map<String, String>? headers,
//   }) async {
//     try {
//       Uri uri = Uri.parse(url);
//       _logRequest(url: url);

//       Response response = await delete(
//         uri,
//         headers: {...defaultHeaders, ...?headers},
//       ).timeout(const Duration(seconds: 15));

//       return _handleResponse<T>(url, response);
//     } on Exception catch (e) {
//       return _handleException<T>(url, e);
//     }
//   }

//   //! ========== Helpers ==========

//   static ApiResponse<T> _handleResponse<T>(String url, Response response) {
//     final int statusCode = response.statusCode;
//     final dynamic decodedData = _safeDecode(response.body);

//     if (statusCode >= 200 && statusCode < 300) {
//       logger.i('✅ Success [$statusCode] $url');
//       _logResponse(url: url, body: decodedData, statusCode: statusCode);
//       return ApiResponse<T>(
//         isSuccess: true,
//         response: decodedData as T?,
//         statusCode: statusCode,
//       );
//     } else {
//       logger.w('⚠️ Failed [$statusCode] $url');
//       _logResponse(
//         url: url,
//         body: decodedData,
//         statusCode: statusCode,
//         errorMessage: decodedData?['message'],
//       );
//       return ApiResponse<T>(
//         isSuccess: false,
//         response: decodedData as T?,
//         statusCode: statusCode,
//         errorMessage:
//             decodedData is Map<String, dynamic> ? decodedData['message'] : null,
//       );
//     }
//   }

//   static ApiResponse<T> _handleException<T>(String url, Exception e) {
//     String errorMessage = 'An error occurred';
//     if (e is SocketException) {
//       errorMessage = 'No Internet Connection';
//     } else if (e is TimeoutException) {
//       errorMessage = 'Request Timed Out';
//     } else if (e is FormatException) {
//       errorMessage = 'Invalid Response Format';
//     } else {
//       errorMessage = e.toString();
//     }

//     logger.e('❌ Exception $url => $errorMessage');
//     _logResponse(
//       url: url,
//       body: null,
//       statusCode: 0,
//       errorMessage: errorMessage,
//     );

//     return ApiResponse<T>(
//       isSuccess: false,
//       response: null,
//       statusCode: 0,
//       errorMessage: errorMessage,
//     );
//   }

//   static void _logRequest({required String url, Map<String, dynamic>? body}) {
//     logger.d('➡️ Request URL: $url');
//     if (body != null) {
//       logger.d('➡️ Request Body: $body');
//     }
//   }

//   static void _logResponse({
//     required String url,
//     required dynamic body,
//     required int? statusCode,
//     String? errorMessage,
//   }) {
//     logger.d('⬅️ Response URL: $url');
//     if (body != null) {
//       logger.d('⬅️ Response Body: $body');
//     }
//     if (statusCode != null) {
//       logger.d('⬅️ Status Code: $statusCode');
//     }
//     if (errorMessage != null) {
//       logger.e('⬅️ Error Message: $errorMessage');
//     }
//   }

//   static dynamic _safeDecode(String data) {
//     try {
//       return jsonDecode(data);
//     } catch (_) {
//       return data; // return raw string if not JSON
//     }
//   }
// }

// class ApiResponse<T> {
//   final bool isSuccess;
//   final int statusCode;
//   final T? response;
//   final String? errorMessage;

//   ApiResponse({
//     required this.isSuccess,
//     required this.statusCode,
//     this.response,
//     this.errorMessage,
//   });
// }

//!@========= Old Version ==========
class ApiCaller {
  static Logger logger = Logger();

  static int timeoutDuration = 30;

  // Make headers dynamic - rebuild on every request
  static Map<String, String> get defaultHeaders {
    final headers = {
      "Content-Type": "application/json",
    };

    // Add token if available (check your API documentation for correct format)
    if (AuthController.accessToken != null) {
      headers["token"] = AuthController.accessToken!;
      // OR if your API uses Bearer format:
      // headers["Authorization"] = "Bearer ${AuthController.accessToken}";
    }

    return headers;
  }

  //! GET Request
  static Future<ApiResponse> getRequest({required String url}) async {
    try {
      Uri uri = Uri.parse(url);
      _logRequest(url: url);
      Response response = await get(
        uri,
        headers: defaultHeaders,  // Now gets fresh headers each time
      ).timeout(Duration(seconds: timeoutDuration));

      return _handleResponse(url, response);
    } on Exception catch (e) {
      return _handleException(url, e);
    }
  }

  //! POST Request
  static Future<ApiResponse> postRequest({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    try {
      Uri uri = Uri.parse(url);
      _logRequest(url: url, body: body);
      Response response = await post(
        uri,
        headers: defaultHeaders,
        body: jsonEncode(body),
      ).timeout(Duration(seconds: timeoutDuration));

      return _handleResponse(url, response);
    } on Exception catch (e) {
      return _handleException(url, e);
    }
  }

  //! PUT Request
  static Future<ApiResponse> putRequest({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    try {
      Uri uri = Uri.parse(url);
      _logRequest(url: url, body: body);
      Response response = await put(
        uri,
        headers: defaultHeaders,
        body: jsonEncode(body),
      ).timeout(Duration(seconds: timeoutDuration));

      return _handleResponse(url, response);
    } on Exception catch (e) {
      return _handleException(url, e);
    }
  }

  //! DELETE Request
  static Future<ApiResponse> deleteRequest({required String url}) async {
    try {
      Uri uri = Uri.parse(url);
      _logRequest(url: url);
      Response response = await delete(
        uri,
        headers: defaultHeaders,
      ).timeout(Duration(seconds: timeoutDuration));

      return _handleResponse(url, response);
    } on Exception catch (e) {
      return _handleException(url, e);
    }
  }

  // Centralized response handler
  static ApiResponse _handleResponse(String url, Response response) {
    final int statusCode = response.statusCode;
    final decodedData = _safeDecode(response.body);

    if (statusCode == 200 || statusCode == 201 || statusCode == 204) {
      _logResponse(url: url, body: decodedData, statusCode: statusCode);
      return ApiResponse(
        isSuccess: true,
        responseData: decodedData,
        statusCode: statusCode,
      );
    } else if (statusCode == 401) {
      logger.w('⚠️ 401 Unauthorized at $url');
      // IMPORTANT: Don't auto-logout here!
      // Let the UI handle it or add better error handling
      _logResponse(
        url: url,
        body: decodedData,
        statusCode: statusCode,
        errorMessage: 'Unauthorized',
      );

      // Option 1: Return error and let UI handle logout
      // return ApiResponse(
      //   isSuccess: false,
      //   responseData: decodedData,
      //   statusCode: statusCode,
      //   errorMessage: 'Session expired. Please log in again.',
      // );

      // Option 2: Only logout if we're sure it's a real auth issue
      if (AuthController.accessToken != null) {
        _moveToLoginScreen();
      }
    } else {
      _logResponse(
        url: url,
        body: decodedData,
        statusCode: statusCode,
        errorMessage: decodedData is Map ? decodedData['data'] : null,
      );
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

  // Centralized exception handler
  static ApiResponse _handleException(String url, Exception e) {
    String errorMessage = 'An error occurred';
    if (e.toString().contains('SocketException')) {
      errorMessage = 'No Internet Connection';
    } else if (e.toString().contains('TimeoutException')) {
      errorMessage = 'Request Timed Out';
    } else {
      errorMessage = e.toString();
    }

    _logResponse(
      url: url,
      body: null,
      statusCode: 0,
      errorMessage: errorMessage,
    );

    return ApiResponse(
      isSuccess: false,
      responseData: null,
      statusCode: 0,
      errorMessage: errorMessage,
    );
  }

  static void _logRequest({required String url, Map<String, dynamic>? body}) {
    logger.i('➡️ Request URL: $url');
    logger.i('➡️ Headers: $defaultHeaders');
    if (body != null) {
      logger.i('➡️ Request Body: $body');
    }
  }

  static void _logResponse({
    required String url,
    required dynamic body,
    required int? statusCode,
    String? errorMessage,
  }) {
    logger.i('⬅️ Response URL: $url');
    if (statusCode != null) {
      logger.i('⬅️ Status Code: $statusCode');
    }
    if (body != null) {
      logger.i('⬅️ Response Body: $body');
    }
    if (errorMessage != null) {
      logger.e('⬅️ Error Message: $errorMessage');
    }
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