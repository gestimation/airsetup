# Set up a demo AI-assisted analysis project

`airsetup_demo()` is a beginner-friendly wrapper around
[`airsetup()`](https://gestimation.github.io/airsetup/reference/airsetup.md).
It creates the standard project structure, optionally adds QC skill
templates with
[`airskill()`](https://gestimation.github.io/airsetup/reference/airskill.md),
and places bundled prostate cancer demo materials in the initial data
and source folders.

## Usage

``` r
airsetup_demo(path, japanese = TRUE, skills = TRUE, overwrite = FALSE)
```

## Arguments

- path:

  Parent directory to create or update.

- japanese:

  Logical. If `TRUE`, generated `AGENTS.md` instructs Codex to write
  narrative output documents in Japanese by default.

- skills:

  Logical. If `TRUE`, also run
  [`airskill()`](https://gestimation.github.io/airsetup/reference/airskill.md)
  to add QC skill templates.

- overwrite:

  Logical. If `TRUE`, overwrite generated files and demo materials that
  already exist.

## Value

A data frame with columns `file`, `path`, `status`, and `overwritten`.

## Examples

``` r
demo_dir <- file.path(tempdir(), "airsetup_demo_example")
airsetup_demo(demo_dir)
#>                      file
#> 1         SKILLS_INDEX.md
#> 2     QC_SKILL_CONTEXT.md
#> 3        QC_SKILL_PLAN.md
#> 4      QC_SKILL_RESULT.md
#> 5 QC_SKILL_M11SEMANTIC.md
#> 6            demodata.rds
#> 7            demodata.rds
#> 8 definition_demodata.txt
#>                                                         path  status
#> 1                   ai_project/source/skills/SKILLS_INDEX.md created
#> 2               ai_project/source/skills/QC_SKILL_CONTEXT.md created
#> 3                  ai_project/source/skills/QC_SKILL_PLAN.md created
#> 4                ai_project/source/skills/QC_SKILL_RESULT.md created
#> 5           ai_project/source/skills/QC_SKILL_M11SEMANTIC.md created
#> 6   ai_project/ai_visible_data/initial_20260708/demodata.rds created
#> 7     r_project/ai_hidden_data/initial_20260708/demodata.rds created
#> 8 ai_project/source/initial_20260708/definition_demodata.txt created
#>   overwritten
#> 1       FALSE
#> 2       FALSE
#> 3       FALSE
#> 4       FALSE
#> 5       FALSE
#> 6       FALSE
#> 7       FALSE
#> 8       FALSE
aircheck(demo_dir)
#>                                           item   type
#> 1                            ai_project/source folder
#> 2                   ai_project/ai_visible_data folder
#> 3                         ai_project/ai_output folder
#> 4                          ai_project/r_output folder
#> 5                                ai_project/qc folder
#> 6                               ai_project/log folder
#> 7                         ai_project/AGENTS.md   file
#> 8                      ai_project/QC_STATUS.md   file
#> 9           ai_project/source/initial_YYYYMMDD folder
#> 10 ai_project/ai_visible_data/initial_YYYYMMDD folder
#> 11                        r_project/.gitignore   file
#> 12    r_project/README_DO_NOT_SHARE_WITH_AI.md   file
#> 13                    r_project/ai_hidden_data folder
#> 14   r_project/ai_hidden_data/initial_YYYYMMDD folder
#>                                           path exists required
#> 1                            ai_project/source   TRUE     TRUE
#> 2                   ai_project/ai_visible_data   TRUE     TRUE
#> 3                         ai_project/ai_output   TRUE     TRUE
#> 4                          ai_project/r_output   TRUE     TRUE
#> 5                                ai_project/qc   TRUE     TRUE
#> 6                               ai_project/log   TRUE     TRUE
#> 7                         ai_project/AGENTS.md   TRUE     TRUE
#> 8                      ai_project/QC_STATUS.md   TRUE     TRUE
#> 9           ai_project/source/initial_YYYYMMDD   TRUE     TRUE
#> 10 ai_project/ai_visible_data/initial_YYYYMMDD   TRUE     TRUE
#> 11                        r_project/.gitignore   TRUE     TRUE
#> 12    r_project/README_DO_NOT_SHARE_WITH_AI.md   TRUE     TRUE
#> 13                    r_project/ai_hidden_data   TRUE     TRUE
#> 14   r_project/ai_hidden_data/initial_YYYYMMDD   TRUE     TRUE
#>                       message
#> 1                       Found
#> 2                       Found
#> 3                       Found
#> 4                       Found
#> 5                       Found
#> 6                       Found
#> 7                       Found
#> 8                       Found
#> 9  Found dated initial folder
#> 10 Found dated initial folder
#> 11                      Found
#> 12                      Found
#> 13                      Found
#> 14                      Found
```
