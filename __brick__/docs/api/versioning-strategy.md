# API Versioning Strategy

## Overview

Project App follows a **strict versioning policy** to ensure:
- **Backward compatibility** for existing clients
- **Smooth migration** to new API versions
- **Clear deprecation** timelines
- **Zero breaking changes** without version bumps

## Versioning Scheme

We use **semantic versioning** for API contracts:
- **MAJOR**: Breaking changes (incompatible API changes)
- **MINOR**: New features (backward-compatible additions)
- **PATCH**: Bug fixes (backward-compatible fixes)

**Format:** `v{MAJOR}.{MINOR}.{PATCH}`

**Examples:**
- `v1.0.0` - Initial release
- `v1.1.0` - Added new endpoints (backward-compatible)
- `v2.0.0` - Breaking changes (incompatible with v1.x)

## Version Specification

### In Repository Interfaces

Repository interfaces define the contract version:

```dart
/// Authentication repository following API v1.0 contract.
///
/// Contract Version: v1.0.0
/// Last Updated: 2026-01-23
abstract class AuthRepository {
  Future<Either<Failure, User>> signInWithGoogle();
}
```

### In API Clients (Data Layer)

Specify API version in HTTP headers or URL:

```dart
class AuthRepositoryImpl implements AuthRepository {
  static const String apiVersion = 'v1';
  
  Future<Either<Failure, User>> signInWithGoogle() async {
    final response = await _dio.post(
      '/api/$apiVersion/auth/google-signin',
      options: Options(headers: {'API-Version': apiVersion}),
    );
    // ...
  }
}
```

## Breaking Changes Policy

### What Constitutes a Breaking Change?

**Breaking Changes (Require MAJOR version bump):**
- Removing endpoints
- Removing required fields from responses
- Adding required fields to requests
- Changing field types (String → Int)
- Changing field names
- Changing authentication mechanism
- Changing error response structure

**Non-Breaking Changes (MINOR/PATCH version):**
- Adding new endpoints
- Adding optional fields to requests
- Adding new fields to responses
- Adding new error codes
- Deprecating features (with notice)

### Migration Process

1. **Announce deprecation** (90 days notice)
2. **Release new version** (v2.0.0) alongside old (v1.x)
3. **Support both versions** (minimum 6 months)
4. **Migrate clients** incrementally
5. **Sunset old version** after migration period

## Deprecation Strategy

### Marking Deprecated Features

In repository interfaces:

```dart
/// Authentication repository v1 (DEPRECATED).
///
/// ⚠️ DEPRECATED: This version is deprecated as of 2026-01-23.
/// Please migrate to [AuthRepositoryV2].
/// This version will be removed in 2026-07-23.
@Deprecated('Use AuthRepositoryV2 instead')
abstract class AuthRepository {
  // ...
}
```

In API responses:

```json
{
  "deprecated": true,
  "deprecation_notice": "This endpoint is deprecated. Use /api/v2/auth instead.",
  "sunset_date": "2026-07-23"
}
```

## Handling Multiple Versions

### Approach 1: Separate Repository Interfaces

```dart
// v1
abstract class AuthRepository {
  Future<Either<Failure, User>> signInWithGoogle();
}

// v2
abstract class AuthRepositoryV2 {
  Future<Either<Failure, User>> signInWithGoogle();
  Future<Either<Failure, User>> signInWithApple(); // New in v2
}
```

### Approach 2: Version-Agnostic Interfaces

```dart
abstract class AuthRepository {
  /// Signs in with Google.
  /// 
  /// Available in: v1.0+
  Future<Either<Failure, User>> signInWithGoogle();
  
  /// Signs in with Apple.
  /// 
  /// Available in: v2.0+
  /// Throws [UnsupportedError] if API version < v2.0
  Future<Either<Failure, User>> signInWithApple();
}
```

## Version Negotiation

### Client-Side Version Selection

```dart
class ApiConfig {
  static const String preferredApiVersion = 'v2';
  static const List<String> supportedVersions = ['v1', 'v2'];
  
  static String get currentApiVersion {
    // Negotiate version based on server capabilities
    return _negotiateVersion();
  }
}
```

### Server-Side Version Detection

```dart
class AuthRepositoryImpl implements AuthRepository {
  Future<Either<Failure, User>> signInWithGoogle() async {
    final serverVersion = await _getServerApiVersion();
    
    if (serverVersion == 'v2') {
      return _signInWithGoogleV2();
    } else {
      return _signInWithGoogleV1();
    }
  }
}
```

## Documentation Requirements

For each API version, document:
1. **Changelog** - What changed from previous version
2. **Migration Guide** - How to upgrade
3. **Breaking Changes** - Incompatibilities with previous versions
4. **Deprecation Timeline** - When features will be removed

**Example Changelog:**

```markdown
## v2.0.0 (2026-01-23)

### Breaking Changes
- Removed `signInWithToken()` method (use `refreshToken()` instead)
- Changed `User.id` from String to Int
- Renamed `displayName` to `fullName`

### New Features
- Added `signInWithApple()` support
- Added `User.isEmailVerified` field

### Migration Guide
1. Update `User` entity to use Int for ID
2. Replace `signInWithToken()` calls with `refreshToken()`
3. Update `displayName` references to `fullName`
```

## Testing Version Compatibility

```dart
group('API Version Compatibility', () {
  test('v1 contract is supported', () async {
    final repo = AuthRepositoryImpl(apiVersion: 'v1');
    final result = await repo.signInWithGoogle();
    expect(result.isRight(), true);
  });

  test('v2 contract includes new features', () async {
    final repo = AuthRepositoryImpl(apiVersion: 'v2');
    final result = await repo.signInWithApple();
    expect(result.isRight(), true);
  });
});
```

## Best Practices

### ✅ DO
- Version all API contracts
- Document breaking changes clearly
- Provide migration guides
- Support multiple versions during transition
- Use deprecation warnings
- Test backward compatibility

### ❌ DON'T
- Make breaking changes without version bump
- Remove features immediately
- Skip deprecation notices
- Support versions indefinitely
- Change version format mid-project
- Use unstable versions in production
