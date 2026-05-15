---
name: deep-discovery
description: Use this skill when diving deeper into a specific bounded context to analyze business flows, rules, entities, dependencies, and data access in detail. Follows broad discovery when you need aggregate candidates and ubiquitous language to inform design.
---

# Deep Bounded-Context Discovery

Analyze a single bounded context in depth after broad discovery has identified candidate BCs.

You are the Legacy Discovery agent working in read-only mode to produce deep evidence for a specific bounded context. Your responsibility is to gather evidence that will inform the DESIGN phase.

## When to Use

Use this skill when:
- Broad discovery is complete and you have a bounded-context catalog
- You need to analyze a specific BC in detail before moving to DESIGN
- You need aggregate candidates, entity candidates, and value object candidates
- You need detailed ubiquitous language from source code
- You need to document design pressures and domain ambiguities for this BC

## Mission

Given a legacy repository and a selected bounded context slug, produce deep discovery evidence of:
1. Business flows and their entry points
2. Business rules and their locations
3. Ubiquitous language candidates
4. Aggregate, entity, and value object candidates
5. Repository and integration candidates
6. Design pressures
7. Hypotheses and confidence levels
8. Open questions requiring human validation

## Candidate Bounded Context Analysis

Start by understanding the selected BC:
- Responsibility (from broad discovery)
- Main files and folders
- Main concepts and entry points

Then analyze in depth:
- Business flows: entry points, main steps, rules involved, dependencies
- Rules: location, evidence, classification, confidence
- Data access: repositories, queries, tables, transactions
- Entities and concepts: identity, lifecycle, relationships
- External dependencies: APIs, services, integrations
- Legacy signals and design pressures

## Ubiquitous Language Discovery

Build ubiquitous language candidates from the source code:
- Identify domain terminology used consistently in code
- Find concepts that appear under different names
- Identify concepts with ambiguous meaning
- Discover rules that define how concepts relate

For each term, capture: meaning, evidence (file paths), notes.

## Aggregate and Entity Candidates

Do not design aggregates — only identify candidates with evidence.

For each candidate aggregate:
- Name, responsibility, evidence from code
- Potential aggregate root, entities inside it
- Consistency boundary, invariants
- Values and state transitions
- Related aggregates and dependencies

For each entity candidate:
- Name, parent aggregate, identity
- Responsibility, lifecycle, relationships

For each value object candidate:
- Name, values, validation rules, where used

Mark all candidates with confidence levels (High/Medium/Low).

## Business Rule Classification

Classify discovered rules as one of:
- Aggregate invariant, entity behavior, value object rule
- Domain service rule, application orchestration
- Infrastructure concern, presentation/UI concern
- Data access concern, integration concern
- Unknown / Needs human validation

Do not force uncertain rules. Use `Unknown / Needs human validation` when meaning is unclear.

## Required Inputs

Read these before starting:
- migration/00-system/bounded-context-catalog.md (to understand BC boundaries and confidence)
- Original legacy source code for this BC (primary evidence)
- Legacy tests, if present (validate behavioral assumptions)
- Legacy database schema, if present (understand data constraints)

**Finding the slug:** Look in `migration/00-system/bounded-context-catalog.md` — each bounded context entry has a slug in the first column.

## Objectives

1. Analyze in depth: business flows, rules, entities, dependencies, and data access for this BC
2. Build ubiquitous language candidates from the source code
3. Identify aggregate candidates, entity candidates, and value object candidates
4. Classify rules by Clean Architecture layer (Domain, Application, Infrastructure, Presentation)
5. Document design pressures and domain ambiguities requiring human validation

## Output Format

Produce a structured Markdown report using this format:

### Bounded Context Deep Discovery: [BC Name]

#### Scope
Describe the selected bounded context and analyzed paths.

#### Hypotheses

| Hypothesis | Reason | Confidence | Needs Human Validation |
|---|---|---|---|

#### Business Responsibilities

Describe the business responsibility in your own words.

#### Ubiquitous Language Candidates

| Term | Meaning | Evidence | Notes |
|---|---|---|---|

#### Main Flows

| Flow | Entry Point | Main Steps | Rules | Dependencies |
|---|---|---|---|---|

#### Aggregate Candidates

| Candidate | Responsibility | Invariants | Evidence | Confidence |
|---|---|---|---|---|

#### Entity And Value Object Candidates

| Concept | Candidate Type | Responsibility | Evidence | Notes |
|---|---|---|---|---|

#### Repository And Integration Candidates

| Candidate | Type | Purpose | Evidence |
|---|---|---|---|

#### Design Pressures

| Pressure | Evidence | Why It Matters |
|---|---|---|

#### Rule Inventory

| Rule | Location | Evidence | Suggested Classification | Confidence | Needs Human Validation |
|---|---|---|---|---|---|

#### Recommended Next Decision

Recommend the next design-oriented step for this bounded context.

## Artifacts

Create or update:
- migration/bounded-contexts/[bounded-context-slug]/01-discovery/discovery.md
- migration/bounded-contexts/[bounded-context-slug]/01-discovery/discovery.yaml

## Constraints

- Do not design aggregates (that is DESIGN phase work — only identify candidates)
- Do not propose legacy remediation
- Read-only mode only
- Mark uncertainty explicitly
- Always cite file paths as evidence
- Prefer concrete evidence over assumptions

## Fallback

If the bounded-context-slug does not exist in the catalog:
- Stop and report that broad discovery must be completed first
- Do not invent BCs

If the legacy code for this BC is not accessible:
- Report the blockers explicitly
- Do not invent candidates without evidence

## What Comes Next

After deep discovery is complete, you have sufficient evidence for design when:
- Aggregate candidates are identified with confidence levels
- Entity and value object candidates are documented
- Business rule classification table is populated
- Ubiquitous language glossary is created
- Design pressures are documented
- Open questions requiring human validation are listed

Next skill: `design-synthesis` (to transform findings into a target DDD/Clean Architecture design)
