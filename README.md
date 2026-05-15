# DDD Clean Design Migration Plugin

Analyze a legacy system and build a new DDD/Clean Architecture system from scratch — guided by what the legacy code reveals about business intent.

## How It Works

The plugin guides you through three phases:

1. **Discovery** — Read legacy code to extract business rules, identify business areas, and map domain boundaries
2. **Design** — Transform findings into a DDD model with aggregates, entities, repositories, and layer boundaries
3. **Develop** — Build the new system as greenfield code, organized into Domain, Application, and Infrastructure layers

Legacy code is read-only evidence. The new system is built independently under `migration/new-projects/`.

## Getting Started

### Phase 1: Analyze the Legacy System

Start with the full codebase:

```
Analyze this legacy repository to identify its main business areas,
business rules, and domain boundaries.
```

After the first pass, go deeper on a specific area:

```
Analyze the [area name] in more detail. I want to understand its
business flows, entities, rules, and dependencies.
```

### Phase 2: Design the New System

Once discovery is complete for an area:

```
Design a DDD/Clean Architecture model for the [area] based on what was found.
```

### Phase 3: Build

Once design is approved, implement one scope at a time:

```
Implement the domain model for [aggregate] — entities, value objects, and invariants.
```

```
Implement the [use case name] use case in the application layer.
```

```
Implement the repository adapter for [aggregate].
```

Each phase produces artifacts under `migration/` that the next phase uses.

## Artifacts

```
migration/
├── 00-system/
│   ├── bounded-context-catalog.md
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

## Principles

- **Legacy is evidence, not remediation.** Read the legacy system to understand business intent. Never modify it.
- **Greenfield only.** The new system is independent code. No strangler pattern, no incremental extraction.
- **Design before code.** Discovery and Design are read-only. Code only after design is approved.
- **Source is ground truth.** Discovery artifacts are interpretations. Original source code always takes precedence.
- **Pragmatic DDD.** Prefer a smaller useful model over a complete theoretical one.

## Skills Reference

| Skill | Purpose |
|---|---|
| `broad-discovery` | Analyze the full legacy system for business area boundaries |
| `deep-discovery` | Analyze one area in depth for aggregate and entity candidates |
| `design-synthesis` | Design the target DDD/Clean model from discovery findings |
| `target-implementation` | Build the new system based on design specifications |
| `legacy-business-logic-extraction` | Find hidden business logic in code |
| `ddd-aggregate-design` | Define DDD patterns (aggregates, entities, value objects) |
| `clean-architecture-boundaries` | Classify responsibilities into layers |
| `architecture-validation` | Audit code for layer boundary violations |
| `migration-code-guardrails` | Enforce clean boundaries during implementation |

## License

MIT — See LICENSE file in repository
