# Changelog

## airsetup 0.0.3.9000

### Breaking changes

- [`airsetup()`](https://gestimation.github.io/airsetup/reference/airsetup.md)
  no longer accepts the `mode` argument.
- Project layout is now controlled by explicit logical arguments:
  `split`, `skills`, and `qc_agent`.
- `split = TRUE` replaces the old split layout behavior, while
  `split = FALSE` creates only `ai_project/`.
- QC skill templates are now created under `ai_project/skills/`;
  `source/` is reserved for protocols, SAPs, database definitions, and
  other source materials.
- User-run R outputs are centralized under `ai_project/r_output/`;
  `r_project/r_output/` is no longer created.
- `qc_agent = TRUE` adds independent QC agent scaffolding and documents
  the Plan gate rule that final R code generation must wait for
  `APPROVE_NEXT_STEP`.
