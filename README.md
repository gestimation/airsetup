# airsetup

`airsetup` is a lightweight workflow infrastructure package for the gestimation AI & R Toolkit.
It is not a statistical analysis package.

> Structure the data flow. Stop errors from flowing downstream.
>
> データの流れを整え、エラーを下流へ流さない。まずはプロジェクトフォルダから始めよう。

`airsetup` creates controlled project folders, `AGENTS.md` instructions, compact specification templates,
Checkpoint QC templates, Software Inventory templates, traceability logs, and project structure checks for
AI-assisted statistical analysis workflows in R.

## AI-visible and AI-hidden project separation

`airsetup` separates the AI-visible workflow project from the AI-hidden local R execution project.

In split mode, `airsetup` creates:

```text
root/
  ai_project/
  r_project/
```

The `ai_project` is intended for AI agents. It contains context, specifications, dummy data, R code under
development, QC materials, logs, and deliverables.

The `r_project` is intended for secure local real-data execution by humans. It should not be exposed to AI
agents. It is intentionally minimal and customizable.

In `ai_only` mode, `airsetup` creates only:

```text
root/
  ai_project/
```

This is useful when the real-data R project is created manually in a separate secure location.

Git or GitHub is not required. The generated folders work as local folders. If Git is used, sensitive data
folders should be excluded from version control.

## Minimal examples

```r
library(airsetup)

create_agentic_project("kd_flow", mode = "split")
check_agentic_project("kd_flow", mode = "split")

create_agentic_project("kd_flow_ai", mode = "ai_only")
check_agentic_project("kd_flow_ai", mode = "ai_only")
```

The generated workflow is organized into three phases:

- **Preflight**: C01--C02, upstream preparation, data review, variable specification, and derivation.
- **Flight**: C03--C04, descriptive review, population flow review, and statistical analysis execution.
- **Landing**: C05--C06, TLF generation, document generation, final output review, and consistency review.

Checkpoint QC requires a checkpoint decision (`pass`, `fail`, or `conditional_pass`) before downstream work proceeds.
AI may prepare evidence, but AI must not independently approve checkpoints requiring statistical or scientific judgment.
