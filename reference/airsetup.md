# Set up an AI-assisted analysis project structure

Set up an AI-assisted analysis project structure

## Usage

``` r
airsetup(
  path,
  mode = c("split", "ai_only"),
  japanese = FALSE,
  overwrite = FALSE
)
```

## Arguments

- path:

  Parent directory to create or update.

- mode:

  Project layout mode. `"split"` creates sibling `ai_project` and
  `r_project` folders. `"ai_only"` creates only `ai_project`.

- japanese:

  Logical. If `TRUE`, generated `AGENTS.md` instructs Codex to write
  narrative output documents in Japanese by default. If `FALSE`, it
  instructs Codex to use English by default. This does not override
  scripts, source code, schemas, or explicit user instructions.

- overwrite:

  Logical. If `TRUE`, overwrite generated files that already exist.

## Value

Invisibly returns the normalized parent path.

## Examples

``` r
project_dir <- file.path(tempdir(), "airsetup_example")

airsetup(
  path = project_dir,
  mode = "split",
  japanese = FALSE,
  overwrite = FALSE
)

aircheck(project_dir, mode = "split")
#>                                        item   type
#> 1                         ai_project/source folder
#> 2                 ai_project/source/initial folder
#> 3                ai_project/ai_visible_data folder
#> 4        ai_project/ai_visible_data/initial folder
#> 5                      ai_project/ai_output folder
#> 6                       ai_project/r_output folder
#> 7                             ai_project/qc folder
#> 8                            ai_project/log folder
#> 9                      ai_project/AGENTS.md   file
#> 10                  ai_project/QC_STATUS.md   file
#> 11                 r_project/ai_hidden_data folder
#> 12         r_project/ai_hidden_data/initial folder
#> 13                     r_project/.gitignore   file
#> 14 r_project/README_DO_NOT_SHARE_WITH_AI.md   file
#>                                        path exists required message
#> 1                         ai_project/source   TRUE     TRUE   Found
#> 2                 ai_project/source/initial   TRUE     TRUE   Found
#> 3                ai_project/ai_visible_data   TRUE     TRUE   Found
#> 4        ai_project/ai_visible_data/initial   TRUE     TRUE   Found
#> 5                      ai_project/ai_output   TRUE     TRUE   Found
#> 6                       ai_project/r_output   TRUE     TRUE   Found
#> 7                             ai_project/qc   TRUE     TRUE   Found
#> 8                            ai_project/log   TRUE     TRUE   Found
#> 9                      ai_project/AGENTS.md   TRUE     TRUE   Found
#> 10                  ai_project/QC_STATUS.md   TRUE     TRUE   Found
#> 11                 r_project/ai_hidden_data   TRUE     TRUE   Found
#> 12         r_project/ai_hidden_data/initial   TRUE     TRUE   Found
#> 13                     r_project/.gitignore   TRUE     TRUE   Found
#> 14 r_project/README_DO_NOT_SHARE_WITH_AI.md   TRUE     TRUE   Found

ai_only_dir <- file.path(tempdir(), "airsetup_ai_only_example")
airsetup(ai_only_dir, mode = "ai_only", japanese = TRUE)
aircheck(ai_only_dir, mode = "ai_only")
#>                                  item   type                               path
#> 1                   ai_project/source folder                  ai_project/source
#> 2           ai_project/source/initial folder          ai_project/source/initial
#> 3          ai_project/ai_visible_data folder         ai_project/ai_visible_data
#> 4  ai_project/ai_visible_data/initial folder ai_project/ai_visible_data/initial
#> 5                ai_project/ai_output folder               ai_project/ai_output
#> 6                 ai_project/r_output folder                ai_project/r_output
#> 7                       ai_project/qc folder                      ai_project/qc
#> 8                      ai_project/log folder                     ai_project/log
#> 9                ai_project/AGENTS.md   file               ai_project/AGENTS.md
#> 10            ai_project/QC_STATUS.md   file            ai_project/QC_STATUS.md
#>    exists required message
#> 1    TRUE     TRUE   Found
#> 2    TRUE     TRUE   Found
#> 3    TRUE     TRUE   Found
#> 4    TRUE     TRUE   Found
#> 5    TRUE     TRUE   Found
#> 6    TRUE     TRUE   Found
#> 7    TRUE     TRUE   Found
#> 8    TRUE     TRUE   Found
#> 9    TRUE     TRUE   Found
#> 10   TRUE     TRUE   Found
```
