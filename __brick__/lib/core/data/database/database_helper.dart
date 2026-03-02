import 'package:fpdart/fpdart.dart';
import 'package:sqflite/sqflite.dart';
import 'package:{{project_name}}/core/data/database/database_config.dart';
import 'package:{{project_name}}/core/data/database/migrations.dart';
import 'package:{{project_name}}/core/data/exceptions/database_exceptions.dart';
import 'package:{{project_name}}/core/domain/failures/failure.dart';

/// Singleton helper class for managing the SQLite database.
///
/// This class provides a single point of access to the database
/// and handles initialization, migrations, and transactions.
///
/// Note: For Project App's ephemeral-first approach, this database
/// is primarily used for offline mode. Authentication uses secure storage.
class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  Database? _database;

  /// Migration manager with all migrations
  final _migrationManager = const MigrationManager([Migration1()]);

  /// Gets the database instance, initializing it if necessary.
  Future<Either<Failure, Database>> get database async {
    if (_database != null) {
      return right(_database!);
    }

    try {
      _database = await _initDatabase();
      return right(_database!);
    } on DatabaseInitializationException catch (e) {
      return left(
        CacheFailure(
          message: 'Failed to initialize database: ${e.message}',
          code: 'DATABASE_INIT_FAILED',
        ),
      );
    } catch (e) {
      return left(
        CacheFailure(
          message: 'Unexpected database error: $e',
          code: 'DATABASE_ERROR',
        ),
      );
    }
  }

  /// Initializes the database.
  Future<Database> _initDatabase() async {
    try {
      final path = await DatabaseConfig.databasePath;

      return await openDatabase(
        path,
        version: DatabaseConfig.databaseVersion,
        onCreate: _migrationManager.onCreate,
        onUpgrade: (db, oldVersion, newVersion) async {
          await _migrationManager.migrate(
            db,
            oldVersion: oldVersion,
            newVersion: newVersion,
          );
        },
        // Enable foreign keys
        onConfigure: (db) async {
          await db.execute('PRAGMA foreign_keys = ON');
        },
      );
    } catch (e, stackTrace) {
      throw DatabaseInitializationException(
        'Failed to initialize database: $e',
        stackTrace,
      );
    }
  }

  /// Executes a query and returns the result.
  Future<Either<Failure, List<Map<String, dynamic>>>> query(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final dbResult = await database;

    return dbResult.fold(left, (db) async {
      try {
        final result = await db.query(
          table,
          distinct: distinct,
          columns: columns,
          where: where,
          whereArgs: whereArgs,
          groupBy: groupBy,
          having: having,
          orderBy: orderBy,
          limit: limit,
          offset: offset,
        );
        return right(result);
      } catch (e) {
        return left(
          CacheFailure(message: 'Query failed: $e', code: 'QUERY_FAILED'),
        );
      }
    });
  }

  /// Inserts a row into the database.
  Future<Either<Failure, int>> insert(
    String table,
    Map<String, Object?> values, {
    ConflictAlgorithm? conflictAlgorithm,
  }) async {
    final dbResult = await database;

    return dbResult.fold(left, (db) async {
      try {
        final id = await db.insert(
          table,
          values,
          conflictAlgorithm: conflictAlgorithm,
        );
        return right(id);
      } catch (e) {
        return left(
          CacheFailure(message: 'Insert failed: $e', code: 'INSERT_FAILED'),
        );
      }
    });
  }

  /// Updates rows in the database.
  Future<Either<Failure, int>> update(
    String table,
    Map<String, Object?> values, {
    String? where,
    List<Object?>? whereArgs,
    ConflictAlgorithm? conflictAlgorithm,
  }) async {
    final dbResult = await database;

    return dbResult.fold(left, (db) async {
      try {
        final count = await db.update(
          table,
          values,
          where: where,
          whereArgs: whereArgs,
          conflictAlgorithm: conflictAlgorithm,
        );
        return right(count);
      } catch (e) {
        return left(
          CacheFailure(message: 'Update failed: $e', code: 'UPDATE_FAILED'),
        );
      }
    });
  }

  /// Deletes rows from the database.
  Future<Either<Failure, int>> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final dbResult = await database;

    return dbResult.fold(left, (db) async {
      try {
        final count = await db.delete(
          table,
          where: where,
          whereArgs: whereArgs,
        );
        return right(count);
      } catch (e) {
        return left(
          CacheFailure(message: 'Delete failed: $e', code: 'DELETE_FAILED'),
        );
      }
    });
  }

  /// Executes a raw SQL query.
  Future<Either<Failure, List<Map<String, dynamic>>>> rawQuery(
    String sql, [
    List<Object?>? arguments,
  ]) async {
    final dbResult = await database;

    return dbResult.fold(left, (db) async {
      try {
        final result = await db.rawQuery(sql, arguments);
        return right(result);
      } catch (e) {
        return left(
          CacheFailure(
            message: 'Raw query failed: $e',
            code: 'RAW_QUERY_FAILED',
          ),
        );
      }
    });
  }

  /// Executes a transaction.
  Future<Either<Failure, T>> transaction<T>(
    Future<T> Function(Transaction txn) action,
  ) async {
    final dbResult = await database;

    return dbResult.fold(left, (db) async {
      try {
        final result = await db.transaction(action);
        return right(result);
      } catch (e) {
        return left(
          CacheFailure(
            message: 'Transaction failed: $e',
            code: 'TRANSACTION_FAILED',
          ),
        );
      }
    });
  }

  /// Closes the database connection.
  Future<Either<Failure, void>> close() async {
    if (_database == null) {
      return right(null);
    }

    try {
      await _database!.close();
      _database = null;
      return right(null);
    } catch (e) {
      return left(
        CacheFailure(
          message: 'Failed to close database: $e',
          code: 'CLOSE_FAILED',
        ),
      );
    }
  }

  /// Deletes the database file.
  ///
  /// This is useful for testing or when the user wants to clear all local data.
  Future<Either<Failure, void>> deleteDatabase() async {
    try {
      await close();
      final path = await DatabaseConfig.databasePath;
      await databaseFactory.deleteDatabase(path);
      return right(null);
    } catch (e) {
      return left(
        CacheFailure(
          message: 'Failed to delete database: $e',
          code: 'DELETE_DATABASE_FAILED',
        ),
      );
    }
  }
}
