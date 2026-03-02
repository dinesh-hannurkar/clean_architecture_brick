import 'package:sqflite/sqflite.dart';

import 'package:{{project_name}}/core/data/exceptions/database_exceptions.dart';

/// Abstract base class for database migrations.
///
/// Each migration should extend this class and implement the [migrate] method.
abstract class Migration {
  const Migration();

  /// The version number this migration targets.
  int get version;

  /// Executes the migration.
  ///
  /// This method should contain all SQL statements needed to migrate
  /// the database to the target [version].
  ///
  /// Migrations must be idempotent - safe to run multiple times.
  Future<void> migrate(Database db);
}

/// Manages database migrations.
///
/// This class is responsible for executing migrations in order
/// and tracking which migrations have been applied.
class MigrationManager {
  const MigrationManager(this._migrations);

  final List<Migration> _migrations;

  /// Executes all pending migrations.
  ///
  /// Migrations are executed in order from [oldVersion] to [newVersion].
  /// If a migration fails, a [MigrationException] is thrown.
  Future<void> migrate(
    Database db, {
    required int oldVersion,
    required int newVersion,
  }) async {
    if (oldVersion >= newVersion) {
      return;
    }

    // Get migrations that need to be applied
    final pendingMigrations =
        _migrations
            .where((m) => m.version > oldVersion && m.version <= newVersion)
            .toList()
          ..sort((a, b) => a.version.compareTo(b.version));

    // Execute migrations in order
    for (final migration in pendingMigrations) {
      try {
        await migration.migrate(db);
      } catch (e, stackTrace) {
        throw MigrationException(
          'Failed to execute migration to version ${migration.version}: $e',
          fromVersion: oldVersion,
          toVersion: newVersion,
          stackTrace: stackTrace,
        );
      }
    }
  }

  /// Creates the initial database schema.
  ///
  /// This is called when the database is created for the first time.
  Future<void> onCreate(Database db, int version) async {
    // Execute all migrations up to the current version
    // Starting from version 0 to handle initial schema creation
    final allMigrations =
        _migrations.where((m) => m.version <= version).toList()
          ..sort((a, b) => a.version.compareTo(b.version));

    for (final migration in allMigrations) {
      try {
        await migration.migrate(db);
      } catch (e, stackTrace) {
        throw MigrationException(
          'Failed to create initial schema at version ${migration.version}: $e',
          fromVersion: 0,
          toVersion: version,
          stackTrace: stackTrace,
        );
      }
    }
  }
}

/// Migration to version 1 - Initial schema.
///
/// Creates the initial database tables for users and auth tokens.
/// Note: For the ephemeral-first approach, these tables may not be used
/// initially, but are created for future offline mode support.
class Migration1 extends Migration {
  const Migration1();

  @override
  int get version => 1;

  @override
  Future<void> migrate(Database db) async {
    // Create users table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id TEXT PRIMARY KEY,
        email TEXT NOT NULL,
        display_name TEXT,
        photo_url TEXT,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');

    // Create auth_tokens table (not used in ephemeral approach,
    // but created for consistency)
    await db.execute('''
      CREATE TABLE IF NOT EXISTS auth_tokens (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        access_token TEXT NOT NULL,
        refresh_token TEXT NOT NULL,
        expires_at INTEGER NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''');

    // Create indexes for better query performance
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_users_email ON users(email)
    ''');
  }
}
