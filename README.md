# airsetup

`airsetup` is a lightweight workflow infrastructure package for the gestimation AI & R Toolkit.
It is not a statistical analysis package and it does not require Git or GitHub.

> Structure the data flow. Stop errors from flowing downstream.
>
> データの流れを整え、エラーを下流へ流さない。まずはプロジェクトフォルダから始めよう。

`airsetup` creates controlled project folders, `AGENTS.md` instructions, compact specification templates,
Checkpoint QC templates, Software Inventory templates, traceability logs, and project structure checks for
AI-assisted statistical analysis workflows in R.

## AI-visible and AI-hidden project separation

`airsetup` creates an AI-visible project and, in split mode, an optional AI-hidden R execution scaffold.
The split keeps the package-oriented audit structure for humans while giving Codex and other AI agents a
simple default route for coding tasks.

In split mode, `airsetup` creates:

```text
root/
  ai_project/
  r_project/
```

The `ai_project` is intended for AI agents. It contains the 01--08 audit packages, active task context,
AI-visible data, R code under development, QC materials, logs, and deliverables. AI-visible dummy,
synthetic, or anonymized data live under:

```text
ai_project/ai_visible_data/
  input/
  lookup/
  metadata/
```

The `r_project` is intended for secure local real-data execution by humans. It should not be exposed to AI
agents. AI-hidden real data or local real-data links live under:

```text
r_project/ai_hidden_data/
  input/
  lookup/
  metadata/
```

The internal layouts of `ai_visible_data/` and `ai_hidden_data/` should mirror each other whenever possible,
including relative paths, file names, and column names. File contents differ: `ai_visible_data/` contains only
AI-visible dummy, synthetic, or anonymized data, while `ai_hidden_data/` contains real data or local-only real-data
links.

In `ai_only` mode, `airsetup` creates only:

```text
root/
  ai_project/
```

This is useful when the real-data R project is created manually in a separate secure location. There is no
`flat` mode.

## Default AI-agent workflow

Generated `ai_project/AGENTS.md` instructs agents to:

1. Read `AGENTS.md`.
2. Read `04_ai_context_package/active/active_task.md`.
3. Read data only from `ai_visible_data/`.
4. Write R scripts only to `06_analysis_execution/programs/`.
5. Write analysis outputs only to `06_analysis_execution/outputs/`.
6. Write QC evidence only to `05_qc_package/results/`.
7. Avoid all other folders unless the active task explicitly says otherwise.
8. Never request or infer access to `r_project` or real data.
9. Prepare evidence for human checkpoint review rather than making checkpoint decisions.

AI-generated R code should use a configurable `data_dir`. During AI-side development, `data_dir` should point
to `file.path(ai_project_dir, "ai_visible_data")`. Human users can run the same code on real data by setting
`data_dir` to `r_project/ai_hidden_data` or another secure real-data location. Outputs and QC evidence should
generally be written back to the sibling `ai_project` under `06_analysis_execution/outputs/` and
`05_qc_package/results/`.

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
