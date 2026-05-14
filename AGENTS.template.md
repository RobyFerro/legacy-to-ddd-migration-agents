# Legacy-Informed DDD/Clean Architecture Design

This repository is used to understand a legacy system well enough to design a new system from scratch.

The goal is not to repair, refactor, or incrementally migrate the legacy codebase.
The goal is to extract evidence from the legacy system and turn that evidence into better design decisions for a new target system.

## Operating Model

The user decides when a phase starts or ends.
The agent does not autonomously switch phases.
The agent must guide the user with the information needed to make informed decisions.

The default sequence is:

1. Broad discovery of the whole legacy system
2. Optional deep discovery of selected bounded contexts
3. DDD/Clean design synthesis
4. Greenfield develop phase for the selected target scope

Discovery exists to reduce design uncertainty.
It does not exist to identify remediation steps in the legacy code.

The three mandatory phases are:

- `DISCOVERY`
- `DESIGN`
- `DEVELOP`

## Agent Usage

Use the appropriate project agent profile depending on the task:

- Use `legacy-discovery` to analyze the legacy repository and extract domain evidence.
- Use `ddd-design` to transform discovered evidence into a target DDD/Clean design.
- Use `clean-migration-worker` only if the user explicitly starts a delivery/build phase for the new target project.

Codex may not expose these profile names as direct `spawn_agent.agent_type` values.
When delegating, prefer this runtime mapping unless the current Codex build explicitly supports the custom type:

- `legacy-discovery` -> `explorer` plus `legacy-business-logic-extraction`
- `ddd-design` -> `explorer` plus `ddd-aggregate-design` and `clean-architecture-boundaries`
- `clean-migration-worker` -> `worker` plus the phase-appropriate implementation skill, only for the new target project

During broad discovery, the main agent remains responsible for identifying candidate bounded contexts and deciding whether dedicated deep discovery can be delegated safely.
The system may offer parallel deep discovery when that improves evidence quality.

## Core Principles

- Treat the legacy system as an evidence source, not as the target of remediation.
- Never frame discovery findings as mandatory fixes to apply in the legacy code.
- Describe legacy weaknesses as `legacy signals`, `design pressures`, or `domain ambiguities`.
- Prioritize exploration and design by domain centrality, not by ease of incremental extraction.
- Always explain architectural decisions and trade-offs.
- Mark uncertain findings as `Needs human validation`.
- When information is incomplete, state explicit hypotheses with a confidence level.
- Keep discovery and design artifacts traceable to concrete legacy files, methods, SQL, modules, flows, and runtime behaviors.

## Legacy Analysis Rules

Treat all of the following as possible sources of business knowledge:

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

Every discovered rule should be classified as one of:

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

## Recommended Artifacts

Artifacts remain a core part of the workflow.
They should be kept current across all three phases.

Suggested artifact families:

- system bounded-context catalog
- context map
- per-bounded-context discovery report
- per-bounded-context design report
- target model definition
- develop-phase delivery report
- develop-phase validation report
- open questions / validation backlog

Suggested phase structure:

- `00-system/`
- `bounded-contexts/<bounded-context-slug>/01-discovery/`
- `bounded-contexts/<bounded-context-slug>/02-design/`
- `bounded-contexts/<bounded-context-slug>/03-develop/`

## Mandatory Behavioral Rules

When responding after discovery:

- do not recommend remediation of the legacy codebase
- do not recommend migration slices
- do not recommend strangler seams or safe-area strategies
- do not recommend rollback plans for legacy changes
- do recommend deeper discovery when it materially improves design decisions
- do recommend design synthesis when discovery evidence is sufficient
- do recommend whether the user has enough evidence to enter `DESIGN`

When recommending what comes next, the allowed next-step categories are:

- additional discovery
- focused deep discovery on one or more bounded contexts
- DDD/Clean design synthesis
- develop-phase start for the selected target scope
- clarification questions for business ambiguity

Do not present `DEVELOP` as the default next step unless the user explicitly starts that phase.

## Required Final Response Shape

When closing a discovery or design task, summarize:

- scope analyzed
- agents used
- skills used
- evidence quality
- main bounded contexts or design decisions
- central legacy signals
- central design pressures
- open questions
- recommended next decision for the user
- confirmation that no legacy remediation was performed
