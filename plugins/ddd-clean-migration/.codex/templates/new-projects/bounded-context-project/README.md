# Bounded Context Migration Project

This is a standalone migration target project for one bounded context.

Recommended approach:

- keep all new implementation here
- touch legacy code only through thin adapters or integration seams
- preserve traceability back to the bounded-context artifacts under `migration/bounded-contexts/`
