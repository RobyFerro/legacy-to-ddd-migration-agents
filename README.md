# Codex DDD/Clean Migration Kit

Reusable Codex setup for incremental migration from legacy architecture to Domain-Driven Design and Clean Architecture.

This repository is also structured as a Codex plugin marketplace repository. The distributable plugin lives at `plugins/ddd-clean-migration`, and the marketplace entry lives at `/.agents/plugins/marketplace.json`.

## Make It Available In Codex

Add this marketplace to your `~/.codex/config.toml`:

```toml
[marketplaces.legacy-to-ddd-migration-agents]
source_type = "git"
source = "https://github.com/RobyFerro/legacy-to-ddd-migration-agents.git"
ref = "master"
```

Then restart Codex. The plugin will appear as `ddd-clean-migration`.

## Repository Layout

- `plugins/ddd-clean-migration/.codex-plugin/plugin.json`: distributable plugin manifest
- `.agents/plugins/marketplace.json`: marketplace catalog entry for Codex
- `.codex/` and `skills/`: source content kept at repo root for local development compatibility

## Includes

- 3 custom Codex agents
- 5 Codex skills
- AGENTS.md template
- migration playbooks
- report templates

## Agents

- `legacy-discovery`
- `ddd-design`
- `clean-migration-worker`

## Skills

- `legacy-business-logic-extraction`
- `ddd-aggregate-design`
- `clean-architecture-boundaries`
- `migration-slice-planning`
- `architecture-validation`

## Install into a project

```powershell
.\install-project.ps1 -TargetRepo "C:\path\to\target-repo"
```

To overwrite an existing `AGENTS.md`:

```powershell
.\install-project.ps1 -TargetRepo "C:\path\to\target-repo" -OverwriteAgentsMd
```

## Install globally

```powershell
.\install-global.ps1
```

Both install scripts package content from `plugins/ddd-clean-migration`.

## First planning prompt

```text
Pianifica la migrazione da legacy a DDD del bounded context [Name].
```

Expected flow:

```text
legacy-discovery + legacy-business-logic-extraction
↓
ddd-design + ddd-aggregate-design + clean-architecture-boundaries
↓
clean-migration-worker + migration-slice-planning
↓
STOP before implementation
```

## Implementation approval prompt

```text
APPROVED: implement this migration slice
```

## Recommended usage

Plan the whole bounded context, but implement only one migration slice at a time.
