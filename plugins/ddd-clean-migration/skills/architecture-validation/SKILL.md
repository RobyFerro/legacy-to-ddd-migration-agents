---
name: architecture-validation
description: Use this skill to validate that implemented code respects Clean Architecture boundaries, DDD consistency, and design specifications. Audits layer dependencies, Domain purity, test coverage, build results, and behavior preservation without writing code.
---

# Architecture Validation

Use this skill to audit code after implementation or to validate a code change against Clean Architecture and DDD rules.

The goal is to verify that the change is small, coherent, reversible, and aligned with DDD + Clean Architecture.

## When to Use

Use this skill when the task involves:

- validating implemented code against Clean Architecture rules
- reviewing a git diff or changed files
- checking layer boundaries and Domain purity
- checking whether the implementation matches the design specification
- identifying behavior regressions
- distinguishing new failures from pre-existing failures
- producing a validation report

## Required Inputs

Before starting, read:
- Original legacy source code for the relevant scope (read-only — verify behavior preservation)
- `migration/bounded-contexts/[slug]/01-discovery/discovery.md` (if it exists)
- `migration/bounded-contexts/[slug]/02-design/design.md` (if it exists)
- `migration/bounded-contexts/[slug]/03-develop/develop.md` (if it exists)
- Current git diff and changed files
- Build output and test output (if available)

Always check both the legacy source and any existing artifacts. Artifacts may be incomplete or absent — fall back to the legacy source as ground truth.

## Core Principle

Do not assume the implementation is correct because it compiles.

Validate:

- scope
- behavior
- architecture
- tests
- risks
- reversibility

## Validation Inputs

When available, read:

- `migration/bounded-contexts/[slug]/01-discovery/discovery.md`
- `migration/bounded-contexts/[slug]/02-design/design.md`
- `migration/bounded-contexts/[slug]/03-develop/develop.md`
- current git diff and changed files
- test output and build output
- existing architecture tests

## Validation Checklist

Check:

- Were only planned files modified?
- Did the implementation stay inside the selected scope?
- Were public contracts preserved?
- Was UI behavior preserved?
- Was legacy behavior preserved?
- Were business rules moved to the correct layer?
- Does Domain remain free from technical dependencies?
- Does Application contain orchestration instead of business invariants?
- Does Infrastructure contain technical details instead of business policy?
- Does Presentation avoid owning business workflows?
- Were tests added or updated?
- Were build/test commands executed?
- Are failures related to the slice or pre-existing?
- Is rollback simple?

## Layer Responsibility Reference

For comprehensive layer definitions and responsibilities, see the `clean-architecture-boundaries` skill.

This skill focuses on *validating* layer boundaries in code reviews and pull requests using those definitions.

## Diff Review Method

When reviewing the diff:

1. List all changed files.
2. Compare changed files with the approved design scope (`design.md` and `develop.md`).
3. Identify unexpected files.
4. For each changed file, explain the purpose of the change.
5. Check whether behavior changed intentionally or accidentally.
6. Check whether tests cover the changed behavior.
7. Check whether new abstractions are justified.
8. Check whether the slice can be rolled back safely.

## Output Format

Use this format:

## Architecture Validation Report

### Scope

Describe the migration slice being validated.

### Changed Files

| File | Planned? | Change Summary | Risk |
|---|---|---|---|

### Scope Compliance

| Check | Result | Notes |
|---|---|---|
| Only planned files modified | Pass/Fail/Warning | |
| No unrelated refactoring | Pass/Fail/Warning | |
| Public contracts preserved | Pass/Fail/Warning | |
| UI behavior preserved | Pass/Fail/Warning | |
| DB schema unchanged unless planned | Pass/Fail/Warning | |

### Layer Compliance

| Rule | Result | Evidence | Notes |
|---|---|---|---|
| Domain does not depend on Infrastructure | Pass/Fail/Warning | | |
| Domain does not depend on Presentation | Pass/Fail/Warning | | |
| Application contains orchestration only | Pass/Fail/Warning | | |
| Infrastructure does not own domain policy | Pass/Fail/Warning | | |
| Presentation does not own business workflow | Pass/Fail/Warning | | |

### Behavior Preservation

| Legacy Behavior | Preserved? | Evidence | Notes |
|---|---|---|---|

### Tests

| Test / Command | Result | Notes |
|---|---|---|

### Build Result

State whether build was executed.

If build failed, classify errors as:

- caused by this slice
- likely pre-existing
- outside scope
- unknown

Use this table:

| Error | File | Classification | Reason | Suggested Action |
|---|---|---|---|---|

### Risks

| Risk | Impact | Suggested Mitigation |
|---|---|---|

### Rollback Assessment

Explain whether rollback is simple and which files would be reverted.

### Verdict

Choose one:

- Approved
- Approved with warnings
- Needs fixes before acceptance
- Rejected

### Recommended Next Step

Suggest the next smallest useful action.

## Severity Levels

Use these severity levels for findings:

- Critical: breaks behavior, build, data, or public contracts.
- High: violates architecture or changes behavior unexpectedly.
- Medium: risk of future divergence or weak tests.
- Low: minor cleanup or documentation issue.

## Finding Format

When reporting findings, use:

| Severity | Finding | File | Evidence | Recommendation |
|---|---|---|---|---|

## Build/Test Failure Classification

If validation commands fail:

1. Identify the failing command.
2. Extract the relevant errors.
3. Check whether changed files are involved.
4. If errors are outside changed files, mark as likely pre-existing or outside scope.
5. Do not hide failed validation.
6. Do not claim full success if build or tests failed.

## Safety Rules

Do not modify code unless explicitly asked.
Do not fix issues during validation unless the user requests a fix.
Do not broaden the migration scope.
Do not mark a slice as approved if public behavior changed unintentionally.
Do not ignore unexpected files in the diff.

## Final Checklist

Before approving a slice, verify:

- The diff is small.
- The modified files match the plan.
- The behavior is preserved.
- Public contracts are unchanged unless planned.
- Domain remains pure.
- Application does not own core business invariants.
- Infrastructure does not own business policy.
- Presentation does not own business workflow.
- Tests exist or missing tests are explained.
- Build/test result is reported honestly.
- Remaining risks are documented.
- Rollback is clear.
