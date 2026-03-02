# Error Handling Strategy

## Philosophy

Project App uses **explicit error handling** instead of throwing exceptions for expected failures. This makes error handling:
- **Predictable**: Callers know errors can occur
- **Type-safe**: Compiler enforces error handling
- **Testable**: Easy to test error scenarios
- **Readable**: Error paths are visible in code

## Core Pattern: Either<Failure, T>

We use the `Either` type from `fpdart` to represent operations that can fail:

```dart
Future<Either<Failure, User>> signInWithGoogle();
```

This returns:
- `Left(Failure)` - operation failed
- `Right(T)` - operation succeeded with value

## Failure Hierarchy

All failures extend the base `Failure` class:

```dart
abstract class Failure extends Equatable {
  const Failure({
    required this.message,
    this.code,
  });

  final String message;  // Human-readable error
  final String? code;    // Programmatic error code
}
```

### Standard Failure Types

| Failure Type | Usage | Example |
|--------------|-------|---------|
| `NetworkFailure` | Network connectivity issues | No internet connection |
| `ServerFailure` | Server errors (5xx) | Internal server error |
| `CacheFailure` | Local storage issues | Failed to read from cache |
| `AuthenticationFailure` | Auth/authorization failures | Invalid credentials |
| `ValidationFailure` | Input validation errors | Invalid email format |
| `UnknownFailure` | Unexpected errors | Unhandled exception |

## Creating Custom Failures

For domain-specific failures, extend `Failure`:

```dart
class UserNotFoundFailure extends Failure {
  const UserNotFoundFailure({
    super.message = 'User not found',
    super.code = 'USER_NOT_FOUND',
  });
}
```

## Handling Errors

### In Use Cases

Use cases should return failures, never throw:

```dart
@override
Future<Either<Failure, User>> call(NoParams params) async {
  return _authRepository.signInWithGoogle();
}
```

### In Repositories (Data Layer)

Convert exceptions to failures:

```dart
@override
Future<Either<Failure, User>> signInWithGoogle() async {
  try {
    final user = await _remoteDataSource.signIn();
    return right(user);
  } on NetworkException {
    return left(const NetworkFailure());
  } on ServerException {
    return left(const ServerFailure());
  } catch (e) {
    return left(UnknownFailure(message: e.toString()));
  }
}
```

### In Presentation Layer (BLoC)

Pattern match on Either to update UI state:

```dart
final result = await _signInUseCase(NoParams());

result.fold(
  (failure) => emit(AuthError(failure.message)),
  (user) => emit(AuthSuccess(user)),
);
```

## Best Practices

### ✅ DO
- Use `Either<Failure, T>` for operations that can fail
- Create specific failure types for domain errors
- Provide meaningful error messages
- Include error codes for programmatic handling
- Convert exceptions to failures at the data layer boundary

### ❌ DON'T
- Throw exceptions for expected failures in domain/use cases
- Use generic `Exception` or `Error` types
- Return null to indicate failure
- Swallow errors silently
- Use dynamic error types

## Error Logging

Failures should be logged at the presentation layer:

```dart
result.fold(
  (failure) {
    _logger.error('Operation failed', failure);
    emit(ErrorState(failure.message));
  },
  (success) => emit(SuccessState(success)),
);
```

## Testing Error Scenarios

Test both success and failure paths:

```dart
test('returns NetworkFailure when network is unavailable', () async {
  // Arrange
  when(() => mockRepo.signIn())
      .thenAnswer((_) async => left(const NetworkFailure()));

  // Act
  final result = await useCase(NoParams());

  // Assert
  expect(result.isLeft(), true);
  result.fold(
    (failure) => expect(failure, isA<NetworkFailure>()),
    (_) => fail('Should return failure'),
  );
});
```

## Exception vs Failure Guidelines

| Scenario | Use |
|----------|-----|
| Network timeout | `Failure` (expected) |
| Invalid user input | `Failure` (expected) |
| Authentication failed | `Failure` (expected) |
| Server 4xx/5xx responses | `Failure` (expected) |
| Programming errors (null check) | `Exception` (unexpected) |
| Invalid state assertions | `Exception` (unexpected) |

**Rule of thumb:** If it's a business/operational error that users might encounter, use `Failure`. If it's a programming bug, throw an exception.
