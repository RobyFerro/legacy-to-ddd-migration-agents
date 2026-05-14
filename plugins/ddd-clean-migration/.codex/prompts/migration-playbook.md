# DDD + Clean Architecture Migration Playbook

Use these short prompts from the repository root.

## Workspace Bootstrap

```text
Se il workspace di migrazione non esiste, crea la struttura standard sotto migration/
usando il template del progetto e una safe area nella stessa repository.
```

Suggested command:

```powershell
.\.codex\scripts\initialize-migration-workspace.ps1 -TargetRepo "<repo-path>"
```

## Broad Discovery

```text
Usa legacy-discovery con legacy-business-logic-extraction.
Esegui una broad discovery dell'intero sistema legacy.
Identifica candidate bounded context, relazioni, dipendenze e hotspot.
Aggiorna:
- migration/migration-project.yaml
- migration/00-system/bounded-context-catalog.md
- migration/00-system/bounded-context-catalog.yaml
- migration/00-system/context-map.md
```

## Deep Discovery

```text
Usa legacy-discovery con legacy-business-logic-extraction.
Analizza il bounded context [SCOPE] in profondita' in modalita' read-only.
Aggiorna:
- migration/bounded-contexts/[slug]/01-discovery.md
- migration/bounded-contexts/[slug]/01-discovery.yaml
Riporta ipotesi esplicite con confidence quando il codice non e' chiaro.
```

## Design

```text
Usa ddd-design con ddd-aggregate-design e clean-architecture-boundaries.
Progetta DDD/Clean per [SCOPE].
Non modificare codice.
Aggiorna:
- migration/bounded-contexts/[slug]/02-design.md
- migration/bounded-contexts/[slug]/02-model.yaml
- migration/migration-project.yaml
```

## Migration Plan

```text
Usa clean-migration-worker con migration-slice-planning.
Crea solo il migration plan per [SCOPE].
Non modificare codice.
Dividi il lavoro in slice piccoli e consigliami il primo.
Aggiorna migration/bounded-contexts/[slug]/03-migration-plan.md.
```

## Implementation

```text
APPROVED: implement this migration slice

Usa clean-migration-worker con clean-architecture-boundaries.
Implementa solo lo slice approvato.
Non ampliare scope.
Preserva comportamento legacy.
Lavora principalmente dentro migration/safe-area/.
Aggiorna:
- migration/bounded-contexts/[slug]/04-implementation-notes.md
- migration/bounded-contexts/[slug]/05-validation.md
```

## Validation

```text
Usa clean-migration-worker con architecture-validation.
Valida lo slice appena implementato.
Non modificare codice.
Aggiorna migration/bounded-contexts/[slug]/05-validation.md.
```

## Bounded Context Planning

```text
Pianifica la migrazione broad-to-specific del bounded context [Name].
Se manca, esegui prima la broad discovery del sistema.
```

Expected workflow:

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
