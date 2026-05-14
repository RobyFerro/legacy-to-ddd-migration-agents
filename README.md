# Codex DDD/Clean Migration Kit

Reusable Codex plugin for broad-to-specific migration from legacy architecture to Domain-Driven Design and Clean Architecture.

This repository is also a Codex plugin marketplace repository. The distributable plugin lives in `plugins/ddd-clean-migration`, and the marketplace entry lives in `.agents/plugins/marketplace.json`.

## What The Plugin Does

The plugin guides the team through these phases:

1. workspace bootstrap for migration artifacts and target implementation area
2. broad discovery of the legacy system to identify candidate bounded contexts and a simple context map
3. optional per-bounded-context deep discovery delegation when boundaries are stable enough
4. DDD/Clean design for one bounded context at a time
5. migration-slice planning
6. implementation of one approved slice at a time
7. architectural and traceability validation

The process is evidence-based and traceable. Discovery and design artifacts must cite concrete legacy paths, methods, queries, and modules.

## Main Outputs

The plugin scaffolds and maintains:

- a central `migration-project.yaml` manifest
- system-level discovery artifacts for candidate bounded contexts and relationships
- per-bounded-context artifacts organized by phase and, for implementation, by slice
- a standalone new-project structure for bounded-context migration targets
- an optional safe-area folder structure for incremental clean-architecture code
- agent prompts and skills aligned with the migration workflow

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
- `clean-migration-worker`

## Bundled Skills

- `legacy-business-logic-extraction`
- `ddd-aggregate-design`
- `clean-architecture-boundaries`
- `migration-slice-planning`
- `architecture-validation`
- `migration-code-guardrails`

## Subagent Runtime Note

As of May 14, 2026, Codex Desktop exposes built-in `spawn_agent` roles such as `explorer` and `worker`.

In this kit, `legacy-discovery`, `ddd-design`, and `clean-migration-worker` should therefore be treated as project agent profiles, not as guaranteed `agent_type` values.

Recommended delegation mapping:

- `legacy-discovery` -> `explorer` + `legacy-business-logic-extraction`
- `ddd-design` -> `explorer` + `ddd-aggregate-design` + `clean-architecture-boundaries`
- `clean-migration-worker` -> `worker` + the phase-appropriate migration skill

## Selected Coding Guardrails

The plugin includes a selective set of coding guardrails for the implementation phase. These are adapted from the NeoLabHQ DDD ruleset and applied only where they materially support migration work:

- keep Domain and Infrastructure separate
- enforce separation of concerns across layers
- prefer domain-specific names over generic buckets
- respect command-query separation
- keep important side effects visible in orchestration

These guardrails are intentionally scoped to migration slices and to the new-project or safe-area target code. They are not meant to trigger style-only refactoring.

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

Standard global install or update:

```powershell
.\install-global.ps1
```

Clean global update that removes plugin-managed directories first and then reinstalls:

```powershell
.\update-global-clean.ps1
```

Use the clean update when you want to avoid stale files from previous versions under `~/.codex/`.

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

The repository does not rely on project-local `.codex/agents` for delegation because current Codex Desktop runtimes use built-in subagent roles instead.

To overwrite an existing `AGENTS.md`:

```powershell
.\install-project.ps1 -TargetRepo "C:\path\to\target-repo" -OverwriteAgentsMd
```

## Workspace Bootstrap

If the migration workspace does not exist yet, create the standard structure under `migration/` with a standalone new project inside the same repository as the default target:

```powershell
.\.codex\scripts\initialize-migration-workspace.ps1 -TargetRepo "<repo-path>"
```

Optional strangler-style alternative:

```powershell
.\.codex\scripts\initialize-migration-workspace.ps1 -TargetRepo "<repo-path>" -ImplementationMode SafeArea
```

Optional bounded-context bootstrap:

```powershell
.\.codex\scripts\initialize-migration-workspace.ps1 `
  -TargetRepo "<repo-path>" `
  -BoundedContextName "<BC Name>"
```

Create the next slice artifact folder:

```powershell
.\.codex\scripts\new-slice-artifacts.ps1 `
  -TargetRepo "<repo-path>" `
  -BoundedContextName "<BC Name>"
```

## Workflow Prompts

### Broad Discovery

```text
Usa il profilo `legacy-discovery` tramite un subagent `explorer` con `legacy-business-logic-extraction`.
Esegui una broad discovery dell'intero sistema legacy.
Identifica candidate bounded context, relazioni, dipendenze e hotspot.
Mostra sempre la possibilita' di avviare deep discovery dedicate per BC.
Decidi tu se delegare subito o rinviare la delega in base alla stabilita' dei confini.
Aggiorna:
- migration/migration-project.yaml
- migration/00-system/bounded-context-catalog.md
- migration/00-system/bounded-context-catalog.yaml
- migration/00-system/context-map.md
```

### Deep Discovery

```text
Usa il profilo `legacy-discovery` tramite un subagent `explorer` con `legacy-business-logic-extraction`.
Analizza il bounded context [SCOPE] in profondita' in modalita' read-only.
Aggiorna:
- migration/bounded-contexts/[slug]/01-discovery/discovery.md
- migration/bounded-contexts/[slug]/01-discovery/discovery.yaml
Riporta ipotesi esplicite con confidence quando il codice non e' chiaro.
```

### Parallel BC Deep Discovery

```text
Dopo la broad discovery, valuta ogni bounded context candidato.
Mostra sempre l'opzione di lanciare subagent `explorer` dedicati che operano con il profilo `legacy-discovery`.
Delega solo i BC con confini abbastanza stabili.
Se la partizione e' ancora instabile, spiega perche' continui la discovery in modo centralizzato.
Per ogni BC candidato riporta:
- responsabilita'
- segnali/evidenze
- focus suggerito per la deep discovery
- precondizioni o dubbi aperti
```

### Design

```text
Usa il profilo `ddd-design` tramite un subagent `explorer` con `ddd-aggregate-design` e `clean-architecture-boundaries`.
Progetta DDD/Clean per [SCOPE].
Non modificare codice.
Aggiorna:
- migration/bounded-contexts/[slug]/02-design/design.md
- migration/bounded-contexts/[slug]/02-design/model.yaml
- migration/migration-project.yaml
```

### Migration Plan

```text
Usa il profilo `clean-migration-worker` tramite un subagent `worker` con `migration-slice-planning`.
Crea solo il migration plan per [SCOPE].
Non modificare codice.
Dividi il lavoro in slice piccoli e consigliami il primo.
Aggiorna migration/bounded-contexts/[slug]/03-planning/migration-plan.md.
```

### Implementation

```text
APPROVED: implement this migration slice

Usa il profilo `clean-migration-worker` tramite un subagent `worker` con `clean-architecture-boundaries`.
Implementa solo lo slice approvato.
Non ampliare scope.
Preserva comportamento legacy.
Lavora principalmente dentro migration/new-projects/.
Usa migration/safe-area/ solo se la strategia scelta lo richiede esplicitamente.
Determina il prossimo slice-id e crea la relativa cartella artefatti se manca.
Puoi usare .\.codex\scripts\new-slice-artifacts.ps1 per automatizzare questo step.
Aggiorna:
- migration/bounded-contexts/[slug]/04-implementation/slices/[slice-id]/slice.md
- migration/bounded-contexts/[slug]/04-implementation/slices/[slice-id]/traceability.md
- migration/bounded-contexts/[slug]/04-implementation/slices/[slice-id]/validation.md
- opzionalmente migration/bounded-contexts/[slug]/04-implementation/slices/[slice-id]/handoff.md
```

### Validation

```text
Usa il profilo `clean-migration-worker` tramite un subagent `worker` con `architecture-validation`.
Valida lo slice appena implementato.
Non modificare codice.
Aggiorna migration/bounded-contexts/[slug]/04-implementation/slices/[slice-id]/validation.md.
```

### Bounded Context Planning

```text
Pianifica la migrazione broad-to-specific del bounded context [Name].
Se manca, esegui prima la broad discovery del sistema.
Se emergono piu' BC candidati, valuta se avviare deep discovery parallela solo per quelli abbastanza stabili.
```

## Expected Workflow

```text
legacy-discovery + legacy-business-logic-extraction
↓
legacy-discovery + legacy-business-logic-extraction
↓
ddd-design + ddd-aggregate-design + clean-architecture-boundaries
↓
clean-migration-worker + migration-slice-planning
↓
STOP before implementation
```

## Recommended Usage

Plan the whole bounded context, but implement only one migration slice at a time. Keep the system-level context map current while the per-bounded-context artifacts evolve. During discovery, the main agent should always expose the optional per-BC deep-discovery step, but it must defer delegation when the candidate boundaries are still unstable.
