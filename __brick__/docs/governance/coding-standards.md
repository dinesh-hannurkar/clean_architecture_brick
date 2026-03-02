# Coding Standards

This document outlines the coding standards for Project App. Adherence to these standards is verified via CI/CD.

## 1. Naming Conventions

### Files & Directories
- **Format**: `snake_case`
- **Example**: `user_profile_screen.dart`, `auth_repository.dart`

### Classes
- **Format**: `PascalCase`
- **Example**: `UserProfileScreen`, `AuthRepositoryImpl`

### Variables & Functions
- **Format**: `camelCase`
- **Example**: `fetchUserData()`, `isLoading`, `userList`

### Constants
- **Format**: `lowerCamelCase` or `SCREAMING_SNAKE_CASE` (only for true primitives)
- **Top-level**: `const kAnimationDuration = Duration(milliseconds: 200);`

## 2. Formatting

We use the official Dart formatter.
```bash
dart format . --line-length 80
```

## 3. Linter Rules

We use a strict set of linter rules via `flutter_lints` and additional custom rules in `analysis_options.yaml`.

- **DO** use `const` constructors whenever possible.
- **DO** specify types for public APIs.
- **DON'T** use `var` unless the type is obvious or needed for dynamic typing (rare).

## 4. Error Handling

- **Use `fpdart`**: We use `Either<Failure, Success>` for return types in Domain and Data layers.
- **No thrown exceptions**: Avoid `throw` in Domain layer. Catch exceptions in Data layer and return `Left(Failure)`.

```dart
// ✅ Good
Future<Either<Failure, User>> login();

// ❌ Bad
Future<User> login(); // Throws exception on failure
```

## 5. State Management

- Use **BLoC** for complex feature state.
- Use **Cubit** for simple feature state.
- **Events**: Name events as `PageAction` or `UserAction` (e.g., `LoginSubmitted`, `ProfileLoadRequested`).
- **States**: Name states as adjectives or nouns (e.g., `LoginLoading`, `LoginSuccess`).

## 6. Testing

### Unit Tests
- Use `mocktail` for mocking.
- Follow **Arrange-Act-Assert** pattern.
- **Coverage**: 100% for Domain, >80% for Data/Presentation.

### Widget Tests
- Test that correct widgets are rendered.
- Test user interactions (taps, text input).

## 7. Comments

- **Documentation Comments**: Use `///` for public APIs.
- **Inline Comments**: Use `//` sparingly, only to explain *why* complex logic exists.

```dart
/// Authenticates the user with email and password.
/// 
/// Returns a [User] on success or [AuthFailure] on error.
Future<Either<Failure, User>> login(...)
```
