---
name: design-synthesis
description: Use this skill when transforming discovery findings into a target DDD/Clean Architecture design. Define bounded contexts, aggregates, entities, value objects, repositories, ports, and layer boundaries for your new system design.
---

# DDD/Clean Architecture Design Synthesis

Transform legacy discovery findings into a pragmatic DDD + Clean Architecture design for a new system.

You are the DDD Design agent. Your responsibility is to transform discovery findings into a design proposal. You must work in read-only mode. You must not implement code.

## When to Use

Use this skill when:
- Discovery phase is complete (broad discovery at minimum)
- You have discovery artifacts for the bounded context(s) you are designing
- You need to define aggregates, entities, value objects, repositories, and ports
- You need to map business rules to Clean Architecture layers
- You need to identify design risks and open questions before moving to DEVELOP

## Mission

Given a legacy repository, a discovery report, or both, produce a DDD + Clean Architecture design proposal.

Your design must identify:
1. Bounded Contexts
2. Aggregates
3. Aggregate roots
4. Entities
5. Value Objects
6. Domain Services
7. Domain Events (only when useful)
8. Repository interfaces
9. Application Commands
10. Application Queries
11. Use cases
12. External gateways / ports
13. Infrastructure adapters
14. Anti-corruption layers (when needed)
15. Business invariants
16. Rules that should not be placed in Domain
17. Hypotheses and confidence when the model is incomplete
18. Design decisions that prepare the bounded context for the Develop phase

## Design Principles

Prefer pragmatic DDD. Do not over-engineer.

Do not:
- Create aggregates for every database table
- Create Value Objects for every primitive automatically
- Create Domain Services when behavior naturally belongs inside an Aggregate or Entity
- Introduce Domain Events unless they clarify a real business process or integration need
- Introduce abstractions without a clear reason

The model must be useful for building a new system, not for patching the legacy one.

## Input Sources

Always read both interpretation sources AND ground truth sources:

**Primary interpretation sources** (legacy analysis already done):
- system-level bounded-context catalog
- system-level context map
- bounded-context discovery reports
- user-provided business explanations

**Always-on ground truth sources** (verify and fill gaps):
- original legacy source code (mandatory co-reference)
- existing tests
- existing API contracts
- existing database schema
- existing documentation

Do not rely only on discovery artifacts. Always cross-check against the original source code. If a discovery report is absent, clearly state that the design is based on incomplete discovery and read the source code directly to fill gaps. When discovery artifacts and source code contradict, the source code takes precedence.

## Clean Architecture Rules

The target architecture must respect these rules:

- Domain must not depend on Application.
- Domain must not depend on Infrastructure.
- Domain must not depend on Presentation/UI.
- Domain must not depend on frameworks, databases, ORMs, web APIs, queues, or file systems.
- Application may depend on Domain.
- Application may define use cases, commands, queries, ports, and orchestration.
- Infrastructure implements technical details and adapters.
- Presentation/UI calls Application use cases.
- Dependency injection belongs to the composition root.
- Business invariants belong in the Domain.
- Use case orchestration belongs in Application.
- Persistence, external APIs, file system, email, queues, PDF generation, and database access belong in Infrastructure.

## Aggregate Design Rules

When proposing an Aggregate, define:
- Aggregate name, aggregate root, responsibility
- Consistency boundary, invariants, state transitions
- Entities inside the aggregate (if any)
- Value Objects used by the aggregate
- Commands/use cases that modify it
- Queries that read it
- Repository need
- Evidence from legacy code
- Risks and uncertainties

An Aggregate should protect business invariants. Avoid large aggregates that simply mirror screens, tables, or modules.

## Recommendations for Build Order

When recommending what to build first, prioritize by:
1. domain centrality
2. conceptual dependency of other contexts or flows
3. architectural learning value
4. risk reduction through earlier clarification

Do not rank by ease of incremental extraction from the legacy code. Do not recommend migration slices.

## Required Inputs

Read these to understand baseline:
- migration/00-system/bounded-context-catalog.md
- migration/00-system/context-map.md
- migration/bounded-contexts/[slug]/01-discovery/discovery.md (if it exists)

**Always also read directly:**
- Original legacy source code (verify and extend discovery findings)
- Legacy tests, if present (validate behavioral assumptions)
- Legacy database schema or migrations, if present (understand data constraints)

**Finding the slug:** Look in `migration/00-system/bounded-context-catalog.md` — each bounded context entry has a slug in the first column.

## Objectives

1. Define bounded contexts and their responsibilities
2. Design aggregates, aggregate roots, entities, and value objects for each BC
3. Define repository interfaces and external gateway (port) contracts
4. Clarify business rule placement (Domain, Application, Infrastructure, Presentation)
5. Identify which design decisions are stable enough for the DEVELOP phase
6. Document design risks and open questions

## Output Format

Produce a structured Markdown report using this format:

### DDD + Clean Architecture Design Proposal

#### Scope
Describe the selected scope and source material used.

#### Assumptions

| Assumption | Reason | Confidence | Needs Human Validation |
|---|---|---|---|

#### Proposed Bounded Contexts

| Bounded Context | Responsibility | Main Concepts | Evidence | Confidence |
|---|---|---|---|---|

#### Selected Bounded Context Design

For each selected bounded context:

##### Bounded Context: [Name]

###### Responsibility
Describe the business responsibility.

###### Ubiquitous Language

| Term | Meaning | Evidence | Notes |
|---|---|---|---|

###### Aggregates

| Aggregate | Aggregate Root | Responsibility | Invariants | Evidence | Confidence |
|---|---|---|---|---|---|

###### Entities

| Entity | Parent Aggregate | Identity | Responsibility | Evidence |
|---|---|---|---|---|

###### Value Objects

| Value Object | Values | Validation Rules | Used By | Evidence |
|---|---|---|---|---|

###### Domain Services

| Domain Service | Responsibility | Rules Encapsulated | Why Not Aggregate Behavior | Evidence |
|---|---|---|---|---|

###### Domain Events

| Domain Event | Raised By | Meaning | Consumers | Reason |
|---|---|---|---|---|

(Only include Domain Events if useful.)

###### Business Rule Placement

| Rule | Legacy Location | Classification | Target Location | Reason | Confidence |
|---|---|---|---|---|---|

###### Application Use Cases

| Use Case | Command/Query | Involved Aggregates | Repositories/Gateways | Notes |
|---|---|---|---|---|

###### Repository Interfaces

| Repository | Aggregate | Required Methods | Reason |
|---|---|---|---|

###### Gateways / Ports

| Gateway/Port | Purpose | Implemented By Infrastructure | Used By |
|---|---|---|---|

###### Anti-Corruption Layers

| External/Legacy Model | Target Domain Model | Translation Needed | Reason |
|---|---|---|---|

###### Suggested Clean Architecture Structure

Use a tree format.

#### Design Risks

| Risk | Impact | Evidence | Mitigation |
|---|---|---|---|

#### Unknowns / Needs Human Validation

| Question | Why It Matters | Suggested Validation |
|---|---|---|

#### Recommended Next Decision

Recommend one of:
- more discovery
- focused deep discovery
- design refinement
- develop-phase start for the selected target scope

## Artifacts

Create or update:
- migration/bounded-contexts/[slug]/02-design/design.md
- migration/bounded-contexts/[slug]/02-design/model.yaml

## Constraints

- Do not implement code.
- Do not modify code.
- Do not produce migration plans.
- Do not produce fake certainty.
- Always include evidence when possible.
- Prefer a smaller useful model over a complete theoretical model.
- When the design depends on incomplete evidence, state the hypothesis explicitly and assign confidence.

## Fallback

If discovery.md for the selected scope does not exist:
- State that explicitly.
- Do not invent design decisions.
- Report what discovery needs to be done first.

If discovery evidence is insufficient for confident design:
- Document what is unclear.
- Recommend additional discovery before moving to DEVELOP.
- Mark uncertain decisions as "Needs human validation".

## What Comes Next

After design is complete, you are ready to move to DEVELOP when:
- At least one bounded context has a complete design document
- Aggregate definitions are explicit (aggregate roots, entities, value objects)
- Business rule placement table is populated (legacy location → target layer)
- Application use cases for the selected build scope are defined
- Repository interfaces and external gateway contracts are clear
- No unresolved "Unknown / Needs human validation" items that block the selected scope

Next skill: `target-implementation` (to build the target system based on design)
