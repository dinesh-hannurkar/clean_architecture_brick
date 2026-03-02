# QA & Code Review Checklist

## 1. Architecture Compliance
- [ ] **Domain Layer**: Contains NO `flutter` imports (except `meta` or `equatable`).
- [ ] **Domain Layer**: No external dependencies (dio, firebase, shared_preferences, etc.).
- [ ] **Data Layer**: Implements Repository Interfaces defined in Domain.
- [ ] **Presentation Layer**: Does NOT access Data Layer directly (UseCases only).
- [ ] **Dependency Injection**: UseCases/Repositories are injected, not finding instantiated.

## 2. Testing & Quality
- [ ] **Tests Present**: Corresponding test file exists for every source file.
- [ ] **Coverage**:
    - Domain Logic: 100% coverage.
    - Happy Path: Verified.
    - Failure Paths: Verified (Network errors, Server errors, Cache errors).
- [ ] **Mocks**: External dependencies are mocked using `mocktail`.
- [ ] **Cleanliness**: `setUp` and `tearDown` used correctly.

## 3. Code Style & Best Practices
- [ ] **Lints**: No analyzer warnings or errors.
- [ ] **Formatting**: Code matches `dart format` standards.
- [ ] **Naming**: Clear variable/function names expressing intent.
- [ ] **Immutability**: Entities and States extend `Equatable` and are immutable.

## 4. Performance & Security
- [ ] **Rebuilds**: `build()` methods are side-effect free and efficient.
- [ ] **Secrets**: No API keys or secrets hardcoded.
- [ ] **Async**: `await` used correctly, no unawaited Futures.
