/// Exception thrown when a server error occurs (5xx status codes).
class ServerException implements Exception {
  /// Creates a [ServerException] with an optional [message].
  const ServerException([this.message]);

  /// Optional error message.
  final String? message;

  @override
  String toString() => 'ServerException: ${message ?? 'Server error occurred'}';
}

/// Exception thrown when a network connectivity issue occurs.
class NetworkException implements Exception {
  /// Creates a [NetworkException] with an optional [message].
  const NetworkException([this.message]);

  /// Optional error message.
  final String? message;

  @override
  String toString() =>
      'NetworkException: ${message ?? 'Network connection failed'}';
}

/// Exception thrown when a cache or local storage operation fails.
class CacheException implements Exception {
  /// Creates a [CacheException] with an optional [message].
  const CacheException([this.message]);

  /// Optional error message.
  final String? message;

  @override
  String toString() => 'CacheException: ${message ?? 'Cache operation failed'}';
}

/// Exception thrown when authentication or authorization fails (401/403).
class UnauthorizedException implements Exception {
  /// Creates an [UnauthorizedException] with an optional [message].
  const UnauthorizedException([this.message]);

  /// Optional error message.
  final String? message;

  @override
  String toString() =>
      'UnauthorizedException: ${message ?? 'Unauthorized access'}';
}

/// Exception thrown when data validation fails.
class ValidationException implements Exception {
  /// Creates a [ValidationException] with an optional [message].
  const ValidationException([this.message]);

  /// Optional error message.
  final String? message;

  @override
  String toString() =>
      'ValidationException: ${message ?? 'Data validation failed'}';
}

/// Exception thrown when a request times out.
class TimeoutException implements Exception {
  /// Creates a [TimeoutException] with an optional [message].
  const TimeoutException([this.message]);

  /// Optional error message.
  final String? message;

  @override
  String toString() => 'TimeoutException: ${message ?? 'Request timed out'}';
}
