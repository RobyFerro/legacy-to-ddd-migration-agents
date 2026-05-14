# Codex DDD/Clean Migration Kit

Reusable Codex plugin for broad-to-specific migration from legacy architecture to Domain-Driven Design and Clean Architecture.

This repository is also a Codex plugin marketplace repository. The distributable plugin lives in `plugins/ddd-clean-migration`, and the marketplace entry lives in `.agents/plugins/marketplace.json`.

## What The Plugin Does

The plugin guides the team through three phases:

1. broad discovery of the legacy system to identify candidate bounded contexts and a simple context map
2. deep discovery, DDD design, and migration planning for one bounded context at a time
3. implementation of approved migration slices inside a safe area created in the same repository

The process is evidence-based and traceable. Discovery and design artifacts must cite concrete legacy paths, methods, queries, and modules.

## Main Outputs

The plugin scaffolds and maintains:

- a central `migration-project.yaml` manifest
- system-level discovery artifacts for candidate bounded contexts and relationships
- per-bounded-context artifacts for discovery, model, design, migration planning, implementation notes, and validation
- a safe-area folder structure for incremental clean-architecture code
- agent prompts and skills aligned with the migration workflow

## Repository Layout

- `plugins/ddd-clean-migration/.codex-plugin/plugin.json`: distributable plugin manifest
- `.agents/plugins/marketplace.json`: marketplace catalog entry for Codex
- `.codex/`: local-development copy of agents, prompts, templates, and scripts
- `skills/`: local-development copy of the bundled skills
- `plugins/ddd-clean-migration/`: packaged plugin content

## Bundled Agents

- `legacy-discovery`
- `ddd-design`
- `clean-migration-worker`

## Bundled Skills

- `legacy-business-logic-extraction`
- `ddd-aggregate-design`
- `clean-architecture-boundaries`
- `migration-slice-planning`
- `architecture-validation`

## Make It Available In Codex

Add this marketplace to your `~/.codex/config.toml`:

```toml
[marketplaces.legacy-to-ddd-migration-agents]
source_type = "git"
source = "https://github.com/RobyFerro/legacy-to-ddd-migration-agents.git"
ref = "master"
```

Then restart Codex. The plugin will appear as `ddd-clean-migration`.

## Install Into A Project

```powershell
.\install-project.ps1 -TargetRepo "C:\path\to\target-repo"
```

This installs:

- `.codex/agents`
- `.codex/skills`
- `.codex/prompts`
- `.codex/templates`
- `.codex/scripts`
- `AGENTS.md`

To overwrite an existing `AGENTS.md`:

```powershell
.\install-project.ps1 -TargetRepo "C:\path\to\target-repo" -OverwriteAgentsMd
```

## Bootstrap The Migration Workspace

After installation, initialize the migration workspace in the target repository:

```powershell
.\.codex\scripts\initialize-migration-workspace.ps1 -TargetRepo "C:\path\to\target-repo"
```

Optional: scaffold the artifact folder for a first bounded context.

```powershell
.\.codex\scripts\initialize-migration-workspace.ps1 `
  -TargetRepo "C:\path\to\target-repo" `
  -BoundedContextName "Billing"
```

## Broad-To-Specific Workflow

1. Run a broad system discovery to identify candidate bounded contexts and a simple context map.
2. Select one bounded context.
3. Run deep discovery for that bounded context.
4. Produce DDD/Clean design and migration slices.
5. Implement only the approved slice in the safe area.
6. Validate architectural boundaries, preserved behavior, and traceability.

## First Planning Prompt

```text
Inizializza il workspace di migrazione se manca.
Esegui una broad discovery del sistema legacy per identificare bounded context candidati e relazioni.
Poi prepara la deep discovery del bounded context [Name].
```

## Implementation Approval Prompt

```text
APPROVED: implement this migration slice
```

## Recommended Usage

Plan the whole bounded context, but implement only one migration slice at a time. Keep the system-level context map current while the per-bounded-context artifacts evolve.
