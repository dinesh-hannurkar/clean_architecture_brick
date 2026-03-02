# Git Workflow & Branching Strategy

## Overview

Project App follows **GitFlow** branching model to manage parallel development, ensure stable releases, and enable rapid hotfixes for production issues.

## Branch Types

### `main`
- **Purpose**: Production-ready code only
- **Protection**: Highest level
- **Merges from**: `release/*`, `hotfix/*`
- **Naming**: Always `main`
- **Lifecycle**: Permanent
- **Tags**: Every merge creates a version tag (e.g., `v1.0.0`)

### `develop`
- **Purpose**: Integration branch for next release
- **Protection**: High level
- **Merges from**: `feature/*`, `bugfix/*`, `release/*`
- **Merges to**: `release/*`
- **Naming**: Always `develop`
- **Lifecycle**: Permanent

### `feature/*`
- **Purpose**: New feature development
- **Branches from**: `develop`
- **Merges to**: `develop`
- **Naming**: `feature/<task-id>-<short-description>`
  - Examples: `feature/VCS-001-git-workflow`, `feature/FE-042-login-screen`
- **Lifecycle**: Delete after merge
- **Protection**: None (but CI checks required)

### `bugfix/*`
- **Purpose**: Non-critical bug fixes during development
- **Branches from**: `develop`
- **Merges to**: `develop`
- **Naming**: `bugfix/<task-id>-<short-description>`
  - Example: `bugfix/QA-023-navigation-error`
- **Lifecycle**: Delete after merge

### `release/*`
- **Purpose**: Prepare for production release (final testing, version bumps, docs)
- **Branches from**: `develop`
- **Merges to**: `main` AND `develop`
- **Naming**: `release/<version>`
  - Example: `release/1.2.0`
- **Lifecycle**: Delete after merge to both `main` and `develop`
- **Protection**: Medium (no direct commits, PR only)

### `hotfix/*`
- **Purpose**: Critical production fixes
- **Branches from**: `main`
- **Merges to**: `main` AND `develop`
- **Naming**: `hotfix/<version>-<short-description>`
  - Example: `hotfix/1.1.1-auth-crash`
- **Lifecycle**: Delete after merge to both branches
- **Protection**: Requires 2 approvals, expedited review

## Workflow Diagrams

### Feature Development Flow
\`\`\`
develop
  |
  | (branch)
  v
feature/FE-042-login-screen
  |
  | (commits)
  |
  | (PR review)
  v
develop (squash merge)
\`\`\`

### Release Flow
\`\`\`
develop
  |
  | (branch when feature-complete)
  v
release/1.2.0
  |
  | (version bump, bug fixes only)
  |
  |-----(merge)-----> main (tag: v1.2.0)
  |
  |-----(merge back)--> develop
\`\`\`

### Hotfix Flow
\`\`\`
main (v1.2.0)
  |
  | (critical bug found!)
  v
hotfix/1.2.1-payment-failure
  |
  | (fix + tests)
  |
  |-----(merge)-----> main (tag: v1.2.1)
  |
  |-----(merge back)--> develop
\`\`\`

## Merge Strategies

| From Branch | To Branch | Strategy | Rationale |
|-------------|-----------|----------|-----------|
| `feature/*` | `develop` | **Squash and merge** | Clean history, single commit per feature |
| `bugfix/*` | `develop` | **Squash and merge** | Clean history, single commit per fix |
| `release/*` | `main` | **Merge commit** | Preserve release history |
| `release/*` | `develop` | **Merge commit** | Preserve release history |
| `hotfix/*` | `main` | **Merge commit** | Track emergency fixes explicitly |
| `hotfix/*` | `develop` | **Merge commit** | Preserve hotfix context |

## Branch Naming Conventions

### Format
\`\`\`
<type>/<task-id>-<short-description>
\`\`\`

### Rules
- **Type**: `feature`, `bugfix`, `hotfix`, `release`
- **Task ID**: Reference to task tracking system (e.g., `VCS-001`, `FE-042`)
- **Description**: Kebab-case, 2-4 words max
- **No special characters** except hyphens and slashes

### Valid Examples
- ✅ `feature/API-101-user-authentication`
- ✅ `bugfix/QA-045-null-pointer-fix`
- ✅ `release/2.0.0`
- ✅ `hotfix/1.5.1-crash-on-startup`

### Invalid Examples
- ❌ `my-feature` (no task ID)
- ❌ `feature/add_login_screen` (underscores)
- ❌ `FEATURE-123` (no type prefix)

## Commit Frequency & Size

- **Commit often**: Small, logical units of work
- **Each commit should**:
  - Compile successfully
  - Pass existing tests
  - Represent a single logical change
  - Have a meaningful commit message

## Stale Branch Policy

- **Definition**: Branches with no commits for 7+ days AND no open PR
- **Action**: Automated weekly cleanup (Monday 9 AM)
- **Exceptions**: `main`, `develop`, `release/*` branches in active release cycle
- **Notification**: 24-hour warning before deletion

## Access Control Matrix

| Branch Pattern | Who Can Push | Who Can Merge | Approval Required |
|----------------|--------------|---------------|-------------------|
| `main` | ❌ No one | Release Manager, DevOps | 2 approvals |
| `develop` | ❌ No one | Team Leads | 1 approval |
| `feature/*` | ✅ Feature owner | ✅ Feature owner (via PR) | 2 approvals |
| `bugfix/*` | ✅ Bug owner | ✅ Bug owner (via PR) | 1 approval |
| `release/*` | ❌ Release Manager only | Release Manager | 2 approvals |
| `hotfix/*` | ❌ Hotfix owner only | DevOps, Team Leads | 2 approvals (expedited) |

## Best Practices

1. **Always branch from the correct source**
   - Features/bugfixes → from `develop`
   - Hotfixes → from `main`

2. **Keep branches up-to-date**
   - Regularly merge `develop` into your feature branch
   - Resolve conflicts locally before PR

3. **One branch = One responsibility**
   - Don't mix multiple features/fixes in one branch
   - Split large features into smaller sub-features

4. **Delete merged branches**
   - Immediately after successful merge
   - Keep repository clean

5. **Never rewrite public history**
   - No force pushes to `main`, `develop`, or shared branches
   - Use `git revert` for undoing changes

## Integration with CI/CD

- **All branches**: Run lint, unit tests, build checks
- **develop**: Additional integration tests
- **release/***: Full test suite + smoke tests
- **main**: Deployment pipeline triggered on merge

## Version Tagging Strategy

- **Format**: Semantic Versioning (`vMAJOR.MINOR.PATCH`)
  - Example: `v1.2.3`
- **When**: Every merge to `main`
- **Who**: Automated by CI/CD
- **Annotation**: Tags are annotated with release notes

### Version Increment Rules
- **MAJOR**: Breaking changes, architecture overhaul
- **MINOR**: New features, backwards-compatible
- **PATCH**: Bug fixes, hotfixes

## Emergency Procedures

### Reverting a Bad Release
\`\`\`bash
# Option 1: Revert the merge commit
git checkout main
git revert -m 1 <merge-commit-sha>
git push origin main

# Option 2: Hotfix branch
git checkout -b hotfix/1.2.1-revert-bad-change main
# Make fixes
# PR to main
\`\`\`

### Fast-tracking Critical Fixes
1. Create `hotfix/*` branch from `main`
2. Ping DevOps lead for expedited review
3. Minimum 1 approval (from senior engineer)
4. Merge to `main` → auto-deploy
5. Merge back to `develop` immediately

## References

- [Conventional Commits](file:///Users/dineshhannurkar/Development/app/docs/governance/commit-conventions.md)
- [Pull Request Process](file:///Users/dineshhannurkar/Development/app/docs/governance/pull-request-process.md)
- [Branch Protection Settings](file:///Users/dineshhannurkar/Development/app/docs/governance/branch-protection.md)
