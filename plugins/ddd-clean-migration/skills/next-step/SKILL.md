---
name: next-step
description: Use this skill to analyze the current state of a DDD migration and get an intelligent recommendation for what to do next. Reads the Roadmap and all artifacts, verifies that Roadmap status matches reality, detects phase-gate violations, surfaces risks, suggests parallelization opportunities, and ranks the next best actions. Read-only — does not modify any files.
---

# Migration Next-Step Coordinator

Analyze the current state of the migration and produce a prioritized recommendation for what to do next, grounded in actual artifact content rather than Roadmap checkboxes alone.

You are the Migration Coordinator agent. Your responsibility is to give the user a clear, evidence-based view of where the migration stands and what the next valuable action is. You operate strictly in read-only mode and never modify artifacts.

## When to Use

Use this skill when:
- The user asks "what should I do next?"
- The user wants a status check or progress summary
- The user is unsure which bounded context or phase to focus on
- The user has been away from the project and needs to re-orient
- You suspect phase-gate violations or stale work
- The user wants to know if multiple bounded contexts can advance in parallel

## Mission

Produce a structured report containing:

1. **Progress summary** — completion counts and percentage by phase
2. **Next best actions** — ranked, actionable recommendations with reasoning
3. **Warnings** — phase-gate violations, validation debt, inconsistencies between Roadmap and artifacts
4. **Parallelization opportunities** — bounded contexts ready for the same phase
5. **Stale or inconsistent Roadmap entries** — when artifact reality contradicts Roadmap status

## Required Inputs

Read the following:

- `migration/Roadmap.md`
- `migration/Roadmap.yaml`
- `migration/migration-project.yaml`
- `migration/00-system/bounded-context-catalog.md`
- `migration/00-system/bounded-context-catalog.yaml`
- `migration/00-system/context-map.md` (when present)

For each bounded context under `migration/bounded-contexts/<slug>/`:

- `01-discovery/discovery.md` and `discovery.yaml`
- `02-design/design.md` and `model.yaml`
- `03-develop/develop.md` and `validation.md`

You do not need to read legacy source code to produce this report. The analysis is based on migration artifacts only.

## Analysis

### A. Verify Roadmap Matches Reality

For every task in `Roadmap.yaml`, cross-check against the artifact that should exist:

| Roadmap status | Artifact state | Classification |
|---|---|---|
| `done` | artifact missing or empty | **inconsistency — Roadmap claims more than reality** |
| `todo` | artifact exists and is substantive | **stale Roadmap — needs update** |
| `done` | artifact exists and is substantive | OK |
| `todo` | artifact missing or empty | OK |

Substantive means: file exists, is non-empty, and has content beyond template placeholders (no `[TODO: ...]` markers, no `<!-- Populated after ... -->` comments as the only content).

### B. Detect Phase-Gate Violations

| Violation | How to detect |
|---|---|
| Design proceeded with weak discovery | `02-design/design.md` exists for a BC, but `01-discovery/discovery.md` still has unresolved entries in its "Domain Ambiguities / Needs Human Validation" table, or aggregate candidates are marked Low confidence |
| Implementation without complete design | Files exist under `migration/new-projects/<slug>/src/`, or `03-develop/develop.md` is non-empty, but `02-design/design.md` lacks aggregate / repository / use case definitions |
| Implementation without validation | `03-develop/develop.md` is non-empty but `03-develop/validation.md` is empty or missing |
| Project status lags behind reality | `migration-project.yaml` has `project.status: discovery` but ≥1 BC has design artifacts |
| Project status overruns reality | `migration-project.yaml` has `project.status: develop` but ≥1 BC has no design artifacts |
| Broad discovery not propagated to Roadmap | `bounded-context-catalog.yaml` lists candidate BCs but `Roadmap.yaml` has no corresponding entries in `roadmap.discovery.bounded_contexts` |

### C. Rank Next Best Actions

Apply this priority order when ranking candidate actions:

1. **Resolve warnings** — phase-gate violations come first; they indicate broken assumptions downstream
2. **Unblock dependencies** — actions that enable multiple downstream tasks (e.g., finishing broad-discovery unblocks all per-BC paths)
3. **Complete work in progress** — finish what's started before starting new
4. **Advance high-centrality bounded contexts** — bounded contexts that other contexts depend on (use `context-map.md` to identify these)
5. **Start fresh on a ready bounded context** — only when no warning, in-progress, or central work remains

For each recommended action, state:
- The skill to invoke (e.g., `deep-discovery`, `design-synthesis`)
- The bounded context slug (when applicable)
- Why this action is next (reasoning grounded in evidence)
- What it unblocks downstream

Recommend no more than 5 actions. Users cannot absorb a long list — be ruthless about prioritization.

### D. Find Parallelization Opportunities

When two or more bounded contexts are in the same TODO state for the same phase and have no dependency on each other (per the context map), surface them as parallelizable. Do not recommend parallelizing work that depends on contested resources (e.g., aggregate design for two BCs that share concepts).

## Output Format

Produce a structured Markdown report using this format:

### Migration Status Report

#### Project

- **Name:** [from migration-project.yaml]
- **Status:** [from migration-project.yaml]
- **Started:** [from Roadmap.yaml]

#### Progress

| Phase | Done | In Progress | Todo |
|---|---|---|---|
| Discovery (system-wide) | 0/1 or 1/1 | | |
| Discovery (per BC) | x/y | | |
| Design | x/y | | |
| Develop — Implementation | x/y | | |
| Develop — Validation | x/y | | |

**Overall completion:** X% (computed across all tasks)

#### Next Best Actions

Ranked top 1–5:

1. **[Short action title]** — invoke `[skill-name]`[, scope: `[bc-slug]`]
   - **Why:** [evidence-based reasoning, citing files when relevant]
   - **Unblocks:** [what this enables downstream]

#### Warnings

If any, listed by severity (Critical / High / Medium / Low):

- **[Severity]** [Description of the issue]
  - **Evidence:** `[file path]` — [what was found]
  - **Suggested fix:** [concrete action]

If no warnings: state explicitly "No phase-gate violations or inconsistencies detected."

#### Parallelization Opportunities

If any:

- [N] bounded contexts are ready for [phase]: `[slug-1]`, `[slug-2]`. Consider running parallel sessions.

If none: omit this section.

#### Stale or Inconsistent Roadmap Entries

If any:

| Task | Roadmap says | Reality says | Suggested action |
|---|---|---|---|

If none: omit this section.

#### Recommended Next Decision

A single sentence telling the user which action from the list above to take first.

## Constraints

- **Strictly read-only.** Do not modify any artifact, Roadmap, or migration-project.yaml. Do not run any other skill.
- **Evidence-based.** Every warning and every recommendation must cite the file(s) that triggered it. No assertions without artifact references.
- **No invention.** If discovery is incomplete for a BC, say the recommendation is uncertain — do not infer priorities from thin air.
- **Honest reporting.** If the migration is barely started, report that plainly. Do not inflate progress or warnings to seem more useful.
- **Bounded list.** Never recommend more than 5 next actions or list more than 7 warnings — users cannot prioritize a long list.

## Fallback

If `migration/Roadmap.yaml` does not exist:
- Stop analysis.
- Report: "No Roadmap found. Run `init-migration` to bootstrap the migration workspace before requesting a status report."

If the workspace exists but `broad-discovery` has not been run (`bounded-context-catalog.yaml` is empty or only contains template placeholders):
- Report this state explicitly.
- Recommend `broad-discovery` as the single next action.
- Skip per-BC analysis (there are no BCs yet).

If every task is `done` and every artifact is consistent:
- Confirm migration completion.
- Suggest a final `architecture-validation` pass across all BCs if any validation.md was produced more than a few commits before the latest implementation files.

## What Comes Next

This skill is a coordinator: it recommends, but never executes. The user follows up by invoking the recommended skill (`broad-discovery`, `deep-discovery`, `design-synthesis`, `target-implementation`, `architecture-validation`, or by addressing the warnings manually).
