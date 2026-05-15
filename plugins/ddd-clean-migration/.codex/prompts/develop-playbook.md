# DEVELOP Phase Playbook

## What This Phase Does

Build the new target system based on discovery and design artifacts. Implement one scope at a time in isolation. This phase is **greenfield development only** — the legacy system is read-only evidence, not the target of remediation.

## Readiness Checklist

Before starting DEVELOP, confirm:

- [ ] At least one bounded context has a complete design document (`02-design/design.md`)
- [ ] Aggregate and entity definitions are clear
- [ ] Business rule placement table is populated (legacy location → target layer)
- [ ] Application use cases for the selected scope are defined
- [ ] Repository and gateway interfaces are specified
- [ ] Target project structure created under `migration/new-projects/[slug]/`
- [ ] All team members understand the target architecture

## Quick-Start Prompt

**Agent Profile:** `target-build-worker` (maps to Codex `worker` + `clean-architecture-boundaries` + `architecture-validation`)

Copy-paste this prompt to begin implementation:

```text
Use the target-build-worker agent with clean-architecture-boundaries and architecture-validation skills.

Implement the DEVELOP phase for the new target system.

Scope: [bounded-context-name and specific implementation goal]

Objectives:
- Build only the requested scope in the new target system
- Respect Clean Architecture layers (Domain, Application, Infrastructure, Presentation)
- Maintain traceability to design and discovery artifacts
- Add tests where possible
- Validate that the implementation matches the target design

Input Sources (read-only):
- migration/migration-project.yaml
- migration/bounded-contexts/[slug]/01-discovery/discovery.md
- migration/bounded-contexts/[slug]/02-design/design.md
- migration/bounded-contexts/[slug]/02-design/model.yaml
- Target project structure under migration/new-projects/[slug]/

Artifacts to create or update:
- migration/bounded-contexts/[slug]/03-develop/develop.md (what was built)
- migration/bounded-contexts/[slug]/03-develop/validation.md (build results and risks)
- New implementation files under migration/new-projects/[slug]/

Expected Output:
- Implementation of the selected scope only
- Tests added or updated when possible
- Build and test results
- Architecture validation summary
- Remaining risks and open questions

Constraints:
- Do not clean up the legacy system
- Do not expand scope beyond what was approved
- Do not perform unrelated refactoring
- Do not violate the target architecture boundaries
- Respect Clean Architecture: Domain pure, Application orchestrates, Infrastructure adapts
```

## After Implementation

Validate before closing DEVELOP:

- [ ] Build succeeds (run `dotnet build` or equivalent)
- [ ] Tests pass (run `dotnet test` or equivalent)
- [ ] Domain layer is free from infrastructure/UI dependencies
- [ ] Application layer does not contain core business invariants
- [ ] All changes documented in `03-develop/develop.md`
- [ ] Risks documented in `03-develop/validation.md`

See **AGENTS.md** for:
- Complete Clean Architecture validation rules
- Architecture-specific guardrails
- Migration code guardrails
- Artifact ownership matrix
- Phase readiness criteria
