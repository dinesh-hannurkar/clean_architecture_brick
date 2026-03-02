import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fpdart/fpdart.dart';
import 'package:{{project_name}}/core/domain/failures/failure.dart';

/// Secure storage keys for sensitive data.
class SecureStorageKeys {
  const SecureStorageKeys._();

  /// Key for storing the access token
  static const String accessToken = 'auth_access_token';

  /// Key for storing the refresh token
  static const String refreshToken = 'auth_refresh_token';

  /// Key for storing the token expiration timestamp
  static const String tokenExpiresAt = 'auth_token_expires_at';

  /// Key for storing the auth token as JSON (alternative approach)
  static const String authTokenJson = 'auth_token_json';

  /// Key for storing the user model as JSON.
  static const String userJson = 'auth_user_json';
}

/// Abstract interface for secure storage operations.
///
/// This interface defines the contract for secure storage services
/// that handle sensitive data like authentication tokens.
abstract class SecureStorageService {
  /// Writes a value to secure storage.
  Future<Either<Failure, void>> write({
    required String key,
    required String value,
  });

  /// Reads a value from secure storage.
  ///
  /// Returns `null` if the key doesn't exist.
  Future<Either<Failure, String?>> read({required String key});

  /// Deletes a value from secure storage.
  Future<Either<Failure, void>> delete({required String key});

  /// Deletes all values from secure storage.
  Future<Either<Failure, void>> deleteAll();

  /// Checks if a key exists in secure storage.
  Future<Either<Failure, bool>> containsKey({required String key});
}

/// Implementation of [SecureStorageService] using flutter_secure_storage.
///
/// This implementation provides encrypted storage for sensitive data
/// using platform-specific secure storage mechanisms:
/// - iOS: Keychain
/// - Android: EncryptedSharedPreferences
/// - macOS: Keychain
/// - Linux: libsecret
/// - Windows: Credential Store
class SecureStorageServiceImpl implements SecureStorageService {
  SecureStorageServiceImpl({FlutterSecureStorage? secureStorage})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _secureStorage;

  @override
  Future<Either<Failure, void>> write({
    required String key,
    required String value,
  }) async {
    try {
      await _secureStorage.write(key: key, value: value);
      return right(null);
    } catch (e) {
      return left(
        CacheFailure(
          message: 'Failed to write to secure storage: $e',
          code: 'SECURE_STORAGE_WRITE_FAILED',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, String?>> read({required String key}) async {
    try {
      final value = await _secureStorage.read(key: key);
      return right(value);
    } catch (e) {
      return left(
        CacheFailure(
          message: 'Failed to read from secure storage: $e',
          code: 'SECURE_STORAGE_READ_FAILED',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> delete({required String key}) async {
    try {
      await _secureStorage.delete(key: key);
      return right(null);
    } catch (e) {
      return left(
        CacheFailure(
          message: 'Failed to delete from secure storage: $e',
          code: 'SECURE_STORAGE_DELETE_FAILED',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteAll() async {
    try {
      await _secureStorage.deleteAll();
      return right(null);
    } catch (e) {
      return left(
        CacheFailure(
          message: 'Failed to delete all from secure storage: $e',
          code: 'SECURE_STORAGE_DELETE_ALL_FAILED',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> containsKey({required String key}) async {
    try {
      final value = await _secureStorage.containsKey(key: key);
      return right(value);
    } catch (e) {
      return left(
        CacheFailure(
          message: 'Failed to check key in secure storage: $e',
          code: 'SECURE_STORAGE_CONTAINS_KEY_FAILED',
        ),
      );
    }
  }
}
