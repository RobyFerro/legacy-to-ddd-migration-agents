---
name: ddd-aggregate-design
description: Use this skill when designing or validating DDD aggregates, aggregate roots, entities, value objects, invariants, and consistency boundaries during legacy-to-DDD/Clean Architecture migration.
---

# DDD Aggregate Design

Use this skill to design or validate aggregates during a DDD migration.

The goal is to avoid confusing database tables, UI screens, DTOs, or repositories with aggregates.

An aggregate is a consistency boundary that protects business invariants.

## When to Use

Use this skill when the task involves:

- DDD design
- aggregate discovery
- aggregate validation
- entity/value object modeling
- deciding ownership of business rules
- evaluating whether a concept should be an aggregate, entity, value object, domain service, or application use case
- reviewing proposed aggregate designs

Typical agents:

- `ddd-design`
- `clean-migration-worker`, only when implementing or reviewing a migration slice involving Domain model changes

## Core Principle

Do not model the legacy database 1:1.

Do not assume:

- one table = one aggregate
- one screen = one aggregate
- one repository = one aggregate
- one DTO = one entity
- one folder = one bounded context

Model around business consistency, invariants, lifecycle, and behavior.

## Aggregate Identification

A concept is a strong aggregate candidate when it:

- owns a lifecycle
- protects invariants
- coordinates related entities
- has identity
- controls valid state transitions
- is modified through business operations
- defines a transaction boundary
- prevents invalid combinations of state
- is referenced by other parts of the system by identity

A concept is a weak aggregate candidate when it:

- is only a read model
- is only a database table
- is only a UI grouping
- is only a DTO
- has no behavior
- has no invariants
- is modified freely by many unrelated flows
- exists only for persistence convenience

## Aggregate Root Rules

The aggregate root:

- is the only object external code should modify directly
- enforces aggregate invariants
- coordinates child entities
- exposes intention-revealing methods
- prevents invalid internal state
- raises domain events only when useful

External code should not freely mutate child entities.

## Entity Rules

Use an Entity when the concept:

- has identity
- has lifecycle
- changes over time
- belongs inside an aggregate consistency boundary
- has behavior or state transitions
- is not fully defined by its values

Do not create an Entity only because there is a database table.

## Value Object Rules

Use a Value Object when the concept:

- is defined by its values
- has no identity
- has validation rules
- represents a meaningful domain concept
- reduces primitive obsession
- can be compared by value
- is immutable or treated as immutable

Good candidates:

- codes
- names
- descriptions
- amounts
- quantities
- date ranges
- bounding boxes
- file names
- file paths when domain-relevant
- page indexes
- extraction methods
- statuses

Do not create a Value Object if it only wraps a primitive without behavior, validation, or meaning.

## Domain Service Rules

Use a Domain Service only when:

- the rule is pure domain logic
- the rule does not naturally belong to one aggregate
- the rule coordinates multiple domain objects
- putting the rule on one entity would be misleading
- it has no infrastructure dependencies

Do not use Domain Services as a dumping ground for procedural logic.

## Invariant Discovery

Look for invariants in:

- validations
- exceptions
- guard clauses
- UI enable/disable rules
- repository constraints
- SQL filters
- duplicated checks
- naming rules
- delete rules
- import rules
- lifecycle transitions
- state/status changes
- tests
- documentation
- error messages

Classify invariants as:

- aggregate invariant
- entity invariant
- value object invariant
- application precondition
- infrastructure constraint
- UI-only validation
- unknown / needs human validation

## Design Output Format

When proposing an aggregate, use this format:

## Aggregate Candidate: [Name]

### Verdict

Choose one:

- Strong aggregate
- Weak aggregate
- Entity inside another aggregate
- Value Object
- Domain Service
- Application use case
- Read model
- Infrastructure concern
- Unknown / Needs human validation

### Reason

Explain why.

### Evidence

| Evidence | File/Location | Meaning |
|---|---|---|

### Responsibility

Describe what the aggregate owns.

### Aggregate Root

Name the aggregate root.

### Consistency Boundary

Describe what must be consistent immediately.

### Invariants

| Invariant | Source Evidence | Target Owner | Confidence |
|---|---|---|---|

### Entities

| Entity | Identity | Lifecycle | Why inside aggregate |
|---|---|---|---|

### Value Objects

| Value Object | Values | Validation | Why useful |
|---|---|---|---|

### Behaviors

| Behavior | Description | Owner |
|---|---|---|

### External References

Describe how other contexts/modules should refer to this aggregate.

### Repository Need

Explain whether a repository is needed and why.

### Risks / Open Questions

| Question | Why It Matters | Suggested Validation |
|---|---|---|

## Anti-Patterns to Avoid

Avoid:

- aggregate per table
- aggregate per screen
- aggregate per repository
- aggregate with only getters/setters
- aggregate that knows about EF, SQL, files, WPF, HTTP, Python, PDF libraries, or external tools
- huge aggregate that coordinates unrelated workflows
- child entities mutated directly by application code
- domain service containing all business logic
- value objects with no validation or meaning
- domain events used only because they seem architectural

## DocuMiner-Specific Guidance

For DocuMiner:

- `ExtractionTemplate` is a strong aggregate candidate when dealing with template identity, fields, documents, rules, and lifecycle.
- `TemplateDocument` is likely an entity inside `ExtractionTemplate` if its lifecycle is owned by the template.
- File copying/deleting is not Domain; it belongs to Infrastructure.
- Deciding that a template owns a document is Domain/Application depending on invariant.
- Collision-safe filename generation is probably Infrastructure behavior preserving legacy storage semantics, unless the product treats the name as a business concept.
- Licensing checks are Application orchestration using the Licensing BC.
- WPF picker/progress/dialog behavior stays Presentation.
- PDF/OCR/table extraction execution is not part of the aggregate itself.
- Browser/read models should not automatically become aggregates.

## Final Checklist

Before accepting an aggregate design, verify:

- Does it protect real invariants?
- Is it more than a database table?
- Is the aggregate root clear?
- Are child entities modified only through the root?
- Are Value Objects meaningful?
- Are infrastructure concerns excluded?
- Are UI concerns excluded?
- Is the repository boundary reasonable?
- Is the model small enough for incremental migration?
- Are uncertainties marked clearly?
