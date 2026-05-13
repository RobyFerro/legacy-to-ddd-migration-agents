---
name: migration-slice-planning
description: Use this skill when planning incremental legacy-to-DDD/Clean Architecture migrations. It helps split large scopes into small, safe, reversible migration slices before implementation.
---

# Migration Slice Planning

Use this skill to plan small, safe, incremental migration slices.

The goal is to prevent large refactors, big-bang rewrites, and uncontrolled architectural changes.

## When to Use

Use this skill when the task involves:

- creating a migration plan
- splitting a large scope into smaller slices
- deciding what to implement first
- reducing migration risk
- keeping Codex changes small
- avoiding scope creep
- planning DDD/Clean Architecture refactoring

Typical agents:

- `clean-migration-worker`
- `ddd-design`, only when recommending migration slices

## Core Principle

A migration slice must be small, useful, testable, and reversible.

Do not implement a full bounded context in one pass.

Do not implement a full lifecycle in one pass unless explicitly approved.

Prefer one of:

- one business rule
- one use case
- one aggregate behavior
- one value object
- one application service
- one adapter
- one repository split
- one ViewModel delegation
- one validation step

## Slice Size Rules

A good slice usually:

- touches few files
- has a clear behavior to preserve
- can be tested
- has a simple rollback
- avoids schema changes
- avoids public contract changes
- does not modify unrelated UI
- does not mix multiple bounded contexts
- does not combine discovery, design, refactor, and feature changes

A risky slice usually:

- touches Domain, Application, Infrastructure, and Presentation all together
- changes UI and database together
- changes public contracts
- changes persistence schema
- renames widely used concepts
- rewrites a whole repository
- introduces multiple new abstractions
- changes behavior and architecture at the same time
- depends on unclear domain decisions

## Planning Method

When given a scope:

1. Identify the full desired migration outcome.
2. Identify current legacy behavior.
3. Identify business rules to preserve.
4. Identify involved layers.
5. Split the scope into smaller slices.
6. Rank slices by safety and value.
7. Choose the first smallest useful slice.
8. Define out-of-scope items.
9. Define tests.
10. Define rollback strategy.

## Output Format

Use this format:

## Migration Slice Plan

### Overall Scope

Describe the larger migration area.

### Target Outcome

Describe the desired final architecture.

### Behavior to Preserve

| Behavior | Evidence | Must Preserve |
|---|---|---|

### Proposed Slices

| Slice | Scope | Files Likely Involved | Value | Risk | Testability | Recommended Order |
|---|---|---|---|---|---|---|

### Selected First Slice

Describe the first slice to implement.

### Why This Slice First

Explain why it is the safest useful first step.

### Files to Read

| File | Reason |
|---|---|

### Files to Create

| File | Reason |
|---|---|

### Files to Modify

| File | Expected Change |
|---|---|

### Tests to Add or Update

| Test | Type | Purpose |
|---|---|---|

### Explicitly Out of Scope

List what must not be touched in this slice.

### Risks

| Risk | Impact | Mitigation |
|---|---|---|

### Rollback Strategy

Explain how to revert the slice safely.

### Definition of Done

| Criterion | Expected Result |
|---|---|

## Slice Ranking Criteria

Rank possible slices using:

- business value
- architectural value
- implementation risk
- number of files touched
- testability
- reversibility
- dependency complexity
- UI impact
- database impact
- public contract impact

Prefer slices with:

- high value
- low risk
- high reversibility
- high testability
- limited file changes

## Common Slice Patterns

### Domain-Only Slice

Use when the Domain model is missing behavior.

Example:

- add Value Object
- add aggregate method
- add invariant
- add domain tests

Allowed layers:

- Domain
- Tests

Avoid:

- UI
- Infrastructure
- DB schema
- application wiring

### Application Use Case Slice

Use when orchestration is currently in UI or Infrastructure.

Example:

- create `ImportTemplateDocumentsUseCase`
- call domain methods
- call repository interface
- call storage port
- return application result

Allowed layers:

- Application
- Tests
- possibly interfaces/ports

Avoid:

- UI rewiring unless explicitly planned
- infrastructure implementation unless needed

### Infrastructure Adapter Slice

Use when technical behavior must be isolated.

Example:

- file copy adapter
- collision-safe filename resolver
- PDF extraction adapter
- license validator adapter

Allowed layers:

- Infrastructure
- Application port if needed
- Tests

Avoid:

- domain policy changes
- UI changes

### Presentation Delegation Slice

Use when ViewModel currently owns orchestration.

Example:

- ViewModel calls application use case
- ViewModel keeps picker/dialog/progress only

Allowed layers:

- Presentation
- Application interface usage
- Tests if available

Avoid:

- changing UX behavior
- changing domain model at the same time

### Repository Narrowing Slice

Use when a repository is too broad.

Example:

- introduce a narrower query/write interface
- keep existing repository implementation temporarily
- migrate one use case to narrower contract

Allowed layers:

- Application
- Infrastructure
- Tests

Avoid:

- rewriting entire repository
- changing all callers at once

## Anti-Patterns

Avoid plans that say:

- migrate the whole bounded context
- clean all repositories
- refactor all ViewModels
- redesign the database
- rename all namespaces
- replace all legacy models
- implement full lifecycle in one slice
- change public contracts and UI together
- change behavior while changing architecture

If the requested scope is too large, split it.

## DocuMiner-Specific Guidance

For DocuMiner, prefer these slice shapes:

### Licensing

Good first slice:

- make `LicenseService` delegate policy checks to `LicensePolicy`
- keep `ILicenseService` unchanged
- no UI changes

### DocumentMining / Template Documents

Do not implement full lifecycle in one slice unless explicitly approved.

Prefer:

1. Domain behavior on `ExtractionTemplate` / `TemplateDocument`
2. Application use case for import/list
3. Filesystem storage adapter
4. ViewModel delegation for import
5. Application use case for delete
6. ViewModel delegation for delete

### DocumentMining / Field Rules

Prefer:

1. Domain rule clarification
2. Value Objects for page index / bbox index / extraction method
3. Application orchestration
4. UI delegation

### WorkflowProgramming

Prefer:

1. graph definition invariants
2. graph validation behavior
3. execution application service
4. infrastructure adapters for Python/SQL/export

## Approval Gate

If the plan could touch more than one major layer, include an approval gate.

Use this rule:

Do not implement until the user explicitly approves the selected slice.

Recommended approval phrase:

`APPROVED: implement this migration slice`

## Safety Rules

Before implementation, always clarify:

- selected slice
- files to modify
- behavior to preserve
- tests to add
- out-of-scope items
- rollback strategy

During implementation:

- do not expand scope
- do not modify unrelated files
- do not perform formatting-only changes outside scope
- do not change behavior unless explicitly planned
- do not change public contracts unless explicitly planned

## Final Checklist

Before accepting a migration plan, verify:

- Is the slice small?
- Is it useful?
- Is it testable?
- Is it reversible?
- Are out-of-scope items explicit?
- Are public contracts protected?
- Is UI behavior protected?
- Is database schema protected?
- Are risks listed?
- Is the first slice clearly selected?
- Is there an approval gate when needed?
