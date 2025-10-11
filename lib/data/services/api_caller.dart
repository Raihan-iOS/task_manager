import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

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

  /// Default headers (you can extend with auth tokens, etc.)
  static Map<String, String> defaultHeaders = {
    "Content-Type": "application/json",
    "token" : AuthController.accessToken ?? '',
  };

  static int timeoutDuration = 30;

  //! GET Request
  static Future<ApiResponse> getRequest({required String url}) async {
    try {
      Uri uri = Uri.parse(url);
      _logRequest(url: url);
      Response response = await get(
        headers: defaultHeaders,
        uri,
      ).timeout(Duration(seconds: timeoutDuration));

      final int statusCode = response.statusCode;

      final decodedData = _safeDecode(response.body);

      if (statusCode == 200) {
        _logResponse(url: url, body: decodedData, statusCode: statusCode);
        return ApiResponse(
          isSuccess: true,
          responseData: decodedData,
          statusCode: statusCode,
        );
      } else {
        _logResponse(
          url: url,
          body: decodedData,
          statusCode: statusCode,
          errorMessage: decodedData?['data'],
        );
        return ApiResponse(
          isSuccess: false,
          responseData: decodedData,
          statusCode: statusCode,
          errorMessage: decodedData?['data'] ?? 'An error occurred',
        );
      }
    } on Exception catch (e) {
      _logResponse(
        url: url,
        body: null,
        statusCode: 0,
        errorMessage: e.toString(),
      );
      return ApiResponse(
        isSuccess: false,
        responseData: null,
        statusCode: 0,
        errorMessage: e.toString(),
      );
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

      final int statusCode = response.statusCode;
      final decodedData = _safeDecode(response.body);

      if (statusCode == 200 || statusCode == 201) {
        _logResponse(url: url, body: decodedData, statusCode: statusCode);
        return ApiResponse(
          isSuccess: true,
          responseData: decodedData,
          statusCode: statusCode,
        );
      } else {
        _logResponse(
          url: url,
          body: decodedData,
          statusCode: statusCode,
          errorMessage: decodedData?['data'],
        );
        return ApiResponse(
          isSuccess: false,
          responseData: decodedData,
          statusCode: statusCode,
          errorMessage: decodedData?['data'] ?? 'An error occurred',
        );
      }
    } on Exception catch (e) {
      _logResponse(
        url: url,
        body: null,
        statusCode: 0,
        errorMessage: e.toString(),
      );
      return ApiResponse(
        isSuccess: false,
        responseData: null,
        statusCode: 0,
        errorMessage: e.toString(),
      );
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

      final int statusCode = response.statusCode;
      final decodedData = _safeDecode(response.body);

      if (statusCode == 200 || statusCode == 201) {
        _logResponse(url: url, body: decodedData, statusCode: statusCode);
        return ApiResponse(
          isSuccess: true,
          responseData: decodedData,
          statusCode: statusCode,
        );
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
          errorMessage:
              decodedData is Map
                  ? decodedData['data'] ?? 'An error occurred'
                  : 'An error occurred',
        );
      }
    } on Exception catch (e) {
      _logResponse(
        url: url,
        body: null,
        statusCode: 0,
        errorMessage: e.toString(),
      );
      return ApiResponse(
        isSuccess: false,
        responseData: null,
        statusCode: 0,
        errorMessage: e.toString(),
      );
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

      final int statusCode = response.statusCode;
      final decodedData = _safeDecode(response.body);

      if (statusCode == 200 || statusCode == 204) {
        _logResponse(url: url, body: decodedData, statusCode: statusCode);
        return ApiResponse(
          isSuccess: true,
          responseData: decodedData,
          statusCode: statusCode,
        );
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
          errorMessage:
              decodedData is Map
                  ? decodedData['data'] ?? 'An error occurred'
                  : 'An error occurred',
        );
      }
    } on Exception catch (e) {
      _logResponse(
        url: url,
        body: null,
        statusCode: 0,
        errorMessage: e.toString(),
      );
      return ApiResponse(
        isSuccess: false,
        responseData: null,
        statusCode: 0,
        errorMessage: e.toString(),
      );
    }
  }

  //! Helpers
  static void _logRequest({required String url, Map<String, dynamic>? body}) {
    logger.i('Request URL: $url');
    if (body != null) {
      logger.i('Request Body: $body');
    }
  }

  static void _logResponse({
    required String url,
    required dynamic body,
    required int? statusCode,
    String? errorMessage,
  }) {
    logger.i('Request URL: $url');
    if (body != null) {
      logger.i('Response Body: $body');
    }
    if (statusCode != null) {
      logger.i('Response Status Code: $statusCode');
    }
    if (errorMessage != null) {
      logger.e('Error Message: $errorMessage');
    }
  }

  static dynamic _safeDecode(String data) {
    try {
      return jsonDecode(data);
    } catch (_) {
      return data; // return raw string if not JSON
    }
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
