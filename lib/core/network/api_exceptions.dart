import 'package:dio/dio.dart';

class ApiException implements Exception {
  late String message;
  final int? statusCode;

  ApiException.fromDioException(DioException dioException)
      : statusCode = dioException.response?.statusCode {
    switch (dioException.type) {
      case DioExceptionType.cancel:
        message = "Request to API server was cancelled.";
        break;
      case DioExceptionType.connectionTimeout:
        message = "Connection timeout with API server.";
        break;
      case DioExceptionType.receiveTimeout:
        message = "Receive timeout in connection with API server.";
        break;
      case DioExceptionType.sendTimeout:
        message = "Send timeout in connection with API server.";
        break;
      case DioExceptionType.badResponse:
        message = _handleError(
          dioException.response?.statusCode,
          dioException.response?.data,
        );
        break;
      case DioExceptionType.badCertificate:
        message = "Bad SSL certificate.";
        break;
      case DioExceptionType.connectionError:
        message = "No internet connection. Please check your network.";
        break;
      case DioExceptionType.unknown:
      default:
        if (dioException.error != null) {
          message = dioException.error.toString();
        } else {
          message = "Something went wrong. Please try again.";
        }
        break;
    }
  }

  String _handleError(int? statusCode, dynamic error) {
    if (error != null) {
      try {
        if (error is Map) {
          // 1. Try to extract specific validation errors first
          if (error.containsKey('errors') && error['errors'] != null) {
            final errorsVal = error['errors'];
            if (errorsVal is List && errorsVal.isNotEmpty) {
              return errorsVal.map((e) => e.toString()).join('\n');
            } else if (errorsVal is Map && errorsVal.isNotEmpty) {
              final List<String> messages = [];
              errorsVal.forEach((key, value) {
                if (value is List) {
                  messages.addAll(value.map((e) => e.toString()));
                } else {
                  messages.add(value.toString());
                }
              });
              if (messages.isNotEmpty) {
                return messages.join('\n');
              }
            }
          }

          // 2. Try to extract message, but ignore if it's generic "Validation error"
          if (error.containsKey('message') && error['message'] != null) {
            final msg = error['message'].toString().trim();
            if (msg.isNotEmpty && msg.toLowerCase() != "validation error") {
              return msg;
            }
          }

          if (error.containsKey('error') && error['error'] != null) {
            final msg = error['error'].toString().trim();
            if (msg.isNotEmpty) return msg;
          }

          // Fallback to message if it was "Validation error" but no specific errors found
          if (error.containsKey('message') && error['message'] != null) {
            final msg = error['message'].toString().trim();
            if (msg.isNotEmpty) return msg;
          }
        } else if (error is String) {
          final trimmed = error.trim();
          if (trimmed.isNotEmpty) return trimmed;
        }
      } catch (_) {}
    }

    switch (statusCode) {
      case 400:
        return "Incorrect email or password. Please try again.";
      case 401:
        return "Incorrect email or password. Please try again.";
      case 403:
        return "Access denied. You do not have permission to perform this action.";
      case 404:
        return "Requested resource not found. Please try again later.";
      case 422:
        return "Validation failed (422). Please verify the submitted data.";
      case 500:
        return "Internal server error. Our servers are experiencing issues, please try again later.";
      case 502:
        return "Bad gateway. Please try again later.";
      default:
        return "Something went wrong (Error Code: ${statusCode ?? 'Unknown'}).";
    }
  }

  @override
  String toString() => message;
}
