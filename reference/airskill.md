# Add AI & R QC skill templates

`airskill()` adds lightweight QC skill Markdown files to an existing
airsetup project. The files are written under
`ai_project/source/skills/`.

## Usage

``` r
airskill(
  path = ".",
  skills = c("context", "plan", "result", "m11_semantic"),
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
  `"plan"`, `"result"`, and `"m11_semantic"`.

- overwrite:

  Logical. If `FALSE`, existing files are not overwritten.

- quiet:

  Logical. If `TRUE`, suppress messages.

## Value

A data frame with columns `file`, `path`, `status`, and `overwritten`.

## Examples

``` r
project_dir <- file.path(tempdir(), "airskill_example")
airsetup(project_dir, mode = "ai_only")
airskill(project_dir)
#> created: ai_project/source/skills/SKILLS_INDEX.md
#> created: ai_project/source/skills/QC_SKILL_CONTEXT.md
#> created: ai_project/source/skills/QC_SKILL_PLAN.md
#> created: ai_project/source/skills/QC_SKILL_RESULT.md
#> created: ai_project/source/skills/QC_SKILL_M11SEMANTIC.md
#>                      file                                             path
#> 1         SKILLS_INDEX.md         ai_project/source/skills/SKILLS_INDEX.md
#> 2     QC_SKILL_CONTEXT.md     ai_project/source/skills/QC_SKILL_CONTEXT.md
#> 3        QC_SKILL_PLAN.md        ai_project/source/skills/QC_SKILL_PLAN.md
#> 4      QC_SKILL_RESULT.md      ai_project/source/skills/QC_SKILL_RESULT.md
#> 5 QC_SKILL_M11SEMANTIC.md ai_project/source/skills/QC_SKILL_M11SEMANTIC.md
#>    status overwritten
#> 1 created       FALSE
#> 2 created       FALSE
#> 3 created       FALSE
#> 4 created       FALSE
#> 5 created       FALSE
airskill(project_dir, skills = c("context", "plan"))
#> skipped: ai_project/source/skills/SKILLS_INDEX.md
#> skipped: ai_project/source/skills/QC_SKILL_CONTEXT.md
#> skipped: ai_project/source/skills/QC_SKILL_PLAN.md
#>                  file                                         path  status
#> 1     SKILLS_INDEX.md     ai_project/source/skills/SKILLS_INDEX.md skipped
#> 2 QC_SKILL_CONTEXT.md ai_project/source/skills/QC_SKILL_CONTEXT.md skipped
#> 3    QC_SKILL_PLAN.md    ai_project/source/skills/QC_SKILL_PLAN.md skipped
#>   overwritten
#> 1       FALSE
#> 2       FALSE
#> 3       FALSE
airskill(project_dir, skills = "m11_semantic")
#> skipped: ai_project/source/skills/SKILLS_INDEX.md
#> skipped: ai_project/source/skills/QC_SKILL_M11SEMANTIC.md
#>                      file                                             path
#> 1         SKILLS_INDEX.md         ai_project/source/skills/SKILLS_INDEX.md
#> 2 QC_SKILL_M11SEMANTIC.md ai_project/source/skills/QC_SKILL_M11SEMANTIC.md
#>    status overwritten
#> 1 skipped       FALSE
#> 2 skipped       FALSE
```
