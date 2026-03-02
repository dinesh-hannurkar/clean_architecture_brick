# ADR-001: Hybrid Feature-Layer Architecture

**Status**: Accepted  
**Date**: 2026-01-23  
**Deciders**: API Architect, Product Owner

## Context and Problem Statement
Project App needs to be highly scalable and maintainable. Pure Clean Architecture (layer-first) can lead to large folders (`lib/domain` with 50+ files) making it hard to navigate. Pure feature-first can lead to duplication or circular dependencies between features.

## Decision Drivers
- Ease of navigation as the project grows.
- Strict enforcement of Clean Architecture layers.
- Feature independence.
- High testability.

## Considered Options
1. **Layer-First Clean Architecture**: `lib/domain`, `lib/data`, `lib/presentation`.
2. **Pure Feature-First**: `lib/features/feature_a/...`.
3. **Hybrid Feature-Layer (Clean Architecture within Features)**.

## Decision Outcome
Chosen option: **Option 3 (Hybrid Feature-Layer)**, because it allows features to be self-contained modules while still strictly adhering to Clean Architecture principles within each module.

### Positive Consequences
- Scalable: New features can be added without affecting existing ones.
- Focused: All code related to a feature is in one directory.
- Testable: Layers are still separated, allowing for pure Dart unit tests in the domain layer.

### Negative Consequences
- Slight increase in folder nesting.
- Requires discipline to keep `core/` lean.

## Pros and Cons of the Options

### Layer-First
- Good: Familiar structure for many developers.
- Bad: Becomes unmanageable as the number of entities/usecases grows.

### Hybrid (Selected)
- Good: Combines modularity with architectural rigor.
- Good: Easier for teams to work on separate features in parallel.
- Bad: Higher initial setup effort for folder structures.
