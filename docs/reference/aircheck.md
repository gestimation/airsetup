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
