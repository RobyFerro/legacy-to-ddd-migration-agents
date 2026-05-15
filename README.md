# Codex Legacy-Informed DDD/Clean Design Kit

Reusable Codex plugin for broad-to-specific discovery and target-system design starting from a legacy codebase.

This repository is also a Codex plugin marketplace repository. The distributable plugin lives in `plugins/ddd-clean-migration`, and the marketplace entry lives in `.agents/plugins/marketplace.json`.

## What The Plugin Does

The plugin guides the team through these phases:

1. broad discovery of the legacy system
2. optional deep discovery of selected bounded contexts
3. DDD/Clean design synthesis
4. greenfield develop phase for the selected target scope

The core purpose is advisory.
The agent should help the user make better decisions.
The user decides when a phase starts or ends.

The workflow must always preserve these three phases:

- `DISCOVERY`
- `DESIGN`
- `DEVELOP`

Discovery is evidence gathering.
It is not a request to fix the legacy codebase.

## Quick Start: Choose Your Phase

**New to this plugin?** Start here:

- **[Discovery Playbook](plugins/ddd-clean-migration/.codex/prompts/discovery-playbook.md)** — Extract evidence from the legacy system. Read-only analysis of business logic, bounded contexts, and dependencies.
- **[Design Playbook](plugins/ddd-clean-migration/.codex/prompts/design-playbook.md)** — Transform discovery into a target DDD/Clean Architecture design. Define aggregates, entities, and layer boundaries.
- **[Develop Playbook](plugins/ddd-clean-migration/.codex/prompts/develop-playbook.md)** — Build the new greenfield target system based on design. Clean Architecture implementation only.

Each playbook includes:
- Readiness checklist for that phase
- Copy-paste ready prompt to start immediately
- Links to complete rules and reference material

## Design Stance

- legacy code is a source of truth about business reality
- discovery findings are decision inputs, not remediation tasks
- legacy weaknesses should be described as `legacy signals`, `design pressures`, or `domain ambiguities`
- bounded contexts should be prioritized by domain centrality
- the target is a new system, not an incremental cleanup of the old one

## Main Outputs

The plugin should help produce:

- a system bounded-context catalog
- a context map
- per-bounded-context discovery reports
- per-bounded-context DDD/Clean design reports
- target model definitions
- develop-phase delivery reports
- develop-phase validation reports
- open-question backlogs for human validation

Suggested artifact structure:

- `migration/00-system/`
- `migration/bounded-contexts/<slug>/01-discovery/`
- `migration/bounded-contexts/<slug>/02-design/`
- `migration/bounded-contexts/<slug>/03-develop/`

## Repository Layout

- `.agents/plugins/marketplace.json`: marketplace catalog entry for Codex
- `plugins/ddd-clean-migration/.codex-plugin/plugin.json`: distributable plugin manifest
- `plugins/ddd-clean-migration/.codex/`: bundled agents, prompts, and templates
- `plugins/ddd-clean-migration/skills/`: bundled skills
- `plugins/ddd-clean-migration/scripts/`: bundled helper scripts
- `install-global.ps1`, `install-project.ps1`, `update-global-clean.ps1`: repository-level install helpers

## Bundled Agent Profiles

- `legacy-discovery`
- `ddd-design`
- `target-build-worker`

`target-build-worker` remains available for optional target-project delivery work, but it should not drive discovery or post-discovery recommendations.

## Bundled Skills

- `legacy-business-logic-extraction`
- `ddd-aggregate-design`
- `clean-architecture-boundaries`
- `migration-slice-planning`
- `architecture-validation`
- `migration-code-guardrails`

Some skill names remain legacy for backward compatibility.
The expected behavior is still greenfield target design first, not incremental migration guidance.

## Subagent Runtime Note

As of May 14, 2026, Codex Desktop exposes built-in `spawn_agent` roles such as `explorer` and `worker`.

Recommended delegation mapping:

- `legacy-discovery` -> `explorer` + `legacy-business-logic-extraction`
- `ddd-design` -> `explorer` + `ddd-aggregate-design` + `clean-architecture-boundaries`
- `target-build-worker` -> `worker` only when the user explicitly starts delivery for the new target project

## Make It Available In Codex

Add this marketplace to your `~/.codex/config.toml`:

```toml
[marketplaces.legacy-to-ddd-migration-agents]
source_type = "git"
source = "https://github.com/RobyFerro/legacy-to-ddd-migration-agents.git"
ref = "master"
```

Then restart Codex. The plugin will appear as `ddd-clean-migration`.

## Install Globally

```powershell
.\install-global.ps1
```

## Install Into A Project

```powershell
.\install-project.ps1 -TargetRepo "C:\path\to\target-repo"
```

 This installs:
 
 - `.codex/skills`
 - `.codex/prompts`
 - `.codex/templates`
 - `.codex/scripts`
 - `AGENTS.md`
 - `migration/` bootstrap workspace for phase artifacts

 To overwrite an existing `AGENTS.md`:

```powershell
 .\install-project.ps1 -TargetRepo "C:\path\to\target-repo" -OverwriteAgentsMd
 ```

Important:

- the plugin does not use `docs/` as its default artifact root
- discovery, design, and develop artifacts are expected under `migration/`
- broad discovery should update system-level files under `migration/00-system/`
- per-bounded-context artifacts are created when a bounded context is selected or analyzed deeply enough

## For More Details

- **Phase-specific guidance:** See the playbooks above (discovery, design, develop)
- **Complete rules and reference:** See `AGENTS.md` after installation in your project
  - Agent behavioral rules
  - Artifact ownership matrix
  - Readiness criteria details
  - Clean Architecture and DDD rules
