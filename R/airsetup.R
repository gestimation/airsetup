#' airsetup: project setup for AI-assisted R workflows
#'
#' Lightweight workflow infrastructure for creating controlled project
#' structures, AI-visible data routes, templates, traceability logs, and Checkpoint QC materials.
#'
#' @keywords internal
"_PACKAGE"

required_dirs <- function() {
  c(
    "01_study_documentation_package", "01_study_documentation_package/source",
    "01_study_documentation_package/reviewed", "01_study_documentation_package/archive",
    "02_estimand_specification_package", "02_estimand_specification_package/template",
    "02_estimand_specification_package/pre_data_review", "02_estimand_specification_package/post_data_review",
    "02_estimand_specification_package/archive",
    "03_statistical_analysis_package", "03_statistical_analysis_package/template",
    "03_statistical_analysis_package/pre_data_review", "03_statistical_analysis_package/post_data_review",
    "03_statistical_analysis_package/archive",
    "04_ai_context_package", "04_ai_context_package/template", "04_ai_context_package/active",
    "04_ai_context_package/archive",
    "ai_visible_data", "ai_visible_data/input", "ai_visible_data/lookup", "ai_visible_data/metadata",
    "05_qc_package", "05_qc_package/template", "05_qc_package/pre_data_review",
    "05_qc_package/post_data_review", "05_qc_package/results", "05_qc_package/archive",
    "06_analysis_execution", "06_analysis_execution/programs",
    "06_analysis_execution/outputs", "06_analysis_execution/work_products",
    "07_traceability_log",
    "08_deliverables", "08_deliverables/final_specifications", "08_deliverables/final_outputs",
    "08_deliverables/final_reports", "08_deliverables/qc_report"
  )
}

traceability_files <- function() {
  file.path("07_traceability_log", c(
    "prompt_log.csv", "ai_output_log.csv", "decision_log.csv", "change_log.csv",
    "issue_log.csv", "software_use_log.csv", "data_review_log.csv",
    "specification_change_log.csv", "checkpoint_decision_log.csv", "qc_discrepancy_log.csv"
  ))
}

template_files <- function() {
  c(
    "02_estimand_specification_package/template/estimand_specification_template.md",
    "02_estimand_specification_package/template/endpoint_definition_template.md",
    "02_estimand_specification_package/template/population_definition_template.md",
    "02_estimand_specification_package/template/censoring_rule_template.md",
    "03_statistical_analysis_package/template/analysis_plan_template.md",
    "03_statistical_analysis_package/template/analysis_variable_spec_template.csv",
    "03_statistical_analysis_package/template/table_shell_spec_template.csv",
    "03_statistical_analysis_package/template/analysis_task_order_template.md",
    "03_statistical_analysis_package/template/software_inventory_template.csv",
    "04_ai_context_package/template/file_operation_rules_template.md",
    "04_ai_context_package/template/web_research_policy_template.md",
    "04_ai_context_package/template/software_use_policy_template.md",
    "05_qc_package/template/qc_plan_template.md",
    "05_qc_package/template/qc_checklist_template.csv",
    "05_qc_package/template/discrepancy_log_template.csv",
    "05_qc_package/template/qc_report_template.md",
    "05_qc_package/template/checkpoint_qc_plan_template.md",
    "05_qc_package/template/checkpoint_definition_template.csv",
    "05_qc_package/template/checkpoint_checklist_template.csv",
    "05_qc_package/template/checkpoint_decision_log_template.csv",
    "05_qc_package/template/checkpoint_discrepancy_log_template.csv"
  )
}

required_files <- function() c("AGENTS.md", template_files(), active_files(), ai_visible_data_files(), traceability_files())

active_files <- function() {
  file.path("04_ai_context_package", "active", c("active_task.md", "execution_contract.md", "data_contract.md"))
}

ai_visible_data_files <- function() {
  file.path("ai_visible_data", "metadata", c("data_contract.md", "data_manifest.csv"))
}

write_if_allowed <- function(path, lines, overwrite = FALSE) {
  if (file.exists(path) && !overwrite) return(FALSE)
  dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)
  writeLines(lines, path, useBytes = TRUE)
  TRUE
}

write_csv_if_allowed <- function(path, data, overwrite = FALSE) {
  if (file.exists(path) && !overwrite) return(FALSE)
  dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)
  utils::write.csv(data, path, row.names = FALSE, na = "")
  TRUE
}

#' Create an AI-assisted statistical analysis project structure
#'
#' @param path Project directory to create or update.
#' @param mode Project layout mode: `"split"` creates sibling `ai_project` and `r_project` folders; `"ai_only"` creates only `ai_project`.
#' @param template Template name. Currently only `"clinical_trial"` is used.
#' @param overwrite Logical. If `TRUE`, overwrite generated files that already exist.
#'
#' @return Invisibly returns the normalized project path.
#' @export
create_agentic_project <- function(path, mode = c("split", "ai_only"), template = "clinical_trial", overwrite = FALSE) {
  if (!nzchar(path)) stop("`path` must be a non-empty string.", call. = FALSE)
  mode <- match.arg(mode)
  dir.create(path, recursive = TRUE, showWarnings = FALSE)

  ai_path <- file.path(path, "ai_project")
  create_ai_project_structure(ai_path, template = template, overwrite = overwrite)

  if (identical(mode, "split")) {
    create_r_project_scaffold(file.path(path, "r_project"), overwrite = overwrite)
  }

  invisible(normalizePath(path, winslash = "/", mustWork = TRUE))
}

create_ai_project_structure <- function(path, template = "clinical_trial", overwrite = FALSE) {
  dir.create(path, recursive = TRUE, showWarnings = FALSE)
  for (dir in required_dirs()) dir.create(file.path(path, dir), recursive = TRUE, showWarnings = FALSE)
  create_agents_md(path, template = template, overwrite = overwrite)
  create_readmes(path, overwrite = overwrite)
  create_templates(path, overwrite = overwrite)
  invisible(normalizePath(path, winslash = "/", mustWork = TRUE))
}

create_r_project_scaffold <- function(path, overwrite = FALSE) {
  dir.create(path, recursive = TRUE, showWarnings = FALSE)
  for (dir in c("ai_hidden_data", "ai_hidden_data/input", "ai_hidden_data/lookup", "ai_hidden_data/metadata", "programs", "logs")) {
    dir.create(file.path(path, dir), recursive = TRUE, showWarnings = FALSE)
  }

  write_if_allowed(file.path(path, ".gitignore"), c(
    "ai_hidden_data/", "*.rds", "*.RData", "*.csv", "*.sas7bdat", "*.xlsx"
  ), overwrite = overwrite)

  write_if_allowed(file.path(path, "README_DO_NOT_SHARE_WITH_AI.md"), c(
    "# Do not share this folder with AI", "",
    "This folder is intended for local human execution only.",
    "This folder may contain real data or paths to real data under `ai_hidden_data/`.",
    "This folder should not be exposed to AI agents.",
    "AI-generated code should generally be stored in `../ai_project/06_analysis_execution/programs/`.",
    "Human users may run AI-generated code from this r_project by setting `data_dir` to `ai_hidden_data/`.",
    "Outputs from execution should generally be written back to `../ai_project/06_analysis_execution/outputs/` or `../ai_project/05_qc_package/results/`.",
    "Users may customize this folder structure as needed.",
    "Git or GitHub is not required."
  ), overwrite = overwrite)

  write_if_allowed(file.path(path, "ai_hidden_data", "README_DO_NOT_COMMIT.md"), c(
    "# Do not commit real data", "",
    "Place real data or local-only data links here if appropriate.",
    "Mirror the internal folder structure, file names, and column names used under `../ai_project/ai_visible_data/` whenever possible.",
    "Do not expose files in this folder to AI agents.",
    "Do not commit or share real data.",
    "The folder is ignored by the default `.gitignore`."
  ), overwrite = overwrite)

  write_if_allowed(file.path(path, "programs", "run_analysis_template.R"), c(
    "# Run analysis template",
    "# Execute this script from the AI-hidden r_project.",
    "# Real data should remain under r_project/ai_hidden_data and should not be exposed to AI agents.",
    "# Outputs should generally be written back to the sibling ai_project.",
    "",
    "ai_project_dir <- normalizePath(file.path(\"..\", \"ai_project\"), winslash = \"/\", mustWork = TRUE)",
    "",
    "data_dir <- normalizePath(file.path(\"ai_hidden_data\"), winslash = \"/\", mustWork = TRUE)",
    "",
    "output_dir <- file.path(ai_project_dir, \"06_analysis_execution\", \"outputs\")",
    "qc_dir <- file.path(ai_project_dir, \"05_qc_package\", \"results\")",
    "log_dir <- file.path(\"logs\")",
    "",
    "# AI-written scripts under ../ai_project/06_analysis_execution/programs/",
    "# should use ai_project_dir, data_dir, output_dir, and qc_dir.",
    "# They must not assume that getwd() is ai_project.",
    "",
    "# Example:",
    "# source(file.path(ai_project_dir, \"06_analysis_execution\", \"programs\", \"01_derive_participant_flow_counts.R\"))",
    "# source(file.path(ai_project_dir, \"06_analysis_execution\", \"programs\", \"02_check_participant_flow_counts.R\"))"
  ), overwrite = overwrite)

  invisible(normalizePath(path, winslash = "/", mustWork = TRUE))
}

#' Create project AGENTS.md instructions
#'
#' @param path Project directory.
#' @param template Template name. Currently only `"clinical_trial"` is used.
#' @param overwrite Logical. If `TRUE`, overwrite an existing `AGENTS.md`.
#'
#' @return Invisibly returns the `AGENTS.md` path.
#' @description Create AGENTS.md guidance for the default Codex workflow, mirrored data layout, R execution boundary, folder lifecycle, Checkpoint QC, software inventory, traceability, and deliverables.
#' @export
create_agents_md <- function(path, template = "clinical_trial", overwrite = FALSE) {
  dir.create(path, recursive = TRUE, showWarnings = FALSE)
  agents <- c(
    "# AGENTS.md", "", "Structure the data flow. Stop errors from flowing downstream.",
    "データの流れを整え、エラーを下流へ流さない。まずはプロジェクトフォルダから始めよう。", "",

    "## Default Codex workflow",
    "When working in this ai_project, follow this default route unless the active task explicitly says otherwise:", "",
    "1. Read `AGENTS.md`.",
    "2. Read `04_ai_context_package/active/active_task.md`.",
    "3. Read data only from `ai_visible_data/`.",
    "4. Write R scripts only to `06_analysis_execution/programs/`.",
    "5. Write analysis outputs only to `06_analysis_execution/outputs/`.",
    "6. Write QC evidence only to `05_qc_package/results/`.",
    "7. Record issues or assumptions in the appropriate QC or traceability files when instructed.",
    "8. Do not use other folders unless the active task explicitly says so.",
    "9. Do not access, request, infer, or assume access to `r_project` or real data.",
    "10. Do not make checkpoint decisions. Prepare evidence for human review.", "",

    "## Mirrored data layout contract",
    "- `ai_project/ai_visible_data/` contains AI-visible dummy, synthetic, or anonymized data only.",
    "- `r_project/ai_hidden_data/`, if it exists, contains AI-hidden real data or local real-data links.",
    "- The internal folder structure and file names under `ai_visible_data/` and `ai_hidden_data/` should match whenever possible.",
    "- AI-written R code should be developed against `ai_visible_data/`.",
    "- Human users should be able to run the same code against `ai_hidden_data/` by changing only a `data_dir` object.",
    "- Do not write R code that depends on dummy-specific file names unless those same file names are expected under `ai_hidden_data/`.",
    "- Do not place real data in `ai_project/ai_visible_data/`.",
    "- Do not request access to `r_project/ai_hidden_data/`.",
    "- Do not output row-level real-data records, subject IDs, or sensitive listings back into `ai_project`.", "",

    "## AI-visible and AI-hidden project separation",
    "- This ai_project is the only folder intended to be visible to AI agents.",
    "- Do not request, inspect, or assume access to files outside ai_project.",
    "- The sibling r_project, if it exists, is an AI-hidden local execution environment for real data.",
    "- AI agents may write R code intended to be executed from r_project, but must not read, request, infer, or simulate access to real data.",
    "- Real data should remain outside ai_project.",
    "- Dummy, synthetic, or anonymized data for AI-assisted code development should be placed under ai_visible_data/.",
    "- R programs written by AI agents should be placed under 06_analysis_execution/programs/.",
    "- Outputs generated from AI-visible data may be placed under 06_analysis_execution/outputs/.",
    "- QC results generated from AI-visible data may be placed under 05_qc_package/results/.",
    "- Final real-data execution and checkpoint decisions require human review.",
    "- Git or GitHub is not required. These folders should work as ordinary local folders.", "",

    "## R execution boundary contract",
    "R programs stored under `06_analysis_execution/programs/` are developed in the AI-visible `ai_project`, but they may be executed later from an AI-hidden sibling or external `r_project`.", "",
    "Therefore, R programs must not assume that the current working directory is `ai_project`.", "",
    "When writing R scripts:", "",
    "- Use an `ai_project_dir` object when it already exists in the execution environment.",
    "- If `ai_project_dir` does not exist, default it to the current working directory only for interactive AI-side execution from `ai_project`.",
    "- Use a configurable `data_dir` object for input data.",
    "- During AI-side development, `data_dir` should point to `file.path(ai_project_dir, \"ai_visible_data\")`.",
    "- During human-side real-data execution, `data_dir` should point to `r_project/ai_hidden_data`.",
    "- Build paths with `file.path()`.",
    "- Do not use absolute local paths.",
    "- Do not hard-code `ai_visible_data` as the only possible data root unless the script is explicitly AI-development-only.",
    "- Write code so that it can be sourced from `r_project/programs/run_analysis_template.R`.",
    "- Write outputs to `06_analysis_execution/outputs/`.",
    "- Write QC results to `05_qc_package/results/`.",
    "- Do not access files outside `ai_project` except through user-defined path objects during human-side execution.", "",
    "Use this path pattern in AI-written R scripts:", "", "```r",
    "if (!exists(\"ai_project_dir\", inherits = TRUE)) {",
    "  ai_project_dir <- normalizePath(\".\", winslash = \"/\", mustWork = FALSE)",
    "}", "",
    "if (!file.exists(file.path(ai_project_dir, \"AGENTS.md\")) ||",
    "    !dir.exists(file.path(ai_project_dir, \"06_analysis_execution\"))) {",
    "  stop(",
    "    \"`ai_project_dir` does not appear to point to an airsetup ai_project. \",",
    "    \"Run this script from ai_project or define ai_project_dir before sourcing it.\",",
    "    call. = FALSE",
    "  )",
    "}", "",
    "if (!exists(\"data_dir\", inherits = TRUE)) {",
    "  data_dir <- file.path(ai_project_dir, \"ai_visible_data\")",
    "}", "",
    "if (!exists(\"output_dir\", inherits = TRUE)) {",
    "  output_dir <- file.path(ai_project_dir, \"06_analysis_execution\", \"outputs\")",
    "}", "",
    "if (!exists(\"qc_dir\", inherits = TRUE)) {",
    "  qc_dir <- file.path(ai_project_dir, \"05_qc_package\", \"results\")",
    "}", "```", "",

    "## Package folder lifecycle",
    "- Package folders manage templates, pre-data-review specifications, post-data-review specifications, and archived versions.",
    "- template/ contains reusable toolkit templates.",
    "- pre_data_review/ contains specifications drafted from protocol, SAP, CRF, mock TLFs, data dictionary, and other study documents before detailed data review.",
    "- post_data_review/ contains specifications updated after reviewing actual dataset structure, variable availability, coding, missingness, and derivation feasibility.",
    "- Do not use pre_data_review specifications for final analysis when corresponding post_data_review specifications exist.",
    "- Draft work products created during data review belong in 06_analysis_execution/work_products.",
    "- Analysis programs and generated outputs belong in 06_analysis_execution.",
    "- Logs belong in 07_traceability_log.", "- Reviewed final materials belong in 08_deliverables.",
    "- Substantial specification changes must be recorded in 07_traceability_log/specification_change_log.csv.",
    "- Do not overwrite raw data or source documents.", "- Do not treat AI-generated code or outputs as validated.",
    "- Use QC materials in 05_qc_package and record unresolved issues.", "",
    "## Workflow phases", "- Organize the workflow into Preflight, Flight, and Landing phases.",
    "- Preflight includes data review and variable derivation. It is intentionally substantial because upstream errors can propagate into downstream analyses and outputs.",
    "- Flight includes descriptive review, population flow review, and statistical analysis execution.",
    "- Landing includes TLF generation, document generation, final output review, and output consistency review.", "",
    "## Checkpoint QC", "- Use Checkpoint QC. Do not proceed to downstream analysis steps until the current checkpoint has been checked and assigned a checkpoint decision.",
    "- The checkpoint is mandatory, but the checkpoint opener depends on opener_type.",
    "- Checkpoint decisions include pass, fail, and conditional_pass.",
    "- For human_checkpoint, a human reviewer must make the checkpoint decision.",
    "- For ai_assisted_human_checkpoint, AI may prepare evidence and discrepancy summaries, but a human reviewer must make the checkpoint decision.",
    "- For automated_checkpoint, a predefined mechanical rule may make the checkpoint decision.",
    "- AI must not independently approve checkpoints that require statistical interpretation, endpoint definition, population definition, variable derivation rules, model specification, or final scientific interpretation.", "",
    "## Software inventory", "- Use the Software Inventory when writing or reviewing R code.",
    "- Prefer approved functions for the relevant task.", "- Do not use prohibited functions.",
    "- Restricted functions require human approval and additional QC.",
    "- If an unlisted package or function is used, record the reason in software_use_log.csv and treat it as under_review until approved.", "",
    "## Agent operating rules",
    "- Before starting any task, identify the current workflow phase: Preflight, Flight, or Landing.",
    "- Before editing files, inspect the active task, relevant package folder, active specifications, and applicable QC templates.",
    "- Do not infer missing endpoint definitions, population definitions, variable derivation rules, or model specifications without recording the uncertainty.",
    "- If a task requires statistical judgment, prepare evidence and proposed issues, but do not make the checkpoint decision.",
    "- If a required specification is missing, outdated, or inconsistent with the data, stop the affected downstream work and record the issue.",
    "- If working code is generated, place draft code in 06_analysis_execution/programs unless the user explicitly instructs otherwise.",
    "- If exploratory outputs or intermediate work products are generated, place them in 06_analysis_execution/work_products or 06_analysis_execution/outputs according to their role.",
    "- If a package or function is not listed in the Software Inventory, do not silently use it as approved. Record it in software_use_log.csv and treat it as under_review.",
    "- When completing a task, summarize files read, files created or modified, assumptions made, unresolved issues, checkpoint implications, and recommended next action.", "",
    "## Discrepancies",
    "- A conditional_pass may be used only when unresolved issues are explicitly recorded and downstream steps allowed under the conditional pass are specified."
  )
  out <- file.path(path, "AGENTS.md")
  write_if_allowed(out, agents, overwrite = overwrite)
  invisible(out)
}

create_readmes <- function(path, overwrite = FALSE) {
  majors <- c("01_study_documentation_package", "02_estimand_specification_package", "03_statistical_analysis_package", "04_ai_context_package", "05_qc_package", "06_analysis_execution", "07_traceability_log", "08_deliverables")
  for (folder in majors) write_if_allowed(file.path(path, folder, "README.md"), c(paste0("# ", folder), "", "Generated by airsetup."), overwrite)
}

create_templates <- function(path, overwrite = FALSE) {
  for (f in setdiff(template_files(), c("03_statistical_analysis_package/template/software_inventory_template.csv", "05_qc_package/template/checkpoint_definition_template.csv", "05_qc_package/template/checkpoint_checklist_template.csv", "05_qc_package/template/checkpoint_decision_log_template.csv", "05_qc_package/template/checkpoint_discrepancy_log_template.csv"))) {
    if (grepl("\\.csv$", f)) write_csv_if_allowed(file.path(path, f), data.frame(item=character(), description=character(), notes=character()), overwrite) else write_if_allowed(file.path(path, f), c("# Template", "", "Minimal extensible template generated by airsetup."), overwrite)
  }
  write_csv_if_allowed(file.path(path, "03_statistical_analysis_package/template/software_inventory_template.csv"), software_inventory_data(), overwrite)
  write_csv_if_allowed(file.path(path, "05_qc_package/template/checkpoint_definition_template.csv"), checkpoint_definition_data(), overwrite)
  write_csv_if_allowed(file.path(path, "05_qc_package/template/checkpoint_checklist_template.csv"), data.frame(phase=character(), checkpoint_id=character(), check_item_id=character(), check_item_name=character(), description=character(), check_type=character(), expected_evidence=character(), result=character(), reviewer=character(), review_date=character(), comment=character()), overwrite)
  write_csv_if_allowed(file.path(path, "05_qc_package/template/checkpoint_decision_log_template.csv"), data.frame(phase=character(), checkpoint_id=character(), checkpoint_name=character(), opener_type=character(), checkpoint_decision=character(), decision_date=character(), decided_by=character(), evidence_reviewed=character(), unresolved_issues=character(), downstream_steps_allowed=character(), comment=character()), overwrite)
  write_csv_if_allowed(file.path(path, "05_qc_package/template/checkpoint_discrepancy_log_template.csv"), data.frame(discrepancy_id=character(), phase=character(), checkpoint_id=character(), detected_at=character(), description=character(), severity=character(), affected_files=character(), affected_downstream_steps=character(), resolution=character(), resolved_by=character(), resolved_at=character(), comment=character()), overwrite)
  write_if_allowed(file.path(path, "ai_visible_data", "metadata", "data_contract.md"), c(
    "# Data contract", "",
    "This folder contains AI-visible dummy, synthetic, or anonymized data only.", "",
    "Mirror the internal folder structure, file names, and column names used by `r_project/ai_hidden_data/` whenever possible.",
    "Never place real data in `ai_project/ai_visible_data/`."
  ), overwrite)
  write_csv_if_allowed(file.path(path, "ai_visible_data", "metadata", "data_manifest.csv"), data.frame(path=character(), data_type=character(), description=character(), source=character(), notes=character()), overwrite)

  write_if_allowed(file.path(path, "04_ai_context_package", "active", "active_task.md"), c(
    "# Active task", "",
    "Describe the current task here before asking an AI agent to work.", "",
    "## Task goal", "", "To be completed by the user.", "",
    "## Files the AI agent should read", "", "To be completed by the user.", "",
    "## Data available to the AI agent", "", "Use only files under:", "", "* `ai_visible_data/`", "",
    "## Files the AI agent may create or modify", "", "Usually:", "", "* `06_analysis_execution/programs/`", "* `06_analysis_execution/outputs/`", "* `05_qc_package/results/`", "",
    "## Files the AI agent must not modify", "", "Usually:", "", "* `01_study_documentation_package/source/`", "* `08_deliverables/`", "* any files outside `ai_project`", "",
    "## Expected completion summary", "", "The AI agent should summarize:", "", "* files read", "* files created or modified", "* assumptions made", "* unresolved issues", "* QC evidence generated", "* recommended next action for human review"
  ), overwrite)
  write_if_allowed(file.path(path, "04_ai_context_package", "active", "execution_contract.md"), c(
    "# Execution contract", "",
    "AI-written R scripts are developed in `ai_project`, but may be executed later from an AI-hidden `r_project`.", "",
    "Scripts should use:", "", "* `ai_project_dir`", "* `data_dir`", "* `output_dir`", "* `qc_dir`", "",
    "Do not assume that `getwd()` is `ai_project`.", "",
    "During AI-side development:", "", "```r", "data_dir <- file.path(ai_project_dir, \"ai_visible_data\")", "```", "",
    "During human-side real-data execution from r_project:", "", "```r", "data_dir <- file.path(\"ai_hidden_data\")", "```", "",
    "Outputs and QC results should generally be written back to the sibling `ai_project`."
  ), overwrite)
  write_if_allowed(file.path(path, "04_ai_context_package", "active", "data_contract.md"), c(
    "# Data contract", "",
    "The AI-visible and AI-hidden data folders should mirror each other.", "",
    "AI-visible dummy data:", "", "* `ai_project/ai_visible_data/input/`", "* `ai_project/ai_visible_data/lookup/`", "* `ai_project/ai_visible_data/metadata/`", "",
    "AI-hidden real data:", "", "* `r_project/ai_hidden_data/input/`", "* `r_project/ai_hidden_data/lookup/`", "* `r_project/ai_hidden_data/metadata/`", "",
    "The internal folder structure, file names, and column names should match whenever possible.", "",
    "Never place real data in `ai_project/ai_visible_data/`."
  ), overwrite)
  for (f in traceability_files()) write_csv_if_allowed(file.path(path, f), data.frame(timestamp=character(), item=character(), description=character(), reviewer=character(), comment=character()), overwrite)
}

software_inventory_data <- function() {
  out <- data.frame(
    category = "", task = "", package = "", function_name = "", status = "under_review",
    allowed_use = "", restricted_use = "", qc_requirement = "",
    notes = "Allowed status values: approved; restricted; discouraged; prohibited; under_review",
    stringsAsFactors = FALSE
  )
  names(out)[names(out) == "function_name"] <- "function"
  out
}

checkpoint_definition_data <- function() data.frame(
  phase = c("Preflight", "Preflight", "Flight", "Flight", "Landing", "Landing"),
  checkpoint_id = sprintf("C%02d", 1:6),
  checkpoint_name = c("Requirements and data review", "Variable specification and derivation", "Descriptive review and population flow", "Statistical analysis execution", "TLF generation and output review", "Document generation and consistency review"),
  objective = c("Confirm requirements and data reality before downstream work.", "Confirm variable mappings and derivation rules.", "Confirm descriptive findings and population flow.", "Confirm analysis execution follows approved specifications.", "Confirm TLFs are generated and reviewed consistently.", "Confirm final documents are consistent with approved outputs."),
  required_inputs = "To be completed", expected_outputs = "To be completed", check_items = "To be completed",
  checkpoint_condition = "A checkpoint decision of pass or documented conditional_pass is required before specified downstream steps proceed.",
  opener_type = c("human_checkpoint", "human_checkpoint", "ai_assisted_human_checkpoint", "human_checkpoint", "ai_assisted_human_checkpoint", "human_checkpoint"),
  checkpoint_opener = "To be assigned", reviewer = "To be assigned", approval_required = TRUE, downstream_steps = "To be specified"
)

#' Check an airsetup project structure
#'
#' @param path Project directory to check.
#' @param mode Project layout mode to check.
#'
#' @return A data.frame with columns `item`, `type`, `path`, `exists`, `required`, and `message`.
#' @export
check_agentic_project <- function(path, mode = c("split", "ai_only")) {
  mode <- match.arg(mode)
  ai_items <- file.path("ai_project", c(required_dirs(), required_files()))
  ai_types <- c(rep("folder", length(required_dirs())), rep("file", length(required_files())))

  items <- ai_items
  types <- ai_types

  if (identical(mode, "split")) {
    r_dirs <- file.path("r_project", c("ai_hidden_data", "ai_hidden_data/input", "ai_hidden_data/lookup", "ai_hidden_data/metadata", "programs", "logs"))
    r_files <- file.path("r_project", c("README_DO_NOT_SHARE_WITH_AI.md", ".gitignore", "ai_hidden_data/README_DO_NOT_COMMIT.md", "programs/run_analysis_template.R"))
    items <- c(items, r_dirs, r_files)
    types <- c(types, rep("folder", length(r_dirs)), rep("file", length(r_files)))
  }

  full <- file.path(path, items)
  exists <- ifelse(types == "folder", dir.exists(full), file.exists(full))
  data.frame(item = items, type = types, path = items, exists = exists, required = TRUE, message = ifelse(exists, "Found", "Missing required item"), stringsAsFactors = FALSE)
}
