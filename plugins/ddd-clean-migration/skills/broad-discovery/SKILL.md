---
name: broad-discovery
description: Use this skill when starting DISCOVERY of a legacy system to understand repository structure, identify candidate bounded contexts, map relationships, extract business rules, and assess design pressures. Best for first analysis of an entire legacy codebase before deciding on deeper investigation.
---

# Broad Legacy Discovery

Analyze an entire legacy system and extract evidence for bounded context identification, business rule discovery, and target system design.

You are the Legacy Discovery agent. Your responsibility is to extract evidence from the legacy system so the user can make better design decisions. You must work in read-only mode.

## When to Use

Use this skill when:
- Starting DISCOVERY phase on a new legacy system
- You need to understand overall system structure and entry points
- You need to identify candidate bounded contexts across the whole codebase
- You need to extract business rules, legacy signals, and design pressures
- You need to recommend whether to proceed with DESIGN or do deeper per-BC discovery first

## Mission

Analyze the repository and produce a structured discovery of:
1. Candidate Bounded Contexts
2. Relationships between candidate BCs
3. Main application flows
4. Business logic spread across the repository
5. Technical dependencies
6. Integration points
7. Data access patterns
8. Legacy signals that matter for the new design
9. Domain ambiguities requiring human validation
10. Explicit hypotheses when the code is ambiguous

## Discovery Strategy

Start by understanding the repository structure. Look for:
- Projects, modules, packages, namespaces, folders
- Controllers, UI components, pages, view models
- Application services, domain-like services, repositories
- Query handlers, command handlers, DTOs, mappers, helpers
- Static utility classes, SQL queries, stored procedures, database triggers
- Batch jobs, scheduled jobs, import/export routines
- External integrations, configuration files, dependency injection setup
- Database schema or migrations, tests

## Candidate Bounded Context Identification

Identify candidate Bounded Contexts using evidence such as:
- Business terminology, folder/module boundaries, namespace boundaries
- Database table groups, UI feature areas, API endpoint groups
- Workflow boundaries, authorization boundaries, integration boundaries
- Team or ownership hints, different models using the same words differently
- Different lifecycle rules for similar concepts

For each candidate Bounded Context, report:
- Name, responsibility, evidence, main files/folders, main concepts
- Related database tables (when detectable), external dependencies
- Incoming dependencies, outgoing dependencies, confidence level (High/Medium/Low)
- Open questions, hypotheses (when direct evidence is incomplete)

When analyzing, decide whether dedicated deep discovery would improve evidence quality. Recommend delegation only when that helps clarify the design space.

## Business Logic Discovery

Treat all of the following as possible business knowledge:
- Conditional branches that encode business decisions
- Validation rules, state transitions, workflow rules
- Authorization rules, calculations, date/time rules
- Thresholds, limits, pricing/amount calculations
- Document generation rules, import/export transformation rules
- SQL WHERE clauses, CASE expressions, stored procedures, triggers
- Batch logic, UI-only validations, repeated constants
- Status codes, enum-like strings/numbers, cross-field validation
- Fallback logic, hierarchical selection logic
- Rules hidden in mappers or DTO construction

For each discovered rule, capture:
- Short rule description, exact location (file path, function/class/method name)
- Evidence, possible business meaning
- Current technical location, suggested classification, confidence level
- Whether it needs human validation

## Business Rule Classification

Classify every discovered rule as one of:
- Aggregate invariant, entity behavior, value object rule
- Domain service rule, application orchestration
- Infrastructure concern, presentation/UI concern
- Data access concern, integration concern, unknown / needs human validation

Do not force uncertain rules into a DDD category. When uncertain, use `Unknown / Needs human validation`.

## Dependency Mapping

Identify and describe dependencies between candidate contexts or modules.

Classify dependency types as:
- Direct code dependency, database dependency, shared table dependency
- Shared DTO/model dependency, API dependency, event/message dependency
- File dependency, batch dependency, UI navigation dependency
- Configuration dependency, unknown dependency

## Required Inputs

Read these to understand baseline:
- migration/migration-project.yaml (if it exists)
- Original legacy repository structure (complete overview)

## Objectives

1. Understand the legacy repository structure and entry points.
2. Identify candidate bounded contexts with confidence levels (Low, Medium, High).
3. Map relationships, dependencies, and integration points between candidate BCs.
4. Extract business rules, legacy signals, and design pressures.
5. Document domain ambiguities requiring human validation.
6. Recommend whether to move to DESIGN, do deeper per-BC discovery first, or gather more evidence.

## Output Format

Produce a structured Markdown report using this format:

### Legacy System Discovery Report

#### Scope
Describe what was analyzed.

#### Repository Overview
Summarize the repository structure.

#### Candidate Bounded Contexts

| Candidate BC | Responsibility | Evidence | Main Paths | Dependencies | Confidence |
|---|---|---|---|---|---|

#### Context Relationship Map

| Source | Target | Dependency Type | Evidence | Notes |
|---|---|---|---|---|

#### Business Logic Inventory

| Rule | Location | Evidence | Current Layer/Area | Suggested Classification | Confidence | Needs Human Validation |
|---|---|---|---|---|---|---|

#### Main Legacy Flows

| Flow | Entry Point | Main Steps | Business Rules Involved | External Dependencies |
|---|---|---|---|---|

#### Data Access and Persistence

Describe: repositories, queries, tables, stored procedures, transactions, data access patterns, business rules hidden in persistence.

#### Integration Points

Describe: external APIs, file system, queues, email, PDF generation, import/export, scheduled jobs, other systems.

#### Legacy Signals

| Signal | Evidence | Why It Matters For Design |
|---|---|---|

#### Domain Ambiguities / Needs Human Validation

| Question | Why It Matters | Evidence | Suggested Validation |
|---|---|---|---|

#### Recommended Next Decision

Recommend one of:
- more broad discovery
- focused deep discovery
- DDD/Clean design synthesis
- business clarification

#### Deep Discovery Recommendation

| Candidate BC | Why Deep Discovery Helps | Suggested Focus | Preconditions / Open Questions |
|---|---|---|---|

When producing structured side artifacts, also emit a machine-readable YAML version of the bounded-context catalog with: repository_scope, candidate_bounded_contexts, relationships, legacy_signals, assumptions, open_questions.

## Artifacts

Create or update:
- migration/migration-project.yaml
- migration/00-system/bounded-context-catalog.md
- migration/00-system/bounded-context-catalog.yaml
- migration/00-system/context-map.md

## Constraints

- Do not modify code.
- Do not implement code.
- Do not produce a migration plan.
- Do not design aggregates unless explicitly asked.
- Do not overstate confidence.
- Always cite file paths as evidence.
- Prefer concrete evidence over assumptions.
- When assumptions are unavoidable, label them as hypotheses with confidence.

## Fallback

If the legacy repository is not accessible or has no clear structure:
- Report the blockers explicitly.
- Recommend clarifying repository structure before proceeding.
- Do not invent BCs without evidence.

## Sub-Agent Delegation

When broad discovery reveals multiple candidate BCs that need deeper evidence before design, you may delegate deep discovery of individual BCs in parallel to sub-agents using the `deep-discovery` skill. Each sub-agent focuses on one BC slug.

**Delegate when:**
- The system has more than 3-4 candidate BCs at Medium confidence
- Evidence for specific BCs is insufficient for design decisions
- Parallel investigation would meaningfully reduce design uncertainty

**Do not delegate when:**
- The system is small and broad discovery already yields sufficient evidence
- Only one BC needs deeper investigation

## What Comes Next

After broad discovery is complete, you are ready to move forward when:
- System-level bounded-context catalog has been created
- At least 3 candidate bounded contexts are identified with confidence >= Medium
- Main application flows are documented for each candidate BC
- Business logic classification table has at least one entry per BC
- Open questions that block design are explicitly listed

Next skill: `deep-discovery` (if selected BCs need deeper evidence) or `design-synthesis` (if evidence is sufficient for at least 3 BCs at Medium confidence).
