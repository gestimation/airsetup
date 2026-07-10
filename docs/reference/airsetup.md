# Set up an AI-assisted analysis project structure

Set up an AI-assisted analysis project structure

## Usage

``` r
airsetup(
  path,
  split = TRUE,
  skills = TRUE,
  qc_agent = FALSE,
  japanese = FALSE,
  overwrite = FALSE
)
```

## Arguments

- path:

  Parent directory to create or update.

- split:

  Logical. If `TRUE`, create sibling `ai_project` and `r_project`
  folders. If `FALSE`, create only `ai_project`.

- skills:

  Logical. If `TRUE`, add QC skill templates under
  `ai_project/agent_control/`.

- qc_agent:

  Logical. If `TRUE`, add independent QC agent specifications and Plan
  gate review folders.

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

airsetup(project_dir)
airsetup(project_dir, qc_agent = TRUE)
airsetup(project_dir, split = FALSE)
airsetup(project_dir, skills = FALSE)

aircheck(project_dir)
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
#> 11           ai_project/skills/SKILLS_INDEX.md   file
#> 12       ai_project/skills/QC_SKILL_CONTEXT.md   file
#> 13          ai_project/skills/QC_SKILL_PLAN.md   file
#> 14        ai_project/skills/QC_SKILL_RESULT.md   file
#> 15   ai_project/skills/QC_SKILL_M11SEMANTIC.md   file
#> 16                    r_project/ai_hidden_data folder
#> 17                         r_project/r_scripts folder
#> 18                        r_project/.gitignore   file
#> 19    r_project/README_DO_NOT_SHARE_WITH_AI.md   file
#> 20                    r_project/ai_hidden_data folder
#> 21   r_project/ai_hidden_data/initial_YYYYMMDD folder
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
#> 11           ai_project/skills/SKILLS_INDEX.md   TRUE     TRUE
#> 12       ai_project/skills/QC_SKILL_CONTEXT.md   TRUE     TRUE
#> 13          ai_project/skills/QC_SKILL_PLAN.md   TRUE     TRUE
#> 14        ai_project/skills/QC_SKILL_RESULT.md   TRUE     TRUE
#> 15   ai_project/skills/QC_SKILL_M11SEMANTIC.md   TRUE     TRUE
#> 16                    r_project/ai_hidden_data   TRUE     TRUE
#> 17                         r_project/r_scripts   TRUE     TRUE
#> 18                        r_project/.gitignore   TRUE     TRUE
#> 19    r_project/README_DO_NOT_SHARE_WITH_AI.md   TRUE     TRUE
#> 20                    r_project/ai_hidden_data   TRUE     TRUE
#> 21   r_project/ai_hidden_data/initial_YYYYMMDD   TRUE     TRUE
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
#> 15                      Found
#> 16                      Found
#> 17                      Found
#> 18                      Found
#> 19                      Found
#> 20                      Found
#> 21                      Found
```
