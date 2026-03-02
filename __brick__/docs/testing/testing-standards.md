# Testing Standards & Quality Assurance Framework

## 1. Overview
This document outlines the testing strategy for Project App, ensuring strict adherence to Clean Architecture principles and high software quality.

## 2. Testing Pyramid
We follow the testing pyramid approach:
- **Unit Tests (70%)**: Fast, isolated tests for Domain and Data layers.
- **Widget Tests (20%)**: Component-level tests for Presentation layer.
- **Integration Tests (10%)**: End-to-end user flow validation.

## 3. Layer-Specific Testing Guidelines

### 3.1 Domain Layer (Pure Dart)
* **Goal**: 100% Code Coverage.
* **Tools**: `test`, `mocktail`.
* **Focus**: 
    - UseCases: Verify correct interaction with Repositories.
    - Entities: Verify data integrity and domain logic.
    - Failures: Verify error handling types.
* **Rules**: 
    - NO Flutter dependencies (except `flutter_test` if needed).
    - Mock all external dependencies.

### 3.2 Data Layer
* **Goal**: Verify data transformation and external communication.
* **Tools**: `flutter_test`, `mocktail`.
* **Focus**:
    - Repositories: Test logic mapping Datasource -> Entity.
    - Models: Test `fromJson`/`toJson`.
    - Datasources: Mock external clients (Dio, SharedPrefs).

### 3.3 Presentation Layer
* **Goal**: Verify UI rendering and State Management logic.
* **Tools**: `bloc_test`, `flutter_test`.
* **Focus**:
    - BLoCs/Cubits: Test state transitions (Inputs -> Outputs).
    - Widgets: Test rendering, interaction, and visual regressions.

## 4. Test Structure & Naming
* Tests must mirror the `lib/` directory structure.
* **Naming**: `[feature]_[component]_test.dart`.
* **Pattern**: 
    ```dart
    group('Component Name', () {
      setUp(() { ... });
      
      test('should [expected outcome] when [condition]', () {
        // Arrange
        // Act
        // Assert
      });
    });
    ```

## 5. Mocking Strategy
* Use `mocktail` for all mocking.
* Create specific Mocks for each test file or use a shared `mocks.dart` for common types.
* strict adherence to `registerFallbackValue` for custom types.

## 6. Continuous Integration (CI)
* All PRs must pass:
    - `flutter test` (All Unit/Widget tests)
    - `flutter analyze`
    - `dart format --set-exit-if-changed .`

## 7. Coverage Requirements
* **Domain**: 100%
* **Data**: >90%
* **Presentation**: >80%
