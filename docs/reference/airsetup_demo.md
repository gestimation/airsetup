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
#> Error in airsetup_demo(demo_dir): could not find function "airsetup_demo"
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
#> 1                            ai_project/source  FALSE     TRUE
#> 2                   ai_project/ai_visible_data  FALSE     TRUE
#> 3                         ai_project/ai_output  FALSE     TRUE
#> 4                          ai_project/r_output  FALSE     TRUE
#> 5                                ai_project/qc  FALSE     TRUE
#> 6                               ai_project/log  FALSE     TRUE
#> 7                         ai_project/AGENTS.md  FALSE     TRUE
#> 8                      ai_project/QC_STATUS.md  FALSE     TRUE
#> 9           ai_project/source/initial_YYYYMMDD  FALSE     TRUE
#> 10 ai_project/ai_visible_data/initial_YYYYMMDD  FALSE     TRUE
#> 11                        r_project/.gitignore  FALSE     TRUE
#> 12    r_project/README_DO_NOT_SHARE_WITH_AI.md  FALSE     TRUE
#> 13                    r_project/ai_hidden_data  FALSE     TRUE
#> 14   r_project/ai_hidden_data/initial_YYYYMMDD  FALSE     TRUE
#>                                  message
#> 1                  Missing required item
#> 2                  Missing required item
#> 3                  Missing required item
#> 4                  Missing required item
#> 5                  Missing required item
#> 6                  Missing required item
#> 7                  Missing required item
#> 8                  Missing required item
#> 9  Missing required dated initial folder
#> 10 Missing required dated initial folder
#> 11                 Missing required item
#> 12                 Missing required item
#> 13                 Missing required item
#> 14                 Missing required item
```
