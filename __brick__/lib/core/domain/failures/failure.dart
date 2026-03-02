import 'package:equatable/equatable.dart';

/// Base class for all failures in the domain layer.
///
/// Uses a sealed class pattern for exhaustive pattern matching.
/// All failures should extend this class and provide meaningful
/// error messages and codes.
abstract class Failure extends Equatable {
  /// Creates a [Failure] with the given [message] and [code].
  const Failure({required this.message, this.code});

  /// Human-readable error message.
  final String message;

  /// Optional error code for programmatic error handling.
  final String? code;

  @override
  List<Object?> get props => [message, code];
}

/// Failure due to network connectivity issues.
class NetworkFailure extends Failure {
  /// Creates a [NetworkFailure].
  const NetworkFailure({
    super.message = 'Network connection failed',
    super.code = 'NETWORK_ERROR',
  });
}

/// Failure due to server-side errors (5xx status codes).
class ServerFailure extends Failure {
  /// Creates a [ServerFailure].
  const ServerFailure({
    super.message = 'Server error occurred',
    super.code = 'SERVER_ERROR',
  });
}

/// Failure due to cache or local storage issues.
class CacheFailure extends Failure {
  /// Creates a [CacheFailure].
  const CacheFailure({
    super.message = 'Cache operation failed',
    super.code = 'CACHE_ERROR',
  });
}

/// Failure due to authentication or authorization issues.
class AuthenticationFailure extends Failure {
  /// Creates an [AuthenticationFailure].
  const AuthenticationFailure({
    super.message = 'Authentication failed',
    super.code = 'AUTH_ERROR',
  });
}

/// Failure due to validation errors (invalid input, business rule violations).
class ValidationFailure extends Failure {
  /// Creates a [ValidationFailure].
  const ValidationFailure({
    super.message = 'Validation failed',
    super.code = 'VALIDATION_ERROR',
  });
}

/// Failure for unknown or unexpected errors.
class UnknownFailure extends Failure {
  /// Creates an [UnknownFailure].
  const UnknownFailure({
    super.message = 'An unknown error occurred',
    super.code = 'UNKNOWN_ERROR',
  });
}

/// Failure due to request timeout.
class TimeoutFailure extends Failure {
  /// Creates a [TimeoutFailure].
  const TimeoutFailure({
    super.message =
        'Request timed out. Please check your internet connection and try again.',
    super.code = 'TIMEOUT_ERROR',
  });
}
