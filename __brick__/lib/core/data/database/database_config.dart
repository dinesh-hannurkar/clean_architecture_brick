import 'package:sqflite/sqflite.dart';

/// Database configuration constants for Project App.
///
/// This file contains all database-related configuration including
/// database name, version, and table names.
class DatabaseConfig {
  const DatabaseConfig._();

  /// Database name
  static const String databaseName = 'app.db';

  /// Current database version
  ///
  /// Increment this when schema changes are made to trigger migrations.
  static const int databaseVersion = 1;

  /// Table names
  static const String userTable = 'users';
  static const String authTokenTable = 'auth_tokens';

  /// Database file path helper
  ///
  /// Returns the full path to the database file.
  /// Uses the sqflite getDatabasesPath() function.
  static Future<String> get databasePath async {
    final path = await getDatabasesPath();
    return '$path/$databaseName';
  }
}
