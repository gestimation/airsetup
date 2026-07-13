# Check an airsetup project structure

Check an airsetup project structure

## Usage

``` r
aircheck(path, split = TRUE, skills = TRUE, qc_agent = FALSE)
```

## Arguments

- path:

  Parent project directory to check.

- split:

  Logical. If `TRUE`, check the sibling `r_project` scaffold.

- skills:

  Logical. If `TRUE`, check the context, general plan, clinical SAP,
  result, and M11 semantic QC skill templates under
  `ai_project/agent_control/`.

- qc_agent:

  Logical. If `TRUE`, check independent QC agent scaffolding.

## Value

A data.frame with columns `item`, `type`, `path`, `exists`, `required`,
and `message`.

## Examples

``` r
project_dir <- file.path(tempdir(), "aircheck_example")
airsetup(project_dir)
aircheck(project_dir)
#>                                                item   type
#> 1                                 ai_project/source folder
#> 2                        ai_project/ai_visible_data folder
#> 3                              ai_project/ai_output folder
#> 4                               ai_project/r_output folder
#> 5                                     ai_project/qc folder
#> 6                                    ai_project/log folder
#> 7                          ai_project/agent_control folder
#> 8                              ai_project/AGENTS.md   file
#> 9                           ai_project/QC_STATUS.md   file
#> 10               ai_project/source/initial_YYYYMMDD folder
#> 11      ai_project/ai_visible_data/initial_YYYYMMDD folder
#> 12  ai_project/agent_control/AGENT_CONTROL_INDEX.md   file
#> 13     ai_project/agent_control/QC_SKILL_CONTEXT.md   file
#> 14        ai_project/agent_control/QC_SKILL_PLAN.md   file
#> 15         ai_project/agent_control/QC_SKILL_SAP.md   file
#> 16      ai_project/agent_control/QC_SKILL_RESULT.md   file
#> 17 ai_project/agent_control/QC_SKILL_M11SEMANTIC.md   file
#> 18                         r_project/ai_hidden_data folder
#> 19                             r_project/.gitignore   file
#> 20         r_project/README_DO_NOT_SHARE_WITH_AI.md   file
#> 21                         r_project/ai_hidden_data folder
#> 22        r_project/ai_hidden_data/initial_YYYYMMDD folder
#>                                                path exists required
#> 1                                 ai_project/source   TRUE     TRUE
#> 2                        ai_project/ai_visible_data   TRUE     TRUE
#> 3                              ai_project/ai_output   TRUE     TRUE
#> 4                               ai_project/r_output   TRUE     TRUE
#> 5                                     ai_project/qc   TRUE     TRUE
#> 6                                    ai_project/log   TRUE     TRUE
#> 7                          ai_project/agent_control   TRUE     TRUE
#> 8                              ai_project/AGENTS.md   TRUE     TRUE
#> 9                           ai_project/QC_STATUS.md   TRUE     TRUE
#> 10               ai_project/source/initial_YYYYMMDD   TRUE     TRUE
#> 11      ai_project/ai_visible_data/initial_YYYYMMDD   TRUE     TRUE
#> 12  ai_project/agent_control/AGENT_CONTROL_INDEX.md   TRUE     TRUE
#> 13     ai_project/agent_control/QC_SKILL_CONTEXT.md   TRUE     TRUE
#> 14        ai_project/agent_control/QC_SKILL_PLAN.md   TRUE     TRUE
#> 15         ai_project/agent_control/QC_SKILL_SAP.md   TRUE     TRUE
#> 16      ai_project/agent_control/QC_SKILL_RESULT.md   TRUE     TRUE
#> 17 ai_project/agent_control/QC_SKILL_M11SEMANTIC.md   TRUE     TRUE
#> 18                         r_project/ai_hidden_data   TRUE     TRUE
#> 19                             r_project/.gitignore   TRUE     TRUE
#> 20         r_project/README_DO_NOT_SHARE_WITH_AI.md   TRUE     TRUE
#> 21                         r_project/ai_hidden_data   TRUE     TRUE
#> 22        r_project/ai_hidden_data/initial_YYYYMMDD   TRUE     TRUE
#>                       message
#> 1                       Found
#> 2                       Found
#> 3                       Found
#> 4                       Found
#> 5                       Found
#> 6                       Found
#> 7                       Found
#> 8                       Found
#> 9                       Found
#> 10 Found dated initial folder
#> 11 Found dated initial folder
#> 12                      Found
#> 13                      Found
#> 14                      Found
#> 15                      Found
#> 16                      Found
#> 17                      Found
#> 18                      Found
#> 19                      Found
#> 20                      Found
#> 21                      Found
#> 22                      Found
```
