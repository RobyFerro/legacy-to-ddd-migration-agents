---
name: legacy-business-logic-extraction
description: Use this skill when analyzing legacy code to find hidden business logic in UI, services, repositories, SQL, helpers, DTOs, mappers, filesystem operations, batch jobs, or integration code. Especially useful during DDD/Clean Architecture discovery before designing bounded contexts or aggregates.
---

# Legacy Business Logic Extraction

Use this skill to discover and classify business logic hidden inside a legacy or partially migrated codebase.

The goal is not to refactor code.
The goal is to identify where business decisions currently live.

## When to Use

Use this skill when the task involves:

- legacy discovery
- business rule inventory
- DDD migration analysis
- Clean Architecture migration analysis
- identifying business logic hotspots
- separating domain rules from application, infrastructure, and UI logic

Typical agents:

- `legacy-discovery`
- `ddd-design`, only when validating discovered rules
- `target-build-worker`, only when reviewing whether a planned migration missed rules

## Core Principle

Do not assume business logic is located only in Domain or Service classes.

In legacy systems, business logic may be hidden in:

- ViewModels
- Controllers
- UI event handlers
- Application services
- Infrastructure services
- Repositories
- SQL queries
- Stored procedures
- Database triggers
- DTO construction
- Mappers
- Helpers
- Static utility classes
- Import/export code
- Filesystem operations
- Batch jobs
- Scheduled jobs
- Validation logic
- Authorization logic
- Configuration defaults
- Constants
- Enum-like strings or numbers
- Error messages
- Naming rules
- Fallback logic

## What Counts as Business Logic

Treat the following as possible business logic:

- validation rules
- limits
- thresholds
- status transitions
- workflow steps
- calculations
- date/time rules
- filtering rules
- sorting rules with business meaning
- grouping rules
- defaulting rules
- fallback rules
- authorization rules
- licensing/capability rules
- document naming rules
- collision handling rules
- file lifecycle rules
- import/export transformation rules
- retry or partial-success behavior
- SQL `WHERE` clauses with business meaning
- SQL `CASE` expressions
- SQL joins that encode ownership or hierarchy
- UI rules that decide what is allowed
- duplicated rules across layers

## Extraction Method

When analyzing a scope:

1. Identify entry points.
2. Follow the main flow.
3. Locate decisions, validations, calculations, and side effects.
4. Check whether the same rule appears in more than one file.
5. Identify whether the rule is domain, application, infrastructure, or UI.
6. Record evidence with file paths.
7. Mark uncertainty explicitly.

## Classification

Classify each discovered rule as one of:

- Aggregate invariant
- Entity behavior
- Value Object rule
- Domain Service rule
- Application orchestration
- Infrastructure concern
- Presentation/UI concern
- Data access concern
- Integration concern
- Unknown / Needs human validation

Do not force uncertain rules into Domain.

Use `Unknown / Needs human validation` when the business meaning is unclear.

## Output Format

Produce a table:

| Rule | Location | Evidence | Current Area | Suggested Classification | Confidence | Needs Human Validation |
|---|---|---|---|---|---|---|

## Additional Output

When useful, also produce:

### Business Logic Hotspots

| Hotspot | Why It Matters | Files | Risk |
|---|---|---|---|

### Duplicated Rules

| Rule | Locations | Risk | Suggested Owner |
|---|---|---|---|

### Hidden Domain Concepts

| Concept | Evidence | Possible Target Model | Confidence |
|---|---|---|---|

### Questions for Human Validation

| Question | Why It Matters | Evidence |
|---|---|---|

## Rules for DocuMiner

For this repository, pay special attention to:

- WPF ViewModels that orchestrate business workflows.
- Filesystem operations that encode product behavior.
- PDF import/export rules.
- Template document lifecycle rules.
- Field extraction and page-specific behavior.
- Python transform behavior.
- Graph/script execution rules.
- SQL query and data browser behavior.
- Licensing gates and duplicated capability rules.
- Repository methods that do more than persistence.
- Compatibility code that preserves legacy behavior.

## Safety Rules

Do not modify code.
Do not propose implementation before discovery is complete.
Do not turn every rule into a Domain rule.
Do not ignore UI or Infrastructure just because they are technical layers.
Do not hide uncertainty.
Prefer precise evidence over assumptions.

## Recommended Final Summary

End with:

- highest-risk business logic hotspots
- duplicated rules
- rules likely belonging in Domain
- rules likely belonging in Application
- rules likely belonging in Infrastructure
- rules likely remaining in Presentation/UI
- open questions
- recommended next discovery or design scope
