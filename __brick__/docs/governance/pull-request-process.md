# Pull Request Process

## Overview

Pull Requests (PRs) are the primary mechanism for code review and integration in Project App. This document outlines the complete PR lifecycle from creation to merge.

---

## Before Creating a PR

### Pre-submission Checklist
- [ ] Branch is up-to-date with target branch (`develop` or `main`)
- [ ] All commits follow [Conventional Commits](file:///Users/dineshhannurkar/Development/app/docs/governance/commit-conventions.md)
- [ ] Code is formatted (`dart format .`)
- [ ] Linting passes (`dart analyze`)
- [ ] All tests pass locally (`flutter test`)
- [ ] New tests added for new functionality
- [ ] Documentation updated (if applicable)

---

## Creating a Pull Request

### 1. Push Your Branch
```bash
git push origin feature/FE-042-login-screen
```

### 2. Open PR on Platform
- Navigate to repository on GitHub/GitLab
- Click "New Pull Request"
- **Base branch**: `develop` (or `main` for hotfixes)
- **Compare branch**: Your feature/bugfix/hotfix branch

### 3. Fill Out PR Template
The PR template will auto-populate. Complete ALL sections:
- ✅ Description of changes
- ✅ Type of change (feat, fix, refactor, etc.)
- ✅ Clean Architecture compliance checklist
- ✅ Testing checklist
- ✅ Breaking change declaration

### 4. Link Related Tasks
```
Closes: FE-042
Relates-to: API-101
```

### 5. Request Reviews
- **CODEOWNERS** are auto-assigned based on files changed
- Manually add additional reviewers if needed
- Minimum reviewers:
  - **2 approvals** for `main`
  - **1 approval from Code Owner** for `develop`

---

## PR Title Format

Follow the same format as commit messages:

```
<type>(<scope>): <description>
```

### Examples
- ✅ `feat(presentation): add login screen with email validation`
- ✅ `fix(data): resolve memory leak in image cache`
- ✅ `refactor(domain): extract validation to use case`

---

## Review Process

### Reviewer Assignment

#### Automatic Assignment (via CODEOWNERS)
Based on files changed:
- `/lib/presentation/` → `@frontend-developer`
- `/lib/domain/` → `@api-architect`, `@backend-engineer`
- `/lib/data/` → `@backend-engineer`, `@database-engineer`

#### Manual Assignment
For cross-cutting concerns, assign:
- **Architecture review**: `@api-architect`
- **Security review**: `@devops-infrastructure`
- **Performance review**: `@qa-reviewer`

### Reviewer Responsibilities

#### Code Owners
Must review within **24 hours** (48 hours for large PRs)

#### Review Checklist
Reviewers should verify:
- [ ] **Architecture**: Clean Architecture boundaries respected
- [ ] **Testing**: Adequate test coverage (domain ≥ 100%, overall ≥ 80%)
- [ ] **Security**: No sensitive data leaks, proper auth handling
- [ ] **Performance**: No unnecessary widget rebuilds, memory leaks
- [ ] **Code Quality**: Readable, maintainable, follows style guide
- [ ] **Documentation**: Complex logic is commented
- [ ] **Governance**: Aligns with project-overview.yaml contracts

---

## Review Feedback

### Types of Comments

#### 🔴 **Blocking** (Must Fix)
Critical issues that **must** be addressed before approval:
- Architecture violations
- Security vulnerabilities
- Failing tests
- Breaking changes without migration plan

**Format:**
```
🔴 BLOCKING: UI layer directly accessing data source (violates Clean Architecture)
```

#### 🟡 **Non-blocking** (Should Fix)
Important suggestions that improve quality but don't block merge:
- Code style improvements
- Performance optimizations
- Better naming

**Format:**
```
🟡 Suggestion: Consider extracting this logic to a separate use case for reusability
```

#### 🟢 **Informational** (Nice to Have)
Optional improvements or questions:
- Alternative approaches
- Future refactoring ideas

**Format:**
```
🟢 FYI: We might want to add caching here in the future
```

#### 💬 **Question**
Clarifications or discussions:
```
💬 Question: Why did we choose BLoC over Cubit here?
```

### Responding to Feedback

#### As PR Author
- Address **all blocking comments** before requesting re-review
- Respond to questions and suggestions
- If you disagree, explain reasoning (healthy discussion encouraged)
- Mark conversations as resolved once addressed

#### As Reviewer
- Be constructive, not critical
- Explain **why** something should change
- Provide examples or references
- Approve when all blocking issues are resolved

---

## CI/CD Checks

All PRs must pass automated checks before merge:

### Required Checks
| Check | Description | Timeout |
|-------|-------------|---------|
| `ci/build` | Build succeeds on all platforms | 10 min |
| `ci/test` | All tests pass | 15 min |
| `ci/lint` | Dart analyze + format check | 5 min |
| `ci/analyze` | Static code analysis | 5 min |
| `ci/coverage` | Coverage thresholds met | 5 min |

### Failed Check Resolution
1. Review CI logs to identify failure
2. Fix issue locally
3. Push new commit
4. CI re-runs automatically

---

## Merge Process

### Approval Requirements

| Target Branch | Approvals Required | Additional Checks |
|---------------|-------------------|-------------------|
| `develop` | 1 (from Code Owner) | All CI checks pass |
| `main` | 2 (including Code Owner) | All CI + manual QA |
| `release/*` | 2 (including QA Reviewer) | Full test suite |

### Merge Strategies

#### Squash and Merge (Default for Features)
**When**: Merging `feature/*` or `bugfix/*` to `develop`

**Effect**: All commits squashed into one

**Final Commit Message Format:**
```
feat(presentation): implement user profile screen

Complete user profile feature including:
- Profile view with avatar, name, email
- Edit profile form with validation
- Avatar upload with image picker
- BLoC pattern state management
- Unit and widget tests

Closes: FE-042, FE-043, FE-044
```

#### Merge Commit (for Releases/Hotfixes)
**When**: Merging `release/*` or `hotfix/*` to `main`

**Effect**: Preserves commit history

### Who Can Merge

| Branch | Who Can Merge |
|--------|---------------|
| `main` | Release Manager, DevOps Lead |
| `develop` | Anyone with required approvals |
| `feature/*` | Branch owner (after PR approval) |

---

## Post-Merge Actions

### Automatic Actions
- ✅ Source branch deleted (for `feature/*`, `bugfix/*`)
- ✅ Linked tasks/issues closed
- ✅ Changelog updated (for `main` merges)
- ✅ Version tag created (for `main` merges)

### Manual Follow-up
- Update related documentation
- Notify team in messenger files
- Monitor deployment (for `main` merges)

---

## Merge Conflicts

### Prevention
Keep your branch up-to-date:
```bash
# Regularly sync with develop
git checkout develop
git pull origin develop
git checkout feature/FE-042-login-screen
git merge develop
# Resolve conflicts locally
git push origin feature/FE-042-login-screen
```

### Resolution Strategy
1. **Update your branch** with latest target branch
2. **Resolve conflicts locally** (not on GitHub UI)
3. **Test thoroughly** after resolution
4. **Push resolution** to your branch
5. **Request re-review** if significant changes

---

## Special Cases

### Draft PRs
Use for:
- Work in progress
- Early feedback
- Architectural discussion

**How to create:**
- Mark as "Draft" when opening PR
- Reviewers can comment but cannot approve
- Convert to "Ready for Review" when complete

### Hotfix PRs
**Expedited process:**
- Target: `main` branch
- Required approvals: 2 (can be expedited)
- SLA: 4-hour review turnaround
- **Must also create PR to merge back to `develop`**

### Dependency Update PRs
- Automated (Dependabot/Renovate)
- Auto-merge if CI passes
- Manual review if major version bump

---

## PR Size Guidelines

### Ideal PR Size
- **Lines changed**: < 400
- **Files changed**: < 10
- **Review time**: < 30 minutes

### Large PR Strategy
If your PR exceeds guidelines:
1. **Split into smaller PRs** (preferred)
2. If impossible to split:
   - Add detailed description
   - Include architecture diagram
   - Schedule live walkthrough with reviewers

---

## Review SLA (Service Level Agreement)

| PR Type | Review SLA | Approval SLA |
|---------|------------|--------------|
| Hotfix | 4 hours | 8 hours |
| Feature | 24 hours | 48 hours |
| Refactor | 24 hours | 48 hours |
| Docs only | 48 hours | 72 hours |

**Escalation**: If SLA not met, tag team lead in PR comments

---

## Code Owner Override

### When Allowed
Code owner approval can be bypassed only if:
1. Code owner is unavailable (vacation, emergency)
2. Urgent hotfix required
3. Incident Commander approval obtained

### Process
1. Tag substitute reviewer (another senior engineer)
2. Document reason in PR description
3. Notify Code Owner in messenger file for post-review

---

## Common Rejection Reasons

### ❌ PR Will Be Rejected If:
1. **Architecture violation**
   - Example: UI directly accessing database
2. **Insufficient tests**
   - Example: Domain logic with < 100% coverage
3. **Breaking change without migration**
   - Example: Changing API contract without deprecation
4. **Security vulnerability**
   - Example: Hardcoded credentials, unencrypted storage
5. **Failing CI checks**
   - Example: Build errors, linting failures

---

## Best Practices

### For PR Authors
1. **Keep PRs small and focused** (one feature/fix per PR)
2. **Write clear descriptions** (explain why, not just what)
3. **Self-review before requesting review**
4. **Respond promptly to feedback**
5. **Keep branch up-to-date** with target

### For Reviewers
1. **Review promptly** (respect SLA)
2. **Be constructive** (suggest, don't demand)
3. **Explain reasoning** (educate, don't criticize)
4. **Approve when standards met** (don't nitpick)
5. **Test locally if needed** (especially for UI changes)

---

## Tools & Automation

### GitHub Actions / GitLab CI
- Auto-assign reviewers based on CODEOWNERS
- Run CI/CD checks on every push
- Auto-label PRs (feat, fix, docs, etc.)
- Size labeling (S, M, L, XL)

### Bots
- **Dependabot**: Auto-update dependencies
- **Stale PR Bot**: Close PRs with no activity in 30 days

---

## Metrics & Monitoring

### PR Health Metrics
- Average time to first review
- Average time to merge
- PR size distribution
- Approval rate
- Revert rate

### Team Goals
- 90%+ of PRs reviewed within SLA
- 80%+ of PRs < 400 lines changed
- < 5% revert rate

---

## References

- [Git Workflow](file:///Users/dineshhannurkar/Development/app/docs/governance/git-workflow.md)
- [Commit Conventions](file:///Users/dineshhannurkar/Development/app/docs/governance/commit-conventions.md)
- [Branch Protection](file:///Users/dineshhannurkar/Development/app/docs/governance/branch-protection.md)
- [Pull Request Template](file:///Users/dineshhannurkar/Development/app/.github/pull_request_template.md)
