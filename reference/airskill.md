# Add AI & R QC skill templates

`airskill()` adds lightweight QC skill Markdown files to an existing
airsetup project. The files are written under
`ai_project/agent_control/`. Use `"plan"` for a general coding plan or
analysis specification and `"sap"` for a clinical-trial Statistical
Analysis Plan. These are normally alternative review tracks. SAP QC can
use `M11SEMANTIC_MAP.md` when it is available, but it can also review
the supplied protocol or the SAP alone. When cross-document evidence is
unavailable, the generated SAP skill instructs the reviewer to report
`Cannot assess`, not infer missing facts.

## Usage

``` r
airskill(
  path = ".",
  skills = c("context", "plan", "sap", "result", "m11_semantic"),
  overwrite = FALSE,
  quiet = FALSE
)
```

## Arguments

- path:

  Project root created by
  [`airsetup()`](https://gestimation.github.io/airsetup/reference/airsetup.md).

- skills:

  Character vector of skills to add. Supported values are `"context"`,
  `"plan"`, `"sap"`, `"result"`, and `"m11_semantic"`.

- overwrite:

  Logical. If `FALSE`, existing files are not overwritten.

- quiet:

  Logical. If `TRUE`, suppress messages.

## Value

A data frame with columns `file`, `path`, `status`, and `overwritten`.

## Examples

``` r
project_dir <- file.path(tempdir(), "airskill_example")
airsetup(project_dir, split = FALSE, skills = FALSE)
airskill(project_dir)
#> skipped: ai_project/agent_control/AGENT_CONTROL_INDEX.md
#> created: ai_project/agent_control/QC_SKILL_CONTEXT.md
#> created: ai_project/agent_control/QC_SKILL_PLAN.md
#> created: ai_project/agent_control/QC_SKILL_SAP.md
#> created: ai_project/agent_control/QC_SKILL_RESULT.md
#> created: ai_project/agent_control/QC_SKILL_M11SEMANTIC.md
#>                      file                                             path
#> 1  AGENT_CONTROL_INDEX.md  ai_project/agent_control/AGENT_CONTROL_INDEX.md
#> 2     QC_SKILL_CONTEXT.md     ai_project/agent_control/QC_SKILL_CONTEXT.md
#> 3        QC_SKILL_PLAN.md        ai_project/agent_control/QC_SKILL_PLAN.md
#> 4         QC_SKILL_SAP.md         ai_project/agent_control/QC_SKILL_SAP.md
#> 5      QC_SKILL_RESULT.md      ai_project/agent_control/QC_SKILL_RESULT.md
#> 6 QC_SKILL_M11SEMANTIC.md ai_project/agent_control/QC_SKILL_M11SEMANTIC.md
#>    status overwritten
#> 1 skipped       FALSE
#> 2 created       FALSE
#> 3 created       FALSE
#> 4 created       FALSE
#> 5 created       FALSE
#> 6 created       FALSE
airskill(project_dir, skills = c("context", "plan"))
#> skipped: ai_project/agent_control/AGENT_CONTROL_INDEX.md
#> skipped: ai_project/agent_control/QC_SKILL_CONTEXT.md
#> skipped: ai_project/agent_control/QC_SKILL_PLAN.md
#>                     file                                            path
#> 1 AGENT_CONTROL_INDEX.md ai_project/agent_control/AGENT_CONTROL_INDEX.md
#> 2    QC_SKILL_CONTEXT.md    ai_project/agent_control/QC_SKILL_CONTEXT.md
#> 3       QC_SKILL_PLAN.md       ai_project/agent_control/QC_SKILL_PLAN.md
#>    status overwritten
#> 1 skipped       FALSE
#> 2 skipped       FALSE
#> 3 skipped       FALSE
airskill(project_dir, skills = "sap")
#> skipped: ai_project/agent_control/AGENT_CONTROL_INDEX.md
#> skipped: ai_project/agent_control/QC_SKILL_SAP.md
#>                     file                                            path
#> 1 AGENT_CONTROL_INDEX.md ai_project/agent_control/AGENT_CONTROL_INDEX.md
#> 2        QC_SKILL_SAP.md        ai_project/agent_control/QC_SKILL_SAP.md
#>    status overwritten
#> 1 skipped       FALSE
#> 2 skipped       FALSE
airskill(project_dir, skills = "m11_semantic")
#> skipped: ai_project/agent_control/AGENT_CONTROL_INDEX.md
#> skipped: ai_project/agent_control/QC_SKILL_M11SEMANTIC.md
#>                      file                                             path
#> 1  AGENT_CONTROL_INDEX.md  ai_project/agent_control/AGENT_CONTROL_INDEX.md
#> 2 QC_SKILL_M11SEMANTIC.md ai_project/agent_control/QC_SKILL_M11SEMANTIC.md
#>    status overwritten
#> 1 skipped       FALSE
#> 2 skipped       FALSE
```
