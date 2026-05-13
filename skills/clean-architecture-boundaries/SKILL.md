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
- `clean-migration-worker`
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

- EF Core
- SQL
- SQLite
- WPF
- file system access
- PDF libraries
- OCR libraries
- Python execution
- HTTP calls
- queues
- email
- logging implementation
- dependency injection
- application configuration
- UI dialogs
- progress windows
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
- EF Core implementation details
- SQL implementation details
- filesystem implementation details
- WPF-specific code
- direct PDF/OCR/Python implementation
- UI dialogs or view state
- technical adapter implementation

### Infrastructure

Infrastructure contains technical details and adapters.

Infrastructure can contain:

- repository implementations
- EF Core DbContext and mappings
- SQL execution
- SQLite-specific code
- filesystem storage
- PDF reading/rendering
- OCR implementation
- Python process execution
- external library adapters
- export implementation
- email implementation
- queue implementation
- license library integration
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

- WPF Views
- ViewModels
- commands bound to UI
- picker dialogs
- progress windows
- confirmation dialogs
- user notifications
- UI state
- UI-only validation
- formatting for display
- selection state
- refresh triggers

Presentation must not own:

- business invariants
- filesystem lifecycle
- persistence logic
- repository rules
- batch processing logic
- licensing policy rules
- document import orchestration beyond UI interaction

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

### From ViewModel to Application

Move to Application when a ViewModel:

- coordinates a multi-step use case
- calls repositories directly
- performs import/delete workflows
- applies licensing before use case execution
- decides persistence sequence
- handles domain operation results

Keep in ViewModel:

- picker dialogs
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

## DocuMiner-Specific Classification

### Domain

Examples likely belonging to Domain:

- template owns documents
- template field validation
- page rule invariants
- graph structural invariants
- license capability policy
- aggregate state transitions

### Application

Examples likely belonging to Application:

- import template documents
- delete template documents
- run extraction workflow
- apply licensing before import/extraction
- execute graph as part of a use case
- compose results for UI
- coordinate repository + filesystem + domain

### Infrastructure

Examples likely belonging to Infrastructure:

- copy PDF to `%AppData%\\payslippy\\files\\{templateId}`
- collision-safe physical filename resolution
- delete physical files
- SQLite queries
- EF Core persistence
- PDF text extraction
- OCR
- ONNX table recognition
- Python process execution
- CSV/Excel export implementation
- Standard.Licensing integration

### Presentation

Examples likely belonging to Presentation:

- file/folder picker
- progress window
- WPF dialogs
- selected document state
- tab opening
- UI refresh
- visual bounding boxes
- warning display

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
