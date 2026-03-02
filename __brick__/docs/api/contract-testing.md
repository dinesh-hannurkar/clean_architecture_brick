# Contract Testing Strategy

## Purpose

Contract testing ensures that:
- Repository interfaces define clear contracts
- Data layer implementations fulfill those contracts
- Changes don't break existing contracts
- Mock implementations match real behavior

## Contract Definition

**Contracts** are defined as repository interfaces in the domain layer:

```dart
abstract class AuthRepository {
  /// Signs in a user with Google.
  /// 
  /// Returns [User] on success.
  /// Returns [NetworkFailure] if network is unavailable.
  /// Returns [AuthenticationFailure] if sign-in is rejected.
  Future<Either<Failure, User>> signInWithGoogle();
}
```

## Testing Approach

### 1. Interface Contract Tests

Test that the contract itself is well-defined:

```dart
import 'package:test/test.dart';
import 'package:app/domain/repositories/auth_repository.dart';

void main() {
  group('AuthRepository Contract', () {
    test('signInWithGoogle returns Either<Failure, User>', () {
      // This test ensures the method signature is correct
      const AuthRepository repo = _TestAuthRepository();
      expect(
        repo.signInWithGoogle(),
        isA<Future<Either<Failure, User>>>(),
      );
    });
  });
}

class _TestAuthRepository implements AuthRepository {
  const _TestAuthRepository();
  
  @override
  Future<Either<Failure, User>> signInWithGoogle() async {
    return right(const User(id: 'test', email: 'test@example.com'));
  }
}
```

### 2. Implementation Contract Tests

Verify that real implementations fulfill the contract:

```dart
void main() {
  group('AuthRepositoryImpl Contract Compliance', () {
    late AuthRepository repository;

    setUp(() {
      repository = AuthRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        networkInfo: mockNetworkInfo,
      );
    });

    test('signInWithGoogle returns User on success', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.signInWithGoogle())
          .thenAnswer((_) async => testUserModel);

      // Act
      final result = await repository.signInWithGoogle();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return user'),
        (user) {
          expect(user, isA<User>());
          expect(user.id, isNotEmpty);
        },
      );
    });

    test('signInWithGoogle returns NetworkFailure when offline', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final result = await repository.signInWithGoogle();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('Should return failure'),
      );
    });
  });
}
```

### 3. Mock Contract Tests

Ensure mocks used in tests match the real contract:

```dart
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('MockAuthRepository Contract', () {
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthRepository();
    });

    test('mock fulfills AuthRepository contract', () {
      // Verify mock can be used as AuthRepository
      final AuthRepository repo = mockRepository;
      
      when(() => mockRepository.signInWithGoogle())
          .thenAnswer((_) async => right(testUser));

      expect(repo.signInWithGoogle(), completes);
    });
  });
}
```

## Contract Test Suite Template

Create a reusable test suite for repository contracts:

```dart
/// Contract test suite for [AuthRepository] implementations.
///
/// Use this to test that any implementation of [AuthRepository]
/// fulfills the contract correctly.
void testAuthRepositoryContract(AuthRepository repository) {
  group('AuthRepository Contract', () {
    test('signInWithGoogle returns User on success', () async {
      final result = await repository.signInWithGoogle();
      expect(result.isRight(), true);
    });

    test('signInWithGoogle returns Failure on error', () async {
      // Test error scenarios
    });

    test('getCurrentUser returns authenticated User', () async {
      // First sign in
      await repository.signInWithGoogle();
      
      // Then get current user
      final result = await repository.getCurrentUser();
      expect(result.isRight(), true);
    });
  });
}

// Usage:
void main() {
  group('Real Implementation', () {
    testAuthRepositoryContract(AuthRepositoryImpl(...));
  });

  group('Mock Implementation', () {
    testAuthRepositoryContract(MockAuthRepository(...));
  });
}
```

## Verifying Return Types

Ensure methods return the correct types:

```dart
test('all methods return Either<Failure, T>', () {
  final repo = MockAuthRepository();
  
  expect(
    repo.signInWithGoogle(),
    isA<Future<Either<Failure, User>>>(),
  );
  
  expect(
    repo.signOut(),
    isA<Future<Either<Failure, void>>>(),
  );
  
  expect(
    repo.refreshToken(),
    isA<Future<Either<Failure, AuthToken>>>(),
  );
});
```

## Testing Error Contracts

Verify all documented error cases:

```dart
group('Error Contract', () {
  test('returns NetworkFailure when network unavailable', () async {
    when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    
    final result = await repository.signInWithGoogle();
    
    expect(result.isLeft(), true);
    result.fold(
      (failure) => expect(failure, isA<NetworkFailure>()),
      (_) => fail('Should return NetworkFailure'),
    );
  });

  test('returns AuthenticationFailure on invalid credentials', () async {
    when(() => mockRemoteDataSource.signInWithGoogle())
        .thenThrow(AuthException());
    
    final result = await repository.signInWithGoogle();
    
    expect(result.isLeft(), true);
    result.fold(
      (failure) => expect(failure, isA<AuthenticationFailure>()),
      (_) => fail('Should return AuthenticationFailure'),
    );
  });
});
```

## Breaking Change Detection

Use tests to detect breaking contract changes:

```dart
// This test will fail if the contract changes
test('contract remains stable', () {
  const repository = MockAuthRepository();
  
  // If method signature changes, this will fail to compile
  final Future<Either<Failure, User>> result =
      repository.signInWithGoogle();
  
  expect(result, isA<Future<Either<Failure, User>>>());
});
```

## Documentation Testing

Verify contracts match documentation:

```dart
test('contract matches documentation', () {
  // Check that all documented methods exist
  final repository = MockAuthRepository();
  
  // Documented in AuthRepository:
  // - signInWithGoogle()
  // - signOut()
  // - getCurrentUser()
  // - refreshToken()
  // - isAuthenticated()
  
  expect(() => repository.signInWithGoogle(), returnsNormally);
  expect(() => repository.signOut(), returnsNormally);
  expect(() => repository.getCurrentUser(), returnsNormally);
  expect(() => repository.refreshToken(), returnsNormally);
  expect(() => repository.isAuthenticated(), returnsNormally);
});
```

## Best Practices

### ✅ DO
- Test all contract implementations
- Verify return types match interfaces
- Test all documented error cases
- Use contract test suites for consistency
- Test mocks match real implementations
- Document expected behavior in tests

### ❌ DON'T
- Skip testing error scenarios
- Assume implementations match contracts
- Use untested mocks in production code
- Change contracts without updating tests
- Test implementation details instead of contracts
- Ignore breaking change warnings

## CI/CD Integration

Run contract tests in CI pipeline:

```yaml
# .github/workflows/test.yml
name: Contract Tests

on: [push, pull_request]

jobs:
  contract-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test test/domain/repositories/
```

## Tools and Libraries

**Recommended:**
- `mocktail` - For creating mock implementations
- `bloc_test` - For testing BLoC contracts
- `fpdart` - For Either type in contracts
- `equatable` - For value equality in entities

**Example Setup:**

```dart
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:app/domain/repositories/auth_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
  });

  tearDown(() {
    reset(mockAuthRepository);
  });

  // Contract tests here
}
```
