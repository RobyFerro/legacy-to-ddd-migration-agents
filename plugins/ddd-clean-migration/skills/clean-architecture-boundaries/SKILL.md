---
name: clean-architecture-boundaries
description: Use this skill when assigning responsibilities to Domain, Application, Infrastructure, and Presentation during Clean Architecture migration, or when reviewing whether code is placed in the correct layer.
---

# Clean Architecture Boundaries

Use this skill to classify responsibilities across Clean Architecture layers.

The goal is to prevent business rules, orchestration, technical details, and UI logic from being mixed together.

## When to Use

Use this skill when the task involves:

- Clean Architecture design
- DDD migration
- layer responsibility classification
- migration planning
- implementation review
- checking if code belongs in Domain, Application, Infrastructure, or Presentation
- extracting logic from ViewModels, services, repositories, or adapters

Typical agents:

- `ddd-design`
- `target-build-worker`
- `legacy-discovery`, only when classifying discovered logic

## Core Principle

A layer should contain only the responsibilities that belong to it.

Do not place code based on where it currently exists.
Place code based on what responsibility it has.

## Layer Responsibilities

### Domain

Domain contains business concepts and business rules that are independent of technology.

Domain can contain:

- aggregates
- aggregate roots
- entities
- value objects
- domain services
- domain events, only when useful
- pure business policies
- business invariants
- state transition rules
- validation that protects invariants

Domain must not contain:

- ORMs or database libraries
- SQL or database queries
- file system access
- HTTP calls
- external service SDKs
- queues
- email
- logging implementation
- dependency injection
- UI libraries or dialogs
- request/response DTOs
- infrastructure adapters

### Application

Application contains use cases and orchestration.

Application can contain:

- commands
- queries
- command handlers
- query handlers
- use case services
- application DTOs
- ports/interfaces for infrastructure
- transaction orchestration
- calls to repositories
- calls to gateways
- calls to domain methods
- calls to licensing/capability checks
- application-level validation
- composition of results for UI/API
- workflow coordination

Application must not contain:

- core business invariants
- ORM or database implementation details
- filesystem implementation details
- UI implementation
- direct external service calls (use adapters instead)
- technical adapter implementation

### Infrastructure

Infrastructure contains technical details and adapters.

Infrastructure can contain:

- repository implementations
- ORM/database code and mappings
- filesystem adapters
- external service adapters
- email implementation
- queue implementation
- compatibility migrations
- technical configuration adapters

Infrastructure must not own:

- domain invariants
- business capability rules
- use case orchestration
- UI decisions
- user interaction flow

### Presentation

Presentation contains UI and user interaction.

Presentation can contain:

- UI views or components
- ViewModels or controllers
- UI commands or handlers
- dialogs or modals
- user notifications
- UI state
- UI-only validation
- formatting for display
- selection state
- interaction handlers

Presentation must not own:

- business invariants
- persistence logic
- repository rules
- use case orchestration

## Classification Method

For each responsibility, ask:

1. Is this a business invariant?
   - If yes: Domain.
2. Is this a use case workflow or orchestration?
   - If yes: Application.
3. Is this a technical implementation detail?
   - If yes: Infrastructure.
4. Is this user interaction or display state?
   - If yes: Presentation.
5. Is this only for reading/reporting?
   - It may be a query/read model, usually Application + Infrastructure.
6. Is this unclear?
   - Mark as `Unknown / Needs human validation`.

## Output Format

Use this table:

| Responsibility | Current Location | Target Layer | Reason | Confidence |
|---|---|---|---|---|

When useful, also include:

### Boundary Violations

| Violation | File | Why It Violates Boundaries | Suggested Fix |
|---|---|---|---|

### Ports / Adapters

| Port | Defined In | Implemented In | Purpose |
|---|---|---|---|

### Layer Decision Log

| Decision | Reason | Trade-off |
|---|---|---|

## Common Migration Moves

### From ViewModel/Controller to Application

Move to Application when a ViewModel/Controller:

- coordinates a multi-step use case
- calls repositories directly
- performs resource creation/deletion workflows
- applies policy checks before use case execution
- decides persistence sequence
- handles domain operation results

Keep in ViewModel/Controller:

- dialogs or forms
- progress UI
- selected items
- refresh commands
- notification text
- UI-specific state

### From Infrastructure Service to Domain

Move to Domain when an Infrastructure service:

- enforces pure business limits
- duplicates domain policies
- decides allowed/not allowed based on business state
- performs validation unrelated to technology
- encodes business lifecycle rules

### From Infrastructure Service to Application

Move to Application when an Infrastructure service:

- orchestrates multiple technical adapters
- coordinates repositories, filesystem, and domain
- performs workflow sequencing
- composes operation results
- implements a use case flow

### From Repository to Application/Domain

Move out of repositories when they:

- decide business rules
- perform workflow decisions
- materialize application-specific behavior
- enforce policy
- perform non-persistence orchestration

Repositories should mostly:

- load
- save
- query
- map persistence models
- handle database-specific details

## Safety Rules

Do not move code just because it is currently in the wrong layer.

First identify:

- behavior to preserve
- tests needed
- target owner
- adapter needed
- rollback strategy

Prefer incremental extraction over big rewrites.

## Final Checklist

Before accepting a layer decision, verify:

- Is the responsibility correctly classified?
- Is Domain free from technical dependencies?
- Is Application free from UI and infrastructure implementations?
- Is Infrastructure free from domain policy ownership?
- Is Presentation free from use case orchestration?
- Are ports defined in the right layer?
- Is the migration slice small enough?
- Are unclear decisions marked for validation?
