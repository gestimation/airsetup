# Add AI & R QC skill templates

`airskill()` adds lightweight QC skill Markdown files to an existing
airsetup project. The files are written under
`ai_project/source/skills/`.

## Usage

``` r
airskill(
  path = ".",
  skills = c("context", "plan", "result"),
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
  `"plan"`, and `"result"`.

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
#>                  file                                         path  status
#> 1     SKILLS_INDEX.md     ai_project/source/skills/SKILLS_INDEX.md created
#> 2 QC_SKILL_CONTEXT.md ai_project/source/skills/QC_SKILL_CONTEXT.md created
#> 3    QC_SKILL_PLAN.md    ai_project/source/skills/QC_SKILL_PLAN.md created
#> 4  QC_SKILL_RESULT.md  ai_project/source/skills/QC_SKILL_RESULT.md created
#>   overwritten
#> 1       FALSE
#> 2       FALSE
#> 3       FALSE
#> 4       FALSE
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
```
