---
name: migration-code-guardrails
description: Use this skill during implementation or code review of migration slices to enforce selected guardrails for clean boundaries, domain-specific naming, command-query separation, and explicit orchestration without turning migration into a generic style exercise.
---

# Migration Code Guardrails

Use this skill during implementation and review of migration slices.

The goal is to enforce a small set of high-value coding guardrails that support legacy-to-DDD/Clean Architecture migration without introducing generic style noise.

This skill intentionally adopts and adapts a selective subset of rules inspired by the NeoLabHQ DDD plugin:

- clean architecture and DDD boundaries
- separation of concerns
- domain-specific naming
- command-query separation
- explicit side effects and transparent orchestration
- explicit control flow and explicit data flow, only when they improve migration clarity

## When To Use

Use this skill when the task involves:

- implementing a migration slice
- reviewing code written in the safe area
- extracting business logic from legacy modules
- moving orchestration out of UI or infrastructure
- creating new Domain/Application/Infrastructure/Presentation code
- validating whether a new abstraction is honest and justified

Typical agents:

- `clean-migration-worker`
- `ddd-design`, only when proposing implementation-oriented structure

## Core Principle

The migration is not a generic cleanup initiative.

Apply these guardrails only when they improve one or more of:

- domain clarity
- architectural boundaries
- traceability to legacy behavior
- safe incremental migration
- testability

Do not introduce refactoring that is stylistically cleaner but outside the approved slice.

## Adopted Guardrails

### 1. Keep Domain And Infrastructure Separate

Business logic must not depend on frameworks, database clients, filesystem code, HTTP libraries, UI concerns, or SDK-specific adapters.

### 2. Enforce Separation Of Concerns

Each layer should do one kind of work:

- Presentation handles interaction and transport concerns
- Application orchestrates use cases
- Domain protects invariants and behavior
- Infrastructure implements technical details

### 3. Prefer Domain-Specific Naming

Use names that reflect the bounded context and responsibility.

Prefer:

- `InvoiceNumberGenerator`
- `AbsenceApprovalPolicy`
- `ImportEmployeeDocumentUseCase`

Avoid generic names unless there is a real cross-context concept:

- `Utils`
- `Helpers`
- `Common`
- `Shared`
- `Manager`
- `Service` when the actual responsibility is narrower and clearer

### 4. Respect Command-Query Separation

A function should either:

- return data without hidden mutation, or
- perform a side effect/state change

### 5. Keep Side Effects Explicit In Orchestration

Application orchestration should make important side effects visible.

When useful, the reader should be able to scan a use case and see:

- load
- validate
- invoke domain behavior
- persist
- notify/publish/integrate

### 6. Use Explicit Control Flow And Data Flow Pragmatically

Prefer code where a reviewer can see:

- where decisions happen
- where data is transformed
- where errors are raised

## Adaptation For Migration Work

These guardrails are adapted for migration work and therefore have special limits:

- do not trigger renaming-only refactors outside the selected slice
- do not split files only to satisfy aesthetics
- do not introduce new abstractions without migration value
- do not force full purity when a thin legacy seam is the safer option
- do not rewrite orchestration solely to satisfy an abstract rule

If a legacy compromise is retained intentionally, document it in implementation notes and validation.

## Review Questions

When implementing or reviewing a slice, ask:

1. Is this code in the right layer?
2. Does the name reflect the domain or just a generic utility bucket?
3. Is this function a command, a query, or an unclear mix of both?
4. Are important side effects visible enough to review safely?
5. Did we introduce any abstraction that hides behavior rather than clarifying it?
6. Did we improve the migration target without expanding scope?

## Output Format

When useful, report guardrail findings with this table:

| Guardrail | File | Finding | Risk | Suggested Adjustment |
|---|---|---|---|---|

When there are no meaningful issues, state that the implemented slice is consistent with the migration guardrails.

## Final Checklist

Before accepting the implementation, verify:

- boundary direction is still correct
- new names are domain-specific enough
- commands and queries are not misleading
- main side effects are reviewable
- no style-only refactor expanded the slice
- compromises are documented when kept intentionally
