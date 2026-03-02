## Description

<!-- Provide a brief summary of your changes -->

### Type of Change
<!-- Check all that apply -->
- [ ] `feat` - New feature
- [ ] `fix` - Bug fix
- [ ] `refactor` - Code refactoring
- [ ] `docs` - Documentation update
- [ ] `test` - Test additions/modifications
- [ ] `chore` - Maintenance or tooling change
- [ ] `perf` - Performance improvement

### Related Tasks
<!-- Link to related tasks/issues -->
- Closes: <!-- e.g., FE-042, API-101 -->
- Relates-to: <!-- e.g., BE-056 -->

---

## Clean Architecture Compliance

### Layer Affected
<!-- Check the primary layer(s) modified -->
- [ ] **Presentation** (UI, widgets, BLoC/Cubit)
- [ ] **Domain** (use cases, entities, repository interfaces)
- [ ] **Data** (repository implementations, data sources)
- [ ] **Core** (utilities, constants, DI)

### Architecture Boundaries
<!-- ALL must be checked ✅ -->
- [ ] ✅ UI does NOT directly access data layer
- [ ] ✅ Domain layer contains NO Flutter/platform dependencies (pure Dart)
- [ ] ✅ Third-party packages are wrapped in adapters/interfaces
- [ ] ✅ Business logic is NOT in UI widgets (only in use cases/BLoC)
- [ ] ✅ Dependency flow: Presentation → Domain ← Data

### Dependency Injection
- [ ] New dependencies registered in DI container
- [ ] Dependencies injected via constructor (not accessed globally)

---

## Testing

### Test Coverage
- [ ] Unit tests added/updated for domain logic
- [ ] Widget tests added for UI components
- [ ] Integration tests updated (if applicable)
- [ ] All tests pass locally

### Test Coverage Goal
<!-- For domain layer: target 100% coverage -->
- Domain layer coverage: <!-- e.g., 95% -->
- Overall coverage: <!-- e.g., 78% -->

---

## Code Quality

### Linting & Formatting
- [ ] `dart analyze` passes with no errors
- [ ] `dart format` applied to all changed files
- [ ] No new lint warnings introduced

### Code Review
- [ ] Self-reviewed the code before submitting
- [ ] Code follows project style guide
- [ ] Complex logic is commented/documented
- [ ] No debug code (print statements, commented code blocks)

---

## Breaking Changes

### Is this a breaking change?
- [ ] Yes ⚠️
- [ ] No

<!-- If YES, explain the impact and migration path -->
**Breaking Change Details:**
<!-- Describe what breaks and how to migrate -->

---

## Security & Data

### Security Considerations
- [ ] No sensitive data in logs
- [ ] Credentials stored in encrypted secure storage
- [ ] API calls use HTTPS/TLS 1.3
- [ ] User input is validated and sanitized

### Data Handling
- [ ] Follows "remote server as source of truth" principle
- [ ] Local caching is on-demand only
- [ ] No unnecessary data persistence

---

## Documentation

- [ ] Code is self-documenting with clear naming
- [ ] Complex algorithms/logic have inline comments
- [ ] Public APIs have dartdoc comments
- [ ] README or docs updated (if applicable)

---

## Governance Compliance

<!-- Confirm adherence to project governance -->
- [ ] Changes align with [project-overview.yaml](file:///Users/dineshhannurkar/Development/app/docs/project/project-overview.yaml)
- [ ] Commit messages follow [Conventional Commits](file:///Users/dineshhannurkar/Development/app/docs/governance/commit-conventions.md)
- [ ] Branch naming follows [Git Workflow](file:///Users/dineshhannurkar/Development/app/docs/governance/git-workflow.md) conventions

---

## Reviewer Checklist

<!-- For reviewers -->
### Code Review Focus Areas
- [ ] Architecture boundaries respected
- [ ] Proper error handling (explicit failure types)
- [ ] Performance considerations (widget rebuilds, memory)
- [ ] Security implications reviewed
- [ ] Test coverage adequate

### Approval
- **Minimum 2 approvals required** for merge to `main` or `develop`
- **CODEOWNERS automatically assigned**

---

## Additional Notes

<!-- Any additional context, screenshots, or information -->
