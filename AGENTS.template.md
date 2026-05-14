# Legacy To DDD + Clean Architecture Migration

This repository is being migrated from legacy architecture to Domain-Driven Design and Clean Architecture.

The goal is not a big-bang rewrite.
The goal is to discover, model, migrate, and validate incrementally using a broad-to-specific workflow.

## Migration Workflow

The migration must follow this workflow:

1. Broad discovery of the whole legacy system
2. Identification of candidate bounded contexts and their simple relationship map
3. Selection of one bounded context
4. Deep discovery of the selected bounded context
5. DDD design and migration planning for that bounded context
6. Implementation of one approved migration slice in the safe area
7. Validation and artifact update

Do not implement code before broad discovery, bounded-context design, and migration planning have been completed for the selected scope.

## Agent Usage

Use the appropriate agent depending on the task:

- Use `legacy-discovery` to analyze the legacy repository and extract business knowledge.
- Use `ddd-design` to transform the discovered knowledge into a DDD + Clean Architecture model.
- Use `clean-migration-worker` to implement one small migration step at a time.

If the user does not explicitly specify the agent, choose the safest agent for the current phase.

## General Principles

- Work incrementally.
- Never migrate the whole application or a whole bounded context at once.
- Prefer one bounded context, aggregate, use case, feature, or module per iteration.
- Preserve legacy behavior unless the user explicitly requests a behavior change.
- Keep changes small, reviewable, and reversible.
- Always explain architectural decisions.
- Mark uncertain findings as `Needs human validation`.
- When information is incomplete, propose explicit hypotheses with a confidence level instead of pretending certainty.
- Prefer explicit trade-offs over hidden assumptions.
- Keep discovery and design artifacts traceable to concrete legacy files, methods, SQL, modules, or flows.

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

## Workspace And Artifact Rules

The migration workspace is expected under `migration/`.

The central manifest is `migration/migration-project.yaml`.

System-level artifacts should live under `migration/00-system/`.

Per-bounded-context artifacts should live under `migration/bounded-contexts/<bounded-context-slug>/`.

Per-bounded-context artifacts should be organized by phase:

- `01-discovery/`
- `02-design/`
- `03-planning/`
- `04-implementation/`

Implementation artifacts should be organized by slice under:

- `04-implementation/slices/<slice-id>/`

Standalone migration projects should live under `migration/new-projects/`.

Safe-area implementation code may live under `migration/safe-area/` only when that mode is explicitly chosen.

Keep artifacts updated as the migration evolves.

## Migration Rules

Before implementation, produce or update a migration plan.

The migration plan must include:

- selected scope
- reason for selecting that scope
- legacy behavior to preserve
- files to read
- files to create
- files to modify
- tests to add or update
- risks
- rollback strategy
- definition of done

During implementation:

- Move only the rules included in the selected scope.
- Avoid unrelated refactoring.
- Avoid formatting-only changes in unrelated files.
- Keep public contracts stable unless the migration explicitly requires adapters.
- Add tests around moved business rules whenever possible.
- Prefer introducing seams and adapters over big-bang rewrites.
- Prefer implementation inside `migration/new-projects/`.
- Use `migration/safe-area/` only when the migration strategy explicitly chooses a strangler-style internal target.
- Touch legacy code only through thin seams when a standalone project is the chosen target.

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
| Broad discovery | `legacy-discovery` | `legacy-business-logic-extraction` |
| Deep bounded-context discovery | `legacy-discovery` | `legacy-business-logic-extraction` |
| DDD design | `ddd-design` | `ddd-aggregate-design`, `clean-architecture-boundaries` |
| Migration planning | `clean-migration-worker` | `migration-slice-planning`, `clean-architecture-boundaries` |
| Implementation | `clean-migration-worker` | `clean-architecture-boundaries`, `migration-code-guardrails` |
| Validation | `clean-migration-worker` | `architecture-validation`, `migration-code-guardrails` |

### Skill Rules

- Use `legacy-business-logic-extraction` to find hidden business rules in UI, services, repositories, SQL, helpers, DTOs, mappers, filesystem operations, batch jobs, and integration code.
- Use `ddd-aggregate-design` when evaluating aggregates, aggregate roots, entities, value objects, invariants, and consistency boundaries.
- Use `clean-architecture-boundaries` when deciding whether a responsibility belongs to Domain, Application, Infrastructure, or Presentation.
- Use `migration-slice-planning` before implementation to split large scopes into small, safe, reversible migration slices.
- Use `migration-code-guardrails` during implementation and review to enforce selective coding guardrails: boundary separation, domain-specific naming, command-query separation, and explicit orchestration.
- Use `architecture-validation` after implementation to validate scope, diff, layer dependencies, behavior preservation, tests, and risks.

## Mandatory Agent Workflow For Bounded Context Migration

When the user asks to plan or execute a migration from legacy architecture to DDD/Clean Architecture for a bounded context, Codex must use the project agents and the appropriate skills.

Example user request:

`Pianifica la migrazione da legacy a DDD del bounded context DocumentMining`

This request must trigger the following workflow:

1. Use the `legacy-discovery` agent with the `legacy-business-logic-extraction` skill for broad discovery if the system map is missing or stale.
2. Use the `legacy-discovery` agent again for deep bounded-context discovery.
3. Use the `ddd-design` agent with the `ddd-aggregate-design` and `clean-architecture-boundaries` skills.
4. Use the `clean-migration-worker` agent with the `migration-slice-planning` skill for planning only.
5. Stop before implementation unless the user explicitly approves a selected slice.
6. After approval, use the `clean-migration-worker` agent with `clean-architecture-boundaries` for implementation in the safe area.
7. After implementation, use the `clean-migration-worker` agent with `architecture-validation`.

### Planning Requests

If the user says:

- `Pianifica la migrazione da legacy a DDD del bounded context [Name]`
- `Pianifica la migrazione del BC [Name]`
- `Prepara il piano di migrazione DDD/Clean per [Name]`
- `Analizza e pianifica la migrazione di [Name]`

then Codex must treat the request as a planning request.

For planning requests:

- initialize the migration workspace if missing
- use `legacy-discovery` for broad discovery when needed
- use `legacy-discovery` again for the selected bounded context
- then use `ddd-design`
- then use `clean-migration-worker` only for migration planning
- do not modify production code
- do not implement
- do not skip discovery
- do not skip design
- do not skip migration planning
- produce or update:
  - `migration/migration-project.yaml`
  - `migration/00-system/bounded-context-catalog.md`
  - `migration/00-system/bounded-context-catalog.yaml`
  - `migration/00-system/context-map.md`
  - `migration/bounded-contexts/<bounded-context-slug>/01-discovery/discovery.md`
  - `migration/bounded-contexts/<bounded-context-slug>/01-discovery/discovery.yaml`
  - `migration/bounded-contexts/<bounded-context-slug>/02-design/design.md`
  - `migration/bounded-contexts/<bounded-context-slug>/02-design/model.yaml`
  - `migration/bounded-contexts/<bounded-context-slug>/03-planning/migration-plan.md`

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
- prefer implementation inside `migration/new-projects/`
- use `migration/safe-area/` only when explicitly selected
- produce or update:
  - `migration/bounded-contexts/<bounded-context-slug>/04-implementation/slices/<slice-id>/slice.md`
  - `migration/bounded-contexts/<bounded-context-slug>/04-implementation/slices/<slice-id>/traceability.md`
  - `migration/bounded-contexts/<bounded-context-slug>/04-implementation/slices/<slice-id>/validation.md`
  - optionally `migration/bounded-contexts/<bounded-context-slug>/04-implementation/slices/<slice-id>/handoff.md`

### Required Final Response For Planning

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

- `migration/migration-project.yaml`
- `migration/00-system/bounded-context-catalog.md`
- `migration/00-system/bounded-context-catalog.yaml`
- `migration/00-system/context-map.md`
- `migration/bounded-contexts/<bounded-context-slug>/01-discovery/discovery.md`
- `migration/bounded-contexts/<bounded-context-slug>/01-discovery/discovery.yaml`
- `migration/bounded-contexts/<bounded-context-slug>/02-design/design.md`
- `migration/bounded-contexts/<bounded-context-slug>/02-design/model.yaml`
- `migration/bounded-contexts/<bounded-context-slug>/03-planning/migration-plan.md`
- `migration/bounded-contexts/<bounded-context-slug>/04-implementation/slices/<slice-id>/slice.md`
- `migration/bounded-contexts/<bounded-context-slug>/04-implementation/slices/<slice-id>/traceability.md`
- `migration/bounded-contexts/<bounded-context-slug>/04-implementation/slices/<slice-id>/validation.md`
