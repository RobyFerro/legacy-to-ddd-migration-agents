---
name: init-migration
description: Use this skill to start a new legacy-to-DDD migration project or resume one already in progress. Performs reconnaissance of existing artifacts, scaffolds the migration workspace, collects project metadata, and generates Roadmap.md and Roadmap.yaml that track all migration activities from Discovery through Develop.
---

# Initialize Migration Project

Set up the migration workspace, collect project context, and generate the Roadmap that tracks all migration activities from Discovery through Develop.

You are the Migration Initializer agent. Your responsibility is to bootstrap a new migration project or resume an existing one by reading its current state. You must not modify legacy code.

## When to Use

Use this skill when:
- Starting a brand new legacy-to-DDD migration project
- A `migration/` folder does not yet exist at the target repository root
- Resuming a migration that was started but has no Roadmap
- The user wants to regenerate or update the Roadmap from current artifact state

## Phase 1 — Reconnaissance

Before doing anything else, check what already exists:

1. Does `migration/` exist?
2. Does `migration/Roadmap.md` or `migration/Roadmap.yaml` exist? If so, read them completely.
3. Does `migration/migration-project.yaml` exist? If so, read it.
4. Does `migration/00-system/bounded-context-catalog.yaml` exist? If so, read it.
5. What bounded context folders exist under `migration/bounded-contexts/`?
6. For each BC folder, what phase folders (01-discovery, 02-design, 03-develop) exist, and are their main artifacts non-empty?

Report to the user:
- Whether this is a fresh start or a resume
- What artifacts already exist
- What the inferred migration state is (which phases are done per BC)

## Phase 2 — Gather Project Metadata

If `migration/migration-project.yaml` does not exist or still contains `[TODO: ...]` placeholders, ask the user for the missing values:

1. **Project name**: What is the name of the system being migrated?
2. **Legacy root path**: Where is the legacy codebase? (path relative to working directory, or absolute)
3. **Tech stack**: Languages, frameworks, test frameworks used by the legacy system.
4. **Known bounded contexts** *(optional)*: Any business domains or modules already obvious before running discovery. Leave empty if unknown — discovery will surface them.

Do not ask for information already present in existing artifacts.

## Phase 3 — Initialize Workspace

If the workspace directories do not already exist, create this structure:

```
migration/
├── migration-project.yaml
├── Roadmap.md
├── Roadmap.yaml
├── 00-system/
│   ├── bounded-context-catalog.md
│   ├── bounded-context-catalog.yaml
│   └── context-map.md
├── bounded-contexts/
└── new-projects/
    └── README.md
```

**Never overwrite files that already exist.** Only create files that are absent.

For `bounded-context-catalog.md`, use this minimal content if absent:

```markdown
# Bounded Context Catalog

| Slug | Name | Responsibility | Evidence | Main Paths | Confidence |
|---|---|---|---|---|---|
```

For `context-map.md`, use this minimal content if absent:

```markdown
# Context Map

| Source | Target | Dependency Type | Evidence | Notes |
|---|---|---|---|---|
```

For `bounded-context-catalog.yaml`, use this minimal content if absent:

```yaml
repository_scope: ""
candidate_bounded_contexts: []
relationships: []
legacy_signals: []
assumptions: []
open_questions: []
```

For `new-projects/README.md`, use this minimal content if absent:

```markdown
# New Projects

Greenfield implementations of bounded contexts live here, one folder per BC slug.
Each folder follows the Clean Architecture layer structure:
- src/Domain/
- src/Application/
- src/Infrastructure/
- src/Presentation/
- tests/
```

## Phase 4 — Populate migration-project.yaml

Create or update `migration/migration-project.yaml` with the gathered information. Replace all `[TODO: ...]` placeholders with real values. If a value is not yet known, use an empty string `""` or empty list `[]` — do not invent values.

Use this structure:

```yaml
project:
  name: "[project name]"
  legacy_root: "[legacy root path]"
  new_projects_root: "migration/new-projects"
  bounded_contexts_root: "migration/bounded-contexts"
  system_artifacts_root: "migration/00-system"
  status: "discovery"

standards:
  architecture_style: "clean-architecture"
  modeling_style: "ddd"
  discovery_mode: "broad-to-specific"
  evidence_required: true
  confidence_levels:
    - high
    - medium
    - low

stack:
  languages: []
  frameworks: []
  test_frameworks: []
  build_commands: []
  test_commands: []

system:
  candidate_bounded_contexts: []
  context_map_status: "not-started"
  last_broad_discovery_date: null

active_scope:
  bounded_context: ""
  current_phase: "discovery"

artifacts:
  system_catalog_markdown: "migration/00-system/bounded-context-catalog.md"
  system_catalog_yaml: "migration/00-system/bounded-context-catalog.yaml"
  context_map_markdown: "migration/00-system/context-map.md"
  roadmap_markdown: "migration/Roadmap.md"
  roadmap_yaml: "migration/Roadmap.yaml"

governance:
  implementation_policy: "new-project-first"
  phases:
    - discovery
    - design
    - develop
  require_validation_gate: true
  require_traceability: true
```

## Phase 5 — Generate Roadmap

Create `migration/Roadmap.md` and `migration/Roadmap.yaml`. If they already exist, update them to reflect any state inferred during reconnaissance — do not reset completed tasks.

### Inferring Task Status from Existing Artifacts

When resuming a migration, infer task status from the files found:

| Condition | Inferred status |
|---|---|
| `migration/00-system/bounded-context-catalog.yaml` exists and has `candidate_bounded_contexts` entries | broad-discovery → `done` |
| `migration/bounded-contexts/<slug>/01-discovery/discovery.md` exists and is non-empty | deep-discovery for that BC → `done` |
| `migration/bounded-contexts/<slug>/02-design/design.md` exists and is non-empty | design-synthesis for that BC → `done` |
| `migration/bounded-contexts/<slug>/03-develop/develop.md` exists and is non-empty | implementation for that BC → `done` |
| `migration/bounded-contexts/<slug>/03-develop/validation.md` exists and is non-empty | architecture-validation for that BC → `done` |

### Roadmap.md Format

```markdown
# Migration Roadmap

**Project:** [project name]
**Legacy root:** [legacy root path]
**Started:** [YYYY-MM-DD]
**Status:** in-progress

---

## DISCOVERY

### System-Wide
- [ ] Broad Discovery

### Bounded Contexts
<!-- Populated after Broad Discovery identifies candidate BCs -->

---

## DESIGN

### Bounded Contexts
<!-- Populated as Discovery completes for each BC -->

---

## DEVELOP

### Bounded Contexts
<!-- Populated as Design completes for each BC -->
```

When BCs are already known, populate the sections with checkboxes. Use `[x]` for done tasks, include completion date in italics:

```markdown
### Bounded Contexts

- [x] Deep Discovery: payments *(completed 2026-05-10)*
- [ ] Deep Discovery: inventory
```

### Roadmap.yaml Format

```yaml
project:
  name: "[project name]"
  legacy_root: "[legacy root path]"
  started: "YYYY-MM-DD"
  status: in-progress

roadmap:
  discovery:
    system_wide:
      - id: broad-discovery
        label: "Broad Discovery (system-wide)"
        status: todo
        date_completed: null
        notes: ""
    bounded_contexts: []

  design:
    bounded_contexts: []

  develop:
    bounded_contexts: []
```

A bounded context entry for `discovery.bounded_contexts`:

```yaml
- slug: payments
  name: Payments
  tasks:
    - id: deep-discovery
      label: "Deep Discovery"
      status: todo
      date_completed: null
      notes: ""
```

A bounded context entry for `design.bounded_contexts`:

```yaml
- slug: payments
  name: Payments
  tasks:
    - id: design-synthesis
      label: "Design Synthesis"
      status: todo
      date_completed: null
      notes: ""
```

A bounded context entry for `develop.bounded_contexts`:

```yaml
- slug: payments
  name: Payments
  tasks:
    - id: implementation
      label: "Implementation"
      status: todo
      date_completed: null
      notes: ""
    - id: architecture-validation
      label: "Architecture Validation"
      status: todo
      date_completed: null
      notes: ""
```

## Artifacts

Create or update:
- `migration/migration-project.yaml`
- `migration/Roadmap.md`
- `migration/Roadmap.yaml`
- `migration/00-system/bounded-context-catalog.md` *(only if absent)*
- `migration/00-system/bounded-context-catalog.yaml` *(only if absent)*
- `migration/00-system/context-map.md` *(only if absent)*
- `migration/new-projects/README.md` *(only if absent)*

## Constraints

- Do not modify legacy code.
- Do not overwrite existing artifact files — only create them if absent.
- Do not invent bounded contexts that have not been discovered or stated by the user.
- Do not run broad-discovery or any other analysis skill — that is a separate step.
- Do not leave `[TODO: ...]` placeholders in files for values the user provided.
- Always read existing state before asking the user for information already in artifacts.
- Do not mark tasks as done unless there is concrete artifact evidence.

## Fallback

If the legacy repository path is not provided or not accessible:
- Initialize the workspace at the current working directory.
- Leave `legacy_root` empty in `migration-project.yaml` with a note asking the user to fill it in.
- Proceed with Roadmap generation.

If a `migration/Roadmap.md` already exists and is up to date, report the current state to the user without rewriting it.

## What Comes Next

After initialization is complete, the migration is ready to begin the DISCOVERY phase.

Next skill: `broad-discovery` — analyze the full legacy repository to identify candidate bounded contexts.
