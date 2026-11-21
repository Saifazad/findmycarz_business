import 'dart:convert';
import 'dart:developer' as dev;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_config.dart';
import 'api_exceptions.dart';

class DioClient {
  late final Dio _dio;

  // Singleton instance
  static final DioClient _instance = DioClient._internal();

  factory DioClient() => _instance;

  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(milliseconds: ApiConfig.connectTimeout),
        receiveTimeout: const Duration(milliseconds: ApiConfig.receiveTimeout),
        responseType: ResponseType.json,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Dynamic Auth Token Interceptor (Bearer Token - Laravel Sanctum)
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          try {
            final prefs = await SharedPreferences.getInstance();
            final token = prefs.getString('business_auth_token');
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          } catch (_) {}
          return handler.next(options);
        },
      ),
    );

    // Logging Interceptor for debugging in development mode
    if (kDebugMode) {
      _dio.interceptors.add(VMDeveloperLogInterceptor());
    }
  }

  // GET Request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // POST Request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // PUT Request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // DELETE Request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}

class VMDeveloperLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final String requestPath = "${options.baseUrl}${options.path}";
    final StringBuffer logBuffer = StringBuffer();
    logBuffer.writeln("--> [API REQUEST] ${options.method} $requestPath");
    if (options.queryParameters.isNotEmpty) {
      logBuffer.writeln("   Query Params: ${options.queryParameters}");
    }
    if (options.data != null) {
      try {
        final prettyJson = const JsonEncoder.withIndent('  ').convert(options.data);
        logBuffer.writeln("   Payload:\n$prettyJson");
      } catch (_) {
        logBuffer.writeln("   Payload: ${options.data}");
      }
    }
    dev.log(
      logBuffer.toString().trim(),
      name: "API_CLIENT",
      time: DateTime.now(),
    );
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final String requestPath =
        "${response.requestOptions.baseUrl}${response.requestOptions.path}";
    final StringBuffer logBuffer = StringBuffer();
    logBuffer.writeln("<-- [API RESPONSE] ${response.requestOptions.method} $requestPath");
    logBuffer.writeln("   Status Code: ${response.statusCode}");
    if (response.data != null) {
      try {
        final prettyJson = const JsonEncoder.withIndent('  ').convert(response.data);
        logBuffer.writeln("   Body:\n$prettyJson");
      } catch (_) {
        logBuffer.writeln("   Body: ${response.data}");
      }
    }
    dev.log(
      logBuffer.toString().trim(),
      name: "API_CLIENT",
      time: DateTime.now(),
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final String requestPath =
        "${err.requestOptions.baseUrl}${err.requestOptions.path}";
    final response = err.response;
    final StringBuffer logBuffer = StringBuffer();
    logBuffer.writeln("[API ERROR] ${err.requestOptions.method} $requestPath");
    logBuffer.writeln("   Status Code: ${response?.statusCode}");
    logBuffer.writeln("   Message: ${err.message}");
    if (response?.data != null) {
      try {
        final prettyJson = const JsonEncoder.withIndent('  ').convert(response?.data);
        logBuffer.writeln("   Error Body:\n$prettyJson");
      } catch (_) {
        logBuffer.writeln("   Error Body: ${response?.data}");
      }
    }
    dev.log(
      logBuffer.toString().trim(),
      name: "API_CLIENT",
      time: DateTime.now(),
      error: err,
    );
    super.onError(err, handler);
  }
}
