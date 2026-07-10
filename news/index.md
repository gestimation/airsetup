# Changelog

## airsetup 0.0.3.9000

### Breaking changes

- [`airsetup()`](https://gestimation.github.io/airsetup/reference/airsetup.md)
  no longer accepts the `mode` argument.
- Project layout is now controlled by explicit logical arguments:
  `split`, `skills`, and `qc_agent`.
- `split = TRUE` replaces the old split layout behavior, while
  `split = FALSE` creates only `ai_project/`.
- AI/agent control files are now centralized under
  `ai_project/agent_control/`. QC skill templates are created there when
  `skills = TRUE`, and independent Workflow/QC agent role files are
  created there when `qc_agent = TRUE`. Legacy `ai_project/skills/` and
  `ai_project/agent_specs/` directories are no longer created. `source/`
  is reserved for protocols, SAPs, database definitions, and other
  source materials.
- The split-project scaffold no longer creates `r_project/r_scripts/`.
- User-run R outputs are centralized under `ai_project/r_output/`;
  `r_project/r_output/` is no longer created.
- `qc_agent = TRUE` adds independent QC agent scaffolding and documents
  the Plan gate rule that final R code generation must wait for
  `APPROVE_NEXT_STEP`.
