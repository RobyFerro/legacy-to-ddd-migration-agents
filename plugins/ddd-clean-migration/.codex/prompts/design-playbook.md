# DESIGN Phase Playbook

## What This Phase Does

Transform discovery findings into a target DDD/Clean Architecture design. Define bounded contexts, aggregates, entities, value objects, repositories, ports, and clean architecture layers for the new system.

Design focuses on **modeling, not implementation**. Do not write code yet.

## Readiness Checklist

Before starting DESIGN, confirm:

- [ ] Discovery artifacts exist in `migration/00-system/` (bounded-context-catalog, context-map)
- [ ] At least 3 candidate bounded contexts are documented with confidence >= Medium
- [ ] Main flows and business rules have been extracted
- [ ] Open ambiguities from discovery are listed

## Quick-Start Prompt

**Agent Profile:** `ddd-design` (maps to Codex `explorer` + `ddd-aggregate-design` + `clean-architecture-boundaries`)

Copy-paste this prompt to begin design synthesis:

```text
Use the ddd-design agent with ddd-aggregate-design and clean-architecture-boundaries skills.

Transform legacy discovery findings into a DDD/Clean Architecture design proposal.

Scope: [bounded-context-name or "whole system"]

Objectives:
- Define bounded contexts and their responsibilities
- Design aggregates, aggregate roots, entities, and value objects for each BC
- Define repositories and external gateways (ports)
- Clarify business rule placement (Domain, Application, Infrastructure, Presentation)
- Identify which design decisions are stable enough for the DEVELOP phase

Expected Output:
- Structured Markdown design report
- Model definitions with evidence from discovery
- Business rule placement table (legacy location → target layer)
- Design risks and open questions

Artifacts to create or update:
- migration/bounded-contexts/[slug]/02-design/design.md
- migration/bounded-contexts/[slug]/02-design/model.yaml

Input Sources:
- migration/00-system/bounded-context-catalog.md
- migration/00-system/context-map.md
- migration/bounded-contexts/[slug]/01-discovery/discovery.md (if deep discovery was done)

Constraints:
- Do not implement code
- Do not modify legacy code
- Do not propose incremental migration plans
- Use discovery evidence as the primary source; if insufficient, state hypotheses explicitly with confidence
```

## After Design

You are ready to move to DEVELOP when:

- [ ] At least one bounded context has a complete design document
- [ ] Aggregate definitions are explicit (aggregate roots, entities, value objects identified)
- [ ] Business rule placement table is populated (legacy location → target layer mapping)
- [ ] Application use cases defined for the selected build scope
- [ ] Repository interfaces and external gateway contracts are clear
- [ ] No unresolved "Unknown / Needs human validation" items that block the selected scope

See **AGENTS.md** for:
- Complete DDD and Clean Architecture rules
- Aggregate design patterns
- Artifact ownership matrix
- Phase readiness criteria details
