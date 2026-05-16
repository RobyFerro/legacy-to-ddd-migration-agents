---
name: target-implementation
description: Use this skill when implementing the target system in the DEVELOP phase. Build new code based on design specifications, respecting Clean Architecture layers and maintaining traceability to design/discovery. Greenfield development only.
---

# Target System Implementation

Build isolated parts of a new DDD/Clean Architecture target system based on design specifications.

Your responsibility is to build or validate selected parts of the new target system. You focus exclusively on the new target project, not the legacy codebase. You are the only agent allowed to modify code.

## When to Use

Use this skill when:
- Discovery and design phases are complete for the selected scope
- You have design.md and model.yaml for this BC
- You need to implement one specific scope (aggregate, use case, layer, or vertical slice)
- You need to write tests and validate against design specifications
- You need to document what was built and validate against the target architecture

## Mission

Implement one selected target scope at a time inside the new project.

Valid scopes can be:
1. One bounded context foundation
2. One aggregate and its repository port
3. One use case
4. One query model
5. One infrastructure adapter
6. One integration port and adapter pair
7. One application flow in the new target project

Implementation must prefer a standalone new project. Do not use safe-area or strangler-style guidance by default.

## Implementation Strategy

For every implementation task, follow this workflow:

1. Understand the selected target scope
2. Read relevant discovery and design material
3. Inspect the current target project structure
4. Confirm assumptions that affect the implementation boundary
5. Implement only the selected target scope
6. Add or update tests when possible
7. Run available build/test commands when possible
8. Report what was built, validated, and left open
9. Update the `03-develop` artifacts

## Clean Architecture Rules

Respect these dependency rules:

- Domain must not depend on Application
- Domain must not depend on Infrastructure
- Domain must not depend on Presentation/UI
- Domain must not depend on frameworks
- Domain must not depend on databases, ORMs, file systems, queues, HTTP clients, or external services
- Application may depend on Domain
- Application may define commands, queries, use cases, ports, and abstractions
- Application orchestrates workflows but must not contain core business invariants
- Infrastructure implements technical details and adapters
- Presentation/UI calls Application use cases
- Dependency injection belongs to the composition root

## Safety Rules

Avoid:
- legacy cleanup work outside the requested scope
- unrelated refactoring
- formatting-only changes in unrelated files
- naming-only or style-only refactoring without clear design value
- changing behavior without explicit user approval
- moving infrastructure concerns into Domain
- creating unnecessary abstractions
- making assumptions without marking them

## Required Inputs

Before implementation, look for:

- discovery artifacts
- design artifacts
- existing target project structure, if present
- existing tests
- existing contracts
- existing schemas
- original legacy source code (read-only reference to verify correct behavior translation)
- user-provided scope

If discovery or design is missing, do not implement immediately. Instead, produce a short message explaining what is missing and recommend completing the DISCOVERY or DESIGN phase first.

## Scope Definition

Before writing code, you must define which part of the target system you are building:

**Scope format:** [bounded-context-slug] — [implementation goal]

**Implementation goal examples:**
- "Domain layer: Aggregate + Entities + Value Objects only"
- "Application layer: Use case [name]"
- "Infrastructure adapter: Repository implementation for [aggregate]"
- "Full vertical slice: use case [name] from Domain through Application to Infrastructure"

**Finding the slug:** Look in `migration/00-system/bounded-context-catalog.md` — each bounded context entry has a slug in the first column.

## Inputs

Read these to understand baseline:
- migration/migration-project.yaml
- migration/bounded-contexts/[slug]/01-discovery/discovery.md
- migration/bounded-contexts/[slug]/02-design/design.md
- migration/bounded-contexts/[slug]/02-design/model.yaml
- Target project structure under migration/new-projects/[slug]/

**Also read (reference only, do not modify):**
- Original legacy source code — verify that the implementation correctly represents legacy behavior
- Legacy tests — understand behavioral expectations not fully captured in design artifacts
- Legacy database schema — validate data constraints and edge cases

## Objectives

1. Build only the requested scope in the new target system
2. Respect Clean Architecture layers (Domain, Application, Infrastructure, Presentation)
3. Maintain traceability to design and discovery artifacts
4. Add or update tests when possible
5. Validate that the implementation matches the target design
6. Report what was built, what tests were added, and any risks

## Output Format

After implementation, produce a Delivery Summary:

### Delivery Summary

#### Scope

Describe the selected target scope.

#### Files Changed

| File | Change Type | Reason |
|---|---|---|

#### Architecture Impact

Describe how the change advances the new DDD/Clean Architecture target.

#### Tests

Describe tests added, updated, executed, or missing.

#### Validation

| Check | Result | Notes |
|---|---|---|

#### Remaining Risks

| Risk | Impact | Suggested Next Step |
|---|---|---|

#### Recommended Next Decision

Recommend the next user decision for the build phase.

## Artifacts

Create or update:
- migration/bounded-contexts/[slug]/03-develop/develop.md (what was built, decisions made)
- migration/bounded-contexts/[slug]/03-develop/validation.md (build results, test results, risks)
- New implementation files under migration/new-projects/[slug]/

## Roadmap Update

After completing a full BC implementation scope, update the Roadmap if it exists:

1. In `migration/Roadmap.yaml`, find the `implementation` task for this BC slug under `roadmap.develop.bounded_contexts`. Set `status` to `done` and `date_completed` to today's date only when the full BC implementation is complete — not for partial scopes (e.g., a single aggregate).
2. In `migration/Roadmap.md`, change `- [ ] Implementation: [slug]` to `- [x] Implementation: [slug] *(completed YYYY-MM-DD)*` when the BC is fully implemented.

If only a partial scope was implemented, add a `notes` entry to the `implementation` task in `Roadmap.yaml` describing what was completed (e.g., `"Domain layer complete — Application and Infrastructure pending"`).

If `migration/Roadmap.md` does not exist, skip this step and suggest running `init-migration` first.

## Constraints

- Do not modify the legacy system (no writes). Reading the legacy source code for reference is required and encouraged.
- Do not expand scope beyond what was approved.
- Do not perform unrelated refactoring.
- Do not violate the target architecture boundaries.
- Respect Clean Architecture: Domain pure, Application orchestrates, Infrastructure adapts.

## Fallback

Before writing any code, confirm that design.md and model.yaml exist for this scope.

If design artifacts are missing or incomplete:
- Stop and report what is missing.
- Do not invent design decisions.
- Recommend returning to DESIGN phase.

If the design does not cover the requested scope:
- Report the gap explicitly.
- Recommend design clarification before continuing.

## Validation After Implementation

After implementation, check:

- Build succeeds (run `dotnet build` or equivalent)
- Tests pass (run `dotnet test` or equivalent)
- Layer dependency direction is correct
- Domain purity is preserved
- Remaining risks are documented
- Incomplete assumptions are marked
- Files changed are listed and justified

If build or tests fail, report the failure clearly and explain the likely cause. Do not hide failed validation. Do not claim full success if build or tests failed.

## What Comes Next

After each implementation scope is complete, you have several options:

1. **Implement the next scope** in the same BC — if you have capacity and the user approves
2. **Validate the implementation** — use `architecture-validation` skill to audit the code against Clean Architecture rules
3. **Document the work** — complete the 03-develop/develop.md and 03-develop/validation.md artifacts

Next skill (optional): `architecture-validation` (to verify implementation matches the target design)
