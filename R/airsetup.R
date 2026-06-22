#' airsetup: project setup for AI-assisted R workflows
#'
#' Lightweight workflow infrastructure for creating controlled project
#' structures, templates, traceability logs, and Checkpoint QC materials.
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
    "05_qc_package", "05_qc_package/template", "05_qc_package/pre_data_review",
    "05_qc_package/post_data_review", "05_qc_package/results", "05_qc_package/archive",
    "06_analysis_execution", "06_analysis_execution/programs", "06_analysis_execution/datasets",
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

required_files <- function() c("AGENTS.md", template_files(), traceability_files())

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
#' @param template Template name. Currently only `"clinical_trial"` is used.
#' @param overwrite Logical. If `TRUE`, overwrite generated files that already exist.
#'
#' @return Invisibly returns the normalized project path.
#' @export
create_agentic_project <- function(path, template = "clinical_trial", overwrite = FALSE) {
  if (!nzchar(path)) stop("`path` must be a non-empty string.", call. = FALSE)
  dir.create(path, recursive = TRUE, showWarnings = FALSE)
  for (dir in required_dirs()) dir.create(file.path(path, dir), recursive = TRUE, showWarnings = FALSE)
  create_agents_md(path, template = template, overwrite = overwrite)
  create_readmes(path, overwrite = overwrite)
  create_templates(path, overwrite = overwrite)
  invisible(normalizePath(path, winslash = "/", mustWork = TRUE))
}

#' Create project AGENTS.md instructions
#'
#' @param path Project directory.
#' @param template Template name. Currently only `"clinical_trial"` is used.
#' @param overwrite Logical. If `TRUE`, overwrite an existing `AGENTS.md`.
#'
#' @return Invisibly returns the `AGENTS.md` path.
#' @export
create_agents_md <- function(path, template = "clinical_trial", overwrite = FALSE) {
  dir.create(path, recursive = TRUE, showWarnings = FALSE)
  agents <- c(
    "# AGENTS.md", "", "Structure the data flow. Stop errors from flowing downstream.",
    "データの流れを整え、エラーを下流へ流さない。まずはプロジェクトフォルダから始めよう。", "",
    "## Package folder lifecycle",
    "- Package folders manage templates, pre-data-review specifications, post-data-review specifications, and archived versions.",
    "- template/ contains reusable toolkit templates.",
    "- pre_data_review/ contains specifications drafted from protocol, SAP, CRF, mock TLFs, data dictionary, and other study documents before detailed data review.",
    "- post_data_review/ contains specifications updated after reviewing actual dataset structure, variable availability, coding, missingness, and derivation feasibility.",
    "- Do not use pre_data_review specifications for final analysis when corresponding post_data_review specifications exist.",
    "- Draft work products created during data review belong in 06_analysis_execution/work_products.",
    "- Analysis programs, derived datasets, and generated outputs belong in 06_analysis_execution.",
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
    "- Before editing files, inspect the relevant package folder, active specifications, and applicable QC templates.",
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
#'
#' @return A data.frame with columns `item`, `type`, `path`, `exists`, `required`, and `message`.
#' @export
check_agentic_project <- function(path) {
  dirs <- required_dirs(); files <- required_files()
  items <- c(dirs, files); types <- c(rep("folder", length(dirs)), rep("file", length(files)))
  full <- file.path(path, items)
  exists <- ifelse(types == "folder", dir.exists(full), file.exists(full))
  data.frame(item = basename(items), type = types, path = items, exists = exists, required = TRUE, message = ifelse(exists, "Found", "Missing required item"), stringsAsFactors = FALSE)
}
