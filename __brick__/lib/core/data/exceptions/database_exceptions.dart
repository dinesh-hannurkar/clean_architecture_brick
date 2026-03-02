/// Base exception for all database-related errors.
///
/// This is the parent class for all database exceptions in the application.
class DatabaseException implements Exception {
  const DatabaseException(this.message, [this.stackTrace]);

  final String message;
  final StackTrace? stackTrace;

  @override
  String toString() => 'DatabaseException: $message';
}

/// Exception thrown when database initialization fails.
class DatabaseInitializationException extends DatabaseException {
  const DatabaseInitializationException(super.message, [super.stackTrace]);

  @override
  String toString() => 'DatabaseInitializationException: $message';
}

/// Exception thrown when database migration fails.
class MigrationException extends DatabaseException {
  const MigrationException(
    String message, {
    this.fromVersion,
    this.toVersion,
    StackTrace? stackTrace,
  }) : super(message, stackTrace);

  final int? fromVersion;
  final int? toVersion;

  @override
  String toString() {
    final versionInfo = fromVersion != null && toVersion != null
        ? ' (from version $fromVersion to $toVersion)'
        : '';
    return 'MigrationException: $message$versionInfo';
  }
}

/// Exception thrown when secure storage operations fail.
class StorageException extends DatabaseException {
  const StorageException(super.message, [super.stackTrace]);

  @override
  String toString() => 'StorageException: $message';
}
