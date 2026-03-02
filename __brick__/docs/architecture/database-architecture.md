# Database Architecture

**Last Updated:** 2026-01-23  
**Author:** Database Engineer  
**Status:** Implementation Complete

## Overview

Project App follows an **ephemeral-first** persistence philosophy, where the remote server is the primary source of truth, and local persistence is used sparingly and conditionally.

The database layer is designed to support future offline mode while currently prioritizing secure token storage for authentication.

## Persistence Philosophy

### Source of Truth
- **Primary:** Remote server
- **Local:** Ephemeral cache only
- **Persistent:** Only when offline mode is mandated

### Current Implementation (Authentication)
The authentication feature uses **secure storage only** for tokens:
- ✅ `AuthToken` stored in encrypted secure storage
- ❌ `User` data NOT cached (ephemeral, fetched from server)
- ✅ No SQLite database used for auth (future: offline mode)

This approach aligns with the project's ephemeral-first philosophy and minimizes local state.

---

## Architecture Components

### 1. Secure Storage Service

**Location:** `lib/core/data/storage/secure_storage_service.dart`

Wrapper around `flutter_secure_storage` for platform-specific encrypted storage:

| Platform | Storage Mechanism |
|----------|-------------------|
| iOS | Keychain |
| Android | EncryptedSharedPreferences |
| macOS | Keychain |
| Linux | libsecret |
| Windows | Credential Store |

**Interface:**
```dart
abstract class SecureStorageService {
  Future<Either<Failure, void>> write({required String key, required String value});
  Future<Either<Failure, String?>> read({required String key});
  Future<Either<Failure, void>> delete({required String key});
  Future<Either<Failure, void>> deleteAll();
  Future<Either<Failure, bool>> containsKey({required String key});
}
```

**Storage Keys:**
- `auth_token_json` - Complete AuthToken as JSON

---

### 2. SQLite Database (Conditional)

**Location:** `lib/core/data/database/`

SQLite database infrastructure for future offline mode support. Currently created but not actively used by the authentication feature.

#### Database Helper

**File:** `database_helper.dart`

Singleton class for managing SQLite database:
- Database initialization and version management
- Migration execution
- CRUD operations with `Either<Failure, T>` error handling
- Transaction support
- Async operations

**Key Methods:**
```dart
Future<Either<Failure, Database>> get database;
Future<Either<Failure, List<Map<String, dynamic>>>> query(...);
Future<Either<Failure, int>> insert(...);
Future<Either<Failure, int>> update(...);
Future<Either<Failure, int>> delete(...);
Future<Either<Failure, T>> transaction<T>(...);
```

#### Database Configuration

**File:** `database_config.dart`

Constants for database setup:
- Database name: `app.db`
- Current version: `1`
- Table names (users, auth_tokens)

#### Migration Framework

**File:** `migrations.dart`

Structured migration system:
- Abstract `Migration` base class
- `MigrationManager` for executing migrations
- Version tracking
- Idempotent migrations

**Current Migrations:**
- **Migration1:** Initial schema (users + auth_tokens tables)

---

### 3. Auth Local Data Source

**Location:** `lib/features/auth/data/datasources/auth_local_data_source.dart`

Handles local persistence of authentication data using secure storage (NOT SQLite).

**Interface:**
```dart
abstract class AuthLocalDataSource {
  Future<Either<Failure, void>> saveAuthToken(AuthTokenModel token);
  Future<Either<Failure, AuthTokenModel>> getAuthToken();
  Future<Either<Failure, void>> deleteAuthToken();
  Future<Either<Failure, bool>> hasAuthToken();
}
```

**Implementation Details:**
- Stores `AuthToken` as JSON in secure storage
- Uses `SecureStorageKeys.authTokenJson` key
- Returns `AuthenticationFailure` when token not found
- Returns `CacheFailure` for storage errors

---

## Error Handling

### Exception Types

**File:** `lib/core/data/exceptions/database_exceptions.dart`

| Exception | Used For |
|-----------|----------|
| `DatabaseException` | Base exception for all database errors |
| `DatabaseInitializationException` | Database init failures |
| `MigrationException` | Migration execution failures |
| `StorageException` | Secure storage failures |

### Failure Mapping

Database exceptions are converted to domain failures:
- `DatabaseException` → `CacheFailure`
- Storage errors → `CacheFailure` or `AuthenticationFailure`

---

## Testing Strategy

### Unit Tests

All database components have comprehensive test coverage:

**Secure Storage Service:** 11 tests
- ✅ Write operations (success + failure)
- ✅ Read operations (success + failure + null)
- ✅ Delete operations (single + all)
- ✅ Key existence checks

**Auth Local Data Source:** 11 tests
- ✅ Save token (success + failure)
- ✅ Get token (success + not found + parse error + read failure)
- ✅ Delete token (success + failure)
- ✅ Has token (true + false + failure)

**Total:** 23 tests, 100% passing

### Test Location

```
test/
├── core/
│   └── data/
│       └── storage/
│           └── secure_storage_service_test.dart
└── features/
    └── auth/
        └── data/
            └── datasources/
                └── auth_local_data_source_test.dart
```

---

## Usage Examples

### Saving an Auth Token

```dart
final dataSource = AuthLocalDataSourceImpl(secureStorage);

final token = AuthTokenModel(
  accessToken: 'abc123',
  refreshToken: 'xyz789',
  expiresAt: DateTime.now().add(Duration(hours: 1)),
);

final result = await dataSource.saveAuthToken(token);

result.fold(
  (failure) => print('Failed to save token: ${failure.message}'),
  (_) => print('Token saved successfully'),
);
```

### Retrieving an Auth Token

```dart
final result = await dataSource.getAuthToken();

result.fold(
  (failure) {
    if (failure is AuthenticationFailure) {
      // No token found or invalid
      print('Not authenticated');
    } else {
      // Storage error
      print('Storage error: ${failure.message}');
    }
  },
  (token) {
    if (token.isValid) {
      // Use the token
      print('Token is valid until ${token.expiresAt}');
    } else {
      // Token expired
      print('Token expired');
    }
  },
);
```

### Clearing Auth Data on Logout

```dart
final result = await dataSource.deleteAuthToken();

result.fold(
  (failure) => print('Failed to clear token: ${failure.message}'),
  (_) => print('Token cleared successfully'),
);
```

---

## Security Considerations

### Encryption

- ✅ All auth tokens stored in **encrypted** secure storage
- ✅ Platform-specific encryption (Keychain, EncryptedSharedPreferences, etc.)
- ✅ No sensitive data in plain text

### Data Leakage Prevention

- ❌ No sensitive data in logs
- ❌ No tokens in SQLite (using secure storage instead)
- ✅ Secure storage automatically handles encryption

### Token Expiration

- Tokens include `expiresAt` timestamp
- `AuthToken` entity has `isValid` and `isExpired` getters
- Application should check validity before using tokens

---

## Future Enhancements

### Offline Mode Support

When offline mode is implemented:

1. **Enable SQLite caching**
   - Cache `User` entities in SQLite
   - Implement local data source for user data
   - Sync strategy for remote/local data

2. **Migration to Version 2**
   - Add sync metadata columns
   - Add last_sync timestamps
   - Add offline queue tables

3. **Conflict Resolution**
   - Define merge strategies
   - Implement sync queue
   - Handle network recovery

### Database Encryption

For sensitive offline data:
- Consider using `sqflite_sqlcipher` for database-level encryption
- Implement encryption key management
- Secure database file access

---

## Performance Considerations

### Current Approach (Secure Storage Only)

✅ **Advantages:**
- Very fast (no database overhead)
- Simple implementation
- Minimal storage footprint
- Platform-optimized encryption

❌ **Limitations:**
- No offline support for user data
- No caching for repeated fetches

### Future SQLite Approach

✅ **Advantages:**
- Offline data access
- Complex queries support
- Relational data storage

❌ **Considerations:**
- Database initialization overhead
- Migration management complexity
- Encryption adds overhead

---

## Migration Strategy

### Version Management

Migrations are idempotent and version-tracked:

1. Update `DatabaseConfig.databaseVersion`
2. Create new `MigrationX` class extending `Migration`
3. Add migration to `MigrationManager` list
4. Test migration up/down paths

### Example: Adding a New Table (Migration 2)

```dart
class Migration2 extends Migration {
  const Migration2();

  @override
  int get version => 2;

  @override
  Future<void> migrate(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS sync_queue (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        entity_type TEXT NOT NULL,
        entity_id TEXT NOT NULL,
        operation TEXT NOT NULL,
        data TEXT NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_sync_queue_entity 
      ON sync_queue(entity_type, entity_id)
    ''');
  }
}
```

Then add to `MigrationManager`:
```dart
final _migrationManager = const MigrationManager([
  Migration1(),
  Migration2(), // Add new migration
]);
```

---

## Best Practices

### ✅ DO

- Use secure storage for sensitive credentials
- Follow ephemeral-first philosophy
- Implement proper error handling with `Either`
- Write comprehensive tests
- Create idempotent migrations
- Document schema changes

### ❌ DON'T

- Store sensitive data in SQLite without encryption
- Cache data unnecessarily
- Skip migration testing
- Use direct SQL in UI layer
- Throw exceptions for expected failures
- Mix persistence strategies without justification

---

## Troubleshooting

### Common Issues

**Issue:** "No auth token found"
- **Cause:** User not logged in or token deleted
- **Solution:** Redirect to login screen

**Issue:** "Token parse failed"
- **Cause:** Corrupted token data in secure storage
- **Solution:** Delete corrupted token, force re-login

**Issue:** "Database initialization failed"
- **Cause:** Migration failure or file permissions
- **Solution:** Check migration logic, verify file permissions

### Debugging

Enable database logging:
```dart
// In development only
if (kDebugMode) {
  await Sqflite.setDebugModeOn(true);
}
```

---

## References

- [Project Overview](file:///Users/dineshhannurkar/Development/app/docs/project/project-overview.yaml)
- [Domain Layer Architecture](file:///Users/dineshhannurkar/Development/app/docs/architecture/domain-layer.md)
- [DTO Conventions](file:///Users/dineshhannurkar/Development/app/docs/api/dto-conventions.md)
- [flutter_secure_storage Documentation](https://pub.dev/packages/flutter_secure_storage)
- [sqflite Documentation](https://pub.dev/packages/sqflite)
