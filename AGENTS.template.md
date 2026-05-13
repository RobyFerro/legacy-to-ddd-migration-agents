# Legacy to DDD + Clean Architecture Migration

This repository is being migrated from legacy architecture to Domain-Driven Design and Clean Architecture.

The goal is not to rewrite the whole system at once.
The goal is to discover, model, migrate, and validate the system incrementally.

## Migration Workflow

The migration must follow this workflow:

1. Discovery
2. DDD Design
3. Migration Planning
4. Implementation
5. Validation

Do not implement code before Discovery, DDD Design, and Migration Planning have been completed for the selected scope.

## Agent Usage

Use the appropriate agent depending on the task:

- Use `legacy-discovery` to analyze the legacy repository and extract business knowledge.
- Use `ddd-design` to transform the discovered knowledge into a DDD + Clean Architecture model.
- Use `clean-migration-worker` to implement one small migration step at a time.

If the user does not explicitly specify the agent, choose the safest agent for the current phase.

## General Principles

- Work incrementally.
- Never migrate the whole application at once.
- Prefer one bounded context, aggregate, use case, feature, or module per iteration.
- Preserve legacy behavior unless the user explicitly requests a behavior change.
- Keep changes small, reviewable, and reversible.
- Always explain architectural decisions.
- Mark uncertain findings as `Needs human validation`.
- Prefer explicit trade-offs over hidden assumptions.

## Legacy Analysis Rules

Treat all of the following as possible sources of business logic:

- Controllers
- UI event handlers
- View models
- Application services
- Domain-like services
- Repositories
- Query handlers
- Commands
- DTOs
- Mappers
- Helpers
- Static utility classes
- SQL queries
- Stored procedures
- Database triggers
- Batch jobs
- Scheduled jobs
- Validation logic
- Authorization logic
- State transitions
- Workflow logic
- Calculations
- File import/export logic
- Integration logic with external systems

Do not assume that business logic is already isolated in a single layer.

## Business Rule Classification

Every discovered rule must be classified as one of:

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

## Clean Architecture Rules

The target architecture must respect these dependency rules:

- Domain must not depend on Application, Infrastructure, Presentation, UI, frameworks, databases, or external services.
- Application may depend on Domain and abstractions.
- Infrastructure implements interfaces defined by Application or Domain.
- Presentation/UI depends on Application.
- Dependency injection is configured at the composition root.
- Business invariants belong in the Domain.
- Use case orchestration belongs in the Application layer.
- Technical details belong in Infrastructure.
- UI concerns belong in Presentation/UI.

## DDD Modeling Rules

When designing the target model, identify:

- Bounded Contexts
- Aggregates
- Aggregate roots
- Entities
- Value Objects
- Domain Services
- Domain Events, only when useful
- Repository interfaces
- Application Commands
- Application Queries
- Use cases
- External gateways
- Anti-corruption layers, when needed

Prefer simple models over over-engineered models.

Do not create unnecessary aggregates, services, or abstractions.

## Migration Rules

Before implementation, produce a migration plan.

The migration plan must include:

- Selected scope
- Reason for selecting that scope
- Legacy behavior to preserve
- Files to read
- Files to create
- Files to modify
- Tests to add or update
- Risks
- Rollback strategy
- Definition of Done

During implementation:

- Move only the rules included in the selected scope.
- Avoid unrelated refactoring.
- Avoid formatting-only changes in unrelated files.
- Keep public contracts stable unless the migration explicitly requires adapters.
- Add tests around moved business rules whenever possible.
- Prefer introducing seams and adapters over big-bang rewrites.

## Validation Rules

After implementation, validate:

- Build result
- Test result
- Layer dependency direction
- Domain purity
- Preserved legacy behavior
- Remaining risks
- Incomplete or uncertain findings

Produce a validation summary at the end of each implementation step.

## Skills Usage

Use repository skills when they match the task.

Recommended skill usage:

| Phase | Agent | Skills |
|---|---|---|
| Legacy discovery | `legacy-discovery` | `legacy-business-logic-extraction` |
| DDD design | `ddd-design` | `ddd-aggregate-design`, `clean-architecture-boundaries` |
| Migration planning | `clean-migration-worker` | `migration-slice-planning`, `clean-architecture-boundaries` |
| Implementation | `clean-migration-worker` | `clean-architecture-boundaries` |
| Validation | `clean-migration-worker` | `architecture-validation` |

### Skill Rules

- Use `legacy-business-logic-extraction` to find hidden business rules in UI, services, repositories, SQL, helpers, DTOs, mappers, filesystem operations, batch jobs, and integration code.
- Use `ddd-aggregate-design` when evaluating aggregates, aggregate roots, entities, value objects, invariants, and consistency boundaries.
- Use `clean-architecture-boundaries` when deciding whether a responsibility belongs to Domain, Application, Infrastructure, or Presentation.
- Use `migration-slice-planning` before implementation to split large scopes into small, safe, reversible migration slices.
- Use `architecture-validation` after implementation to validate scope, diff, layer dependencies, behavior preservation, tests, and risks.

## Mandatory Agent Workflow for Bounded Context Migration

When the user asks to plan or execute a migration from legacy architecture to DDD/Clean Architecture for a bounded context, Codex must use the project agents and the appropriate skills.

Example user request:

`Pianifica la migrazione da legacy a DDD del bounded context DocumentMining`

This request must trigger the following workflow:

1. Use the `legacy-discovery` agent with the `legacy-business-logic-extraction` skill.
2. Use the `ddd-design` agent with the `ddd-aggregate-design` and `clean-architecture-boundaries` skills.
3. Use the `clean-migration-worker` agent with the `migration-slice-planning` skill for planning only.
4. Stop before implementation unless the user explicitly approves a selected slice.
5. After approval, use the `clean-migration-worker` agent with `clean-architecture-boundaries` for implementation.
6. After implementation, use the `clean-migration-worker` agent with `architecture-validation`.

### Planning Requests

If the user says:

- `Pianifica la migrazione da legacy a DDD del bounded context [Name]`
- `Pianifica la migrazione del BC [Name]`
- `Prepara il piano di migrazione DDD/Clean per [Name]`
- `Analizza e pianifica la migrazione di [Name]`

then Codex must treat the request as a planning request.

For planning requests:

- use `legacy-discovery`
- then use `ddd-design`
- then use `clean-migration-worker` only for migration planning
- do not modify production code
- do not implement
- do not skip discovery
- do not skip design
- do not skip migration planning
- produce or update:
  - `legacy-discovery-report.md`
  - `ddd-design-proposal.md`
  - `migration-plan.md`

### Implementation Requests

If the user explicitly approves a selected slice using:

`APPROVED: implement this migration slice`

then Codex may use `clean-migration-worker` to implement only the approved slice.

Implementation rules:

- implement only the selected slice
- do not expand scope
- preserve legacy behavior
- do not perform unrelated refactoring
- keep public contracts unchanged unless explicitly planned
- produce or update:
  - `implementation-summary.md`
  - `validation-report.md`

### Required Final Response for Planning

At the end of a planning request, Codex must summarize:

- bounded context analyzed
- agents used
- skills used
- discovery outcome
- DDD/Clean design outcome
- migration slices identified
- recommended first slice
- risks
- open questions
- confirmation that no code was implemented

## Required Output Style

Use structured Markdown reports.

Prefer tables for inventories, mappings, and classifications.

When analyzing code, include file paths as evidence.

When confidence is low, say so explicitly.

Do not hide uncertainty.

## Standard Reports

The expected reports are:

- `legacy-discovery-report.md`
- `ddd-design-proposal.md`
- `migration-plan.md`
- `implementation-summary.md`
- `validation-report.md`
