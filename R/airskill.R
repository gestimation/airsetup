#' Add AI & R QC skill templates
#'
#' `airskill()` adds lightweight QC skill Markdown files to an existing
#' airsetup project. The files are written under `ai_project/source/skills/`.
#'
#' @param path Project root created by [airsetup()].
#' @param skills Character vector of skills to add. Supported values are
#'   `"context"`, `"plan"`, and `"result"`.
#' @param overwrite Logical. If `FALSE`, existing files are not overwritten.
#' @param quiet Logical. If `TRUE`, suppress messages.
#'
#' @return A data frame with columns `file`, `path`, `status`, and
#'   `overwritten`.
#' @export
#'
#' @examples
#' project_dir <- file.path(tempdir(), "airskill_example")
#' airsetup(project_dir, mode = "ai_only")
#' airskill(project_dir)
#' airskill(project_dir, skills = c("context", "plan"))
airskill <- function(path = ".",
                     skills = c("context", "plan", "result"),
                     overwrite = FALSE,
                     quiet = FALSE) {
  if (!is.character(path) || length(path) != 1L || !nzchar(path)) {
    stop("`path` must be a non-empty string.", call. = FALSE)
  }
  if (!is.logical(overwrite) || length(overwrite) != 1L || is.na(overwrite)) {
    stop("`overwrite` must be TRUE or FALSE.", call. = FALSE)
  }
  if (!is.logical(quiet) || length(quiet) != 1L || is.na(quiet)) {
    stop("`quiet` must be TRUE or FALSE.", call. = FALSE)
  }

  skills <- validate_airskill_skills(skills)

  project_root <- normalizePath(path, winslash = "/", mustWork = TRUE)
  ai_project <- file.path(project_root, "ai_project")
  if (!dir.exists(ai_project)) {
    stop(
      "`path` must be an airsetup project root containing `ai_project/`.",
      call. = FALSE
    )
  }

  skills_dir <- file.path(ai_project, "source", "skills")
  dir.create(skills_dir, recursive = TRUE, showWarnings = FALSE)

  specs <- airskill_file_specs(skills)
  results <- lapply(specs, function(spec) {
    out <- file.path(skills_dir, spec$file)
    existed <- file.exists(out)
    written <- write_if_allowed(out, spec$template(), overwrite = overwrite)

    status <- if (written && existed) {
      "overwritten"
    } else if (written) {
      "created"
    } else {
      "skipped"
    }

    if (!quiet) {
      message(sprintf("%s: %s", status, file.path("ai_project", "source", "skills", spec$file)))
    }

    data.frame(
      file = spec$file,
      path = file.path("ai_project", "source", "skills", spec$file),
      status = status,
      overwritten = isTRUE(written && existed),
      stringsAsFactors = FALSE
    )
  })

  out <- do.call(rbind, results)
  rownames(out) <- NULL
  out
}

validate_airskill_skills <- function(skills) {
  supported <- c("context", "plan", "result")

  if (!is.character(skills) || length(skills) < 1L || any(!nzchar(skills))) {
    stop(
      "`skills` must be a non-empty character vector containing one or more of: ",
      paste(supported, collapse = ", "),
      ".",
      call. = FALSE
    )
  }

  skills <- unique(tolower(skills))
  invalid <- setdiff(skills, supported)
  if (length(invalid) > 0L) {
    stop(
      "Unsupported skill value: ",
      paste(invalid, collapse = ", "),
      ". Supported values are: ",
      paste(supported, collapse = ", "),
      ".",
      call. = FALSE
    )
  }

  skills
}

airskill_file_specs <- function(skills) {
  skill_specs <- list(
    context = list(file = "CONTEXT-QC-SKILL.md", template = context_qc_skill_template),
    plan = list(file = "PLAN-QC-SKILL.md", template = plan_qc_skill_template),
    result = list(file = "RESULT-QC-SKILL.md", template = result_qc_skill_template)
  )

  c(
    list(list(file = "SKILLS_INDEX.md", template = skills_index_template)),
    unname(skill_specs[skills])
  )
}

skills_index_template <- function() {
  c(
    "# AI & R Skills Index",
    "",
    "This directory contains lightweight QC skills for the AI & R workflow.",
    "",
    "Use these skills selectively. Do not load all skill files unless needed.",
    "",
    "## Available skills",
    "",
    "### CONTEXT-QC-SKILL.md",
    "",
    "Use before drafting an analysis plan or generating R code.",
    "",
    "Purpose:",
    "",
    "- Check whether the supplied analysis context is clear enough.",
    "- Identify missing information.",
    "- Identify AI assumption risks.",
    "- Decide what AI can safely do next.",
    "",
    "Typical output location:",
    "",
    "- `ai_project/qc/context-qc-001.md`",
    "",
    "### PLAN-QC-SKILL.md",
    "",
    "Use before generating R code from a SAP or analysis plan.",
    "",
    "Purpose:",
    "",
    "- Check whether the plan is clear enough for R implementation.",
    "- Identify non-implementable or ambiguous plan items.",
    "- Identify AI assumption risks.",
    "- Decide whether R script generation can proceed.",
    "",
    "Typical output location:",
    "",
    "- `ai_project/qc/plan-qc-001.md`",
    "",
    "### RESULT-QC-SKILL.md",
    "",
    "Use after R outputs are available and before report writing.",
    "",
    "Purpose:",
    "",
    "- Check visible consistency of analysis results.",
    "- Check planned-output alignment when a plan is available.",
    "- Check interpretation safety.",
    "- Identify traceability gaps and AI assumption risks.",
    "",
    "Typical output location:",
    "",
    "- `ai_project/qc/result-qc-001.md`",
    "",
    "## Workflow guidance",
    "",
    "Recommended quick workflow:",
    "",
    "1. Context QC",
    "2. Plan drafting or revision",
    "3. Plan QC",
    "4. R script generation",
    "5. R script QC, if available",
    "6. Local R execution",
    "7. Result QC",
    "8. Human review or report writing",
    "",
    "Write QC reports to `ai_project/qc/`.",
    "",
    "Carry unresolved issues forward to `QC_STATUS.md`.",
    "",
    "A `Pass` from a quick QC skill does not mean formal statistical approval.",
    "",
    "## Agent instruction",
    "",
    "When a skill is used, read the relevant skill file, produce the requested QC",
    "report, save the report under `ai_project/qc/`, and update `QC_STATUS.md`",
    "when unresolved issues, decisions, or handoff actions need to be tracked."
  )
}

common_qc_report_template <- function(skill_name, workflow_stage, domains, next_steps) {
  c(
    "## Required output format",
    "",
    "Always use this compact format.",
    "",
    "```markdown",
    "# AI & R QC Report",
    "",
    "## 1. Skill information",
    "",
    paste0("- Skill name: ", skill_name),
    "- Skill version:",
    "- Review target:",
    paste0("- Workflow stage: ", workflow_stage),
    "- Review date:",
    "- Reviewer:",
    "",
    "## 2. Overall judgment",
    "",
    "Judgment: Pass / Conditional pass / Revision required / Fail / Cannot assess",
    "",
    "Readiness category: Ready / Mostly ready / Partially ready / Not ready / Cannot proceed",
    "",
    "Brief rationale:",
    "- ...",
    "",
    "## 3. Readiness by next step",
    "",
    "| Next step | Readiness | Reason |",
    "|---|---|---|",
    paste0("| ", next_steps, " | Ready / Mostly ready / Partially ready / Not ready / Cannot assess / Not applicable | ... |"),
    "",
    "Include only relevant next steps. Omit clearly irrelevant steps.",
    "",
    "## 4. Materials reviewed",
    "",
    "| Material | Status | Notes |",
    "|---|---|---|",
    "| Task materials | Provided / Partially provided / Not provided / Not applicable | ... |",
    "| Dataset or variable information | Provided / Partially provided / Not provided / Not applicable | ... |",
    "| Plan, code, result, or prior QC | Provided / Partially provided / Not provided / Not applicable | ... |",
    "",
    "## 5. Domain assessment",
    "",
    "| Domain | Status | Assessment |",
    "|---|---|---|",
    paste0("| ", domains, " | OK / Needs clarification / Problem / Cannot assess / Not applicable | ... |"),
    "",
    "## 6. Issues",
    "",
    "| ID | Severity | Issue | Evidence | Recommended action |",
    "|---|---|---|---|---|",
    "| C-001 / M-001 / m-001 / N-001 | Critical / Major / Minor / Note | ... | ... | ... |",
    "",
    "If none:",
    "No issues were identified from the provided materials.",
    "",
    "## 7. Cannot-assess items",
    "",
    "| Item | Missing information | Why it is needed |",
    "|---|---|---|",
    "| ... | ... | ... |",
    "",
    "If none:",
    "No Cannot-assess items were identified.",
    "",
    "## 8. AI assumption risks",
    "",
    "| ID | Possible AI assumption | Risk | Prevention |",
    "|---|---|---|---|",
    "| A-001 | ... | ... | ... |",
    "",
    "If none:",
    "No major AI assumption risks were identified.",
    "",
    "## 9. Required clarification questions",
    "",
    "1. ...",
    "2. ...",
    "3. ...",
    "",
    "If none:",
    "No clarification questions are required before the requested next step.",
    "",
    "## 10. Recommended next actions",
    "",
    "1. ...",
    "2. ...",
    "3. ...",
    "",
    "## 11. Quick assessment",
    "",
    paste0("### 11.", seq_along(domains), " ", domains),
    "",
    "Assessment:",
    "- ...",
    "",
    "## 12. Handoff to next workflow step",
    "",
    "Next recommended step:",
    "- ...",
    "",
    "Information to pass forward:",
    "- ...",
    "",
    "Unresolved issues to carry forward:",
    "- ...",
    "",
    "Suggested next prompt:",
    "- ...",
    "```"
  )
}

common_quick_qc_sections <- function() {
  c(
    "## Domain status",
    "",
    "Use the following status categories for each domain.",
    "",
    "| Status | Meaning |",
    "|---|---|",
    "| OK | Clear enough for the requested next step |",
    "| Needs clarification | Some clarification is needed, but the issue is limited |",
    "| Problem | Important ambiguity, inconsistency, or missing information may affect the next step |",
    "| Cannot assess | Required information is missing |",
    "| Not applicable | This domain is not relevant to the task |",
    "",
    "A domain marked `Problem` or `Cannot assess` should usually produce an Issue, a Cannot-assess item, or an AI assumption risk.",
    "",
    "## Overall judgment categories",
    "",
    "Provide one of the following overall judgments.",
    "",
    "- `Pass`: no Critical or Major issues were identified, and the key domains needed for the requested next step are `OK` or only have minor clarification needs.",
    "- `Conditional pass`: the materials are mostly usable, but limited clarification or minor correction is needed before or during the next step.",
    "- `Revision required`: important information is missing, ambiguous, inconsistent, or insufficiently implementable.",
    "- `Fail`: proceeding would likely produce incorrect, misleading, or non-reproducible work.",
    "- `Cannot assess`: the supplied materials are too limited to evaluate.",
    "",
    "## Readiness categories",
    "",
    "| Readiness | Meaning |",
    "|---|---|",
    "| Ready | Clear enough for this next step |",
    "| Mostly ready | The next step can probably proceed after limited clarification |",
    "| Partially ready | Some work can proceed, but important clarification is needed |",
    "| Not ready | The next step should not proceed without clarification or revision |",
    "| Cannot assess | The supplied materials are insufficient to judge readiness |",
    "| Not applicable | The next step is not relevant to the task |",
    "",
    "Only include relevant next steps. Omit clearly irrelevant steps.",
    "",
    "## Severity classification",
    "",
    "- `Critical`: the requested next step should not proceed because AI would have to make unsafe assumptions or the result may be wrong, misleading, or uninterpretable.",
    "- `Major`: clarify or correct before reliable R code generation, analysis execution, reporting, or interpretation.",
    "- `Minor`: correct when convenient; unlikely to invalidate the requested next step.",
    "- `Note`: caution, limitation, or helpful observation.",
    "",
    "## Judgment rules",
    "",
    "- If one or more Critical issues are present, the relevant next step should usually be `Not ready`, `Cannot assess`, `Revision required`, or `Fail`.",
    "- If one or more Major issues are present, the relevant next step should usually be `Partially ready`, `Not ready`, or `Revision required`.",
    "- If only Minor issues are present, use `Conditional pass` or `Mostly ready`.",
    "- If only Notes are present, `Pass` may be appropriate.",
    "- If essential information is missing, use `Cannot assess` rather than guessing.",
    "- Issue severity overrides an otherwise favorable impression.",
    "- Do not use numeric scoring.",
    "",
    "## Evidence rule",
    "",
    "In the `Evidence` column, cite the supplied material whenever possible.",
    "",
    "Use section names, table names, variable names, output labels, file names, short quoted phrases, codebook entries, user-provided wording, R warnings, or R code labels.",
    "",
    "If the issue is caused by missing material, state that directly.",
    "",
    "Avoid vague evidence such as `unclear`, `not enough information`, or `seems missing`. Explain what is unclear and which supplied material is missing.",
    "",
    "## AI assumption risk",
    "",
    "Always identify likely assumptions AI might make from incomplete materials.",
    "",
    "For each risk, state:",
    "",
    "- possible assumption",
    "- why it matters",
    "- how to prevent it"
  )
}

context_qc_skill_template <- function() {
  domains <- c(
    "Purpose clarity",
    "Dataset clarity",
    "Population or analysis unit clarity",
    "Variable clarity",
    "Method clarity",
    "Output clarity"
  )
  c(
    "# CONTEXT-QC-SKILL.md",
    "",
    "## Purpose",
    "",
    "This skill performs a lightweight quality check of the context supplied for an analysis task.",
    "",
    "The central question is:",
    "",
    "> Is the supplied context clear enough for AI to perform the requested next step without making unsafe or hidden assumptions?",
    "",
    "## Scope",
    "",
    "Use this skill before asking AI to perform common analysis tasks, including survey summaries, descriptive statistics, cross-tabulations, simple plots, group comparisons, model preparation, R script generation, analysis result review, and report writing.",
    "",
    "This skill does not replace human statistical review, formal SAP review, regulatory review, or human accountability.",
    "",
    "## Quick QC limitation",
    "",
    "`Pass` means no obvious blocking issue was identified from the provided materials in this lightweight review. It does not certify correctness, optimality, reproducibility, or formal approval.",
    "",
    "If information is missing, state what cannot be assessed. Do not infer missing information.",
    "",
    "## Minimum inputs",
    "",
    "| Input | Purpose |",
    "|---|---|",
    "| Task request | What the user wants AI to do |",
    "| Dataset information | Which data should be used and what one row represents |",
    "| Variable information | Variable names, labels, coding, missing values |",
    "| Target population or records | Who or what should be included |",
    "| Method or summary request | Counts, percentages, tests, models, plots, etc. |",
    "| Output requirements | Table, figure, R script, report, file format |",
    "| Constraints | Packages, file paths, language, reproducibility requirements |",
    "",
    "## Core checks",
    "",
    "| Domain | Main question |",
    "|---|---|",
    "| Purpose clarity | Is the goal of the analysis clear? |",
    "| Dataset clarity | Is the dataset and row unit clear? |",
    "| Population or analysis unit clarity | Is it clear who or what should be analyzed? |",
    "| Variable clarity | Are required variables, labels, codes, and missing values clear? |",
    "| Method clarity | Is the requested summary, test, model, or plot clear enough? |",
    "| Output clarity | Is the expected output clear? |",
    "",
    "Do not assign a numeric score. Use domain status, issue severity, and next-step readiness instead.",
    "",
    common_quick_qc_sections(),
    "",
    common_qc_report_template(
      skill_name = "context-qc",
      workflow_stage = "Context QC",
      domains = domains,
      next_steps = c("Context clarification", "Analysis plan drafting", "R script generation", "Analysis execution", "Result QC", "Report writing")
    ),
    "",
    "## Check details",
    "",
    "### Purpose clarity",
    "",
    "Check what the user wants to learn or produce, whether the task is descriptive, comparative, modeling, exploratory, or reporting-oriented, and whether the main grouping or comparison is clear.",
    "",
    "### Dataset clarity",
    "",
    "Check the dataset name or file, data format, row unit, multiple datasets, linking keys, repeated records, and approximate size when relevant.",
    "",
    "### Population or analysis unit clarity",
    "",
    "Check inclusion and exclusion rules, complete-record rules, duplicate handling, group definitions, and whether the analysis unit matches the row unit.",
    "",
    "### Variable clarity",
    "",
    "Check variable names, labels, types, category codes, missing value codes, outcome variables, grouping variables, filter variables, covariates, dates, derived variables, and units.",
    "",
    "### Method clarity",
    "",
    "Check whether the requested method or analysis approach is clear enough. The user does not always need to name the method if the task is simple and the method is obvious from the request.",
    "",
    "### Output clarity",
    "",
    "Check table, figure, R script, report, interpretation text, table structure, figure type, denominator, missing category display, decimal places, output format, output language, and save location when needed.",
    "",
    "## Behavior rules",
    "",
    "- Do not invent missing context.",
    "- Keep the review lightweight.",
    "- Assess clarity, not sophistication.",
    "- Treat variables as central.",
    "- Use task-specific readiness.",
    "- Use conservative readiness.",
    "",
    "## Suggested invocation prompt",
    "",
    "```text",
    "You are performing a lightweight Analysis Context QC review.",
    "",
    "Evaluate whether the supplied context is clear enough for the requested AI-assisted analysis task.",
    "",
    "Focus on purpose clarity, dataset clarity, population or analysis unit clarity, variable clarity, method clarity, output clarity, and AI assumption risks.",
    "",
    "Use the compact AI & R QC Report format. Do not assign a numeric score. Classify issues as Critical, Major, Minor, or Note. Do not infer missing information. State what cannot be assessed. Use domain status instead of scores. Recommend the next action and include a handoff to the next workflow step.",
    "```",
    "",
    "## Design intent for AI & R workflow",
    "",
    "This skill is the lightweight entry gate for AI-assisted analysis. Its operational question is: given this context, what can AI safely do next?"
  )
}

plan_qc_skill_template <- function() {
  domains <- c(
    "Objective clarity",
    "Population and analysis unit clarity",
    "Endpoint, outcome, and variable clarity",
    "Method clarity",
    "Output clarity",
    "R implementation readiness"
  )
  c(
    "# PLAN-QC-SKILL.md",
    "",
    "## Purpose",
    "",
    "This skill performs a lightweight quality check of a Statistical Analysis Plan, analysis plan, or lightweight analysis specification in an AI & R workflow.",
    "",
    "The central question is:",
    "",
    "> Is this plan clear enough that AI can generate or review R code without making unsafe or hidden assumptions?",
    "",
    "## Scope",
    "",
    "Use this skill to evaluate simple survey analysis plans, descriptive analysis plans, cross-tabulation plans, group comparison plans, regression analysis plans, survival analysis plans, clinical or epidemiologic SAP drafts, real-world data or registry analysis plans, exploratory analysis plans, and sensitivity or subgroup analysis plans.",
    "",
    "This skill does not replace human statistical review, final SAP approval, regulatory review, or clinical interpretation.",
    "",
    "## Quick QC limitation",
    "",
    "`Pass` means no obvious blocking issue was identified from the provided materials in this lightweight review. It does not certify that the plan is statistically optimal, formally approved, validated, or ready for final scientific use without human review.",
    "",
    "If information is missing, state what cannot be assessed. Do not infer missing information.",
    "",
    "## Minimum inputs",
    "",
    "| Input | Purpose |",
    "|---|---|",
    "| SAP or analysis plan | The plan to be reviewed |",
    "| Study or project context | What the analysis is about |",
    "| Analysis objective | What should be estimated, compared, described, or tested |",
    "| Dataset information | Which data will be used and what one row represents |",
    "| Variable information | Variable names, labels, coding, missing values |",
    "| Output requirements | Tables, figures, estimates, scripts, reports |",
    "| Constraints | R packages, file paths, reporting rules, reproducibility requirements |",
    "",
    "## Core checks",
    "",
    "| Domain | Main question |",
    "|---|---|",
    "| Objective clarity | Is the analysis goal clear? |",
    "| Population and analysis unit clarity | Is it clear who or what should be analyzed? |",
    "| Endpoint, outcome, and variable clarity | Are required variables, endpoints, outcomes, codes, and derived variables clear? |",
    "| Method clarity | Is the planned summary, test, model, or estimation method clear enough? |",
    "| Output clarity | Are expected tables, figures, estimates, and formats clear? |",
    "| R implementation readiness | Can R code be written without guessing? |",
    "",
    "Do not assign a numeric score. Use domain status, issue severity, and next-step readiness instead.",
    "",
    common_quick_qc_sections(),
    "",
    common_qc_report_template(
      skill_name = "plan-qc",
      workflow_stage = "Plan QC",
      domains = domains,
      next_steps = c("Plan revision", "R script generation", "R script QC", "Analysis execution", "Result QC", "Report writing")
    ),
    "",
    "## Check details",
    "",
    "### Objective clarity",
    "",
    "Check the main analysis purpose, task type, main comparison, primary versus secondary goals, time point or follow-up period, and intended interpretation or use.",
    "",
    "### Population and analysis unit clarity",
    "",
    "Check target population or records, inclusion and exclusion criteria, analysis unit, row unit, duplicate handling, complete-case or valid-response rules, group assignment rules, and subgroup definitions.",
    "",
    "### Endpoint, outcome, and variable clarity",
    "",
    "Check endpoint or outcome definition, grouping variables, exposure or treatment variables, covariates, stratification variables, filter variables, variable names, labels, category codes, missing value codes, derived variable rules, date variables, units, baseline definition, event definition, censoring definition, and competing event definitions when relevant.",
    "",
    "### Method clarity",
    "",
    "Check counts, percentages, summary statistics, cross-tabulations, plots, tests, regression models, survival analysis, competing risk analysis, adjustment variables, stratification, sensitivity analyses, subgroup analyses, missing-data handling, confidence intervals, p-values, reference category, and diagnostics when relevant.",
    "",
    "### Output clarity",
    "",
    "Check table types, figure types, model output, estimates, confidence intervals, p-values, denominators, missing category display, decimal places, output language, output file format, titles, save location, and report text requirements.",
    "",
    "### R implementation readiness",
    "",
    "Check whether the dataset, row unit, target records, variables, category codes, missing values, derived variables, models, outputs, file paths, and package constraints are clear enough for R code generation without guessing.",
    "",
    "## Behavior rules",
    "",
    "- Do not invent missing plan details.",
    "- Keep the review lightweight.",
    "- Assess clarity and implementability, not document polish.",
    "- Treat variables and implementation readiness as central.",
    "- Use task-specific readiness.",
    "- Use conservative readiness.",
    "",
    "## Suggested invocation prompt",
    "",
    "```text",
    "You are performing a lightweight Plan QC review.",
    "",
    "Evaluate whether the supplied SAP or analysis plan is clear enough for the requested AI-assisted analysis workflow.",
    "",
    "Focus on objective clarity, population and analysis unit clarity, endpoint/outcome/variable clarity, method clarity, output clarity, R implementation readiness, and AI assumption risks.",
    "",
    "Use the compact AI & R QC Report format. Do not assign a numeric score. Classify issues as Critical, Major, Minor, or Note. Do not infer missing information. State what cannot be assessed. Use domain status instead of scores. Recommend the next action and include a handoff to the next workflow step.",
    "```",
    "",
    "## Clinical/statistical caution",
    "",
    "For clinical, causal, time-to-event, competing-risk, or regulatory analyses, check whether estimand, intercurrent events, competing risks, and missing data require formal human review.",
    "",
    "## Design intent for AI & R workflow",
    "",
    "This skill is used after context QC and before R script generation or analysis execution. Its operational question is: given this plan, what can AI safely do next?"
  )
}

result_qc_skill_template <- function() {
  domains <- c(
    "Planned-output alignment",
    "Numerical consistency",
    "Code and log consistency",
    "Table and figure clarity",
    "Interpretation safety",
    "Traceability and missing information"
  )
  c(
    "# RESULT-QC-SKILL.md",
    "",
    "## Purpose",
    "",
    "This skill performs a lightweight quality check of analysis results in an AI & R workflow.",
    "",
    "The central question is:",
    "",
    "> Are these analysis results clear and consistent enough that AI or a human reviewer can use them without making unsafe or hidden assumptions?",
    "",
    "## Scope",
    "",
    "Use this skill to evaluate descriptive tables, cross-tabulations, summary statistics, figures, model outputs, survival or time-to-event summaries, competing risk summaries, R console outputs, R Markdown or Quarto outputs, draft result sections, and AI-generated interpretations of analysis results.",
    "",
    "This skill does not replace independent statistical validation, source data verification, final manuscript review, regulatory review, or human accountability.",
    "",
    "## Quick QC limitation",
    "",
    "`Pass` means no obvious blocking issue was identified from the provided materials in this lightweight review. It does not certify that the result is independently validated, reproducible from raw data, generated by error-free code, or ready for final scientific use without human review.",
    "",
    "If information is missing, state what cannot be assessed. Do not infer missing information.",
    "",
    "## Minimum inputs",
    "",
    "| Input | Purpose |",
    "|---|---|",
    "| Analysis result | Tables, figures, estimates, outputs, or result text to be reviewed |",
    "| SAP or analysis plan | What results were planned or expected |",
    "| R script | How the results were generated |",
    "| R execution log | Warnings, errors, package versions, and execution status |",
    "| Dataset information | Row unit, target population, variables, coding, missing values |",
    "| Prior context QC or plan QC | Known unresolved issues |",
    "| Output requirements | Required table shells, figure requirements, report format |",
    "| Interpretation text | Claims or explanation based on results |",
    "",
    "## Core checks",
    "",
    "| Domain | Main question |",
    "|---|---|",
    "| Planned-output alignment | Do the results match the planned analysis or requested output? |",
    "| Numerical consistency | Are numbers, denominators, percentages, estimates, and labels internally consistent? |",
    "| Code and log consistency | Are the results consistent with the R script and execution log, if provided? |",
    "| Table and figure clarity | Are tables and figures readable, labeled, and interpretable? |",
    "| Interpretation safety | Are result claims appropriately cautious and supported by the outputs? |",
    "| Traceability and missing information | Can the result be traced to data, code, plan, and assumptions? |",
    "",
    "Do not assign a numeric score. Use domain status, issue severity, and next-step readiness instead.",
    "",
    common_quick_qc_sections(),
    "",
    common_qc_report_template(
      skill_name = "result-qc",
      workflow_stage = "Analysis Result QC",
      domains = domains,
      next_steps = c("Result correction", "R script review", "Analysis rerun", "Report writing", "Human statistical review")
    ),
    "",
    "## Check details",
    "",
    "### Planned-output alignment",
    "",
    "Check whether requested tables, figures, estimates, confidence intervals, p-values, subgroup analyses, sensitivity analyses, time points, populations, model terms, and outcome definitions are reflected in the results.",
    "",
    "### Numerical consistency",
    "",
    "Check group totals, denominators, numerators, percentages, missing counts, totals across rows and columns, estimates, standard errors, confidence intervals, p-values, event counts, person-time, time points, rounding, and labels.",
    "",
    "### Code and log consistency",
    "",
    "Check whether the R script produces the reported table or figure, whether dataset names, filters, variable definitions, grouping variables, model formulas, warnings, errors, seeds, versions, and output files are consistent with the result.",
    "",
    "### Table and figure clarity",
    "",
    "Check titles, population labels, denominators, row and column labels, units, time points, missing value display, footnotes, group labels, reference categories, axes, legends, confidence bands, captions, and abbreviation definitions.",
    "",
    "### Interpretation safety",
    "",
    "Check that claims match the displayed results, descriptive results are not overstated, associations are not described as causal without justification, non-significant results are not described as no effect, exploratory analyses are not described as confirmatory, and uncertainty is described appropriately.",
    "",
    "### Traceability and missing information",
    "",
    "Check whether the result can be traced to dataset identity, target population, variable definitions, analysis plan, R script, R log, session information, output file names, table shells, figure specifications, known limitations, and unresolved QC issues.",
    "",
    "## Behavior rules",
    "",
    "- Do not certify correctness from polished output.",
    "- Do not infer missing materials.",
    "- Keep the review lightweight.",
    "- Treat warnings and errors seriously.",
    "- Treat interpretation as part of QC.",
    "- Use task-specific readiness.",
    "- Use conservative readiness.",
    "",
    "## Suggested invocation prompt",
    "",
    "```text",
    "You are performing a lightweight Analysis Result QC review.",
    "",
    "Evaluate whether the supplied analysis results are clear, internally consistent, traceable, and safe enough for the requested next step.",
    "",
    "Focus on planned-output alignment, numerical consistency, code and log consistency, table and figure clarity, interpretation safety, traceability and missing information, and AI assumption risks.",
    "",
    "Use the compact AI & R QC Report format. Do not assign a numeric score. Classify issues as Critical, Major, Minor, or Note. Do not infer missing information. State what cannot be assessed. Use domain status instead of scores. Recommend the next action and include a handoff to the next workflow step.",
    "```",
    "",
    "## Return point guidance",
    "",
    "When an issue is found, state where the workflow should return: context clarification, plan revision, R script review, analysis rerun, result correction, report text revision, or human statistical review.",
    "",
    "## Design intent for AI & R workflow",
    "",
    "This skill is used after R script execution and before report writing or final human review. Its operational question is: given these results and materials, what can AI or a human reviewer safely do next?"
  )
}
