# ADR-002: BLoC State Management

**Status**: Accepted  
**Date**: 2026-01-23  
**Deciders**: Frontend Developer, API Architect

## Context and Problem Statement
We need a predictable, testable, and robust state management solution that scales well with complex business logic and reactive UI requirements.

## Decision Drivers
- Testability (Pure Dart logic testing).
- Predictability (Unidirectional data flow).
- Decoupling (Separation of UI from business logic).
- Team experience and community support.

## Considered Options
1. **Provider / ChangeNotifier**: Simpler, but logic often leaks into widgets.
2. **Riverpod**: Powerful, but less rigid than BLoC regarding event-to-state mapping.
3. **BLoC (Business Logic Component)**: Strict event-state mapping, highly testable.

## Decision Outcome
Chosen option: **BLoC (flutter_bloc)**, because it perfectly aligns with Clean Architecture (Presentation layer) and provides the most rigid separation between UI events and state transitions.

### Positive Consequences
- Logic for state changes is centralized in BLoCs.
- Very easy to unit test by adding events and observing state streams.
- Clear audit trail of state changes.

### Negative Consequences
- More boilerplate code (events, states, bloc).
- Steeper learning curve for new developers.

## Pros and Cons of the Options

### Provider
- Good: Low boilerplate.
- Bad: Harder to enforce strict separation in large teams.

### BLoC (Selected)
- Good: Scalable and predictable.
- Good: Excellent for complex flows (like multi-step booking forms).
- Bad: Higher initial development cost per feature.
