# Branch Protection Rules

## Overview

This document outlines the branch protection settings to be configured in the Git repository hosting platform (GitHub, GitLab, Bitbucket, etc.). These settings enforce the Git workflow and ensure code quality.

> [!WARNING]
> These settings must be **manually configured** in your Git hosting platform's repository settings. They cannot be enforced through configuration files alone.

---

## Protected Branches

### `main` Branch

**Purpose**: Production-ready code only

#### Protection Rules
- ✅ **Require pull request before merging**
- ✅ **Require 2 approvals** before merge
- ✅ **Dismiss stale reviews** when new commits are pushed
- ✅ **Require review from Code Owners**
- ✅ **Require status checks to pass** before merging:
  - `ci/build` - Build succeeds
  - `ci/test` - All tests pass
  - `ci/lint` - Linting passes
  - `ci/analyze` - Static analysis passes
  - `ci/coverage` - Coverage threshold met (80%+)
- ✅ **Require branches to be up to date** before merging
- ✅ **Require linear history** (squash or rebase, no merge commits from features)
- ✅ **Include administrators** in restrictions
- ❌ **Do not allow force pushes**
- ❌ **Do not allow deletions**

#### Who Can Merge
- Release Manager
- DevOps Infrastructure Lead
- (Emergency: Senior Engineers with approval)

---

### `develop` Branch

**Purpose**: Integration branch for ongoing development

#### Protection Rules
- ✅ **Require pull request before merging**
- ✅ **Require 1 approval** before merge
- ✅ **Require review from Code Owners**
- ✅ **Require status checks to pass**:
  - `ci/build`
  - `ci/test`
  - `ci/lint`
  - `ci/analyze`
- ✅ **Require branches to be up to date**
- ✅ **Require linear history** (squash merges for features)
- ❌ **Do not allow force pushes**
- ❌ **Do not allow deletions**

#### Who Can Merge
- Any team member with 1 approval from Code Owner

---

### `release/*` Branches

**Purpose**: Release preparation and stabilization

#### Protection Rules
- ✅ **Require pull request before merging**
- ✅ **Require 2 approvals**
- ✅ **Require review from Code Owners**
- ✅ **Require status checks to pass**:
  - `ci/build`
  - `ci/test` (full suite)
  - `ci/integration-test`
  - `ci/smoke-test`
  - `ci/lint`
  - `ci/security-scan`
- ✅ **Require branches to be up to date**
- ❌ **Do not allow force pushes**
- ✅ **Allow only Release Manager to create** release branches

#### Who Can Merge to Release Branch
- Only bug fixes (no new features)
- Requires QA Reviewer approval

#### Who Can Merge Release to `main`
- Release Manager
- Requires Product Owner approval

---

### `hotfix/*` Branches

**Purpose**: Critical production fixes

#### Protection Rules
- ✅ **Require pull request before merging**
- ✅ **Require 2 approvals** (can be expedited)
- ✅ **Require review from Code Owners**
- ✅ **Require status checks to pass**:
  - `ci/build`
  - `ci/test`
  - `ci/lint`
  - `ci/critical-security-scan`
- ⚠️ **Expedited review process** (4-hour SLA)
- ❌ **Do not allow force pushes**

#### Who Can Merge
- DevOps Infrastructure Lead
- Senior Engineers
- Requires QA Reviewer sign-off

---

### `feature/*` and `bugfix/*` Branches

**Purpose**: Individual feature/bugfix development

#### Protection Rules
- ✅ **Require status checks to pass**:
  - `ci/build`
  - `ci/test`
  - `ci/lint`
- ❌ **No branch protection** (developers have full control)
- ⚠️ **Recommended**: Keep branch up-to-date with `develop`

#### Merge Requirements (for PR to develop)
- ✅ **Squash and merge** enforced
- ✅ **Require 2 approvals** from team members
- ✅ **At least 1 approval from Code Owner**

---

## Status Checks Configuration

### Required CI/CD Checks

#### `ci/build`
- Build succeeds for all platforms (Android, iOS, Web)
- No compilation errors
- **Timeout**: 10 minutes

#### `ci/test`
- All unit tests pass
- All widget tests pass
- Integration tests pass (for `main` and `release/*`)
- **Timeout**: 15 minutes

#### `ci/lint`
- `dart analyze` reports no errors
- `dart format` check passes (no unformatted files)
- **Timeout**: 5 minutes

#### `ci/analyze`
- Static code analysis passes
- No critical or high-severity issues
- **Timeout**: 5 minutes

#### `ci/coverage`
- Domain layer: ≥ 100% coverage
- Overall: ≥ 80% coverage
- **Timeout**: 5 minutes

#### `ci/security-scan` (for releases only)
- Dependency vulnerability scan
- OWASP security checks
- Sensitive data leak detection
- **Timeout**: 10 minutes

---

## Auto-merge Conditions

### When Auto-merge is Allowed
Auto-merge can be enabled for:
- Dependency updates (Dependabot PRs)
- Documentation-only changes
- Automated test fixes

### Requirements for Auto-merge
- ✅ All status checks pass
- ✅ Approvals met
- ✅ No merge conflicts
- ✅ Branch is up-to-date

---

## Merge Strategies by Branch

| Target Branch | Allowed Strategies | Enforced Strategy |
|---------------|-------------------|-------------------|
| `main` | Merge commit only | Merge commit |
| `develop` | Squash, Rebase | Squash (for features) |
| `release/*` | Merge commit only | Merge commit |
| `hotfix/*`→`main` | Merge commit only | Merge commit |
| `hotfix/*`→`develop` | Merge commit only | Merge commit |

---

## Stale Branch Policy

### Automated Cleanup
- **Schedule**: Every Monday at 9:00 AM
- **Criteria**:
  - No commits in 7+ days
  - No open pull request
  - Not `main`, `develop`, or active `release/*`
- **Process**:
  1. Bot comments on branch (24-hour warning)
  2. If no response, branch is deleted
  3. Notification sent to branch owner

### Manual Override
Branch owners can comment `keep` to prevent deletion.

---

## Emergency Override Procedures

### When to Use
- Critical production outage
- Security vulnerability patch
- Data loss risk

### Process
1. **Incident Commander** (DevOps Lead or CTO) declares emergency
2. Temporary bypass of approval requirements (still requires PR)
3. Minimum 1 senior engineer approval
4. Post-incident review mandatory within 24 hours

### Audit Trail
All emergency overrides logged and reviewed weekly.

---

## Platform-Specific Setup

### GitHub
```
Settings → Branches → Add rule

Branch name pattern: main
☑ Require a pull request before merging
  ☑ Require approvals: 2
  ☑ Dismiss stale pull request approvals when new commits are pushed
  ☑ Require review from Code Owners
☑ Require status checks to pass before merging
  ☑ Require branches to be up to date before merging
  Status checks: ci/build, ci/test, ci/lint, ci/analyze, ci/coverage
☑ Require linear history
☑ Do not allow bypassing the above settings
☑ Restrict who can push to matching branches
```

### GitLab
```
Settings → Repository → Protected Branches

Branch: main
Allowed to merge: Maintainers
Allowed to push: No one
Allowed to force push: No
Code owner approval: Required

Settings → Merge Requests
☑ Pipelines must succeed
☑ All threads must be resolved
☑ Require 2 approvals
```

### Bitbucket
```
Repository settings → Branch permissions

Branch name: main
Merge via pull request only: Yes
Required approvals: 2
Require approvals from Code Owners: Yes
Required successful builds: 1
Prevent branch deletion: Yes
```

---

## Monitoring & Compliance

### Weekly Audit
- Review all direct pushes to protected branches (should be zero)
- Review emergency override usage
- Check stale branch cleanup logs

### Monthly Report
- Number of PRs merged
- Average time to merge
- Approval patterns
- CI/CD failure rates

### Alerts
- Notification when protection rules are modified
- Alert when emergency override is used
- Warning when CI checks are skipped

---

## References

- [Git Workflow](file:///Users/dineshhannurkar/Development/app/docs/governance/git-workflow.md)
- [Pull Request Process](file:///Users/dineshhannurkar/Development/app/docs/governance/pull-request-process.md)
- [Commit Conventions](file:///Users/dineshhannurkar/Development/app/docs/governance/commit-conventions.md)
