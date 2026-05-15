# DISCOVERY Phase Playbook

## What This Phase Does

Extract evidence from the legacy system to identify candidate bounded contexts, business rules, dependencies, and design pressures. This evidence becomes the foundation for target system design.

Discovery is **read-only analysis**. Do not propose legacy remediation.

## Readiness Checklist

Before starting DISCOVERY, confirm:

- [ ] Legacy repository is accessible and understood structurally
- [ ] Team agrees on scope (whole system or specific modules)
- [ ] Discovery artifacts will be stored under `migration/00-system/` and `migration/bounded-contexts/`

## Quick-Start Prompt

**Agent Profile:** `legacy-discovery` (maps to Codex `explorer` + `legacy-business-logic-extraction`)

Copy-paste this prompt to begin broad discovery:

```text
Use the legacy-discovery agent with legacy-business-logic-extraction skill.

Execute a broad discovery of the entire legacy system.

Objectives:
- Understand the repository structure
- Identify candidate bounded contexts
- Map relationships, dependencies, main flows, and integration points
- Extract business rules, legacy signals, design pressures, and domain ambiguities
- Assess whether deep discovery of selected bounded contexts would improve design decisions

Expected Output:
- Structured Markdown report
- All evidence linked to legacy file paths
- Explicit hypotheses with confidence levels when code is ambiguous
- Clear recommendation on next step (more discovery, deep discovery, or move to DESIGN)

Artifacts to create or update:
- migration/migration-project.yaml
- migration/00-system/bounded-context-catalog.md
- migration/00-system/bounded-context-catalog.yaml
- migration/00-system/context-map.md

Constraints:
- Do not modify code
- Do not propose legacy remediation
- Do not propose migration slices
- Do not recommend strangler or safe-area strategies
```

## After Discovery

You are ready to move to DESIGN when:

- [ ] System-level bounded-context catalog created
- [ ] At least 3 candidate bounded contexts identified with confidence >= Medium
- [ ] Main application flows documented for each candidate BC
- [ ] Business logic classification table populated (rule location and suggested layer)
- [ ] Open questions that block design are explicitly listed

See **AGENTS.md** for:
- Complete behavioral rules and constraints
- Business rule classification taxonomy
- Artifact ownership matrix
- When to delegate deep discovery
