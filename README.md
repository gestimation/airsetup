# airsetup

`airsetup` is a lightweight workflow infrastructure package for the gestimation AI & R Toolkit.
It is not a statistical analysis package.

> Structure the data flow. Stop errors from flowing downstream.
>
> データの流れを整え、エラーを下流へ流さない。まずはプロジェクトフォルダから始めよう。

`airsetup` creates controlled project folders, `AGENTS.md` instructions, compact specification templates,
Checkpoint QC templates, Software Inventory templates, traceability logs, and project structure checks for
AI-assisted statistical analysis workflows in R.

## Minimal example

```r
library(airsetup)

project <- tempfile("analysis_project_")
create_agentic_project(project)

check_agentic_project(project)
```

The generated workflow is organized into three phases:

- **Preflight**: C01--C02, upstream preparation, data review, variable specification, and derivation.
- **Flight**: C03--C04, descriptive review, population flow review, and statistical analysis execution.
- **Landing**: C05--C06, TLF generation, document generation, final output review, and consistency review.

Checkpoint QC requires a checkpoint decision (`pass`, `fail`, or `conditional_pass`) before downstream work proceeds.
AI may prepare evidence, but AI must not independently approve checkpoints requiring statistical or scientific judgment.
