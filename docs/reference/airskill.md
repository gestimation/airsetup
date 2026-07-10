# Add AI & R QC skill templates

`airskill()` adds lightweight QC skill Markdown files to an existing
airsetup project. The files are written under `ai_project/skills/`.

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
airsetup(project_dir, split = FALSE, skills = FALSE)
#> Error in airsetup(project_dir, split = FALSE, skills = FALSE): unused arguments (split = FALSE, skills = FALSE)
airskill(project_dir)
#> Error in normalizePath(path.expand(path), winslash, mustWork): path[1]="C:\Users\Shiro\AppData\Local\Temp\RtmpczczET/airskill_example": 指定されたファイルが見つかりません。
airskill(project_dir, skills = c("context", "plan"))
#> Error in normalizePath(path.expand(path), winslash, mustWork): path[1]="C:\Users\Shiro\AppData\Local\Temp\RtmpczczET/airskill_example": 指定されたファイルが見つかりません。
airskill(project_dir, skills = "m11_semantic")
#> Error in normalizePath(path.expand(path), winslash, mustWork): path[1]="C:\Users\Shiro\AppData\Local\Temp\RtmpczczET/airskill_example": 指定されたファイルが見つかりません。
```
