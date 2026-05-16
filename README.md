# Legacy to Enterprise AI Toolkit

Analyze a legacy system and build a new DDD/Clean Architecture system from scratch — guided by what the legacy code reveals about business intent.

## How It Works

The plugin guides you through three phases:

1. **Discovery** — Read legacy code to extract business rules, identify business areas, and map domain boundaries
2. **Design** — Transform findings into a DDD model with aggregates, entities, repositories, and layer boundaries
3. **Develop** — Build the new system as greenfield code, organized into Domain, Application, and Infrastructure layers

Legacy code is read-only evidence. The new system is built independently under `migration/new-projects/`.

## Installation

Install the plugin directly from the git repository via the Codex CLI:

```bash
codex plugin marketplace add RobyFerro/legacy-to-ddd-migration-agents
```

Or browse to the plugin in the Codex marketplace UI and use the Update/Sync option.

## Getting Started

Each migration phase has a dedicated skill. The prompts below are designed to be copy-pasted into Codex: they state your intent, give the skill the context it needs, and define what you expect back. Replace placeholders in `[brackets]` with your values, then adapt the rest as your situation requires.

### Step 0 — Initialize

```text
I'm starting a legacy-to-DDD migration of the system.
Bootstrap the migration workspace, ask me for anything you need to know
(project name, tech stack, modules I'm already aware of), and generate
the Roadmap so we can track every phase from here.
```

If the workspace already exists, the skill will detect it, infer the current state from existing artifacts, and resume without overwriting anything.

### Phase 1 — Discovery

Start with a system-wide pass to map the territory:

```text
Start the discovery phase on this legacy codebase. I need a system-wide
analysis that identifies the candidate bounded contexts, maps their
relationships, and surfaces the main business rules — enough evidence
for me to decide which contexts deserve a deeper look before design.
```

Once the catalog is populated, dig into a specific bounded context:

```text
Go deeper on the [bc-slug] bounded context. I need its business flows,
aggregate candidates, ubiquitous language, and any business rules hidden
in the code. Flag domain ambiguities that need my input before we move
to design.
```

### Phase 2 — Design

```text
Discovery is complete for [bc-slug]. Propose a pragmatic DDD + Clean
Architecture design from the findings: aggregates, entities, value objects,
repositories, ports, and the target layer for each business rule. Keep the
model lean — call out risks where the evidence is thin instead of inventing
certainty.
```

### Phase 3 — Develop

Open an implementation session for the bounded context:

```text
The design for [bc-slug] is approved — let's start building. Read the
design, then propose the first scope to implement (an aggregate, a use
case, or an adapter — whichever unblocks the most). Wait for my
confirmation before writing any code.
```

Each session covers **one scope** — aggregate, use case, or adapter. Repeat until the bounded context is complete.

After each significant scope, validate before moving on:

```text
Audit the latest implementation slice for [bc-slug] against Clean
Architecture and DDD rules. Check layer boundaries, domain purity,
behavior preservation against the legacy reference, and test coverage.
Tell me explicitly if anything is broken or risky before I continue.
```

Each phase produces artifacts under `migration/` that the next phase consumes. The Roadmap is updated automatically at the end of each skill run.

### Anytime — Where Am I?

Whenever you lose context or you're unsure what to do next, ask for a status report:

```text
Give me a status check on this migration. Where am I, what should I do
next, and is anything off-track? Flag any phase-gate violations or
inconsistencies between the Roadmap and the actual artifacts.
```

The `next-step` skill reads the Roadmap and all artifacts, then returns a ranked list of next actions, warnings about phase-gate violations or stale state, and parallelization opportunities. It's read-only — it recommends but never modifies anything.

## Artifacts

```
migration/
├── Roadmap.md                      ← Master TODO list (updated by each skill)
├── Roadmap.yaml                    ← Machine-readable Roadmap
├── migration-project.yaml          ← Project metadata and configuration
├── 00-system/
│   ├── bounded-context-catalog.md
│   ├── bounded-context-catalog.yaml
│   └── context-map.md
├── bounded-contexts/
│   └── [area-slug]/
│       ├── 01-discovery/
│       ├── 02-design/
│       └── 03-develop/
└── new-projects/
    └── [area-slug]/
        └── src/
            ├── Domain/
            ├── Application/
            ├── Infrastructure/
            └── Presentation/
```

## Roadmap

The Roadmap is the central tracking artifact for the entire migration. It is created by `init-migration` and updated automatically by each phase skill.

Example state after broad discovery on a system with two bounded contexts:

```markdown
## DISCOVERY
### System-Wide
- [x] Broad Discovery *(completed 2026-05-16)*
### Bounded Contexts
- [x] Deep Discovery: payments *(completed 2026-05-17)*
- [ ] Deep Discovery: inventory

## DESIGN
### Bounded Contexts
- [ ] Design Synthesis: payments
- [ ] Design Synthesis: inventory

## DEVELOP
### Bounded Contexts
- [ ] Implementation: payments
- [ ] Architecture Validation: payments
- [ ] Implementation: inventory
- [ ] Architecture Validation: inventory
```

## Principles

- **Legacy is evidence, not remediation.** Read the legacy system to understand business intent. Never modify it.
- **Greenfield only.** The new system is independent code. No strangler pattern, no incremental extraction.
- **Design before code.** Discovery and Design are read-only. Code only after design is approved.
- **Source is ground truth.** Discovery artifacts are interpretations. Original source code always takes precedence.
- **Pragmatic DDD.** Prefer a smaller useful model over a complete theoretical one.

## Skills Reference

| Skill | Phase | Purpose |
| --- | --- | --- |
| `init-migration` | Setup | Initialize workspace, create Roadmap, resume existing migration |
| `next-step` | Anytime | Analyze current state and recommend the next best action |
| `broad-discovery` | Discovery | Analyze the full legacy system for business area boundaries |
| `deep-discovery` | Discovery | Analyze one area in depth for aggregate and entity candidates |
| `design-synthesis` | Design | Design the target DDD/Clean model from discovery findings |
| `target-implementation` | Develop | Build the new system based on design specifications |
| `architecture-validation` | Develop | Audit code for layer boundary violations |
| `legacy-business-logic-extraction` | Discovery | Find hidden business logic in code |
| `ddd-aggregate-design` | Design | Define DDD patterns (aggregates, entities, value objects) |
| `clean-architecture-boundaries` | Design | Classify responsibilities into layers |
| `migration-code-guardrails` | Develop | Enforce clean boundaries during implementation |

## License

MIT — See LICENSE file in repository
