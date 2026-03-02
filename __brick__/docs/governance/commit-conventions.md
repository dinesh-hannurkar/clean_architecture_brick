# Commit Message Conventions

## Overview

Project App uses **Conventional Commits** specification to ensure consistent, readable, and machine-parseable commit history.

## Format

\`\`\`
<type>(<scope>): <subject>

[optional body]

[optional footer(s)]
\`\`\`

### Example
\`\`\`
feat(presentation): add login screen with email validation

Implemented login UI using BLoC pattern with form validation.
Email regex validation and password strength indicator included.

Closes: FE-042
\`\`\`

## Commit Types

| Type | Description | Examples |
|------|-------------|----------|
| `feat` | New feature or capability | Add user profile screen, implement OAuth |
| `fix` | Bug fix | Fix null pointer in navigation, resolve memory leak |
| `docs` | Documentation only changes | Update API docs, add architecture diagrams |
| `refactor` | Code restructuring without behavior change | Extract payment logic to use case, rename variables |
| `test` | Adding or updating tests | Add unit tests for authentication, fix flaky test |
| `chore` | Maintenance tasks, dependencies | Update dependencies, configure CI pipeline |
| `perf` | Performance improvements | Optimize image loading, reduce widget rebuilds |
| `style` | Code style changes (formatting, semicolons) | Run dart format, fix linting warnings |
| `build` | Build system or external dependency changes | Update Flutter SDK, modify pubspec.yaml |
| `ci` | CI/CD configuration changes | Update GitHub Actions, modify deployment script |
| `revert` | Revert a previous commit | Revert "feat(data): add caching layer" |

## Scope

Scope represents the **Clean Architecture layer** or **component** affected by the change.

### Clean Architecture Scopes

| Scope | Description | Examples |
|-------|-------------|----------|
| `presentation` | UI layer (widgets, BLoC, screens) | Login screen, theme cubit, navigation |
| `domain` | Business logic (use cases, entities) | Login use case, user entity, repository interface |
| `data` | Data layer (repositories, data sources) | User repository impl, API client, local DB |
| `core` | Shared utilities, constants, extensions | Date formatter, string extensions, DI setup |

### Component Scopes (when specific)
- `auth` - Authentication module
- `profile` - User profile features
- `notifications` - Push notification system
- `payments` - Payment processing
- `analytics` - Analytics integration

### Infrastructure Scopes
- `ci` - Continuous Integration
- `deps` - Dependencies
- `config` - Configuration files

## Subject Line

### Rules
1. **Imperative mood**: "add" not "added" or "adds"
2. **Lowercase**: Start with lowercase letter
3. **No period**: Don't end with a period
4. **50 characters max**: Be concise
5. **Descriptive**: Explain **what** and **why**, not **how**

### Good Examples
- ✅ `feat(presentation): add logout button to profile screen`
- ✅ `fix(data): prevent memory leak in image cache`
- ✅ `refactor(domain): extract validation logic to use case`

### Bad Examples
- ❌ `updated files` (vague, no type/scope)
- ❌ `feat(presentation): Added logout button.` (not imperative, has period)
- ❌ `fix(data): fixed the bug where the app crashes when user clicks button` (too long)

## Body (Optional)

Use the body to provide **context** and **rationale**:
- **Why** was this change needed?
- **What** was the previous behavior?
- **How** does this change address the issue?

### Format
- Separate from subject with a blank line
- Wrap at 72 characters per line
- Use bullet points for multiple points

### Example
\`\`\`
refactor(domain): extract user validation to dedicated use case

Previous implementation had validation logic scattered across
presentation and data layers, violating Clean Architecture.

Changes:
- Created ValidateUserInputUseCase in domain layer
- Moved all validation rules to domain entities
- Updated LoginBloc to call use case instead of direct validation

This ensures domain layer remains pure Dart with no dependencies.
\`\`\`

## Footer (Optional)

Use footers for:
- Issue/task references
- Breaking changes
- Co-authors

### Format
\`\`\`
<token>: <value>
\`\`\`

### Common Tokens

#### Issue References
\`\`\`
Closes: FE-042
Fixes: #123
Relates-to: API-056
\`\`\`

#### Breaking Changes
\`\`\`
BREAKING CHANGE: Authentication token format changed from JWT to OAuth2.
All existing auth integrations must update token handling.
\`\`\`

#### Co-authorship
\`\`\`
Co-authored-by: Jane Developer <jane@example.com>
\`\`\`

## Full Example

\`\`\`
feat(data)!: migrate to new authentication API endpoint

Switched from deprecated /auth/login to /v2/auth/token endpoint.
New endpoint requires OAuth2 flow instead of simple JWT.

Changes:
- Updated AuthRemoteDataSource to use OAuth2 client
- Modified token refresh logic for new expiry format
- Added migration guide for local storage format

BREAKING CHANGE: AuthRepository.login() now returns OAuth2Token
instead of JwtToken. Update all presentation layer auth calls.

Closes: API-101
Relates-to: BE-056
\`\`\`

## Breaking Changes Indicator

Add `!` after the scope to indicate a breaking change:

\`\`\`
feat(domain)!: change User entity to immutable class
\`\`\`

This is equivalent to including `BREAKING CHANGE:` in the footer.

## Merge Commit Messages

When squashing feature branches, the final commit message should:
1. Summarize the entire feature
2. Use the primary commit type
3. Include all relevant issue references

### Example
\`\`\`
feat(presentation): implement user profile screen

Complete user profile feature including:
- Profile view with avatar, name, email
- Edit profile form with validation
- Avatar upload with image picker
- BLoC pattern state management
- Unit and widget tests

Closes: FE-042, FE-043, FE-044
\`\`\`

## Validation Rules

Commits must pass the following checks:
1. ✅ Format: `<type>(<scope>): <subject>`
2. ✅ Type is one of: feat, fix, docs, refactor, test, chore, perf, style, build, ci, revert
3. ✅ Scope is lowercase, alphanumeric, or hyphenated
4. ✅ Subject is lowercase imperative mood
5. ✅ Subject is ≤ 50 characters
6. ✅ Subject does not end with period

## Tools & Automation

### Pre-commit Hook (Future)
\`\`\`bash
# .git/hooks/commit-msg
#!/bin/bash
commit_msg_file=$1
commit_msg=$(cat "$commit_msg_file")

# Validate conventional commit format
if ! echo "$commit_msg" | grep -qE "^(feat|fix|docs|refactor|test|chore|perf|style|build|ci|revert)(\(.+\))?!?: .+"; then
  echo "ERROR: Commit message does not follow Conventional Commits format"
  echo "Format: <type>(<scope>): <subject>"
  exit 1
fi
\`\`\`

### CI Validation
GitHub Actions / GitLab CI will validate commit messages on all PRs.

## Common Scenarios

### Multiple Files, Same Purpose
\`\`\`
feat(presentation): add dark mode support

Updated theme configuration and all screens to support dark mode.
\`\`\`

### Dependency Update
\`\`\`
build(deps): upgrade Flutter to 3.24.0

Updated SDK and resolved breaking changes in widgets.
\`\`\`

### Configuration Change
\`\`\`
chore(config): update lint rules for stricter analysis

Added prefer_const_constructors and avoid_dynamic_calls.
\`\`\`

### Emergency Hotfix
\`\`\`
fix(data)!: resolve critical payment processing crash

Null check added for payment response. Crash occurred when
server returned 204 No Content instead of payment confirmation.

BREAKING CHANGE: PaymentRepository.processPayment() now returns
PaymentResult? instead of PaymentResult (nullable).

Closes: HOTFIX-023
\`\`\`

## Benefits

1. **Automated Changelog**: Generate release notes from commit history
2. **Semantic Versioning**: Determine version bumps automatically
3. **Clear History**: Understand changes at a glance
4. **Better Collaboration**: Consistent format reduces cognitive load
5. **Compliance**: Aligns with governance contracts

## References

- Official Spec: https://www.conventionalcommits.org/
- [Git Workflow](file:///Users/dineshhannurkar/Development/app/docs/governance/git-workflow.md)
- [Pull Request Process](file:///Users/dineshhannurkar/Development/app/docs/governance/pull-request-process.md)
