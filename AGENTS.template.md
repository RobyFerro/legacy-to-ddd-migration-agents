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
- Use `target-build-worker` only if the user explicitly starts a delivery/build phase for the new target project.

Codex may not expose these profile names as direct `spawn_agent.agent_type` values.
When delegating, prefer this runtime mapping unless the current Codex build explicitly supports the custom type:

- `legacy-discovery` -> `explorer` plus `legacy-business-logic-extraction`
- `ddd-design` -> `explorer` plus `ddd-aggregate-design` and `clean-architecture-boundaries`
- `target-build-worker` -> `worker` plus the phase-appropriate implementation skill, only for the new target project

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

Default artifact root:

- `migration/`

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

 - `migration/00-system/`
 - `migration/bounded-contexts/<bounded-context-slug>/01-discovery/`
 - `migration/bounded-contexts/<bounded-context-slug>/02-design/`
 - `migration/bounded-contexts/<bounded-context-slug>/03-develop/`

During `DISCOVERY`, create or update at least:

- `migration/migration-project.yaml`
- `migration/00-system/bounded-context-catalog.md`
- `migration/00-system/bounded-context-catalog.yaml`
- `migration/00-system/context-map.md`

When a specific bounded context is analyzed in enough depth, also create or update:

- `migration/bounded-contexts/<bounded-context-slug>/01-discovery/discovery.md`
- `migration/bounded-contexts/<bounded-context-slug>/01-discovery/discovery.yaml`

## Source Reference Policy

In all phases, agents must read the original legacy source code as a mandatory co-reference alongside phase artifacts.

- In DISCOVERY: legacy source is the primary input (entire mission is source code analysis)
- In DESIGN: discovery artifacts provide interpretation and summarization; legacy source code verifies those findings and fills gaps
- In DEVELOP: design artifacts define the target model; legacy source code validates that the implementation correctly represents legacy behavior

**Key principle:** Reading artifacts without cross-checking against the source is not sufficient. Artifacts encode a team's interpretation at a point in time. The source is always more current and more authoritative.

**Conflict resolution:** When an artifact and the source code contradict each other, the source code takes precedence. Raise the contradiction explicitly and state that the implementation follows the source.

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

---

## Phase Readiness Criteria

### DISCOVERY → DESIGN Readiness

Before moving from DISCOVERY to DESIGN, confirm:

- System-level bounded-context catalog has been created (`migration/00-system/bounded-context-catalog.md`)
- At least 3 candidate bounded contexts have been identified
- Confidence level for each BC is at least Medium
- Main application flows have been documented for each candidate BC
- Business logic classification table has at least one entry per BC
- Open questions that block design decisions are explicitly listed
- No unbounded scope creep during discovery

### DESIGN → DEVELOP Readiness

Before moving from DESIGN to DEVELOP, confirm:

- At least one bounded context has a complete design document (`02-design/design.md`)
- Aggregate definitions are explicit (aggregate roots, entities, value objects)
- Business rule placement table is populated (legacy location → target layer)
- Application use cases are defined for the selected build scope
- Repository interfaces and external gateways are identified
- No unresolved "Unknown / Needs human validation" items that block the selected scope
- Clean Architecture layer dependency rules are understood

---

## Artifact Ownership Matrix

| Artifact | Created/Updated By | Read By | Conflict Rule |
|---|---|---|---|
| `migration-project.yaml` | legacy-discovery, ddd-design, target-build-worker | all agents | Last writer owns; append version field on conflict |
| `00-system/bounded-context-catalog.md` | legacy-discovery | ddd-design | ddd-design reads only; never overwrites |
| `00-system/bounded-context-catalog.yaml` | legacy-discovery | ddd-design | ddd-design reads only; never overwrites |
| `00-system/context-map.md` | legacy-discovery | ddd-design | ddd-design reads only; never overwrites |
| `[slug]/01-discovery/discovery.md` | legacy-discovery | ddd-design | ddd-design reads only; never modifies |
| `[slug]/01-discovery/discovery.yaml` | legacy-discovery | ddd-design | ddd-design reads only; never modifies |
| `[slug]/02-design/design.md` | ddd-design | target-build-worker | target-build-worker reads only; never modifies |
| `[slug]/02-design/model.yaml` | ddd-design | target-build-worker | target-build-worker reads only; never modifies |
| `[slug]/03-develop/develop.md` | target-build-worker | — | Append-only; update with session summaries |
| `[slug]/03-develop/validation.md` | target-build-worker | — | Overwrite per validation run |

---

## Agent Selection Guide

Use this table to choose which agent profile and skills to invoke for each task:

| Task | Agent Profile | Map to Codex Built-In | Required Skills | When to Use |
|---|---|---|---|---|
| Broad legacy discovery | `legacy-discovery` | `explorer` | `legacy-business-logic-extraction` | Start of DISCOVERY phase; analyze entire legacy system |
| Deep bounded-context discovery | `legacy-discovery` | `explorer` | `legacy-business-logic-extraction` | During DISCOVERY; focus on one or more selected BCs |
| DDD/Clean design synthesis | `ddd-design` | `explorer` | `ddd-aggregate-design`, `clean-architecture-boundaries` | During DESIGN phase; transform discovery into target model |
| Architecture review | `target-build-worker` | `worker` | `clean-architecture-boundaries`, `architecture-validation` | Validate that delivered code respects Clean Architecture |
| Target system implementation | `target-build-worker` | `worker` | `clean-architecture-boundaries`, `architecture-validation`, `migration-code-guardrails` | During DEVELOP phase; build new target project |

### Codex Runtime Notes

As of May 2026, Codex Desktop and other Codex implementations expose built-in agent types:

- `explorer`: read-only analysis agent; ideal for discovery and design
- `worker`: workspace-write agent; needed for implementation and code modifications

When spawning subagents, map custom profile names to these standard types. If your Codex version supports custom profile names directly (e.g., `spawn_agent(agent_type="legacy-discovery")`), use them. Otherwise, use the Codex built-in names and combine with the required skills list.
