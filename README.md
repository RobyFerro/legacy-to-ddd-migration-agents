# Codex Legacy-Informed DDD/Clean Design Kit

Reusable Codex plugin for broad-to-specific discovery and target-system design starting from a legacy codebase.

This repository is also a Codex plugin marketplace repository. The distributable plugin lives in `plugins/ddd-clean-migration`, and the marketplace entry lives in `.agents/plugins/marketplace.json`.

## What The Plugin Does

The plugin guides the team through these phases:

1. broad discovery of the legacy system
2. optional deep discovery of selected bounded contexts
3. DDD/Clean design synthesis
4. build-order recommendation for the new target system
5. optional greenfield delivery of the selected target scope

The core purpose is advisory.
The agent should help the user make better decisions.
The user decides when a phase starts or ends.

Discovery is evidence gathering.
It is not a request to fix the legacy codebase.

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
- build-order recommendations
- open-question backlogs for human validation

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

`clean-migration-worker` remains available for optional target-project delivery work, but it should not drive discovery or post-discovery recommendations.

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
- `clean-migration-worker` -> `worker` only when the user explicitly starts delivery for the new target project

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

To overwrite an existing `AGENTS.md`:

```powershell
.\install-project.ps1 -TargetRepo "C:\path\to\target-repo" -OverwriteAgentsMd
```

## Workflow Prompts

### Broad Discovery

```text
Usa il profilo `legacy-discovery` tramite un subagent `explorer` con `legacy-business-logic-extraction`.
Esegui una broad discovery dell'intero sistema legacy.
Identifica candidate bounded context, relazioni, dipendenze, segnali legacy e ambiguita' di dominio.
Valuta se ha senso avviare deep discovery dedicate per BC.
Consiglia la delega solo quando migliora la qualita' della discovery.
Non proporre remediation del legacy.
```

### Deep Discovery

```text
Usa il profilo `legacy-discovery` tramite un subagent `explorer` con `legacy-business-logic-extraction`.
Analizza il bounded context [SCOPE] in profondita' in modalita' read-only.
Riporta evidenze, design pressures, ambiguita' di dominio, ipotesi esplicite e confidence.
Non proporre refactoring o remediation del legacy.
```

### Parallel BC Deep Discovery

```text
Dopo la broad discovery, valuta ogni bounded context candidato.
Delega solo i BC che hanno abbastanza segnale e confini sufficientemente leggibili.
Per ogni BC candidato riporta:
- responsabilita'
- evidenze
- perche' la deep discovery aiuterebbe il design del sistema target
- focus suggerito
- dubbi aperti
```

### Design

```text
Usa il profilo `ddd-design` tramite un subagent `explorer` con `ddd-aggregate-design` e `clean-architecture-boundaries`.
Progetta DDD/Clean per [SCOPE].
Non modificare codice.
Trasforma la discovery in decisioni di design, modello target e build order consigliato.
```

### Build Order

```text
Usa discovery e design gia' raccolti.
Consigliami l'ordine di costruzione del nuovo sistema.
Motiva l'ordine con centralita' del dominio, dipendenze concettuali, rischio architetturale e valore informativo.
Non ragionare in termini di migration slice o di modifiche incrementali al legacy.
```

## Recommended Usage

Usa il plugin per capire il legacy, chiarire i bounded contexts, ridurre le ambiguita' di dominio e progettare meglio il sistema nuovo.
Se il team entra in una fase di delivery, il lavoro deve riguardare il nuovo target project, non il cleanup del legacy.
