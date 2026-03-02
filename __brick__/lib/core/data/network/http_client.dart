import 'dart:io' as io;
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:{{project_name}}/core/config/app_config.dart';
import 'package:{{project_name}}/core/data/exceptions/exceptions.dart';

/// HTTP client wrapper for Dio with configured interceptors.
///
/// Provides centralized configuration for all HTTP requests including:
/// - Base URL
/// - Timeouts
/// - Authentication token injection
/// - Error response handling
/// - Request/response logging
class HttpClient {
  /// Creates an [HttpClient] with the given [baseUrl].
  HttpClient({required String baseUrl, String? authToken})
    : _authToken = authToken {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 60),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _setupInterceptors();
    _setupSSLBypass();
  }

  void _setupSSLBypass() {
    if (AppConfig.appEnv == 'dev') {
      _dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final client = io.HttpClient();
          client.badCertificateCallback =
              (io.X509Certificate cert, String host, int port) => true;
          return client;
        },
      );
    }
  }

  late final Dio _dio;
  String? _authToken;

  /// Gets the underlying Dio instance.
  Dio get dio => _dio;

  /// Updates the authentication token for future requests.
  void setAuthToken(String? token) {
    _authToken = token;
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Inject auth token if available
          if (_authToken != null) {
            final authPrefix =
                options.extra['auth_prefix'] as String? ?? 'Bearer';
            options.headers['Authorization'] = '$authPrefix $_authToken';
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          // Convert DioException to data layer exceptions
          final exception = _handleError(error);
          return handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              error: exception,
              response: error.response,
              type: error.type,
            ),
          );
        },
      ),
    );

    // Add logging interceptor
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => print('🌐 $obj'), // Prefix specifically for API logs
      ),
    );
  }

  Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException(
          'The request timed out. Please try again.',
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode != null) {
          if (statusCode == 401 || statusCode == 403) {
            return UnauthorizedException(
              _getErrorMessage(error.response?.data),
            );
          } else if (statusCode >= 500) {
            return ServerException(_getErrorMessage(error.response?.data));
          } else if (statusCode >= 400) {
            return ValidationException(_getErrorMessage(error.response?.data));
          }
        }
        return ServerException('Bad response: ${error.message}');

      case DioExceptionType.cancel:
        return const NetworkException('Request cancelled');

      case DioExceptionType.badCertificate:
        return const NetworkException('Bad certificate');

      case DioExceptionType.connectionError:
        return const NetworkException('Connection error');

      case DioExceptionType.unknown:
        print(error);
        return NetworkException(error.message ?? 'Unknown error');
    }
  }

  String? _getErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data.containsKey('detail')) {
        return data['detail'].toString();
      }
      if (data.containsKey('message')) {
        return data['message'].toString();
      }
      if (data.containsKey('error')) {
        return data['error'].toString();
      }
      if (data.containsKey('non_field_errors')) {
        return data['non_field_errors'].toString();
      }
      if (data.containsKey('msg')) {
        return data['msg'].toString();
      }
    }
    return data?.toString();
  }
}
