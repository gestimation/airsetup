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
#> created: ai_project/source/skills/CONTEXT-QC-SKILL.md
#> created: ai_project/source/skills/PLAN-QC-SKILL.md
#> created: ai_project/source/skills/RESULT-QC-SKILL.md
#>                  file                                         path  status
#> 1     SKILLS_INDEX.md     ai_project/source/skills/SKILLS_INDEX.md created
#> 2 CONTEXT-QC-SKILL.md ai_project/source/skills/CONTEXT-QC-SKILL.md created
#> 3    PLAN-QC-SKILL.md    ai_project/source/skills/PLAN-QC-SKILL.md created
#> 4  RESULT-QC-SKILL.md  ai_project/source/skills/RESULT-QC-SKILL.md created
#>   overwritten
#> 1       FALSE
#> 2       FALSE
#> 3       FALSE
#> 4       FALSE
airskill(project_dir, skills = c("context", "plan"))
#> skipped: ai_project/source/skills/SKILLS_INDEX.md
#> skipped: ai_project/source/skills/CONTEXT-QC-SKILL.md
#> skipped: ai_project/source/skills/PLAN-QC-SKILL.md
#>                  file                                         path  status
#> 1     SKILLS_INDEX.md     ai_project/source/skills/SKILLS_INDEX.md skipped
#> 2 CONTEXT-QC-SKILL.md ai_project/source/skills/CONTEXT-QC-SKILL.md skipped
#> 3    PLAN-QC-SKILL.md    ai_project/source/skills/PLAN-QC-SKILL.md skipped
#>   overwritten
#> 1       FALSE
#> 2       FALSE
#> 3       FALSE
```
