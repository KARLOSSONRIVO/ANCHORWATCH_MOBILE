import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'dart:io';

@lazySingleton
class DioClient {
  static String get _baseUrl {
    if (kIsWeb) {
      return 'http://127.0.0.1:8000'; // Web can use localhost directly
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000'; // Android emulator special IP
    } else if (Platform.isIOS) {
      return 'http://127.0.0.1:8000'; // iOS simulator uses localhost
    } else {
      return 'http://127.0.0.1:8000'; // Default for other platforms
    }
  }

  static Future<String> getPhysicalDeviceBaseUrl() async {
    try {
      for (var interface in await NetworkInterface.list()) {
        for (var addr in interface.addresses) {
          if (addr.type == InternetAddressType.IPv4 &&
              !addr.isLoopback &&
              addr.address.startsWith('192.168.')) {
            return 'http://${addr.address}:8000';
          }
        }
      }
      return 'http://127.0.0.1:8000';
    } catch (e) {
      return 'http://127.0.0.1:8000';
    }
  }

  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(
          minutes: 8,
        ), // Increased for LLM responses
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          handler.next(options);
        },
        onResponse: (response, handler) {
          handler.next(response);
        },
        onError: (error, handler) {
          handler.next(error);
        },
      ),
    );
  }

  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Exception _handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return NetworkException(
          'Connection timeout. Please check your internet connection.',
        );
      case DioExceptionType.sendTimeout:
        return NetworkException(
          'Send timeout. Please check your internet connection.',
        );
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          'Receive timeout. Please check your internet connection.',
        );
      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response);
      case DioExceptionType.cancel:
        return NetworkException('Request was cancelled.');
      case DioExceptionType.connectionError:
        return NetworkException(
          'Connection error. Please check your internet connection.',
        );
      case DioExceptionType.unknown:
        return NetworkException('Unknown error occurred: ${error.message}');
      default:
        return NetworkException('Network error occurred.');
    }
  }

  Exception _handleBadResponse(Response? response) {
    if (response == null) {
      return ServerException('Server error occurred.');
    }
    String? errorMessage;
    if (response.data != null) {
      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        // Handle different error field types safely
        if (data['error'] is String) {
          errorMessage = data['error'] as String;
        } else if (data['error'] is bool && data['error'] == true) {
          // If error is true, use the message field instead
          errorMessage = data['message'] as String?;
        } else {
          errorMessage = data['message'] ?? data['detail'];
        }
      } else if (response.data is String) {
        errorMessage = response.data as String;
      }
    }

    // Check for rate limiting in any response (regardless of status code)
    if (response.data != null &&
        response.data is Map<String, dynamic> &&
        response.data['retry_after_seconds'] != null) {
      // This is a rate limiting error, include the retry time in the message
      final retrySeconds = response.data['retry_after_seconds'] as int;
      final formattedTime = _formatTimeRemaining(retrySeconds);
      return BadRequestException(
        'Please wait $formattedTime before sending another message.',
      );
    }

    switch (response.statusCode) {
      case 400:
        return BadRequestException(errorMessage ?? 'Bad request.');
      case 401:
        return UnauthorizedException(errorMessage ?? 'Invalid credentials.');
      case 403:
        return ForbiddenException(errorMessage ?? 'Access forbidden.');
      case 404:
        return NotFoundException(errorMessage ?? 'Resource not found.');
      case 409:
        return ConflictException(errorMessage ?? 'Conflict occurred.');
      case 500:
        return ServerException(errorMessage ?? 'Internal server error.');
      default:
        return ServerException(
          errorMessage ??
              'Server error with status code: ${response.statusCode}',
        );
    }
  }

  String _formatTimeRemaining(int seconds) {
    if (seconds < 60) {
      return '$seconds seconds';
    } else if (seconds < 3600) {
      final minutes = (seconds / 60).ceil();
      return '$minutes minute${minutes == 1 ? '' : 's'}';
    } else {
      final hours = (seconds / 3600).floor();
      final minutes = ((seconds % 3600) / 60).ceil();
      if (minutes == 0) {
        return '$hours hour${hours == 1 ? '' : 's'}';
      } else {
        return '$hours hour${hours == 1 ? '' : 's'} $minutes minute${minutes == 1 ? '' : 's'}';
      }
    }
  }
}

abstract class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException(super.message);
}

class ServerException extends AppException {
  const ServerException(super.message);
}

class BadRequestException extends AppException {
  const BadRequestException(super.message);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException(super.message);
}

class ForbiddenException extends AppException {
  const ForbiddenException(super.message);
}

class NotFoundException extends AppException {
  const NotFoundException(super.message);
}

class ConflictException extends AppException {
  const ConflictException(super.message);
}
