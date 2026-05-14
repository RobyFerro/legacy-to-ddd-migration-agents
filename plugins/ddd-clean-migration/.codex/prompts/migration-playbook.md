# Legacy-Informed DDD/Clean Design Playbook

Use these short prompts from the repository root.

## Broad Discovery

```text
Usa legacy-discovery con legacy-business-logic-extraction.
Esegui una broad discovery dell'intero sistema legacy.
Identifica candidate bounded context, relazioni, dipendenze, segnali legacy e ambiguita' di dominio.
Valuta se una deep discovery dedicata per alcuni BC migliorerebbe davvero la qualita' delle decisioni di design.
Non proporre remediation del legacy.
```

## Deep Discovery

```text
Usa legacy-discovery con legacy-business-logic-extraction.
Analizza il bounded context [SCOPE] in profondita' in modalita' read-only.
Riporta evidenze, language candidates, design pressures, domain ambiguities e ipotesi con confidence.
Non proporre refactoring o remediation del legacy.
```

## Parallel BC Deep Discovery

```text
Dopo la broad discovery, valuta ogni bounded context candidato.
Delega solo i BC che hanno abbastanza segnale per produrre discovery utile.
Per ogni BC candidato riporta:
- responsabilita'
- evidenze
- perche' la deep discovery aiuterebbe il design del sistema target
- focus suggerito
- dubbi aperti
```

## Design

```text
Usa ddd-design con ddd-aggregate-design e clean-architecture-boundaries.
Progetta DDD/Clean per [SCOPE].
Non modificare codice.
Trasforma la discovery in decisioni di design, modello target e build order consigliato.
```

## Build Order

```text
Usa discovery e design gia' raccolti.
Consigliami l'ordine di costruzione del nuovo sistema.
Motiva l'ordine con centralita' del dominio, dipendenze concettuali, rischio architetturale e valore informativo.
Non usare linguaggio da migration slice o da refactoring incrementale.
```

## Optional Delivery

```text
L'utente ha avviato la fase di delivery del nuovo sistema.
Usa clean-migration-worker solo per costruire il target project, non per modificare il legacy.
Implementa solo lo scope richiesto e valida il risultato.
```
