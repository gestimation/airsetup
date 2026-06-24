# Check an airsetup project structure

Check an airsetup project structure

## Usage

``` r
aircheck(path, mode = c("split", "ai_only"))
```

## Arguments

- path:

  Parent project directory to check.

- mode:

  Project layout mode to check. `"split"` checks sibling `ai_project`
  and `r_project` folders. `"ai_only"` checks only `ai_project`.

## Value

A data.frame with columns `item`, `type`, `path`, `exists`, `required`,
and `message`.

## Examples

``` r
project_dir <- file.path(tempdir(), "aircheck_example")
airsetup(project_dir, mode = "split")
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
```
