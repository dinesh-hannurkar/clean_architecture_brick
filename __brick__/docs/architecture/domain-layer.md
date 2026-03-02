# Domain Layer Architecture

## Overview

The domain layer is the heart of Project App's Clean Architecture implementation. It contains the business logic and is completely independent of any external frameworks, UI, or data sources.

## Structure

```
lib/
├── core/domain/              # Shared domain code
│   ├── failures/            # Base failure types
│   └── usecases/           # Base UseCase class
└── features/
    └── auth/domain/         # Auth-specific domain code
        ├── entities/        # User, AuthToken
        ├── repositories/    # AuthRepository interface
        └── usecases/       # SignInWithGoogle, etc.
```

## Core Principles

### 1. Pure Dart
The domain layer MUST contain only pure Dart code with no external dependencies except:
- `equatable` for value equality
- `fpdart` for functional programming constructs (Either type)

**NO Flutter imports. NO third-party framework code.**

### 2. Dependency Inversion
External layers (data, presentation) depend on the domain layer, never the reverse. Repository interfaces are defined here, implemented elsewhere.

### 3. Immutability
All entities are immutable with `final` fields and `const` constructors where possible.

### 4. Explicit Error Handling
No throwing exceptions for expected failures. Use the `Either<Failure, T>` pattern for explicit error handling.

## Structure

```
lib/domain/
├── entities/          # Business objects (User, AuthToken, etc.)
├── repositories/      # Repository interfaces (contracts)
├── usecases/         # Business logic operations
└── failures/         # Error types
```

## Entities

Entities represent core business objects. They:
- Extend `Equatable` for value equality
- Are immutable (final fields)
- Have no dependencies on external layers
- Contain domain logic (e.g., `AuthToken.isValid`)

**Example:**
```dart
class User extends Equatable {
  const User({
    required this.id,
    required this.email,
    this.displayName,
  });

  final String id;
  final String email;
  final String? displayName;

  @override
  List<Object?> get props => [id, email, displayName];
}
```

## Repository Interfaces

Repositories define contracts for data operations. They:
- Are defined as abstract classes in the domain layer
- Return `Future<Either<Failure, T>>` for async operations
- Have no implementation details (pure abstractions)
- Follow dependency inversion principle

**Example:**
```dart
abstract class AuthRepository {
  Future<Either<Failure, User>> signInWithGoogle();
  Future<Either<Failure, void>> signOut();
}
```

## Use Cases

Use cases encapsulate single business operations. They:
- Implement `UseCase<Type, Params>`
- Follow Single Responsibility Principle
- Depend on repository interfaces, not implementations
- Return `Future<Either<Failure, Type>>`

**Example:**
```dart
class SignInWithGoogle implements UseCase<User, NoParams> {
  const SignInWithGoogle(this._authRepository);
  
  final AuthRepository _authRepository;

  @override
  Future<Either<Failure, User>> call(NoParams params) {
    return _authRepository.signInWithGoogle();
  }
}
```

## Failures

Failures represent domain errors. They:
- Extend the base `Failure` class
- Are used instead of throwing exceptions
- Provide meaningful error messages and codes
- Enable exhaustive error handling

**Available Failure Types:**
- `NetworkFailure` - Network connectivity issues
- `ServerFailure` - Server-side errors (5xx)
- `CacheFailure` - Local storage issues
- `AuthenticationFailure` - Auth/authorization failures
- `ValidationFailure` - Input validation errors
- `UnknownFailure` - Unexpected errors

## Best Practices

### ✅ DO
- Keep entities immutable
- Use `Either<Failure, T>` for error handling
- Define repository interfaces in domain layer
- Test domain logic with unit tests
- Use meaningful failure types

### ❌ DON'T
- Import Flutter in domain layer
- Throw exceptions for expected failures
- Implement repositories in domain layer
- Put UI logic in use cases
- Use dynamic types

## Testing

Domain layer should have 100% test coverage. Test:
- Entity equality and immutability
- Use case business logic with mock repositories
- Failure type creation and properties
- Repository interface contracts (via mocks)

**Example Test:**
```dart
test('SignInWithGoogle returns user on success', () async {
  // Arrange
  final mockRepo = MockAuthRepository();
  final useCase = SignInWithGoogle(mockRepo);
  when(() => mockRepo.signInWithGoogle())
      .thenAnswer((_) async => right(testUser));

  // Act
  final result = await useCase(NoParams());

  // Assert
  expect(result, right(testUser));
});
```
