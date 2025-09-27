import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

enum HttpMethod { get, post, put, delete }

class ApiCallerUpdated {
  static Logger logger = Logger();

  /// Default headers (you can extend with auth tokens, etc.)
  static Map<String, String> defaultHeaders = {
    "Content-Type": "application/json",
  };

  /// Consolidated HTTP request method
  static Future<ApiResponseUpdated<T>> makeRequest<T>({
    required HttpMethod method,
    required String url,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      Uri uri = Uri.parse(url);
      _logRequest(url: url, body: body);

      Response response;
      final combinedHeaders = {...defaultHeaders, ...?headers};

      switch (method) {
        case HttpMethod.get:
          response = await get(
            uri,
            headers: combinedHeaders,
          ).timeout(const Duration(seconds: 30));
          break;
        case HttpMethod.post:
          response = await post(
            uri,
            headers: combinedHeaders,
            body: jsonEncode(body),
          ).timeout(const Duration(seconds: 30));
          break;
        case HttpMethod.put:
          response = await put(
            uri,
            headers: combinedHeaders,
            body: jsonEncode(body),
          ).timeout(const Duration(seconds: 30));
          break;
        case HttpMethod.delete:
          response = await delete(
            uri,
            headers: combinedHeaders,
          ).timeout(const Duration(seconds: 30));
          break;
      }

      return _handleResponse<T>(url, response);
    } on Exception catch (e) {
      return _handleException<T>(url, e);
    }
  }

  //! ========== Helpers ==========

  static ApiResponseUpdated<T> _handleResponse<T>(
    String url,
    Response response,
  ) {
    final int statusCode = response.statusCode;
    final dynamic decodedData = _safeDecode(response.body);

    if (statusCode >= 200 && statusCode < 300) {
      logger.i('✅ Success [$statusCode] $url');
      _logResponse(url: url, body: decodedData, statusCode: statusCode);
      return ApiResponseUpdated<T>(
        isSuccess: true,
        response: decodedData as T?,
        statusCode: statusCode,
      );
    } else {
      logger.w('⚠️ Failed [$statusCode] $url');
      _logResponse(
        url: url,
        body: decodedData,
        statusCode: statusCode,
        errorMessage: decodedData?['message'],
      );
      return ApiResponseUpdated<T>(
        isSuccess: false,
        response: decodedData as T?,
        statusCode: statusCode,
        errorMessage:
            decodedData is Map<String, dynamic> ? decodedData['message'] : null,
      );
    }
  }

  static ApiResponseUpdated<T> _handleException<T>(String url, Exception e) {
    String errorMessage = 'An error occurred';
    if (e is SocketException) {
      errorMessage = 'No Internet Connection';
    } else if (e is TimeoutException) {
      errorMessage = 'Request Timed Out';
    } else if (e is FormatException) {
      errorMessage = 'Invalid Response Format';
    } else {
      errorMessage = e.toString();
    }

    logger.e('❌ Exception $url => $errorMessage');
    _logResponse(
      url: url,
      body: null,
      statusCode: 0,
      errorMessage: errorMessage,
    );

    return ApiResponseUpdated<T>(
      isSuccess: false,
      response: null,
      statusCode: 0,
      errorMessage: errorMessage,
    );
  }

  static void _logRequest({required String url, Map<String, dynamic>? body}) {
    logger.d('➡️ Request URL: $url');
    if (body != null) {
      logger.d('➡️ Request Body: $body');
    }
  }

  static void _logResponse({
    required String url,
    required dynamic body,
    required int? statusCode,
    String? errorMessage,
  }) {
    logger.d('⬅️ Response URL: $url');
    if (body != null) {
      logger.d('⬅️ Response Body: $body');
    }
    if (statusCode != null) {
      logger.d('⬅️ Status Code: $statusCode');
    }
    if (errorMessage != null) {
      logger.e('⬅️ Error Message: $errorMessage');
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

class ApiResponseUpdated<T> {
  final bool isSuccess;
  final int statusCode;
  final T? response;
  final String? errorMessage;

  ApiResponseUpdated({
    required this.isSuccess,
    required this.statusCode,
    this.response,
    this.errorMessage,
  });
}
