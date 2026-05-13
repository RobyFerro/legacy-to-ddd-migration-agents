# DDD + Clean Architecture Migration Playbook

Use these short prompts from the repository root.

## Discovery

```text
Usa legacy-discovery con legacy-business-logic-extraction.
Analizza [SCOPE] read-only e aggiorna legacy-discovery-report.md.
```

## Design

```text
Usa ddd-design con ddd-aggregate-design e clean-architecture-boundaries.
Progetta DDD/Clean per [SCOPE].
Non modificare codice.
Produci ddd-design-proposal.md.
```

## Migration Plan

```text
Usa clean-migration-worker con migration-slice-planning.
Crea solo migration-plan.md per [SCOPE].
Non modificare codice.
Dividi il lavoro in slice piccoli e consigliami il primo.
```

## Implementation

```text
APPROVED: implement this migration slice

Usa clean-migration-worker con clean-architecture-boundaries.
Implementa solo lo slice approvato.
Non ampliare scope.
Preserva comportamento legacy.
Produci implementation-summary.md e validation-report.md.
```

## Validation

```text
Usa clean-migration-worker con architecture-validation.
Valida lo slice appena implementato.
Non modificare codice.
Aggiorna validation-report.md.
```

## Bounded Context Planning

```text
Pianifica la migrazione da legacy a DDD del bounded context [Name].
```

Expected workflow:

```text
legacy-discovery + legacy-business-logic-extraction
↓
ddd-design + ddd-aggregate-design + clean-architecture-boundaries
↓
clean-migration-worker + migration-slice-planning
↓
STOP before implementation
```
